
--drop table cla_free_text;
--create table cla_free_text as select * from (
--select distinct fin_acc_num,lccmr,lcnr text1,lcnr1||' '||lcnr2 text2,lcnr3||' '||lcnr4 text3,DENSE_RANK() OVER(PARTITION BY fin_acc_num ORDER BY lccmr)  serial_details from map_acc c
--inner join ld_deal_int_wise a on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and c.leg_acc_num=to_char(serial_deal)
--inner join ldpf on ldbrnm||trim(lddlp)||trim(lddlr)=a.leg_acc_num
--inner join lcpf on lccmr=ldcmr);
--
--
--TRUNCATE TABLE FREETEXT_O_TABLE;
--
--INSERT INTO FREETEXT_O_TABLE
-- SELECT DISTINCT
--       RPAD (NVL (a.FIN_ACC_NUM, ' '), 16, ' ') ACID,
--       RPAD (NVL(a.text1,' '), 80, ' ') FREE_TEXT_1,
--       RPAD (NVL(a.text2,' '), 80, ' ') FREE_TEXT_2,
--       RPAD (NVL(a.text3,' '), 80, ' ') FREE_TEXT_3,
--       RPAD (case when b.SERIAL_DETAILS is not null  then to_char(NVL(b.text1,' ')) else ' ' end, 80, ' ') FREE_TEXT_4,
--       RPAD (case when b.SERIAL_DETAILS is not null  then to_char(NVL(b.text2,' ')) else ' ' end, 80, ' ') FREE_TEXT_5,
--       RPAD (case when b.SERIAL_DETAILS is not null  then to_char(NVL(b.text3,' ')) else ' ' end, 80, ' ') FREE_TEXT_6,
--       RPAD (case when c.SERIAL_DETAILS is not null  then to_char(NVL(c.text1,' ')) else ' ' end, 80, ' ') FREE_TEXT_7,
--       RPAD (case when c.SERIAL_DETAILS is not null  then to_char(NVL(c.text2,' ')) else ' ' end, 80, ' ') FREE_TEXT_8,
--       RPAD (case when c.SERIAL_DETAILS is not null  then to_char(NVL(c.text3,' ')) else ' ' end, 80, ' ') FREE_TEXT_9,
--       RPAD (case when d.SERIAL_DETAILS is not null  then to_char(NVL(d.text1,' ')) else ' ' end, 80, ' ') FREE_TEXT_10,
--       RPAD (case when d.SERIAL_DETAILS is not null  then to_char(NVL(d.text2,' ')) else ' ' end, 80, ' ') FREE_TEXT_11,
--       RPAD (case when d.SERIAL_DETAILS is not null  then to_char(NVL(d.text3,' ')) else ' ' end, 80, ' ') FREE_TEXT_12,
--       RPAD (case when e.SERIAL_DETAILS is not null  then to_char(NVL(e.text1,' ')) else ' ' end, 80, ' ') FREE_TEXT_13,
--       RPAD (case when e.SERIAL_DETAILS is not null  then to_char(NVL(e.text2,' ')) else ' ' end, 80, ' ') FREE_TEXT_14,
--       RPAD (case when last_6_digit is not null then to_char('.'||last_6_digit) else ' ' end, 80, ' ') FREE_TEXT_15
-- from cla_free_text a
--  left join cla_free_text b on a.fin_acc_num=b.fin_acc_num and b.SERIAL_DETAILS=2
--  left join cla_free_text c on a.fin_acc_num=c.fin_acc_num and c.SERIAL_DETAILS=3
--  left join cla_free_text d on a.fin_acc_num=d.fin_acc_num and d.SERIAL_DETAILS=4
--  left join cla_free_text e on a.fin_acc_num=d.fin_acc_num and e.SERIAL_DETAILS=5
--  left join (select distinct fin_acc_num,last_6_digit from (
--select  distinct a.fin_acc_num,leg_branch_id||leg_scan||leg_scas leg_acc_num,
--  lccmr commitment_ref_no,text1,text2,text3,substr(trim(text3),length(trim(text3))-5,6) last_6_digit from cla_free_text a 
--  inner join map_Acc b on a.fin_acc_num=b.fin_acc_num and SCHM_TYPE <> 'OOO'
--  left join ld_deal_int_wise c on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and to_char(serial_deal)=b.leg_acc_num 
--  left join ldpf on ldcmr=lccmr
--  where isnumber(substr(trim(text3),length(trim(text3))-5,6))=1 and substr(trim(text3),length(trim(text3))-5,6) is not null)
--  where last_6_digit not like '%.%') roll_over_fees on  roll_over_fees.fin_acc_num=a.fin_acc_num
--  where a.SERIAL_DETAILS=1;
-- 
--COMMIT;
drop table indemnity_date;
create table indemnity_date as
select FIN_ACC_NUM fin_num,TO_CHAR (START_DATE, 'DD-MM-YYYY') START_DATE,TO_CHAR (END_DATE, 'DD-MM-YYYY')  END_DATE
FROM BEAM_MEMOPAD
     INNER JOIN MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=TRIM(CUST_ACCT) and SCHM_TYPE <> 'OOO'
     left join (select distinct fin_cif_id,BGCSNO from MAP_CIF 
				inner JOIN BGPF  ON NVL(MAP_CIF.GFCLC,' ')=NVL(BGPF.BGCLC,' ') AND trim(MAP_CIF.GFCUS)=trim(BGPF.BGCUS)
				where  to_number(BGCSNO) <> 0)map_cif ON MAP_CIF.FIN_CIF_ID = MAP_ACC.FIN_CIF_ID
  WHERE (FIN_ACC_NUM,CREATE_DATE) IN( SELECT  FIN_ACC_NUM,MAX(CREATE_DATE)  CREATE_DATE FROM (
                                       SELECT DISTINCT FIN_ACC_NUM,CREATE_DATE FROM BEAM_MEMOPAD
                                                INNER JOIN MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=TRIM(CUST_ACCT)
                                        WHERE UPPER(NOTE) LIKE '%FAX%' and SCHM_TYPE!='OOO'
                                       ) GROUP BY FIN_ACC_NUM
                                    )
    AND  UPPER(NOTE) LIKE '%FAX%' and  SCHM_TYPE not in ('OOO');
 
 
