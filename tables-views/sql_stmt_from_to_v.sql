create or replace view sql_stmt_from_to_v as
select
--
--  Combine
--     sql_stmt_v and
--     sql_stmt_selects_from_v
--  to see which table an sql statement inserts to
--  and where it gets the data from.
--
--  stmt.name,
    plan.inserted_table_owner                    inserted_table_owner,
    plan.inserted_table_name                     inserted_table_name,
    from_.table_owner                            selected_object_owner,
    from_.table_name                             selected_object_name,
    plan.usr_plan,
    plan.r                                       plan_r,
    plan.id                                      plan_id,
    plan.sql_id
from
    sql_stmt_plan_v              plan join
    sql_stmt_selects_from_v      from_ on plan.sql_id = from_.sql_id and
                                          plan.r      = from_.plan_r
;
