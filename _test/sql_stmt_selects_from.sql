create table tq84_test_sql_stmt_tab_a (id number, val number);
create table tq84_test_sql_stmt_tab_b (id number, val number);
create table tq84_test_sql_stmt_tab_c (id number, val number);
create table tq84_test_sql_stmt_tab_d (id number, val number);

declare
   stmt_id  sql_stmt_mgmt.sql_id_t;
begin

   task_mgmt.begin_('test sql_stmt: add insert statement');

   stmt_id := sql_stmt_mgmt.add(q'[
   insert into tq84_test_sql_stmt_tab_d
   select
      sum(x + c.val),
      q_1.id
   from (
        select
           a.id,
           a.val + b.val as x
        from
           tq84_test_sql_stmt_tab_a a  join
           tq84_test_sql_stmt_tab_b b on a.id = b.id
   ) q_1                                              join
     tq84_test_sql_stmt_tab_c c on q_1.id = c.id
     group
        by q_1.id]');

   dbms_output.put_line('stmt_id = ' || stmt_id);
   dbms_output.put_line('  plan id = ' || sql_stmt_exec_mgmt.explain_plan(stmt_id));
   task_mgmt.done;
exception when others then
   task_mgmt.exc;
end;
/

-- select * from log_v where cur_ses_r = 1 order by id desc;

select * from sql_stmt_plan_v         where sql_id = 'cc4v1gvzgm7pr' /* id      = 1 */ and r = 1;
select * from sql_stmt_selects_from_v where sql_id = 'cc4v1gvzgm7pr' and plan_r = 1;
select * from sql_stmt_from_to_v      where sql_id = 'cc4v1gvzgm7pr' and plan_r = 1;