TRUNCATE TABLE FREETEXT_O_TABLE;

INSERT INTO FREETEXT_O_TABLE
 SELECT DISTINCT
       RPAD (NVL (a.FIN_ACC_NUM, ' '), 16, ' ') ACID,
       RPAD (NVL(lcnr,' '), 80, ' ') FREE_TEXT_1,
       RPAD (NVL(lcnr1||' '||lcnr2,' '), 80, ' ') FREE_TEXT_2,
       RPAD (NVL(lcnr3||' '||lcnr4,' '), 80, ' ') FREE_TEXT_3,
       RPAD (NVL (START_DATE,' '), 80, ' ') FREE_TEXT_4,
       RPAD (NVL (END_DATE,' '), 80, ' ') FREE_TEXT_5,
       RPAD (' ', 80, ' ') FREE_TEXT_6,
       RPAD (' ', 80, ' ') FREE_TEXT_7,
       RPAD (' ', 80, ' ') FREE_TEXT_8,
       RPAD (' ', 80, ' ') FREE_TEXT_9,
       RPAD (' ', 80, ' ') FREE_TEXT_10,
       RPAD (' ', 80, ' ') FREE_TEXT_11,
       RPAD (' ', 80, ' ') FREE_TEXT_12,
       RPAD (' ', 80, ' ') FREE_TEXT_13,
       RPAD (' ', 80, ' ') FREE_TEXT_14,
       RPAD (case when schm_code='LFR' and trim(ossrc)='A'  and isnumber(substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6))=1 and substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6) is not null and (substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6)) not like '%.%' then to_char('.'||substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6)) 
       when schm_code='LFR' and trim(ossrc)='A' then '.250000'
       else ' ' end, 80, ' ') FREE_TEXT_15
from map_acc a
inner join ospf on osbrnm||trim(osdlp)||trim(osdlr)=leg_acc_num
inner join ldpf on ldbrnm||trim(lddlp)||trim(lddlr)=leg_acc_num
inner join lcpf on trim(lccmr)=trim(ldcmr)
left join indemnity_date on fin_num=a.fin_acc_num
where schm_type='CLA';
COMMIT;

