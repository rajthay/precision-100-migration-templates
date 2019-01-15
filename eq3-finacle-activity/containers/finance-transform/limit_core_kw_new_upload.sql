

DROP TABLE HPPF_BANK_GRP;
DROP TABLE HHPF_BANK_GRP;
DROP TABLE HHPF_MIG;
DROP TABLE HPPF_MIG;

CREATE TABLE HPPF_BANK_GRP AS 
SELECT DISTINCT NVL(UPDATED_RISK_COUNTRY_CODE,GFCNAR) HPCNA, HPGRP, GFCUS HPCUS, GFCLC HPCLC, HPLSTR, HPCCY, HPLED, HPYMDT, HPBRNM, HPLEDE, HPDLM, HPYRIT, HPYLCH, HPCF1, HPCF2, HPCF3, HPAUD FROM HPPF
INNER JOIN GFPF ON TRIM(HPGRP) = TRIM(GFGRP)
LEFT JOIN BANK_GRP_RISK_CNTRY ON TRIM(GROUP_NAME) = TRIM(HPGRP) ;

CREATE TABLE HHPF_BANK_GRP AS 
SELECT  DISTINCT NVL(UPDATED_RISK_COUNTRY_CODE,GFCNAR) HHCNA, HHGRP, GFCUS HHCUS, GFCLC HHCLC, HHLC, HHCCY, HHLED, HHAMA, HHLTST, HHYELG, HHYLCH, HHAAM, HHRAM FROM HHPF
INNER JOIN GFPF ON TRIM(HHGRP) = TRIM(GFGRP)
LEFT JOIN BANK_GRP_RISK_CNTRY ON TRIM(GROUP_NAME) = TRIM(HHGRP) ;

CREATE TABLE  HHPF_MIG AS 
SELECT * FROM (
SELECT * FROM HHPF WHERE TRIM(HHGRP) IS NULL
UNION
SELECT * FROM HHPF_BANK_GRP
) ;

TRUNCATE TABLE IBD_CUSTOMER;

INSERT INTO IBD_CUSTOMER
SELECT GFPF.GFCLC,GFPF.GFCUS,GFCNAR,FIN_CIF_ID,GFACO FROM GFPF
INNER JOIN MAP_CIF ON GFPF.GFCLC||GFPF.GFCUS = MAP_CIF.GFCLC||MAP_CIF.GFCUS
WHERE (NVL(TRIM(GFACO),0)>= 300 AND NVL(TRIM(GFACO),0) <=399) OR TRIM(GFACO)='450';

COMMIT;

UPDATE HHPF_MIG A SET HHCNA = (select GFCNAR from(SELECT distinct hhclc,hhcus,GFCNAR FROM HHPF_MIG a
inner join gfpf b on  a.hhclc||a.hhcus  = b.gfclc||b.gfcus ) b where a.hhclc||a.hhcus  = b.hhclc||b.hhcus)
where trim(HHCNA) is null and a.hhclc||a.hhcus in(select gfclc||gfcus from gfpf where GFCNAR <> 'KW');
commit;


drop table YCRLC1LF02_MIG;

create table YCRLC1LF02_MIG as 
select CRC1_GRP, nvl(GFCUS,CRC1_CUS) CRC1_CUS, nvl(GFCLC,CRC1_CLC) CRC1_CLC, CRC1_LSTR, CRC1_CGN, CRC1_PSEQ, CRC1_LSEQ, CRC1_LC, CRC1_LCN, CRC1_SUB, CRC1_HIF, CRC1_RLMA, CRC1_RLCY, CRC1_RLXD, CRC1_RADTE, CRC1_RGDTE,
 CRC1_RPLC, CRC1_RPLCN, CRC1_RICR, CRC1_RPC, CRC1_RRLVG, CRC1_BLNKF, CRC1_ULMA, CRC1_ULCY, CRC1_ULXD, CRC1_UADTE, CRC1_UGDTE, CRC1_UPLC, CRC1_UPLCN, CRC1_UICR, CRC1_UPC,
  CRC1_URLVG, CRC1_FILL from YCRLC1LF02 
left JOIN GFPF ON TRIM(CRC1_GRP) = TRIM(GFGRP)
where  (CRC1_CUS||CRC1_CLC||CRC1_GRP||CRC1_LC,CRC1_PSEQ) in(
select CRC1_CUS||CRC1_CLC||CRC1_GRP||CRC1_LC ,max(to_number(CRC1_PSEQ)) from YCRLC1LF02 group by CRC1_CUS||CRC1_CLC||CRC1_GRP||CRC1_LC
);

delete YCRLC1LF02_mig where rowid in(
select rowid from YCRLC1LF02_mig where CRC1_CUS||CRC1_CLC||CRC1_LC in(
select CRC1_CUS||CRC1_CLC||CRC1_LC  from YCRLC1LF02_mig where trim(CRC1_CUS) is not null  group by CRC1_CUS||CRC1_CLC||CRC1_LC having count(*)>1
) and  trim(CRC1_GRP) is null
);

--------------------------------------------
--Ignoring cash limit if customer have only Syndicate loan or there is no cash product in child level
--drop table cash_limit_customer;
 
--create table cash_limit_customer as 
--select hhclc,hhcus from hhpf_mig where trim(hhlc) in(       
--SELECT TRIM (COLUMN_VALUE) LIMIT_LINE
--  FROM limit_mapping,
--       XMLTABLE ( ('"' || REPLACE (LIMIT_LINE, ',', '","') || '"'))
-- WHERE LEVEL_6_PARENT = 'GECSH'
-- ) and trim(HHCUS) is not null and hhama <> 0 ;
-- 
-- update hhpf_mig set HHAMA='0' where hhclc||hhcus not in(
-- select hhclc||hhcus from cash_limit_customer
-- ) and trim(HHCUS) is not null and hhama <> 0 and trim(hhlc) in('LG083');
--commit;
------------------------------------------------
 
 
--SUBSTRACT FX LIMIT FROM CUSTL LIMIT
--UPDATE HHPF_MIG A SET A.HHAMA = (
--SELECT NEW_HHAMA FROM(
--select A.HHCLC,A.HHCUS,A.HHLC,A.HHAMA - ((C82.C8SPT/C81.C8SPT)*(B.HHAMA/C82.C8PWD))*C81.C8PWD  NEW_HHAMA from HHPF_MIG A
--INNER JOIN (select HHCUS,HHCLC,HHCCY,HHAMA from HHPF_MIG where HHLC='LG092' AND HHAMA <> 0) B ON A.HHCUS = B.HHCUS AND A.HHCLC = B.HHCLC
--LEFT JOIN C8PF C81 ON C81.C8CCY = A.HHCCY
--LEFT JOIN C8PF C82 ON C82.C8CCY = B.HHCCY
--where A.HHLC='LG098' AND A.HHAMA <> 0 
--) B WHERE A.HHCLC||A.HHCUS = B.HHCLC||B.HHCUS 
--) WHERE (A.HHCLC||A.HHCUS||A.HHLC) IN(
--select A.HHCLC||A.HHCUS||A.HHLC from HHPF_MIG A
--INNER JOIN (select HHCUS,HHCLC,HHCCY,HHAMA from HHPF_MIG where HHLC='LG092' AND HHAMA <> 0) B ON A.HHCUS = B.HHCUS AND A.HHCLC = B.HHCLC
--where A.HHLC='LG098' AND A.HHAMA <> 0);

CREATE TABLE  HPPF_MIG AS 
SELECT * FROM (
SELECT * FROM HPPF WHERE TRIM(HPGRP) IS NULL
UNION
SELECT * FROM HPPF_BANK_GRP
) ;

--CREATE CUSTL LIMIT FROM LS127 IF LG098 IS ZERO
--BELOW CODE COMMENTED BEACUSE NOW ARE COPING GENRL LIMIT TO CUSTL LIMIT
--UPDATE HHPF_MIG A SET (A.HHAMA,A.HHAAM,A.HHRAM) =( SELECT HHAMA,HHAAM,HHRAM FROM(
--SELECT B.* FROM HHPF_MIG A
--INNER JOIN (SELECT * FROM HHPF_MIG WHERE HHLC='LS127' AND HHAMA+HHRAM<>0) B ON A.HHCLC||A.HHCUS = B.HHCLC||B.HHCUS
-- WHERE A.HHLC='LG098' AND  A.HHAMA=0 
-- ) B WHERE A.HHCLC||A.HHCUS = B.HHCLC||B.HHCUS
-- ) WHERE A.HHLC='LG098' AND A.HHAMA=0 ;
-- 
-- COMMIT;

--update hhpf set HHAMA='600000000' where hhcus||hhclc='075007600' and hhlc='LG089';--exception ******
--update hhpf set HHAMA='40000000' where hhcus||hhclc='505752603' and hhlc='LG083';--exception ******

TRUNCATE TABLE LIMIT_CORE_TEMP_TABLE;

--Level 7
INSERT INTO LIMIT_CORE_TEMP_TABLE
SELECT distinct HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       CIF.fin_cif_id BORROWER_NAME,
       '7' NODE_LEVEL,
       CIF.fin_cif_id LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_7 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       CIF.fin_cif_id PARENT_LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_7_PARENT END PARENT_LIMIT_SUFFIX,
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_7 IS NOT NULL 
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON LS.LIMIT_SUFFIX_CODE= LM.level_7
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
 WHERE  --HH.HHLED > get_param ('EODCYYMMDD')AND
       CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1';
       
commit;
       
--Level 6
INSERT INTO LIMIT_CORE_TEMP_TABLE        
SELECT  DISTINCT HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       CIF.fin_cif_id BORROWER_NAME,
       '6' NODE_LEVEL,
       CIF.fin_cif_id LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_6 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       CIF.fin_cif_id PARENT_LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_6_PARENT END PARENT_LIMIT_SUFFIX,
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit,
       get_param('BANK_ID')  
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_6 IS NOT NULL 
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON LS.LIMIT_SUFFIX_CODE= LM.level_6
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
 WHERE  --HH.HHLED > get_param ('EODCYYMMDD')AND
       CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1';
       
commit;
        
--Level 5
INSERT INTO LIMIT_CORE_TEMP_TABLE        
SELECT  DISTINCT HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       CIF.fin_cif_id BORROWER_NAME,
       '5' NODE_LEVEL,
       CIF.fin_cif_id LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_5 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       CIF.fin_cif_id PARENT_LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_5_PARENT END PARENT_LIMIT_SUFFIX,
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit ,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_5 IS NOT NULL 
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON LS.LIMIT_SUFFIX_CODE= LM.level_5
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
 WHERE  --HH.HHLED > get_param ('EODCYYMMDD')AND
        CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1';
                        
