========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
ns_tda_master.sql 
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/casa/KW_NONSTAFF_TDA.dat
select
'EXTERNAL_NO'||'|'||
'LEG_BRCH_ID'||'|'||
'FINACLE_SOL_ID'||'|'||
'LEG_CLIENT_NO'||'|'||
'LEG_SUFFIX'||'|'||
'LEG_CCY'||'|'||
'FINACLE_CCY'||'|'||
'CCY_MATCH'||'|'||
'FINACLE_CIF_ID'||'|'||
'LEG_CONTRACT'||'|'||
'LEG_DEAL_REF_NUMBER' ||'|'||
'FINACLE_ACCT_NUM'||'|'||
'LEG_CUST_TYPE'||'|'||
'LEG_ACCT_TYPE'||'|'||
'FINACLE_SCHEME_CODE'||'|'||
'SCHM_DESC'||'|'||
--'LEGACY_CUST_NAME' ||'|'||
'FINACLE_CUST_NAME' ||'|'||
--'lEGACY_CR_PREF_RATE'||'|'||
'LEG_DEPOSIT_AMOUNT'||'|'||
'FINACLE_DEPOSIT_AMOUNT'||'|'||
'DEPOSIT_AMOUNT_MATCH'||'|'||
--'LEG_INT_TAB_CODE'||'|'||
--'LEG_EXTRACTED_INT_TBL_CODE'||'|'||
--'FINACLE_INT_TBL_CODE'||'|'||
--'INT_TBL_CODE_MATCH'||'|'||
'LEG_ACCT_OPN_DATE'||'|'||
'FINACLE_ACCT_OPN_DATE'||'|'||
'ACCT_OPN_DATE_MATCH'||'|'||
'LEG_OPEN_EFFECTIVE_DATE'||'|'||
'FINACLE_OPEN_EFFECTIVE_DATE'||'|'||
'OPEN_EFFECTIVE_DATE_MATCH'||'|'||
'LEG_OPERATIVE_ACCOUNT' ||'|'||
'FINACLE_OPERATIVE_ACCOUNT' ||'|'||
'LEG_REPAYMENT_ACCOUNT' ||'|'||
'FINACLE_REPAYMENT_ACCOUNT' ||'|'||
'LEG_LAST_CR_INT_POST_DT'||'|'||
'FINACLE_LAST_CR_INT_POST_DT'||'|'||
'LAST_CR_INT_POST_DT_MATCH'||'|'||
'LEG_LAST_INT_RUN_DATE_CR'||'|'||
'FINACLE_LAST_INT_RUN_DATE_CR'||'|'||
'LAST_INT_RUN_DATE_CR_MATCH'||'|'||
--'LEG_NET_INT_CALC'||'|'||
--'FINACLE_NET_INT_CALC'||'|'||
--'LEG_CUMU_INTEREST_PAID'||'|'||
--'FINACLE_CUMU_INTEREST_PAID'||'|'||
--'CUMU_INTEREST_PAID_MATCH'||'|'||
'LEG_CUMU_INTE_CREDIT'||'|'||
'FINACLE_CUMU_INT_CREDIT'||'|'||
'CUMU_INT_CREDIT_MATCH'||'|'||
'LEG_MATURITY_DATE'||'|'||
'FINACLE_MATURITY_DATE'||'|'||
'MATURITY_DATE_MATCH'||'|'||
--'LEG_PRIN_REPAY_ACCT'||'|'||
--'FINACLE_PRIN_REPAY_ACCT'||'|'||
--'LEG_INT_CR_ACCT'||'|'||
--'FINACLE_INT_CR_ACCT'||'|'||
'LEG_AUTO_RENEWAL_FLAG'||'|'||
'FINACLE_AUTO_RENEWAL_FLG'||'|'||
'LEG_AUTO_CLOSURE_FLG'||'|'||
'FINACLE_AUTO_CLOSURE_FLG'||'|'||
--'LEG_RENEWAL_OPTION'||'|'||
--'FINACLE_RENEWAL_OPTION'||'|'||
--'RENEWAL_OPTION_MATCH'||'|'||
'FINACLE_INT_TABLE_RATE'||'|'||
'LEG_ABSOLUTE_RATE'||'|'||
'FINACLE_ABSOLUTE_RATE'||'|'||
'ABSOLUTE_RATE_MATCH'||'|'||
'FIN_PREF_RATE'||'|'||
'LEG_ACCOUNT_BALANCE'||'|'||
'FINACLE_CLEAR_BALANCE_AMOUNT'||'|'||
'ACCOUNT_BALANCE_MATCH'||'|'||
'LEG_LEGDER_BALANCE'||'|'||
'MANAGER_CODE'||'|'||
--'LEG_NOMINATED_ACC'||'|'||
--'FINACLE_NOMINATED_ACC'||'|'||
--'NOMINATED_ACC_MATCH'||'|'||
'CAPITALISED_INTEREST_FLAG'||'|'||
'LEG_DIVISION'||'|'||
'FIN_DIVISION'||'|'||
'LEG_SUB_DIVISION'||'|'||
'FIN_SUB_DIVISION'
from dual
union all
select 
to_char(map_acc.EXTERNAL_ACC)||'|'||
to_char(map_acc.leg_branch_id) ||'|'||
to_char(gam.sol_id) ||'|'||
to_char(map_acc.leg_scan) ||'|'||
to_char(map_acc.LEG_SCAS) ||'|'||
to_char(map_acc.currency) ||'|'||
to_char(gam.acct_crncy_code) ||'|'||
case when to_char(gam.acct_crncy_code) = gam.acct_crncy_code THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(gam.cif_id) ||'|'||
to_char(map_acc.leg_acc_num) ||'|'||
TO_CHAR(V5PF.V5DLR) ||'|'||
to_char(gam.foracid) ||'|'|| 
to_char(map_acc.leg_cust_type) ||'|'||
to_char(map_acc.leg_acct_type) ||'|'|| 
to_char(map_acc.schm_code) ||'|'||
to_char(gsp.SCHM_DESC)||'|'||
--to_char(gam.ACCT_NAME) ||'|'||
to_char(gam.ACCT_NAME) ||'|'||
--to_char(ACC_PREF_RATE) ||'|'||
to_char(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi)  and nvl(clmamount,0)  <> 0 
                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end)||'|'||
