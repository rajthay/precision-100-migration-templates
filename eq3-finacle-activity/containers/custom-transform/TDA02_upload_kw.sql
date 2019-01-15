
-- File Name        : TDA02_upload.sql
-- File Created for    : Upload file for TD Master
-- Created By        : Jagadeesh.M
-- Client            : ENBD
-- Created On        : 24-06-2015
-------------------------------------------------------------------
drop table ompf_pm;
create table ompf_pm as
select * from ompf where ommvt='P' and OMMVTS='M';
create index ompf_pm_idx on ompf_pm(ombrnm,omdlp,omdlr);
drop table owpf_note_tda;
create table owpf_note_tda as
select trim(owbrnm)||trim(owdlp)||trim(owdlr) leg_acc,OWSD1,OWSD2,OWSD3,OWSD4 from owpf 
where owmvt = 'P' and owmvts = 'C';
create index owpf_idx on owpf_note_tda(leg_acc);
drop table future_interest;
create table future_interest as 
select leg_acc_num,sum((omnwp +omnwr)/power(10,c8ced))interest_to_be_paid_in_future from map_acc
inner join (select * from ompf where to_number(omdte) > to_number(get_param('EODCYYMMDD')) and ommvt = 'I' and trim(ommvts) is null)ompf on ombrnm||omdlp||omdlr = leg_acc_num
inner join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr) = leg_acc_num
inner join c8pf on c8ccy =currency
where schm_type= 'TDA'
group by leg_acc_num;
truncate table TDA_O_TABLE;
insert into TDA_O_TABLE 
select distinct/*+use_hash(scab,scan,scas,scccy,ombrnm,omdlp,omdlr) */
--   v_Employee_Id                  CHAR(9)
            lpad(' ',9,' '),
-- v_Customer_Credit_Pref_Percent   CHAR(10)
            lpad(' ',10,' '),
-- v_Customer_Debit_Pref_Percent    CHAR(10)
            lpad(' ',10,' '),
-- v_Account_Credit_Pref_Percent    CHAR(10)
            lpad(' ',10,' '),
-- v_Account_Debit_Pref_Percent     CHAR(10)
            lpad(' ',10,' '),
-- v_Channel_Credit_Pref_Percent    CHAR(10)
            lpad(' ',10,' '),
-- v_Channel_Debit_Pref_Percent     CHAR(10)
            lpad(' ',10,' '),
--   v_Pegged_Flag                  CHAR(1)
            rpad(case when v5pf_acc_num is not null then 'N' when trim(v5prc) is not null then 'Y' else 'N' end,1,' '),
--   v_Peg_Frequency_in_Months      CHAR(4)
            lpad(case when v5pf_acc_num is not null then ' ' when v5prc like '%M%' then to_Char(replace(v5prc,'M',''))
            when v5prc like '%Y%' then to_Char(replace(v5prc,'Y','')*12)
            else ' ' end,4,' '),
--   v_Peg_Frequency_in_Days        CHAR(3)
            lpad(case when v5pf_acc_num is not null then ' ' when v5prc like '%D%' then to_char(replace(v5prc,'D',''))
            else ' ' end,3,' '),
-- v_sulabh_flg                     CHAR(1)
            rpad(' ',1,' '),
--   v_interest_accrual_flag        CHAR(1)
            rpad('Y',1,' '),                                   -- Need confirmation from Business
-- v_Passbook_Sheet_Receipt_Ind     CHAR(1)
            rpad('N',1,' '),
-- v_With_holdng_tax_amt_scope_flg  CHAR(1)
            lpad(' ',1,' '),
--   v_With_holding_tax_flag        CHAR(1)
            lpad('N',1,' '),
-- v_safe_custody_flag              CHAR(1)
            rpad('N',1,' '),
--   v_cash_excp_amount_limit       CHAR(17)
            lpad(' ',17,' '),
-- v_clearing_excp_amount_limit     CHAR(17)
            lpad(' ',17,' '),
-- v_Transfer_excp_amount_limit     CHAR(17)
            lpad(' ',17,' '),
--   v_cash_cr_excp_amt_lim         CHAR(17)
            lpad(' ',17,' '),
--   v_Clearing_cr_excp_amt_lim     CHAR(17)
            lpad(' ',17,' '),
--   v_Transfer_cr_excp_amt_lim     CHAR(17)
            lpad(' ',17,' '),
--   v_Deposit_Account_Number       CHAR(16)
            lpad(map_acc.fin_acc_num,16,' '),        -- Need to write the a/c number generation for TD
--   v_Currency_Code                CHAR(3)
            lpad(map_acc.currency,3,' '),
--   v_SOL_ID                       CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_GL_Sub_head_code             CHAR(5)
            rpad(nvl(map_acc.GL_SUB_HEADCODE,' '),5,' '),
--   v_Scheme_Code                  CHAR(5)
            rpad(map_acc.schm_code,5,' '),                    -- Defaulted as no BPD values
--   v_CIF_ID                       CHAR(32)
            lpad(map_acc.fin_cif_id,32,' '),
--   v_Deposit_amount               CHAR(17)
            --lpad(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi or trim(v5ifq) is null)  and nvl(clmamount,0)  <> 0 
			lpad(case when map_acc.schm_code='TDATD' then nvl(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),0)-nvl(to_number(atd_clmamount)/POWER(10,C8CED),0) -- nvl(to_number(atd_clmamount)/POWER(10,C8CED),0)- subtracted on 25-09-2017 as per vijay,ravi and sandeep discusion. Only deposit amount need to provided
			when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi)  and nvl(clmamount,0)  <> 0 then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end,17,' '),
--   v_Deposit_period_months        CHAR(3)
            lpad(' ',3,' '),                                -- Maturity date value is given in TD002-065 filed so this is not required.
--   v_Deposit_period_days          CHAR(3)
            lpad(' ',3,' '),                                -- Maturity date value is given in TD002-065 filed so this is not required.
--   v_Interest_table_code          CHAR(5)
            rpad(case when v5pf_acc_num is not null then to_char(dep_rate.tbl_code) else to_char(csp.INT_TBL_CODE) end,5,' '),                        
--  v_Mode_of_operation             CHAR(5)
            rpad('012',5,' '),                                    -- Defaulted as no BPD values
