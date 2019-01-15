
-- File Name           : LAT_upload.sql
-- File Created for    : Upload file for LAT
-- Created By          : Alavudeen Ali Badusha.R
-- Client              : ABK
-- Created On          : 20-06-2015 
-------------------------------------------------------------------
truncate table LAT_O_TABLE;
insert into LAT_O_TABLE
select 
--   Transaction_Type         CHAR(1) NULL,
rpad('T',1,' '),
--   Transaction_sub_Type         CHAR(2) NULL,
rpad('BI',2,' '),
--   Account_Number         CHAR(16) NULL,
rpad(fin_acc_num,16,' '),
--   Currency             CHAR(3) NULL,
rpad(map_acc.currency,3,' '),
--   Service_Outlet         CHAR(8) NULL,
rpad(fin_sol_id,8,' '),     
--   Amount             CHAR(17) NULL,
lpad(to_number(abs(otdla))/POWER(10,c8pf.C8CED),17,' '),--commented based on karthic sir confirmation.sum of indem overdue and sum of pidem overdue subtracted from outstanding balance
--lpad(to_number(abs(otdla))/POWER(10,c8pf.C8CED)- (nvl(sum_overdue,0)/power(10,c8ced)+nvl(lsup,0)/power(10,c8ced)),17,' '), ---- commented on 17-07-2017 based on mk5 observation --overdue interest not included in otdla hence commented
--   Part_tran_type         CHAR(1) NULL,
rpad('D',1,' '),
--   Type_of_demands         CHAR(1) NULL,
rpad( 'P',1,' '),
--   Value_Date             CHAR(10) NULL,
--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') > trunc(to_date(get_date_fm_btrv(get_param('EODCYYMMDD')),'YYYYMMDD'),'MM') then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
	 --when omdte is not null then to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY')
	 --else get_param('EOD_DATE')	end,
	 get_param('EOD_DATE'), --As per Sandep bandela confirmation on 05-01-2017 changed to cut off_date
--   Flow_Id             CHAR(5) NULL,
rpad('DISBM',5,' '),
--   Demand_Date             CHAR(10) NULL,
rpad(' ',10,' '),
--   Last_part_transaction_flag     CHAR(1) NULL,
rpad('N',1,' '),
--   Tran_end_ind             CHAR(1) NULL,
rpad('N',1,' '),
--   Advance_Payment_Flag         CHAR(1) NULL,
rpad('N',1,' '),
--   Prepayment_Type         CHAR(1) NULL,
rpad(' ',1,' '),
--   int_coll_on_prepayment_flg     CHAR(1) NULL,
rpad(' ',1,' '),
--   Transaction_Remarks         CHAR(30) NULL,
rpad(' ',30,' '),
--   Transaction_Particulars     CHAR(50) NULL
rpad(fin_acc_num,50,' ')   
FROM MAP_ACC
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = map_acc.leg_acc_num
left join (SELECT ombrnm,omdlp,omdlr ,Max(omdte) omdte FROM ompf WHERE  omdte <= get_param('EODCYYMMDD') GROUP BY ombrnm,omdlp,omdlr)ompf on leg_acc_num=ombrnm||trim(omdlp)||trim(omdlr)
inner join c8pf on c8ccy = otccy
left join (select lsbrnm,lsdlp,lsdlr,sum(abs(to_number((lsamtd - lsamtp)))) sum_overdue from lspf where  lsmvt = 'I' and (lsamtd -lsamtp) < 0  and LSAMTD <> 0 and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num
left join (select lsbrnm,lsdlp,lsdlr,sum(abs(to_number(lsup))) lsup from lspf where  lsup <> 0 and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num
where map_acc.schm_type='LAA' and OTDLA <> 0
union all
select 'T','BI',rpad((fin_sol_id||crncy_alias_num||'52000LAA'),16,' '), currency,rpad(fin_sol_id,8,' '),lpad(calc_bal,17,' '),'C',' ',rpad(get_param('EOD_DATE'),10,' '),rpad(' ',5,' '),rpad(' ',10,' '),'Y','N','N',' ',' ',rpad(' ',30,' '),rpad(fin_acc_num,50,' ')
from
--(select map_acc.fin_sol_id,currency,sum(to_number(abs(otdla)/POWER(10,c8pf.C8CED))) calc_bal  ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
(select fin_acc_num, fin_sol_id,currency,(to_number(abs(otdla)/POWER(10,c8pf.C8CED))) calc_bal  
--to_number(abs(otdla))/POWER(10,c8pf.C8CED)- (nvl(sum_overdue,0)/power(10,c8ced)+nvl(lsup,0)/power(10,c8ced)) calc_bal  
from MAP_ACC
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = map_acc.leg_acc_num
inner join v5pf on v5brnm||v5dlp||trim(v5dlr) = map_acc.leg_acc_num
left join scpf on scab||scan||scas=V5ABD||v5AND||V5ASD
left join (SELECT ombrnm,omdlp,omdlr ,Max(omdte) omdte FROM ompf WHERE  omdte <= get_param('EODCYYMMDD') GROUP BY ombrnm,omdlp,omdlr)ompf on leg_acc_num=ombrnm||trim(omdlp)||trim(omdlr)
inner join c8pf on c8ccy = otccy
left join (select lsbrnm,lsdlp,lsdlr,sum(abs(to_number((lsamtd - lsamtp)))) sum_overdue from lspf where  lsmvt = 'I' and (lsamtd -lsamtp) < 0  and LSAMTD <> 0 and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num
left join (select lsbrnm,lsdlp,lsdlr,sum(abs(to_number(lsup))) lsup from lspf where  lsup <> 0 and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num
where map_acc.schm_type='LAA' and OTDLA <> 0
--group by currency,map_acc.fin_sol_id ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
order by currency,fin_sol_id
)
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on crncy_code=currency; 
commit;
exit;
 
