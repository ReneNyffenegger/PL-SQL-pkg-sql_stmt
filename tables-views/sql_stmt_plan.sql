create table sql_stmt_plan (
   stmt_type /* operation  */   varchar2(  30)     null,
   usr               varchar2( 128) not null,
   sql_id            not null,
   exec_id           integer  not null,
   id                integer  generated always as identity,
   --
   constraint sql_stmt_plan_pk    primary key (id),
   constraint sql_stmt_plan_fk_s  foreign key (sql_id ) references sql_stmt,
   constraint sql_stmt_plan_fk_e  foreign key (exec_id) references sql_stmt_exec,
   constraint sql_stmt_plan_ck_op check (stmt_type in (
      'INSERT STATEMENT',
      'SELECT STATEMENT',
      'UPDATE STATEMENT',
      'DELETE STATEMENT',
      'CREATE TABLE STATEMENT',
      'error'
   ))
);

comment on column sql_stmt_plan.stmt_type is 'null if error';
comment on column sql_stmt_plan.exec_id   is 'The exec id of the ''explain plan'' statement.';