commit;
        
--Level 4
INSERT INTO LIMIT_CORE_TEMP_TABLE        
SELECT  DISTINCT HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       CIF.fin_cif_id BORROWER_NAME,
       '4' NODE_LEVEL,
       CIF.fin_cif_id LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_4 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       CIF.fin_cif_id PARENT_LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_4_PARENT END PARENT_LIMIT_SUFFIX,
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_4 IS NOT NULL 
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON LS.LIMIT_SUFFIX_CODE= LM.level_4
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
 WHERE  --HH.HHLED > get_param ('EODCYYMMDD')AND
        CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1';
           
commit;

--Level 3
INSERT INTO LIMIT_CORE_TEMP_TABLE        
SELECT DISTINCT HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       CIF.fin_cif_id BORROWER_NAME,
       '3' NODE_LEVEL,
       CIF.fin_cif_id LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_3 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       CASE WHEN IBD_CUSTOMER.FIN_CIF_ID IS NOT NULL THEN TO_CHAR(TRIM(HHCNA)) ELSE TO_CHAR(GM.GROUP_ID) END PARENT_LIMIT_PREFIX,--NEED TO PUT GROUP NAME
       CASE WHEN IBD_CUSTOMER.FIN_CIF_ID IS NOT NULL THEN 'CNTRY' WHEN GM.GROUP_ID IS NOT NULL THEN 'GROUP' END PARENT_LIMIT_SUFFIX,--CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_3_PARENT END
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_3 IS NOT NULL 
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= LM.level_3
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
       LEFT JOIN GROUP_MASTER_O_TABLE GM ON TRIM(REPORTING_GROUP_ID) = TRIM(HHGRP)
       LEFT JOIN IBD_CUSTOMER ON IBD_CUSTOMER.FIN_CIF_ID = CIF.fin_cif_id AND TRIM(HHCNA) IS NOT NULL AND TRIM(HHGRP) IS NULL
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
 WHERE  --HH.HHLED > get_param ('EODCYYMMDD')AND
       CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1';
        
commit;       



--LEVEL 1 (BANK GROUP LIMIT)
INSERT INTO LIMIT_CORE_TEMP_TABLE
SELECT DISTINCT HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       TRIM(GH.GROUP_ID) BORROWER_NAME,
       '1' NODE_LEVEL,
       TRIM(GH.GROUP_ID) LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_1 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       HH.HHCNA PARENT_LIMIT_PREFIX,--NEED TO PUT GROUP NAME
       'CNTRY' PARENT_LIMIT_SUFFIX,--CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_3_PARENT END
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'G' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_1 IS NOT NULL 
       INNER JOIN GROUP_MASTER_O_TABLE GH ON TRIM(GH.REPORTING_GROUP_ID) = TRIM(HH.HHGRP)
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= LM.level_1
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
  WHERE CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1'
 ;
  
COMMIT;       

UPDATE LIMIT_CORE_TEMP_TABLE SET LIMIT_SUFFIX=CASE WHEN CRNCY_CODE='KWD' THEN 'SYLHC' ELSE 'SYLFC' END WHERE LIMIT_SUFFIX ='SYLXX';

COMMIT;

UPDATE LIMIT_CORE_TEMP_TABLE SET LIMIT_SUFFIX=CASE WHEN CRNCY_CODE='KWD' THEN 'GETLH' ELSE 'GETLF' END WHERE LIMIT_SUFFIX ='GETXX';

COMMIT;

UPDATE LIMIT_CORE_TEMP_TABLE SET LIMIT_SUFFIX=CASE WHEN CRNCY_CODE='KWD' THEN 'GELLH' ELSE 'GELLF' END WHERE LIMIT_SUFFIX ='GELXX';

COMMIT;

--Substracting GECNC sanction amount from GECSH
update LIMIT_CORE_TEMP_TABLE x set x.SANCTION_LIMIT = (select SANCTION_LIMIT from(
select a.limit_prefix,a.limit_suffix,a.SANCTION_LIMIT-b.SANCTION_LIMIT SANCTION_LIMIT from 
(select * from LIMIT_CORE_TEMP_TABLE where LIMIT_SUFFIX='GECSH') a
inner join ((select * from LIMIT_CORE_TEMP_TABLE where LIMIT_SUFFIX='GECNC')) b on a.limit_prefix = b.limit_prefix
) y where x.limit_prefix = y.limit_prefix and x.limit_suffix = y.limit_suffix)
where x.limit_prefix||x.limit_suffix in(
select a.limit_prefix||a.limit_suffix from 
(select * from LIMIT_CORE_TEMP_TABLE where LIMIT_SUFFIX='GECSH') a
inner join ((select * from LIMIT_CORE_TEMP_TABLE where LIMIT_SUFFIX='GECNC')) b on a.limit_prefix = b.limit_prefix
);
commit;

       
TRUNCATE TABLE LIMIT_CORE_O_TABLE;
INSERT INTO LIMIT_CORE_O_TABLE
   SELECT BORROWER_NAME,
          NODE_LEVEL,
          LIMIT_PREFIX,
          LIMIT_SUFFIX,
          LIMIT_DESC,
          CRNCY_CODE,
          PARENT_LIMIT_PREFIX,
          PARENT_LIMIT_SUFFIX,
          SANCTION_LIMIT,
          DRAWING_POWER_IND,
          LIMIT_APPROVAL_DATE,
          LIMIT_EXPIRY_DATE,
          LIMIT_REVIEW_DATE,
          APPROVAL_AUTH_CODE,
          APPROVAL_LEVEL,
          LIMIT_APPROVAL_REF,
          NOTES,
          TERMS_AND_CONDITIONS,
          LIMIT_TYPE,
          LOAN_TYPE,
          MASTER_LIMIT_NODE,
          MIN_COLL_VALUE_BASED_ON,
          DRWNG_POWER_PCNT,
          PATTERN_OF_FUNDING,
          DEBIT_ACCOUNT_FOR_FEES,
          COMMITTED_LINES,
          CONTRACT_SIGN_DATE,
          UPLOAD_STATUS,
          COND_PRECEDENT_FLG,
          GLOBAL_LIMIT_FLG,
          MAIN_PRODUCT_TYPE,
          PROJECT_NAME,
          PRODUCT_NAME,
          PURPOSE_OF_LIMIT,
          BANK_ID
     FROM LIMIT_CORE_TEMP_TABLE -- WHERE to_date(LIMIT_EXPIRY_DATE,'DD-MM-YYYY')>to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
     ;
COMMIT;    



--DELETE FROM LIMIT_CORE_O_TABLE A WHERE NOT EXISTS (
--SELECT 1 FROM (
--select TRIM(CIF_ID) BORROWER_NAME from tf001
--union all
--select TRIM(DC_CIF_ID) from tf004
--union all
--select TRIM(CIF_ID) BORROWER_NAME from tf001_risk
--) B WHERE  A.BORROWER_NAME = B.BORROWER_NAME
--) and SANCTION_LIMIT='0';

--delete from LIMIT_CORE_O_TABLE where NODE_LEVEL !='7' and SANCTION_LIMIT='0';

--update LIMIT_CORE_O_TABLE set PARENT_LIMIT_PREFIX='' , PARENT_LIMIT_SUFFIX='' where NODE_LEVEL ='7' and SANCTION_LIMIT='0';

--COMMIT;



DROP TABLE CIF_GROUPS_DATA_MIG;

CREATE TABLE CIF_GROUPS_DATA_MIG AS SELECT * FROM CIF_GROUPS_DATA;

UPDATE CIF_GROUPS_DATA_MIG SET ENTITY_NAME='',ENTITY_REPORTING_ID='',ENTITY_ID='' WHERE ENTITY_NAME NOT IN(select a.ENTITY_NAME from (
(select ENTITY_NAME ,count(*) no_of_cif from CIF_GROUPS_DATA where ENTITY_NAME is not null group by ENTITY_NAME) a
inner join (
SELECT ENTITY_NAME,count(*) no_of_cif_limit FROM CIF_GROUPS_DATA 
INNER JOIN (SELECT DISTINCT LIMIT_PREFIX FROM LIMIT_CORE_TEMP_TABLE) ON LIMIT_PREFIX = ACCOUNT_NO 
GROUP BY ENTITY_NAME
) b on a.ENTITY_NAME = b.ENTITY_NAME
)
where --NO_OF_CIF = no_of_cif_limit and
 NO_OF_CIF != 1 and no_of_cif_limit!=1
);

UPDATE CIF_GROUPS_DATA_MIG SET GROUP_NAME='',GROUP_REPORTING_ID='',GROUP_ID='' WHERE GROUP_NAME NOT IN(
select a.GROUP_NAME from (
(select GROUP_NAME ,count(*) no_of_cif from CIF_GROUPS_DATA where GROUP_NAME is not null group by GROUP_NAME) a
inner join (
SELECT GROUP_NAME,count(*) no_of_cif_limit FROM CIF_GROUPS_DATA 
INNER JOIN (SELECT DISTINCT LIMIT_PREFIX FROM LIMIT_CORE_TEMP_TABLE) ON LIMIT_PREFIX = ACCOUNT_NO 
GROUP BY GROUP_NAME
) b on a.GROUP_NAME = b.GROUP_NAME
)
where NO_OF_CIF != 1 and no_of_cif_limit!=1
);

commit;


--LEVEL 2 (ENTITY LIMIT)
INSERT INTO LIMIT_CORE_O_TABLE
SELECT ENTITY_ID BORROWER_NAME,
       '2' NODE_LEVEL,
       ENTITY_ID LIMIT_PREFIX,
       'ENTTY' LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       CRNCY_CODE CRNCY_CODE,
       TRIM(GROUP_ID) PARENT_LIMIT_PREFIX,
       CASE WHEN TRIM(GROUP_ID) IS NOT NULL THEN 'GROUP' END PARENT_LIMIT_SUFFIX,
       SANCTION_LIMIT SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       LIMIT_APPROVAL_DATE LIMIT_APPROVAL_DATE,
       LIMIT_EXPIRY_DATE LIMIT_EXPIRY_DATE,
       LIMIT_REVIEW_DATE LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'G' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (SELECT TRIM(ENTITY_ID) ENTITY_ID,SANCTION_LIMIT SANCTION_LIMIT,
       'L2- Entity Limit' LIMIT_SUFFIX_DESC,
       LIMIT_EXPIRY_DATE, 
       LIMIT_REVIEW_DATE,
       LIMIT_APPROVAL_DATE,
       CRNCY_CODE,
       TRIM(GROUP_ID) GROUP_ID
       FROM CIF_GROUPS_DATA_MIG
       INNER JOIN MAP_CIF CIF ON TRIM(ACCOUNT_NO )= CIF.GFBRNM || CIF.GFCUS
       INNER JOIN LIMIT_CORE_O_TABLE LC ON LC.BORROWER_NAME = TRIM(ACCOUNT_NO) AND LC.NODE_LEVEL = '3'
       WHERE TRIM(ENTITY_ID) IS NOT NULL
       );
