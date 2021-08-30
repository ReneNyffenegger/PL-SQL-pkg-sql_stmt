create or replace view sql_stmt_plan_step_v as
select
--
-- Left join sql_stmt with sql_stmt_plan
-- to have the execution plan for every statement.
-- Additionally, indent the operation for easier
-- visual inspection.
--
   plan.stmt_type,
   plan.exec_error,
   lpad(' ', step.depth*2) || step.operation || case when step.options is not null then ' (' || step.options || ')' end operation_indented,
   case when object_name is not null then object_owner || '.' || object_name else object_alias       end object,
   step.operation,
   step.options,
   step.object_owner,
   step.object_name,
-- plan.object_alias,
   step.qblock_name,
   step.step_id         plan_step_id,  -- Use this to 'order by' result
   step.depth           plan_depth,    -- Use this to indent operation
   plan.usr_plan       ,
   plan.id              plan_id,
   plan.sql_id,
   plan.r               plan_r
from
   sql_stmt_plan_v     plan                                 left join
   sql_stmt_plan_step  step on plan.id     = step.plan_id
;