----to_char(case when v5abd||v5and||v5asd=v5abi||v5ani||v5asi and nvl(clmamount,0)  <> 0 
----                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
----            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end) ||'|'||
to_char(tam.deposit_amount) ||'|'||
case when trim(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi)  and nvl(clmamount,0)  <> 0 
                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end) = to_char(tam.deposit_amount) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(csp.INT_TBL_CODE)||'|'||
--to_char(csp.INT_TBL_CODE)||'|'||
--to_char(itc.int_tbl_code)||'|'||
--case when csp.INT_TBL_CODE = itc.int_tbl_code then 'TRUE' else 'FALSE' end ||'|'||
to_char(case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
            else ' ' end)  ||'|'||
TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY')||'|'||
case when  to_char(case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
            else ' ' end)  = TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY') then 'TRUE' else 'FALSE' end  ||'|'||
case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
            to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MON-YYYY')
            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
            else  '' end  ||'|'||
TO_CHAR (tam.open_effective_date, 'DD-MON-YYYY') ||'|'||
case when (case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
            to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MON-YYYY')
            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
            else  '' end)  = TO_CHAR (tam.open_effective_date, 'DD-MON-YYYY')  then 'TRUE' else 'FALSE' end ||'|'||
case when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null and v5ani <> '111112' 
           then to_char(v5abi||v5ani||v5asi)
           when v5ani ='111112'
           then to_char(iv.omabf||iv.omanf||iv.omasf)
           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
           then to_char(iv.omabf||iv.omanf||iv.omasf)
           else ''
           end ||'|'||
case
           when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null and v5ani <> '111112' 
           then to_char(get_oper_acct(v5abi||v5ani||v5asi))
           when v5ani ='111112'
           then to_char(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) 
           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
           then to_char(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) 
           else '' end ||'|'||
TO_CHAR(pm.omabf||pm.omanf||pm.omasf) ||'|'||
TO_CHAR(get_oper_acct(pm.omabf||pm.omanf||pm.omasf))  ||'|'||           
case --when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')---- commented on 09-09-2017 based on sandeep requirement and finding from day 1 recon
                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
                 when v5lcd<>0 and v5lre=0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')------Added on 09-09-2017 based on sandeep requirement and day1 recon
            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end  ||'|'||