commit;       



UPDATE LIMIT_CORE_O_TABLE A SET (A.PARENT_LIMIT_SUFFIX,A.PARENT_LIMIT_PREFIX)=(
SELECT DISTINCT LIMIT_SUFFIX,ENTITY_ID FROM (
SELECT 'ENTTY' LIMIT_SUFFIX,TO_CHAR(TRIM(ACCOUNT_NO)) ACCOUNT_NO,TO_CHAR(TRIM(ENTITY_ID))ENTITY_ID  FROM CIF_GROUPS_DATA_MIG WHERE ENTITY_ID IS NOT NULL
UNION
SELECT 'GROUP',TO_CHAR(TRIM(ACCOUNT_NO)) ACCOUNT_NO,TO_CHAR(TRIM(GROUP_ID))GROUP_ID FROM CIF_GROUPS_DATA_MIG WHERE ENTITY_ID IS NULL AND GROUP_ID IS NOT NULL
) B WHERE A.BORROWER_NAME  = B.ACCOUNT_NO)
WHERE NODE_LEVEL='3' AND PARENT_LIMIT_PREFIX IS NULL;
UPDATE LIMIT_CORE_O_TABLE SET PARENT_LIMIT_SUFFIX='' WHERE PARENT_LIMIT_PREFIX IS NULL;

COMMIT;

--LEVEL 1 (GROUP LIMIT)
INSERT INTO LIMIT_CORE_O_TABLE
SELECT DISTINCT GROUP_ID BORROWER_NAME,
       '1' NODE_LEVEL,
       GROUP_ID LIMIT_PREFIX,
       'GROUP' LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       CRNCY_CODE CRNCY_CODE,
       '' PARENT_LIMIT_PREFIX,
       '' PARENT_LIMIT_SUFFIX,
       SANCTION_LIMIT SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       LIMIT_APPROVAL_DATE LIMIT_APPROVAL_DATE,
       LIMIT_EXPIRY_DATE LIMIT_EXPIRY_DATE,
       LIMIT_REVIEW_DATE LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'G' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (SELECT DISTINCT TRIM(GROUP_ID) GROUP_ID,SANCTION_LIMIT SANCTION_LIMIT,LC.BORROWER_NAME,
       'L1- Group Limit' LIMIT_SUFFIX_DESC,
       LIMIT_EXPIRY_DATE, 
       LIMIT_REVIEW_DATE,
       LIMIT_APPROVAL_DATE,
       CRNCY_CODE
       FROM CIF_GROUPS_DATA_MIG
       INNER JOIN LIMIT_CORE_O_TABLE LC ON LC.PARENT_LIMIT_PREFIX = TRIM(GROUP_ID) AND LC.NODE_LEVEL IN( '2','3') AND LC.PARENT_LIMIT_SUFFIX='GROUP'
       );
COMMIT;    


--LEVEL 0 (COUNTRY LIMIT)
INSERT INTO LIMIT_CORE_O_TABLE
SELECT  DISTINCT 
       TRIM(HHCNA) BORROWER_NAME,
       '0' NODE_LEVEL,
       TRIM(HHCNA)LIMIT_PREFIX,
       'CNTRY' LIMIT_SUFFIX,
       'L0-Country Limit' LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       '' PARENT_LIMIT_PREFIX,
       '' PARENT_LIMIT_SUFFIX,
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       '' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON trim(HPCNA) = trim(HHCNA) AND TRIM(HPCNA) IS NOT NULL AND TRIM(HPGRP) IS NULL
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY	   
 WHERE  trim(HHLC)='LG156' AND HHAMA <> 0 AND TRIM(HHCNA) IS NOT NULL AND TRIM(HHGRP) IS NULL and trim(HHCUS)  is null;
 
 COMMIT;

DECLARE
V_CCY_CNT NUMBER;
   CURSOR c1
   IS
        SELECT NODE_LEVEL,LIMIT_PREFIX,LIMIT_SUFFIX,MAX(CONV_TO_VALID_DATE(LIMIT_EXPIRY_DATE,'DD-MM-YYYY')) LIMIT_EXPIRY_DATE FROM LIMIT_CORE_O_TABLE GROUP BY NODE_LEVEL,LIMIT_PREFIX,LIMIT_SUFFIX HAVING COUNT(*)>1 order by NODE_LEVEL desc;
BEGIN

   FOR l_record IN c1
   LOOP
        SELECT COUNT(DISTINCT CRNCY_CODE) INTO V_CCY_CNT FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX;
   
        IF V_CCY_CNT = 1 THEN 
            
            UPDATE LIMIT_CORE_O_TABLE SET NOTES='U' ,SANCTION_LIMIT = (SELECT SUM(to_number(SANCTION_LIMIT)) FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX 
            AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX ) 
            WHERE  LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX AND CONV_TO_VALID_DATE(LIMIT_EXPIRY_DATE,'DD-MM-YYYY') = l_record.LIMIT_EXPIRY_DATE AND ROWNUM =1 ;
            COMMIT;
            
            delete from LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX and trim(NOTES) is null;
            
            --DELETE FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX AND SANCTION_LIMIT != (
            --SELECT MAX(TO_NUMBER(SANCTION_LIMIT)) FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX);                                                                              
            COMMIT;
            
        ELSE 
            UPDATE LIMIT_CORE_O_TABLE SET  NOTES='U' ,CRNCY_CODE= CASE WHEN GET_PARAM('BANK_ID') = '01' THEN 'KWD' WHEN GET_PARAM('BANK_ID') = '02' THEN 'AED' END ,
                                           SANCTION_LIMIT = (SELECT SUM(to_number(SANCTION_LIMIT) * TO_NUMBER (C8RTE)) FROM LIMIT_CORE_O_TABLE A
                                                             LEFT JOIN C8PF B ON A.CRNCY_CODE = B.C8CCY
                                                                WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX
                                                                  )
                        WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX AND CONV_TO_VALID_DATE(LIMIT_EXPIRY_DATE,'DD-MM-YYYY') = l_record.LIMIT_EXPIRY_DATE 
                        AND ROWNUM =1;
            COMMIT;
                              
            delete from LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX and trim(NOTES) is null;
            
           -- DELETE FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX AND (SANCTION_LIMIT != (
           -- SELECT MAX(TO_NUMBER(SANCTION_LIMIT)) FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX='GEREV' 
           -- and CRNCY_CODE = CASE WHEN GET_PARAM('BANK_ID') = '01' THEN 'KWD' WHEN GET_PARAM('BANK_ID') = '02' THEN 'AED' END) or 
           -- CRNCY_CODE != CASE WHEN GET_PARAM('BANK_ID') = '01' THEN 'KWD' WHEN GET_PARAM('BANK_ID') = '02' THEN 'AED' END);                                                              
           COMMIT;
        END IF;
        
   END LOOP;

   COMMIT;
END;

update LIMIT_CORE_O_TABLE set NOTES='';
commit;

DROP TABLE LIMIT_CORE_O_TABLE_BCK;

CREATE TABLE LIMIT_CORE_O_TABLE_BCK AS SELECT DISTINCT * FROM LIMIT_CORE_O_TABLE;
--COMMIT;

TRUNCATE TABLE LIMIT_CORE_O_TABLE;

INSERT INTO LIMIT_CORE_O_TABLE SELECT * FROM LIMIT_CORE_O_TABLE_BCK;
COMMIT;



DECLARE
V_CCY_CNT NUMBER;
   CURSOR c1
   IS
        SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,SUM(TO_NUMBER(SANCTION_LIMIT)) SANCTION_LIMIT  FROM LIMIT_CORE_O_TABLE 
            WHERE PARENT_LIMIT_PREFIX||PARENT_LIMIT_SUFFIX IN ( SELECT LIMIT_PREFIX||LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE  SANCTION_LIMIT='0')
            GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX having SUM(TO_NUMBER(SANCTION_LIMIT)) >0;

BEGIN

   FOR l_record IN c1
   LOOP
        SELECT COUNT(DISTINCT CRNCY_CODE) INTO V_CCY_CNT FROM LIMIT_CORE_O_TABLE WHERE  PARENT_LIMIT_SUFFIX=l_record.PARENT_LIMIT_SUFFIX and PARENT_LIMIT_PREFIX=l_record.PARENT_LIMIT_PREFIX ;
   
        IF V_CCY_CNT = 1 THEN 
            
             UPDATE LIMIT_CORE_O_TABLE A SET A.SANCTION_LIMIT = (
                SELECT SUM(TO_NUMBER(SANCTION_LIMIT)) FROM LIMIT_CORE_O_TABLE 
                LEFT JOIN C8PF B ON CRNCY_CODE = B.C8CCY
                WHERE PARENT_LIMIT_SUFFIX=l_record.PARENT_LIMIT_SUFFIX and PARENT_LIMIT_PREFIX=l_record.PARENT_LIMIT_PREFIX 
                ) where  LIMIT_SUFFIX = l_record.PARENT_LIMIT_SUFFIX and  LIMIT_PREFIX=l_record.PARENT_LIMIT_PREFIX;
            commit;
            
        ELSE 
            UPDATE LIMIT_CORE_O_TABLE A SET A.CRNCY_CODE= CASE WHEN GET_PARAM('BANK_ID') = '01' THEN 'KWD' WHEN GET_PARAM('BANK_ID') = '02' THEN 'AED' END ,A.SANCTION_LIMIT = (
                SELECT SUM(TO_NUMBER(SANCTION_LIMIT) * TO_NUMBER (C8RTE)) SANCTION_LIMIT  FROM LIMIT_CORE_O_TABLE 
                LEFT JOIN C8PF B ON CRNCY_CODE = B.C8CCY
                WHERE PARENT_LIMIT_SUFFIX=l_record.PARENT_LIMIT_SUFFIX and PARENT_LIMIT_PREFIX=l_record.PARENT_LIMIT_PREFIX 
                ) where  LIMIT_SUFFIX = l_record.PARENT_LIMIT_SUFFIX and  LIMIT_PREFIX=l_record.PARENT_LIMIT_PREFIX;
            commit;
        END IF;
        
   END LOOP;

