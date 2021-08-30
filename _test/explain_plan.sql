create table tq84_explain_plan_test_1 (
   a number,
   b number
);

create table tq84_explain_plan_test_2 (
   c number,
   d number
);

create view tq84_explain_plan_test_v as
select
   one.a,
   one.b,
   two.*
from
   tq84_explain_plan_test_1 one  join
   tq84_explain_plan_test_2 two on one.a = two.c;


declare

   procedure do_stmt(x varchar2, stmt clob) is
      stmt_id  sql_stmt_mgmt.sql_id_t;
   begin

      dbms_output.put_line(x);
      log_mgmt.msg(x);
      stmt_id := sql_stmt_mgmt.add(stmt);
      dbms_output.put_line('  stmt id = ' || stmt_id);

      dbms_output.put_line('  plan id = ' || sql_stmt_exec_mgmt.explain_plan(stmt_id));
      dbms_output.put_line('  exec id = ' || sql_stmt_exec_mgmt.exec        (stmt_id).exec_id);

   end do_stmt;

begin

   task_mgmt.begin_('tests for sql_stmt: explain plan functionality');

   do_stmt('create table', q'[create table tq84_test_sql_stmt_table as select * from tq84_explain_plan_test_v where a in (1,2,3)]');
   do_stmt('insert into ', q'[insert into  tq84_test_sql_stmt_table    select * from tq84_explain_plan_test_v where b in (4,5,6)]');
   do_stmt('delete from ', q'[delete from  tq84_test_sql_stmt_table                                           where c in (7,8,9)]');
   do_stmt('update      ', q'[update       tq84_test_sql_stmt_table set d = null                              where d = 10      ]');



--
-- TODO: Statment drop table ... cannot be explained
   do_stmt('drop table  ', q'[drop   table tq84_test_sql_stmt_table                                                              ]');

   task_mgmt.done;
exception when others then
   task_mgmt.exc;
end;
/

select * from log_v where cur_ses_r = 1 order by id desc;

select * from sql_stmt_plan;

-- CREATE TABLE STATEMENT
select * from sql_stmt_plan        where sql_id = '4w20j43upbfmm';
select * from sql_stmt_plan_v      where sql_id = '4w20j43upbfmm';
select * from sql_stmt_plan_step   where plan_id = (select id from sql_stmt_plan where sql_id = '4w20j43upbfmm');
select * from sql_stmt_plan_step_v where sql_id = '4w20j43upbfmm';

-- INSERT STATEMENT
select * from sql_stmt_plan        where sql_id = '4tnbqnts21v6c';
select * from sql_stmt_plan_v      where sql_id = '4tnbqnts21v6c';
select * from sql_stmt_plan_step   where plan_id = (select id from sql_stmt_plan where sql_id = '4tnbqnts21v6c');
select * from sql_stmt_plan_step_v where sql_id = '4tnbqnts21v6c';

-- DELETE STATEMENT
select * from sql_stmt_plan        where sql_id = 'fjyn2s0qkac6m';
select * from sql_stmt_plan_v      where sql_id = 'fjyn2s0qkac6m';
select * from sql_stmt_plan_step   where plan_id = (select id from sql_stmt_plan where sql_id = 'fjyn2s0qkac6m');
select * from sql_stmt_plan_step_v where sql_id = 'fjyn2s0qkac6m';

-- UPDATE STATEMENT
select * from sql_stmt_plan        where sql_id = '3gvz3s6vmgadh';
select * from sql_stmt_plan_v      where sql_id = '3gvz3s6vmgadh';
select * from sql_stmt_plan_step   where plan_id = (select id from sql_stmt_plan where sql_id = '3gvz3s6vmgadh');
select * from sql_stmt_plan_step_v where sql_id = '3gvz3s6vmgadh';

-- error STATEMENT
select * from sql_stmt_plan        where sql_id = 'c1gp8bnyuxa20';
select * from sql_stmt_plan_v      where sql_id = 'c1gp8bnyuxa20';
select * from sql_stmt_plan_step   where plan_id = (select id from sql_stmt_plan where sql_id = 'c1gp8bnyuxa20');
select * from sql_stmt_plan_step_v where sql_id = 'c1gp8bnyuxa20';
