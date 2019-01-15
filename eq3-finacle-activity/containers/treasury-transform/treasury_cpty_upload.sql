truncate table treasury_cpty_o_table;

--TREASURY CORPORATE CUSTOMER
insert into treasury_cpty_o_table
SELECT DISTINCT
       '' RESPONSE,
       '' TEMPLATE,
       trim(BO149_COREINTERFACE.TREASURYCOUNTERPARTYMNE) NAME,
       trim(BO149_Corporate.corp_Key) MNEMONIC,
       trim(BO149_Corporate.corporate_Name) SHORT_NAME1,
       trim(BO149_Corporate.corporate_Name) SHORT_NAME2,
       'EPG_KWT' EPG,
       'EXTERNAL' TRADE_ROLE,
       --case when trim(BIC) is null then 'CORPORATE' else 'BANK' end CPTY_TYPE,
	   case when trim(CTYPE)='B' then 'BANK'
            when trim(CTYPE) IN('C','F') THEN 'CORPORATE'
            when trim(CTYPE)='I' THEN 'INDIVIDUAL'
            when trim(CTYPE) IN('O','K') THEN 'OTHINS'
            end CPTY_TYPE,
       --CASE when trim(INSTRUMENT_CLASS_DATA_NAME) like 'MUTUAL FUNDS%' then 'AMC'  
       --     WHEN upper(trim(SN)) like '%BROKER%' THEN 'BROKER'            
       --     WHEN B.COUNTERPARTY_STRING IS NOT NULL THEN 'ISSUER'
       --     ELSE 'BANK_CUSTOMER' END CPTY_ROLE_DATA,
	   CASE when trim(INSTRUMENT_CLASS_DATA_NAME) like 'MUTUAL FUNDS%' then 'AMC'  
             WHEN B.COUNTERPARTY_STRING IS NOT NULL THEN 'ISSUER'
             when trim(CTYPE)='K' then 'BROKER' 
             ELSE 'BANK_CUSTOMER' END CPTY_ROLE_DATA,
       TRIM(BO149_Corporate.CountryOfOrigin) COI,
       TRIM(BO149_Corporate.principle_PlaceOperation) COUR,
       '' CPTY_CATEGORY,--
       '' LBS_1,
       trim(GRP_ID) PARENT_DATA_FETCH_MNEMONIC,--
       case when trim(GRP_ID) is not null then 'LIMIT GROUP' end PARENT_DATA_RELATIONSHIP,--
       case when trim(GRP_ID) is not null then 'OK' end PARENT_DATA_ADD_ACTION,--
       TRIM(BO149_Address.Address_Line1) ADDRESS_1,
       TRIM(BO149_Address.Address_Line2) ADDRESS_2,
       TRIM(BO149_Address.Address_Line3) ADDRESS_3,
       '' ADDRESS_4,
       '' PHONE,
       '' EMAIL_ID,
       '' CONFIRMATION_EMAIL_ID,
       '' FAX,
       case when trim(BIC) is not null then 'SWIFT' end CPTY_MEDIUM_DATA_$1_MEDIUM,
       trim(BIC) CPTY_MEDIUM_DATA_$1_MEDIUM_ID,
       case when trim(BIC) is not null then 'SWIFT' end CONFIRM_METHOD,
       case when trim(BIC) is not null then 'SWIFT' end SETL_METHOD,
       trim(CUSTALTID_1) CPTY_ALIAS_DATA_$1_NAME,
       case when trim(CUSTALTID_1) is not null then 'REUTERS' end CPTY_ALIAS_DATA_$1_ALIASGROUP,
       case when trim(CUSTALTID_1) is not null then 'OK' end CPTY_ALIAS_DATA_$1_COMMENTS,
       '' BROKER_EXCH_AMC_LIST_STR,
       trim(SIC) INDUSTRY_DATA,
       '' CPTY_SETL_DATA_CCY_CAL_LIST,
       '' CPTY_SETL_DATA_TAX_APPL,
       '' CPTY_SETL_DATA_TAX_PRCNTAGE,
       '' CPTY_SETL_DATA_SCRIP_PAYI_LAG,
       '' CPTY_SETL_DATA_SCRIP_PAYO_LAG,
       '' CPTY_SETL_DATA_FUNDS_PAYIN_LAG,
       '' CPTY_SETL_DATA_FUNDS_PAYO_LAG,
       '' CPTY_SETL_DATA_TRDNG_PRD,
       '' CPTY_SETL_DATA_TRDNG_PRD_STRT,
       '' CPTY_SETL_DATA_TRDNG_PRD_END,
       '' CPTY_SETL_DATA_NXT_SCRIP_PAYI,
       '' CPTY_SETL_DATA_NXT_FUNDS_PAYI,
       '' CPTY_SETL_DATA_NXT_SCRIP_PAYO,
       '' CPTY_SETL_DATA_NXT_FUNDS_PAYO,
       '' CPTY_SETL_DATA_INTRAPRD_SQ_OFF,
       '' LB_ACCT_ID,
       '' CURRENCY,
       '' LB_ACCT_BRANCH,
       '' LB_ACCT_STATUS
   FROM CRMUSER.Corporate BO149_Corporate
  INNER JOIN CRMUSER.COREINTERFACE BO149_Coreinterface ON BO149_Corporate.corp_ID = BO149_Coreinterface.corp_ID AND BO149_COREINTERFACE.TREASURYCOUNTERPARTY =  'Y'
  LEFT JOIN CRMUSER.Address BO149_Address ON BO149_Corporate.corp_ID = BO149_Address.corp_ID AND  BO149_ADDRESS.PREFERREDADDRESS = 'Y'
  LEFT JOIN cust ON TRIM(CMNE) = TRIM(BO149_COREINTERFACE.TREASURYCOUNTERPARTYMNE)
  LEFT JOIN (SELECT TO_CHAR(trim(ISSUER_STRING)) COUNTERPARTY_STRING,INSTRUMENT_CLASS_DATA_NAME FROM SECURITY_DEFN_O_TABLE UNION
    SELECT TO_CHAR(trim(ISSUER_STRING)),INSTRUMENT_CLASS_DATA_NAME FROM EQUITY_DEFN_O_TABLE) B on TRIM(CMNE) = COUNTERPARTY_STRING
  left join tr_grp_and_cpty_map_o_table on trim(CPTY_MNEMONIC) =  TRIM(BO149_COREINTERFACE.TREASURYCOUNTERPARTYMNE)
  left join (select trim(cno) cno,min(CUSTALTID) CUSTALTID_1,case when count(*)>1 then max(CUSTALTID) end CUSTALTID_2
                 from cusi where CUSTIDTYPE='REUTERS' group by trim(cno)) cusi on trim(cusi.CNO) = trim(CUST.CNO) --and  trim(cusi.CUSTIDTYPE)='REUTERS'
  WHERE BO149_Corporate.BANK_ID = '01';
  
  --TREASURY RETAIL CUSTOMER
  insert into treasury_cpty_o_table
    SELECT DISTINCT
       '' RESPONSE,
       '' TEMPLATE,
       TRIM(BO1_Coreinterface.TREASURYCOUNTERPARTYMNE) NAME,
       trim(BO1_Accounts_Retail.OrgKey) MNEMONIC,
       trim(BO1_Accounts_Retail.Cust_First_Name) SHORT_NAME1,
       trim(BO1_Accounts_Retail.Cust_Last_Name) SHORT_NAME2,
       'EPG_KWT' EPG,
       'EXTERNAL' TRADE_ROLE,
       --case when trim(BIC) is null then 'CORPORATE' else 'BANK' end CPTY_TYPE,
	   case when trim(CTYPE)='B' then 'BANK'
            when trim(CTYPE) IN('C','F') THEN 'CORPORATE'
            when trim(CTYPE)='I' THEN 'INDIVIDUAL'
            when trim(CTYPE) IN('O','K') THEN 'OTHINS'
            end CPTY_TYPE,	   
       --CASE when trim(INSTRUMENT_CLASS_DATA_NAME) like 'MUTUAL FUNDS%' then 'AMC'  
       --     WHEN upper(trim(SN)) like '%BROKER%' THEN 'BROKER'            
       --     WHEN B.COUNTERPARTY_STRING IS NOT NULL THEN 'ISSUER'
       --     ELSE 'BANK_CUSTOMER' END CPTY_ROLE_DATA,
	   CASE when trim(INSTRUMENT_CLASS_DATA_NAME) like 'MUTUAL FUNDS%' then 'AMC'  
             WHEN B.COUNTERPARTY_STRING IS NOT NULL THEN 'ISSUER'
             when trim(CTYPE)='K' then 'BROKER' 
             ELSE 'BANK_CUSTOMER' END CPTY_ROLE_DATA,			
       TRIM(BO1_Accounts_Retail.CountryOfBirth) COI,--TRIM(BO74_Demographic.Nationality)
       TRIM(BO74_Demographic.Nationality) COUR,--TRIM(BO1_Accounts_Retail.CountryOfBirth)
       '' CPTY_CATEGORY,--
       '' LBS_1,
       trim(GRP_ID) PARENT_DATA_FETCH_MNEMONIC,--
       case when trim(GRP_ID) is not null then 'LIMIT GROUP' end PARENT_DATA_RELATIONSHIP,--
       case when trim(GRP_ID) is not null then 'OK' end PARENT_DATA_ADD_ACTION,--
       TRIM(BO149_Address.Address_Line1) ADDRESS_1,
       TRIM(BO149_Address.Address_Line2) ADDRESS_2,
       TRIM(BO149_Address.Address_Line3) ADDRESS_3,
       '' ADDRESS_4,
       '' PHONE,
       '' EMAIL_ID,
       '' CONFIRMATION_EMAIL_ID,
       '' FAX,
       case when trim(BIC) is not null then 'SWIFT' end CPTY_MEDIUM_DATA_$1_MEDIUM,
       trim(BIC) CPTY_MEDIUM_DATA_$1_MEDIUM_ID,
       case when trim(BIC) is not null then 'SWIFT' end CONFIRM_METHOD,
       case when trim(BIC) is not null then 'SWIFT' end SETL_METHOD,
       trim(CUSTALTID_1) CPTY_ALIAS_DATA_$1_NAME,
       case when trim(CUSTALTID_1) is not null then 'REUTERS' end CPTY_ALIAS_DATA_$1_ALIASGROUP,
       case when trim(CUSTALTID_1) is not null then 'OK' end CPTY_ALIAS_DATA_$1_COMMENTS,
       '' BROKER_EXCH_AMC_LIST_STR,
       trim(SIC) INDUSTRY_DATA,
       '' CPTY_SETL_DATA_CCY_CAL_LIST,
       '' CPTY_SETL_DATA_TAX_APPL,
       '' CPTY_SETL_DATA_TAX_PRCNTAGE,
       '' CPTY_SETL_DATA_SCRIP_PAYI_LAG,
       '' CPTY_SETL_DATA_SCRIP_PAYO_LAG,
       '' CPTY_SETL_DATA_FUNDS_PAYIN_LAG,
       '' CPTY_SETL_DATA_FUNDS_PAYO_LAG,
       '' CPTY_SETL_DATA_TRDNG_PRD,
       '' CPTY_SETL_DATA_TRDNG_PRD_STRT,
       '' CPTY_SETL_DATA_TRDNG_PRD_END,
       '' CPTY_SETL_DATA_NXT_SCRIP_PAYI,
       '' CPTY_SETL_DATA_NXT_FUNDS_PAYI,
       '' CPTY_SETL_DATA_NXT_SCRIP_PAYO,
       '' CPTY_SETL_DATA_NXT_FUNDS_PAYO,
       '' CPTY_SETL_DATA_INTRAPRD_SQ_OFF,
       '' LB_ACCT_ID,
       '' CURRENCY,
       '' LB_ACCT_BRANCH,
       '' LB_ACCT_STATUS
   FROM crmuser.Accounts_Retail BO1_Accounts_Retail
   left join crmuser.Demographic BO74_Demographic on BO74_Demographic.orgKey = BO1_Accounts_Retail.OrgKey
  INNER JOIN CRMUSER.COREINTERFACE BO1_Coreinterface ON BO1_Accounts_Retail.OrgKey = BO1_Coreinterface.OrgKey AND BO1_Coreinterface.TREASURYCOUNTERPARTY =  'Y'
  LEFT JOIN CRMUSER.Address BO149_Address ON BO1_Accounts_Retail.OrgKey = BO149_Address.OrgKey AND  BO149_ADDRESS.PREFERREDADDRESS = 'Y'
  left join crmuser.miscellaneousinfo BO1_miscellaneousinfo on BO1_Accounts_Retail.orgKey = BO1_miscellaneousinfo.OrgKey
  LEFT JOIN cust ON TRIM(CMNE) = TRIM(BO1_Coreinterface.TREASURYCOUNTERPARTYMNE)
  LEFT JOIN (SELECT TO_CHAR(trim(ISSUER_STRING)) COUNTERPARTY_STRING,INSTRUMENT_CLASS_DATA_NAME FROM SECURITY_DEFN_O_TABLE UNION
    SELECT TO_CHAR(trim(ISSUER_STRING)),INSTRUMENT_CLASS_DATA_NAME FROM EQUITY_DEFN_O_TABLE) B on TRIM(CMNE) = COUNTERPARTY_STRING
  left join tr_grp_and_cpty_map_o_table on trim(CPTY_MNEMONIC) =  TRIM(BO1_Coreinterface.TREASURYCOUNTERPARTYMNE)
  left join (select trim(cno) cno,min(CUSTALTID) CUSTALTID_1,case when count(*)>1 then max(CUSTALTID) end CUSTALTID_2
                 from cusi where CUSTIDTYPE='REUTERS' group by trim(cno)) cusi on trim(cusi.CNO) = trim(CUST.CNO) --and  trim(cusi.CUSTIDTYPE)='REUTERS'
  WHERE BO1_Accounts_Retail.BANK_ID = '01';
  
  commit;
  
  exit; 