END;

COMMIT;

DELETE FROM LIMIT_CORE_O_TABLE WHERE LIMIT_SUFFIX='GECSH' AND SANCTION_LIMIT='0' 
AND  (LIMIT_PREFIX||LIMIT_SUFFIX) NOT IN(
SELECT B.LIMIT_PREFIX||B.LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE  A
INNER JOIN (SELECT LIMIT_PREFIX,LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE LIMIT_SUFFIX='GECSH' AND SANCTION_LIMIT='0') B ON A.PARENT_LIMIT_PREFIX = B.LIMIT_PREFIX AND A.PARENT_LIMIT_SUFFIX = B.LIMIT_SUFFIX
);
COMMIT;

UPDATE LIMIT_CORE_O_TABLE SET SANCTION_LIMIT='0.001' WHERE SANCTION_LIMIT='0';
COMMIT;


delete from LIMIT_CORE_O_TABLE  where borrower_name='0603762840' and LIMIT_SUFFIX='GELCU' and PARENT_LIMIT_PREFIX is null;
commit;

update LIMIT_CORE_O_TABLE a set LIMIT_DESC=(select trim(LIMIT_SUFFIX_DESC) from LIMIT_SUFFIX_CODE_AND_DESC b where b.LIMIT_SUFFIX_CODE = a.limit_suffix) where  LIMIT_DESC is null;
commit;

--update LIMIT_CORE_O_TABLE set LIMIT_DESC='L'||NODE_LEVEL||'-'||LIMIT_SUFFIX where  LIMIT_DESC is null;
--commit;


--CHANGED ON 22-07-2117

--update LIMIT_CORE_O_TABLE set LIMIT_REVIEW_DATE = to_char(to_date(LIMIT_EXPIRY_DATE,'dd-mm-yyyy')-1,'dd-mm-yyyy') where to_date(LIMIT_EXPIRY_DATE,'dd-mm-yyyy') = to_date(LIMIT_REVIEW_DATE,'dd-mm-yyyy');
--commit;



--UPDATE LIMIT_CORE_O_TABLE A SET (LIMIT_EXPIRY_DATE ,LIMIT_REVIEW_DATE)=(SELECT LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM (SELECT BORROWER_NAME,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM LIMIT_CORE_O_TABLE B WHERE BORROWER_NAME IN(
--SELECT BORROWER_NAME FROM LIMIT_CORE_O_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND CONV_TO_VALID_DATE(B.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') < CONV_TO_VALID_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') and to_number(NODE_LEVEL)> 2)
--) AND  NODE_LEVEL='3') C WHERE  TRIM(A.BORROWER_NAME) = TRIM(C.BORROWER_NAME) ) 
--WHERE A.BORROWER_NAME IN(
--SELECT BORROWER_NAME FROM LIMIT_CORE_O_TABLE B WHERE  EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE A WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND CONV_TO_VALID_DATE(B.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') < CONV_TO_VALID_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY')) and  to_number(NODE_LEVEL)> 2
--);
--commit;

--update LIMIT_CORE_O_TABLE set LIMIT_EXPIRY_DATE='31-05-2017',LIMIT_REVIEW_DATE='31-05-2017' where limit_prefix='KW';



TRUNCATE TABLE LIMIT_ENTITY_AND_GROUP_MAP;     
INSERT INTO LIMIT_ENTITY_AND_GROUP_MAP 
select DISTINCT ENTITY_ID,ENTITY_NAME,ENTITY_REPORTING_ID,GROUP_ID,GROUP_NAME,GROUP_REPORTING_ID from CIF_GROUPS_DATA_MIG where ENTITY_NAME is not null AND GROUP_NAME IS NOT NULL ORDER BY GROUP_NAME;
COMMIT;


--NEED TO CHECK
--DELETE FROM LIMIT_CORE_O_TABLE WHERE BORROWER_NAME IN (
--SELECT BORROWER_NAME FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='1'
--MINUS
--SELECT DISTINCT PARENT_LIMIT_PREFIX FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='2' AND PARENT_LIMIT_PREFIX IS NOT NULL
--) AND NODE_LEVEL='1';
--COMMIT;

--------------------------------------------------------------------------------------


--update LIMIT_CORE_O_TABLE set PARENT_LIMIT_PREFIX='',PARENT_LIMIT_SUFFIX='' where limit_prefix='GRP793';--exception *******
--update LIMIT_CORE_O_TABLE set  LIMIT_EXPIRY_DATE='31-03-2018',LIMIT_REVIEW_DATE='30-03-2018' where BORROWER_NAME='KW';--exception *******

-----------------------------------------------------------------------------------------

truncate table BANK_RISK_PART_DATA;

insert into BANK_RISK_PART_DATA
select LIMIT_PREFIX, CRNCY_CODE, SANCTION_LIMIT, LIMIT_APPROVAL_DATE, LIMIT_EXPIRY_DATE, LIMIT_REVIEW_DATE from
LIMIT_CORE_temp_TABLE where LIMIT_STRUCTURE='BANKL' and LIMIT_SUFFIX='CUSTL' and PARENT_LIMIT_SUFFIX='GROUP';
 commit;

--MANUAL RISK PARTICIPATION LIMIT

INSERT INTO LIMIT_CORE_O_TABLE
SELECT a.LIMIT_PREFIX BORROWER_NAME,
       a.NODE_LEVEL,
       a.LIMIT_PREFIX,
       a.LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       a.CRNCY_CODE,
       a.PARENT_LIMIT_PREFIX,
       a.PARENT_LIMIT_SUFFIX,
       A.SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       a.LIMIT_APPROVAL_DATE,
       a.LIMIT_EXPIRY_DATE,
       a.LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (
       SELECT '7' NODE_LEVEL, LIMIT_PREFIX, 'RPBLG' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPTLG' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT ,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '7' NODE_LEVEL, LIMIT_PREFIX, 'RPBLC' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPTLC' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '7' NODE_LEVEL, LIMIT_PREFIX, 'RPBLO' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPBNL' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '6' NODE_LEVEL,LIMIT_PREFIX, 'RPTLG' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPNSH' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '6' NODE_LEVEL,LIMIT_PREFIX, 'RPTLC' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPNSH' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '6' NODE_LEVEL,LIMIT_PREFIX, 'RPBNL' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPNSH' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '5' NODE_LEVEL,LIMIT_PREFIX, 'RPNSH' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPATL' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '4' NODE_LEVEL,LIMIT_PREFIX, 'RPATL' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'CUSTL' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '3' NODE_LEVEL,LIMIT_PREFIX, 'CUSTL' LIMIT_SUFFIX, CRNCY_CODE, '' PARENT_LIMIT_PREFIX , '' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       ) A
       left join LIMIT_CORE_O_TABLE b on a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= a.LIMIT_SUFFIX
       where b.limit_prefix is null  ;
COMMIT;       




----CLA LIMIT(COMMITMENT)

drop table  COMMITMENT_LIMIT_DATA;

create table  COMMITMENT_LIMIT_DATA as
SELECT DISTINCT LCCMR,LCCCY, ORG_COMMITMENT_AMOUNT, LOAN_AMOUNT,COMMITMENT_TO_BE_DISB, LEG_INTERNAL_ACC_NUM ,
LEG_ACC_NUM, FIN_ACC_nUM, LEG_ACCT_TYPE,SCHM_CODE,FIN_CIF_ID,SCC2R--, G.SCC2R 
, expiry_date, First_drawdown_date ,
LIMIT_SUFFIX||(dense_rank() over(partition by FIN_CIF_ID,LIMIT_SUFFIX order by LCCMR ))
     LIMIT_SUFFIX,
      PARENT_LIMIT_SUFFIX
FROM (
select LCCMR,LCCCY,LCAMT/POWER(10,C8CED) ORG_COMMITMENT_AMOUNT,OTDLA/POWER(10,C8CED) LOAN_AMOUNT, LCAMTU/POWER(10,C8CED) COMMITMENT_TO_BE_DISB,LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS LEG_INTERNAL_ACC_NUM ,
to_char(LEG_ACC_NUM)LEG_ACC_NUM, FIN_ACC_nUM, LEG_ACCT_TYPE,SCHM_CODE,FIN_CIF_ID,C.SCC2R,
CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(LCDTEX),'YYYYMMDD')   expiry_date,CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(LCDTEF),'YYYYMMDD')   First_drawdown_date,
CASE WHEN TRIM(SCHM_CODE)='LF' AND LCCCY='KWD' THEN 'GTLH'
     WHEN TRIM(SCHM_CODE)='LF' AND LCCCY!='KWD' THEN 'GTLF'
     WHEN TRIM(SCHM_CODE)='LFR' AND LCCCY='KWD' THEN 'GRVH'
     WHEN TRIM(SCHM_CODE)='LFR' AND LCCCY!='KWD' THEN 'GRVF'
     WHEN TRIM(SCHM_CODE) in('LD','LDADV') AND LCCCY='KWD' THEN 'GLLH'
     WHEN TRIM(SCHM_CODE) in('LD','LDADV') AND LCCCY!='KWD' THEN 'GLLF'
     WHEN TRIM(SCHM_CODE) LIKE 'S%' AND LCCCY ='KWD' THEN 'SYLH'
     WHEN TRIM(SCHM_CODE) LIKE 'S%' AND LCCCY !='KWD' THEN 'SYLF'
     END LIMIT_SUFFIX,
     CASE WHEN TRIM(SCHM_CODE)='LF' THEN 'GETTL'
     WHEN TRIM(SCHM_CODE)='LFR' THEN 'GEREV'
     WHEN TRIM(SCHM_CODE) in('LD','LDADV') THEN 'GETLL'
     WHEN TRIM(SCHM_CODE) LIKE 'S%' THEN 'SYLOA'
     END PARENT_LIMIT_SUFFIX
