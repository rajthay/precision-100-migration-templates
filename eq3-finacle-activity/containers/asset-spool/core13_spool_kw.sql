set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/core/KW/CORE013.txt
select 
Account_Number		||
Start_Date||
Crncy_Code||
End_Date		||
Total_No_of_Days_Debit||
Total_No_of_Days_Credit||
Total_Debit_Balance||
Total_Credit_Balance||
Highest_Debit_Balance	||
Highest_Credit_Balance||
Total_Debits			||
Total_Credits||
Total_Credit_Clearing_Balance||
No_of_Instruments_Clearing||
Total_No_of_TODs_Granted||
Interest_Collected||
Interest_Paid||
Time_taken_to_clear_TODs||
No_of_Regular_TODs||
No_of_Inward_Chq_Returned||
No_of_Outward_Chq_Returned||
No_of_Debit_Transactions||
No_of_Credit_Transactions||
Credit_Interest_Accrued||
Debit_Interest_Accrued||
Lowest_Credit_Balance||
Lowest_Debit_Balance||
Inward_Clg_Cheque_Return_Amt||
Outward_Clg_Cheque_Return_Amt
from ato_o_table;
exit;
 
