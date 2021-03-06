--------------------------------------------------------
--  File created - �����������-������-30-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table FOREIGN_CURRENCY_MARKET
--------------------------------------------------------

  CREATE TABLE "USER_MARKELOV"."FOREIGN_CURRENCY_MARKET" 
   (	"ON_DATE" DATE, 
	"VALUTA_ID" VARCHAR2(20 BYTE), 
	"NUMCODE" NUMBER(10,0), 
	"CHARCODE" VARCHAR2(10 BYTE), 
	"NOMINAL" NUMBER(10,0), 
	"NAME" VARCHAR2(100 BYTE), 
	"VALUE" NUMBER(12,6)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index FOREIGN_CURRENCY_MARKET_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "USER_MARKELOV"."FOREIGN_CURRENCY_MARKET_PK" ON "USER_MARKELOV"."FOREIGN_CURRENCY_MARKET" ("ON_DATE", "VALUTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index FOREIGN_CURRENCY_MARKET_DATE_CHARCODE
--------------------------------------------------------

  CREATE INDEX "USER_MARKELOV"."FOREIGN_CURRENCY_MARKET_DATE_CHARCODE" ON "USER_MARKELOV"."FOREIGN_CURRENCY_MARKET" ("ON_DATE", "CHARCODE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table FOREIGN_CURRENCY_MARKET
--------------------------------------------------------

  ALTER TABLE "USER_MARKELOV"."FOREIGN_CURRENCY_MARKET" MODIFY ("ON_DATE" NOT NULL ENABLE);
  ALTER TABLE "USER_MARKELOV"."FOREIGN_CURRENCY_MARKET" MODIFY ("VALUTA_ID" NOT NULL ENABLE);
  ALTER TABLE "USER_MARKELOV"."FOREIGN_CURRENCY_MARKET" ADD CONSTRAINT "FOREIGN_CURRENCY_MARKET_PK" PRIMARY KEY ("ON_DATE", "VALUTA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table FOREIGN_CURRENCY_MARKET
--------------------------------------------------------

  ALTER TABLE "USER_MARKELOV"."FOREIGN_CURRENCY_MARKET" ADD CONSTRAINT "FOREIGN_CURRENCY_MARKET_VALUTA_ID_FK_FOREIGN_CURRENCY_MARKET_LIB_VALUTA_ID" FOREIGN KEY ("VALUTA_ID")
	  REFERENCES "USER_MARKELOV"."FOREIGN_CURRENCY_MARKET_LIB" ("VALUTA_ID") ENABLE;
