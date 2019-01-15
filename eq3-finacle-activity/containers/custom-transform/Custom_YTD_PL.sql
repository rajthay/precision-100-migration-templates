
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
--drop table SCPF_sep1;
--create table SCPF_sep1 as select scab,scan,scas,scbal+scsuma sep_bal,c8lsar sep_rate from scpf_sep inner join c8pf_sep on c8ccy=scccy where scbal+scsuma <> 0; 
--CREATE INDEX SCSEP_IND ON SCPF_SEP1 (SCAB, SCAN, SCAS);
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
--PL JAN--
drop table profit_loss_balance_trfr_jan;
create table profit_loss_balance_trfr_jan
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_jan
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
        SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_jan
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_JAN a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL FEB--
drop table profit_loss_balance_trfr_feb;
create table profit_loss_balance_trfr_feb
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_feb
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_feb
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_feb a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL MAR--
drop table profit_loss_balance_trfr_mar;
create table profit_loss_balance_trfr_mar
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_mar
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_mar
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_mar a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL apr--
drop table profit_loss_balance_trfr_apr;
create table profit_loss_balance_trfr_apr
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_apr
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_apr
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_apr a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL MAY--
drop table profit_loss_balance_trfr_may;
create table profit_loss_balance_trfr_may
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_may
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_may
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_may a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL JUN--
drop table profit_loss_balance_trfr_jun;
create table profit_loss_balance_trfr_jun
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_jun
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_jun
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_jun a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL JUL--
drop table profit_loss_balance_trfr_jul;
create table profit_loss_balance_trfr_jul
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_jul
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_jul
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_jul a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL AUG--
drop table profit_loss_balance_trfr_aug;
create table profit_loss_balance_trfr_aug
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_aug
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_aug
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_aug a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
commit;
drop table custom_ytd_dtl;
create table custom_ytd_dtl as
select  lpad(z.scab||z.scan||z.scas,20,' ') EQ_account_no,fin_acc_num,currency,account_type,scheme_type,Analysis_code,customer_type,MTD_BAL,GL_SUB_HEAD_CODE,
jan_BAL,jan_rate,feb_BAL,feb_rate,mar_BAL,mar_rate,apr_BAL,apr_rate,may_BAL,may_rate,jun_BAL,jun_rate,jul_BAL,jul_rate,
aug_BAL,
aug_rate,
--sep_BAL,
--sep_rate,
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
--left join SCPF_sep1 sep on z.scab=sep.scab and z.scan=sep.scan and z.scas=sep.scas 
--left join SCPF_oct1 oct on z.scab=oct.scab and z.scan=oct.scan and z.scas=oct.scas 
--left join SCPF_nov1 nov on z.scab=nov.scab and z.scan=nov.scan and z.scas=nov.scas 
--left join SCPF_dec1 dec on z.scab=dec.scab and z.scan=dec.scan and z.scas=dec.scas 
;
commit;
insert into custom_ytd_dtl
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny, a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE, scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,PL_CONV_CCY jan_bal,to_char(C8LSAR) JAN_RATE,0 FEB_BAL,to_char('') FEB_RATE,0 MAR_BAL,to_char('') MAR_RATE,
0 APR_BAL,to_char('') APR_RATE,0 MAY_BAL,to_char('') MAY_RATE,0 JUN_BAL,to_char('') JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_jan a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_jan on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_jan
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_jan) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
union all
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,0 jan_bal,'' JAN_RATE,PL_CONV_CCY FEB_bal,to_char(C8LSAR) FEB_RATE,
0 MAR_BAL,to_char('') MAR_RATE,
0 APR_BAL,to_char('') APR_RATE,0 MAY_BAL,to_char('') MAY_RATE,0 JUN_BAL,to_char('') JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_feb a 
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_feb on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_feb
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_feb) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
union all
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,
PL_CONV_CCY MAR_bal,to_char(C8LSAR) MAR_RATE,0 APR_BAL,to_char('') APR_RATE,0 MAY_BAL,to_char('') MAY_RATE,0 JUN_BAL,to_char('') JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_mar  a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_mar on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_mar
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_mar) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
union all
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,0 mar_bal,to_char('') mar_RATE,
PL_CONV_CCY APR_bal,to_char(C8LSAR) APR_RATE,0 MAY_BAL,to_char('') MAY_RATE,0 JUN_BAL,to_char('') JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_apr a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_apr on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_apr
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_apr) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
union all
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,0 mar_bal,to_char('') mar_RATE,0 apr_bal,to_char('') apr_RATE,
PL_CONV_CCY MAY_bal,to_char(C8LSAR) MAY_RATE,0 JUN_BAL,to_char('') JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_may a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_may on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_may
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_may) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
union all
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,0 mar_bal,to_char('') mar_RATE,0 apr_bal,to_char('') apr_RATE,
0 may_bal,to_char('') may_RATE,PL_CONV_CCY jun_bal,to_char(C8LSAR) JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_jun a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_jun on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_jun
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_jun) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
UNION ALL
select DEAL_NO,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,
0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,0 mar_bal,to_char('') mar_RATE,0 apr_bal,to_char('') apr_RATE,
0 may_bal,to_char('') may_RATE,0 JUN_bal,to_char('') JUN_RATE,
PL_CONV_CCY juL_bal,TO_CHAR(C8LSAR) JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_jul a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_jul on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_jul
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_jul) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
UNION ALL
select DEAL_NO,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,
0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,0 mar_bal,to_char('') mar_RATE,0 apr_bal,to_char('') apr_RATE,
0 may_bal,to_char('') may_RATE,0 JUN_bal,to_char('') JUN_RATE,
PL_CONV_CCY juL_bal,TO_CHAR(C8LSAR) JUL_RATE,PL_CONV_CCY aug_bal,TO_CHAR(C8LSAR) aug_RATE,GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_aug a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_aug on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_aug
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_aug) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null);
commit;
exit; 
