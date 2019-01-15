alter session set "_hash_join_enabled"=true;
truncate table spt_temp;
DECLARE
 CURSOR c1
   IS
select r4pf.*,fin_acc_num,(R4LSR-R4FSN)+1 leaves 
from r4pf 
inner join map_acc on r4ab=leg_branch_id and r4an=leg_scan and r4as=leg_scas
inner join scpf    on scab=r4ab and scan=r4an and scas=r4as
inner join c8pf    on c8ccy=scccy
where schm_type in('CAA','SBA','ODA') and r4typ='S'; --added r4typ='S' based on confirmation from Edwin on 19/04/2017
    str1       VARCHAR2 (20000);
    todo       NUMBER;
    start_no   NUMBER;
    end_no     NUMBER;
    x          NUMBER;
   BEGIN
   FOR l_record IN c1
   LOOP
    todo := l_record.leaves;
    start_no := trim(l_record.R4FSN);
    end_no := l_record.R4LSR;
    x := FLOOR (l_record.leaves/1);
    FOR i IN 1 .. x
     LOOP
     INSERT INTO spt_temp
              VALUES (trim(to_char(to_date(get_date_fm_btrv(l_record.r4eff),'YYYYMMDD'),'DD-MM-YYYY')),trim(l_record.r4ab),trim(l_record.r4aN),trim(l_record.r4as), 
              trim(l_record.R4AMT),trim(start_no),
                     trim(start_no) + 1 - 1, 1,l_record.R4CCY,l_record.fin_acc_num,l_record.r4pay,l_record.r4nar);
         todo := todo - 1;
         start_no := trim(start_no) + 1;
      END LOOP;
      --IF todo != 0
      --THEN
        --INSERT INTO spt_temp
          --   VALUES (trim(l_record.CHQDT),trim(l_record.INPUTDT),trim(l_record.ACBRN),trim(l_record.ACNUM),trim(l_record.Amount),trim(start_no),
            --          end_no, todo, l_record.ACSEQ,l_record.ACCUR,l_record.fin_acc_num);
      --END IF;
   END LOOP;
   COMMIT;   
END;
/
TRUNCATE TABLE CHEQUE_PROCESSED;
drop index CHEQUE_PROC_TBL_CHQ_SLR_START;
drop index CHQ_PROC_TBL_CHQ_CHQ_SLR_END ;
drop index CHQ_PROC_BR_ID_CUST_NO_SUF ;
insert into audit_msg values('CHEQUE_PROCESSED INDEX DROPED',sysdate);
INSERT INTO CHEQUE_PROCESSED
SELECT CASE WHEN SCOAD > dtdiss THEN TO_CHAR (TO_DATE (get_date_fm_btrv (SCOAD), 'YYYYMMDD'), 'DD-MM-YYYY')
         ELSE TO_CHAR (TO_DATE (get_date_fm_btrv (dtdiss), 'YYYYMMDD'),'DD-MM-YYYY')END ISSUE_DATE,
       TRIM (DTABC) BRANCH_ID,
       TRIM (DTANC) CUST_NO,
       TRIM (DTASC) SUFFIX,
       TRIM (DTFIRS) CHQ_SLR_START,
       DTLAST CHQ_SLR_END,
       DTCHIB NO_LEAVES,
       '' FIN_FLD,
       DTCBTC CHQ_TYPE,
       currency,
       fin_acc_num--,
       --rpad('P',DTCHIB,'P')CHQ_LVS_STAT
  FROM dtpf
       INNER JOIN map_acc
          ON dtabc = leg_branch_id AND dtanc = leg_scan AND dtasc = leg_scas
       INNER JOIN scpf ON scab = dtabc AND scan = dtanc AND scas = dtasc
 WHERE     schm_type IN ('CAA', 'SBA', 'ODA') --and rownum<1000
       --AND DTABC = '0600'
       --AND DTANC = '000127'
       --AND DTASC = '201' AND TO_NUMBER(DTFIRS) <= 1051 AND  TO_NUMBER(DTLAST) > = 1051 
       ;
