connect plsql_pkg_owner/plsql_pkg_owner_pw

declare
   res  sql_stmt_mgmt.exec_res_t;
begin
   task_mgmt.begin_('test: exec_immediate');

   res := sql_stmt_exec_mgmt.exec_immediate('create table tq84_exec_immediate_test(a number, b varchar2(10))');
   log_mgmt.msg('res.exec_id = ' || res.exec_id || ', .row_cnt = ' || res.row_cnt || ', .err_nr = ' || res.err_nr || ', err_msg = ' || res.err_msg);
   res := sql_stmt_exec_mgmt.exec_immediate('drop   table tq84_exec_immediate_test purge'                    );

   task_mgmt.done;

exception when others then
   task_mgmt.exc;
end;
/

select * from log_v           where cur_ses_r    =  1;
select stmt_text, duration_s, row_cnt, error, sql_stmt_exec_v.* from sql_stmt_exec_v where task_exec_id = (select max(task_exec_id) from log_v where cur_ses_r  = 1) order by exec_id;
select * from task_exec_v     where cur_ses_r    =  1;