FROM (select LEG_BRANCH_ID,LEG_SCAN,LEG_SCAS,case when SCHM_TYPE='PCA' then V5BRNM||V5DLP||V5DLR else to_nchar(LEG_ACC_NUM) end  LEG_ACC_NUM,FIN_CIF_ID,LEG_ACCT_TYPE,FIN_ACC_nUM,SCHM_TYPE,SCHM_CODE
FROM MAP_ACC 
left join v5pf on v5abd||V5AND||v5asd = LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS and SCHM_TYPE='PCA'
where SCHM_TYPE in('PCA','CLA') AND SCHM_CODE NOT IN ('BDT','LAC','CLM','WK')) 
LEFT  JOIN LDPF ON TRIM(LDBRNM)||TRIM(LDDLP)||TRIM(LDDLR)=TRIM(LEG_ACC_NUM)
LEFT JOIN  LCPF ON TRIM(LCCMR)=TRIM(LDCMR) and TRIM(LCAMT) <> 0
left JOIN C8PF ON LCCCY=C8CCY
INNER JOIN SCPF G ON G.SCAB||G.sCAN||G.SCAS=LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
left join SCPF C ON C.SCAB||C.sCAN||C.SCAS=LCABC||LCANC||LCASC
LEFT  JOIN OTPF ON OTBRNM||TRIM(OTDLP)||TRIM(OTDLR)=LEG_ACC_NUM
WHERE trim(LCCMR) is not null
union
select DISTINCT LCCMR,LCCCY,LCAMT/POWER(10,C8CED) ORG_COMMITMENT_AMOUNT,OTDLA/POWER(10,C8CED) LOAN_AMOUNT, LCAMTU/POWER(10,C8CED) COMMITMENT_TO_BE_DISB,LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS LEG_INTERNAL_ACC_NUM ,
to_char(LEG_ACC_NUM)LEG_ACC_NUM, FIN_ACC_nUM, LEG_ACCT_TYPE,SCHM_CODE,map_cif.FIN_CIF_ID,C.SCC2R
,CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(LCDTEX),'YYYYMMDD')   expiry_date,CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(LCDTEF),'YYYYMMDD')   First_drawdown_date,
CASE 
     WHEN TRIM(LCCMR) like 'LFR%' AND LCCCY='KWD' THEN 'GRVH'
     WHEN TRIM(LCCMR) like 'LFR%' AND LCCCY!='KWD' THEN 'GRVF'
     WHEN TRIM(LCCMR) like 'LD%' AND LCCCY='KWD' THEN 'GLLH'
     WHEN TRIM(LCCMR) like 'LD%' AND LCCCY!='KWD' THEN 'GLLF'
     WHEN TRIM(LCCMR) like 'LF%' AND LCCCY='KWD' THEN 'GTLH'
     WHEN TRIM(LCCMR) like 'LF%' AND LCCCY!='KWD' THEN 'GTLF'
     WHEN TRIM(LCCMR) LIKE 'S%' AND LCCCY ='KWD' THEN 'SYLH'
     WHEN TRIM(LCCMR) LIKE 'S%' AND LCCCY !='KWD' THEN 'SYLF'
     END LIMIT_SUFFIX,
     CASE WHEN TRIM(LCCMR) like 'LFR%' THEN 'GEREV'
     WHEN TRIM(LCCMR) like 'LF%' THEN 'GETTL'
     WHEN TRIM(LCCMR) like 'LD%' THEN 'GETLL'
     WHEN TRIM(LCCMR) LIKE 'S%' THEN 'SYLOA'
     END PARENT_LIMIT_SUFFIX
from lcpf 
left join c8pf on c8ccy = LCCCY
LEFT JOIN  LDPF ON TRIM(LCCMR)=TRIM(LDCMR)
left join map_cif on gfclc||gfcus = trim(lcclc)||trim(lccus)
left join map_acc on  TRIM(LDBRNM)||TRIM(LDDLP)||TRIM(LDDLR)=TRIM(LEG_ACC_NUM)
--INNER JOIN SCPF G ON G.SCAB||G.sCAN||G.SCAS=LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
left join SCPF C ON C.SCAB||C.sCAN||C.SCAS=LCABC||LCANC||LCASC
LEFT  JOIN OTPF ON OTBRNM||TRIM(OTDLP)||TRIM(OTDLR)=LEG_ACC_NUM
where lcamt= LCAMTU and lcamt <> 0);


truncate table LIMIT_CORE_O_TABLE_CLA;

INSERT INTO LIMIT_CORE_O_TABLE_CLA
SELECT distinct a.FIN_CIF_ID BORROWER_NAME,
       '7' NODE_LEVEL,
       a.FIN_CIF_ID LIMIT_PREFIX,
       a.LIMIT_SUFFIX LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       LCCCY CRNCY_CODE,
       a.FIN_CIF_ID PARENT_LIMIT_PREFIX,
       a.PARENT_LIMIT_SUFFIX,
       A.ORG_COMMITMENT_AMOUNT SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       TO_CHAR(FIRST_DRAWDOWN_DATE,'DD-MM-YYYY') LIMIT_APPROVAL_DATE,
       nvl(b.LIMIT_EXPIRY_DATE,GET_PARAM('EOD_DATE')) LIMIT_EXPIRY_DATE,
       nvl(b.LIMIT_REVIEW_DATE,TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY')) LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       LCCMR NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SCC2R Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (select LCCMR,FIN_CIF_ID,LCCCY,EXPIRY_DATE,FIRST_DRAWDOWN_DATE,LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,SCC2R,avg(ORG_COMMITMENT_AMOUNT) ORG_COMMITMENT_AMOUNT from COMMITMENT_LIMIT_DATA        
       group by LCCMR,FIN_CIF_ID,LCCCY,EXPIRY_DATE,FIRST_DRAWDOWN_DATE,LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,SCC2R) A
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= a.LIMIT_SUFFIX
       left join limit_core_o_table b on FIN_CIF_ID = limit_prefix and a.PARENT_LIMIT_SUFFIX = b.PARENT_LIMIT_SUFFIX;
       
       commit;
       
       
--drop table cla_cif_suffix;
       
--create table cla_cif_suffix as
--select a.LIMIT_PREFIX,a.PARENT_LIMIT_SUFFIX from (   
--       SELECT LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,sum(SANCTION_LIMIT*c8rte) commitment_amount FROM LIMIT_CORE_O_TABLE_CLA
--       left join c8pf on c8ccy = CRNCY_CODE
--        GROUP BY LIMIT_PREFIX,PARENT_LIMIT_SUFFIX
--       ) a
--       inner join (
--       select LIMIT_PREFIX,LIMIT_SUFFIX ,LIMIT_DESC,sum(SANCTION_LIMIT*c8rte)  SANCTION_LIMIT from LIMIT_CORE_INFY_TABLE 
--       left join c8pf on c8ccy = CRNCY_CODE 
--       where NODE_LEVEL='6' and limit_suffix in('GETTL','GEREV','GETLL','SYLOA')
--       group by LIMIT_PREFIX,LIMIT_SUFFIX ,LIMIT_DESC
--       ) b on a.LIMIT_PREFIX = b.LIMIT_PREFIX and a.PARENT_LIMIT_SUFFIX = b.LIMIT_SUFFIX
--       --where  round(a.commitment_amount-b.SANCTION_LIMIT,0) = 0 
--       ;   
--       
--delete LIMIT_CORE_O_TABLE where PARENT_LIMIT_PREFIX||PARENT_LIMIT_SUFFIX in(select LIMIT_PREFIX||PARENT_LIMIT_SUFFIX from cla_cif_suffix);
--commit;

--insert into LIMIT_CORE_O_TABLE
--select * from LIMIT_CORE_O_TABLE_CLA where PARENT_LIMIT_PREFIX||PARENT_LIMIT_SUFFIX in(select LIMIT_PREFIX||PARENT_LIMIT_SUFFIX from cla_cif_suffix);
--commit;


TRUNCATE TABLE MISSING_LIMIT_DIFF_CLA;

insert into MISSING_LIMIT_DIFF_CLA
select a.LIMIT_PREFIX,case when a.PARENT_LIMIT_SUFFIX='GETTL' then 'GTLH0' 
                           when a.PARENT_LIMIT_SUFFIX='GEREV' then 'GRVH0'
                           when a.PARENT_LIMIT_SUFFIX='GETLL' then 'GLLH0'
                           when a.PARENT_LIMIT_SUFFIX='SYLOA' then 'SYLF0' end limit_suffix,
nvl(b.CRNCY_CODE,'KWD')crncy_code,round(NVL(abs(a.commitment_amount-b.SANCTION_LIMIT),a.commitment_amount)/c8rte,C8CED) SANCTION_LIMIT,a.PARENT_LIMIT_SUFFIX from (   
       SELECT LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,sum(SANCTION_LIMIT*c8rte) commitment_amount FROM LIMIT_CORE_O_TABLE_CLA
       left join c8pf on c8ccy = CRNCY_CODE
        GROUP BY LIMIT_PREFIX,PARENT_LIMIT_SUFFIX
       ) a
       LEFT join (
       select LIMIT_PREFIX,LIMIT_SUFFIX ,LIMIT_DESC,sum(SANCTION_LIMIT*c8rte)  SANCTION_LIMIT,CRNCY_CODE from LIMIT_CORE_O_TABLE 
       left join c8pf on c8ccy = CRNCY_CODE 
       where NODE_LEVEL='6' and limit_suffix in('GETTL','GEREV','GETLL','SYLOA')
       group by LIMIT_PREFIX,LIMIT_SUFFIX ,LIMIT_DESC,CRNCY_CODE
       ) b on a.LIMIT_PREFIX = b.LIMIT_PREFIX and a.PARENT_LIMIT_SUFFIX = b.LIMIT_SUFFIX
       left join c8pf on c8ccy =  nvl(b.CRNCY_CODE,'KWD')
       where  round(a.commitment_amount-b.SANCTION_LIMIT,0) < 0 ;

COMMIT;
       
INSERT INTO MISSING_LIMIT_DIFF_CLA       
       SELECT LIMIT_PREFIX,LIMIT_SUFFIX,CRNCY_CODE,SANCTION_LIMIT,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE_CLA A WHERE  NOT EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE SANCTION_LIMIT != 0 and
        A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX )  AND PARENT_LIMIT_PREFIX IS NOT NULL AND NODE_LEVEL='7';    
COMMIT;        
       
DELETE FROM LIMIT_CORE_O_TABLE WHERE (PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) IN(SELECT DISTINCT FIN_CIF_ID,PARENT_LIMIT_SUFFIX FROM COMMITMENT_LIMIT_DATA );
COMMIT;
       
