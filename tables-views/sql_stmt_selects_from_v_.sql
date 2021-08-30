create or replace view sql_stmt_selects_from_v_ as
select
--
-- The final underscore in the view name indicates that
-- another view will select from this view:
--
   object_owner,
   object_name,
   sql_id,
   usr_plan,
   plan_id,
   plan_r
from
   sql_stmt_plan_step_v
where
   operation in ('INDEX', 'TABLE ACCESS')
group by
   object_owner,
   object_name,
   sql_id,
   usr_plan,
   plan_id,
   plan_r
;
