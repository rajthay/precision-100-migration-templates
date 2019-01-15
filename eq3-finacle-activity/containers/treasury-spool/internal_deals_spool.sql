-- File Name		: internal_deals_spool.sql
-- File Created for	: Creation of source table
-- Created By		: Sharanappa S
-- Client		    : ABK
-- Created On		: 27-04-2017
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/treasury/FX_ARB.dat
 SELECT rpad(trim(DEAL_IDENTIFIER),7,' ') ||','||
      rpad(trim(DEAL_DATE),11,' ') ||','||
      rpad(trim(START_DATE),11,' ') ||','||
      rpad(trim(END_DATE),11,' ') ||','||
      rpad(trim(CURRENCY_PAIR),7,' ') ||','||
      rpad(trim(BUY_SELL),4,' ') ||','||
      rpad(trim(NEAR_RATE),8,' ') ||','||
      rpad(trim(DEPO_BASIS),5,' ') ||','||
      rpad(trim(LOAN_BASIS),5,' ') ||','||
      rpad(trim(SPOTRATE),10,' ') ||','||
      rpad(trim(RIGHT_NEAR_VAL),12,' ') ||','||
      rpad(trim(LEFT_NEAR_VAL),12,' ') ||','||
      rpad(trim(LT_F_VAL),12,' ') ||','||
      rpad(trim(RT_F_VAL),13,' ') ||','||
      rpad(trim(FWD_CTRCT_RATE),7,' ') ||','||
      rpad(trim(DEPO_RATE),11,' ') ||','||
      rpad(trim(LOAN_RATE),11,' ')
 FROM INTERNAL_DEALS_O_TABLE;
exit;
--OLD MAPPING
-- SELECT rpad(trim(DEAL_IDENTIFIER),7,' ') ||
--      rpad(trim(DEAL_DATE),11,' ') ||
--      rpad(trim(START_DATE),11,' ') ||
--      rpad(trim(END_DATE),11,' ') ||
--      rpad(trim(CURRENCY_PAIR),7,' ') ||
--      rpad(trim(BUY_SELL),4,' ') ||
--      rpad(trim(SPOTRATE),10,' ') ||
--      rpad(trim(DEPO_BASIS),5,' ') ||
--      rpad(trim(LOAN_BASIS),5,' ') ||
--      rpad(trim(NEAR_RATE),10,' ') ||
--      rpad(trim(RIGHT_NEAR_VAL),12,' ') ||
--      rpad(trim(LEFT_NEAR_VAL),12,' ') ||
--      rpad(trim(LT_F_VAL),12,' ') ||
--      rpad(trim(RT_F_VAL),13,' ') ||
--      rpad(trim(FWD_CTRCT_RATE),7,' ') ||
--      rpad(trim(DEPO_RATE),11,' ') ||
--      rpad(trim(LOAN_RATE),11,' ')
-- FROM INTERNAL_DEALS_O_TABLE;
--LENGTH VALIDATION
-- SELECT max(length(trim(DEAL_IDENTIFIER))),
--      max(length(trim(DEAL_DATE))),
--      max(length(trim(START_DATE))),
--      max(length(trim(END_DATE))),
--      max(length(trim(CURRENCY_PAIR))),
--      max(length(trim(BUY_SELL))),
--      max(length(trim(NEAR_RATE))),
--      max(length(trim(DEPO_BASIS))),
--      max(length(trim(LOAN_BASIS))),
--      max(length(trim(SPOTRATE))),
--      max(length(trim(RIGHT_NEAR_VAL))),
--      max(length(trim(LEFT_NEAR_VAL))),
--      max(length(trim(LT_F_VAL))),
--      max(length(trim(RT_F_VAL))),
--      max(length(trim(FWD_CTRCT_RATE))),
--      max(length(trim(DEPO_RATE))),
--      max(length(trim(LOAN_RATE)))
-- FROM INTERNAL_DEALS_O_TABLE
 --select '7','11','11','11','7','4','8','5','5','10','12','12','12','13','7','11','11' from dual;
 
