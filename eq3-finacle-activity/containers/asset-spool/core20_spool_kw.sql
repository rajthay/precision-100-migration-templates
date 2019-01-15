-- File Name		: spool CA1
-- File Created for	: Creation of source table
-- Created By		: Kumaresan.B
-- Client		    : Emirates Islamic Bank
-- Created On		: 26-05-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/core/KW/CORE020.txt
select 
SOL_ID||
SI_Freq_Type||
SI_Freq_Week_num||
SI_Freq_Week_Day||
SI_Freq_Start_DD||
SI_Freq_Hldy_Stat||
SI_Execution_code||
SI_end_date||
SI_Next_Execution_Date||
Target_Account||
Balance_Indicator||
Excess_Short_Indicator||
Target_Balance||
Auto_Post_Flag||
Carry_Forward_Allowed_Flag||
Validate_Crncy_Holiday_Flag||
Delete_Trn_if_not_Posted||
Carry_Forward_Limit||
SI_Class||
CIF_ID||
Remarks||
Closure_remarks||
Execution_charge_code||
Failure_charge_code||
Charge_rate_code||
Charge_debit_account_number||
Amount_Indicator||
Create_Memo_Pad_Entry||
Currency_Code||
Fixed_Amount||
Part_Tran_Type||
Balance_Indicator1||
Excess_Short_Indicator1||
Account_Number||
Account_Balance||
Percentage||
Amount_multiple||
ADM_Account_No||
Round_off_Type||
Round_off_Value||
Collect_Charges||
Report_Code||
Reference_Number||
Tran_particular||
Tran_remarks||
Intent_Code||
DD_payable_bank_code||
DD_payable_branch_code||
Payee_name||
Purchase_Account_Number||
Purchase_Name||
cr_adv_pymnt_flg||
Amount_Indicator1||
Create_Memo_Pad_Entry1||
ADM_Account_No1||
Round_off_Type1||
Round_off_Value1||
Collect_Charges1||
Report_Code1||
Reference_Number1||
Tran_particular1||
Tran_remarks1||
Intent_Code1||
SI_Priority||
si_freq_cal_base||
cr_ceiling_amt||
cr_cumulative_amt||
dr_ceiling_amt||
dr_cumulative_amt||
SI_freq_days_num||
Script_File_Name
from bo_o_table;
--where adm_account_no not like '000%';
exit;
 
