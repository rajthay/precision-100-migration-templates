
TRUNCATE TABLE CUSTOMER_PAYEE_O_TABLE;
INSERT INTO CUSTOMER_PAYEE_O_TABLE
SELECT  rownum "PAYEE_LIST_ID",
       '01' "BANK_ID",
       CORP_USER USER_ID,
       '1' "DB_TS",     
       CORP_ID,
       BNF_ID,
       BNF_NAME "BNF_NIC_NAME",
       BNF_BANK_ADDRESS "FREE_FIELD_1",
       BNF_BANK_COUNTRY "FREE_FIELD_2",
       '' "FREE_FIELD_3",
       '' "FREE_FLG1",
       '' "FREE_FLG2",
       'N' "DEL_FLG",
       'MIGRATED' "R_MOD_ID",
       R_MOD_TIME,
       'MIGRATED' "R_CRE_ID",
       R_CRE_TIME,
       '' "CONSUMER_CD",
       '' "RECEIVE_BILLS_FLG",
       '' "AUTOPAY_FLG",
       '' "AUTOPAY_AMT",
       '' "AUTOPAY_CRN",
       '' "AUTOPAY_ACID",
       '' "AUTOPAY_BRCH_ID",
       '' "AUTOPAY_MODE",
       '' "SUBSCRIPTION_START_DATE",
       'N' "ADHOC_PAYEE",
       'MIGRATED' "NICKNAME_CRE_ID",--Need to check  --Populate R_CRE_ID from this table
       '' "BNF_PYMT_DETAILS_1",
       '' "BNF_PYMT_DETAILS_2",
       '' "BNF_PYMT_DETAILS_3",
       '' "BNF_PYMT_DETAILS_4",
       '' "NOTIFICATION_REF_NO",
       '' "MAX_AMT_IN_HOMECRN",
       '' "REG_ACTIVE_FLG",
       '' "CUSTOMER_ID",
       '' "FILE_SEQN_NUM",
       '' "FU_REC_NUM"
  FROM PAYEE_MASTER_O_TABLE
  inner JOIN SMS_AND_E_BANKING_USER_O_TABLE O ON  CUST_ID=CORP_ID;
  COMMIT;    

UPDATE CUSTOMER_PAYEE_O_TABLE SET PAYEE_LIST_ID= NXT_PAYEE_LIST_ID01.NEXTVAL;
COMMIT;
EXIT; 