--   v_Account_location_code        CHAR(5)
            lpad(' ',5,' '),
--  v_Auto_Renewal_Flag             CHAR(1)
           rpad(case when v5pf.v5arc in ('A','P') then 'N'
                --when HYDBNM||HYDLP||HYDLR is not null then 'U'  --commented as per spira 7096 and vijay confirmation on 06-07-2017. auto renewal no need for collateral account
                when v5pf.v5mdt=9999999 then 'U'
                else 'N' end,1,' '),    
-- v_Prd_in_mnths_for_auto_renewal  CHAR(3)
            lpad(case when v5pf.v5mdt=9999999 then case when jrpf.jrddy like 'M'  then 
                        to_char(jrpf.jrnum)
                    when jrpf.jrddy like 'Y'  then 
                              to_char(jrpf.jrnum*12)
                    when jrpf.jrddy like 'D'  and jrpf.jrnum > 360 then 
                          to_char(floor(jrpf.jrnum/30))
                          else '0'
               end else '0' end,3,' '),                            
-- v_Prd_in_days_for_auto_renewal   CHAR(3)
            lpad( case when v5pf.v5mdt=9999999 then case when jrpf.jrddy = 'D' and jrpf.jrnum > 360  then 
                    to_char(mod(jrpf.jrnum,30)) 
                when jrpf.jrddy = 'D' and jrpf.jrnum <= 360  then 
                     to_char(jrpf.jrnum)
                when jrpf.jrddy = 'W'  then to_char(JRNUM*7)     
                else '0' end
				else '0' end
             ,3,' '),                            
--  v_Account_Open_Date             CHAR(10)
            case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else rpad(' ',10,' ') end,
--   v_Open_Effective_Date          CHAR(10)
            case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else  rpad(' ',10,' ')
            end,
-- v_Nominee_Print_Flag             CHAR(1)
            rpad('N',1,' '),
--   v_Printing_Flag                CHAR(1)
            case when SCAID3='Y' then rpad('Y',1,' ')
            else rpad('N',1,' ') end,
--   v_Ledger_Number                CHAR(3)
            lpad(' ',3,' '),
-- v_Last_Credit_Int_Posted_Date    CHAR(10)
            case --when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')---- commented on 09-09-2017 based on sandeep requirement and finding from day 1 recon
                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
                 when v5lcd<>0 and v5lre=0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')------Added on 09-09-2017 based on sandeep requirement and day1 recon
			else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end,
--   v_Last_Credit_Int_Run_Date     CHAR(10)
            case --when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')---commented on 09-09-2017 based on sandeep requirement and day1 recon
                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
                 when v5lcd<>0 and v5lre=0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')------Added on 09-09-2017 based on sandeep requirement and day1 recon
			else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end ,
-- v_Last_Interest_Provision_Date   CHAR(10)            
             case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
             rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
             when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
             rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
             else  rpad(' ',10,' ')
             end,
--   v_Printed_date                 CHAR(10)
            --lpad(' ',10,' '),
            case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else  rpad(' ',10,' ')
            end,
--   v_Cumulative_Interest_Paid     CHAR(17)
            --lpad(case when (v5abd||v5and||v5asd<>v5abi||v5ani||v5asi and trim(v5ifq) is not null)  then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0') --commented on 06-07-2017 based on RTD0600000027699 deal issue
			lpad(case 
			--when trim(v5pf.v5dlp)='ATD' then nvl(to_char(to_number((atd_clmamount)/POWER(10,C8CED))),'0') ---commented changed on 29-09-2017 based on drill 1 observation and sandeep requirement
			when (v5abd||v5and||v5asd<>v5abi||v5ani||v5asi)  then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0') 
			else ' ' end,17,' '),
-- v_Cumulative_interest_credited   CHAR(17)
            --lpad(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi  or trim(v5ifq) is null)  then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0')
			lpad(case 
			when trim(v5pf.v5dlp)='ATD' then nvl(to_char(to_number((atd_clmamount)/POWER(10,C8CED))),'0') ---added changed on 29-09-2017 based on drill 1 observation and sandeep requirement
			when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi )  then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0')--commented on 06-07-2017 based on RTD0600000027699 deal issue
            else ' ' end,17,' '),       
-- v_Cumulative_installments_paid   CHAR(17)            
            --lpad(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),17,' '),
            --lpad(nvl(to_char(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi  or trim(v5ifq) is null) and nvl(clmamount,0)  <> 0   --commented on 06-07-2017 based on RTD0600000027699 deal issue
			lpad(nvl(to_char(case 
			when map_acc.schm_code='TDATD' then nvl(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),0)-nvl(to_number(atd_clmamount)/POWER(10,C8CED),0) ---added changed on 29-09-2017 based on drill 1 observation and sandeep requirement
			when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi ) and nvl(clmamount,0)  <> 0 
                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end),' '),17,' '),
--   v_Maturity_amount              CHAR(17)           
            --case when (v5abd||v5and||v5asd<>v5abi||v5ani||v5asi and trim(v5ifq) is not null) then lpad(nvl(to_char(to_number(v5pf.v5bal)/power(10,c8pf.c8ced)),' '),17,' ')--commented on 06-07-2017 based on RTD0600000027699 deal issue
			case when map_acc.schm_code='TDATD' then lpad(to_char(nvl(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),0)),17,' ') -- nvl(to_number(atd_clmamount)/POWER(10,C8CED),0)+ removed on 25-09-2017 as per vijay,ravi and sandeep discusion. Only deposit amount need to provided
			when tsd.FLOW_CODE ='IO' then lpad(nvl(to_char(to_number(v5pf.v5bal)/power(10,c8pf.c8ced)),' '),17,' ') --added on 01-08-2017 as per dicussion with vijay and sandeep due to maturity amount issue for II account
			--when (v5abd||v5and||v5asd<>v5abi||v5ani||v5asi) then lpad(nvl(to_char(to_number(v5pf.v5bal)/power(10,c8pf.c8ced)),' '),17,' ')--commented on 01-08-2017 as per dicussion with vijay and sandeep due to maturity amount issue for II account
			--else lpad(nvl(to_char(to_number(v5pf.v5bal+nvl(interest_to_be_paid_in_future,0))/power(10,c8pf.c8ced)),' '),17,' ') end, -- commented as interest_to_be_paid_in_future was divided twice, changed on 18-4-2017 based on issues from Users
            else lpad(nvl(to_char(to_number(v5pf.v5bal)/power(10,c8pf.c8ced)+nvl(interest_to_be_paid_in_future,0)),' '),17,' ') end,
