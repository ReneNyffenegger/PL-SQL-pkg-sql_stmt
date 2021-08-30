create or replace view sql_stmt_exec_v as
select
   tsk.name                         task_name,
   stm.text                         stmt_text,
   tsk.usr,
   exc.start_,
   exc.end_,
   tim.to_s(exc.end_ - exc.start_)  duration_s,
   exc.row_cnt,
   exc.error,
   exc.sql_id,
   tsk.cur_task,
   tsk.cur_ses,
   tsk.cur_ses_r                    task_exec_cur_ses_r,
   tsk.usr_proxy,
   tsk.usr_os,
   tsk.sid,
   tsk.serial#,
   tsk.ses_id,
   exc.end_ - exc.start_            duration_,
   stm.force_matching_signature,
   exc.id        exec_id,
   tsk.id        task_exec_id
from
   sql_stmt_exec exc                                    join
   sql_stmt      stm on exc.sql_id       = stm.sql_id   join
   task_exec_v   tsk on exc.task_exec_id = tsk.id
;