INSERT INTO LIMIT_CORE_O_TABLE_CLA       
       SELECT a.LIMIT_PREFIX BORROWER_NAME,
       a.NODE_LEVEL,
       a.LIMIT_PREFIX,
       a.LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       A.CRNCY_CODE,
       a.PARENT_LIMIT_PREFIX,
       a.PARENT_LIMIT_SUFFIX,
       A.SANCTION_AMOUNT SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY') LIMIT_APPROVAL_DATE,
       GET_PARAM('EOD_DATE') LIMIT_EXPIRY_DATE,
       TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY') LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (
     SELECT DISTINCT '7' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(NEW_LIMIT_SUFFIX) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,A.PARENT_LIMIT_SUFFIX PARENT_LIMIT_SUFFIX,CRNCY_CODE,1*SANCTION_AMOUNT SANCTION_AMOUNT  FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT FROM MISSING_LIMIT_DIFF_CLA) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        union 
     select NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE, sum(SANCTION_AMOUNT) SANCTION_AMOUNT from(
        SELECT DISTINCT '6' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(c.LEVEL_6) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(c.LEVEL_6_PARENT) PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT  FROM MISSING_LIMIT_DIFF_CLA) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =  NVL(TRIM(b.LEVEL_7_PARENT),A.PARENT_LIMIT_SUFFIX)
        )group by NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE
        union
        select NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE, sum(SANCTION_AMOUNT) SANCTION_AMOUNT from( 
        SELECT DISTINCT '5' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(d.LEVEL_5) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(d.LEVEL_5_PARENT) PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT  FROM MISSING_LIMIT_DIFF_CLA) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =   NVL(TRIM(b.LEVEL_7_PARENT),A.PARENT_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        )group by NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE
        union
        select NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE, sum(SANCTION_AMOUNT) SANCTION_AMOUNT from(          
        SELECT DISTINCT '4' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(e.LEVEL_4) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(e.LEVEL_4_PARENT) PARENT_LIMIT_SUFFIX,CRNCY_CODE, SANCTION_AMOUNT FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT  FROM MISSING_LIMIT_DIFF_CLA) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =   NVL(TRIM(b.LEVEL_7_PARENT),A.PARENT_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        LEFT JOIN LIMIT_MAPPING e ON TRIM(e.LEVEL_4) =  TRIM(d.LEVEL_5_PARENT)
        )group by NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE
        union 
        select NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE, sum(SANCTION_AMOUNT) SANCTION_AMOUNT from( 
        SELECT DISTINCT '3' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(f.LEVEL_3) LIMIT_SUFFIX ,'' PARENT_LIMIT_PREFIX ,'' PARENT_LIMIT_SUFFIX,CRNCY_CODE, SANCTION_AMOUNT FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT  FROM MISSING_LIMIT_DIFF_CLA) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =   NVL(TRIM(b.LEVEL_7_PARENT),A.PARENT_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        LEFT JOIN LIMIT_MAPPING e ON TRIM(e.LEVEL_4) =  TRIM(d.LEVEL_5_PARENT)
        LEFT JOIN LIMIT_MAPPING f ON TRIM(f.LEVEL_3) =  TRIM(e.LEVEL_4_PARENT)
        )group by NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE
        ) a
        left join LIMIT_CORE_O_TABLE b on a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix --AND B.node_level!='7'
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= a.LIMIT_SUFFIX
       LEFT JOIN LIMIT_CORE_O_TABLE_CLA C ON a.limit_prefix = C.limit_prefix and a.limit_suffix = C.limit_suffix
       where b.limit_prefix is null AND c.limit_prefix is null;
commit;

update LIMIT_CORE_O_TABLE_CLA set LIMIT_DESC='L7- Gen Term Loan HCCY-diff Cmt' where LIMIT_SUFFIX='GLLH0' and LIMIT_DESC is null;
update LIMIT_CORE_O_TABLE_CLA set LIMIT_DESC='L7- Gen Rev Loan HCCY-diff Cmt' where LIMIT_SUFFIX='GRVH0' and LIMIT_DESC is null;
update LIMIT_CORE_O_TABLE_CLA set LIMIT_DESC='L7- Gen Term Loan HCCY-diff Cmt' where LIMIT_SUFFIX='GTLH0' and LIMIT_DESC is null;
update LIMIT_CORE_O_TABLE_CLA set LIMIT_DESC='L7- Syndication Loan HCCY-diff Cmt' where LIMIT_SUFFIX='SYLF0' and LIMIT_DESC is null;

--delete LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN (SELECT LIMIT_PREFIX,LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE_CLA);
--commit;

UPDATE LIMIT_CORE_O_TABLE_CLA A SET (LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) = (SELECT LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM(
SELECT A.LIMIT_PREFIX,A.LIMIT_SUFFIX,B.LIMIT_APPROVAL_DATE,B.LIMIT_EXPIRY_DATE,B.LIMIT_REVIEW_DATE FROM LIMIT_CORE_O_TABLE_CLA A
LEFT JOIN LIMIT_CORE_O_TABLE B ON A.PARENT_LIMIT_PREFIX = B.LIMIT_PREFIX AND A.PARENT_LIMIT_SUFFIX = B.LIMIT_SUFFIX 
 WHERE A.LIMIT_EXPIRY_DATE IS NULL  
 ) B WHERE A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX
 ) WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
 SELECT A.LIMIT_PREFIX,A.LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE_CLA A
LEFT JOIN LIMIT_CORE_O_TABLE B ON A.PARENT_LIMIT_PREFIX = B.LIMIT_PREFIX AND A.PARENT_LIMIT_SUFFIX = B.LIMIT_SUFFIX 
 WHERE A.LIMIT_EXPIRY_DATE IS NULL);

commit;
 
insert into LIMIT_CORE_O_TABLE
select * from LIMIT_CORE_O_TABLE_CLA ;
commit;


-- ODA ZERO LIMIT

truncate table MISSING_LIMIT;

insert into MISSING_LIMIT
SELECT TO_NCHAR(MAP_CIF.FIN_CIF_ID) NEW_LIMIT_PREFIX,CASE WHEN IBD_CUSTOMER.FIN_CIF_ID IS NOT NULL THEN 'GEVOD' ELSE 'GEODR' END NEW_LIMIT_SUFFIX,'KWD' CRNCY_CODE FROM MAP_ACC 
LEFT JOIN MAP_CIF ON MAP_ACC.FIN_CIF_ID = MAP_CIF.FIN_CIF_ID
LEFT JOIN LIMIT_CORE_O_TABLE ON TRIM(LIMIT_PREFIX)  = TRIM(MAP_ACC.FIN_CIF_ID) AND NODE_LEVEL='7' AND LIMIT_SUFFIX IN('GEODR','GEVOD')
LEFT JOIN IBD_CUSTOMER ON IBD_CUSTOMER.FIN_CIF_ID = MAP_CIF.FIN_CIF_ID
WHERE SCHM_TYPE='ODA' AND LIMIT_PREFIX IS NULL
and (MAP_CIF.FIN_CIF_ID,CASE WHEN IBD_CUSTOMER.FIN_CIF_ID IS NOT NULL THEN 'GEVOD' ELSE 'GEODR' END ) not in(select NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX from MISSING_LIMIT);

commit;


--FT MISSING LIMIT NODE

insert into MISSING_LIMIT
SELECT distinct NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,case when  b.LIMIT_PREFIX is not null then b.CRNCY_CODE else to_nchar('KWD') end CRNCY_CODE FROM TF_MISSING_LIMIT a
left join (
SELECT distinct a.LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE A
INNER JOIN (
SELECT LIMIT_PREFIX FROM (SELECT DISTINCT LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='7') GROUP BY LIMIT_PREFIX HAVING COUNT(*)=1
) B ON A.LIMIT_PREFIX = B.LIMIT_PREFIX
) b on a.NEW_LIMIT_PREFIX = b.LIMIT_PREFIX
where (NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX) not in(select NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX from MISSING_LIMIT)
; 

commit;



INSERT INTO LIMIT_CORE_O_TABLE
SELECT a.LIMIT_PREFIX BORROWER_NAME,
       a.NODE_LEVEL,
       a.LIMIT_PREFIX,
       a.LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       'KWD' CRNCY_CODE,
       a.PARENT_LIMIT_PREFIX,
       a.PARENT_LIMIT_SUFFIX,
       '0.001' SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY') LIMIT_APPROVAL_DATE,
       GET_PARAM('EOD_DATE') LIMIT_EXPIRY_DATE,
       TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY') LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (
     SELECT DISTINCT '7' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(NEW_LIMIT_SUFFIX) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(LEVEL_7_PARENT) PARENT_LIMIT_SUFFIX FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX FROM MISSING_LIMIT) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        union 
     SELECT DISTINCT '6' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(c.LEVEL_6) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(c.LEVEL_6_PARENT) PARENT_LIMIT_SUFFIX FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX FROM MISSING_LIMIT) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =  TRIM(b.LEVEL_7_PARENT)
        union 
        SELECT DISTINCT '5' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(d.LEVEL_5) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(d.LEVEL_5_PARENT) PARENT_LIMIT_SUFFIX FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX FROM MISSING_LIMIT) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =  TRIM(b.LEVEL_7_PARENT)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        union         
        SELECT DISTINCT '4' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(e.LEVEL_4) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(e.LEVEL_4_PARENT) PARENT_LIMIT_SUFFIX FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX FROM MISSING_LIMIT) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =  TRIM(b.LEVEL_7_PARENT)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        LEFT JOIN LIMIT_MAPPING e ON TRIM(e.LEVEL_4) =  TRIM(d.LEVEL_5_PARENT)
        union 
        SELECT DISTINCT '3' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(f.LEVEL_3) LIMIT_SUFFIX ,'' PARENT_LIMIT_PREFIX ,'' PARENT_LIMIT_SUFFIX FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX FROM MISSING_LIMIT) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =  TRIM(b.LEVEL_7_PARENT)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        LEFT JOIN LIMIT_MAPPING e ON TRIM(e.LEVEL_4) =  TRIM(d.LEVEL_5_PARENT)
        LEFT JOIN LIMIT_MAPPING f ON TRIM(f.LEVEL_3) =  TRIM(e.LEVEL_4_PARENT)
        ) a
        left join LIMIT_CORE_O_TABLE b on a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= a.LIMIT_SUFFIX
       where b.limit_prefix is null ;
       
COMMIT;