--   v_Operative_Account_Number     CHAR(16)
           case          
           when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null            
           then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')                     
           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
           then rpad(get_oper_acct(iv.omabf||iv.omanf||iv.omasf),16,' ') 
           else rpad(' ',16,' ') end,
           --case
           --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null 
           --then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')           
           --else rpad(' ',16,' ') end,
-- v_Operative_Account_Crncy_Code   CHAR(3)           
           case           
           when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
           then rpad(get_oper_ccy(v5abi||v5ani||v5asi),3,' ')           
           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
           then rpad(trim(get_oper_ccy(iv.omabf||iv.omanf||iv.omasf)),3,' ') 
           else rpad(' ',3,' ')end,
           --case
           --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
           --then rpad(get_oper_ccy(v5abi||v5ani||v5asi),3,' ')             
           --else rpad(' ',3,' ')end,
--   v_Operative_Account_SOL        CHAR(8)          
          case          
          when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
          then rpad(to_char(get_oper_sol(v5abi||v5ani||v5asi)),8,' ')          
          when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
          then rpad(to_char(get_oper_sol(iv.omabf||iv.omanf||iv.omasf)),8,' ')
          else rpad(' ',8,' ') end,
          --case
          --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
          --then rpad(to_char(get_oper_sol(v5abi||v5ani||v5asi)),8,' ')
          --else rpad(' ',8,' ') end,
-- v_Notice_prd_Mnts_forNotice_Dep  CHAR(3)
            lpad(' ',3,' '),                
-- v_Notice_prd_Days_forNotice_Dep  CHAR(3)
            lpad(' ',3,' '),
--V_NOTICE_DATE CHAR(10)
            lpad(' ',10,' '),            
--   v_Stamp_Duty_Borne_By_Cust     CHAR(1)
            lpad(' ',1,' '),
-- v_Stamp_Duty_Amount              CHAR(1)
            lpad(' ',17,' '),
-- v_Stamp_Duty_Amount_Crncy_Code   CHAR(3)
            lpad(' ',3,' '),
--   v_Original_Deposit_Amt         CHAR(17)
            lpad(' ',17,' '),                                        -- Need to check if we need to bring this value
-- v_Absolute_Rate_of_Interest      CHAR(8)            
            case when v5pf.v5rat='0' then lpad(to_char(nvl(D4BRAR,0)),8,' ')
            when  TO_number(v5pf.v5rat) between 0.001 and 0.999 then lpad('0'||to_char(v5pf.v5rat),8,' ')
            else lpad(to_char(v5pf.v5rat),8,' ')
            end,
-- v_Exclude_for_combined_stmnt     CHAR(1)
            lpad(' ',1,' '),
--   v_Statement_CIF_ID             CHAR(32)
            lpad(' ',32,' '),
