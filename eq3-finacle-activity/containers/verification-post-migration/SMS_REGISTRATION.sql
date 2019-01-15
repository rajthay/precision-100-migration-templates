========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
SMS_REGISTRATION.sql 
SELECT 
l_smsal.CUST_ID LEG_CUST_ID,f_smsal.CUST_ID FIN_CUST_ID,Case when (l_smsal.CUST_ID) = (f_smsal.CUST_ID) then 'TRUE' else 'FALSE' end MATCH_CUST_ID,
l_smsal.CORP_ID LEG_CORP_ID,f_smsal.CORP_ID FIN_CORP_ID,Case when (l_smsal.CORP_ID) = (f_smsal.CORP_ID) then 'TRUE' else 'FALSE' end MATCH_CORP_ID,
l_smsal.RELATED_PARTY_ID LEG_RELATED_PARTY,f_smsal.RELATED_PARTY_ID FIN_RELATED_PARTY,Case when (l_smsal.RELATED_PARTY_ID) = (f_smsal.RELATED_PARTY_ID) then 'TRUE' else 'FALSE' end MATCH_RELATED_PARTY,
l_smsal.CUST_FIRST_NAME LEG_FIRST_NAME,f_smsal.CUST_FIRST_NAME FIN_FIRST_NAME,Case when upper(l_smsal.CUST_FIRST_NAME) = upper(f_smsal.CUST_FIRST_NAME) then 'TRUE' else 'FALSE' end MATCH_FIRST_NAME,
l_smsal.CUST_MID_NAME LEG_MID_NAME,f_smsal.CUST_MID_NAME FIN_MID_NAME,Case when upper(l_smsal.CUST_MID_NAME) = upper(f_smsal.CUST_MID_NAME) then 'TRUE' else 'FALSE' end MATCH_MID_NAME,
l_smsal.CUST_LAST_NAME LEG_LAST_NAME,f_smsal.CUST_LAST_NAME FIN_LAST_NAME,Case when upper(l_smsal.CUST_LAST_NAME) = upper(f_smsal.CUST_LAST_NAME) then 'TRUE' else 'FALSE' end MATCH_LAST_NAME,
l_smsal.C_MOBILE_NO LEG_MOBILE_NO,f_smsad.C_MOBILE_NO FIN_MOBILE_NO,case when (l_smsal.C_MOBILE_NO) = (f_smsad.C_MOBILE_NO) then 'TRUE' else 'FALSE' end MATCH_MOBILENO ,
l_smsal.PREF_TIME_ZONE LEG_SERVICE_PROVIDER,f_smsad.FREE_TEXT_1 FIN_SERVICE_PROVIDER,case when nvl(trim(l_smsal.PREF_TIME_ZONE),' ')= nvl(trim(f_smsad.FREE_TEXT_1),' ') then 'TRUE' else 'FALSE' end MATCH_SERVICE_PROVIDER ,
l_smsal.USER_CATEGORY_NAME USER_CATEGORY
FROM SMS_ALERTS_REG_O_TABLE l_smsal
left join (select * from alertuser.aurt@dbread_alert where bank_id='01')f_smsal on l_smsal.CUST_ID=f_smsal.CUST_ID and l_smsal.CORP_ID=f_smsal.CORP_ID
left join (select * from alertuser.alad@dbread_alert where bank_id='01')f_smsad on l_smsal.CUST_ID=f_smsad.CUST_ID and l_smsal.CORP_ID=f_smsad.CORP_ID 
