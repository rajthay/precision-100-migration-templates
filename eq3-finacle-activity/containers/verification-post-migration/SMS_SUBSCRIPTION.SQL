========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
SMS_SUBSCRIPTION.SQL 
select
lsms.CORP_ID LEG_CUST_ID,
fsmss.CORP_ID FIN_CUST_ID,
Case when (lsms.CORP_ID) = (fsmss.CORP_ID) then 'TRUE' else 'FALSE' end CUST_ID_MATCH,
lsms.ALRT_ACCT_ID LEG_ALERT_ACCOUNT,
fsmss.ALRT_ACCT_ID LEG_ALERT_ACCOUNT,
case when upper(trim(lsms.ALRT_ACCT_ID)) = upper(trim(fsmss.ALRT_ACCT_ID)) then 'TRUE' else 'FALSE' end ALERT_ACCOUNT_MATCH ,
upper(trim(lsms.ALERT_ID))  LEG_ALERT_ID, 
upper(trim(fsmss.ALERT_ID)) FIN_ALERT_ID,
case when upper(trim(lsms.ALERT_ID)) = upper(trim(fsmss.ALERT_ID)) then 'TRUE' else 'FALSE' end ALERT_ID_MATCH,
lsms.USER_CATEGORY_NAME LEG_CATEGORY_NAME,
fsmss.USER_CATEGORY_NAME LEG_CATEGORY_NAME, 
case when upper(trim(lsms.USER_CATEGORY_NAME)) = upper(trim(fsmss.USER_CATEGORY_NAME)) then 'TRUE' else 'FALSE' end CATEGORY_NAME_MATCH,
lsms.AMOUNT1 LEG_AMOUNT1,
fsmss.AMOUNT1 FIN_AMOUNT1,
case when (lsms.AMOUNT1) = (fsmss.AMOUNT1) then 'TRUE' else 'FALSE' end AMOUNT1_MATCH 
from SMS_ALERTS_SUB_O_TABLE lsms
left join (select * from alertuser.ault@dbread_alert where bank_id='01')fsmss on lsms.CORP_ID=fsmss.CORP_ID and upper(trim(lsms.ALRT_ACCT_ID)) = upper(trim(fsmss.ALRT_ACCT_ID))
and upper(trim(lsms.ALERT_ID)) = upper(trim(fsmss.ALERT_ID))
--select * from alertuser.ausm@dbread_alert  