COMMIT;       
insert into audit_msg values('INSERTED INTO CHEQUE_PROCESSED',sysdate);
create index CHQ_PROC_BR_ID_CUST_NO_SUF on CHEQUE_PROCESSED(BRANCH_ID||CUST_NO||SUFFIX);
create index CHEQUE_PROC_TBL_CHQ_SLR_START on CHEQUE_PROCESSED(CHQ_SLR_START);
create index CHQ_PROC_TBL_CHQ_CHQ_SLR_END on CHEQUE_PROCESSED(CHQ_SLR_END);
insert into audit_msg values('CHEQUE_PROCESSED INDEX CREATED',sysdate);
----------------------------------------------------------------------------------
DROP INDEX DUPF_MIG_DUABC_DUANC_DUASC_IDX;
DROP INDEX DUPF_MIG_DULAST_IDX;
DROP INDEX DUPF_MIG_DUFIRS_IDX;
truncate table dupf_mig;
insert into dupf_mig select trim(DUABC),trim(DUANC),trim(DUASC),to_number(trim(DUFIRS)),to_number(trim(DULAST)),trim(DUCBTC) from dupf;
commit;
insert into dupf_mig SELECT * FROM DUPF_STOP_CHEQUE WHERE (DUABC||DUANC||DUASC,DUFIRS) IN(
SELECT BRANCH||CUST_NO||SUFFIX LEG_ACC_NUM,START_NO FROM spt_temp
);
commit;
CREATE INDEX DUPF_MIG_DUABC_DUANC_DUASC_IDX  ON DUPF_MIG(DUABC||DUANC||DUASC );
CREATE INDEX DUPF_MIG_DULAST_IDX  ON DUPF_MIG(DULAST );
CREATE INDEX DUPF_MIG_DUFIRS_IDX  ON DUPF_MIG(DUFIRS );
exec dbms_stats.gather_table_stats('MIGAPPKW','CHEQUE_PROCESSED',cascade=>true);
exec dbms_stats.gather_table_stats('MIGAPPKW','DUPF_MIG',cascade=>true);
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
select to_char(sysdate,'DD.MON.YYYY HH24:MI:SS') currtime from dual;
set timing on autotrace on linesize 1000 trimspool on trimout on echo on
alter session set current_schema = migappkw;
alter session enable parallel query;
alter session set "_b_tree_bitmap_plans" = true;
alter session set "_gby_hash_aggregation_enabled" = true;
alter session set "_undo_autotune" = true;
alter session set db_file_multiblock_read_count = 128;
alter session set "_hash_join_enabled" = false;
drop table migappkw.CHEQUE_PROCESSED_PART;
CREATE TABLE migappkw.CHEQUE_PROCESSED_PART
        (    ISSUE_DATE VARCHAR2(10),
             BRANCH_ID VARCHAR2(4),
             CUST_NO VARCHAR2(6),
             SUFFIX VARCHAR2(3),
             CHQ_SLR_START NUMBER,
             CHQ_SLR_END NUMBER,
             NO_LEAVES NUMBER,
             FIN_FLD VARCHAR2(10),
             CHQ_TYPE VARCHAR2(3),
             CURRENCY VARCHAR2(3),
             FIN_ACC_NUM VARCHAR2(32),
             BRANCH_ID_CUST_NO_SUFFIX  number
        )
PARTITION BY HASH("CHQ_SLR_START")
(
             partition p1 tablespace users,
             partition p2 tablespace users,
             partition p3 tablespace users,
             partition p4 tablespace users,
             partition p5 tablespace users,
             partition p6 tablespace users,
             partition p7 tablespace users,
             partition p8 tablespace users,
             partition p9 tablespace users,
             partition p10 tablespace users,
             partition p11 tablespace users,
             partition p12 tablespace users,
             partition p13 tablespace users,
             partition p14 tablespace users,
             partition p15 tablespace users,
             partition p16 tablespace users,
             partition p17 tablespace users,
             partition p18 tablespace users,
             partition p19 tablespace users,
             partition p20 tablespace users
)
TABLESPACE "USERS" ;
insert into migappkw.CHEQUE_PROCESSED_PART
(
             "ISSUE_DATE",
             "BRANCH_ID",
             "CUST_NO",
             "SUFFIX",
             "CHQ_SLR_START",
             "CHQ_SLR_END",
             "NO_LEAVES",
             "FIN_FLD",
             "CHQ_TYPE",
             "CURRENCY",
             "FIN_ACC_NUM",
             "BRANCH_ID_CUST_NO_SUFFIX"
)
(select
             "ISSUE_DATE",
             "BRANCH_ID",
             "CUST_NO",
             "SUFFIX",
             "CHQ_SLR_START",
             "CHQ_SLR_END",
             "NO_LEAVES",
             "FIN_FLD",
             "CHQ_TYPE",
             "CURRENCY",
             "FIN_ACC_NUM",
             to_number(BRANCH_ID||CUST_NO||SUFFIX)
         from migappkw.CHEQUE_PROCESSED
         --from migappkw.CHEQUE_PROCESSED
);
drop TABLE "migappkw"."DUPF_MIG_PART";
CREATE TABLE "migappkw"."DUPF_MIG_PART"
        (    "DUABC" VARCHAR2(4),
             "DUANC" VARCHAR2(6),
             "DUASC" VARCHAR2(3),
             "DUFIRS" NUMBER,
             "DULAST" NUMBER,
             "DUCBTC" VARCHAR2(3),
             "DUABC_DUANC_DUASC" number
        )
