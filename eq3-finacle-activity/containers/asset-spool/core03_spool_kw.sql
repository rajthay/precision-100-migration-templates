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
spool $MIG_PATH/output/finacle/core/KW/CORE003.txt
select 
AC2_O_TABLE.Account_Number||
AC2_O_TABLE.Currency||
AC2_O_TABLE.Service_Outlet||
AC2_O_TABLE.Record_Type||
AC2_O_TABLE.Name||
AC2_O_TABLE.Designation||
AC2_O_TABLE.Amount_allowed||
AC2_O_TABLE.Start_Date||
AC2_O_TABLE.End_Date||
AC2_O_TABLE.CIF_ID||
AC2_O_TABLE.Relation_Code||
AC2_O_TABLE.Pass_Sheet_flag||
AC2_O_TABLE.Standing_Instruction_ad_flag||
AC2_O_TABLE.TD_Maturity_Notice_Flag||
AC2_O_TABLE.Loan_Overdue_Notice_Flag||
AC2_O_TABLE.Communication_Address_1||
AC2_O_TABLE.Communication_Address_2||
AC2_O_TABLE.Communication_Address_3||
AC2_O_TABLE.Communication_City_Code||
AC2_O_TABLE.Communication_State_Code||
AC2_O_TABLE.Communication_Pin_Code||
AC2_O_TABLE.Communication_Country||
AC2_O_TABLE.Communication_Phone_Number||
AC2_O_TABLE.Communication_FAX_Number||
AC2_O_TABLE.Communication_Telex_Number||
AC2_O_TABLE.Communication_Email_Id||
AC2_O_TABLE.Exclude_for_combined_statement||
AC2_O_TABLE.Statement_CIF_Id||
AC2_O_TABLE.Customer_Title_Code||
AC2_O_TABLE.Incert_print_flag||
AC2_O_TABLE.Incert_adv_flag||
AC2_O_TABLE.Guarantor_liab_Pcnt||
AC2_O_TABLE.Guarantor_liab_sequence||
AC2_O_TABLE.PS_freq_type||
AC2_O_TABLE.PS_freq_week_num||
AC2_O_TABLE.PS_freq_week_day||
AC2_O_TABLE.PS_Freq_Start_month||
AC2_O_TABLE.PS_freq_holiday_status||
AC2_O_TABLE.SWIFT_statement_serial_num||
AC2_O_TABLE.PS_despatch_mode||
AC2_O_TABLE.SWIFT_frequency_type||
AC2_O_TABLE.SWIFT_freq_week_number||
AC2_O_TABLE.SWIFT_freq_week_day||
AC2_O_TABLE.Swift_Freq_Start_Day||
AC2_O_TABLE.SWIFT_freq_holiday_status||
AC2_O_TABLE.SWIFT_message_type||
AC2_O_TABLE.SWIFT_message_receiver_bic||
AC2_O_TABLE.Address_type||
AC2_O_TABLE.Phone_type||
AC2_O_TABLE.Email_type||
AC2_O_TABLE.Alt_Auth_Sign_Name
from AC2_O_TABLE ;
--inner join (select acid,foracid from tbaadm.gam) gam on foracid = trim(account_number)
--left join tbaadm.aas on gam.acid=aas.acid and trim(RECORD_TYPE)= ACCT_POA_AS_REC_TYPE 
--where aas.acid||ACCT_POA_AS_REC_TYPE  is null
exit;
 
