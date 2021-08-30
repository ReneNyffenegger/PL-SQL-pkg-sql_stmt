create or replace package sql_stmt_mgmt
as

    subtype   sql_id_t         is varchar2(13);

 --
 -- Information about the execution
 -- of an SQL statement
 --
    type exec_res_t is record (
         exec_id     integer,
         row_cnt     integer,
         err_nr      integer       :=  0,
         err_msg     varchar2(500) := ''
    );

    function add(
         stmt clob
    )
    return sql_id_t;

    function stmt_text(sql_id varchar2) return clob;

--
--  ins_exec and upd_exec need to run as owner of the the table sql_stmt and sql_stmt_exec
--  hence, they're defined in sql_stmt_exec.
--  These functions are used from sql_stmt_exec_mgmt (with authid current_user)
--
    function  ins_exec(sql_id sql_id_t) return integer;

    procedure upd_exec(
          exec_id              integer,
          ts                   timestamp := null,
          row_cnt              integer   := null,
          err                  varchar2  := null);
 --
 -- The final underscore indicates that fill_stmt_plan_ is not
 -- supposed to be executed by 'the public'.
 --
    function  fill_stmt_plan_(
          sql_id               sql_id_t,
          plan_exec            exec_res_t,
          usr                  varchar2
    ) return integer;

end sql_stmt_mgmt;
/
