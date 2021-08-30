connect PLSQL_PKG_OWNER/PLSQL_PKG_OWNER_PW

prompt plsql/sql_stmt_mgmt
@      plsql/sql_stmt_mgmt

prompt plsql/sql_stmt_exec_mgmt
@      plsql/sql_stmt_exec_mgmt

prompt plsql/sql_stmt_txt
@      plsql/sql_stmt_txt

prompt tables-views/sql_stmt
@      tables-views/sql_stmt

prompt tables-views/sql_stmt_exec
@      tables-views/sql_stmt_exec

prompt tables-views/sql_stmt_exec_v
@      tables-views/sql_stmt_exec_v

prompt tables-views/sql_stmt_plan
@      tables-views/sql_stmt_plan

prompt tables-views/sql_stmt_plan_step
@      tables-views/sql_stmt_plan_step

prompt tables-views/sql_stmt_plan_v
@      tables-views/sql_stmt_plan_v

prompt tables-views/sql_stmt_plan_step_v
@      tables-views/sql_stmt_plan_step_v

prompt tables-views/sql_stmt_selects_from_v_
@      tables-views/sql_stmt_selects_from_v_

prompt tables-views/sql_stmt_selects_from_v
@      tables-views/sql_stmt_selects_from_v

prompt tables-views/sql_stmt_from_to_v
@      tables-views/sql_stmt_from_to_v

prompt plsql/sql_stmt_mgmt_body
@      plsql/sql_stmt_mgmt_body

prompt plsql/sql_stmt_exec_mgmt_body
@      plsql/sql_stmt_exec_mgmt_body

prompt plsql/sql_stmt_txt_body
@      plsql/sql_stmt_txt_body

grant execute on sql_stmt_mgmt      to plsql_pkg_user;
grant execute on sql_stmt_exec_mgmt to plsql_pkg_user;
