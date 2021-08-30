create or replace package body sql_stmt_mgmt as

    function add( -- {
       stmt            clob
    ) return sql_id_t
    is pragma autonomous_transaction;
       sql_id      varchar2(13);
    begin

       if stmt is null then
          log_mgmt.msg('stmt is null, returning null');
          return null;
       end if;

       sql_id := dbms_sql_translator.sql_id(stmt);

       begin
          insert into sql_stmt (text, sql_id, force_matching_signature)
          values (stmt, sql_id, dbms_sqltune.sqltext_to_signature(stmt, force_match => 1));
          commit;
       exception when dup_val_on_index then
          rollback;
       end;

       return sql_id;
    exception when others then
        log_mgmt.exc('stmt = ' || stmt);
    end add; -- }

    function stmt_text(sql_id varchar2) return clob is -- {
       text clob;
    begin
       select
          s.text into stmt_text.text
       from
          sql_stmt s
       where
          s.sql_id = stmt_text.sql_id;

        return text;
    exception when no_data_found then
        log_mgmt.msg('No data found for sql_id = ' || sql_id);
    end stmt_text; -- }

    function ins_exec(sql_id sql_id_t) return integer is pragma autonomous_transaction; -- {
       exec_id integer;
    begin
       insert into sql_stmt_exec (sql_id, start_, task_exec_id) values (sql_id, systimestamp, task_mgmt.cur_task)
       returning id into exec_id;
       commit;

       return exec_id;
    end ins_exec; -- }

    procedure upd_exec( -- {
             exec_id integer,
             ts      timestamp := null,
             row_cnt integer   := null,
             err     varchar2  := null) is pragma autonomous_transaction;
    begin

        update sql_stmt_exec
        set
            end_    = upd_exec.ts     ,
            row_cnt = upd_exec.row_cnt,
            error   = upd_exec.err
        where
            id = exec_id;

        commit;

    end upd_exec; -- }

    function fill_stmt_plan_( -- {
          sql_id               sql_id_t,
          plan_exec            exec_res_t,
          usr                  varchar2
    )
    return integer
    is
           plan_id_ integer;
           sqlerrm_ varchar2(512);
    begin

       declare -- {
          op      sql_stmt_plan.stmt_type%type;
       begin

          if plan_exec.err_nr = 0  then -- {
             select operation into op from plan_table where id = 0;
          else
             op := 'error';
          end if; -- }

          insert into sql_stmt_plan ( -- {
             stmt_type,
             usr,
             exec_id,
             sql_id
          )
          values (
             op,
             usr,
             plan_exec.exec_id,
             sql_id
          )
          returning
              id  into plan_id_; -- }

          if plan_exec.err_nr != 0 then -- {
             log_mgmt.msg('returning -plan_id_');
             return -plan_id_;
          end if; -- }

          insert into sql_stmt_plan_step ( -- {
             step_id       ,
             parent_step_id,
             operation     ,
             options       ,
             object_owner  ,
             object_name   ,
             object_alias  ,
             qblock_name   ,
             depth         ,
             plan_id
          )
          select
             id          ,
             parent_id   ,
             operation   ,
             options     ,
             object_owner,
             object_name ,
             object_alias,
             qblock_name ,
             depth -1    , -- subtract 1 because depth seems to be 0 only for root-step which is not stored in sql_stmt_plan_step, but in sql_stmt_plan (where depth does not play any role)
             plan_id_
          from
             plan_table
          where
             id > 0; -- }

       end; -- }

       log_mgmt.msg('returning +plan_id_');
       return plan_id_;

       exception when others then
          log_mgmt.exc;
    end fill_stmt_plan_; -- }

end sql_stmt_mgmt;
/
