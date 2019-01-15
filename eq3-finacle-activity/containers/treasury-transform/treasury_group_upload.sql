
delete from crgm where trim(GRPID)='NBDAE' and trim(GRPMEMBER)='900100045' ;
delete from crgm where trim(GRPID)='EBIAE' and trim(GRPMEMBER)='900013641' ;
commit;
truncate TABLE treasury_group_o_table;       
insert into treasury_group_o_table 
SELECT DISTINCT
       '' RESPONSE,
       '' TEMPLATE,
       trim(c.grpid) NAME,
       trim(c.grpid) MNEMONIC,
       DESCR SHORT_NAME1,
       '' SHORT_NAME2,
       'EPG_KWT' EPG,
       'EXTERNAL' TRADE_ROLE,
       'BANK' CPTY_TYPE,
       '' CPTY_ROLE_DATA,
       UCCODE COI,
       UCCODE COUR,
       '' LBS_1,
       '' ADDRESS_1,
       '' ADDRESS_2,
       '' ADDRESS_3,
       '' ADDRESS_4,
       '' PHONE,
       '' EMAIL_ID,
       '' CONFIRMATION_EMAIL_ID,
       '' FAX,
       '' CPTY_MEDIUM_DATA_$1_MEDIUM,
       '' CPTY_MEDIUM_DATA_$1_MEDIUM_ID,
       '' CONFIRM_METHOD,
       '' SETL_METHOD,
       '' CPTY_ALIAS_DATA_$1_NAME,
       '' CPTY_ALIAS_DATA_$1_ALIASGROUP,
       '' CPTY_ALIAS_DATA_$1_COMMENTS,
       '' BROKER_EXCH_AMC_LIST_STR,
       '' INDUSTRY_DATA,
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
  FROM crgh h
       INNER JOIN crgm c ON TRIM (c.grpid) = TRIM (h.grpid)
       INNER JOIN cust cu ON TRIM (cu.cno) = TRIM (c.GRPMEMBER)
 WHERE h.GRPTYPE = 'C' and trim(cmne) not in(
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
      SELECT * FROM treasury_group_o_table;
   no_of_group_name_con_mne   VARCHAR2 (1) := 0;
BEGIN
   FOR l_record IN c1
   LOOP
      SELECT COUNT (*)
        INTO no_of_group_name_con_mne
        FROM cust
       WHERE trim(CMNE) LIKE l_record.NAME;
      IF (no_of_group_name_con_mne != 0)
      THEN
         UPDATE treasury_group_o_table
            SET NAME = NAME || 'GRP', MNEMONIC = MNEMONIC || 'GRP'
          WHERE NAME = l_record.NAME;
      END IF;
   END LOOP;
END;
/
delete treasury_group_o_table where NAME in(select NAME from treasury_group_o_table group by NAME having count(*)>1) and COI='GB'; 
COMMIT;
exit;