PARTITION BY HASH("DUABC_DUANC_DUASC")
(
             partition p1 tablespace users,
             partition p2 tablespace users,
             partition p3 tablespace users,
             partition p4 tablespace users,
             partition p5 tablespace users,
             partition p6 tablespace users,
             partition p7 tablespace users,
             partition p8 tablespace users,
             partition p9 tablespace users,
             partition p10 tablespace users,
             partition p11 tablespace users,
             partition p12 tablespace users,
             partition p13 tablespace users,
             partition p14 tablespace users,
             partition p15 tablespace users,
             partition p16 tablespace users,
             partition p17 tablespace users,
             partition p18 tablespace users,
             partition p19 tablespace users,
             partition p20 tablespace users
 )
TABLESPACE "USERS" ;
insert into migappkw.DUPF_MIG_PART
(
             "DUABC",
             "DUANC",
             "DUASC",
             "DUFIRS",
             "DULAST",
             "DUCBTC" ,
             "DUABC_DUANC_DUASC"
)
(select
             "DUABC",
             "DUANC",
             "DUASC",
             "DUFIRS",
             "DULAST",
             "DUCBTC",
             to_number(DUABC||DUANC||DUASC)
from
        migappkw.DUPF_MIG
--        "MIGAPPKW"."DUPF_MIG"
);
drop index migappkw.CHEQUE_PROCESSED_concat_cols2;
create index migappkw.CHEQUE_PROCESSED_concat_cols2 on migappkw.CHEQUE_PROCESSED_part(CHQ_SLR_START,CHQ_SLR_END,branch_id_cust_no_suffix) tablespace users;
drop index migappkw.DUPF_MIG_concat_cols;
create index migappkw.DUPF_MIG_concat_cols on migappkw.DUPF_MIG_part(DUFIRS,DULAST) local tablespace users;
drop index migappkw.DUPF_MIG_concat_cols2;
create index migappkw.DUPF_MIG_concat_cols2 on migappkw.dupf_mig_part (DUABC_DUANC_DUASC,dufirs,dulast) tablespace users;
drop index migappkw.CHEQUE_PROCESSED_indx3;
create index migappkw.CHEQUE_PROCESSED_indx3 on migappkw.CHEQUE_PROCESSED_part (branch_id_cust_no_suffix) tablespace users;
exec dbms_stats.gather_table_stats(ownname=>'migappkw',tabname=>'CHEQUE_PROCESSED_PART',cascade=>true,estimate_percent=>.001,method_opt=>'FOR ALL COLUMNS SIZE 254',no_invalidate=>false,degree=>4);
exec dbms_stats.gather_table_stats(ownname=>'migappkw',tabname=>'DUPF_MIG_PART',cascade=>true,estimate_percent=>.001,method_opt=>'FOR ALL COLUMNS SIZE 254',no_invalidate=>false,degree=>4);
drop table migappkw.cheque_processed_temp;
create table migappkw.cheque_processed_temp as
(
    select /*+ PARALLEL(a 20) PARALLEL(b 20) */ /*+ INDEX(b CHEQUE_PROCESSED_concat_cols2) */ a.ISSUE_DATE,a.BRANCH_ID,a.CUST_NO,a.SUFFIX,a.CHQ_SLR_START,a.CHQ_SLR_END,a.NO_LEAVES,a.FIN_FLD,a.CHQ_TYPE,a.CURRENCY,a.FIN_ACC_NUM,
     b.DUFIRS-a.CHQ_SLR_START STARTS_INDEX ,b.DULAST-b.DUFIRS+1 NO_OF_LVS
      ,DENSE_RANK() OVER (order  BY branch_id_cust_no_suffix,CHQ_SLR_START ) rank1,
      DENSE_RANK() OVER (PARTITION BY branch_id_cust_no_suffix,CHQ_SLR_START,CHQ_SLR_END ORDER BY DUFIRS) rank2
    from migappkw.CHEQUE_PROCESSED_part a
    left join migappkw.dupf_mig_part b on branch_id_cust_no_suffix = DUABC_DUANC_DUASC and DUFIRS>=CHQ_SLR_START and DULAST<=CHQ_SLR_END
 );
 alter session disable parallel query;