TO_CHAR (eit.interest_calc_upto_date_cr, 'DD-MM-YYYY' ) ||'|'||
case when (case --when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')---- commented on 09-09-2017 based on sandeep requirement and finding from day 1 recon
                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
                 when v5lcd<>0 and v5lre=0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')------Added on 09-09-2017 based on sandeep requirement and day1 recon
            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end) = (TO_CHAR (eit.interest_calc_upto_date_cr, 'DD-MM-YYYY' )) then 'TRUE' else 'FALSE' end ||'|'||
case --when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')---commented on 09-09-2017 based on sandeep requirement and day1 recon
                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
                 when v5lcd<>0 and v5lre=0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')------Added on 09-09-2017 based on sandeep requirement and day1 recon
            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end  ||'|'||
TO_CHAR(eit.last_interest_run_date_cr,'DD-MM-YYYY')||'|'||
case when (case --when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')---commented on 09-09-2017 based on sandeep requirement and day1 recon
                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
                 when v5lcd<>0 and v5lre=0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')------Added on 09-09-2017 based on sandeep requirement and day1 recon
            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end) = (TO_CHAR(eit.last_interest_run_date_cr,'DD-MM-YYYY')) then 'TRUE' else 'FALSE' end ||'|'||
--'LEG_NET_INT_CALC'||'|'||
--'FINACLE_NET_INT_CALC'||'|'||
--case when v5abd||v5and||v5asd<>v5abi||v5ani||v5asi then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0')
--            else ' ' end ||'|'||
--to_char(tam.cumulative_int_paid)||'|'||
--case when (case when v5abd||v5and||v5asd<>v5abi||v5ani||v5asi then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0')
--            else ' ' end) = to_char(tam.cumulative_int_paid) then 'TRUE' else 'FALSE' end ||'|'||
case when v5abd||v5and||v5asd=v5abi||v5ani||v5asi then to_char(to_number((v5am4)/POWER(10,C8CED))) else ' ' end ||'|'||
to_char(tam.cumulative_int_credited)||'|'||
CASE WHEN (case when v5abd||v5and||v5asd=v5abi||v5ani||v5asi then to_char(to_number((v5am4)/POWER(10,C8CED))) else ' ' end)  = to_char(tam.cumulative_int_credited) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
to_char(case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
            to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
            else to_char(to_date(get_date_fm_btrv(V5NRD),'YYYYMMDD'),'DD-MM-YYYY') end) ||'|'||   --- challenge
TO_CHAR (tam.maturity_date, 'DD-MON-YYYY') ||'|'||
CASE WHEN (case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
            to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
            else to_char(to_date(get_date_fm_btrv(V5NRD),'YYYYMMDD'),'DD-MM-YYYY') end) = TO_CHAR (tam.maturity_date, 'DD-Mm-YYYY') THEN 'TRUE' ELSE 'FALSE' END  ||'|'||
--'LEG_PRIN_REPAY_ACCT'||'|'||
--'FINACLE_PRIN_REPAY_ACCT'||'|'||
--'LEG_INT_CR_ACCT'||'|'||
--'FINACLE_INT_CR_ACCT'||'|'||
rpad(case when v5pf.v5arc in ('A','P') then 'N'
                when HYDBNM||HYDLP||HYDLR is not null then 'U' 
                when v5pf.v5mdt=9999999 then 'U'
                else 'N' end,1,' ') ||'|'||
to_char(tam.auto_renewal_flg) ||'|'||
rpad(
rpad(case when v5pf.v5arc in ('A','P') then 'N'
                when HYDBNM||HYDLP||HYDLR is not null then 'N' 
                when v5pf.v5mdt=9999999 then 'N'
                else 'Y' end,1,' '),1,' ') ||'|'||
