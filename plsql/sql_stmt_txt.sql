create or replace package sql_stmt_txt as
--
-- Remove text up to first  first occurence of 'select' or 'with' so
-- as to get a select statement from an 'insert into ... ( ...) select ... from'
-- statement.
--
   function extract_select_part(stmt clob) return clob;

end sql_stmt_txt;
/
