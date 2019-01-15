========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
corp_e-bank_user.sql 

--SET 1
select 
a.CUST_ID LEG_CIF_ID,b.CUST_ID FIN_CIF_ID,case when NVL(trim(a.CUST_ID),' ') = NVL(trim(b.CUST_ID),' ') then 'TRUE' ELSE 'FALSE' END MATCH_CIF_ID, 
a.CORP_USER LEG_USER_ID,b.USER_ID FIN_USER_ID,case when upper(NVL(trim(a.CORP_USER),' ')) = NVL(trim(b.USER_ID),' ') then 'TRUE' ELSE 'FALSE' END MATCH_USER_ID,
a.C_L_NAME LEG_LAST_NAME,b.C_L_NAME FIN_LAST_NAME ,case when NVL(trim(a.C_L_NAME),' ') = NVL(trim(b.C_L_NAME),' ') then 'TRUE' ELSE 'FALSE' END MATCH_LAST_NAME,
a.C_M_NAME LEG_MIDDLE_NAME,b.C_M_NAME FIN_MIDDLE_NAME,case when NVL(trim(a.C_M_NAME),' ') = NVL(trim(b.C_M_NAME),' ') then 'TRUE' ELSE 'FALSE' END MATCH_MIDDLE_NAME,
a.C_F_NAME LEG_FIRST_NAME,b.C_F_NAME FIN_FIRST_NAME,case when NVL(trim(a.C_F_NAME) ,' ')= NVL(trim(b.C_F_NAME),' ') then 'TRUE' ELSE 'FALSE' END MATCH_FIRST_NAME,
a.C_EMAIL_ID LEG_EMAIL_ID,b.C_EMAIL_ID FIN_EMAIL_ID,case when NVL(trim(a.C_EMAIL_ID),' ') = NVL(trim(b.C_EMAIL_ID),' ') then 'TRUE' ELSE 'FALSE' END MATCH_EMAIL_ID,
a.C_ADDR1 LEG_ADDRESS1,b.C_ADDR1 FIN_ADDRESS1,case when NVL(trim(a.C_ADDR1) ,' ')= NVL(trim(b.C_ADDR1),' ') then 'TRUE' ELSE 'FALSE' END MATCH_ADDRESS1,
a.C_ADDR2 LEG_ADDRESS2,b.C_ADDR2 FIN_ADDRESS2,case when NVL(trim(a.C_ADDR2),' ') = NVL(trim(b.C_ADDR2),' ') then 'TRUE' ELSE 'FALSE' END MATCH_ADDRESS2,
a.C_GENDER LEG_GENDER,b.C_GENDER FIN_GENDER,case when NVL(trim(a.C_GENDER),' ') = NVL(trim(b.C_GENDER),' ') then 'TRUE' ELSE 'FALSE' END MATCH_GENDER,
--a.DATE_OF_BIRTH LEG_DATE_OF_BIRTH,b.DATE_OF_BIRTH FIN_DATE_OF_BIRTH,case when NVL(a.DATE_OF_BIRTH,sysdate) = NVL(b.DATE_OF_BIRTH,sysdate) then 'TRUE' ELSE 'FALSE' END MATCH_DATE_OF_BIRTH,
a.PAN_NATIONAL_ID LEG_CIVIL_ID,b.PAN_NATIONAL_ID FIN_CIVIL_ID,case when NVL(trim(a.PAN_NATIONAL_ID),' ') = NVL(trim(b.PAN_NATIONAL_ID),' ') then 'TRUE' ELSE 'FALSE' END MATCH_CIVIL_ID
 from CORP_E_BANKING_USER_O_TABLE A
LEFT JOIN (
SELECT DISTINCT * FROM ECECUSER.CUSR@DBREAD_USER FIN_CUSR
inner JOIN ECECUSER.CSIP@DBREAD_USER FIN_CSIP ON trim(FIN_CSIP.INDIVIDUAL_ID) = trim(FIN_CUSR.INDIVIDUAL_ID)  
WHERE FIN_CSIP.CHANNEL_ID='I' and FIN_CUSR.DB_TS='1' AND FIN_CUSR.DB_TS='1' and FIN_CSIP.DB_TS='1'  AND FIN_CUSR.BANK_ID='01' and USER_ID not like 'SMS%'-- AND FIN_CSIP.DEL_FLG='N'
) B ON trim(A.CUST_ID) = trim(B.CUST_ID) and upper(NVL(trim(a.CORP_USER),' ')) = NVL(b.USER_ID,' ')



