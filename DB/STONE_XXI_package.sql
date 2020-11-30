create or replace PACKAGE STONE_XXI AS 

  procedure FILL_CURRENCY_LIB;
  
  procedure FILL_CURRENCY;
  
  function GET_CURRENCY_ON_DATE(p_date in date, p_currency_charcode in varchar2) return number RESULT_CACHE;

END STONE_XXI;