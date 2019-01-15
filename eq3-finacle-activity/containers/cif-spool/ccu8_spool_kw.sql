-- File Name		: cu8crop.sql
-- File Created for	: Creation of source table
-- Created By		: Kumaresan.B
-- Client		    : Emirates Islamic Bank
-- Created On		: 26-05-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 800
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/cifkw/CC008.txt
select
trim(CORP_KEY)||'|'||
trim(PHONEEMAILTYPE)||'|'||
trim(PHONEOREMAIL)||'|'||
trim(PHONE_NO)||'|'||
trim(PHONENOLOCALCODE)||'|'||
trim(PHONENOCITYCODE)||'|'||
trim(PHONENOCOUNTRYCODE)||'|'||
trim(WORKEXTENSION)||'|'||
trim(EMAIL)||'|'||
trim(EMAILPALM)||'|'||
trim(URL)||'|'||
trim(PREFERRED_FLAG)||'|'||
trim(Start_Date)||'|'||
trim(End_Date)||'|'||
trim(USERFIELD1)||'|'||
trim(USERFIELD2)||'|'||
trim(USERFIELD3)||'|'||
trim(DATE1)||'|'||
trim(DATE2)||'|'||
trim(DATE3)||'|'||
trim(BANK_ID)
from CU8CORP_O_TABLE;
exit;
 
 