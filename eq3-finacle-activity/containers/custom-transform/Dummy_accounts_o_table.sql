
-- File Name		: dummy_accounts_o_table.sql
-- File Created for	: Upload file for all closed accounts 
-- Created By		: R.Alavudeen Ali Badusha
-- Client		    : ABK
-- Created On		: 09-02-2017
-------------------------------------------------------------------
truncate table dummy_accountS_o_Table;
insert into dummy_accountS_o_Table
select distinct 
--   v_Account_Number             CHAR(16)
            rpad(account_number,16,' '),
--   v_With_holding_tax_flg        CHAR(1)
            rpad('N',1,' '),
--Withholding tax Amount scope flag
            lpad(' ',1,' '),
--   v_With_holding_tax_percent        CHAR(8)
            lpad(' ',8,' '),
--   v_With_holding_tax_floor_limit    CHAR(17)
            lpad(' ',17,' '),
--   v_CIF_ID                 CHAR(32)
            rpad('DUMMY',32,' '),
--   v_Customer_Cr_Pref_Percent        CHAR(10)
            lpad(' ',10,' '),
--   v_Customer_Dr_Pref_Percent        CHAR(10)
            lpad(' ',10,' '),
--   v_Account_Cr_Pref_Percent         CHAR(10) ~!@
			lpad('0',10,' '),
--   v_Account_Dr_Pref_Percent        CHAR(10) ~!@
			lpad('0',10,' '),
--   v_Channel_Cr_Pref             CHAR(10)
            lpad(' ',10,' '),
--   v_Channel_Dr_Pref             CHAR(10)
            lpad(' ',10,' '),
--   v_Pegged_Flag             CHAR(1)
            'N',
--   v_Peg_Frequency_in_Mnth        CHAR(4)
            lpad(' ',4,' '),
--   v_Peg_Frequency_in_Days        CHAR(3)
            lpad(' ',3,' '),
--   v_Int_freq_type_Credit        CHAR(1) -- ~!@     
		   lpad(' ',1,' '),
--   v_Int_freq_week_num_Credit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_week_day_Credit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_start_dd_Credit        CHAR(2) ~!@          
			lpad(' ',2,' '),
--  v_Int_freq_hldy_stat_Credit        CHAR(1)     
			lpad(' ',1,' '),
--  v_Next_Cr_interest_run_date        CHAR(10)  ~!@ 
			lpad(' ',10,' '),
--   v_Int_freq_type_Debit        CHAR(1) ~!@ 
			lpad(' ',1,' '),
--   v_Int_freq_week_num_Debit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_week_day_Debit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_start_dd_Debit        CHAR(2) ~!@
			lpad(' ',2,' '),
--   v_Int_freq_hldy_stat_Debit        CHAR(1)
            lpad(' ',1,' '),
-- v_Next_Debit_interest_run_dt        CHAR(10)
			lpad(' ',10,' '),
--   v_Ledger_Number            CHAR(3)
            lpad(' ',3,' '),
--   v_Employee_Id            CHAR(10)
            lpad(' ',10,' '),
--  v_Account_Open_Date            CHAR(10)
			case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
			then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')          
			else lpad(' ',10,' ')
			end,
--   v_Mode_of_Operation_Code        CHAR(5)            
			lpad('999',5,' '),
--   v_Gl_Sub_Head_Code            CHAR(5)
            lpad('99999',5,' '),
--   v_Scheme_Code             CHAR(5)
            lpad('DUMMY',5,' '),
--   v_Cheque_Allowed_Flag        CHAR(1) ~!@
			lpad('N',1,' '),
--  v_Pass_Book_Pass_Sheet_Code        CHAR(1)
			lpad('N',1,' '),
--   v_Freeze_Code             CHAR(1) ~!@
			lpad(' ',1,' '),
-- v_Freeze_Reason_Code             CHAR(5) ~!@
			rpad(' ',5,' '),
--  v_Free_Text                 CHAR(240)
            lpad(' ' ,240,' '),
--   v_Account_Dormant_Flag        CHAR(1)
			lpad('A',1,' '),
--   v_Free_Code_1            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_2            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_3            CHAR(5)--Mandatory Field          
			lpad('999',5,' '),
--   v_Free_Code_4            CHAR(5)
            lpad(' ',5,' '),			
--   v_Free_Code_5            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_6            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_7            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_8            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_9            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_10            CHAR(5)            
			 lpad(' ',5,' '),			 
--   v_Interest_Table_Code        CHAR(5) 
            lpad('ZEROA',5,' '),
--   v_Account_Location_Code        CHAR(5)
            rpad(' ',5,' '),
--   v_Currency_Code             CHAR(3)	        
            lpad('AED',3,' '),
--   v_Service_Outlet             CHAR(8)
            rpad(' ',8,' '),
--   v_Account_Mgr_User_Id        CHAR(15)            
			lpad(' ',15,' '),
--   v_Account_Name             CHAR(80)
            rpad(' ',80,' '),
--  v_Swift_Allowed_Flg             CHAR(1)
			'N',
--   v_Last_Transaction_Date        CHAR(8)
			case when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
			lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
			else lpad(' ',10,' ') end,
--  v_Last_Transaction_any_date        CHAR(8)      
			case when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
			lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
			else lpad(' ',10,' ')  end,
--   v_Exclude_for_combined_stateme    CHAR(1)
            lpad(' ',1,' '),
--   v_Statement_CIF_ID             CHAR(32)
            lpad(' ',32,' '),
--  v_Charge_Level_Code             CHAR(5)
            lpad(' ',5,' '),
-- v_PBF_download_Flag             CHAR(1)
            'N',
--   v_wtax_level_flg             CHAR(1)
			lpad(' ',1,' '),
