
-- File Name        : Custom_lcu001_upload.sql
-- File Created for : Lockers Customisation
-- Created By       : Sharanappa
-- Client           : ABK
-- Created On       : 10-21-2016
-------------------------------------------------------------------
truncate table custom_lcu001_o_table;
insert into custom_lcu001_o_table
select distinct  
-- SOL_ID                          NVARCHAR2(8),
lpad(nvl(map_sol.fin_sol_id,' '),8,' '),
--  CIF_ID                          NVARCHAR2(32),
lpad(nvl(map_acc.fin_cif_id,' '),32,' '),
--  CUSTOMER_NAME                   NVARCHAR2(80),
lpad(nvl(trim(CIF_NAME),' '),80,' '),
--  LOCKER_TYPE                     NVARCHAR2(10),
lpad(nvl(CASE WHEN trim(SDBTYP)='120X60' THEN TO_CHAR('60X120') ELSE TO_CHAR(trim(SDBTYP)) END,' '),10,' '),
--  LOCKER_NO                       NVARCHAR2(10),
rpad(lpad(nvl(to_char(SDBNBR),' '),4,'0'),10,' '),
--  JOINT_HOLDERNAME_1              NVARCHAR2(80),
lpad(' ',80,' '),--JOINT_HOLDER_NAME1***
--  JOINT_HOLDER_CIF_ID_1           NVARCHAR2(32),
lpad(' ',32,' '),
--  JOINT_HOLDER_RELATION_1         NVARCHAR2(5),
lpad(' ',5,' '),
--  JOINT_HOLDER_NAME_2             NVARCHAR2(80),
lpad(' ',80,' '),
--  JOINT_HOLDER_CIF_ID_2           NVARCHAR2(32),
lpad(' ',32,' '),
--  JOINT_HOLDER_RELATION_2         NVARCHAR2(5),
lpad(' ',5,' '),
--  JOINT_HOLDER_NAME_3             NVARCHAR2(80),
lpad(' ',80,' '),
--  JOINT_HOLDER_CIF_ID_3           NVARCHAR2(32),
lpad(' ',32,' '),
--  JOINT_HOLDER_RELATION_3         NVARCHAR2(5),
lpad(' ',5,' '),
--  OPACC                           NVARCHAR2(16),
lpad(nvl(map_acc.fin_acc_num,' '),16,' '),
--  SDACC                           NVARCHAR2(16),
lpad(' ',16,' '),
--  CODE_WORD                       NVARCHAR2(80),
RPAD('1234',80,' '), --trim(CODE_WORD)
--  OPEN_DATE                       NVARCHAR2(10),
lpad(case when trim(SDBSDT) is not null then nvl(to_char(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBSDT)),'YYYYMMDD'),'DD-MM-YYYY'),' ') else ' ' end ,10,' '),
--  CLOSED_DATE                     NVARCHAR2(10),
lpad('31-12-2099',10,' '),----NEED TO CHECK
--  FREQUENCY                       NVARCHAR2(2),
lpad('YR',2,' '),--NEED TO CHECK
--  TOTAL_RENT                      NVARCHAR2(17),
RPAD(NVL(
case when  
 CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD') > to_date(get_param('EOD_DATE'),'dd-mm-yyyy') then 
 (floor(months_between(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD') , CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBSDT)),'YYYYMMDD')) /12)+1)*case when STAFF_FLAG is null then SDPFEE else SDPSFE end/C8pwd
 else 
 (floor(months_between( to_date(get_param('EOD_DATE'),'dd-mm-yyyy') , CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBSDT)),'YYYYMMDD')) /12)+1)*case when STAFF_FLAG is null then SDPFEE else SDPSFE end/C8pwd
 end,'0.001'),17,' '),--TRIM(TOTAL_RENT)
