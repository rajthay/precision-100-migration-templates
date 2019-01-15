-- File Name		: spool CA1
-- File Created for	: Creation of source table
-- Created By		: Kumaresan.B
-- Client		    : Emirates Islamic Bank
-- Created On		: 26-05-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 5000 
set page size 0
set pages 0
#set trimspool on
set trimspool on
spool $MIG_PATH/output/finacle/core/KW/CORE001.txt
select Account_Number||With_holding_tax_flg||With_holding_tax_Amt_scope_flg||With_holding_tax_percent||
With_holding_tax_floor_limit||CIF_ID||Customer_Cr_Pref_Percent||Customer_Dr_Pref_Percent||Account_Cr_Pref_Percent||
Account_Dr_Pref_Percent||Channel_Cr_Pref||Channel_Dr_Pref||Pegged_Flag||Peg_Frequency_in_Mnth||Peg_Frequency_in_Days||Int_freq_type_Credit||
Int_freq_week_num_Credit||Int_freq_week_day_Credit||Int_freq_start_dd_Credit||Int_freq_hldy_stat_Credit||Next_Cr_interest_run_date||Int_freq_type_Debit||
Int_freq_week_num_Debit||Int_freq_week_day_Debit||Int_freq_start_dd_Debit||Int_freq_hldy_stat_Debit||Next_Debit_interest_run_dt||Ledger_Number||
Employee_Id||Account_Open_Date||Mode_of_Operation_Code||Gl_Sub_Head_Code||Scheme_Code||Cheque_Allowed_Flag||Pass_Book_Pass_Sheet_Code||Freeze_Code||
Freeze_Reason_Code||Free_Text||Account_Dormant_Flag||Free_Code_1||Free_Code_2||Free_Code_3||Free_Code_4||Free_Code_5||Free_Code_6||Free_Code_7||Free_Code_8||
Free_Code_9||Free_Code_10||Interest_Table_Code||Account_Location_Code||Currency_Code||Service_Outlet||Account_Mgr_User_Id||Account_Name||Swift_Allowed_Flg||
Last_Transaction_Date||Last_Transaction_any_date||Exclude_for_combined_statement||Statement_CIF_ID||charge_Level_Code||PBF_download_Flag||wtax_level_flg||
Sanction_Limit||Drawing_Power||DACC_ABSOLUTE_LIMIT||DACC_PERCENT_LIMIT||Maximum_Allowed_Limit||Health_Code||Sanction_Level_Code||Sanction_Reference_Number||
Limit_Sanction_Date||Limit_Expiring_Date||Account_Review_Date||Loan_Paper_Date||Sanction_Authority_Code||Last_Compound_date||Daily_compounding_of_int_flag||
Comp_rest_day_flag||Use_discount_rate_flg||Dummy||Account_status_date||Iban_number||Ias_code||channel_id||channel_level_code||int_suspense_amt||
penal_int_suspense_amt||chrge_off_flg||pd_flg||pd_xfer_date||chrge_off_date||chrge_off_principal||pending_interest||principal_recovery||interest_recovery||
charge_off_type||Master_acct_num||ps_diff_freq_rel_party_flg||swift_diff_freq_rel_party_flg||Address_Type||Phone_Type||Email_Type||Alternate_Account_Name||
Interest_Rate_Period_Months||Interest_Rate_Period_Days||Interpolation_Method||Is_Account_hedged_Flag|| Used_for_netting_off_flag||Security_Indicator||Debt_Security||
Security_Code||Debit_int_Method||Service_Chrge_Coll_Flg||Last_Purge_Date||Total_Profit_Amt||  Min_Age_Not_Met_Amt||Br_Per_Prof_Paid_Flg||
Br_Per_Prof_Paid_Amt||Prof_To_Be_Recovered||Prof_Distr_Upto_Date||Nxt_Profit_Distr_Date||unclaim_status||unclaim_status_date||orig_gl_sub_head_code 
from AC1SBCA_O_TABLE
--this works for full spool as well for incremental spool if needed. 
left join (select foracid from tbaadm.gam where bank_id=get_param('BANK_ID')) gam on foracid = trim(account_number)
where  foracid is null
ORDER BY TO_NUMBER(TRIM(Service_Outlet)); 
exit;
 
