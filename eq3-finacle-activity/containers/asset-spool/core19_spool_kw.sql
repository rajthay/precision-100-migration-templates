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
spool $MIG_PATH/output/finacle/core/KW/CORE019.txt
select 
DD_Issued_Branch_Code||
DD_Number||
DD_Issue_Date||
DD_Issued_Bank_Code||
DD_Currency||
Scheme_Code||
Issue_Extn_Cntr_Code||
Status||
Status_Update_Date||
DD_Amount||
Payee_Branch_Code||
Payee_Bank_Code||
Instrument_No||
DD_Revalidation_Date||
Print_Advice_Flag||
Print_Remarks||
Paying_Branch_Code||
Paying_Bank_Code||
Routing_Branch_Code||
Routing_Bank_Code||
Instrument_Type||
Instrument_Alpha||
Purchasers_Name||
Payees_Name||
Print_Option||
Print_Flag||
Print_Count||
Duplicate_Issue_Count||
Duplicate_Issue_Date||
Rectified_Count||
Cautioned_Status||
Reason_for_Caution||
Paid_Ex_Advice||
Inventory_Serial_No||
Paid_Advice_Flag||
Advice_Received_Date
from dds_o_table;
exit;
 