--   v_Sanction_Limit             CHAR(17)
			lpad(' ',17,' '),
--   v_Drawing_Power             CHAR(17)
			lpad(' ',17,' '),
--   v_DACC_ABSOLUTE_LIMIT        CHAR(17)
            lpad(' ',17,' '),
-- v_DACC_PERCENT_LIMIT             CHAR(8)
            lpad(' ',8,' '),
--   v_Maximum_Allowed_Limit        CHAR(17)
			lpad(' ',17,' '),
--   v_Health_Code             CHAR(5)
            lpad('1',5,' '),
--Sanction Level Code
            lpad(' ',5,' '),
--Sanction Reference Number
            lpad(' ',25,' '),
--   v_Limit_Sanction_Date        CHAR(8)
            lpad(' ',10,' '),
--   v_Limit_Expiring_Date        CHAR(8)--need  clarification
			lpad(' ',10,' '),	
--   v_Account_Review_Date        CHAR(8)
            lpad(' ',10,' '),
--   v_Loan_Paper_Date             CHAR(8)
            lpad(' ',10,' '),
--   v_Sanction_Authority_Code        CHAR(5)
            lpad(' ',5,' '),
-- v_Last_Compound_date             CHAR(8)
            lpad(' ',10,' '),
--   v_Daily_compounding_of_int_fla    CHAR(1)
            lpad(' ',1,' '),
-- v_Comp_rest_day_flag             CHAR(1)
            lpad(' ',1,' '),
--   v_Use_discount_rate_flg        CHAR(1)
            lpad(' ',1,' '),
--   v_Dummy                 CHAR(100)
            lpad(' ',100,' '),
--   v_Account_status_date        CHAR(8)         
			case when scdlm <> 0 and get_date_fm_btrv(scdlm) <> 'ERROR' then
            lpad(to_char(to_date(get_date_fm_btrv(scdlm),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else lpad(get_param('EOD_DATE'),10,' ')
            end, 
--   v_Iban_number             CHAR(34)
            lpad(' ',34,' '),
--   v_Ias_code                 CHAR(5)
            lpad(' ',5,' '),
-- v_channel_id                 CHAR(5)
            lpad(' ',5,' '),
-- v_channel_level_code             CHAR(5)
            lpad(' ',5,' '),
--   v_int_suspense_amt             CHAR(17)
            lpad('0',17,' '),
--   v_penal_int_suspense_amt        CHAR(17)
            lpad('0',17,' '),
--   v_chrge_off_flg             CHAR(1)
            lpad(' ',1,' '),
--   v_pd_flg                 CHAR(1)
            'N',
--   v_pd_xfer_date             CHAR(8)
            lpad(' ',10,' '),
--   v_chrge_off_date             CHAR(8)
            lpad(' ',10,' '),
--   v_chrge_off_principal        CHAR(17)
            lpad(' ',17,' '),
--   v_pending_interest             CHAR(17)
            lpad(' ',17,' '),
-- v_principal_recovery             CHAR(17)
            lpad(' ',17,' '),
-- v_interest_recovery             CHAR(17)
            lpad(' ',17,' '),
--   v_charge_off_type             CHAR(1)
            lpad(' ',1,' '),
--   v_Master_acct_num             CHAR(16)
            lpad(' ',16,' '),
-- v_ps_diff_freq_rel_party_flg        CHAR(1)
            lpad(' ',1,' '),
--   v_swift_diff_freq_rel_party_fl    CHAR(1)
            lpad(' ',1,' '),
--   v_Address_Type             CHAR(12)
			rpad('Mailing',12,' '),
-- v_Phone_Type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_Type                 CHAR(12)   
            lpad(' ',12,' '),
--   v_Alternate_Account_Name        CHAR(80)
            lpad(' ',80,' '),
--   v_Interest_Rate_Period_Months    CHAR(4)
            lpad(' ',4,' '),
-- v_Interest_Rate_Period_Days         CHAR(3)
            lpad(' ',3,' '),
--   v_Interpolation_Method         CHAR(1)
            lpad(' ',1,' '),
--   v_Is_Account_hedged_Flag         CHAR(1)
            lpad(' ',1,' '),
-- v_Used_for_netting_off_flag         CHAR(1)
            lpad(' ',1,' '),
-- v_Security_Indicator             CHAR(10)
            lpad(' ',10,' '),
--   v_Debt_Security             CHAR(1)
            lpad(' ',1,' '),
--   v_Security_Code             CHAR(8)
            lpad(' ',8,' '),
--   Debit_int_Method            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--  Service_Chrge_Coll_Flg        VARCHAR2(1) NUL
            lpad('Y',1,' '),
--   Last_Purge_Date                VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   Total_Profit_Amt              VARCHAR2(17) NULL
		    lpad('0',17,' '),
--   Min_Age_Not_Met_Amt            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Br_Per_Prof_Paid_Flg            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--   Br_Per_Prof_Paid_Amt            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Prof_To_Be_Recovered            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Prof_Distr_Upto_Date            VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   Nxt_Profit_Distr_Date        VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   unclaim_status            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--   unclaim_status_date            VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   orig_gl_sub_head_code        VARCHAR2(16) NUL
            lpad(' ',16,' ')
from DUMMY_ACCOUNTS
INNER JOIN SCPF ON SCAB||SCAN||sCAS=ACCOUNT_NUMBER
LEFT JOIN MAP_ACC ON FIN_ACC_NUM=ACCOUNT_NUMBER AND SCHM_TYPE IN ('CAA','CLA','LAA','ODA','PCA','SBA','TDA')
WHERE FIN_ACC_NUM IS NULL;
commit;
exit;
 
