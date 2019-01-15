-- File Name		: custom_freetext_spool.sql
-- File Created for	: Upload file for freetext
-- Created By		: Sharanappa
-- Client		    : ABK
-- Created On		: 06-06-2017
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/custom/freetext.txt
select 
ACID||
FREE_TEXT_1||
FREE_TEXT_2||
FREE_TEXT_3||
FREE_TEXT_4||
FREE_TEXT_5||
FREE_TEXT_6||
FREE_TEXT_7||
FREE_TEXT_8||
FREE_TEXT_9||
FREE_TEXT_10||
FREE_TEXT_11||
FREE_TEXT_12||
FREE_TEXT_13||
FREE_TEXT_14||
FREE_TEXT_15
from FREETEXT_O_TABLE;
exit;
 
