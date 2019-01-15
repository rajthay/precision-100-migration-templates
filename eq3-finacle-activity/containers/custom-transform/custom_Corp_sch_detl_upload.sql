
-- File Name		: CORP_SCH_DETL_UPLOAD.sql 
-- File Created for	: Upload file for corporate loan schedule details
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 07-03-2017
-------------------------------------------------------------------
truncate table corp_sch_detl;
insert into corp_sch_detl
select 
--Account_Number                   Nvarchar2(16),
rpad(a.acc_num,16,' '),
--  Start_Date                       Nvarchar2(10),      
rpad(to_char(to_date(SANCTION_LIMIT_DATE,'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--  End_Date                         Nvarchar2(10),
rpad(to_char(to_date(LIMIT_EXPIRY_DATE,'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--  Sch_Draw_Down_Amount       Nvarchar2(17),
lpad(TRANS_AMT,17,' '),
--  Draw_Down_Ccy               Nvarchar2(3),
rpad(ACCT_CURRENCY_CODE,3,' '),
--  Cr_Account_Num               Nvarchar2(16),
rpad(OPERATIVE_ACCT_ID,16,' '),
--  ECS_Mandate_Srl_Num        Nvarchar2(12),
lpad(' ',12,' '),
--  Mode_of_Draw_Down                Nvarchar2(1),
rpad(' ',1,' '),
--  Actual_Draw_Down_Amount          Nvarchar2(17),
lpad(SANCTION_LIMIT,17,' '),
--  Remarks                          Nvarchar2(60),
rpad(' ',60,' '),
--  Paysys_ID                        Nvarchar2(5)
rpad(' ',5,' ')
from cl001_o_table a
left join cl007_o_table b on a.acc_num=b.acc_num;
commit;
exit;
 
