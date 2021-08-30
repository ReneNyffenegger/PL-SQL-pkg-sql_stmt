declare
   id_create_table sql_stmt_mgmt.sql_id_t;
   id_fill         sql_stmt_mgmt.sql_id_t;
   id_drop_table   sql_stmt_mgmt.sql_id_t;

   res             sql_stmt_mgmt.exec_res_t;
begin

   task_mgmt.begin_('test sql_stmt');

   id_drop_table   := sql_stmt_mgmt.add('drop   table tq84_test_sql_stmt');
   id_create_table := sql_stmt_mgmt.add('create table tq84_test_sql_stmt(ts timestamp, object_name varchar2(128))');
   id_fill         := sql_stmt_mgmt.add('insert into  tq84_test_sql_stmt select systimestamp, object_name from all_objects');

   dbms_output.put_line('id_create_table = ' || id_create_table);
   dbms_output.put_line('id_fill =         ' || id_fill        );

   res := sql_stmt_exec_mgmt.exec(id_drop_table  );
   res := sql_stmt_exec_mgmt.exec(id_create_table);
   res := sql_stmt_exec_mgmt.exec(id_fill        );
   res := sql_stmt_exec_mgmt.exec(id_fill        );
   res := sql_stmt_exec_mgmt.exec(id_drop_table  );

   task_mgmt.done;

end;
/

select * from log_v where cur_ses_r    =  1 order by id desc;
select stmt_text, duration_s, row_cnt, error, sql_stmt_exec_v.* from sql_stmt_exec_v where task_exec_id = (select max(task_exec_id) from log_v where cur_ses_r  = 1) order by exec_id;
select * from task_exec_v where cur_ses_r    =  1;
