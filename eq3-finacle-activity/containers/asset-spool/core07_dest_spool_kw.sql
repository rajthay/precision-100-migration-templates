-- File Name		: spool CA1
-- File Created for	: Creation of source table
-- Created By		: Kumaresan.B
-- Client		    : Emirates Islamic Bank
-- Created On		: 26-05-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/core/KW/CORE007_DEST.txt
select INDICATOR||ACCOUNT_NUMBER||CURRENCY_CODE||BEGIN_CHEQUE_NUMBER||NUMBER_OF_CHEQUE_LEAVES||DATE_OF_ISSUE||CHEQUE_LEAF_STATUS||BEGIN_CHEQUE_ALPHA||DUMMY
from CBS_DEST_O_TABLE 
order by to_number(NUMBER_OF_CHEQUE_LEAVES) desc;
--inner join tbaadm.gam b on trim(account_number) = foracid
--left join  tbaadm.cbt c on b.acid = c.acid and to_number(begin_cheque_number) = begin_chq_num
--where c.acid is null order by to_number(NUMBER_OF_CHEQUE_LEAVES) desc
exit;
 