--   v_Maturity_Date                CHAR(10)            
            rpad(case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
            to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
            else to_char(to_date(get_date_fm_btrv(V5NRD),'YYYYMMDD'),'DD-MM-YYYY') end,10,' '),   ----based on Spira issue 7089- script  changed on 02-07-2017         
 --      rpad(case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
 --         to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'M' and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
 --        to_char(add_months(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),JRNUM),'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'Y' and v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
 --        to_char(add_months(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),JRNUM*12),'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'W'and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
 --        to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')+JRNUM*7,'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'D'and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
 --        to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')+JRNUM,'DD-MM-YYYY')        
 --  when  jrpf.jrddy like 'M'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
 --        to_char(add_months(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD'),JRNUM),'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'Y'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
 --        to_char(add_months(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD'),JRNUM*12),'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'W'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
 --        to_char(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD')+JRNUM*7,'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'D'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
 --        to_char(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD')+JRNUM,'DD-MM-YYYY')        
 --          end,10,' '),
--  v_Treasury_Rate_MOR             CHAR(8)
            lpad(' ',8,' '),
--   v_Renewal_Option               CHAR(1)
           rpad(case when v5pf.v5arc in ('A','P') then ' '
                --when HYDBNM||HYDLP||HYDLR is not null and v5abd||v5and||v5asd<>v5abi||v5ani||v5asi then 'P' --commented as per spira 7096 and vijay confirmation on 06-07-2017. auto renewal no need for collateral account
                --when HYDBNM||HYDLP||HYDLR is not null and v5abd||v5and||v5asd=v5abi||v5ani||v5asi then 'M'  --commented as per spira 7096 and vijay confirmation on 06-07-2017. auto renewal no need for collateral account
                when v5pf.v5mdt=9999999 and  v5abd||v5and||v5asd<>v5abi||v5ani||v5asi then 'P'
                when v5pf.v5mdt=9999999 and  v5abd||v5and||v5asd=v5abi||v5ani||v5asi then 'M'
                else ' ' end,1,' '), 
--   v_Renewal_Amount               CHAR(17)
            lpad(' ',17,' '),
--   v_Additional_Amt               CHAR(17)
            lpad(' ',17,' '),
--   v_Addnl_Amt_Crncy              CHAR(3)
            lpad(' ',3,' '),
--   v_Renewal_Crncy                CHAR(3)
            lpad(' ',3,' '),
-- v_Additional_Source_Account      CHAR(16)
            lpad(' ',16,' '),
-- v_Aditional_Src_acct_Crncy_Code  CHAR(3)
            lpad(' ',3,' '),
--   v_Additional_Ac_Sol_Id         CHAR(8)
            lpad(' ',8,' '),
--   v_Additional_Rate_Code         CHAR(5)
            lpad(' ',5,' '),
--  v_Renewal_Rate_Code             CHAR(5)
            lpad(' ',5,' '),
--   v_Additional_Rate              CHAR(8)
            lpad(' ',8,' '),
--   v_Renewal_Rate                 CHAR(8)
            lpad(' ',8,' '),
--   v_Link_Operative_Account       CHAR(16)
            lpad(' ',16,' '),
--  v_Break_in_Steps_Of             CHAR(17)
            lpad(' ',17,' '),
--   v_wtax_level_flg               CHAR(1)
            lpad(' ',1,' '),
--  v_Wtax_pcnt                     CHAR(8)
            lpad(' ',8,' '),
--   v_Wtax_floor_limit             CHAR(17)
            lpad(' ',17,' '),
--   v_Iban_number                  CHAR(34)
            lpad(' ',34,' '),
--   v_Ias_code                     CHAR(5)
            lpad(' ',5,' '),
-- v_Channel_ID                     CHAR(5)
            lpad(' ',5,' '),
-- v_Channel_Level_Code             CHAR(5)
            lpad(' ',5,' '),
--   v_Master_acct_num              CHAR(16)
            lpad(' ',16,' '),
--   v_acct_status                  CHAR(1)
            rpad('A',1,' '),
--   v_acct_status_date             CHAR(8)
            lpad(' ',10,' '),
--   v_Dummy                        CHAR(100)
            lpad(nvl(trim(' ')||' '||trim(' ')||' '||trim(' ')||' '||trim(' '),' '),100,' '),
-- v_ps_diff_freq_rel_party_flg     CHAR(1)
            lpad(' ',1,' '),
-- v_swift_diff_freq_rel_party_flg  CHAR(1)
            lpad(' ',1,' '),
-- v_Fixed_instal_amt_Amt_topup     CHAR(17)
            lpad(' ',17,' '),
-- v_Normal_Installment_Percentage  CHAR(10)
            lpad(' ',10,' '),
-- v_Installment_basis              CHAR(1)
            lpad(' ',1,' '),
-- v_Max_missed_contribut_allowed   CHAR(3)
            lpad(' ',3,' '),
-- v_Auto_closure_of_irregular_act  CHAR(1)
            lpad(' ',1,' '),
-- v_Total_num_of_missed_contribut  CHAR(3)
            lpad(' ',3,' '),
--   v_Account_Irregular_status     CHAR(1)
            lpad(' ',1,' '),
-- v_Account_Irregular_Status_Date  CHAR(8)
            lpad(' ',10,' '),
-- v_Cumulative_Normal_Instal_paid  CHAR(17)
            lpad(' ',17,' '),
-- v_Cumulative_Initial_Dep_paid    CHAR(17)
            lpad(' ',17,' '),
--   v_Cumulative_Top_up_paid       CHAR(17)
            lpad(' ',17,' '),
-- v_AutoClosure_Zero_Bal_Acct_Mnts CHAR(3)
            lpad(' ',3,' '),
-- v_AutoClosure_Zero_Bal_Acct_Days CHAR(3)
            lpad(' ',3,' '),
--   v_Last_Bonus_Run_Date          CHAR(8)
            lpad(' ',10,' '),
-- v_Last_Calculated_Bonus_Amount   CHAR(17)
            lpad(' ',17,' '),
--   v_Bonus_Up_to_Date             CHAR(17)
            lpad(' ',17,' '),
--   v_Next_Bonus_Run_Date          CHAR(8)
            lpad(' ',10,' '),
-- v_Normal_Int_Paid_tilllast_Bonus CHAR(17)
            lpad(' ',17,' '),
--   v_Bonus_Cycle                  CHAR(3)
            lpad(' ',3,' '),
-- v_Last_Calc_Bonus_percentage     CHAR(10)
            lpad(' ',10,' '),
--   v_Penalty_Amount               CHAR(17)
            lpad(' ',17,' '),
--   v_Penalty_Charge_Event_Id      CHAR(25)
            lpad(' ',25,' '),
--   v_Address_Type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Phone_Type                     CHAR(12)
            lpad(' ',12,' '),
-- v_Email_Type                     CHAR(12)
            lpad(' ',12,' '),
-- v_Local_Deposit_period_months    CHAR(3)
            lpad(' ',3,' '),
--  v_Local_Deposit_period_days     CHAR(3)
            lpad(' ',3,' '),
--   v_Is_Account_hedged_flag       CHAR(1)
            lpad(' ',1,' '),
--  v_Used_For_Netting_Off_flag     CHAR(1)
            lpad(' ',1,' '),
    --MAX_AUTO_RENEWAL_ALLOWED    nvarchar2(3),
rpad(' ',3,' '),    
--AUTO_CLOSURE_IND    nvarchar2(1),
           rpad(case when v5pf.v5arc in ('A','P') then 'N'
                --when HYDBNM||HYDLP||HYDLR is not null then 'N' ----commented as per spira 7096 and vijay confirmation on 06-07-2017. auto renewal no need for collateral account
                when v5pf.v5mdt=9999999 then 'N'
                when map_acc.schm_code='TDATD' then 'N' ---- as per sandeep confirmation on mock 3a upload and error shared in mail dt 12-03-2017---'N' to 'Y' changed on 16-07-2017 based on hiyam and vijay confirmation due to mk5 issue raised by hiyam--as per sandeep confirmation TDATD scheme auto closure flg should't be 'Y'. So 'Y' to 'N' changed on 17-07-2017
                else 'Y' end,1,' '),    
--LAST_PURGE_DATE    nvarchar2(10),
rpad(' ',10,' '),    
    --PAY_PRECLS_PROFIT    nvarchar2(1),
rpad(' ',1,' '),    
    --PAY_MATURITY_PROFIT    nvarchar2(1),
rpad(' ',1,' '),    
    --MURABAHA_DEPOSIT_AMOUNT    nvarchar2(17),
rpad(' ',17,' '),    
    --CUSTOMER_PURCHASE_ID    nvarchar2(20),
rpad(' ',20,' '),
    --TOTAL_PROFIT_AMOUNT    nvarchar2(17),
rpad(' ',17,' '),    
    --MINIMUM_AGE_NOT_MET    nvarchar2(17),
rpad(' ',17,' '),    
    --BROKEN_PERIOD_PROFIT_PAID nvarchar2(1),
rpad(' ',1,' '),    
    --BROKEN_PERIOD_PROFIT_AMOUNT    nvarchar2(17),
rpad(' ',17,' '),    
    --PROFIT_BE_RECOVERED    nvarchar2(17),
rpad(' ',17,' '),    
    --INDICATE_PROFIT_DIST_UPTO_DATE    nvarchar2(10),
rpad(' ',10,' '),    
    --INDICATE_NEXT_PROFIT_DIST_DATE    nvarchar2(10),
rpad(' ',10,' '),    
    --TRANSFER_IN_IND    nvarchar2(1),
rpad(' ',1,' '),    
--REPAYMENT_ACCOUNT    nvarchar2(16),
rpad(get_oper_acct(pm.omabf||pm.omanf||pm.omasf),16,' '),    
--rpad(' ',16,' '),    
    --REBATE_AMOUNT    nvarchar2(17),
rpad(' ',17,' '),    
    --BRANCH_OFFICE    nvarchar2(20),
rpad(' ',20,' '),    
    --DEFERMENT_PERIOD_MONTHS    nvarchar2(3),
rpad(' ',3,' '),    
    --CONTINUATION_IND    nvarchar2(1)
rpad(' ',1,' ')            
from v5pf
inner join scpf on SCAB=V5ABD and scan=V5AND and scas=V5ASD 
inner join map_acc on map_acc.LEG_ACC_NUM=v5brnm||trim(v5dlp)||trim(v5dlr)
inner join c8pf on c8ccy =scccy
left join (select * from tbaadm.TSD where srl_num='002' and bank_id='01' ) tsd on tsd.schm_code=map_acc.schm_code
left join ospf on v5brnm=osbrnm and trim(v5dlp)=trim(osdlp) and trim(v5dlr)=trim(osdlr)
left join (select * from otpf where ottdt='D')otpf on v5brnm=otbrnm and trim(v5dlp)=trim(otdlp) and trim(v5dlr)=trim(otdlr)
left join ompf_iv iv on v5brnm=iv.ombrnm and trim(v5dlp)=trim(iv.omdlp) and trim(v5dlr)=trim(iv.omdlr)
left join ompf_pm pm on v5brnm=pm.ombrnm and trim(v5dlp)=trim(pm.omdlp) and trim(v5dlr)=trim(pm.omdlr)
left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) clmamount  from v5pf
inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') > case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
                                                    when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
group by v5brnm,v5dlp,v5dlr)int_amt on int_amt.v5brnm =v5pf.v5brnm and int_amt.v5dlp=v5pf.v5dlp  and  int_amt.v5dlr=v5pf.v5dlr
left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) atd_clmamount  from v5pf
inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') >= case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
                                                   when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
and trim(v4dlp)='ATD' and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
group by v5brnm,v5dlp,v5dlr)atd_int_amt on atd_int_amt.v5brnm =v5pf.v5brnm and atd_int_amt.v5dlp=v5pf.v5dlp  and  atd_int_amt.v5dlr=v5pf.v5dlr
left join d4pf on d4brr=v5brr
left join jrpf on trim(jrpf.jrprc) =trim(v5pf.v5prc) 
--left join (select* from hypf where hydlr is not null) hypf on HYDBNM||HYDLP||HYDLR = map_acc.leg_acc_num
--left join owpf_note_tda on leg_acc=map_acc.leg_acc_num
left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code = map_acc.CURRENCY  
left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'N' group by schm_code)gss  on map_acc.schm_code = gss.schm_code
left join (select * from tbaadm.TSP where bank_id = get_param('BANK_ID') and del_flg = 'N' )TSP  on map_acc.schm_code = TSP.schm_code AND Tsp.crncy_code = map_acc.CURRENCY    
left join future_interest fi on fi.leg_acc_num=map_acc.leg_acc_num
left join (select distinct v5pf_acc_num,tbl_code from dep_rate)dep_rate on  v5pf_acc_num=map_acc.leg_acc_num
where map_acc.SCHM_TYPE='TDA' and v5pf.v5tdt='D' and v5pf.v5bal<>'0';
commit;
--update tda_o_table set RENEWAL_OPTION ='M' where trim(Auto_Renewal_Flag)='U';
--commit; --commented on 29/06/2017 based on issue raised by haiyam. Why was this updated??? there are some renewal option as 'P' in Equation which are updated as "M" which is incorrect 
--CLOSED DEPOSIT ACCOUNTS--
--insert into TDA_O_TABLE 
--select +use_hash(scab,scan,scas,scccy,ombrnm,omdlp,omdlr) 
----   v_Employee_Id                  CHAR(9)
--            lpad(' ',9,' '),
---- v_Customer_Credit_Pref_Percent   CHAR(10)
--            lpad(' ',10,' '),
---- v_Customer_Debit_Pref_Percent    CHAR(10)
--            lpad(' ',10,' '),
---- v_Account_Credit_Pref_Percent    CHAR(10)
--            lpad(' ',10,' '),
---- v_Account_Debit_Pref_Percent     CHAR(10)
--            lpad(' ',10,' '),
---- v_Channel_Credit_Pref_Percent    CHAR(10)
--            lpad(' ',10,' '),
---- v_Channel_Debit_Pref_Percent     CHAR(10)
--            lpad(' ',10,' '),
----   v_Pegged_Flag                  CHAR(1)
--            rpad('N',1,' '),
----   v_Peg_Frequency_in_Months      CHAR(4)
--            lpad(' ',4,' '),
----   v_Peg_Frequency_in_Days        CHAR(3)
--            lpad(' ',3,' '),
---- v_sulabh_flg                     CHAR(1)
--            rpad(' ',1,' '),
----   v_interest_accrual_flag        CHAR(1)
--            rpad('Y',1,' '),                                   -- Need confirmation from Business
---- v_Passbook_Sheet_Receipt_Ind     CHAR(1)
--            rpad('N',1,' '),
---- v_With_holdng_tax_amt_scope_flg  CHAR(1)
--            lpad(' ',1,' '),
----   v_With_holding_tax_flag        CHAR(1)
--            lpad('N',1,' '),
---- v_safe_custody_flag              CHAR(1)
--            rpad('N',1,' '),
----   v_cash_excp_amount_limit       CHAR(17)
--            lpad(' ',17,' '),
---- v_clearing_excp_amount_limit     CHAR(17)
--            lpad(' ',17,' '),
---- v_Transfer_excp_amount_limit     CHAR(17)
--            lpad(' ',17,' '),
----   v_cash_cr_excp_amt_lim         CHAR(17)
--            lpad(' ',17,' '),
----   v_Clearing_cr_excp_amt_lim     CHAR(17)
--            lpad(' ',17,' '),
----   v_Transfer_cr_excp_amt_lim     CHAR(17)
--            lpad(' ',17,' '),
----   v_Deposit_Account_Number       CHAR(16)
--            lpad(map_acc.fin_acc_num,16,' '),        -- Need to write the a/c number generation for TD
----   v_Currency_Code                CHAR(3)
--            lpad(map_acc.currency,3,' '),
----   v_SOL_ID                       CHAR(8)
--            lpad(map_acc.fin_sol_id,8,' '),
----   v_GL_Sub_head_code             CHAR(5)
--            rpad(nvl(map_acc.GL_SUB_HEADCODE,' '),5,' '),
----   v_Scheme_Code                  CHAR(5)
--            rpad(map_acc.schm_code,5,' '),                    -- Defaulted as no BPD values
----   v_CIF_ID                       CHAR(32)
--            lpad(map_acc.fin_cif_id,32,' '),
----   v_Deposit_amount               CHAR(17)
--            lpad(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),17,' '),
----   v_Deposit_period_months        CHAR(3)
--            lpad(' ',3,' '),                                -- Maturity date value is given in TD002-065 filed so this is not required.
----   v_Deposit_period_days          CHAR(3)
--            lpad(' ',3,' '),                                -- Maturity date value is given in TD002-065 filed so this is not required.
----   v_Interest_table_code          CHAR(5)
--            rpad(csp.INT_TBL_CODE,5,' '),                        
----  v_Mode_of_operation             CHAR(5)
--            rpad('012',5,' '),                                    -- Defaulted as no BPD values
----   v_Account_location_code        CHAR(5)
--            lpad(' ',5,' '),
----  v_Auto_Renewal_Flag             CHAR(1)
--           rpad(case when v5pf.v5arc in ('A','P') then 'N'
--                when HYDBNM||HYDLP||HYDLR is not null then 'U' 
--                when v5pf.v5mdt=9999999 then 'U'
--                else 'N' end,1,' '),    
---- v_Prd_in_mnths_for_auto_renewal  CHAR(3)
--            lpad( case when v5pf.v5mdt=9999999 then 
--              case when jrpf.jrddy like 'M'  then 
--                        to_char(jrpf.jrnum)
--                    when jrpf.jrddy like 'Y'  then 
--                              to_char(jrpf.jrnum*12)
--                    when jrpf.jrddy like 'D'  and jrpf.jrnum > 360 then 
--                          to_char(floor(jrpf.jrnum/30))
--                          else '0'
--                          end
--                    else '0'
--               end,3,' '),                            
---- v_Prd_in_days_for_auto_renewal   CHAR(3)
--            lpad( case when v5pf.v5mdt=9999999 then 
--           case when jrpf.jrddy = 'D' and jrpf.jrnum > 360  then 
--                    to_char(mod(jrpf.jrnum,30)) 
--                when jrpf.jrddy = 'D' and jrpf.jrnum <= 360  then 
--                     to_char(jrpf.jrnum)
--                when jrpf.jrddy = 'W'  then to_char(JRNUM*7)     
--                else '0' end
--             else '0'     end,3,' '),                            
----  v_Account_Open_Date             CHAR(10)
--            case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            else rpad(' ',10,' ') end,
----   v_Open_Effective_Date          CHAR(10)
--            case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            else  rpad(' ',10,' ')
--            end,
---- v_Nominee_Print_Flag             CHAR(1)
--            rpad('N',1,' '),
----   v_Printing_Flag                CHAR(1)
--            case when SCAID3='Y' then rpad('Y',1,' ')
--            else rpad('N',1,' ') end,
----   v_Ledger_Number                CHAR(3)
--            lpad(' ',3,' '),
---- v_Last_Credit_Int_Posted_Date    CHAR(10)
--            case when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
--                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end,
----   v_Last_Credit_Int_Run_Date     CHAR(10)
--            case when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
--                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end ,
---- v_Last_Interest_Provision_Date   CHAR(10)            
--             case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--             rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--             when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--             rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--             else  rpad(' ',10,' ')
--             end,
----   v_Printed_date                 CHAR(10)
--            --lpad(' ',10,' '),
--            case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            else  rpad(' ',10,' ')
--            end,
----   v_Cumulative_Interest_Paid     CHAR(17)
--            lpad(case when v5abd||v5and||v5asd<>v5abi||v5ani||v5asi then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0')
--            else ' ' end,17,' '),
---- v_Cumulative_interest_credited   CHAR(17)
--            lpad(nvl(case when v5abd||v5and||v5asd=v5abi||v5ani||v5asi then to_char(to_number((clmamount)/POWER(10,C8CED)))
--            else ' ' end,' '),17,' '),       
---- v_Cumulative_installments_paid   CHAR(17)            
--            lpad(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),17,' '),
----   v_Maturity_amount              CHAR(17)           
--            lpad(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),17,' '),
----   v_Operative_Account_Number     CHAR(16)
--           case          
--           when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null            
--           then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')                     
--           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--           then rpad(get_oper_acct(iv.omabf||iv.omanf||iv.omasf),16,' ') 
--           else rpad(' ',16,' ') end,
--           --case
--           --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null 
--           --then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')           
--           --else rpad(' ',16,' ') end,
---- v_Operative_Account_Crncy_Code   CHAR(3)           
--           case           
--           when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
--           then rpad(get_oper_ccy(v5abi||v5ani||v5asi),3,' ')           
--           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--           then rpad(trim(get_oper_ccy(iv.omabf||iv.omanf||iv.omasf)),3,' ') 
--           else rpad(' ',3,' ')end,
--           --case
--           --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
--           --then rpad(get_oper_ccy(v5abi||v5ani||v5asi),3,' ')             
--           --else rpad(' ',3,' ')end,
----   v_Operative_Account_SOL        CHAR(8)          
--          case          
--          when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
--          then rpad(to_char(get_oper_sol(v5abi||v5ani||v5asi)),8,' ')          
--          when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--          then rpad(to_char(get_oper_sol(iv.omabf||iv.omanf||iv.omasf)),8,' ')
--          else rpad(' ',8,' ') end,
--          --case
--          --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
--          --then rpad(to_char(get_oper_sol(v5abi||v5ani||v5asi)),8,' ')
--          --else rpad(' ',8,' ') end,
---- v_Notice_prd_Mnts_forNotice_Dep  CHAR(3)
--            lpad(' ',3,' '),                
---- v_Notice_prd_Days_forNotice_Dep  CHAR(3)
--            lpad(' ',3,' '),
----V_NOTICE_DATE CHAR(10)
--            lpad(' ',10,' '),            
----   v_Stamp_Duty_Borne_By_Cust     CHAR(1)
--            lpad(' ',1,' '),
---- v_Stamp_Duty_Amount              CHAR(1)
--            lpad(' ',17,' '),
---- v_Stamp_Duty_Amount_Crncy_Code   CHAR(3)
--            lpad(' ',3,' '),
----   v_Original_Deposit_Amt         CHAR(17)
--            lpad(' ',17,' '),                                        -- Need to check if we need to bring this value
---- v_Absolute_Rate_of_Interest      CHAR(8)            
--            case when v5pf.v5rat='0' then lpad(to_char(nvl(D4BRAR,0)),8,' ')
--            when  TO_number(v5pf.v5rat) between 0.001 and 0.999 then lpad('0'||to_char(v5pf.v5rat),8,' ')
--            else lpad(to_char(v5pf.v5rat),8,' ')
--            end,
---- v_Exclude_for_combined_stmnt     CHAR(1)
--            lpad(' ',1,' '),
----   v_Statement_CIF_ID             CHAR(32)
--            lpad(' ',32,' '),
----   v_Maturity_Date                CHAR(10)            
--            --rpad(case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
--            --to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
--            --else to_char(to_date(get_date_fm_btrv(V5NRD),'YYYYMMDD'),'DD-MM-YYYY') end,10,' '),            
--            rpad(case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
--            to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
--     when  jrpf.jrddy like 'M' and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--           to_char(add_months(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),JRNUM),'DD-MM-YYYY')
--     when  jrpf.jrddy like 'Y' and v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--           to_char(add_months(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),JRNUM*12),'DD-MM-YYYY')
--     when  jrpf.jrddy like 'W'and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--           to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')+JRNUM*7,'DD-MM-YYYY')
--     when  jrpf.jrddy like 'D'and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--           to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')+JRNUM,'DD-MM-YYYY')        
--     when  jrpf.jrddy like 'M'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
--           to_char(add_months(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD'),JRNUM),'DD-MM-YYYY')
--     when  jrpf.jrddy like 'Y'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
--           to_char(add_months(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD'),JRNUM*12),'DD-MM-YYYY')
--     when  jrpf.jrddy like 'W'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
--           to_char(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD')+JRNUM*7,'DD-MM-YYYY')
--     when  jrpf.jrddy like 'D'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
--           to_char(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD')+JRNUM,'DD-MM-YYYY')        
--             end,10,' '),
----  v_Treasury_Rate_MOR             CHAR(8)
--            lpad(' ',8,' '),
----   v_Renewal_Option               CHAR(1)
--            ' ',
----   v_Renewal_Amount               CHAR(17)
--            lpad(' ',17,' '),
----   v_Additional_Amt               CHAR(17)
--            lpad(' ',17,' '),
----   v_Addnl_Amt_Crncy              CHAR(3)
--            lpad(' ',3,' '),
----   v_Renewal_Crncy                CHAR(3)
--            lpad(' ',3,' '),
---- v_Additional_Source_Account      CHAR(16)
--            lpad(' ',16,' '),
---- v_Aditional_Src_acct_Crncy_Code  CHAR(3)
--            lpad(' ',3,' '),
----   v_Additional_Ac_Sol_Id         CHAR(8)
--            lpad(' ',8,' '),
----   v_Additional_Rate_Code         CHAR(5)
--            lpad(' ',5,' '),
----  v_Renewal_Rate_Code             CHAR(5)
--            lpad(' ',5,' '),
----   v_Additional_Rate              CHAR(8)
--            lpad(' ',8,' '),
----   v_Renewal_Rate                 CHAR(8)
--            lpad(' ',8,' '),
----   v_Link_Operative_Account       CHAR(16)
--            lpad(' ',16,' '),
----  v_Break_in_Steps_Of             CHAR(17)
--            lpad(' ',17,' '),
----   v_wtax_level_flg               CHAR(1)
--            lpad(' ',1,' '),
----  v_Wtax_pcnt                     CHAR(8)
--            lpad(' ',8,' '),
----   v_Wtax_floor_limit             CHAR(17)
--            lpad(' ',17,' '),
----   v_Iban_number                  CHAR(34)
--            lpad(' ',34,' '),
----   v_Ias_code                     CHAR(5)
--            lpad(' ',5,' '),
---- v_Channel_ID                     CHAR(5)
--            lpad(' ',5,' '),
---- v_Channel_Level_Code             CHAR(5)
--            lpad(' ',5,' '),
----   v_Master_acct_num              CHAR(16)
--            lpad(' ',16,' '),
----   v_acct_status                  CHAR(1)
--            rpad('A',1,' '),
----   v_acct_status_date             CHAR(8)
--            lpad(' ',10,' '),
----   v_Dummy                        CHAR(100)
--            lpad(nvl(trim(' ')||' '||trim(' ')||' '||trim(' ')||' '||trim(' '),' '),100,' '),
---- v_ps_diff_freq_rel_party_flg     CHAR(1)
--            lpad(' ',1,' '),
---- v_swift_diff_freq_rel_party_flg  CHAR(1)
--            lpad(' ',1,' '),
---- v_Fixed_instal_amt_Amt_topup     CHAR(17)
--            lpad(' ',17,' '),
---- v_Normal_Installment_Percentage  CHAR(10)
--            lpad(' ',10,' '),
---- v_Installment_basis              CHAR(1)
--            lpad(' ',1,' '),
---- v_Max_missed_contribut_allowed   CHAR(3)
--            lpad(' ',3,' '),
---- v_Auto_closure_of_irregular_act  CHAR(1)
--            lpad(' ',1,' '),
---- v_Total_num_of_missed_contribut  CHAR(3)
--            lpad(' ',3,' '),
----   v_Account_Irregular_status     CHAR(1)
--            lpad(' ',1,' '),
---- v_Account_Irregular_Status_Date  CHAR(8)
--            lpad(' ',10,' '),
---- v_Cumulative_Normal_Instal_paid  CHAR(17)
--            lpad(' ',17,' '),
---- v_Cumulative_Initial_Dep_paid    CHAR(17)
--            lpad(' ',17,' '),
----   v_Cumulative_Top_up_paid       CHAR(17)
--            lpad(' ',17,' '),
---- v_AutoClosure_Zero_Bal_Acct_Mnts CHAR(3)
--            lpad(' ',3,' '),
---- v_AutoClosure_Zero_Bal_Acct_Days CHAR(3)
--            lpad(' ',3,' '),
----   v_Last_Bonus_Run_Date          CHAR(8)
--            lpad(' ',10,' '),
---- v_Last_Calculated_Bonus_Amount   CHAR(17)
--            lpad(' ',17,' '),
----   v_Bonus_Up_to_Date             CHAR(17)
--            lpad(' ',17,' '),
----   v_Next_Bonus_Run_Date          CHAR(8)
--            lpad(' ',10,' '),
---- v_Normal_Int_Paid_tilllast_Bonus CHAR(17)
--            lpad(' ',17,' '),
----   v_Bonus_Cycle                  CHAR(3)
--            lpad(' ',3,' '),
---- v_Last_Calc_Bonus_percentage     CHAR(10)
--            lpad(' ',10,' '),
----   v_Penalty_Amount               CHAR(17)
--            lpad(' ',17,' '),
----   v_Penalty_Charge_Event_Id      CHAR(25)
--            lpad(' ',25,' '),
----   v_Address_Type                 CHAR(12)
--            lpad(' ',12,' '),
---- v_Phone_Type                     CHAR(12)
--            lpad(' ',12,' '),
---- v_Email_Type                     CHAR(12)
--            lpad(' ',12,' '),
---- v_Local_Deposit_period_months    CHAR(3)
--            lpad(' ',3,' '),
----  v_Local_Deposit_period_days     CHAR(3)
--            lpad(' ',3,' '),
----   v_Is_Account_hedged_flag       CHAR(1)
--            lpad(' ',1,' '),
----  v_Used_For_Netting_Off_flag     CHAR(1)
--            lpad(' ',1,' '),
--    --MAX_AUTO_RENEWAL_ALLOWED    nvarchar2(3),
--rpad(' ',3,' '),    
--    --AUTO_CLOSURE_IND    nvarchar2(1),
--rpad('N',1,' '),     
----LAST_PURGE_DATE    nvarchar2(10),
--rpad(' ',10,' '),    
--    --PAY_PRECLS_PROFIT    nvarchar2(1),
--rpad(' ',1,' '),    
--    --PAY_MATURITY_PROFIT    nvarchar2(1),
--rpad(' ',1,' '),    
--    --MURABAHA_DEPOSIT_AMOUNT    nvarchar2(17),
--rpad(' ',17,' '),    
--    --CUSTOMER_PURCHASE_ID    nvarchar2(20),
--rpad(' ',20,' '),
--    --TOTAL_PROFIT_AMOUNT    nvarchar2(17),
--rpad(' ',17,' '),    
--    --MINIMUM_AGE_NOT_MET    nvarchar2(17),
--rpad(' ',17,' '),    
--    --BROKEN_PERIOD_PROFIT_PAID nvarchar2(1),
--rpad(' ',1,' '),    
--    --BROKEN_PERIOD_PROFIT_AMOUNT    nvarchar2(17),
--rpad(' ',17,' '),    
--    --PROFIT_BE_RECOVERED    nvarchar2(17),
--rpad(' ',17,' '),    
--    --INDICATE_PROFIT_DIST_UPTO_DATE    nvarchar2(10),
--rpad(' ',10,' '),    
--    --INDICATE_NEXT_PROFIT_DIST_DATE    nvarchar2(10),
--rpad(' ',10,' '),    
--    --TRANSFER_IN_IND    nvarchar2(1),
--rpad(' ',1,' '),    
----REPAYMENT_ACCOUNT    nvarchar2(16),
--rpad(get_oper_acct(pm.omabf||pm.omanf||pm.omasf),16,' '),    
----rpad(' ',16,' '),    
--    --REBATE_AMOUNT    nvarchar2(17),
--rpad(' ',17,' '),    
--    --BRANCH_OFFICE    nvarchar2(20),
--rpad(' ',20,' '),    
--    --DEFERMENT_PERIOD_MONTHS    nvarchar2(3),
--rpad(' ',3,' '),    
--    --CONTINUATION_IND    nvarchar2(1)
--rpad(' ',1,' ')            
--from v5pf
--inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
--inner join map_acc on map_acc.LEG_ACC_NUM=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
--inner join c8pf on c8ccy =scpf.scccy
--left join ospf on v5brnm=osbrnm and v5dlp=osdlp and v5dlr=osdlr
--left join (select * from otpf where ottdt='D')otpf on v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
--left join ompf_iv iv on v5brnm=iv.ombrnm and v5dlp=iv.omdlp and v5dlr=iv.omdlr
--left join ompf_pm pm on v5brnm=pm.ombrnm and v5dlp=pm.omdlp and v5dlr=pm.omdlr
--left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) clmamount  from v5pf
--inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
--inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
--where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') > case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
--                                                    when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
--and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
--group by v5brnm,v5dlp,v5dlr)int_amt on int_amt.v5brnm =v5pf.v5brnm and int_amt.v5dlp=v5pf.v5dlp  and  int_amt.v5dlr=v5pf.v5dlr
--left join d4pf on d4brr=v5brr
--left join jrpf on trim(jrpf.jrprc) =trim(v5pf.v5prc) 
--left join (select* from hypf where hydlr is not null) hypf on HYDBNM||HYDLP||HYDLR = map_acc.leg_acc_num
----left join owpf_note_tda on leg_acc=map_acc.leg_acc_num
--left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code = map_acc.CURRENCY  
--left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'N' group by schm_code)gss  on map_acc.schm_code = gss.schm_code
--left join (select * from tbaadm.TSP where bank_id = get_param('BANK_ID') and del_flg = 'N' )TSP  on map_acc.schm_code = TSP.schm_code AND Tsp.crncy_code = map_acc.CURRENCY    
--where map_acc.SCHM_TYPE='TDA' and v5pf.v5tdt='D' and ACC_CLOSED='CLOSED'; 
commit;
exit; 
