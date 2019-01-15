
-- File Name		: balance.sql
-- File Created for	: Upload file for balance
-- Created By		: Kumatresan.B
-- Client		    : ABK
-- Created On		: 27-05-2015
-------------------------------------------------------------------
truncate table AC_BALANCE_O_TABLE;
insert into AC_BALANCE_O_TABLE
select 
--   v_Indicator           CHAR(3)
'BAL',
--   v_Account_Number         CHAR(16)
            rpad(fin_acc_num,16,' '),
--   v_Amount              number(14,2)
            lpad((scbal -(scsum1+scsum2))/POWER(10,C8CED),17,' '),
--   v_Transaction_Date         CHAR(8)
        get_param('EOD_DATE'),
--   v_Currency_Code         CHAR(3)            
            rpad(scccy,3,' '),
--   v_Service_Outlet         CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_dummy               CHAR(10)
            lpad(SCHM_TYPE,10,' ')
from map_acc
inner join scpf on scpf.scab=leg_branch_id and scpf.scan=leg_scan and scpf.scas=leg_scas
inner join c8pf on c8ccy = scccy
where (scbal -(scsum1+scsum2)) <>'0' and map_acc.schm_type in('SBA','CAA','ODA') and map_acc.schm_code not in('PISLA','360')
order by scccy;
COMMIT;
insert into AC_BALANCE_O_TABLE
select 
--   v_Indicator           CHAR(3)
'BAL',
--   v_Account_Number         CHAR(16)
            rpad(fin_acc_num,16,' '),
--   v_Amount              number(14,2)            
			lpad(to_number(V5BAL)/power(10,c8pf.c8ced),17,' '),
--   v_Transaction_Date         CHAR(8)
        get_param('EOD_DATE'),
--   v_Currency_Code         CHAR(3)            
            rpad(scccy,3,' '),
--   v_Service_Outlet         CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_dummy               CHAR(10)
            lpad(SCHM_TYPE,10,' ')
from v5pf
inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
inner join c8pf on c8ccy =scpf.scccy
where map_acc.schm_type ='CAA' and v5pf.v5bal<>0 and map_acc.schm_code='PISLA'
order by scccy;
commit;
exit; 