to_char(tam.close_on_maturity_flg) ||'|'||
to_char(itc.INT_TBL_CODE) ||'|'||
to_char(case when trim(v5pf.v5rat)='0' then lpad(to_char(nvl(trim(D4BRAR),0)),8,' ')
when  TO_number(trim(v5pf.v5rat)) between 0.001 and 0.999 then lpad('0'||to_char(trim(v5pf.v5rat)),8,' ')
else lpad(to_char(trim(v5pf.v5rat)),8,' ')
end)||'|'||
case when trim(dep_rate.v5pf_acc_num) is null then to_char(itc.ID_CR_PREF_PCNT + itc.NRML_PCNT_CR) else to_char(itc.ID_CR_PREF_PCNT + tvs.NRML_INT_PCNT) end||'|'||
--to_char(itc.ID_CR_PREF_PCNT + tvs.NRML_INT_PCNT)||'|'||
case when to_number(case when v5pf.v5rat='0' then lpad(to_char(nvl(D4BRAR,0)),8,' ')
when  TO_number(v5pf.v5rat) between 0.001 and 0.999 then lpad('0'||to_char(v5pf.v5rat),8,' ')
else lpad(to_char(v5pf.v5rat),8,' ')
end) = to_number(case when trim(dep_rate.v5pf_acc_num) is null then to_char(itc.ID_CR_PREF_PCNT + itc.NRML_PCNT_CR) else to_char(itc.ID_CR_PREF_PCNT + tvs.NRML_INT_PCNT) end) then 'TRUE' else 'FALSE' end ||'|'||
to_char(itc.ID_CR_PREF_PCNT) ||'|'||
to_char(case when v5abd||v5and||v5asd=v5abi||v5ani||v5asi and nvl(clmamount,0)  <> 0 
                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end)  ||'|'||
to_char(TO_NUMBER (tam.deposit_amount))||'|'||
case when to_char(case when v5abd||v5and||v5asd=v5abi||v5ani||v5asi and nvl(clmamount,0)  <> 0 
                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end)  =to_char(TO_NUMBER (tam.deposit_amount))  then 'TRUE' else 'FALSE' end  ||'|'||
