create or replace view sql_stmt_plan_v as
select
   plan.stmt_type,
   plan.usr                        usr_plan,
   stmt.text                       stmt_text,
   exec.error                      exec_error,
   plan_insert.object_owner        inserted_table_owner,
   plan_insert.object_name         inserted_table_name ,
   exec.start_                     exec_start,
   exec.end_                       exec_end,
   stmt.sql_id                     sql_id,
   exec.force_matching_signature,
   plan.id,
   row_number() over (partition by stmt.sql_id, plan.usr order by exec.end_ desc nulls last) r
from
   sql_stmt              stmt                                          left join
   sql_stmt_plan         plan on stmt.sql_id       = plan.sql_id       left join
   sql_stmt_exec_v       exec on plan.exec_id      = exec.exec_id      left join
   sql_stmt_plan_step    plan_insert on plan.id = plan_insert.plan_id and
       (
           plan_insert.operation in ('LOAD TABLE CONVENTIONAL', 'LOAD AS SELECT')
            and not (plan_insert.operation = 'LOAD AS SELECT' and
                     plan_insert.options   = '(CURSOR DURATION MEMORY)'
                    )
       )
;
