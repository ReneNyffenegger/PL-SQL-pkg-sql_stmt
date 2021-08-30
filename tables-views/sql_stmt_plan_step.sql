create table sql_stmt_plan_step (
   parent_step_id    number     null, -- Filled from plan_table.parent_id
   operation         varchar2 (30),
   options           varchar2(255),
   object_owner      varchar2(128),
   object_name       varchar2(128),
   object_alias      varchar2(261),
   qblock_name       varchar2(128),
   depth             integer,
   plan_id           not null,
   step_id           integer not null check (step_id > 0), -- Filled from plan_table.name
   --
   constraint sql_stmt_plan_step_pk primary key (plan_id, step_id),
   constraint sql_stmt_plan_step_fk foreign key (plan_id) references sql_stmt_plan
);
