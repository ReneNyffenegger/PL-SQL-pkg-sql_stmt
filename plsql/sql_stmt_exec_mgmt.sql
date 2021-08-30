create or replace package  sql_stmt_exec_mgmt
    authid current_user
as

    function exec_immediate( stmt               clob)
    return   sql_stmt_mgmt.exec_res_t;

    function  exec(sql_id sql_stmt_mgmt.sql_id_t)
    return    sql_stmt_mgmt.exec_res_t;

    function  explain_plan (sql_id sql_stmt_mgmt.sql_id_t)
    return    integer;

end sql_stmt_exec_mgmt;
/
