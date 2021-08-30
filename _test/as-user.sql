connect PLSQL_PKG_OWNER/PLSQL_PKG_OWNER_PW

create table tq84_sql_stmt_tst_as_user_src (
   who_am_i  varchar2(30)
);

insert into tq84_sql_stmt_tst_as_user_src values (user);

create table tq84_sql_stmt_tst_as_user_dest (
   who_am_i  varchar2(30),
   usr       varchar2(30),
   dt        date
);


declare

   sql_id sql_stmt_mgmt.sql_id_t;
   res    sql_stmt_mgmt.exec_res_t;

begin

    task_mgmt.begin_('TEST: try to execute an SQL statement as ' || user);

    sql_id := sql_stmt_mgmt.add ('insert into tq84_sql_stmt_tst_as_user_dest
    select
       who_am_i,
       user,
       sysdate
    from
       tq84_sql_stmt_tst_as_user_src
    ');

    res := sql_stmt_exec_mgmt.exec(sql_id => sql_id);

    dbms_output.put_line('  res.exec_id = ' || res.exec_id);

    task_mgmt.done;

end;
/

select * from sql_stmt_exec_v;

select * from tq84_sql_stmt_tst_as_user_dest;


connect PLSQL_PKG_USER/PLSQL_PKG_USER_PW

create table tq84_sql_stmt_tst_as_user_src (
   who_am_i  varchar2(30)
);

insert into tq84_sql_stmt_tst_as_user_src values (user);

create table tq84_sql_stmt_tst_as_user_dest (
   who_am_i  varchar2(30),
   usr       varchar2(30),
   dt        date
);

declare

   sql_id plsql_pkg_owner.sql_stmt_mgmt.sql_id_t;
   res    plsql_pkg_owner.sql_stmt_mgmt.exec_res_t;

begin

    plsql_pkg_owner.task_mgmt.begin_('TEST: try to execute an SQL statement as ' || user);

    sql_id := plsql_pkg_owner.sql_stmt_mgmt.add ('insert into tq84_sql_stmt_tst_as_user_dest
    select
       who_am_i,
       user,
       sysdate
    from
       tq84_sql_stmt_tst_as_user_src
    ');

    res := plsql_pkg_owner.sql_stmt_exec_mgmt.exec(sql_id => sql_id);

    dbms_output.put_line('  res.exec_id = ' || res.exec_id);

    plsql_pkg_owner.task_mgmt.done;

end;
/

select * from tq84_sql_stmt_tst_as_user_dest;