alter session set "_b_tree_bitmap_plans" = false;
alter session set "_gby_hash_aggregation_enabled" = false;
alter session set "_undo_autotune" = false;
alter session set db_file_multiblock_read_count = 128;
alter session set "_hash_join_enabled" = true;
select to_char(sysdate,'DD.MON.YYYY HH24:MI:SS') currtime from dual;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--drop table CHEQUE_PROCESSED_TEMP;
--create table CHEQUE_PROCESSED_TEMP as 
--select a.ISSUE_DATE,a.BRANCH_ID,a.CUST_NO,a.SUFFIX,a.CHQ_SLR_START,a.CHQ_SLR_END,a.NO_LEAVES,a.FIN_FLD,a.CHQ_TYPE,a.CURRENCY,a.FIN_ACC_NUM,
-- b.DUFIRS-a.CHQ_SLR_START STARTS_INDEX ,b.DULAST-b.DUFIRS+1 NO_OF_LVS
--  ,DENSE_RANK() OVER (order  BY BRANCH_ID||CUST_NO||SUFFIX,CHQ_SLR_START ) rank1,
--  DENSE_RANK() OVER (PARTITION BY BRANCH_ID||CUST_NO||SUFFIX,CHQ_SLR_START,CHQ_SLR_END ORDER BY DUFIRS) rank2
--from CHEQUE_PROCESSED a
--left join dupf_mig b on BRANCH_ID||CUST_NO||SUFFIX = DUABC||DUANC||DUASC and DUFIRS>=CHQ_SLR_START and DULAST<=CHQ_SLR_END;
insert into audit_msg values('CHEQUE_PROCESSED_TEMP CREATED',sysdate);
--SET SERVEROUTPUT ON;
TRUNCATE TABLE CHEQUE_PROCESSED_MAIN;
DECLARE
   V_RANK1            NUMBER := 1;
   V_RANK2            NUMBER := 1;
   V_LAST_USERD_LVS   NUMBER;
   V_ISSUE_DATE       VARCHAR2 (10);
   V_BRANCH_ID        VARCHAR2 (4);
   V_CUST_NO          VARCHAR2 (6);
   V_SUFFIX           VARCHAR2 (3);
   V_CHQ_SLR_START    NUMBER;
   V_CHQ_SLR_END      NUMBER;
   V_NO_LEAVES        NUMBER;
   V_FIN_FLD          VARCHAR2 (3);
   V_CHQ_TYPE         VARCHAR2 (3);
   V_CURRENCY         VARCHAR2 (3);
   V_FIN_ACC_NUM      VARCHAR2 (20);
   V_CHQ_LVS_STAT     VARCHAR2 (2000);
   V_I NUMBER :=0;
   CURSOR c1
   IS
      select ISSUE_DATE, FIN_SOL_ID BRANCH_ID, CUST_NO, SUFFIX, CHQ_SLR_START, CHQ_SLR_END, NO_LEAVES, FIN_FLD, 
        CHQ_TYPE, CHEQUE_PROCESSED_TEMP.CURRENCY, CHEQUE_PROCESSED_TEMP.FIN_ACC_NUM, STARTS_INDEX, NO_OF_LVS, RANK1, RANK2 
        from CHEQUE_PROCESSED_TEMP
        inner join map_acc on CHEQUE_PROCESSED_TEMP.FIN_ACC_NUM = map_acc.fin_acc_num order by rank1,rank2;
