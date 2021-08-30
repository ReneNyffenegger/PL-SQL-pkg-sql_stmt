create or replace package body sql_stmt_txt as

   function extract_select_part(stmt clob) return clob is -- {
    --
    -- Remove text up to first  first occurence of 'select' or 'with' so
    -- as to get a select statement from an 'insert into ... ( ...) select ... from'
    -- statement.
    --
   begin

       return regexp_replace(stmt, '^.*?((\W|\A)(select|with)\W)', '\1', 1, 0, 'in');

   end extract_select_part; -- }

end sql_stmt_txt;
/