update LIMIT_CORE_O_TABLE set limit_suffix='GLLF0' where limit_suffix='GELLF';
update LIMIT_CORE_O_TABLE set limit_suffix='GLLH0' where limit_suffix='GELLH';
update LIMIT_CORE_O_TABLE set limit_suffix='GRVF0' where limit_suffix='GERVF';
update LIMIT_CORE_O_TABLE set limit_suffix='GRVH0' where limit_suffix='GERVH';
update LIMIT_CORE_O_TABLE set limit_suffix='GTLF0' where limit_suffix='GETLF';
update LIMIT_CORE_O_TABLE set limit_suffix='GTLH0' where limit_suffix='GETLH';
update LIMIT_CORE_O_TABLE set limit_suffix='SYLH0' where limit_suffix='SYLHC';
update LIMIT_CORE_O_TABLE set limit_suffix='SYLF0' where limit_suffix='SYLFC';

commit;



--CONVERTING MULTI CURRENCY TO SINGLE CURRENCY 


DROP TABLE CORP_KWD_EQU_LIMIT;

CREATE TABLE CORP_KWD_EQU_LIMIT AS
SELECT NODE_LEVEL,LIMIT_PREFIX,LIMIT_SUFFIX,'KWD' NEW_CRNCY_CODE,ROUND(SANCTION_LIMIT*C8RTE,3) KWD_EQU_AMT FROM (
SELECT * FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX  in(select LIMIT_PREFIX from (SELECT distinct LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE WHERE node_level='7' ) group by  LIMIT_PREFIX having count(*) > 1)
AND NODE_LEVEL IN('6','5','4','3')
UNION
SELECT * FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX  in(select LIMIT_PREFIX from (SELECT distinct LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE WHERE node_level='7' ) group by  LIMIT_PREFIX having count(*) > 1)
AND NODE_LEVEL ='3' AND TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
)
UNION
SELECT * FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX  in(select LIMIT_PREFIX from (SELECT distinct LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE WHERE node_level='7' ) group by  LIMIT_PREFIX having count(*) > 1)
AND NODE_LEVEL ='3' AND  TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
)AND NODE_LEVEL ='2' AND  TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
) 
UNION
SELECT * FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN( 
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX  in(select LIMIT_PREFIX from (SELECT distinct LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE WHERE node_level='7' ) group by  LIMIT_PREFIX having count(*) > 1)
AND NODE_LEVEL ='3' AND  TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
)AND NODE_LEVEL ='2' AND  TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
) AND NODE_LEVEL ='1' AND  TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
)
)
LEFT JOIN C8PF ON TRIM(C8CCY) = TRIM(CRNCY_CODE)
 WHERE CRNCY_CODE <> 'KWD' and NODE_LEVEL != 0;


UPDATE LIMIT_CORE_O_TABLE  A SET (CRNCY_CODE,SANCTION_LIMIT) =(SELECT NEW_CRNCY_CODE,KWD_EQU_AMT FROM CORP_KWD_EQU_LIMIT B WHERE A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX )
WHERE (A.LIMIT_PREFIX,A.LIMIT_SUFFIX) IN(SELECT LIMIT_PREFIX,LIMIT_SUFFIX FROM CORP_KWD_EQU_LIMIT);

COMMIT;

--------------------Exception
--update LIMIT_CORE_O_TABLE set PARENT_LIMIT_PREFIX='',PARENT_LIMIT_SUFFIX='' where PARENT_LIMIT_PREFIX='RU';
--commit;
---

update LIMIT_CORE_O_TABLE set COMMITTED_LINES='Y' where NODE_LEVEL='3';
commit;

--LINKING TO COUNTRY LIMIT FOR FCCY CORPORATE CUSTOMER 
UPDATE LIMIT_CORE_O_TABLE X SET (PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) =( SELECT GFCNAR ,'CNTRY' FROM(
SELECT DISTINCT FIN_CIF_ID,GFCNAR FROM HHPF_MIG a
inner join gfpf b on  a.hhclc||a.hhcus  = b.gfclc||b.gfcus
INNER JOIN MAP_CIF ON MAP_CIF.GFCLC||MAP_CIF.GFCUS = a.hhclc||a.hhcus 
INNER JOIN LIMIT_CORE_O_TABLE ON LIMIT_PREFIX = FIN_CIF_ID AND NODE_LEVEL='3' AND PARENT_LIMIT_PREFIX IS NULL
WHERE HHCLC||HHCUS NOT IN(SELECT GFCLC||GFCUS FROM IBD_CUSTOMER) AND GFCNAR<>'KW'
) Y WHERE  X.LIMIT_PREFIX = Y.FIN_CIF_ID)
WHERE X.LIMIT_PREFIX IN(
SELECT DISTINCT FIN_CIF_ID FROM HHPF_MIG a
inner join gfpf b on  a.hhclc||a.hhcus  = b.gfclc||b.gfcus
INNER JOIN MAP_CIF ON MAP_CIF.GFCLC||MAP_CIF.GFCUS = a.hhclc||a.hhcus 
INNER JOIN LIMIT_CORE_O_TABLE ON LIMIT_PREFIX = FIN_CIF_ID AND NODE_LEVEL='3' AND PARENT_LIMIT_PREFIX IS NULL
WHERE HHCLC||HHCUS NOT IN(SELECT GFCLC||GFCUS FROM IBD_CUSTOMER) AND GFCNAR<>'KW'
) AND X.NODE_LEVEL='3';
COMMIT;


TRUNCATE TABLE LIMIT_CORE_INFY_TABLE;
INSERT INTO LIMIT_CORE_INFY_TABLE
   SELECT BORROWER_NAME,
          NODE_LEVEL,
          LIMIT_PREFIX,
          LIMIT_SUFFIX,
          LIMIT_DESC,
          CRNCY_CODE,
          PARENT_LIMIT_PREFIX,
          PARENT_LIMIT_SUFFIX,
          SANCTION_LIMIT,
          DRAWING_POWER_IND,
          TO_DATE(LIMIT_APPROVAL_DATE,'DD-MM-YYYY'),
          TO_DATE(LIMIT_EXPIRY_DATE,'DD-MM-YYYY'),
          TO_DATE(LIMIT_REVIEW_DATE,'DD-MM-YYYY'),
          APPROVAL_AUTH_CODE,
          APPROVAL_LEVEL,
          LIMIT_APPROVAL_REF,
          NOTES,
          TERMS_AND_CONDITIONS,
          LIMIT_TYPE,
          LOAN_TYPE,
          MASTER_LIMIT_NODE,
          MIN_COLL_VALUE_BASED_ON,
          DRWNG_POWER_PCNT,
          PATTERN_OF_FUNDING,
          DEBIT_ACCOUNT_FOR_FEES,
          COMMITTED_LINES,
          TO_DATE(CONTRACT_SIGN_DATE,'DD-MM-YYYY'),
          UPLOAD_STATUS,
          COND_PRECEDENT_FLG,
          GLOBAL_LIMIT_FLG,
          --MAIN_PRODUCT_TYPE,
          --PROJECT_NAME,
          --PRODUCT_NAME,
          --PURPOSE_OF_LIMIT,
          BANK_ID
     FROM LIMIT_CORE_O_TABLE;


TRUNCATE TABLE LIMIT_ENTITY_AND_GROUP_MAP;     
INSERT INTO LIMIT_ENTITY_AND_GROUP_MAP 
select DISTINCT ENTITY_ID,ENTITY_NAME,ENTITY_REPORTING_ID,GROUP_ID,GROUP_NAME,GROUP_REPORTING_ID from CIF_GROUPS_DATA where ENTITY_NAME is not null AND GROUP_NAME IS NOT NULL ORDER BY GROUP_NAME;
COMMIT;

--update expiry and review date from parent to child if parent expiry date is lesser than child

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='1' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='1' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='2' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='2' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='3' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='3' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='4' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='4' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='5' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='5' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='6' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='6' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='7' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='7' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_O_TABLE a set  (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
SELECT A.NODE_LEVEL,A.LIMIT_PREFIX,A.LIMIT_SUFFIX,to_char(B.LIMIT_EXPIRY_DATE,'dd-mm-yyyy') LIMIT_EXPIRY_DATE,to_char(b.LIMIT_REVIEW_DATE,'dd-mm-yyyy' ) LIMIT_REVIEW_DATE FROM LIMIT_CORE_O_TABLE A
LEFT JOIN LIMIT_CORE_INFY_TABLE B ON A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX
WHERE TO_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') != B.LIMIT_EXPIRY_DATE 
) b where a.LIMIT_PREFIX = b.LIMIT_PREFIX and a.LIMIT_SUFFIX = b.LIMIT_SUFFIX
)
where (LIMIT_PREFIX,LIMIT_SUFFIX) in(
SELECT A.LIMIT_PREFIX,A.LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE A
LEFT JOIN LIMIT_CORE_INFY_TABLE B ON A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX
WHERE TO_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') != B.LIMIT_EXPIRY_DATE 
);

commit;

--update expiry and review date from child to parent if parent expiry date is lesser than child

--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='7'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='7');
--
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='6'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='6');
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='5'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='5');
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='4'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='4');
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='3'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='3');
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='2'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='2');
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='1'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='1');
--
--
--update LIMIT_CORE_O_TABLE a set  (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT A.NODE_LEVEL,A.LIMIT_PREFIX,A.LIMIT_SUFFIX,to_char(B.LIMIT_EXPIRY_DATE,'dd-mm-yyyy') LIMIT_EXPIRY_DATE,to_char(b.LIMIT_REVIEW_DATE,'dd-mm-yyyy' ) LIMIT_REVIEW_DATE FROM LIMIT_CORE_O_TABLE A
--LEFT JOIN LIMIT_CORE_INFY_TABLE B ON A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX
--WHERE TO_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') != B.LIMIT_EXPIRY_DATE 
--) b where a.LIMIT_PREFIX = b.LIMIT_PREFIX and a.LIMIT_SUFFIX = b.LIMIT_SUFFIX
--)
--where (LIMIT_PREFIX,LIMIT_SUFFIX) in(
--SELECT A.LIMIT_PREFIX,A.LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE A
--LEFT JOIN LIMIT_CORE_INFY_TABLE B ON A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX
--WHERE TO_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') != B.LIMIT_EXPIRY_DATE 
--);
--
--commit;

