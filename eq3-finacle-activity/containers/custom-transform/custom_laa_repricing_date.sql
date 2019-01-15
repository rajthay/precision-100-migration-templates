
-- File Name		: custom_laa_repricing_date.sql 
-- File Created for	: Upload file for repricing date upload
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 10-09-2017
-------------------------------------------------------------------
truncate table int_tbl_code;
insert into int_tbl_code
select 
--entity_id = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,0,16)))
rpad(foracid,16,' '),
--entity_type = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,16,5)))
rpad(ENTITY_TYPE,5,' '),
--start_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,21,10)))
rpad(to_char(REPRICING_DATE,'DD-MM-YYYY'),10,' '),
--end_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,31,10)))
rpad(to_char(itc.END_DATE,'DD-MM-YYYY'),10,' '),
--int_tbl_code = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,41,5)))
rpad(itc.INT_TBL_CODE,5,' '),
--cust_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,46,10)))
rpad(CUST_CR_PREF_PCNT,10,' '),
--cust_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,56,10)))
rpad(CUST_DR_PREF_PCNT,10,' '),
--id_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,66,10)))
rpad(ACCT_ID_CREDIT_PREF_PERCENT,10,' '),
--id_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,76,10)))
rpad(ACCT_ID_DEBIT_PREF_PERCENT,10,' '),
--pegged_flg = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,86,1)))
rpad(PEGGED_FLG,1,' '),
--peg_frequency_in_months = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,87,4)))
rpad(PEGGING_FREQUENCY_IN_MONTHS,4,' '),
--peg_frequency_in_days = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,91,3)))
rpad(PEGGING_FREQUENCY_IN_DAYS,3,' '),
--min_int_pcnt_cr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,94,10)))
rpad(MIN_INT_PCNT_CR,10,' '),
--min_int_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,104,10)))
rpad(MIN_INT_PCNT_DR,10,' '),
--max_int_pcnt_cr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,114,10)))
rpad(MAX_INT_PCNT_CR,10,' '),
--max_int_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,124,10)))
rpad(MAX_INT_PCNT_DR,10,' '),
--ac_level_nrml_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,134,10)))
rpad(AC_LEVEL_NRML_PCNT_DR,10,' '),
--ac_level_spread = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,144,10)))
rpad(AC_LEVEL_SPREAD,10,' '),
--ac_level_comp_int_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,154,10)))
rpad(AC_LEVEL_COMP_INT_PCNT,10,' '),
--ac_level_comp_prnc_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,164,10)))
rpad(AC_LEVEL_COMP_PRNC_PCNT,10,' '),
--ac_level_pen_int_pcnt_for_int = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,174,10)))
rpad(AC_LEVEL_PEN_INT_PCNT_FOR_INT,10,' '),
--ac_level_pen_int_pcnt_for_prnc = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,184,10)
rpad(AC_LEVEL_PEN_INT_PCNT_FOR_PRNC,10,' '),
--ac_level_penal_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,194,10)))
rpad(AC_LEVEL_PENAL_PCNT_DR,10,' '),
--reason_code = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,204,5)))
rpad(nvl(trim(REASON_CODE),' '),5,' '),
--compound_prnc_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,209,10)))
rpad(COMPOUND_PRNC_PCNT,10,' '),
--compound_int_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,219,10)))
rpad(COMPOUND_INT_PCNT,10,' '),
--penalty_int_pcnt_for_prnc = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,229,10)))
rpad(PENALTY_INT_PCNT_FOR_PRNC,10,' '),
--penalty_int_pcnt_for_int = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,239,10)))
rpad(PENALTY_INT_PCNT_FOR_INT,10,' '),
--chnl_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,249,10)))
rpad(CHNL_DR_PREF_PCNT,10,' '),
--chnl_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,259,10)))
rpad(CHNL_CR_PREF_PCNT,10,' '),
--negotiated_rate_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,269,10)))
rpad(NEGOTIATED_RATE_DR,10,' '),
--int_version = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,279,5)))
rpad(nvl(trim(INT_VERSION),' '),5,' '),
--int_rate_prd_in_months = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,284,4)))
rpad(nvl(INT_RATE_PRD_IN_MONTHS,0),4,' '),
--int_rate_prd_in_days = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,288,3)))
rpad(nvl(INT_RATE_PRD_IN_DAYS,0),3,' '),
--peg_review_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,291,10)))
rpad(to_char(PEG_REVIEW_DATE,'DD-MM-YYYY'),10,' '),
--review_reqd_on_start_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,301,1)))
rpad(nvl(REVIEW_REQD_ON_START_DATE,' '),1,' '),
--interpolation_method = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,302,1)))
rpad(nvl(itc.INTERPOLATION_METHOD,' '),1,' ')
from tbaadm.gam
inner join tbaadm.itc on gam.acid=itc.entity_id
inner join lam_o_table on trim(account_number)=foracid
inner join map_Acc on fin_acc_num=foracid
inner join int_tbl on INT_ACC_NUM =leg_acc_num
where REPRICING_DATE is not null;
commit;
--drop table v2pf_rate;
--create table v2pf_rate as
--select v5pf_acc_num,v2dte,v2rat,Lead(v2dte, 1) OVER (partition by v5pf_acc_num ORDER BY v5pf_acc_num) v2dte_end from v2pf
--inner join (select v5brnm||trim(v5dlp)||trim(v5dlr) v5pf_acc_num,case when V5LRE<>'0' then to_char(V5LRE)  else to_char(otsdte) end opn_dt from v5pf
--inner join otpf  on otbrnm=v5brnm and trim(otdlp)=trim(v5dlp) and trim(otdlr)=trim(v5dlr) where v5tdt='D')v5pf on v5pf_acc_num=v2brnm||trim(v2dlp)||trim(v2dlr) 
--where to_char(v2dte) >=opn_dt order by v5pf_acc_num,v2dte; 
--insert into int_tbl_code
--select 
----entity_id = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,0,16)))
--rpad(foracid,16,' '),
----entity_type = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,16,5)))
--rpad(ENTITY_TYPE,5,' '),
----start_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,21,10)))
--rpad(to_char(to_date(get_date_fm_btrv(v2dte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----end_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,31,10)))
--rpad(case when v2dte_end is not null then to_char(to_date(get_date_fm_btrv(v2dte_end),'YYYYMMDD'),'DD-MM-YYYY')  else to_char(itc.END_DATE,'DD-MM-YYYY') end,10,' '),
----int_tbl_code = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,41,5)))
--rpad(itc.INT_TBL_CODE,5,' '),
----cust_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,46,10)))
--rpad(CUSTOMER_CREDIT_PREF_PERCENT,10,' '),
----cust_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,56,10)))
--rpad(CUSTOMER_DEBIT_PREF_PERCENT,10,' '),
----id_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,66,10)))
--rpad(v2rat,10,' '),
----id_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,76,10)))
--rpad(ACCOUNT_DEBIT_PREF_PERCENT,10,' '),
----pegged_flg = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,86,1)))
--rpad('N',1,' '),
----peg_frequency_in_months = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,87,4)))
--rpad('0',4,' '),
----peg_frequency_in_days = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,91,3)))
--rpad('0',3,' '),
----min_int_pcnt_cr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,94,10)))
--rpad(MIN_INT_PCNT_CR,10,' '),
----min_int_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,104,10)))
--rpad(MIN_INT_PCNT_DR,10,' '),
----max_int_pcnt_cr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,114,10)))
--rpad(MAX_INT_PCNT_CR,10,' '),
----max_int_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,124,10)))
--rpad(MAX_INT_PCNT_DR,10,' '),
----ac_level_nrml_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,134,10)))
--rpad(AC_LEVEL_NRML_PCNT_DR,10,' '),
----ac_level_spread = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,144,10)))
--rpad(AC_LEVEL_SPREAD,10,' '),
----ac_level_comp_int_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,154,10)))
--rpad(AC_LEVEL_COMP_INT_PCNT,10,' '),
----ac_level_comp_prnc_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,164,10)))
--rpad(AC_LEVEL_COMP_PRNC_PCNT,10,' '),
----ac_level_pen_int_pcnt_for_int = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,174,10)))
--rpad(AC_LEVEL_PEN_INT_PCNT_FOR_INT,10,' '),
----ac_level_pen_int_pcnt_for_prnc = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,184,10)
--rpad(AC_LEVEL_PEN_INT_PCNT_FOR_PRNC,10,' '),
----ac_level_penal_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,194,10)))
--rpad(AC_LEVEL_PENAL_PCNT_DR,10,' '),
----reason_code = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,204,5)))
--rpad(nvl(trim(REASON_CODE),' '),5,' '),
----compound_prnc_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,209,10)))
--rpad(COMPOUND_PRNC_PCNT,10,' '),
----compound_int_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,219,10)))
--rpad(COMPOUND_INT_PCNT,10,' '),
----penalty_int_pcnt_for_prnc = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,229,10)))
--rpad(PENALTY_INT_PCNT_FOR_PRNC,10,' '),
----penalty_int_pcnt_for_int = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,239,10)))
--rpad(PENALTY_INT_PCNT_FOR_INT,10,' '),
----chnl_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,249,10)))
--rpad(CHNL_DR_PREF_PCNT,10,' '),
----chnl_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,259,10)))
--rpad(CHNL_CR_PREF_PCNT,10,' '),
----negotiated_rate_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,269,10)))
--rpad(NEGOTIATED_RATE_DR,10,' '),
----int_version = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,279,5)))
--rpad(nvl(trim(INT_VERSION),' '),5,' '),
----int_rate_prd_in_months = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,284,4)))
--rpad(nvl(INT_RATE_PRD_IN_MONTHS,0),4,' '),
----int_rate_prd_in_days = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,288,3)))
--rpad(nvl(INT_RATE_PRD_IN_DAYS,0),3,' '),
----peg_review_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,291,10)))
--rpad(to_char(PEG_REVIEW_DATE,'DD-MM-YYYY'),10,' '),
----review_reqd_on_start_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,301,1)))
--rpad(nvl(REVIEW_REQD_ON_START_DATE,' '),1,' '),
----interpolation_method = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,302,1)))
--rpad(nvl(itc.INTERPOLATION_METHOD,' '),1,' ')
--from tbaadm.gam
--inner join tbaadm.itc on gam.acid=itc.entity_id
--inner join tda_o_table on trim(deposit_account_number)=foracid
--inner join map_Acc on fin_acc_num=foracid
--inner join (select a.* from v2pf_rate a
--inner join (select v5pf_acc_num from v2pf_rate group by v5pf_acc_num having count(*) > 1 ) b on a.v5pf_acc_num=b.v5pf_acc_num
--order by a.v5pf_acc_num,v2dte) deal on v5pf_acc_num=leg_acc_num;
--commit; 
exit; 
