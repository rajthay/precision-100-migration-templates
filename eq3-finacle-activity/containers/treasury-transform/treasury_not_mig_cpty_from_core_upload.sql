truncate TABLE tr_not_mig_cpty_core_o_table;       
insert into tr_not_mig_cpty_core_o_table 
SELECT DISTINCT
       '' RESPONSE,
       '' TEMPLATE,
       trim(CMNE) NAME,
       trim(CMNE) MNEMONIC,
       trim(CFN1) SHORT_NAME1,
       trim(CFN2) SHORT_NAME2,
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
       --     WHEN B.COUNTERPARTY_STRING IS NOT NULL THEN 'ISSUER' END   CPTY_ROLE_DATA,
	   CASE when trim(INSTRUMENT_CLASS_DATA_NAME) like 'MUTUAL FUNDS%' then 'AMC'  
             WHEN B.COUNTERPARTY_STRING IS NOT NULL THEN 'ISSUER'
             when trim(CTYPE)='K' then 'BROKER' 
             ELSE 'BANK_CUSTOMER' END CPTY_ROLE_DATA,			
       TRIM(CCODE) COI,
       TRIM(UCCODE) COUR,
       '' CPTY_CATEGORY,--
       '' LBS_1,
       trim(GRP_ID) PARENT_DATA_FETCH_MNEMONIC,--
       case when trim(GRP_ID) is not null then 'LIMIT GROUP' end PARENT_DATA_RELATIONSHIP,--
       case when trim(GRP_ID) is not null then 'OK' end PARENT_DATA_ADD_ACTION,--
       trim(CA1) ADDRESS_1,
       trim(CA2) ADDRESS_2,
       trim(CA3) ADDRESS_3,
       trim(CA4) ADDRESS_4,
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
  FROM cust
LEFT JOIN GFPF ON TRIM(CMNE) = TRIM(GFOCID)
left join (SELECT TO_CHAR(trim(ISSUER_STRING)) COUNTERPARTY_STRING,INSTRUMENT_CLASS_DATA_NAME FROM SECURITY_DEFN_O_TABLE UNION
SELECT TO_CHAR(trim(ISSUER_STRING)),INSTRUMENT_CLASS_DATA_NAME FROM EQUITY_DEFN_O_TABLE) B on TRIM(CMNE) = COUNTERPARTY_STRING
left join tr_grp_and_cpty_map_o_table on trim(CPTY_MNEMONIC) = TRIM(CMNE)
 left join (select trim(cno) cno,min(CUSTALTID) CUSTALTID_1,case when count(*)>1 then max(CUSTALTID) end CUSTALTID_2
                 from cusi where CUSTIDTYPE='REUTERS' group by trim(cno)) cusi on trim(cusi.CNO) = trim(CUST.CNO) --and  trim(cusi.CUSTIDTYPE)='REUTERS'
WHERE GFOCID IS NULL AND (TRIM(CMNE) IN(
select trim(CU.cmne) from CRLM LM
left join crgm on trim(LM.LIMITMEMBER) = trim(crgm.GRPMEMBER)
LEFT JOIN CUST CU ON TRIM(LM.LIMITMEMBER) = TRIM(CU.CNO)
LEFT JOIN GFPF ON TRIM(GFPF.GFOCID) = TRIM(CU.CMNE)
LEFT JOIN MAP_CIF MC ON trim(MC.GFCUS)||trim(MC.GFCLC) = trim(GFPF.GFCUS)||trim(GFPF.GFCLC)
  WHERE trim(CREQLIMAMT) <> 0 and LIMITTYPE IN ('C','G') AND (TO_DATE(EXPDATE,'YYYY-MM-DD')>to_date(get_param('EOD_DATE'),'dd-mm-yyyy')  OR TRIM(EXPDATE) IS NULL
  or (LIMITMEMBER,LIMITTYPE,PRODGROUPID,MTYDATE,to_date(EXPDATE,'YYYY-MM-DD')) in(select LIMITMEMBER,LIMITTYPE,PRODGROUPID,MTYDATE,max(to_date(EXPDATE,'YYYY-MM-DD')) EXPDATE  from crlm 
    where TO_DATE(EXPDATE,'YYYY-MM-DD')<=to_date(get_param('EOD_DATE'),'dd-mm-yyyy')
    and (LIMITMEMBER,LIMITTYPE,PRODGROUPID,MTYDATE) not in(select LIMITMEMBER,LIMITTYPE,PRODGROUPID,MTYDATE from crlm where TO_DATE(EXPDATE,'YYYY-MM-DD')>to_date(get_param('EOD_DATE'),'dd-mm-yyyy') OR TRIM(EXPDATE) IS NULL)
    group by  LIMITMEMBER,LIMITTYPE,PRODGROUPID,MTYDATE))
  AND (CASE WHEN LIMITTYPE='C' AND trim(CU.CMNE) IS NULL THEN 0 ELSE 1 END =1)
  AND (CASE WHEN trim(LM.PRODGROUPID)='FX DEALS' and trim(LM.MTYDATE)='TOT'  AND trim(LM.CREQLIMAMT) ='0' THEN 0 ELSE 1 END =1)
UNION
select to_char(trim(ISSUER_STRING)) from SECURITY_DEFN_O_TABLE
union
select to_char(trim(ISSUER_STRING)) from EQUITY_DEFN_O_TABLE
)or trim(ctype)='K');
 commit;
 exit;