----SET 2
select 
a.CUST_ID LEG_CIF_ID,b.CUST_ID FIN_CIF_ID,case when NVL(a.CUST_ID,' ') = NVL(b.CUST_ID,' ') then 'TRUE' ELSE 'FALSE' END MATCH_CIF_ID, 
a.CORP_USER LEG_USER_ID,b.USER_ID FIN_USER_ID,case when upper(NVL(trim(a.CORP_USER),' ')) = NVL(b.USER_ID,' ') then 'TRUE' ELSE 'FALSE' END MATCH_USER_ID,
a.C_L_NAME LEG_LAST_NAME,b.C_L_NAME FIN_LAST_NAME ,case when NVL(trim(a.C_L_NAME),' ') = NVL(trim(b.C_L_NAME),' ') then 'TRUE' ELSE 'FALSE' END MATCH_LAST_NAME,
a.C_M_NAME LEG_MIDDLE_NAME,b.C_M_NAME FIN_MIDDLE_NAME,case when NVL(trim(a.C_M_NAME),' ') = NVL(trim(b.C_M_NAME),' ') then 'TRUE' ELSE 'FALSE' END MATCH_MIDDLE_NAME,
a.C_F_NAME LEG_FIRST_NAME,b.C_F_NAME FIN_FIRST_NAME,case when NVL(trim(a.C_F_NAME) ,' ')= NVL(trim(b.C_F_NAME),' ') then 'TRUE' ELSE 'FALSE' END MATCH_FIRST_NAME,
a.C_EMAIL_ID LEG_EMAIL_ID,b.C_EMAIL_ID FIN_EMAIL_ID,case when NVL(trim(a.C_EMAIL_ID),' ') = NVL(trim(b.C_EMAIL_ID),' ') then 'TRUE' ELSE 'FALSE' END MATCH_EMAIL_ID,
a.C_ADDR1 LEG_ADDRESS1,b.C_ADDR1 FIN_ADDRESS1,case when NVL(trim(a.C_ADDR1) ,' ')= NVL(trim(b.C_ADDR1),' ') then 'TRUE' ELSE 'FALSE' END MATCH_ADDRESS1,
a.C_ADDR2 LEG_ADDRESS2,b.C_ADDR2 FIN_ADDRESS2,case when NVL(trim(a.C_ADDR2),' ') = NVL(trim(b.C_ADDR2),' ') then 'TRUE' ELSE 'FALSE' END MATCH_ADDRESS2,
a.C_GENDER LEG_GENDER,b.C_GENDER FIN_GENDER,case when NVL(trim(a.C_GENDER),' ') = NVL(trim(b.C_GENDER),' ') then 'TRUE' ELSE 'FALSE' END MATCH_GENDER,
--a.DATE_OF_BIRTH LEG_DATE_OF_BIRTH,b.DATE_OF_BIRTH FIN_DATE_OF_BIRTH,case when NVL(a.DATE_OF_BIRTH,sysdate) = NVL(b.DATE_OF_BIRTH,sysdate) then 'TRUE' ELSE 'FALSE' END MATCH_DATE_OF_BIRTH,
a.PAN_NATIONAL_ID LEG_CIVIL_ID,b.PAN_NATIONAL_ID FIN_CIVIL_ID,case when NVL(trim(a.PAN_NATIONAL_ID),' ') = NVL(trim(b.PAN_NATIONAL_ID),' ') then 'TRUE' ELSE 'FALSE' END MATCH_CIVIL_ID
 from CORP_E_BANKING_USER1_O_TABLE A
LEFT JOIN (
SELECT DISTINCT * FROM ECECUSER.CUSR@DBREAD_USER FIN_CUSR
inner JOIN ECECUSER.CSIP@DBREAD_USER FIN_CSIP ON FIN_CSIP.INDIVIDUAL_ID = FIN_CUSR.INDIVIDUAL_ID  
WHERE FIN_CSIP.CHANNEL_ID='I' and FIN_CUSR.DB_TS='1' AND FIN_CUSR.DB_TS='1' and FIN_CSIP.DB_TS='1'  AND FIN_CUSR.BANK_ID='01' and USER_ID not like 'SMS%'-- AND FIN_CSIP.DEL_FLG='N'
) B ON A.CUST_ID = B.CUST_ID and upper(NVL(trim(a.CORP_USER),' ')) = NVL(b.USER_ID,' ') 
