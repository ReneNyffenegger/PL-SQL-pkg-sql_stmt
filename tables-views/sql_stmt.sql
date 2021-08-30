create table sql_stmt (
   text                     clob               ,
   sql_id                   varchar2(13)       ,
   force_matching_signature number(20) not null,
   --
   constraint sql_stmt_pk   primary key (sql_id)
);
