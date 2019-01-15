
-- File Name		: balance.sql
-- File Created for	: Upload file for balance
-- Created By		: 
-- Client        	: ABK
-- Created On       : 08-Aug-2015
-------------------------------------------------------------------
truncate table tdt_o_table;
-------------------Cumulative deposit Principal block----------------------
insert into tdt_o_table
select /*+use_hash(scab,scan,scas,scccy) */
'T',
'BI',
rpad(to_char(fin_acc_num),16,' '), 
v5ccy,
--lpad(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi or trim(v5ifq) is null)  and nvl(clmamount,0)  <> 0  --commented on 06-07-2017 based on RTD0600000027699 deal issue
lpad(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi)  and nvl(clmamount,0)  <> 0 
                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end,17,' '),
'C',
case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else  rpad(' ',10,' ')
            end,
' ',
lpad(' ',10,' '),
'PI',
'N',
to_char(fin_sol_id)
from v5pf
inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
inner join c8pf on c8ccy =scpf.scccy
left join (select * from otpf where OTTDT='D')otpf on  v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) clmamount  from v5pf
inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') > case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
                                                   when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
group by v5brnm,v5dlp,v5dlr)int_amt on int_amt.v5brnm =v5pf.v5brnm and int_amt.v5dlp=v5pf.v5dlp  and  int_amt.v5dlr=v5pf.v5dlr
--where schm_type = 'TDA' and v5bal <> '0' and v5pf.v5tdt='D' and (v5abd||v5and||v5asd = v5abi||v5ani||v5asi or trim(v5ifq) is null)--commented on 06-07-2017 based on RTD0600000027699 deal issue
where schm_type = 'TDA' and v5bal <> '0' and v5pf.v5tdt='D' and (v5abd||v5and||v5asd = v5abi||v5ani||v5asi);
commit;
-------------------Cumulative deposit interest capitalized block----------------------
insert into tdt_o_table
select /*+use_hash(scab,scan,scas,scccy) */
'T',
'BI',
rpad(to_char(fin_acc_num),16,' '), 
v5ccy,
--lpad(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi  or trim(v5ifq) is null)  then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0')--commented on 06-07-2017 based on RTD0600000027699 deal issue
lpad(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi )  then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0')
            else ' ' end,17,' '),
'C',
case when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') end,
' ',
lpad(' ',10,' '),
'II',
'N',
to_char(fin_sol_id)
from v5pf
inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
inner join c8pf on c8ccy =scpf.scccy
left join (select * from otpf where OTTDT='D')otpf on  v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) clmamount  from v5pf
inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') > case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
                                                   when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
group by v5brnm,v5dlp,v5dlr)int_amt on int_amt.v5brnm =v5pf.v5brnm and int_amt.v5dlp=v5pf.v5dlp  and  int_amt.v5dlr=v5pf.v5dlr
--where schm_type = 'TDA' and v5bal <> '0' and v5pf.v5tdt='D' and (v5abd||v5and||v5asd = v5abi||v5ani||v5asi or trim(v5ifq) is null) and clmamount <> 0; --commented on 06-07-2017 based on RTD0600000027699 deal issue
where schm_type = 'TDA' and v5bal <> '0' and v5pf.v5tdt='D' and (v5abd||v5and||v5asd = v5abi||v5ani||v5asi) and clmamount <> 0; 
commit;
-------------------Non Cumulative deposit Principal block---------------------- 
insert into tdt_o_table
select /*+use_hash(scab,scan,scas,scccy) */
'T',
'BI',
rpad(to_char(fin_acc_num),16,' '), 
v5ccy,
lpad(to_number(V5BAL)/power(10,c8pf.c8ced),17,' '),
'C',
case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else  rpad(' ',10,' ')
            end,
' ',
lpad(' ',10,' '),
'PI',
'N',
to_char(fin_sol_id)
from v5pf
inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
inner join c8pf on c8ccy =scpf.scccy
left join (select * from otpf where OTTDT='D')otpf on  v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
--where schm_type = 'TDA' and v5bal <> '0' and v5pf.v5tdt='D' and (v5abd||v5and||v5asd <> v5abi||v5ani||v5asi and trim(v5ifq) is not null)--commented on 06-07-2017 based on RTD0600000027699 deal issue
where schm_type = 'TDA' and v5bal <> '0' and v5pf.v5tdt='D' and (v5abd||v5and||v5asd <> v5abi||v5ani||v5asi);
--union
--select 
--'T',
--'BI',
--rpad(to_char(fin_sol_id||crncy_alias_num||'52000TDA'),16,' '), 
--v5ccy,
--lpad(calc_bal,17,' '),
--'D', 
--get_param('EOD_DATE'),
--' ',lpad(' ',10,' '),'BI','Y',to_char(fin_sol_id)
--from 
--(
--select fin_sol_id, v5CCY
--,sum(to_number(V5BAl)/power(10,c8pf.c8ced))calc_bal
--from v5pf
--inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
--inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
--inner join c8pf on c8ccy =scpf.scccy
--left join otpf on v5brnm||v5dlp||v5dlr=otbrnm||otdlp||otdlr
--where schm_type = 'TDA' and v5bal <> '0' and v5pf.v5tdt='D' and (v5abd||v5and||v5asd <> v5abi||v5ani||v5asi and trim(v5ifq) is not null)
--group by fin_sol_id,v5ccy
--order by fin_sol_id,v5ccy
--)x
--left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on crncy_code=v5ccy*/
commit;
-------------------Non Cumulative deposit advanced interest paid block Added by Kumar on 17-05-2017---------------------- 
--insert into tdt_o_table
--select /*+use_hash(scab,scan,scas,scccy) */
--'T',
--'BI',
--rpad(to_char(fin_acc_num),16,' '), 
--v5ccy,
--lpad(nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0'),17,' '),
--'C',
--case when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
--                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end,
--' ',
--lpad(' ',10,' '),
--'IA',
--'N',
--to_char(fin_sol_id)
--from v5pf
--inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
--inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
--inner join c8pf on c8ccy =scpf.scccy
--left join (select * from otpf where OTTDT='D')otpf on  v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
--left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) clmamount  from v5pf
--inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
--inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
--where  v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
--group by v5brnm,v5dlp,v5dlr)int_amt on int_amt.v5brnm =v5pf.v5brnm and int_amt.v5dlp=v5pf.v5dlp  and  int_amt.v5dlr=v5pf.v5dlr
--where schm_type = 'TDA' and v5bal <> '0' and v5pf.v5tdt='D'  and deal_type='ATD'; 
--commit;
-------------------Cumulative deposit contra block----------------------
insert into tdt_o_table
select 
'T',
'BI',
rpad(to_char(fin_sol_id||crncy_alias_num||'52000TDA'),16,' '), 
v5ccy,
lpad(calc_bal,17,' '),
'D', 
get_param('EOD_DATE'),
' ',lpad(' ',10,' '),'BI','Y',to_char(fin_sol_id)
from  
(
select sol_code fin_sol_id ,crncy_alias_num,currency_code v5ccy,sum(amount)calc_bal
from tdt_o_table 
inner join tbaadm.cnc on currency_code=crncy_code and bank_id='01'
where part_transaction_type = 'C'
group by sol_code,crncy_alias_num,currency_code
);
commit;
exit;
 
