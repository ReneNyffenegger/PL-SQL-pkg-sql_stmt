create table sql_stmt_exec (
   start_        timestamp     not null,
   end_          timestamp,
   row_cnt       integer,
-- binds         any_t,
   error         varchar2(4000),
   sql_id        not null,
   task_exec_id  not null,
   id            integer  generated always as identity,
   --
   constraint sql_stmt_exec_pk        primary key (id          ),
   constraint sql_stmt_exec_fk_stmt   foreign key (sql_id      ) references sql_stmt,
   constraint sql_stmt_exec_fk_task   foreign key (task_exec_id) references task_exec
);
