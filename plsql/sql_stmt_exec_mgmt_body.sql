create or replace package  body sql_stmt_exec_mgmt
as

    function exec_ ( -- {
       sql_id  sql_stmt_mgmt.sql_id_t,
       stmt    clob
    )
    return sql_stmt_mgmt.exec_res_t
    is
       ret          sql_stmt_mgmt.exec_res_t;
    begin
       ret.exec_id := sql_stmt_mgmt.ins_exec(sql_id);

       execute immediate stmt;
       ret.row_cnt := sql%rowcount;

       sql_stmt_mgmt.upd_exec(ret.exec_id, ts => systimestamp, row_cnt => ret.row_cnt);

       return ret;

    exception when others then

       ret.err_nr  := sqlcode;
       ret.err_msg := sqlerrm;
       sql_stmt_mgmt.upd_exec(ret.exec_id, err => ret.err_msg);

       log_mgmt.exc(reraise => false);

       return  ret;

    end exec_; -- }

    function exec_immediate(stmt clob) return sql_stmt_mgmt.exec_res_t -- {
    is
       sql_id sql_stmt_mgmt.sql_id_t;
    begin

       sql_id := sql_stmt_mgmt.add(stmt);
       return  exec_(sql_id, stmt);

    exception when others then
        log_mgmt.exc;
    end exec_immediate; -- }

    function exec ( -- {
       sql_id          sql_stmt_mgmt.sql_id_t
    )
    return sql_stmt_mgmt.exec_res_t
    is

      stmt         clob;

    begin

       log_mgmt.msg('sql_id = ' || sql_id);

       stmt    := sql_stmt_mgmt.stmt_text(sql_id);
       return exec_(sql_id, stmt);

    exception when others then

       log_mgmt.exc;

    end exec; -- }

    function explain_plan ( -- {
       sql_id          sql_stmt_mgmt.sql_id_t
    )
    return integer
    is
       stmt_text clob;
       stmt      clob;

       exec_     sql_stmt_mgmt.exec_res_t;
    begin

       stmt  := sql_stmt_mgmt.stmt_text(sql_id);

       exec_ := exec_immediate('delete plan_table');

       if exec_.err_nr != 0 then
          raise_application_error(-20800, 'could not delete plan table', true);
       end if;

       stmt_text := 'explain plan for ';
       stmt_text :=  stmt_text || stmt;

       log_mgmt.msg('explain plan for ' || sql_id);
       exec_   := exec_immediate(stmt_text);
       log_mgmt.msg('err_nr = ' || exec_.err_nr || ', exec_id = ' || exec_.exec_id || ', error_msg = ' || exec_.err_msg);

       if exec_.err_nr != 0 then
          log_mgmt.msg('exec_id = ' || exec_.exec_id || ', unable to execute ' || stmt_text);
       end if;

       log_mgmt.msg('fill stmt plan');

       return sql_stmt_mgmt.fill_stmt_plan_(sql_id, exec_, user);
    exception when others then

       if sqlcode = -1039 then -- insufficient privileges on underlying objects of the view
          log_mgmt.msg('insufficient privileges on underlying object of the view');
          raise_application_error(-20800, 'insufficient privileges on underlying object of the view');
       end if;

       log_mgmt.exc;

    end explain_plan; -- }

end sql_stmt_exec_mgmt;
/
