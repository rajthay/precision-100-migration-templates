truncate table tr_grp_and_cpty_map_o_table;
insert into tr_grp_and_cpty_map_o_table       
SELECT  case when trim(CU.CMNE) = trim(h.grpid) then trim(h.grpid)||'GRP' else trim(h.grpid) end,trim(cu.cmne) cmne
  FROM crgh h
       INNER JOIN crgm c ON TRIM (c.grpid) = TRIM (h.grpid)
       INNER JOIN cust cu ON TRIM (cu.cno) = TRIM (c.GRPMEMBER)
       where   h.GRPTYPE = 'C' and trim(cmne) not in(
select trim(CMNE) CMNE from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID) where trim(cmne) not like 'AE%'
minus(
SELECT trim(TREASURY_COUNTERPARTY_MNEMONIC) FROM RETAIL_COREINTERFACE
UNION
SELECT trim(TREASURY_COUNTERPARTY_MNEMONIC) FROM CORP_COREINTERFACE
union 
select to_char(trim(MNEMONIC)) from TR_NOT_MIG_CPTY_CORE_O_TABLE
)
);     
commit;    
 DECLARE
   CURSOR c1
   IS
      SELECT * FROM tr_grp_and_cpty_map_o_table;
   no_of_group_name_con_mne   VARCHAR2 (1) := 0;
BEGIN
   FOR l_record IN c1
   LOOP
      SELECT COUNT (*)
        INTO no_of_group_name_con_mne
        FROM cust
       WHERE trim(CMNE) LIKE l_record.GRP_ID;
      IF (no_of_group_name_con_mne != 0)
      THEN
         UPDATE tr_grp_and_cpty_map_o_table
            SET GRP_ID = GRP_ID || 'GRP'
          WHERE GRP_ID = l_record.GRP_ID;
      END IF;
   END LOOP;
END;
/
COMMIT;
exit;
--select trim(CMNE) CMNE ,trim(BIC) BIC ,case when trim(BIC) is null then 'CORPORATE' else 'BANK' end CPTY_TYPE, trim(CUSTALTID) REUTERS_ID,
--CASE when trim(INSTRUMENT_CLASS_DATA_NAME) like 'MUTUAL FUNDS%' then 'AMC' 
--WHEN upper(trim(SN)) like '%BROKER%' THEN 'BROKER' WHEN B.COUNTERPARTY_STRING IS NOT NULL THEN 'ISSUER' END CPTY_ROLE_DATA,trim(SIC) SIC  from cust
--left join (SELECT DISTINCT TO_CHAR(ISSUER_STRING) COUNTERPARTY_STRING,trim(INSTRUMENT_CLASS_DATA_NAME) INSTRUMENT_CLASS_DATA_NAME FROM SECURITY_DEFN_O_TABLE UNION
--SELECT DISTINCT TO_CHAR(ISSUER_STRING),trim(INSTRUMENT_CLASS_DATA_NAME)INSTRUMENT_CLASS_DATA_NAME FROM EQUITY_DEFN_O_TABLE) B on TRIM(CMNE) = COUNTERPARTY_STRING
--left join cusi on trim(cusi.CNO) = trim(CUST.CNO) and  trim(cusi.CUSTIDTYPE)='REUTERS'
--where trim(cust.cmne) not like 'AE%'
--
--select trim(CPTY_MNEMONIC) CPTY_MNEMONIC,trim(GRP_ID) GRP_ID from tr_grp_and_cpty_map_o_table
--
--select trim(CMNE) CMNE ,trim(CMNE) CMNE ,trim(SN),trim(CFN1),'EPG_KWT','EXTERNAL',case when trim(BIC) is null then 'CORPORATE' else 'BANK' end CPTY_TYPE, '',TRIM(UCCODE) COI   ,TRIM(UCCODE) COUR FRom cust
--LEFT JOIN GFPF ON TRIM(CMNE) = TRIM(GFOCID)
--WHERE GFOCID IS NULL AND TRIM(CMNE) IN(
--SELECT TO_CHAR(COUNTERPARTY_STRING) COUNTERPARTY_STRING FROM CPTY_CUST_GROUP_LIMIT_O_TABLE
--UNION
--SELECT TO_CHAR(COUNTERPARTY_STRING) FROM SEC_BUY_SELL_O_TABLE
--UNION
--SELECT TO_CHAR(COUNTERPARTY_STRING) FROM EQUITY_MF_O_TABLE
--)
--
--select trim(CPTY_MNEMONIC) CPTY_MNEMONIC,trim(GRP_ID) GROUP_CODE,trim(GROUP_ID) GROUP_ID from tr_grp_and_cpty_map_o_table
--left join GROUP_MASTER_O_TABLE on trim(GRP_ID) like trim(REPORTING_GROUP_ID)||'%'
 