INSERT INTO FREETEXT_O_TABLE
SELECT DISTINCT
       RPAD (NVL (FIN_ACC_NUM, ' '), 16, ' ') ACID,
       --RPAD (NVL(TRIM(BGCSNO),' '), 80, ' ') FREE_TEXT_1,---this is commented because EJ joint cif exculsion stopped
	   RPAD (' ', 80, ' ') FREE_TEXT_1,
       RPAD (' ', 80, ' ') FREE_TEXT_2,
	   RPAD (' ', 80, ' ') FREE_TEXT_3,
       RPAD (NVL (TO_CHAR (START_DATE, 'DD-MM-YYYY'), ' '), 80, ' ') FREE_TEXT_4,
       RPAD (NVL (TO_CHAR (END_DATE, 'DD-MM-YYYY'), ' '), 80, ' ') FREE_TEXT_5,
       RPAD (' ', 80, ' ') FREE_TEXT_6,
       RPAD (' ', 80, ' ') FREE_TEXT_7,
       RPAD (' ', 80, ' ') FREE_TEXT_8,
       RPAD (' ', 80, ' ') FREE_TEXT_9,
       RPAD (' ', 80, ' ') FREE_TEXT_10,
       RPAD (' ', 80, ' ') FREE_TEXT_11,
       RPAD (' ', 80, ' ') FREE_TEXT_12,
       RPAD (' ', 80, ' ') FREE_TEXT_13,
       RPAD (' ', 80, ' ') FREE_TEXT_14,
       RPAD (' ', 80, ' ') FREE_TEXT_15
  FROM BEAM_MEMOPAD
     INNER JOIN MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=TRIM(CUST_ACCT) and SCHM_TYPE <> 'OOO'
     left join (select distinct fin_cif_id,BGCSNO from MAP_CIF 
				inner JOIN BGPF  ON NVL(MAP_CIF.GFCLC,' ')=NVL(BGPF.BGCLC,' ') AND trim(MAP_CIF.GFCUS)=trim(BGPF.BGCUS)
				where  to_number(BGCSNO) <> 0)map_cif ON MAP_CIF.FIN_CIF_ID = MAP_ACC.FIN_CIF_ID
  WHERE (FIN_ACC_NUM,CREATE_DATE) IN( SELECT  FIN_ACC_NUM,MAX(CREATE_DATE)  CREATE_DATE FROM (
                                       SELECT DISTINCT FIN_ACC_NUM,CREATE_DATE FROM BEAM_MEMOPAD
                                                INNER JOIN MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=TRIM(CUST_ACCT)
                                        WHERE UPPER(NOTE) LIKE '%FAX%' and SCHM_TYPE!='OOO'
                                       ) GROUP BY FIN_ACC_NUM
                                    )
    AND  UPPER(NOTE) LIKE '%FAX%' and  SCHM_TYPE not in ('OOO') and FIN_ACC_NUM NOT IN(SELECT TRIM(ACID) FROM FREETEXT_O_TABLE );
    
 COMMIT;
 
  DELETE FROM FREETEXT_O_TABLE WHERE ACID IN(
 SELECT ACID FROM FREETEXT_O_TABLE GROUP BY ACID HAVING COUNT(*)>1
 ) AND TRIM(FREE_TEXT_4) IS NULL;
 
 COMMIT;
 
-- INSERT INTO FREETEXT_O_TABLE
-- SELECT DISTINCT
--       RPAD (NVL (FIN_ACC_NUM, ' '), 16, ' ') ACID,
--       --RPAD (NVL(TRIM(BGCSNO),' '), 80, ' ') FREE_TEXT_1,---this is commented because EJ joint cif exculsion stopped
--	   RPAD (' ', 80, ' ') FREE_TEXT_1,
--       RPAD (' ', 80, ' ') FREE_TEXT_2,
--       RPAD (' ', 80, ' ') FREE_TEXT_3,
--       RPAD (' ', 80, ' ') FREE_TEXT_4,
--       RPAD (' ', 80, ' ') FREE_TEXT_5,
--       RPAD (' ', 80, ' ') FREE_TEXT_6,
--       RPAD (' ', 80, ' ') FREE_TEXT_7,
--       RPAD (' ', 80, ' ') FREE_TEXT_8,
--       RPAD (' ', 80, ' ') FREE_TEXT_9,
--       RPAD (' ', 80, ' ') FREE_TEXT_10,
--       RPAD (' ', 80, ' ') FREE_TEXT_11,
--       RPAD (' ', 80, ' ') FREE_TEXT_12,
--       RPAD (' ', 80, ' ') FREE_TEXT_13,
--       RPAD (' ', 80, ' ') FREE_TEXT_14,
--       RPAD (' ', 80, ' ') FREE_TEXT_15
--  FROM MAP_ACC
--  inner join (select distinct fin_cif_id,BGCSNO from MAP_CIF 
--  inner JOIN BGPF  ON NVL(MAP_CIF.GFCLC,' ')=NVL(BGPF.BGCLC,' ') AND trim(MAP_CIF.GFCUS)=trim(BGPF.BGCUS)
--     where  IS_JOINT='Y' and  to_number(BGCSNO) <> 0)map_cif ON MAP_CIF.FIN_CIF_ID = MAP_ACC.FIN_CIF_ID
--  WHERE FIN_ACC_NUM NOT IN(SELECT TRIM(ACID) FROM FREETEXT_O_TABLE )  and  SCHM_TYPE not in ('OOO') and FIN_ACC_NUM NOT IN(SELECT TRIM(ACID) FROM FREETEXT_O_TABLE );
--  COMMIT;
  
 
 EXIT; 
