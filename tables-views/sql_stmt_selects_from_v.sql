create or replace view sql_stmt_selects_from_v as
select
--
-- Because data can be selected via an index, but we want the
-- table that the index operates on, we need to collapse views
-- and tables into one object:
--
   coalesce(i.table_owner, v.object_owner) table_owner,
   coalesce(i.table_name , v.object_name ) table_name,
   v.sql_id,
   v.usr_plan,
   v.plan_id,
   v.plan_r
from
   sql_stmt_selects_from_v_  v                                 left join
   all_indexes               i on v.object_owner = i.owner and
                                  v.object_name  = i.index_name
group by
   coalesce(i.table_owner, v.object_owner),
   coalesce(i.table_name , v.object_name ),
   v.sql_id,
   v.usr_plan,
   v.plan_id,
   v.plan_r
;