--  REMARKS                         NVARCHAR2(100),
lpad(nvl(trim(SDBNR1)||' '||trim(SDBNR2)||' '||trim(SDBNR3),' '),100,' '),    
--  LAST_RENT_DATE                  NVARCHAR2(10),
lpad(case when trim(SDBLFD) is not null then nvl(to_char(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBLFD)),'YYYYMMDD'),'DD-MM-YYYY'),nvl(to_char(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBSDT)),'YYYYMMDD'),'DD-MM-YYYY'),' ')) else ' ' end,10,' '),
--lpad(regexp_replace(trim(LAST_RENT_DATE),'[A-Z,a-z,/]',''),10,' '),***
--  DUE_DATE                        NVARCHAR2(10),
lpad(case when trim(SDBNFD) is not null then nvl(to_char(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD'),'DD-MM-YYYY'),' ') else ' ' end,10,' '),
--lpad(regexp_replace(trim(DUE_DATE),'[A-Z,a-z,/]',''),10,' '),***
--  DUE_NOTICE_DATE                 NVARCHAR2(10),
lpad(case when trim(SDBNFD) is not null then nvl(to_char(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD'),'DD-MM-YYYY'),' ') else ' ' end,10,' '),--NEED TO CHECK ***
--  DUE_RENT                        NVARCHAR2(17),
LPAD(nvl(case when  
 CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD') > to_date(get_param('EOD_DATE'),'dd-mm-yyyy') then case when STAFF_FLAG is null then SDPFEE else SDPSFE end/C8pwd
 else 
 (floor(months_between(to_date(get_param('EOD_DATE'),'dd-mm-yyyy') , CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD')) /12)+2)*case when STAFF_FLAG is null then SDPFEE else SDPSFE end/C8pwd
 --to_date(get_param('EOD_DATE'),'dd-mm-yyyy') - CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD')
 end,'0.001'),17,' '),
--  DELETE_FLAG                     NVARCHAR2(1),
lpad('N',1,' '),
--  FREE_TEXT_1                     NVARCHAR2(15),
lpad(' ',15,' '),
--  FREE_TEXT_2                     NVARCHAR2(15),
lpad(' ',15,' '),
--  PAYMENT_MODE                    NVARCHAR2(1),
lpad('T',1,' '),-- (trim(PAYMENT_MODE)
--  PAYMENT_DATE                    NVARCHAR2(10),
lpad(case when trim(SDBNFD) is not null then to_char(to_date(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end ,10,' '),
--  RENT_PAID                       NVARCHAR2(17),
lpad('0.01',17,' '),
--  PREFERABLE_LANGUAGE_CODE        NVARCHAR2(10),
lpad(' ',10,' '),
--  CUSTOMER_NAMEIN_PREF_LANG_CODE  NVARCHAR2(80),
lpad(' ',80,' '),
-- MODE_OF_OPER_CODE               NVARCHAR2(5)
lpad('999',5,' ')
from YSDBPF
inner JOIN NEPF ON TRIM(SDBEAN) = TRIM(NEEAN)
inner join scpf on SCAB||SCAN||SCAS=NEAB||NEAN||NEAS
inner join map_sol on br_code=SDBBRNM
inner join map_acc  on SCAB||SCAN||SCAS=LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
inner join map_cif on  trim(MAP_CIF.FIN_CIF_ID) = trim(map_acc.FIN_CIF_ID) and is_joint<>'Y'
LEFT JOIN C8PF ON C8CCY = 'KWD'
left join YSDPPF on trim(SDPTYP) = trim(SDBTYP)
left JOIN CU1_O_TABLE b ON TRIM (b.ORGKEY) = TRIM (map_cif.fin_cif_id) and trim(STAFF_FLAG) = 'Y';
commit;
--delete from custom_lcu001_o_table where length(trim(LAST_RENT_DATE))<10;
--commit;

--delete SDB_JOINT where RELATED_CUS='627878' and RELATIONSHIP='SMN'

update custom_lcu001_o_table set RENT_PAID = lpad(nvl(TOTAL_RENT - case when DUE_RENT = 0.001 then 0 else to_number(DUE_RENT) end ,'0.01'),17,' ');
commit;

truncate table SDB_JOINT;

insert into SDB_JOINT
SELECT fin_acc_num ACC_NUM ,trim(YSDBPF.SDBBRNM), trim(YSDBPF.SDBTYP), trim(YSDBPF.SDBNBR) ,trim(scctp)    ,trim(gfpf.gfcus),trim(gfpf.gfclc),                                                     
  trim(rjrcus),trim(rjrclc),trim(rjrel),  trim(rireld) FROM ysdbpf 
left outer join nepf on trim(neean)=trim(sdbean) 
left outer join scpf on trim(scab)=trim(neab) and trim(scan)=trim(nean) and trim(scas)=trim(neas)
inner join map_acc on scab||scan||scas =  LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
left join c4pf on trim(scctp)=trim(c4ctp)         
left join gfpf on trim(gfcpnc) = trim(scan) 
left outer join rjpf on  (rjcus =gfcus and rjclc = gfclc)                                 
left outer join ripf on rirel = rjrel                                    
inner join map_cif on map_cif.gfclc||map_cif.gfcus = trim(rjrclc)||trim(rjrcus)
where scctp = 'EJ' ;
commit;
delete from SDB_JOINT where CUS||CUS_LOC||RELATED_CUS||RELATIONSHIP='627877600627878JNP';
commit;

UPDATE custom_lcu001_o_table A SET (JOINT_HOLDER_CIF_ID_1,JOINT_HOLDER_RELATION_1,JOINT_HOLDERNAME_1) = 
(SELECT lpad(CASE WHEN TRIM(B.RELATED_CUS) IS NOT NULL THEN to_char('0'||TRIM(B.RELATED_CUS_LOC)||TRIM(B.RELATED_CUS)) ELSE ' ' END,32,' '),lpad(NVL(TRIM(RELATIONSHIP),' '),5,' '),lpad(nvl(JOINT_HOLDER_NAME,' '),80,' ') FROM 
(SELECT  ACC_NUM, BOX_BRANCH, BOX_TYPE, BOX_NUMBER, CUSTOMER_TYPE, CUS, CUS_LOC, RELATED_CUS, RELATED_CUS_LOC, FIN_CODE RELATIONSHIP, FIN_CODE_DESC RELATIONSHIP_DESC,DENSE_RANK() OVER(PARTITION BY CUS ORDER BY RELATED_CUS) JOINT_HOLDER_NUM,lpad(coalesce(to_char(trim(CUST_FIRST_NAME)),to_char(trim(CORPORATE_NAME)),to_char(' ')),80,' ') JOINT_HOLDER_NAME  FROM SDB_JOINT A
left join cu1_o_table on '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = ORGKEY
left join cu1corp_o_table on  '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = corp_key
left join map_codes on trim(LEG_CODE) = trim(relationship))B 
WHERE    TRIM(A.OPACC) = trim(B.ACC_NUM) AND B.JOINT_HOLDER_NUM='1'  AND TRIM(A.LOCKER_NO) = TRIM(lpad(nvl(trim(to_char(B.BOX_NUMBER)),' '),4,'0'))
);

commit;


UPDATE custom_lcu001_o_table A SET (JOINT_HOLDER_CIF_ID_2,JOINT_HOLDER_RELATION_2,JOINT_HOLDER_NAME_2) = 
(SELECT lpad(CASE WHEN TRIM(B.RELATED_CUS) IS NOT NULL THEN to_char('0'||TRIM(B.RELATED_CUS_LOC)||TRIM(B.RELATED_CUS)) ELSE ' ' END,32,' '),lpad(NVL(TRIM(RELATIONSHIP),' '),5,' '), 
lpad(nvl(JOINT_HOLDER_NAME,' '),80,' ')  FROM 
(SELECT  ACC_NUM, BOX_BRANCH, BOX_TYPE, BOX_NUMBER, CUSTOMER_TYPE, CUS, CUS_LOC, RELATED_CUS, RELATED_CUS_LOC, FIN_CODE RELATIONSHIP, FIN_CODE_DESC RELATIONSHIP_DESC,DENSE_RANK() OVER(PARTITION BY CUS ORDER BY RELATED_CUS) JOINT_HOLDER_NUM,lpad(coalesce(to_char(trim(CUST_FIRST_NAME)),to_char(trim(CORPORATE_NAME)),to_char(' ')),80,' ') JOINT_HOLDER_NAME  FROM SDB_JOINT A
left join cu1_o_table on '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = ORGKEY
left join cu1corp_o_table on  '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = corp_key
left join map_codes on trim(LEG_CODE) = trim(relationship))B 
WHERE    TRIM(A.OPACC) = trim(B.ACC_NUM) AND B.JOINT_HOLDER_NUM='2'  AND TRIM(A.LOCKER_NO) = TRIM(lpad(nvl(trim(to_char(B.BOX_NUMBER)),' '),4,'0'))
);
commit;

UPDATE custom_lcu001_o_table A SET (JOINT_HOLDER_CIF_ID_3,JOINT_HOLDER_RELATION_3,JOINT_HOLDER_NAME_3) = 
(SELECT lpad(CASE WHEN TRIM(B.RELATED_CUS) IS NOT NULL THEN to_char('0'||TRIM(B.RELATED_CUS_LOC)||TRIM(B.RELATED_CUS)) ELSE ' ' END,32,' '),lpad(NVL(TRIM(RELATIONSHIP),' '),5,' '),lpad(nvl(JOINT_HOLDER_NAME,' '),80,' ') FROM 
(SELECT  ACC_NUM, BOX_BRANCH, BOX_TYPE, BOX_NUMBER, CUSTOMER_TYPE, CUS, CUS_LOC, RELATED_CUS, RELATED_CUS_LOC, FIN_CODE RELATIONSHIP, FIN_CODE_DESC RELATIONSHIP_DESC,DENSE_RANK() OVER(PARTITION BY CUS ORDER BY RELATED_CUS) JOINT_HOLDER_NUM,lpad(coalesce(to_char(trim(CUST_FIRST_NAME)),to_char(trim(CORPORATE_NAME)),to_char(' ')),80,' ') JOINT_HOLDER_NAME  FROM SDB_JOINT A
left join cu1_o_table on '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = ORGKEY
left join cu1corp_o_table on  '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = corp_key
left join map_codes on trim(LEG_CODE) = trim(relationship))B 
WHERE    TRIM(A.OPACC) = trim(B.ACC_NUM) AND B.JOINT_HOLDER_NUM='3'  AND TRIM(A.LOCKER_NO) = TRIM(lpad(nvl(trim(to_char(B.BOX_NUMBER)),' '),4,'0'))
);

commit;


update custom_lcu001_o_table set  JOINT_HOLDERNAME_1 =  lpad(nvl(JOINT_HOLDERNAME_1,' '),80,' '), JOINT_HOLDER_CIF_ID_1 =  lpad(nvl(JOINT_HOLDER_CIF_ID_1,' '),32,' '), JOINT_HOLDER_RELATION_1 =  lpad(nvl(JOINT_HOLDER_RELATION_1,' '),5,' '),
 JOINT_HOLDER_NAME_2 =  lpad(nvl(JOINT_HOLDER_NAME_2,' '),80,' '), JOINT_HOLDER_CIF_ID_2 =  lpad(nvl(JOINT_HOLDER_CIF_ID_2,' '),32,' '), JOINT_HOLDER_RELATION_2  =  lpad(nvl(JOINT_HOLDER_RELATION_2,' '),5,' '),
  JOINT_HOLDER_NAME_3 =  lpad(nvl(JOINT_HOLDER_NAME_3,' '),80,' '), JOINT_HOLDER_CIF_ID_3 =  lpad(nvl(JOINT_HOLDER_CIF_ID_3,' '),32,' '), JOINT_HOLDER_RELATION_3  =  lpad(nvl(JOINT_HOLDER_RELATION_3,' '),5,' '),
  TOTAL_RENT = RPAD(case when trim(TOTAL_RENT)='0' then '0.01' else to_char(trim(TOTAL_RENT)) end,17,' '),
  DUE_RENT = RPAD(case when trim(DUE_RENT)='0' then '0.01' else to_char(trim(DUE_RENT)) end,17,' '),
  RENT_PAID = RPAD(case when trim(RENT_PAID)='0' then '0.01' else to_char(trim(RENT_PAID)) end,17,' ')
;  

commit;  


truncate table LOCKER_STAFF;

insert into LOCKER_STAFF
 SELECT trim(SOL_ID) SOL_ID,
       trim(LOCKER_TYPE) LOCKER_TYPE,
       trim(LOCKER_NO) LOCKER_NO,
       trim(a.cif_id) CUST_ID,
       trim(STAFF_FLAG) STAFF_FLG,
       trim(STAFFEMPLOYEEID) STAFF_NO,
       SDPSFE/1000 RENT_AMOUNT_CHARGED,
       SDPSFE/SDPFEE*100 PERCENT_RENT,
       TO_DATE(trim(OPEN_DATE),'DD-MM-YYYY') START_DATE,
       TO_DATE(trim(CLOSED_DATE),'DD-MM-YYYY') END_DATE,
       '' REMARKS,
       '' LCHG_TIME,
       '' LCHG_USER_ID,
       '' RCRE_TIME,
       '' RCRE_USER_ID,
       'N' DEL_FLG,
       '' FREE_TEXT1,
       '' FREE_TEXT2,
       '1' TS_CNT,
       get_param('BANK_ID') BANK_ID
  FROM CUSTOM_LCU001_O_TABLE a
       INNER JOIN CU1_O_TABLE b ON TRIM (b.ORGKEY) = TRIM (a.cif_id)
       left join YSDPPF on  CASE WHEN trim(SDPTYP)='120X60' THEN TO_CHAR('60X120') ELSE TO_CHAR(trim(SDPTYP)) END = trim(LOCKER_TYPE)
 WHERE STAFF_FLAG = 'Y';
 commit;

 truncate table C_LCKR_INS_FLG_TBL;

insert into C_LCKR_INS_FLG_TBL
SELECT map_sol.fin_sol_id SOL_ID,
       CASE WHEN trim(SDBTYP)='120X60' THEN TO_CHAR('60X120') ELSE TO_CHAR(trim(SDBTYP)) END LOCKER_TYPE,
       lpad(nvl(to_char(SDBNBR),' '),4,'0') LOCKER_NO,
       map_acc.fin_cif_id CIF_ID,
       trim(SDBINSC) INS_FLG,
       '01' BANK_ID,
       '' RCRE_USER_ID,
       '' RCRE_TIME,
       '' LCHG_USER_ID,
       '' LCHG_TIME
  FROM YSDBPF
inner JOIN NEPF ON TRIM(SDBEAN) = TRIM(NEEAN)
inner join scpf on SCAB||SCAN||SCAS=NEAB||NEAN||NEAS
inner join map_sol on br_code=SDBBRNM
inner join map_acc  on SCAB||SCAN||SCAS=LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
inner join map_cif on  trim(MAP_CIF.FIN_CIF_ID) = trim(map_acc.FIN_CIF_ID) and is_joint<>'Y';
commit;

truncate table C_LCKR_POA_DTS_TBL;

insert into C_LCKR_POA_DTS_TBL
SELECT map_sol.fin_sol_id SOL_ID,
       CASE
          WHEN TRIM (SDBTYP) = '120X60' THEN TO_CHAR ('60X120')
          ELSE TO_CHAR (TRIM (SDBTYP))
       END
          LOCKER_TYPE,
       LPAD (NVL (TO_CHAR (SDBNBR), ' '), 4, '0') LOCKER_NO,
       map_acc.fin_cif_id CIF_ID,
       poa1 POA1,
       POA2 POA2,
       POA3 POA3,
       '01' BANK_ID,
       '' RCRE_USER_ID,
       '' RCRE_TIME,
       '' LCHG_USER_ID,
       '' LCHG_TIME,
       'N' DEL_FLG
  FROM YSDBPF INNER JOIN NEPF ON TRIM (SDBEAN) = TRIM (NEEAN)inner join scpf on SCAB||SCAN||SCAS=NEAB||NEAN||NEAS
inner join map_sol on br_code=SDBBRNM
inner join map_acc  on SCAB||SCAN||SCAS=LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
inner join map_cif on  trim(MAP_CIF.FIN_CIF_ID) = trim(map_acc.FIN_CIF_ID) and is_joint<>'Y'
inner join (select BRANCH,ACCOUNT_NUMBER,BOX_NO,'0'||min(clc||cust) poa1,case when count(*)>1  and count(*)<3 then '0'||max(clc||cust) end poa2,case when count(*)>2 then '0'||max(clc||cust) end poa3 from locker_poa 
where clc||cust is not null
group by BRANCH,ACCOUNT_NUMBER,BOX_NO) po_loc on po_loc.ACCOUNT_NUMBER=map_acc.fin_acc_num and po_loc.BOX_NO=trim(SDBNBR)
where SDBPOA='Y';
 
exit;

--validation
--select a.* from CUSTOM_LCU001_O_TABLE a
--left join tbaadm.sdlkm b  on bank_id='01' and trim(a.LOCKER_TYPE) = trim(b.LOCKER_TYPE) and trim(a.LOCKER_NO) =trim(b.LOCKER_NO) and trim(a.SOL_ID) = trim(b.SOL_ID) 
--where b.SOL_ID is null
--union
--select a.* from CUSTOM_LCU001_O_TABLE a
--left join map_acc b on trim(a.OPACC) = fin_acc_num
--where CURRENCY <> 'KWD'

--select a.SOL_ID, a.CIF_ID, a.CUSTOMER_NAME, a.LOCKER_TYPE, a.LOCKER_NO,A.OPACC ACCOUNT_NUMBER, 'Locker sol_id, locker type and locker number combination not present in BPD' reason_for_failure from CUSTOM_LCU001_O_TABLE a
--left join tbaadm.sdlkm b  on bank_id='01' and trim(a.LOCKER_TYPE) = trim(b.LOCKER_TYPE) and trim(a.LOCKER_NO) =trim(b.LOCKER_NO) and trim(a.SOL_ID) = trim(b.SOL_ID) 
--where b.SOL_ID is null
--union
--select a.SOL_ID, a.CIF_ID, a.CUSTOMER_NAME, a.LOCKER_TYPE, a.LOCKER_NO,A.OPACC ACCOUNT_NUMBER,'Non KWD currency account number'  reason_for_failure from CUSTOM_LCU001_O_TABLE a
--left join map_acc b on trim(a.OPACC) = fin_acc_num
--where CURRENCY <> 'KWD'
--order by  reason_for_failure 