BEGIN
   insert into audit_msg values('CHEQUE_PROCESSED_MAIN STARTS',sysdate);
   FOR l_record IN c1
   LOOP
 --  DBMS_OUTPUT.PUT_LINE('l_record.RANK1 : '||l_record.RANK1);
      IF (V_RANK1 = l_record.RANK1)
      THEN
         IF (V_RANK1 = l_record.RANK1 AND V_RANK2 = l_record.RANK2)
         THEN
            V_ISSUE_DATE := l_record.ISSUE_DATE;
            V_BRANCH_ID := l_record.BRANCH_ID;
            V_CUST_NO := l_record.CUST_NO;
            V_SUFFIX := l_record.SUFFIX;
            V_CHQ_SLR_START := l_record.CHQ_SLR_START;
            V_CHQ_SLR_END := l_record.CHQ_SLR_END;
            V_NO_LEAVES := l_record.NO_LEAVES;
            V_FIN_FLD := l_record.FIN_FLD;
            V_CHQ_TYPE := l_record.CHQ_TYPE;
            V_CURRENCY := l_record.CURRENCY;
            V_FIN_ACC_NUM := l_record.FIN_ACC_NUM;
            V_CHQ_LVS_STAT := RPAD ('P', l_record.STARTS_INDEX , 'P') || RPAD ('U', l_record.NO_OF_LVS, 'U');
            V_LAST_USERD_LVS := l_record.STARTS_INDEX + l_record.NO_OF_LVS - 1;
         ELSE
            V_CHQ_LVS_STAT := V_CHQ_LVS_STAT||RPAD ('P', l_record.STARTS_INDEX-1 - V_LAST_USERD_LVS, 'P') || RPAD ('U', l_record.NO_OF_LVS, 'U');
            V_LAST_USERD_LVS := l_record.STARTS_INDEX + l_record.NO_OF_LVS - 1;
         END IF;
      ELSE
      V_CHQ_LVS_STAT := RPAD (NVL(V_CHQ_LVS_STAT,'P'), V_NO_LEAVES, 'P');
         INSERT INTO CHEQUE_PROCESSED_MAIN
              VALUES (V_ISSUE_DATE,V_BRANCH_ID,V_CUST_NO,V_SUFFIX,V_CHQ_SLR_START,V_CHQ_SLR_END,V_NO_LEAVES,V_FIN_FLD,V_CHQ_TYPE,V_CURRENCY,V_FIN_ACC_NUM,V_CHQ_LVS_STAT);
         V_RANK1 := l_record.RANK1;
         V_ISSUE_DATE := l_record.ISSUE_DATE;
         V_BRANCH_ID := l_record.BRANCH_ID;
         V_CUST_NO := l_record.CUST_NO;
         V_SUFFIX := l_record.SUFFIX;
         V_CHQ_SLR_START := l_record.CHQ_SLR_START;
         V_CHQ_SLR_END := l_record.CHQ_SLR_END;
         V_NO_LEAVES := l_record.NO_LEAVES;
         V_FIN_FLD := l_record.FIN_FLD;
         V_CHQ_TYPE := l_record.CHQ_TYPE;
         V_CURRENCY := l_record.CURRENCY;
         V_FIN_ACC_NUM := l_record.FIN_ACC_NUM;
         V_CHQ_LVS_STAT := RPAD ('P', l_record.STARTS_INDEX, 'P') || RPAD ('U', l_record.NO_OF_LVS, 'U');
         V_LAST_USERD_LVS := l_record.STARTS_INDEX + l_record.NO_OF_LVS - 1;
      END IF;
      IF mod(V_I, 1000) = 0 THEN
              COMMIT;
        END IF;
   END LOOP;
   V_CHQ_LVS_STAT := RPAD (NVL(V_CHQ_LVS_STAT,'P'), V_NO_LEAVES, 'P');
   INSERT INTO CHEQUE_PROCESSED_MAIN
              VALUES (V_ISSUE_DATE,V_BRANCH_ID,V_CUST_NO,V_SUFFIX,V_CHQ_SLR_START,V_CHQ_SLR_END,V_NO_LEAVES,V_FIN_FLD,V_CHQ_TYPE,V_CURRENCY,V_FIN_ACC_NUM,V_CHQ_LVS_STAT);