TRUNCATE TABLE LIMIT_CORE_NOTES_O_TABLE;
INSERT INTO LIMIT_CORE_NOTES_O_TABLE 
SELECT DISTINCT FIN_CIF_ID BORROWER_NAME,
                TRIM(HPCF1) NOTE1,
                TRIM(HPCF2) NOTE2,
                TRIM(HPCF3) NOTE3
  FROM HPPF
       INNER JOIN MAP_CIF ON TRIM (GFCUS) || TRIM (GFCLC) = TRIM (HPCUS) || TRIM (HPCLC)
       INNER JOIN LIMIT_CORE_O_TABLE ON BORROWER_NAME = FIN_CIF_ID
 WHERE    TRIM (HPCF1) IS NOT NULL OR TRIM (HPCF2) IS NOT NULL OR TRIM (HPCF3) IS NOT NULL;
 
INSERT INTO LIMIT_CORE_NOTES_O_TABLE  
 SELECT DISTINCT GROUP_ID BORROWER_NAME,
                TRIM(HPCF1) NOTE1,
                TRIM(HPCF2) NOTE2,
                TRIM(HPCF3) NOTE3 FROM HPPF
 INNER JOIN GROUP_MASTER_O_TABLE ON TRIM(HPGRP) = TRIM(REPORTING_GROUP_ID)
    WHERE TRIM (HPCF1) IS NOT NULL OR TRIM (HPCF2) IS NOT NULL OR TRIM (HPCF3) IS NOT NULL;
    
INSERT INTO LIMIT_CORE_NOTES_O_TABLE     
     SELECT DISTINCT HPCNA BORROWER_NAME,
                TRIM(HPCF1) NOTE1,
                TRIM(HPCF2) NOTE2,
                TRIM(HPCF3) NOTE3 FROM HPPF
 INNER JOIN LIMIT_CORE_O_TABLE ON TRIM(HPCNA) = TRIM(BORROWER_NAME)
    WHERE (TRIM (HPCF1) IS NOT NULL OR TRIM (HPCF2) IS NOT NULL OR TRIM (HPCF3) IS NOT NULL)  AND TRIM(HPCNA) IS NOT NULL AND TRIM(HPGRP) IS NULL AND  TRIM(HPCUS) IS NULL;
 COMMIT;
 
update LIMIT_CORE_O_TABLE set limit_prefix=trim(limit_prefix)||'01',BORROWER_NAME=trim(BORROWER_NAME)||'01' where limit_suffix='CNTRY';
update LIMIT_CORE_O_TABLE set parent_limit_prefix=trim(parent_limit_prefix)||'01' where parent_limit_suffix='CNTRY';
update LIMIT_CORE_INFY_TABLE set limit_prefix=trim(limit_prefix)||'01',BORROWER_NAME=trim(BORROWER_NAME)||'01' where limit_suffix='CNTRY';
update LIMIT_CORE_INFY_TABLE set parent_limit_prefix=trim(parent_limit_prefix)||'01' where parent_limit_suffix='CNTRY';
UPDATE LIMIT_CORE_NOTES_O_TABLE SET LIMIT_PREFIX=LIMIT_PREFIX||'01' WHERE LENGTH(TRIM(LIMIT_PREFIX))=2;
 
exit;


-------------------------------------------------------------------------------------------------     

--UPDATE limit_mapping SET LIMIT_LINE = TRIM(LIMIT_LINE), LIMIT_STRUCTURE= TRIM(LIMIT_STRUCTURE), LINE_DESCRIPTION= TRIM(LINE_DESCRIPTION), LEVEL_7= TRIM(LEVEL_7), LEVEL_6= TRIM(LEVEL_6)
--, LEVEL_5= TRIM(LEVEL_5), LEVEL_4= TRIM(LEVEL_4), LEVEL_3= TRIM(LEVEL_3), LEVEL_2= TRIM(LEVEL_2),
-- LEVEL_1= TRIM(LEVEL_1), LEVEL_7_PARENT= TRIM(LEVEL_7_PARENT), LEVEL_6_PARENT= TRIM(LEVEL_6_PARENT), LEVEL_5_PARENT= TRIM(LEVEL_5_PARENT)
-- , LEVEL_4_PARENT= TRIM(LEVEL_4_PARENT), LEVEL_3_PARENT= TRIM(LEVEL_3_PARENT), LEVEL_2_PARENT= TRIM(LEVEL_2_PARENT), IS_ZERO_LIMIT_REQ= TRIM(IS_ZERO_LIMIT_REQ);
-- COMMIT;

--VALIDATIONS

--SELECT * FROM LIMIT_CORE_O_TABLE A WHERE  SANCTION_LIMIT != 0 and 
-- NOT EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE SANCTION_LIMIT != 0 and A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX ) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL 

--SELECT * FROM LIMIT_CORE_O_TABLE A WHERE 
-- NOT EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX ) 
--AND LIMIT_PREFIX IS NOT NULL AND NODE_LEVEL!='7'

--SELECT * FROM LIMIT_CORE_O_TABLE A WHERE 
-- NOT EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX ) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL

--SELECT * FROM LIMIT_CORE_O_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND CONV_TO_VALID_DATE(B.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') < CONV_TO_VALID_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY')) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL

--SELECT * FROM LIMIT_CORE_infy_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_infy_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND (B.LIMIT_EXPIRY_DATE) < (A.LIMIT_EXPIRY_DATE)) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL

--select * from LIMIT_CORE_infy_TABLE where  LIMIT_APPROVAL_DATE>=LIMIT_EXPIRY_DATE;

--select * from LIMIT_CORE_INFY_TABLE where LIMIT_APPROVAL_DATE > LIMIT_EXPIRY_DATE

--SELECT * FROM LIMIT_CORE_O_TABLE A WHERE   CONV_TO_VALID_DATE(LIMIT_EXPIRY_DATE,'DD-MM-YYYY') < CONV_TO_VALID_DATE(LIMIT_REVIEW_DATE,'DD-MM-YYYY');

--select  * from LIMIT_CORE_O_TABLE where  BORROWER_NAME||LIMIT_PREFIX||LIMIT_SUFFIX in(
--select BORROWER_NAME||LIMIT_PREFIX||LIMIT_SUFFIX from LIMIT_CORE_O_TABLE group by BORROWER_NAME||LIMIT_PREFIX||LIMIT_SUFFIX having count(*) > 1)

--select * from LIMIT_CORE_O_TABLE where borrower_name in(
--SELECT borrower_name FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_APPROVAL_DATE is null or LIMIT_EXPIRY_DATE is null) );

--edit LIMIT_CORE_O_TABLE where LIMIT_PREFIX in(
--select LIMIT_PREFIX from LIMIT_CORE_O_TABLE where borrower_name in(
--SELECT borrower_name FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_APPROVAL_DATE is null or LIMIT_EXPIRY_DATE is null) )
--and SANCTION_LIMIT !='0');
--
--edit LIMIT_CORE_infy_TABLE where LIMIT_PREFIX in(
--select LIMIT_PREFIX from LIMIT_CORE_infy_TABLE where borrower_name in(
--SELECT borrower_name FROM LIMIT_CORE_infy_TABLE WHERE (LIMIT_APPROVAL_DATE is null or LIMIT_EXPIRY_DATE is null) )
--and SANCTION_LIMIT !='0');

--select * from LIMIT_CORE_O_TABLE where LIMIT_PREFIX in(
--select LIMIT_PREFIX from LIMIT_CORE_O_TABLE where borrower_name in(
--SELECT borrower_name FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_APPROVAL_DATE is null or LIMIT_EXPIRY_DATE is null) )
--and SANCTION_LIMIT !='0');

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='6' and BORROWER_NAME not in (select BORROWER_NAME from LIMIT_CORE_O_TABLE where node_level='7');

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='5' and BORROWER_NAME not in (select BORROWER_NAME from LIMIT_CORE_O_TABLE where node_level='6');

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='4' and BORROWER_NAME not in (select BORROWER_NAME from LIMIT_CORE_O_TABLE where node_level='5');

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='3' and BORROWER_NAME not in (select BORROWER_NAME from LIMIT_CORE_O_TABLE where node_level='4');

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='3' and BORROWER_NAME not in (select BORROWER_NAME from LIMIT_CORE_O_TABLE where node_level='4');


--select * from LIMIT_CORE_O_TABLE where LIMIT_DESC is null;

--select * from LIMIT_CORE_O_TABLE where SANCTION_LIMIT='0.001';

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL||LIMIT_PREFIX||LIMIT_SUFFIX NOT IN (
--SELECT NODE_LEVEL||LIMIT_PREFIX||LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE A
--LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC B ON SUBSTR(B.LIMIT_SUFFIX_DESC,2,1) = A.NODE_LEVEL AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX_CODE);

--select HHCUS from (select distinct HHCUS,HHCCY from hhpf where HHLC in( 'LS096', 'LG083') and hhama <> 0) group by HHCUS having count(*)>1

--select distinct LIMIT_SUFFIX from limit_core_o_table where limit_suffix not in(
--select REF_CODE from tbaadm.rct where REF_REC_TYPE='57' and bank_id='01'
--)

--select LIMIT_SUFFIX_CODE,count(*) from LIMIT_SUFFIX_CODE_AND_DESC group by LIMIT_SUFFIX_CODE having count(*)>1

--select * from map_acc
--left join LIMIT_LINKAGE_TO_ACCT_O_TABLE on fin_acc_num = acct_num 
--where  schm_type='ODA' and limit_prefix is null

--UPDATE CHECK

--delete  LIMIT_CORE_infy_TABLE where LIMIT_PREFIX in(
--SELECT LIMIT_PREFIX FROM LIMIT_CORE_infy_TABLE A WHERE 
-- NOT EXISTS (SELECT * FROM LIMIT_CORE_infy_TABLE B WHERE B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX ) 
--AND LIMIT_PREFIX IS NOT NULL AND NODE_LEVEL!='7' and LIMIT_SUFFIX='GECSH' and LIMIT_PREFIX not in('0900067347','0900136048')
--) and LIMIT_SUFFIX in('GECSH','GENRL');
--
--
--delete  LIMIT_CORE_o_TABLE where LIMIT_PREFIX in(
--SELECT LIMIT_PREFIX FROM LIMIT_CORE_o_TABLE A WHERE 
-- NOT EXISTS (SELECT * FROM LIMIT_CORE_o_TABLE B WHERE B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX ) 
--AND LIMIT_PREFIX IS NOT NULL AND NODE_LEVEL not in('7','0') and LIMIT_SUFFIX='GECSH' and LIMIT_PREFIX not in('0900067347','0900136048')
--) and LIMIT_SUFFIX in('GECSH','GENRL'); 
