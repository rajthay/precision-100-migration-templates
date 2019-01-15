-- File Name		: int_rate_update_Spool.sql
-- File Created for	: Creation of source table
-- Created By		: Sreenivasa
-- Client		    : ABK
-- Created On		: 12-06-2016
-------------------------------------------------------------------
set head off
set feedback off   
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/laa/KW/int_rate_change_update.txt
select 
 ENTITY_ID ||
 ENTITY_TYPE ||
 START_DATE ||
 END_DATE ||
 INT_TBL_CODE ||
 CUST_CR_PREF_PCNT ||
 CUST_DR_PREF_PCNT ||
 ID_CR_PREF_PCNT ||
 ID_DR_PREF_PCNT ||
 PEGGED_FLG ||
 PEG_FREQUENCY_IN_MONTHS ||
 PEG_FREQUENCY_IN_DAYS ||
 MIN_INT_PCNT_CR ||
 MIN_INT_PCNT_DR ||
 MAX_INT_PCNT_CR ||
 MAX_INT_PCNT_DR ||
 AC_LEVEL_NRML_PCNT_DR ||
 AC_LEVEL_SPREAD ||
 AC_LEVEL_COMP_INT_PCNT ||
 AC_LEVEL_COMP_PRNC_PCNT ||
 AC_LEVEL_PEN_INT_PCNT_FOR_INT ||
 AC_LEVEL_PEN_INT_PCNT_FOR_PRNC ||
 AC_LEVEL_PENAL_PCNT_DR ||
 REASON_CODE ||
 COMPOUND_PRNC_PCNT ||
 PENALTY_INT_PCNT_FOR_PRNC ||
 PENALTY_INT_PCNT_FOR_INT ||
 CHNL_DR_PREF_PCNT ||
 CHNL_CR_PREF_PCNT ||
 NEGOTIATED_RATE_DR ||
 INT_VERSION ||
 INT_RATE_PRD_IN_MONTHS ||
 INT_RATE_PRD_IN_DAYS ||
 PEG_REVIEW_DATE ||
 REVIEW_REQD_ON_START_DATE ||
 INTERPOLATION_METHOD
 from int_rate_change_update;
 exit; 
