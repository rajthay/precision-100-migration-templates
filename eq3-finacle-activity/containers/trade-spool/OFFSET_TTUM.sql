-- File Name		: spool TTUM2
-- File Created for	: Creation of source table
-- Created By		: Alavudeen B.S
-- Client		: EmiratesNBD Bank
-- Created On		: 01-06-2014
-------------------------------------------------------------------
set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool /export/home/migapp/devmig/output/TF/KWMK5/offset_ttum.txt
select Account_Number||
		Currency_Code||
		SOL_ID||
		Part_Tran_Type||
		Transaction_Amount||
		Transaction_Particular||
		Account_Report_Code||
		Reference_Number||
		Instrument_Type||
		Instrument_Date||
		Instrument_Alpha||
		Actual_Instrument_Number||
		Navigation_Flag_For_HO_Trans||
		Reference_Amount||
		Reference_Currency_Code||
		Rate_Code||
		Rate||
		Value_date||
		GL_date||
		Category_Code||
		To__From_Bank_Code||
		To__From_Branch_Code||
		Advc_Extension_Counter_Code||
		BAR_Advice_Gen_Indicator||
		BAR_Advice_Number||
		BAR_Advice_Date||
		Bill_Number||
		Header_Text_Code||
		Header_Free_Text||
		Particulars_Line_1||
		Particulars_Line_2||
		Particulars_Line_3||
		Particulars_Line_4||
		Particulars_Line_5||
		Amount_Line_1||
		Amount_Line_2||
		Amount_Line_3||
		Amount_Line_4||
		Amount_Line_5||
		Remarks||
		Payee_Account_Number||
		Received_BAR_Advice_Number||
		Received_BAR_Advice_Date||
		Original_Transaction_Date||
		Original_Transaction_ID||
		Original_Part_Txn_Serial_No||
		IBAN_Number||
		Free_text||
		Entity_ID||
		Entity_Type||
		Flow_ID
from offset_ttum order by sol_id,currency_code,part_tran_type asc;
spool off;
 
