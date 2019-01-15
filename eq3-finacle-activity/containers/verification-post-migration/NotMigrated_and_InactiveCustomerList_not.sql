========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
NotMigrated_and_InactiveCustomerList_not.sql 

--Not migrated customer with reason.
SELECT DISTINCT
       a.LEG_USERID,
       a.LEG_CUST_ID,
       CASE
          WHEN c.INDIVIDUAL = 'N' THEN 'This is non retail customer'
          WHEN REGEXP_LIKE (a.LEG_USERID, UNISTR ('[\0600-\06FF]'))OR LEG_USERID LIKE '% %' THEN 'UserId Contains Arabic letters or spaces'
          WHEN d.SCAI30 = 'Y' THEN 'This customer''s account is closed'
          WHEN d.SCAI30 = 'N' THEN 'This customer''s account is not closed'
          WHEN d.SCAI30 IS NULL THEN 'There is no accounts for this customer'
       END
          reason_for_not_migrating
  FROM e_banking_user_report a
       LEFT JOIN gfpf b ON b.GFBRNM || b.GFCUS = a.LEG_CUST_ID
       LEFT JOIN scpf d ON d.SCAN = b.GFCPNC
       LEFT JOIN map_cif c ON c.GFBRNM || c.GFCUS = b.GFBRNM || b.GFCUS
 WHERE CASE
          WHEN c.INDIVIDUAL = 'N' THEN 1
          WHEN c.GFBRNM || c.GFCUS IS NULL THEN 1
          WHEN REGEXP_LIKE (a.LEG_USERID, UNISTR ('[\0600-\06FF]')) OR LEG_USERID LIKE '% %' THEN 1
          ELSE 0
       END = 1;
	   
------------------------------------------------------------------------------------------------------------	   

--Inactive customers	   
select a.CUSTOMER_NO,a.USER_ID from ONLINE_BANK_CUST_DTLS a
left join ONLINE_BANK_CUST_DTLS_UNQ_DATA b on a.CUSTOMER_NO=b.CUSTOMER_NO and a.USER_ID=b.USERID
where b.CUSTOMER_NO is null and b.USERID is nul

 
