-- File Name        : cc9_upload_kw.sql
-- File Created for    : Upload file for Group and CIF mapping
-- Created By        : Sharanappa
-- Client            : ABK
-- Created On        : 09-03-2017
-------------------------------------------------------------------
truncate table CU9CORP_O_TABLE;
INSERT INTO CU9CORP_O_TABLE
SELECT distinct MAP_CIF.FIN_CIF_ID ORGKEY,
       trim(ENTITY_REPORTING_ID) GROUPHOUSEHOLDCODE,
       MAP_CIF.FIN_CIF_ID CMNE,
       '' SHAREHOLDING_IN_PERCENTAGE,
       '' TEXT1,
       '' TEXT2,
       '' TEXT3,
       '' DATE1,
       '' DATE2,
       '' DATE3,
       '' DROPDOWN1,
       '' DROPDOWN2,
       '' DROPDOWN3,
       '' LOOKUP1,
       '' LOOKUP2,
       '' LOOKUP3,
       ENTITY_NAME GROUPHOUSEHOLDNAME,
       '01' BANK_ID,
       ENTITY_ID,
       'Y' PRIMARY_GROUP_INDICATOR
  FROM CIF_GROUPS_DATA
  INNER JOIN MAP_CIF ON trim(GFBRNM)||trim(GFCUS) = trim(ACCOUNT_NO)
  where trim(ENTITY_NAME) IS NOT NULL;
  --and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
  
COMMIT;  
  
  
INSERT INTO CU9CORP_O_TABLE
SELECT distinct MAP_CIF.FIN_CIF_ID ORGKEY,
       GROUP_REPORTING_ID GROUPHOUSEHOLDCODE,
       MAP_CIF.FIN_CIF_ID CMNE,
       '' SHAREHOLDING_IN_PERCENTAGE,
       '' TEXT1,
       '' TEXT2,
       '' TEXT3,
       '' DATE1,
       '' DATE2,
       '' DATE3,
       '' DROPDOWN1,
       '' DROPDOWN2,
       '' DROPDOWN3,
       '' LOOKUP1,
       '' LOOKUP2,
       '' LOOKUP3,
       GROUP_NAME GROUPHOUSEHOLDNAME,
       '01' BANK_ID,
       GROUP_ID GROUP_NAME,
       'Y' PRIMARY_GROUP_INDICATOR
  FROM CIF_GROUPS_DATA
  INNER JOIN MAP_CIF ON trim(GFBRNM)||trim(GFCUS) = trim(ACCOUNT_NO)
  where trim(GROUP_REPORTING_ID) IS NOT NULL; 
  --and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
  
COMMIT;  
  
  INSERT INTO CU9CORP_O_TABLE
  SELECT DISTINCT MAP_CIF.FIN_CIF_ID ORGKEY,
       REPORTING_GROUP_ID GROUPHOUSEHOLDCODE,
       CMNE,
       '' SHAREHOLDING_IN_PERCENTAGE,
       '' TEXT1,
       '' TEXT2,
       '' TEXT3,
       '' DATE1,
       '' DATE2,
       '' DATE3,
       '' DROPDOWN1,
       '' DROPDOWN2,
       '' DROPDOWN3,
       '' LOOKUP1,
       '' LOOKUP2,
       '' LOOKUP3,
       GROUP_NAME GROUPHOUSEHOLDNAME,
       '01' BANK_ID,
       GROUP_ID,
       'Y' PRIMARY_GROUP_INDICATOR
  FROM GROUP_MASTER_O_TABLE A
  LEFT JOIN CRGM ON TRIM(CRGM.GRPID) =  TRIM(A.REPORTING_GROUP_ID)
  LEFT JOIN CUST ON TRIM (CNO) = TRIM (GRPMEMBER)
  LEFT JOIN GFPF ON TRIM (GFOCID) = TRIM (CMNE)
  LEFT JOIN MAP_CIF ON trim(gfpf.gfclc)=trim(map_cif.gfclc) and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
  WHERE MAP_CIF.FIN_CIF_ID IS NOT NULL;
  --and is_joint<>'Y'-------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
  
  commit;
  
  
  INSERT INTO CU9CORP_O_TABLE
  SELECT DISTINCT MAP_CIF.FIN_CIF_ID ORGKEY,
       REPORTING_GROUP_ID GROUPHOUSEHOLDCODE,
       NVL(TRIM(GFPF.GFOCID),MAP_CIF.FIN_CIF_ID),
       '' SHAREHOLDING_IN_PERCENTAGE,
       '' TEXT1,
       '' TEXT2,
       '' TEXT3,
       '' DATE1,
       '' DATE2,
       '' DATE3,
       '' DROPDOWN1,
       '' DROPDOWN2,
       '' DROPDOWN3,
       '' LOOKUP1,
       '' LOOKUP2,
       '' LOOKUP3,
       GROUP_NAME GROUPHOUSEHOLDNAME,
       '01' BANK_ID,
       A.GROUP_ID,
       'Y' PRIMARY_GROUP_INDICATOR
  FROM GROUP_MASTER_O_TABLE A
  LEFT JOIN GFPF ON TRIM(GFPF.GFGRP) =  TRIM(A.REPORTING_GROUP_ID)
  LEFT JOIN MAP_CIF ON trim(gfpf.gfclc)=trim(map_cif.gfclc) and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
  LEFT JOIN CU9CORP_O_TABLE C ON  TRIM(C.ORGKEY) = TRIM(MAP_CIF.FIN_CIF_ID) AND TRIM(GROUPHOUSEHOLDCODE)=TRIM(REPORTING_GROUP_ID) AND TRIM(C.CMNE)=NVL(TRIM(GFPF.GFOCID),MAP_CIF.FIN_CIF_ID) 
  AND TRIM(C.GROUP_ID) =TRIM(A.GROUP_ID)
  WHERE MAP_CIF.FIN_CIF_ID IS NOT NULL AND C.ORGKEY IS NULL;-------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic  
  --and is_joint<>'Y'
  
  COMMIT;
  
  exit;