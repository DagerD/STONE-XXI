create or replace PACKAGE BODY STONE_XXI AS

  procedure FILL_CURRENCY_LIB AS
    
    l_http_request_url varchar2(100):= 'http://www.cbr.ru/scripts/XML_valFull.asp';
    l_http_request   UTL_HTTP.req;
    l_http_response  UTL_HTTP.resp;
    l_clob           CLOB;
    l_text           VARCHAR2(32767);
    l_buffer         PLS_INTEGER:= 10000;
  BEGIN

    DBMS_LOB.createtemporary(l_clob, FALSE);
  
    l_http_request  := UTL_HTTP.begin_request(l_http_request_url);
    UTL_HTTP.SET_BODY_CHARSET(l_http_request, 'windows-1251');
  
    l_http_response := UTL_HTTP.get_response(l_http_request);
  
    BEGIN
      LOOP
        UTL_HTTP.read_text(l_http_response, l_text, l_buffer);
        DBMS_LOB.writeappend (l_clob, LENGTH(l_text), l_text);
      END LOOP;
    EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        UTL_HTTP.end_response(l_http_response);
    END;
    
    FOR l in (select a.table_name, a.constraint_name from all_constraints a
               inner join all_constraints ac on ac.table_name = 'FOREIGN_CURRENCY_MARKET_LIB' 
                                            and ac.owner = a.owner
                                            and ac.constraint_name = a.r_constraint_name
              ) LOOP

      execute immediate 'alter table ' || l.table_name || ' disable constraint ' || l.constraint_name;
      
    END LOOP;

    delete from FOREIGN_CURRENCY_MARKET_LIB;
    
    insert into FOREIGN_CURRENCY_MARKET_LIB (VALUTA_ID, NAME, ENGNAME, NOMINAL, PARENTCODE, ISO_NUM_CODE, ISO_CHAR_CODE)
    select Attribs.ID, Attribs.Name, Attribs.EngName, Attribs.Nominal, Attribs.ParentCode, Attribs.ISO_Num_Code, Attribs.ISO_Char_Code from 
      ( select xmltype(l_clob) xml from dual) xml_data
          , XMLTABLE('/Valuta'
              PASSING xml_data.xml
              COLUMNS
                Items xmltype PATH '/Valuta/Item'
          ) Items
          , XMLTABLE('/Item'
              PASSING Items.Items
              COLUMNS
                ID PATH '/Item/@ID'
                , Name PATH '/Item/Name'
                , EngName PATH '/Item/EngName'
                , Nominal PATH '/Item/Nominal'
                , ParentCode PATH '/Item/ParentCode'
                , ISO_Num_Code PATH '/Item/ISO_Num_Code'
                , ISO_Char_Code PATH '/Item/ISO_Char_Code'
          ) Attribs;
          
    commit;
    
    FOR l in (select a.table_name, a.constraint_name from all_constraints a
               inner join all_constraints ac on ac.table_name = 'FOREIGN_CURRENCY_MARKET_LIB' 
                                            and ac.owner = a.owner
                                            and ac.constraint_name = a.r_constraint_name
              ) LOOP
                                                                
      execute immediate 'alter table ' || l.table_name || ' enable constraint ' || l.constraint_name;
      
    END LOOP;
    
    DBMS_LOB.freetemporary(l_clob);
    
  EXCEPTION
    WHEN OTHERS THEN
      UTL_HTTP.end_response(l_http_response);
      DBMS_LOB.freetemporary(l_clob);
      rollback;
      
      FOR l in (select a.table_name, a.constraint_name from all_constraints a
                 inner join all_constraints ac on ac.table_name = 'FOREIGN_CURRENCY_MARKET_LIB' 
                                              and ac.owner = a.owner
                                              and ac.constraint_name = a.r_constraint_name
                ) LOOP
                                                                  
        execute immediate 'alter table ' || l.table_name || ' enable constraint ' || l.constraint_name;
        
      END LOOP;
    
      RAISE;
      
  END FILL_CURRENCY_LIB;
  
  procedure FILL_CURRENCY AS
  
    l_http_request_url varchar2(100):= 'http://www.cbr.ru/scripts/XML_daily.asp?date_req=';
    l_http_request   UTL_HTTP.req;
    l_http_response  UTL_HTTP.resp;
    l_clob           CLOB;
    l_text           VARCHAR2(32767);
    l_buffer         PLS_INTEGER := 10000;
    
  BEGIN
  
    DBMS_LOB.createtemporary(l_clob, FALSE);
    
    l_http_request_url:= l_http_request_url || sysdate;
    l_http_request  := UTL_HTTP.begin_request(l_http_request_url);
    UTL_HTTP.SET_BODY_CHARSET(l_http_request, 'windows-1251');
  
    l_http_response := UTL_HTTP.get_response(l_http_request);
  
    BEGIN
      LOOP
        UTL_HTTP.read_text(l_http_response, l_text, l_buffer);
        DBMS_LOB.writeappend (l_clob, LENGTH(l_text), l_text);
      END LOOP;
    EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        UTL_HTTP.end_response(l_http_response);
    END;
    
    delete from FOREIGN_CURRENCY_MARKET;
    
    insert into FOREIGN_CURRENCY_MARKET (ON_DATE, VALUTA_ID, NUMCODE, CHARCODE, NOMINAL, NAME, VALUE)
    select to_date(out_date), Attribs.ID, Attribs.NumCode, Attribs.CharCode, Attribs.Nominal, Attribs.Name, Attribs.Value from 
      ( select xmltype(l_clob) xml from dual) xml_data
          , XMLTABLE('/ValCurs'
              PASSING xml_data.xml
              COLUMNS
                out_date PATH '/ValCurs/@Date',
                Items xmltype PATH '/ValCurs/Valute'
          ) Items
          , XMLTABLE('/Valute'
              PASSING Items.Items
              COLUMNS
                ID PATH '/Valute/@ID'
                , NumCode PATH '/Valute/NumCode'
                , CharCode PATH '/Valute/CharCode'
                , Nominal PATH '/Valute/Nominal'
                , Name PATH '/Valute/Name'
                , Value PATH '/Valute/Value'
          ) Attribs;
          
    commit;
  
    DBMS_LOB.freetemporary(l_clob);
    
  EXCEPTION
    WHEN OTHERS THEN
      UTL_HTTP.end_response(l_http_response);
      DBMS_LOB.freetemporary(l_clob);
      rollback;
      RAISE;
      
  END FILL_CURRENCY;
  
  function GET_CURRENCY_ON_DATE(p_date in date, p_currency_charcode in varchar2) return number RESULT_CACHE as
  
    l_currency_value number(12,6);
  
  BEGIN
  
    select t.value into l_currency_value
      from FOREIGN_CURRENCY_MARKET t
     where t.on_date = p_date
       and t.charcode = p_currency_charcode;
       
    return l_currency_value;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
      
  END GET_CURRENCY_ON_DATE;
  

END STONE_XXI;