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
spool $MIG_PATH/output/finacle/core/KW/CORE009.txt
select 
ACCOUNT_NUMBER||
LIEN_AMOUNT||
a.CRNCY_CODE||
a.LIEN_REASON_CODE||
a.LIEN_START_DATE||
a.LIEN_EXPIRY_DATE||
LIEN_TYPE||
ACCOUNT_ID||
SI_CERTIFICATE_NUMBER||
LIMIT_PREFIX||
LIMIT_SUFFIX||
DC_NUMBER||
BG_NUMBER||
a.SOL_ID||
a.LIEN_REMARKS||
a.REQUESTED_BY_DESC||
REQUESTED_DEPARTMENT||
a.CONTACT_NUM
from LIEN_O_TABLE a
--inner join tbaadm.gam on foracid=trim(account_number) and gam.bank_id='01'
--left join tbaadm.alt on alt.bank_id='01' and alt.acid=gam.acid and to_number(lien_amount)=alt.lien_amt+FUTURE_ULIEN_AMT and trim(USER_ID)='MIG3'  and to_date(a.LIEN_START_DATE,'DD-MM-YYYY')=alt.LIEN_START_DATE and trim(a.LIEN_REASON_CODE)=alt.LIEN_REASON_CODE and trim(a.LIEN_REMARKS)=alt.LIEN_REMARKS
--where alt.acid is null
order by trim(a.ACCOUNT_NUMBER),to_date(a.LIEN_START_DATE,'DD-MM-YYYY');
exit;
 
