
-- File Name		: custom_return_chq_upload.sql 
-- File Created for	: Upload file for return cheque data
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 06-07-2017
-------------------------------------------------------------------
drop table return_chq_o_table;
create table return_chq_o_table as
select 
fin_acc_num Account_Number,      
fin_sol_id Sol_ID,              
sadrf Rej_Chq_No,  
SAAMA Cheque_amount,
reason_code Rej_Reason,  
to_char(to_date(substr(sapod,1,10),'YYYY-MM-DD'),'DD-MM-YYYY') Rej_Date,    
'01' Bank_ID
from return_cheque 
inner join map_acc on neean =fin_acc_num;
exit;


 