COMMIT;              
  insert into audit_msg values('CHEQUE_PROCESSED_MAIN ENDS',sysdate);
END;
/
------------------------------------------------------------------------------
TRUNCATE TABLE cbs_o_table;
DECLARE 
CURSOR C1 IS select * from CHEQUE_PROCESSED_MAIN --where FIN_ACC_NUM='0600001126015' and ISSUE_DATE='19-04-2007'
;
V_LEAVES_SPLIT_COUNT NUMBER;
V_CHQ_SLR_START NUMBER;
V_NO_LEAVES NUMBER;
V_CHQ_LVS_STAT VARCHAR2(1000);
i NUMBER :=0;
START_FLG  NUMBER :=1;
BEGIN 
insert into audit_msg values('cbs_o_table STARTS',sysdate);
 FOR l_RECORD IN C1  LOOP
SELECT ceil(l_RECORD.NO_LEAVES/100) INTO V_LEAVES_SPLIT_COUNT FROM DUAL ;
--IF V_LEAVES_SPLIT_COUNT =0 THEN 
--V_LEAVES_SPLIT_COUNT :=1;
--END IF;
START_FLG := 1;
FOR I IN 1..V_LEAVES_SPLIT_COUNT LOOP
V_CHQ_SLR_START := l_RECORD.CHQ_SLR_START+((I-1)*100);
IF V_LEAVES_SPLIT_COUNT > I THEN
V_NO_LEAVES := 100;
ELSE
V_NO_LEAVES := l_RECORD.NO_LEAVES-(100*(V_LEAVES_SPLIT_COUNT-1));
END IF;
V_CHQ_LVS_STAT := SUBSTR(l_RECORD.CHQ_LVS_STAT,100*(I-1)+CASE WHEN START_FLG=1 THEN 0 ELSE 1 END,V_NO_LEAVES);
 INSERT 
 INTO cbs_o_table  
 select 
        'CBS',
        rpad(l_RECORD.FIN_ACC_NUM,16,' '),
        rpad(l_RECORD.CURRENCY,3,' '),
        lpad(V_CHQ_SLR_START,16,' '),--lpad(lpad(V_CHQ_SLR_START,8,'0'),16,' ')
        lpad(V_NO_LEAVES,4,' '),--
        rpad(l_RECORD.ISSUE_DATE,10,' '),
        rpad(V_CHQ_LVS_STAT,100,' '),
        rpad(' ',6,' '),
        rpad(l_RECORD.BRANCH_ID,100,' ')
    from DUAL;
   START_FLG := 0;
END LOOP;
i := i+1;
IF mod(i, 1000) = 0 THEN
      COMMIT;
  END IF;
END LOOP;  
END;
/
insert into audit_msg values('cbs_o_table ENDS',sysdate);
-------------------------------------------------------------
------------------------------------------------------------------------------
insert into cbs_o_table
    select distinct 
        --INDICATOR                NVARCHAR2(3),
        'CBS',
        --ACCOUNT_NUMBER           NVARCHAR2(16),
        rpad(map_acc.fin_acc_num,16,' '),
        --CURRENCY_CODE            NVARCHAR2(3),        
        rpad(map_acc.CURRENCY,3,' '),
        --BEGIN_CHEQUE_NUMBER      NVARCHAR2(16),
        --lpad(CHQ_SLR_START,16,' '),         
        lpad(START_NO,16,' '),
        --NUMBER_OF_CHEQUE_LEAVES  NVARCHAR2(4),
        lpad('1',4,' '),
        --DATE_OF_ISSUE            NVARCHAR2(10)        
        rpad(POSTDT,10,' '),
        --CHEQUE_LEAF_STATUS       NVARCHAR2(100),
        rpad('U',100,' '),--need to arive logic
        --BEGIN_CHEQUE_ALPHA       NVARCHAR2(6),
        rpad(' ',6,' '),
        --DUMMY                    NVARCHAR2(100)
        rpad(map_acc.fin_sol_id,100,' ')
from (
select * from spt_temp
where not exists(select * from dtpf where BRANCH||cust_no||suffix=DTABC||DTANC||DTASC
and to_number(START_NO) between to_number(DTFIRS) and to_number(DTLAST)))spt
inner join map_acc on map_Acc.fin_acc_num=spt.fin_acc_num; 
commit;  
