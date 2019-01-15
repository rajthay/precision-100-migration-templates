
-- File Name                       : custom_htd_upload.sql
-- File Created for            	   : History Transaction file
-- Created By                      : Alavudeen Ali Badusha.R
-- Client                          : ABK
-- Created On                      : 15-01-2017
-------------------------------------------------------------------
drop table all_balance;
create table all_balance as select distinct scab,scan,scas,fin_acc_num,scccy currency,scact account_type,scheme_type,scacd Analysis_code,scctp customer_type,GL_SUB_HEAD_CODE,'0' MTD_BAL,get_param('EOD_DATE') Migration_date  from all_final_trial_balance where scheme_type ='OAB' and fin_acc_num is not null and isnumber(GL_SUB_HEAD_CODE)=1;
create index all_bal_idx on all_balance(scab,scan,scas);
drop table SCPF_jan1;
create table SCPF_jan1 as select scab,scan,scas,scbal+scsuma jan_bal,c8lsar jan_rate from scpf_jan inner join c8pf_jan on c8ccy=scccy where scbal+scsuma <> 0;
CREATE INDEX SCJAN_IND ON SCPF_JAN1 (SCAB, SCAN, SCAS);
drop table SCPF_feb1;
create table SCPF_feb1 as select scab,scan,scas,scbal+scsuma feb_bal,c8lsar feb_rate from scpf_feb inner join c8pf_feb on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCFEB_IND ON SCPF_FEB1 (SCAB, SCAN, SCAS);
drop table SCPF_mar1;
create table SCPF_mar1 as select scab,scan,scas,scbal+scsuma mar_bal,c8lsar mar_rate from scpf_mar inner join c8pf_mar on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCMAR_IND ON SCPF_MAR1 (SCAB, SCAN, SCAS);
drop table SCPF_apr1;
create table SCPF_apr1 as select scab,scan,scas,scbal+scsuma apr_bal,c8lsar apr_rate from scpf_apr inner join c8pf_apr on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCAPR_IND ON SCPF_APR1 (SCAB, SCAN, SCAS);
drop table SCPF_may1;
create table SCPF_may1 as select scab,scan,scas,scbal+scsuma may_bal,c8lsar may_rate from scpf_may inner join c8pf_may on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCMAY_IND ON SCPF_MAY1 (SCAB, SCAN, SCAS);
drop table SCPF_jun1;
create table SCPF_jun1 as select scab,scan,scas,scbal+scsuma jun_bal,c8lsar jun_rate from scpf_jun inner join c8pf_jun on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCJUN_IND ON SCPF_JUN1 (SCAB, SCAN, SCAS);
drop table SCPF_jul1;
create table SCPF_jul1 as select scab,scan,scas,scbal+scsuma jul_bal,c8lsar jul_rate from scpf_jul inner join c8pf_jul on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCJUL_IND ON SCPF_JUL1 (SCAB, SCAN, SCAS);
drop table SCPF_aug1;
create table SCPF_aug1 as select scab,scan,scas,scbal+scsuma aug_bal,c8lsar aug_rate from scpf_aug inner join c8pf_aug on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCAUG_IND ON SCPF_AUG1 (SCAB, SCAN, SCAS);
drop table SCPF_sep1;
create table SCPF_sep1 as select scab,scan,scas,scbal+scsuma sep_bal,c8lsar sep_rate from scpf_sep inner join c8pf_sep on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCSEP_IND ON SCPF_SEP1 (SCAB, SCAN, SCAS);
--drop table SCPF_oct1;
--create table SCPF_oct1 as select scab,scan,scas,scbal+scsuma oct_bal,c8lsar oct_rate from scpf_oct inner join c8pf_oct on c8ccy=scccy where scbal+scsuma <> 0; 
--CREATE INDEX SCOCT_IND ON SCPF_OCT1 (SCAB, SCAN, SCAS);
--drop table SCPF_nov1;
--create table SCPF_nov1 as select scab,scan,scas,scbal+scsuma nov_bal,c8lsar nov_rate from scpf_nov inner join c8pf_nov on c8ccy=scccy where scbal+scsuma <> 0; 
--CREATE INDEX SCNOV_IND ON SCPF_NOV1 (SCAB, SCAN, SCAS);
--drop table SCPF_dec1;
--create table SCPF_dec1 as select scab,scan,scas,scbal+scsuma dec_bal,c8lsar dec_rate from scpf_dec inner join c8pf_dec on c8ccy=scccy where scbal+scsuma <> 0; 
--CREATE INDEX SCDEC_IND ON SCPF_DEC1 (SCAB, SCAN, SCAS);
------------------------------------------------------------
drop table custom_ytd_dtl;
create table custom_ytd_dtl as
select  z.scab||z.scan||z.scas EQ_account_no,fin_acc_num,currency,account_type,scheme_type,Analysis_code,customer_type,MTD_BAL,GL_SUB_HEAD_CODE,
jan_BAL,jan_rate,feb_BAL,feb_rate,mar_BAL,mar_rate,apr_BAL,apr_rate,may_BAL,may_rate,jun_BAL,jun_rate,jul_BAL,jul_rate,
aug_BAL,
aug_rate,
sep_BAL,
sep_rate,
--oct_BAL,
--oct_rate,
--nov_BAL,
--nov_rate,
--dec_BAL,
--dec_rate,
get_param('EOD_DATE') Migration_date 
from all_balance z 
--inner join tbaadm.gss on gss.gl_sub_head_code = z.GL_SUB_HEAD_CODE and bank_id='01'
left join SCPF_jan1 jan on z.scab=jan.scab and z.scan=jan.scan and z.scas=jan.scas 
left join SCPF_feb1 feb on z.scab=feb.scab and z.scan=feb.scan and z.scas=feb.scas 
left join SCPF_mar1 mar on z.scab=mar.scab and z.scan=mar.scan and z.scas=mar.scas 
left join SCPF_apr1 apr on z.scab=apr.scab and z.scan=apr.scan and z.scas=apr.scas 
left join SCPF_may1 may on z.scab=may.scab and z.scan=may.scan and z.scas=may.scas 
left join SCPF_jun1 jun on z.scab=jun.scab and z.scan=jun.scan and z.scas=jun.scas 
left join SCPF_jul1 jul on z.scab=jul.scab and z.scan=jul.scan and z.scas=jul.scas 
left join SCPF_aug1 aug on z.scab=aug.scab and z.scan=aug.scan and z.scas=aug.scas 
left join SCPF_sep1 sep on z.scab=sep.scab and z.scan=sep.scan and z.scas=sep.scas 
--left join SCPF_oct1 oct on z.scab=oct.scab and z.scan=oct.scan and z.scas=oct.scas 
--left join SCPF_nov1 nov on z.scab=nov.scab and z.scan=nov.scan and z.scas=nov.scas 
--left join SCPF_dec1 dec on z.scab=dec.scab and z.scan=dec.scan and z.scas=dec.scas 
;
exit; 