to_char((scbal - SCSUMA)/POWER(10,C8CED))||'|'||
to_char(scaco) ||'|'||
--case when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null            
--then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')                     
--when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--then rpad(get_oper_acct(iv.omabf||iv.omanf||iv.omasf),16,' ') 
--else rpad(' ',16,' ') end||'|'||
--gam_oper.foracid||'|'||
--case when trim(case when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null            
--then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')                     
--when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--then rpad(get_oper_acct(iv.omabf||iv.omanf||iv.omasf),16,' ') 
--else rpad(' ',16,' ') end) = (gam_oper.foracid) then 'TRUE' else 'FALSE' end   ||'|'||
to_char(case when map_acc.schm_code in ('TDGTD','TDATD') then 'N' else 'Y' end)||'|'||
case 
when nrd.officer_code is not null and trim(nrd.division)  is not null  then to_char(trim(nrd.division))
when trim(dv.DIVISION) is not null then to_char(trim(dv.DIVISION)) end||'|'||
c_gac.division||'|'||
case 
when nrd.officer_code is not null  and trim(SUBDIVISION)  is not null  then to_char(trim(nrd.subdivision))
when trim(dv.DIVISION) is not null then to_char(trim(dv.DIVISION)) end||'|'||
c_gac.SUB_DIVISION
from (select * from v5pf where v5pf.v5tdt='D' and v5pf.v5bal<>'0')v5pf
inner join scpf on trim(scpf.SCAB)=trim(v5pf.V5ABD) and trim(scpf.scan)=trim(v5pf.V5AND) and trim(scpf.scas)=trim(v5pf.V5ASD) and scpf.scccy=v5pf.V5CCY
inner join (select * from map_acc where schm_type='TDA')map_acc on map_acc.LEG_ACC_NUM=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
left join map_cif mc on mc.fin_cif_id=map_acc.fin_cif_id
inner join c8pf on c8ccy =scpf.scccy
LEFT JOIN (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam ON gam.foracid = map_acc.fin_acc_num
LEFT JOIN (select * from TBAADM.ALR where bank_id=get_param('BANK_ID'))ALR ON ALR.ACID = GAM.ACID
LEFT JOIN (select * from tbaadm.tam where bank_id=get_param('BANK_ID'))tam ON tam.acid = gam.acid
left join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam_oper on tam.REPAYMENT_ACID=gam_oper.acid
LEFT JOIN (select * from tbaadm.eit where bank_id=get_param('BANK_ID'))eit ON eit.entity_id = gam.acid 
left join (select *  from tbaadm.gsp   where bank_id = get_param('BANK_ID') and del_flg = 'N')gsp on  map_acc.schm_code = gsp.schm_code
LEFT JOIN (select * from tbaadm.itc where bank_id=get_param('BANK_ID'))itc ON itc.entity_id = gam.acid AND itc.entity_type = 'ACCNT'
--left join (select tv1.* from (select * from tbaadm.tvs where bank_id='01') tv1 
--inner join (select int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) int_ver from tbaadm.tvs where bank_id='01'group by  int_tbl_code,crncy_code) tv2 
--on tv1.int_tbl_code=tv2.int_tbl_code and tv1.crncy_code=tv2.crncy_code and tv1.INT_TBL_VER_NUM=tv2.int_ver) tvs on tvs.INT_TBL_CODE=itc.INT_TBL_CODE and tvs.crncy_code=map_acc.currency
left join crmuser.accounts b on b.orgkey = map_acc.fin_cif_id     
left join ospf on v5brnm=osbrnm and v5dlp=osdlp and v5dlr=osdlr
left join (select * from otpf where ottdt='D')otpf on v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
left join ompf_iv iv on v5brnm=iv.ombrnm and v5dlp=iv.omdlp and v5dlr=iv.omdlr
left join ompf_pm pm on v5brnm=pm.ombrnm and v5dlp=pm.omdlp and v5dlr=pm.omdlr
left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) clmamount  from v5pf
inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') > case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
and v5pf.v5tdt='D' and v5pf.v5bal<>'0'        
Group by v5brnm,v5dlp,v5dlr)int_amt on int_amt.v5brnm =v5pf.v5brnm and int_amt.v5dlp=v5pf.v5dlp  and  int_amt.v5dlr=v5pf.v5dlr
left join d4pf on d4brr=V5PF.v5brr
left join jrpf on trim(jrpf.jrprc) =trim(v5pf.v5prc) 
left join (select* from hypf where hydlr is not null) hypf on HYDBNM||HYDLP||HYDLR = map_acc.leg_acc_num
left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code = map_acc.CURRENCY  
left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'N' group by schm_code)gss  on map_acc.schm_code = gss.schm_code
left join (select * from tbaadm.TSP where bank_id = get_param('BANK_ID') and del_flg = 'N' )TSP  on map_acc.schm_code = TSP.schm_code AND Tsp.crncy_code = map_acc.CURRENCY 
left join gfpf  on nvl(trim(gfpf.gfclc),' ')=nvl(trim(mc.gfclc),' ') and  trim(gfpf.gfcus)=trim(mc.gfcus)
left join (select distinct v5pf_acc_num,tbl_code from dep_rate)dep_rate on  v5pf_acc_num=map_acc.leg_acc_num
left join (select tv1.* from (select * from tbaadm.tvs where bank_id='01') tv1 
inner join (select int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) int_ver from tbaadm.tvs where bank_id='01'group by  int_tbl_code,crncy_code) tv2 
on tv1.int_tbl_code=tv2.int_tbl_code and tv1.crncy_code=tv2.crncy_code and tv1.INT_TBL_VER_NUM=tv2.int_ver) tvs on tvs.INT_TBL_CODE=dep_rate.TBL_CODE and tvs.crncy_code=map_acc.currency 
left join rm_code_mapping dv on trim(dv.RESPONSIBILITY_CODE) =trim(scaco)
left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
left join (select * from CUSTOM.CUST_GAC_EXTENTION_TBL)c_gac on c_gac.acid=gam.acid
where (B.STAFFFLAG ='N' or b.staffflag is null);
--select
--'LEG_BRCH_ID'||'|'||
--'FINACLE_SOL_ID'||'|'||
--'LEG_CLIENT_NO'||'|'||
--'LEG_SUFFIX'||'|'||
--'LEG_CCY'||'|'||
--'FINACLE_CCY'||'|'||
--'CCY_MATCH'||'|'||
--'FINACLE_CIF_ID'||'|'||
--'LEG_CONTRACT'||'|'||
--'LEG_DEAL_REF_NUMBER' ||'|'||
--'FINACLE_ACCT_NUM'||'|'||
--'LEG_CUST_TYPE'||'|'||
--'LEG_ACCT_TYPE'||'|'||
--'FINACLE_SCHEME_CODE'||'|'||
--'SCHM_DESC'||'|'||
--'FINACLE_CUST_NAME' ||'|'||
--'FINACLE_CR_PREF_RATE'||'|'||
--'LEG_DEPOSIT_AMOUNT'||'|'||
--'FINACLE_DEPOSIT_AMOUNT'||'|'||
--'DEPOSIT_AMOUNT_MATCH'||'|'||
--'LEG_ACCT_OPN_DATE'||'|'||
--'FINACLE_ACCT_OPN_DATE'||'|'||
--'ACCT_OPN_DATE_MATCH'||'|'||
--'LEG_OPEN_EFFECTIVE_DATE'||'|'||
--'FINACLE_OPEN_EFFECTIVE_DATE'||'|'||
--'OPEN_EFFECTIVE_DATE_MATCH'||'|'||
--'LEG_OPERATIVE_ACCOUNT' ||'|'||
--'FINACLE_OPERATIVE_ACCOUNT' ||'|'||
--'LEG_REPAYMENT_ACCOUNT' ||'|'||
--'FINACLE_REPAYMENT_ACCOUNT' ||'|'||
--'LEG_LAST_CR_INT_POST_DT'||'|'||
--'FINACLE_LAST_CR_INT_POST_DT'||'|'||
--'LEG_LAST_INT_RUN_DATE_CR'||'|'||
--'FINACLE_LAST_INT_RUN_DATE_CR'||'|'||
--'LEG_CUMU_INTE_CREDIT'||'|'||
--'FINACLE_CUMU_INT_CREDIT'||'|'||
--'CUMU_INT_CREDIT_MATCH'||'|'||
--'LEG_MATURITY_DATE'||'|'||
--'FINACLE_MATURITY_DATE'||'|'||
--'MATURITY_DATE_MATCH'||'|'||
--'LEG_AUTO_RENEWAL_FLAG'||'|'||
--'FINACLE_AUTO_RENEWAL_FLG'||'|'||
--'LEG_AUTO_CLOSURE_FLG'||'|'||
--'FINACLE_AUTO_CLOSURE_FLG'||'|'||
--'FINACLE_INT_TABLE_RATE'||'|'||
--'LEG_ABSOLUTE_RATE'||'|'||
--'FINACLE_ABSOLUTE_RATE'||'|'||
--'ABSOLUTE_RATE_MATCH'||'|'||
--'LEG_ACCOUNT_BALANCE'||'|'||
--'FINACLE_CLEAR_BALANCE_AMOUNT'||'|'||
--'ACCOUNT_BALANCE_MATCH'||'|'||
--'LEG_LEGDER_BALANCE'||'|'||
--'MANAGER_CODE'||'|'||
--'LEG_NOMINATED_ACC'||'|'||
--'FINACLE_NOMINATED_ACC'||'|'||
--'NOMINATED_ACC_MATCH'
--from dual
--union all
--select distinct
--to_char(map_acc.leg_branch_id) ||'|'||
--to_char(gam.sol_id) ||'|'||
--to_char(map_acc.leg_scan) ||'|'||
--to_char(map_acc.LEG_SCAS) ||'|'||
--to_char(map_acc.currency) ||'|'||
--to_char(gam.acct_crncy_code) ||'|'||
--case when to_char(gam.acct_crncy_code) = gam.acct_crncy_code THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(gam.cif_id) ||'|'||
--to_char(map_acc.leg_acc_num) ||'|'||
--TO_CHAR(V5PF.V5DLR) ||'|'||
--to_char(gam.foracid) ||'|'|| 
--to_char(map_acc.leg_cust_type) ||'|'||
--to_char(map_acc.leg_acct_type) ||'|'|| 
--to_char(map_acc.schm_code) ||'|'||
--to_char(gsp.SCHM_DESC)||'|'||
--to_char(gam.ACCT_NAME) ||'|'||
--to_char(id_Dr_pref_pcnt) ||'|'||
--to_char(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi)  and nvl(clmamount,0)  <> 0 
--                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
--            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end)||'|'||
--to_char(tam.deposit_amount) ||'|'||
--case when trim(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi)  and nvl(clmamount,0)  <> 0 
--                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
--            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end) = to_char(tam.deposit_amount) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
--            else ' ' end)  ||'|'||
--TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY')||'|'||
--case when  to_char(case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
--            else ' ' end)  = TO_CHAR (gam.acct_opn_date, 'DD-MON-YYYY') then 'TRUE' else 'FALSE' end  ||'|'||
--case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--            to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MON-YYYY')
--            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
--            else  '' end  ||'|'||
--TO_CHAR (tam.open_effective_date, 'DD-MON-YYYY') ||'|'||
--case when (case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--            to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MON-YYYY')
--            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MON-YYYY')
--            else  '' end)  = TO_CHAR (tam.open_effective_date, 'DD-MON-YYYY')  then 'TRUE' else 'FALSE' end ||'|'||
--case when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null and v5ani <> '111112' 
--           then to_char(v5abi||v5ani||v5asi)
--           when v5ani ='111112'
--           then to_char(iv.omabf||iv.omanf||iv.omasf)
--           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--           then to_char(iv.omabf||iv.omanf||iv.omasf)
--           else ''
--           end ||'|'||
--case
--           when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null and v5ani <> '111112' 
--           then to_char(get_oper_acct(v5abi||v5ani||v5asi))
--           when v5ani ='111112'
--           then to_char(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) 
--           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--           then to_char(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) 
--           else '' end ||'|'||
--TO_CHAR(pm.omabf||pm.omanf||pm.omasf) ||'|'||
--TO_CHAR(get_oper_acct(pm.omabf||pm.omanf||pm.omasf))  ||'|'||           
--case when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
--                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end  ||'|'||
--TO_CHAR (eit.interest_calc_upto_date_cr, 'DD-MON-YYYY' ) ||'|'||
--case when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
--                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end  ||'|'||
--TO_CHAR(eit.last_interest_run_date_cr,'DD-MON-YYYY')||'|'||
--case when v5abd||v5and||v5asd=v5abi||v5ani||v5asi then to_char(to_number((v5am4)/POWER(10,C8CED))) else ' ' end ||'|'||
--to_char(tam.cumulative_int_credited)||'|'||
--CASE WHEN (case when v5abd||v5and||v5asd=v5abi||v5ani||v5asi then to_char(to_number((v5am4)/POWER(10,C8CED))) else ' ' end)  = to_char(tam.cumulative_int_credited) THEN 'TRUE' ELSE 'FALSE' END ||'|'||
--to_char(case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
--            to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
--            else to_char(to_date(get_date_fm_btrv(V5NRD),'YYYYMMDD'),'DD-MM-YYYY') end) ||'|'||   --- challenge
--TO_CHAR (tam.maturity_date, 'DD-MON-YYYY') ||'|'||
--CASE WHEN (case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
--            to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
--            else to_char(to_date(get_date_fm_btrv(V5NRD),'YYYYMMDD'),'DD-MM-YYYY') end) = TO_CHAR (tam.maturity_date, 'DD-Mm-YYYY') THEN 'TRUE' ELSE 'FALSE' END  ||'|'||
--rpad(case when v5pf.v5arc in ('A','P') then 'N'
--                when HYDBNM||HYDLP||HYDLR is not null then 'U' 
--                when v5pf.v5mdt=9999999 then 'U'
--                else 'N' end,1,' ') ||'|'||
--to_char(tam.auto_renewal_flg) ||'|'||
--rpad(
--rpad(case when v5pf.v5arc in ('A','P') then 'N'
--                when HYDBNM||HYDLP||HYDLR is not null then 'N' 
--                when v5pf.v5mdt=9999999 then 'N'
--                else 'Y' end,1,' '),1,' ') ||'|'||
--to_char(tam.close_on_maturity_flg) ||'|'||
--to_char(csp.INT_TBL_CODE) ||'|'||
--to_char(case when trim(v5pf.v5rat)='0' then lpad(to_char(nvl(trim(D4BRAR),0)),8,' ')
--when  TO_number(trim(v5pf.v5rat)) between 0.001 and 0.999 then lpad('0'||to_char(trim(v5pf.v5rat)),8,' ')
--else lpad(to_char(trim(v5pf.v5rat)),8,' ')
--end)||'|'||
--to_char(ID_CR_PREF_PCNT + NRML_PCNT_CR)||'|'||
--case when (case when v5pf.v5rat='0' then lpad(to_char(nvl(D4BRAR,0)),8,' ')
--when  TO_number(v5pf.v5rat) between 0.001 and 0.999 then lpad('0'||to_char(v5pf.v5rat),8,' ')
--else lpad(to_char(v5pf.v5rat),8,' ')
--end) = (ID_CR_PREF_PCNT + NRML_PCNT_CR) then 'TRUE' else 'FALSE' end ||'|'||
--to_char(case when v5abd||v5and||v5asd=v5abi||v5ani||v5asi and nvl(clmamount,0)  <> 0 
--                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
--            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end)  ||'|'||
--to_char(TO_NUMBER (tam.deposit_amount))||'|'||
--case when to_char(case when v5abd||v5and||v5asd=v5abi||v5ani||v5asi and nvl(clmamount,0)  <> 0 
--                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
--            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end)  =to_char(TO_NUMBER (tam.deposit_amount))  then 'TRUE' else 'FALSE' end  ||'|'||
--to_char((scbal - SCSUMA)/POWER(10,C8CED))||'|'||
--to_char(scaco) ||'|'||
--case when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null            
--then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')                     
--when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--then rpad(get_oper_acct(iv.omabf||iv.omanf||iv.omasf),16,' ') 
--else rpad(' ',16,' ') end||'|'||
--gam_oper.foracid||'|'||
--case when trim(case when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null            
--then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')                     
--when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--then rpad(get_oper_acct(iv.omabf||iv.omanf||iv.omasf),16,' ') 
--else rpad(' ',16,' ') end) = (gam_oper.foracid) then 'TRUE' else 'FALSE' end           
--from v5pf
--inner join scpf on trim(scpf.SCAB)=trim(v5pf.V5ABD) and trim(scpf.scan)=trim(v5pf.V5AND) and trim(scpf.scas)=trim(v5pf.V5ASD) and scpf.scccy=v5pf.V5CCY
--inner join map_acc on map_acc.LEG_ACC_NUM=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
--left join map_cif mc on mc.fin_cif_id=map_acc.fin_cif_id
--inner join c8pf on c8ccy =scpf.scccy
--LEFT JOIN (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam ON gam.foracid = map_acc.fin_acc_num
--LEFT JOIN (select * from TBAADM.ALR where bank_id=get_param('BANK_ID'))ALR ON ALR.ACID = GAM.ACID
--LEFT JOIN (select * from tbaadm.tam where bank_id=get_param('BANK_ID'))tam ON tam.acid = gam.acid
--left join (select * from tbaadm.gam where bank_id=get_param('BANK_ID'))gam_oper on tam.REPAYMENT_ACID=gam_oper.acid
--LEFT JOIN (select * from tbaadm.eit where bank_id=get_param('BANK_ID'))eit ON eit.entity_id = gam.acid 
--left join (select *  from tbaadm.gsp   where bank_id = get_param('BANK_ID') and del_flg = 'N')gsp on  map_acc.schm_code = gsp.schm_code
--LEFT JOIN (select * from tbaadm.itc where bank_id=get_param('BANK_ID'))itc ON itc.entity_id = gam.acid AND itc.entity_type = 'ACCNT'
--left join crmuser.accounts b on b.orgkey = map_acc.fin_cif_id     
--left join ospf on v5brnm=osbrnm and v5dlp=osdlp and v5dlr=osdlr
--left join (select * from otpf where ottdt='D')otpf on v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
--left join ompf_iv iv on v5brnm=iv.ombrnm and v5dlp=iv.omdlp and v5dlr=iv.omdlr
--left join ompf_pm pm on v5brnm=pm.ombrnm and v5dlp=pm.omdlp and v5dlr=pm.omdlr
--left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) clmamount  from v5pf
--inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
--inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
--where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') > case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
--when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
--and v5pf.v5tdt='D' and v5pf.v5bal<>'0'        
--Group by v5brnm,v5dlp,v5dlr)int_amt on int_amt.v5brnm =v5pf.v5brnm and int_amt.v5dlp=v5pf.v5dlp  and  int_amt.v5dlr=v5pf.v5dlr
--left join d4pf on d4brr=V5PF.v5brr
--left join jrpf on trim(jrpf.jrprc) =trim(v5pf.v5prc) 
--left join (select* from hypf where hydlr is not null) hypf on HYDBNM||HYDLP||HYDLR = map_acc.leg_acc_num
--left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code = map_acc.CURRENCY  
--left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'N' group by schm_code)gss  on map_acc.schm_code = gss.schm_code
--left join (select * from tbaadm.TSP where bank_id = get_param('BANK_ID') and del_flg = 'N' )TSP  on map_acc.schm_code = TSP.schm_code AND Tsp.crncy_code = map_acc.CURRENCY 
--left join gfpf  on nvl(trim(gfpf.gfclc),' ')=nvl(trim(mc.gfclc),' ') and  trim(gfpf.gfcus)=trim(mc.gfcus)
--where map_acc.SCHM_TYPE='TDA' and v5pf.v5tdt='D' and v5pf.v5bal<>'0'
--and (B.STAFFFLAG ='N' or b.staffflag is null);
exit; 
