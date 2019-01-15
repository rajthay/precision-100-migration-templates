
--SOL-RECON
drop table ALL_FINAL_TRIAL_BALANCE_RECON;
create table  ALL_FINAL_TRIAL_BALANCE_RECON as
select * from ALL_FINAL_TRIAL_BALANCE;

--Loan Deal amount is there,Deal Account balance zero.
delete from  ALL_FINAL_TRIAL_BALANCE_RECON where scab||scan||scas ='0615755484300';
commit;
--TRY gl_sub_head_code updated
update ALL_FINAL_TRIAL_BALANCE_RECON c set c.GL_SUB_HEAD_CODE=(
select b.GL_SUB_HEADCODE from ALL_FINAL_TRIAL_BALANCE_RECON a
inner join (select distinct scab||scan||scas leg_Acc_num,GL_SUB_HEADCODE from PREMOCK_RECON_temp where INDICATOR='TR'and trim(EXTERNAL_NO) is not null)b on a.leg_Acc_num=b.leg_Acc_num
where c.leg_acc_num=a.leg_Acc_num)
where exists(
select b.GL_SUB_HEADCODE from ALL_FINAL_TRIAL_BALANCE_RECON a
inner join (select distinct scab||scan||scas leg_Acc_num,GL_SUB_HEADCODE from PREMOCK_RECON_temp where INDICATOR='TR'and trim(EXTERNAL_NO) is not null)b on a.leg_Acc_num=b.leg_Acc_num
where c.leg_acc_num=a.leg_Acc_num);
commit;

update ALL_FINAL_TRIAL_BALANCE_RECON set GL_SUB_HEAD_CODE='48809',new_fin_sol_id='700'  where scact='YL' and scan='803735' and gl_sub_head_code='52000' and scccy='KWD';
commit;
update ALL_FINAL_TRIAL_BALANCE_RECON set GL_SUB_HEAD_CODE='48809',new_fin_sol_id='700'  where scact='YL' and scan='803735' and gl_sub_head_code='52000' and scccy='USD';
commit;
--update   ALL_FINAL_TRIAL_BALANCE_RECON  set GL_SUB_HEAD_CODE ='52000' where scact in('TY','YM') and scbaL<>0 and GL_SUB_HEAD_CODE='TRY';
--commit;
--update   ALL_FINAL_TRIAL_BALANCE_RECON  set GL_SUB_HEAD_CODE ='52000' where scact in('3A','3D','3G','3K','3W','3X','3Y','3Z') and scbal<>0;
--commit;


update ALL_FINAL_TRIAL_BALANCE_RECON c set c.GL_SUB_HEAD_CODE=(
select distinct b.GL_SUB_HEADCODE from ALL_FINAL_TRIAL_BALANCE_RECON a
inner join (
select distinct GL_SUB_HEADCODE,SCACT from PREMOCK_RECON_temp where SCACT in(
'T2',
'V5',
'V6',
'VC',
'W6')  and KWD_BALANCE<>0) b on a.scact=b.SCACT
where a.scact=c.scact and a.scbaL<>0)
where exists( select distinct b.GL_SUB_HEADCODE from ALL_FINAL_TRIAL_BALANCE_RECON a
inner join (
select distinct GL_SUB_HEADCODE,SCACT from PREMOCK_RECON_temp where SCACT in(
'T2',
'V5',
'V6',
'VC',
'W6') and KWD_BALANCE<>0) b on a.scact=b.SCACT
where a.scact=c.scact and a.scbaL<>0);
commit;

--TFS gl_sub_head_code updated
UPDATE ALL_FINAL_TRIAL_BALANCE_RECON SET (GL_SUB_HEAD_CODE,NEW_FIN_SOL_ID) = (SELECT GLSH,TARGET_SOL_ID FROM(
select DISTINCT ACCOUNT_TYPE,SUBSTR(DEBIT_BACID,1,5) GLSH,TARGET_SOL_ID from tf_ttum04 WHERE ACCOUNT_TYPE NOT IN ('DJ','DK')
UNION 
select DISTINCT CONTRA_TYPE,SUBSTR(CREDIT_BACID,1,5),TARGET_SOL_ID from tf_ttum04 WHERE TRIM(CONTRA_TYPE) IS NOT NULL and CONTRA_TYPE NOT IN ('TA')--TA NEED TO CHECK
UNION
select DISTINCT ACCOUNT_TYPE,SUBSTR(CREDIT_BACID,1,5),TARGET_SOL_ID from tf_ttum04 WHERE ACCOUNT_TYPE IN ('DJ','DK')
) WHERE ACCOUNT_TYPE = SCACT )
WHERE SCACT IN(
select DISTINCT ACCOUNT_TYPE from tf_ttum04 WHERE ACCOUNT_TYPE NOT IN ('DJ','DK')
UNION 
select DISTINCT CONTRA_TYPE from tf_ttum04 WHERE TRIM(CONTRA_TYPE) IS NOT NULL and CONTRA_TYPE NOT IN ('TA')--TA NEED TO CHECK
UNION
select DISTINCT ACCOUNT_TYPE from tf_ttum04 WHERE ACCOUNT_TYPE IN ('DJ','DK')
) and scact not in('TA');
commit;

update ALL_FINAL_TRIAL_BALANCE_RECON c set c.GL_SUB_HEAD_CODE=(
select b.GL_SUB_HEADCODE from ALL_FINAL_TRIAL_BALANCE_RECON a
inner join (select distinct scab||scan||scas leg_acc_num,GL_SUB_HEADCODE from  PREMOCK_RECON_temp a
inner join (
select leg_acc_num from (
select distinct scab||scan||scas leg_acc_num,GL_SUB_HEADCODE from PREMOCK_RECON_temp where scact='TA' and KWD_BALANCE<>0 and INDICATOR='TF'
order by scab||scan||scas)
group by leg_acc_num
having count(*)=1)b on b.leg_acc_num=a.scab||a.scan||a.scas
where a.scact='TA' and a.KWD_BALANCE<>0 and a.INDICATOR='TF')b on a.leg_Acc_num=b.leg_Acc_num
where c.leg_acc_num=a.leg_Acc_num)
where exists(
select b.GL_SUB_HEADCODE from ALL_FINAL_TRIAL_BALANCE_RECON a
inner join (select distinct scab||scan||scas leg_acc_num,GL_SUB_HEADCODE from  PREMOCK_RECON_temp a
inner join (
select leg_acc_num from (
select distinct scab||scan||scas leg_acc_num,GL_SUB_HEADCODE from PREMOCK_RECON_temp where scact='TA' and KWD_BALANCE<>0 and INDICATOR='TF'
order by scab||scan||scas)
group by leg_acc_num
having count(*)=1)b on b.leg_acc_num=a.scab||a.scan||a.scas
where a.scact='TA' and a.KWD_BALANCE<>0 and a.INDICATOR='TF')b  on a.leg_Acc_num=b.leg_Acc_num
where c.leg_acc_num=a.leg_Acc_num);
commit;


drop table new_sol_acc_change_map; 
create table new_sol_acc_change_map as
select scab||scan||scas leg_acct_num,
case when substr(trim(FIN_ACC_NUM),6,5)  in('70004','70011') then  '900'
         when substr(trim(FIN_ACC_NUM),6,5)  in('70000','70001','70002','70003','70010','70020',
         '70021','70022','70030','70031','70040','70041','70042','70043','70099') then  '700'
         when substr(FIN_ACC_NUM,1,3) ='700' then  '700'
         else fin_sol_id end fin_sol_id,
         case when substr(trim(FIN_ACC_NUM),6,5)  in('70004','70011') then  '900'||substr(trim(FIN_ACC_NUM),4,13)
         when substr(trim(FIN_ACC_NUM),6,5)  in('70000','70001','70002','70003','70010','70020',
         '70021','70022','70030','70031','70040','70041','70042','70043','70099') then  '700'||substr(trim(FIN_ACC_NUM),4,13)
         else fin_acc_num end fin_acc_num,GL_SUB_HEAD_CODE from all_final_trial_balance_recon
         where  leg_acc_num  in(select leg_acc_num from tfs_sol_map_acc) and scheme_type='OAB'
union all
select scab||scan||scas leg_acct_num,
case when scan in(
'900050','900055','900060','900075','900090','900190','901050','901075',
'901090','903290','903590','907000','915127','915128','915129','915130',
'915205','915210','915228','915229','915230','970800') then '700'
when scan='913500' then '900' end fin_sol_id,
case when  scan in(
'900050','900055','900060','900075','900090','900190','901050','901075',
'901090','903290','903590','907000','915127','915128','915129','915130',
'915205','915210','915228','915229','915230','970800') then  '700'||substr(trim(FIN_ACC_NUM),4,13)
when scan='913500' then '900'||substr(trim(FIN_ACC_NUM),4,13) end
fin_acc_num,GL_SUB_HEAD_CODE from all_final_trial_balance_recon
where   scheme_type='OAB' and scan in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230','970800')
union all
select scab||scan||scas leg_acct_num,'603' fin_sol_id,FIN_ACC_NUM,GL_SUB_HEAD_CODE from all_final_trial_balance_recon where scab||scan||scas  in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840')
and new_fin_sol_id<>'005'
union all
select scab||scan||scas leg_acct_num,'617' fin_sol_id,FIN_ACC_NUM,GL_SUB_HEAD_CODE from ALL_FINAL_TRIAL_BAlance_recon where scab='0617' and fin_sol_id='610' and scbal <>0 and scheme_code='OAB' and isnumber(GL_SUB_HEAD_CODE)<>0
and gl_sub_head_code in('48602','48604','91440');


update all_final_trial_balance_recon a set (FIN_ACC_NUM,NEW_FIN_SOL_ID) = ( select FIN_ACC_NUM,FIN_SOL_ID from new_sol_acc_change_map b where scab||scan||scas = b.LEG_ACCT_NUM
)
where scab||scan||scas in(select LEG_ACCT_NUM from new_sol_acc_change_map);
commit;

UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15100 WHERE SCACT='3A' and scccy='KWD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15100 WHERE SCACT='3X' and scccy='KWD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15106 WHERE SCACT='3W' and scccy='KWD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15101 WHERE SCACT='3G' and scccy='AED';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15101 WHERE SCACT='3Y' and scccy='AED';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15101 WHERE SCACT='3G' and scccy='EUR';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15101 WHERE SCACT='3Y' and scccy='HKD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15101 WHERE SCACT='3G' and scccy='KWD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15101 WHERE SCACT='3Y' and scccy='KWD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15101 WHERE SCACT='3G' and scccy='USD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15102 WHERE SCACT='3X' and scccy='USD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15104 WHERE SCACT='3D' and scccy='USD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15104 WHERE SCACT='3A' and scccy='USD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15105 WHERE SCACT='3K' and scccy='KWD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15106 WHERE SCACT='3Y' and scccy='USD';
UPDATE all_final_trial_balance_recon SET GL_SUB_HEAD_CODE=15106 WHERE SCACT='3W' and scccy='USD';

update  all_final_trial_balance_recon set new_fin_sol_id='005' where fin_acc_num='9000129302004';
commit;	

select  fin_Acc_num,foracid, a.gl_sub_head_code gl_sub,gam.gl_sub_head_code,new_fin_sol_id,sol_id from (
select distinct fin_Acc_num,gl_sub_head_code,new_fin_sol_id from ALL_FINAL_TRIAL_BALANCE_RECON where scheme_type not in('SBA','CAA','ODA','TDA','CLA','LAA','PCA') and scbal<>0
and trim(fin_Acc_num) is not null
order by gl_sub_head_code)a
inner join (select * from tbaadm.gam where schm_type not in('SBA','CAA','ODA','TDA','CLA','LAA','PCA') and bank_id='01' and (clr_bal_amt+future_bal_amt)<>0 )gam on gam.foracid=fin_Acc_num
where a.gl_sub_head_code<>gam.gl_sub_head_code



update  ALL_FINAL_TRIAL_BALANCE_RECON set gl_sub_head_code='10104' where scact='CN' and fin_acc_num in('9000310101000','9000210101000','9000210101001','9000410101001');
commit;
update  ALL_FINAL_TRIAL_BALANCE_RECON set gl_sub_head_code='10400' where scact='CN' and fin_acc_num='9000110101000';
commit;
update  ALL_FINAL_TRIAL_BALANCE_RECON set gl_sub_head_code='91401' where scact='CN' and fin_acc_num in('9001010101000','9000410101007');
commit;

update ALL_FINAL_TRIAL_BALANCE_RECON set gl_sub_head_code='16100',new_fin_sol_id='007' where fin_acc_num in('1630129301000','1630229301000','1630229301001');
commit;


update ALL_FINAL_TRIAL_BALANCE_RECON c set C.NEW_FIN_SOL_ID =(
select  gam.sol_id from (
select distinct fin_Acc_num,gl_sub_head_code,new_fin_sol_id from ALL_FINAL_TRIAL_BALANCE_RECON where scheme_type not in('SBA','CAA','ODA','TDA','CLA','LAA','PCA') and scbal<>0
and trim(fin_Acc_num) is not null
order by gl_sub_head_code)a
inner join (select * from tbaadm.gam where schm_type not in('SBA','CAA','ODA','TDA','CLA','LAA','PCA') and bank_id='01' and (clr_bal_amt+future_bal_amt)<>0 )gam on gam.foracid=fin_Acc_num
where a.new_fin_sol_id<>gam.sol_id
and c.fin_acc_num=a.fin_acc_num)
where exists(
select  gam.sol_id from (
select distinct fin_Acc_num,gl_sub_head_code,new_fin_sol_id from ALL_FINAL_TRIAL_BALANCE_RECON where scheme_type not in('SBA','CAA','ODA','TDA','CLA','LAA','PCA') and scbal<>0
and trim(fin_Acc_num) is not null
order by gl_sub_head_code)a
inner join (select * from tbaadm.gam where schm_type not in('SBA','CAA','ODA','TDA','CLA','LAA','PCA') and bank_id='01' and (clr_bal_amt+future_bal_amt)<>0 )gam on gam.foracid=fin_Acc_num
where a.new_fin_sol_id<>gam.sol_id
and c.fin_acc_num=a.fin_acc_num)
and c.scheme_type not in('SBA','CAA','ODA','TDA','CLA','LAA','PCA') and c.scbal<>0
and trim(c.fin_Acc_num) is not null;
commit;

drop table PREMOCK_RECON_temp1;
create table PREMOCK_RECON_temp1 as
select to_char(Leg_branch_id) scab,to_char(leg_scan) scan,to_char(leg_scas) scas, to_char(EXTERNAL_ACC)external_no,to_char(map_acc.currency) scccy,to_char(leg_cust_type) scctp,to_char(leg_acct_type) scact,''SCACD,MAP_ACC.SCHM_TYPE,map_acc.schm_code,to_char(substr(case when trim(NPL) in('20','50')
then to_char(map_acc.fin_sol_id||cnc.CRNCY_ALIAS_NUM||PAST_DUE_INT_COLL_BACID)
else to_char(map_acc.fin_sol_id||cnc.CRNCY_ALIAS_NUM||PRINCIPAL_LOSSLINE_BACID) end,6,5))gl_sub_head,to_char(case when trim(NPL) in('20','50')
then to_char(map_acc.fin_sol_id||cnc.CRNCY_ALIAS_NUM||PAST_DUE_INT_COLL_BACID)
else to_char(map_acc.fin_sol_id||cnc.CRNCY_ALIAS_NUM||PRINCIPAL_LOSSLINE_BACID) end) fin_Acc_num,-to_number(TOTAL_INTEREST_PAST_DUE) balance,
-(to_number(TOTAL_INTEREST_PAST_DUE)*c8rte)  kwd_balance,
case when -to_number(TOTAL_INTEREST_PAST_DUE) < 0 then 'D' else 'C' end CREDIT_DEBIT_INDICATOR,''MASTER_REF,'O' indicator,fin_sol_id new_fin_sol_id
from iis 
left join map_Acc on DEL_REF=substr(leg_acc_num,8,15) and trim(ACC_NO)=fin_cif_id
left join (select * from tbaadm.gsp where bank_id=get_param('BANK_ID'))gss on gss.schm_code=MAP_ACC.SCHM_CODE
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on cnc.CRNCY_CODE=map_acc.currency
inner join c8pf on c8ccy=map_acc.currency
where leg_acc_num is   not null and trim(PAST_DUE_INT_COLL_BACID) is not null and triM(PRINCIPAL_LOSSLINE_BACID) is not null
union all
select to_char(LEG_BRANCH_ID), to_char(LEG_SCAN), to_char(LEG_SCAS), to_char(EXTERNAL_ACC), to_char(CURRENCY), to_char(LEG_ACCT_TYPE), to_char(LEG_CUST_TYPE), to_char(SCACD), to_char(SCHM_TYPE), 
to_char(SCHM_CODE), to_char(GL_SUB_HEADCODE), to_char(FIN_ACC_NUM), OVERDUE_AMT, OVERDUE_AMT_KWD, to_char(CREDIT_DEBIT_INDICATOR), to_char(MASTER_REF), to_char(INDICATOR),
substr(fin_Acc_num,1,3)NEW_FIN_SOL_ID from (
select LEG_BRANCH_ID,LEG_SCAN,LEG_SCAS,EXTERNAL_ACC,CURRENCY,LEG_ACCT_TYPE,LEG_CUST_TYPE,scacd,schm_type,schm_code,
GL_SUB_HEADCODE,
fin_Acc_num,sum(OVERDUE_AMT) OVERDUE_AMT,sum(OVERDUE_AMT_KWD)OVERDUE_AMT_KWD,CREDIT_DEBIT_INDICATOR,''MASTER_REF,'O'INDICATOR
from(
select leg_branch_id,leg_scan,leg_scas,
map_acc.EXTERNAL_ACC,MAP_ACC.CURRENCY,MAP_ACC.LEG_ACCT_TYPE,MAP_ACC.LEG_CUST_TYPE,scpf.scacd,MAP_ACC.SCHM_TYPE,'OVERDUE_INT' SCHM_code,
substr(lsp.LOAN_INT_BACID,1,5) GL_SUB_HEADCODE,
MAP_ACC.FIN_SOL_ID||cnc.CRNCY_ALIAS_NUM||lsp.LOAN_INT_BACID fin_acc_num,to_number(lsamtd - lsamtp)/POWER(10,c8pf.C8CED) overdue_amt,
(to_number(lsamtd - lsamtp)/POWER(10,c8pf.C8CED))*c8rte overdue_amt_kwd,case when to_number(lsamtd - lsamtp)/POWER(10,c8pf.C8CED)<0 then 'D'
else 'C' end CREDIT_DEBIT_INDICATOR
FROM map_acc
inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =leg_acc_num 
inner join c8pf on c8ccy = map_acc.currency
inner join (select * from tbaadm.lsp where bank_id=get_param('BANK_ID'))lsp on lsp.schm_code=map_acc.schm_code
inner join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on cnc.crncy_code=MAP_ACC.CURRENCY
inner join scpf on leg_branch_id||leg_scan||leg_scas=scab||scan||scas
where map_acc.schm_type='LAA' 
and leg_Acc_num not in('0600NFX1170316000052','0602NFX1151004000015','0607NFX1140211000041','0609NFX1150723000018','0612NFX1160823000060','0612NFX1170221000011','0633NFX1160228000013','0635NFX1151122000013'
--,'0601ZAB1110505000045','0602NFX1090308000011','0612ZAB1111229000005','0615ZAB1111228000020'
)
and lsmvt = 'I' and lsamtd <> 0 and (lsamtd -lsamtp) < 0 and lsdte <= get_param('EODCYYMMDD'))
group by LEG_BRANCH_ID,LEG_SCAN,LEG_SCAS,EXTERNAL_ACC,CURRENCY,LEG_ACCT_TYPE,LEG_CUST_TYPE,scacd,schm_type,schm_code,GL_SUB_HEADCODE,fin_Acc_num,CREDIT_DEBIT_INDICATOR)a
union all
select to_char(scab),to_char(scan),to_char(scas), to_char(trim(neean))external_no,to_char(scccy),to_char(scctp),to_char(scact),to_char(SCACD),''scheme_type,''scheme_code,
gl_sub_head_code gl_sub_head ,'603'||SUBSTR(TTUM1_MIGR_ACCT,4,2)||'90300001' fin_acc_num,scbal/power(10,c8ced) balance, ((scbal/power(10,c8ced))*c8rte)  kwd_balance,
case when scbal < 0 then 'D' else 'C' end CREDIT_DEBIT_INDICATOR,''MASTER_REF,'O' indicator,
'603'
NEW_FIN_SOL_ID
from all_final_trial_balance
inner join c8pf on c8ccy=scccy
inner join nepf on neab||nean||neas=scab||scan||scas
where scbal <> 0  and SCHEME_TYPE='OAB' and scact='RL'  
union all
select  to_char(scab),to_char(scan),to_char(scas), to_char(trim(neean))external_no,to_char(scccy),to_char(scctp),to_char(scact),to_char(SCACD),''scheme_type,''scheme_code,
gl_sub_head_code gl_sub_head ,'603'||SUBSTR(TTUM1_MIGR_ACCT,4,2)||'90300002' fin_acc_num,scbal/power(10,c8ced) balance, ((scbal/power(10,c8ced))*c8rte)  kwd_balance,
case when scbal < 0 then 'D' else 'C' end CREDIT_DEBIT_INDICATOR,''MASTER_REF,'O' indicator,
'603'
NEW_FIN_SOL_ID
from all_final_trial_balance
inner join c8pf on c8ccy=scccy
inner join nepf on neab||nean||neas=scab||scan||scas
where scbal <> 0  and SCHEME_TYPE='OAB' and scact='TL'
union all
select to_char(scab),to_char(scan),to_char(scas), to_char(trim(neean))external_no,to_char(scccy),to_char(scctp),to_char(scact),to_char(SCACD),''scheme_type,''scheme_code,
gl_sub_head_code gl_sub_head ,case when substr(trim(FIN_ACC_NUM),6,5)  in('70004','70011') then  '900'||substr(trim(FIN_ACC_NUM),4,13)
         when substr(trim(FIN_ACC_NUM),6,5)  in('70000','70001','70002','70003','70010','70020',
         '70021','70022','70030','70031','70040','70041','70042','70043','70099') then  '700'||substr(trim(FIN_ACC_NUM),4,13)
         else fin_acc_num end fin_acc_num,scbal/power(10,c8ced) balance, ((scbal/power(10,c8ced))*c8rte)  kwd_balance,
case when scbal < 0 then 'D' else 'C' end CREDIT_DEBIT_INDICATOR,''MASTER_REF,'O' indicator,
case when substr(trim(FIN_ACC_NUM),6,5)  in('70004','70011') then  '900'
         when substr(trim(FIN_ACC_NUM),6,5)  in('70000','70001','70002','70003','70010','70020',
         '70021','70022','70030','70031','70040','70041','70042','70043','70099') then  '700'
         when substr(FIN_ACC_NUM,1,3) ='700' then  '700'
         else fin_sol_id end
NEW_FIN_SOL_ID
from all_final_trial_balance
inner join c8pf on c8ccy=scccy
inner join nepf on neab||nean||neas=scab||scan||scas
where scbal <> 0  and SCHEME_TYPE='OAB'  
and    leg_acc_num  in(select leg_acc_num from tfs_sol_map_acc)
union all
select to_char(scab),to_char(scan),to_char(scas), to_char(trim(neean))external_no,to_char(scccy),to_char(scctp),to_char(scact),to_char(SCACD),''scheme_type,''scheme_code,
gl_sub_head_code gl_sub_head ,fin_acc_num,scbal/power(10,c8ced) balance, ((scbal/power(10,c8ced))*c8rte)  kwd_balance,
case when scbal < 0 then 'D' else 'C' end CREDIT_DEBIT_INDICATOR,''MASTER_REF,'O' indicator,NEW_FIN_SOL_ID
from all_final_trial_balance
inner join c8pf on c8ccy=scccy
inner join nepf on neab||nean||neas=scab||scan||scas
where scact in('YD','YI') and scbal <> 0 and isnumber(fin_acc_num)=1 
and scab||scan||scas  not in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840')
union all
select to_char(scab),to_char(scan),to_char(scas), to_char(trim(neean))external_no,to_char(scccy),to_char(scctp),to_char(scact),to_char(SCACD),''scheme_type,''scheme_code,
gl_sub_head_code gl_sub_head ,(case when new_fin_sol_id<>'005' then
'603' else
new_fin_sol_id end)||substr(fin_acc_num,4,13)  fin_acc_num,scbal/power(10,c8ced) balance, ((scbal/power(10,c8ced))*c8rte)  kwd_balance,
case when scbal < 0 then 'D' else 'C' end CREDIT_DEBIT_INDICATOR,''MASTER_REF,'O' indicator,case when new_fin_sol_id<>'005' then
'603' else
new_fin_sol_id end NEW_FIN_SOL_ID
from all_final_trial_balance
inner join c8pf on c8ccy=scccy
inner join nepf on neab||nean||neas=scab||scan||scas
where scact in('YD','YI') and scbal <> 0 and isnumber(fin_acc_num)=1 
and scab||scan||scas   in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840')
union all
select  to_char(scab),to_char(scan),to_char(scas), to_char(scab||scan||scas)external_no,to_char(scccy),to_char(scctp),to_char(scact),to_char(SCACD),' 'scheme_type,' 'scheme_code,
substr(
TO_CHAR (
new_sol.new_FIN_SOL_ID 
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
),6,5)gl_sub_head,
TO_CHAR (
new_sol.new_FIN_SOL_ID
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
)fin_acc_num,
INTEREST_FCY balance,
round((INTEREST_FCY) * c8rte,3) kwd_balance,
case when INTEREST_FCY < 0 then 'D' else 'C' end CREDIT_DEBIT_INDICATOR,' 'MASTER_REF,'O' indicator,new_sol.NEW_FIN_SOL_ID
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_balance_trfr_bkp
where NEW_FIN_SOL_ID=FIN_SOL_ID 
group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)b     on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
inner join (select s5ab,contra_basic,c8ccyn,NEW_FIN_SOL_ID
from int_recv_pay_balance_trfr_bkp where NEW_FIN_SOL_ID=FIN_SOL_ID group by s5ab,contra_basic,c8ccyn,NEW_FIN_SOL_ID)new_sol on  b.s5ab||b.contra_basic||b.c8ccyn=new_sol.s5ab||new_sol.contra_basic||new_sol.c8ccyn
inner join account_where_int_match_bk on brn = scab and basic = scan and suf = scas
inner join c8pf on c8ccy = scccy
WHERE (TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL)
union all
select  to_char(scab),to_char(scan),to_char(scas), to_char(scab||scan||scas) external_no,to_char(scccy),
to_char(scctp),to_char(scact),to_char(SCACD),' 'scheme_type,' 'scheme_code,
substr(
TO_CHAR (
new_sol.new_FIN_SOL_ID 
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
),6,5)gl_sub_head,
TO_CHAR (
new_sol.new_FIN_SOL_ID
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
)fin_acc_num,
INTEREST_FCY balance,
round((INTEREST_FCY) * c8rte,3) kwd_balance,
case when INTEREST_FCY < 0 then 'D' else 'C' end CREDIT_DEBIT_INDICATOR,' 'MASTER_REF,'O' indicator,new_sol.NEW_FIN_SOL_ID
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_balance_trfr_bkp
where NEW_FIN_SOL_ID<>FIN_SOL_ID 
 group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)b     on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
inner join (select s5ab,contra_basic,c8ccyn,NEW_FIN_SOL_ID
from int_recv_pay_balance_trfr_bkp where NEW_FIN_SOL_ID<>FIN_SOL_ID group by s5ab,contra_basic,c8ccyn,NEW_FIN_SOL_ID)new_sol on  b.s5ab||b.contra_basic||b.c8ccyn=new_sol.s5ab||new_sol.contra_basic||new_sol.c8ccyn
inner join account_where_int_match_bk on brn = scab and basic = scan and suf = scas
inner join c8pf on c8ccy = scccy
WHERE (TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL)
--New code added--
/*union all
select  to_char(scab),to_char(scan),to_char(scas), to_char(scab||scan||scas) external_no,to_char(scccy),
to_char(scctp),to_char(scact),to_char(SCACD),' 'scheme_type,' 'scheme_code,
substr(
TO_CHAR (
new_sol.new_FIN_SOL_ID 
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
),6,5)gl_sub_head,
TO_CHAR (
new_sol.new_FIN_SOL_ID
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
)fin_acc_num,
INTEREST_FCY balance,
round((INTEREST_FCY) * c8rte,3) kwd_balance,
case when INTEREST_FCY < 0 then 'D' else 'C' end CREDIT_DEBIT_INDICATOR,' 'MASTER_REF,'O' indicator,new_sol.NEW_FIN_SOL_ID
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_balance_trfr_bkp
where NEW_FIN_SOL_ID<>FIN_SOL_ID 
 group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)b     on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
inner join (select s5ab,contra_basic,c8ccyn,NEW_FIN_SOL_ID
from int_recv_pay_balance_trfr_bkp where NEW_FIN_SOL_ID<>FIN_SOL_ID group by s5ab,contra_basic,c8ccyn,NEW_FIN_SOL_ID)new_sol on  b.s5ab||b.contra_basic||b.c8ccyn=new_sol.s5ab||new_sol.contra_basic||new_sol.c8ccyn
inner join account_where_int_match_bk on brn = scab and basic = scan and suf = scas
inner join c8pf on c8ccy = scccy
WHERE (TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL)*/




/*drop  table PREMOCK_RECON_temp2;
create  table PREMOCK_RECON_temp2 as 
select scab,scan,scas,scact,scccy, substr(ttum1_migr_acct,1,3) new_FIN_SOL_ID, '52000'GL_SUB_HEADCODE,
(scbal+scsuma)/power(10,c8ced)-nvl(interest,0) balance,
round(((scbal+scsuma)/power(10,c8ced))*c8rte-nvl(interest,0),3) kwd_balance
from scpf a
inner join
(select scab brn,scan basic,scas suf,scbal/power(10,c8ced)bal,interest,ttum1_migr_acct from
(
select * from all_final_trial_balance 
where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
left join
(
select s5ab,contra_basic,c8ccyn,sum(interest_fcy)interest from int_recv_pay_balance_trfr_bkp1
WHERE (TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL)
group by s5ab,contra_basic,c8ccyn
)b
on scab||scan||scas = s5ab||contra_basic||c8ccyn
inner join c8pf on c8ccy = scccy
where nvl(scbal/power(10,c8ced),0) <> nvl(interest,0)
)b
on brn||basic||suf = scab||scan||scas
inner join c8pf on c8ccy = scccy
where ((scbal+scsuma)/power(10,c8ced)) <> nvl(interest,0)
union all
select a.scab,a.scan,a.scas scas,scact,scccy,substr(ttum1_migr_acct,1,3) new_FIN_SOL_ID,
'52000'gl_sub_head,-TOTAL_INTEREST_PAST_DUE balance,-TOTAL_INTEREST_PAST_DUE*c8rte kwd_balance
from all_final_trial_balance a
inner join c8pf on c8ccy=scccy
inner join (
select sum(to_number(TOTAL_INTEREST_PAST_DUE))TOTAL_INTEREST_PAST_DUE,case when npl in('20','50') then '879460'
else '879560' end scan
from iis 
left join map_Acc on DEL_REF=substr(leg_acc_num,8,15) and trim(ACC_NO)=fin_cif_id
left join (select * from tbaadm.gsp where bank_id=get_param('BANK_ID'))gss on gss.schm_code=MAP_ACC.SCHM_CODE
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on cnc.CRNCY_CODE=map_acc.currency
where leg_acc_num is    null
group by case when npl in('20','50') then '879460'
else '879560' end) iis on iis.scan=a.scan;*/








  
drop table SOL_EQUATION_DATA;
create table SOL_EQUATION_DATA AS
SELECT to_char(SCAB) scab,to_char(case when substr(scan,1,1) in ('8','9') then scan end)  scan,to_char(scact)scact,NEW_FIN_SOL_ID,to_char(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE,to_char(SCCCY) SCCCY,
SUM(CASE WHEN SCBAL < 0 THEN TO_NUMBER(SCBAL/C8PWD) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN SCBAL < 0 THEN TO_NUMBER((SCBAL/C8PWD)*C8RTE) ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN SCBAL >= 0 THEN TO_NUMBER(SCBAL/C8PWD) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN SCBAL >= 0 THEN TO_NUMBER((SCBAL/C8PWD)*C8RTE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM(TO_NUMBER(SCBAL/C8PWD)) FCY_SCBAL,
round(SUM(TO_NUMBER((SCBAL/C8PWD)*C8RTE)),3) KWD_SCBAL FROM ALL_FINAL_TRIAL_BALANCE_RECON
LEFT JOIN C8PF ON C8CCY = SCCCY 
where scbal <> 0 and scact not  IN('YD','YI','YP','RL','TL','J1','YU') and leg_acc_num  not in(select leg_acc_num from tfs_sol_map_acc) and scheme_type<>'LAA'
GROUP BY to_char(SCAB),case when substr(scan,1,1) in ('8','9') then scan end,scact,NEW_FIN_SOL_ID,to_char(GL_SUB_HEAD_CODE),SCCCY
union all
SELECT to_char(SCAB),to_char(case when substr(scan,1,1) in ('8','9') then scan end)  scan,to_char(scact),FIN_SOL_ID,to_char(GL_SUB_HEADCODE),to_char(CURRENCY),
SUM(CASE WHEN BALANCE < 0 THEN to_number(BALANCE) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE < 0 THEN to_number(KWD_BALANCE)  ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN BALANCE >= 0 THEN to_number(BALANCE) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE >= 0 THEN to_number(KWD_BALANCE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM( BALANCE) FCY_SCBAL,
round(SUM(KWD_BALANCE),3) KWD_SCBAL FROM PREMOCK_RECON_temp
LEFT JOIN C8PF ON C8CCY = CURRENCY 
left join map_sol on br_code=scab
where BALANCE <> 0 and  scheme_type='LAA'and SCHEME_CODE<>'OVERDUE_INT'
GROUP BY to_char(SCAB),case when substr(scan,1,1) in ('8','9') then scan end,to_char(scact),FIN_SOL_ID,GL_SUB_HEADCODE,to_char(CURRENCY)
union all
SELECT to_char(SCAB),to_char(case when substr(scan,1,1) in ('8','9') then scan end)  scan,to_char(scact),FIN_SOL_ID,to_char(GL_SUB_HEADCODE),to_char(CURRENCY),
SUM(CASE WHEN BALANCE < 0 THEN to_number(BALANCE) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE < 0 THEN to_number(KWD_BALANCE)  ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN BALANCE >= 0 THEN to_number(BALANCE) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE >= 0 THEN to_number(KWD_BALANCE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM( BALANCE) FCY_SCBAL,
round(SUM(KWD_BALANCE),3) KWD_SCBAL FROM PREMOCK_RECON_temp
LEFT JOIN C8PF ON C8CCY = CURRENCY 
left join map_sol on br_code=scab
where BALANCE <> 0 and scact   IN('YP') and scab||scan||scas not  in(select leg_acc_num from tfs_sol_map_acc)
GROUP BY to_char(SCAB),case when substr(scan,1,1) in ('8','9') then scan end,to_char(scact),FIN_SOL_ID,GL_SUB_HEADCODE,to_char(CURRENCY)
union all
SELECT to_char(SCAB),to_char(case when substr(scan,1,1) in ('8','9') then scan end)  scan,to_char(scact),FIN_SOL_ID,to_char(GL_SUB_HEADCODE),to_char(CURRENCY),
SUM(CASE WHEN BALANCE < 0 THEN to_number(BALANCE) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE < 0 THEN to_number(KWD_BALANCE)  ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN BALANCE >= 0 THEN to_number(BALANCE) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE >= 0 THEN to_number(KWD_BALANCE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM( BALANCE) FCY_SCBAL,
round(SUM(KWD_BALANCE),3) KWD_SCBAL FROM PREMOCK_RECON_temp
LEFT JOIN C8PF ON C8CCY = CURRENCY 
left join map_sol on br_code=scab
where BALANCE <> 0 and scact   IN('YU','YD','YI','J1') and  GL_SUB_HEADCODE in('47000','47007','52000')
GROUP BY to_char(SCAB),case when substr(scan,1,1) in ('8','9') then scan end,to_char(scact),FIN_SOL_ID,GL_SUB_HEADCODE,to_char(CURRENCY)
union all
SELECT SCAB,to_char(case when substr(scan,1,1) in ('8','9') then scan end)  scan,to_char(scact),new_FIN_SOL_ID,to_char(GL_SUB_HEAD),scccy,
SUM(CASE WHEN BALANCE < 0 THEN to_number(BALANCE) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE < 0 THEN to_number(KWD_BALANCE)  ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN BALANCE >= 0 THEN to_number(BALANCE) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE >= 0 THEN to_number(KWD_BALANCE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM( BALANCE) FCY_SCBAL,
round(SUM(KWD_BALANCE),3) KWD_SCBAL FROM PREMOCK_RECON_temp1
LEFT JOIN C8PF ON C8CCY = scccy 
where BALANCE <> 0 
GROUP BY SCAB,case when substr(scan,1,1) in ('8','9') then scan end,to_char(scact),new_FIN_SOL_ID,GL_SUB_HEAD,scccy;

update SOL_EQUATION_DATA  set GL_SUB_HEAD_CODE ='49304' where SCACT in('YM','TY') and GL_SUB_HEAD_CODE='TRY';
commit;
update SOL_EQUATION_DATA  set GL_SUB_HEAD_CODE ='90100' where SCACT in('V7') and GL_SUB_HEAD_CODE='TRY';
commit;

update SOL_EQUATION_DATA set NEW_FIN_SOL_ID='015' where gl_sub_head_code='83001' and dr_scbal='-41.25';
commit;
update  SOL_EQUATION_DATA set NEW_FIN_SOL_ID='015'  where KWD_CR_SCBAL='242.473';
commit;

/*union all
SELECT to_char(SCAB),to_char(case when substr(scan,1,1) in ('8','9') then scan end)  scan,to_char(scact),new_FIN_SOL_ID,to_char(GL_SUB_HEADCODE),to_char(scccy),
SUM(CASE WHEN BALANCE < 0 THEN to_number(BALANCE) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE < 0 THEN to_number(KWD_BALANCE)  ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN BALANCE >= 0 THEN to_number(BALANCE) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE >= 0 THEN to_number(KWD_BALANCE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM( BALANCE) FCY_SCBAL,
round(SUM(KWD_BALANCE),3) KWD_SCBAL FROM PREMOCK_RECON_temp2
LEFT JOIN C8PF ON C8CCY = scccy 
where BALANCE <> 0 
GROUP BY to_char(SCAB),case when substr(scan,1,1) in ('8','9') then scan end,scact,new_FIN_SOL_ID,GL_SUB_HEADCODE,scccy;*/


DROP TABLE SOL_FINALCE_DATA;
create table SOL_FINALCE_DATA AS
  SELECT SOL_ID,GL_SUB_HEAD_CODE GL_SUB_HEAD_CODE_FIN,ACCT_CRNCY_CODE,SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT < 0 THEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT ELSE 0 END) DR_CLR_BAL_AMT,
ROUND(SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT < 0 THEN (CLR_BAL_AMT+FUTURE_CLR_BAL_AMT)*C8RTE ELSE 0 END),3) KWD_DR_CLR_BAL_AMT,
SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT >= 0 THEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT ELSE 0 END) CR_CLR_BAL_AMT,
ROUND(SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT >= 0 THEN (CLR_BAL_AMT+FUTURE_CLR_BAL_AMT)*C8RTE ELSE 0 END),3) KWD_CR_CLR_BAL_AMT,
SUM(CLR_BAL_AMT+FUTURE_CLR_BAL_AMT) FCY_CLR_BAL_AMT,
round(SUM((CLR_BAL_AMT+FUTURE_CLR_BAL_AMT)*C8RTE),3) KWD_CLR_BAL_AMT
 FROM TBAADM.GAM
 LEFT JOIN C8PF ON C8CCY = ACCT_CRNCY_CODE 
  WHERE BANK_ID='01' and  CLR_BAL_AMT+FUTURE_CLR_BAL_AMT <>0 
  GROUP BY SOL_ID,GL_SUB_HEAD_CODE,ACCT_CRNCY_CODE;


drop table SOL_RECON;
create table SOL_RECON AS
SELECT SOL_EQUATION_DATA.*,SOL_FINALCE_DATA.*,SOL_FINALCE_DATA.ROWID ROW_ID FROM SOL_EQUATION_DATA
FULL JOIN SOL_FINALCE_DATA ON  trim(SOL_EQUATION_DATA.NEW_FIN_SOL_ID) = trim(SOL_FINALCE_DATA.SOL_ID) AND 
trim(SOL_EQUATION_DATA.GL_SUB_HEAD_CODE) = trim(SOL_FINALCE_DATA.GL_SUB_HEAD_CODE_FIN) AND  trim(SOL_EQUATION_DATA.SCCCY) = trim(SOL_FINALCE_DATA.ACCT_CRNCY_CODE);




drop table SOL_RECON1;
create table SOL_RECON1 AS
SELECT SCAB,SCAN,scact, NEW_FIN_SOL_ID, GL_SUB_HEAD_CODE, SCCCY, DR_SCBAL, KWD_DR_SCBAL, CR_SCBAL, KWD_CR_SCBAL, FCY_SCBAL, KWD_SCBAL,SUM(KWD_SCBAL) OVER(PARTITION BY ROW_ID ORDER BY ROW_ID) GROUP_KWD_SCBAL, 
SOL_ID, GL_SUB_HEAD_CODE_FIN, ACCT_CRNCY_CODE, DR_CLR_BAL_AMT, KWD_DR_CLR_BAL_AMT, CR_CLR_BAL_AMT, KWD_CR_CLR_BAL_AMT, FCY_CLR_BAL_AMT, KWD_CLR_BAL_AMT, 
DENSE_RANK() OVER(ORDER BY ROW_ID) GROUP_NUM,SUM(KWD_SCBAL) OVER(PARTITION BY ROW_ID ORDER BY ROW_ID)-nvl(KWD_CLR_BAL_AMT,0) DIFFERENCE  FROM SOL_RECON;


update SOL_RECON1 set GROUP_KWD_SCBAL='',SOL_ID='',GL_SUB_HEAD_CODE_FIN='',ACCT_CRNCY_CODE='',DR_CLR_BAL_AMT='',KWD_DR_CLR_BAL_AMT='',CR_CLR_BAL_AMT='',KWD_CR_CLR_BAL_AMT='',FCY_CLR_BAL_AMT='',KWD_CLR_BAL_AMT='',DIFFERENCE='0'
where rowid not in(select min(rowid) from SOL_RECON1 where KWD_CR_CLR_BAL_AMT is not null group by GROUP_NUM)
and KWD_CR_CLR_BAL_AMT is not null;
commit;


select * from SOL_RECON1 order by GROUP_NUM;


SELECT SCAB, NEW_FIN_SOL_ID, GL_SUB_HEAD_CODE, SCCCY, DR_SCBAL, KWD_DR_SCBAL, CR_SCBAL, KWD_CR_SCBAL, FCY_SCBAL, KWD_SCBAL,SUM(KWD_SCBAL) OVER(PARTITION BY ROW_ID ORDER BY ROW_ID) GROUP_KWD_SCBAL, 
SOL_ID, GL_SUB_HEAD_CODE_FIN, ACCT_CRNCY_CODE, DR_CLR_BAL_AMT, KWD_DR_CLR_BAL_AMT, CR_CLR_BAL_AMT, KWD_CR_CLR_BAL_AMT, FCY_CLR_BAL_AMT, KWD_CLR_BAL_AMT, 
DENSE_RANK() OVER(ORDER BY ROW_ID) GROUP_NUM,SUM(KWD_SCBAL) OVER(PARTITION BY ROW_ID ORDER BY ROW_ID)-KWD_CLR_BAL_AMT DIFFERENCE  FROM SOL_RECON;

-------------------------------------------------------------------------------------------------------------



--CURRENCY RECON




drop table CCY_EQUATION_DATA;
create table CCY_EQUATION_DATA AS
SELECT to_char(case when substr(scan,1,1) in ('8','9') then scan end)  scan,to_char(scact)scact,NEW_FIN_SOL_ID,to_char(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE,to_char(SCCCY) SCCCY,
SUM(CASE WHEN SCBAL < 0 THEN TO_NUMBER(SCBAL/C8PWD) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN SCBAL < 0 THEN TO_NUMBER((SCBAL/C8PWD)*C8RTE) ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN SCBAL >= 0 THEN TO_NUMBER(SCBAL/C8PWD) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN SCBAL >= 0 THEN TO_NUMBER((SCBAL/C8PWD)*C8RTE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM(TO_NUMBER(SCBAL/C8PWD)) FCY_SCBAL,
round(SUM(TO_NUMBER((SCBAL/C8PWD)*C8RTE)),3) KWD_SCBAL FROM ALL_FINAL_TRIAL_BALANCE_RECON
LEFT JOIN C8PF ON C8CCY = SCCCY 
where scbal <> 0 and scact not  IN('YD','YI','YP','RL','TL','J1','YU') and leg_acc_num  not in(select leg_acc_num from tfs_sol_map_acc) and scheme_type<>'LAA'
GROUP BY case when substr(scan,1,1) in ('8','9') then scan end,scact,NEW_FIN_SOL_ID,to_char(GL_SUB_HEAD_CODE),SCCCY
union all
SELECT to_char(case when substr(scan,1,1) in ('8','9') then scan end)  scan,to_char(scact),FIN_SOL_ID,to_char(GL_SUB_HEADCODE),to_char(CURRENCY),
SUM(CASE WHEN BALANCE < 0 THEN to_number(BALANCE) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE < 0 THEN to_number(KWD_BALANCE)  ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN BALANCE >= 0 THEN to_number(BALANCE) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE >= 0 THEN to_number(KWD_BALANCE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM( BALANCE) FCY_SCBAL,
round(SUM(KWD_BALANCE),3) KWD_SCBAL FROM PREMOCK_RECON_temp
LEFT JOIN C8PF ON C8CCY = CURRENCY 
left join map_sol on br_code=scab
where BALANCE <> 0 and  scheme_type='LAA'and SCHEME_CODE<>'OVERDUE_INT'
GROUP BY case when substr(scan,1,1) in ('8','9') then scan end,to_char(scact),FIN_SOL_ID,GL_SUB_HEADCODE,to_char(CURRENCY)
union all
SELECT to_char(case when substr(scan,1,1) in ('8','9') then scan end)  scan,to_char(scact),FIN_SOL_ID,to_char(GL_SUB_HEADCODE),to_char(CURRENCY),
SUM(CASE WHEN BALANCE < 0 THEN to_number(BALANCE) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE < 0 THEN to_number(KWD_BALANCE)  ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN BALANCE >= 0 THEN to_number(BALANCE) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE >= 0 THEN to_number(KWD_BALANCE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM( BALANCE) FCY_SCBAL,
round(SUM(KWD_BALANCE),3) KWD_SCBAL FROM PREMOCK_RECON_temp
LEFT JOIN C8PF ON C8CCY = CURRENCY 
left join map_sol on br_code=scab
where BALANCE <> 0 and scact   IN('YP') and scab||scan||scas not  in(select leg_acc_num from tfs_sol_map_acc)
GROUP BY case when substr(scan,1,1) in ('8','9') then scan end,to_char(scact),FIN_SOL_ID,GL_SUB_HEADCODE,to_char(CURRENCY)
union all
SELECT to_char(case when substr(scan,1,1) in ('8','9') then scan end)  scan,to_char(scact),FIN_SOL_ID,to_char(GL_SUB_HEADCODE),to_char(CURRENCY),
SUM(CASE WHEN BALANCE < 0 THEN to_number(BALANCE) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE < 0 THEN to_number(KWD_BALANCE)  ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN BALANCE >= 0 THEN to_number(BALANCE) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE >= 0 THEN to_number(KWD_BALANCE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM( BALANCE) FCY_SCBAL,
round(SUM(KWD_BALANCE),3) KWD_SCBAL FROM PREMOCK_RECON_temp
LEFT JOIN C8PF ON C8CCY = CURRENCY 
left join map_sol on br_code=scab
where BALANCE <> 0 and scact   IN('YU','YD','YI','J1') and  GL_SUB_HEADCODE in('47000','47007','52000')
GROUP BY case when substr(scan,1,1) in ('8','9') then scan end,to_char(scact),FIN_SOL_ID,GL_SUB_HEADCODE,to_char(CURRENCY)
union all
SELECT to_char(case when substr(scan,1,1) in ('8','9') then scan end)  scan,to_char(scact),new_FIN_SOL_ID,to_char(GL_SUB_HEAD),scccy,
SUM(CASE WHEN BALANCE < 0 THEN to_number(BALANCE) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE < 0 THEN to_number(KWD_BALANCE)  ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN BALANCE >= 0 THEN to_number(BALANCE) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN KWD_BALANCE >= 0 THEN to_number(KWD_BALANCE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM( BALANCE) FCY_SCBAL,
round(SUM(KWD_BALANCE),3) KWD_SCBAL FROM PREMOCK_RECON_temp1
LEFT JOIN C8PF ON C8CCY = scccy 
where BALANCE <> 0 
GROUP BY case when substr(scan,1,1) in ('8','9') then scan end,to_char(scact),new_FIN_SOL_ID,GL_SUB_HEAD,scccy;

update CCY_EQUATION_DATA  set GL_SUB_HEAD_CODE ='49304' where SCACT in('YM','TY') and GL_SUB_HEAD_CODE='TRY';
commit;
update CCY_EQUATION_DATA  set GL_SUB_HEAD_CODE ='90100' where SCACT in('V7') and GL_SUB_HEAD_CODE='TRY';
commit;


DROP TABLE CCY_FINALCE_DATA;
create table CCY_FINALCE_DATA AS
SELECT ACCT_CRNCY_CODE,GL_SUB_HEAD_CODE GL_SUB_HEAD_CODE_FIN,SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT < 0 THEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT ELSE 0 END) DR_CLR_BAL_AMT,
ROUND(SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT < 0 THEN (CLR_BAL_AMT+FUTURE_CLR_BAL_AMT)*C8RTE ELSE 0 END),3) KWD_DR_CLR_BAL_AMT,
SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT >= 0 THEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT ELSE 0 END) CR_CLR_BAL_AMT,
ROUND(SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT >= 0 THEN (CLR_BAL_AMT+FUTURE_CLR_BAL_AMT)*C8RTE ELSE 0 END),3) KWD_CR_CLR_BAL_AMT,
SUM(CLR_BAL_AMT+FUTURE_CLR_BAL_AMT) FCY_CLR_BAL_AMT,
SUM((CLR_BAL_AMT+FUTURE_CLR_BAL_AMT)*C8RTE) KWD_CLR_BAL_AMT
 FROM TBAADM.GAM
 LEFT JOIN C8PF ON C8CCY = ACCT_CRNCY_CODE 
  WHERE BANK_ID='01' and  CLR_BAL_AMT+FUTURE_CLR_BAL_AMT <>0 
  GROUP BY ACCT_CRNCY_CODE,GL_SUB_HEAD_CODE;

drop table CCY_RECON;

create table CCY_RECON AS
SELECT DISTINCT CCY_EQUATION_DATA.*,CCY_FINALCE_DATA.*,CCY_FINALCE_DATA.ROWID ROW_ID FROM CCY_EQUATION_DATA
FULL JOIN CCY_FINALCE_DATA ON  trim(CCY_EQUATION_DATA.GL_SUB_HEAD_CODE) = trim(CCY_FINALCE_DATA.GL_SUB_HEAD_CODE_FIN) AND  trim(CCY_EQUATION_DATA.SCCCY) = trim(CCY_FINALCE_DATA.ACCT_CRNCY_CODE)
ORDER BY CCY_FINALCE_DATA.GL_SUB_HEAD_CODE_FIN,ACCT_CRNCY_CODE;


drop table CCY_RECON1;

create table CCY_RECON1 AS
SELECT SCAN,scact, SCCCY, GL_SUB_HEAD_CODE,  DR_SCBAL, KWD_DR_SCBAL, CR_SCBAL, KWD_CR_SCBAL, FCY_SCBAL, KWD_SCBAL,SUM(KWD_SCBAL) OVER(PARTITION BY ROW_ID ORDER BY ROW_ID) GROUP_KWD_SCBAL, 
  ACCT_CRNCY_CODE,GL_SUB_HEAD_CODE_FIN, DR_CLR_BAL_AMT, KWD_DR_CLR_BAL_AMT, CR_CLR_BAL_AMT, KWD_CR_CLR_BAL_AMT, FCY_CLR_BAL_AMT, KWD_CLR_BAL_AMT, 
DENSE_RANK() OVER(ORDER BY ROW_ID) GROUP_NUM,SUM(KWD_SCBAL) OVER(PARTITION BY ROW_ID ORDER BY ROW_ID)-nvl(KWD_CLR_BAL_AMT,0) DIFFERENCE  FROM CCY_RECON;


update CCY_RECON1 set GROUP_KWD_SCBAL='',GL_SUB_HEAD_CODE_FIN='',ACCT_CRNCY_CODE='',DR_CLR_BAL_AMT='',KWD_DR_CLR_BAL_AMT='',CR_CLR_BAL_AMT='',KWD_CR_CLR_BAL_AMT='',FCY_CLR_BAL_AMT='',KWD_CLR_BAL_AMT='',DIFFERENCE='0'
where rowid not in(select min(rowid) from CCY_RECON1 where KWD_CR_CLR_BAL_AMT is not null group by GROUP_NUM)
and KWD_CR_CLR_BAL_AMT is not null;


select * from CCY_RECON1 order by GROUP_NUM;


---------------------------------------------

select equ.*,fin.*,equ.KWD_SCBAL-fin.KWD_CLR_BAL_AMT difference from (
SELECT GL_SUB_HEAD_CODE,SCCCY,
SUM(CASE WHEN SCBAL < 0 THEN TO_NUMBER(SCBAL/C8PWD) ELSE 0 END) DR_SCBAL,
ROUND(SUM(CASE WHEN SCBAL < 0 THEN TO_NUMBER((SCBAL/C8PWD)*C8RTE) ELSE 0 END),3) KWD_DR_SCBAL,
SUM(CASE WHEN SCBAL >= 0 THEN TO_NUMBER(SCBAL/C8PWD) ELSE 0 END) CR_SCBAL,
ROUND(SUM(CASE WHEN SCBAL >= 0 THEN TO_NUMBER((SCBAL/C8PWD)*C8RTE) ELSE 0 END),3) KWD_CR_SCBAL,
SUM(TO_NUMBER(SCBAL/C8PWD)) FCY_SCBAL,
SUM(TO_NUMBER((SCBAL/C8PWD)*C8RTE)) KWD_SCBAL FROM ALL_FINAL_TRIAL_BALANCE_RECON
LEFT JOIN C8PF ON C8CCY = SCCCY 
where SCBAL <> 0
GROUP BY GL_SUB_HEAD_CODE,SCCCY
) equ 
left join 
(SELECT GL_SUB_HEAD_CODE GL_SUB_HEAD_CODE_FIN ,ACCT_CRNCY_CODE,SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT < 0 THEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT ELSE 0 END) DR_CLR_BAL_AMT,
ROUND(SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT < 0 THEN (CLR_BAL_AMT+FUTURE_CLR_BAL_AMT)*C8RTE ELSE 0 END),3) KWD_DR_CLR_BAL_AMT,
SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT >= 0 THEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT ELSE 0 END) CR_CLR_BAL_AMT,
ROUND(SUM(CASE WHEN CLR_BAL_AMT+FUTURE_CLR_BAL_AMT >= 0 THEN (CLR_BAL_AMT+FUTURE_CLR_BAL_AMT)*C8RTE ELSE 0 END),3) KWD_CR_CLR_BAL_AMT,
SUM(CLR_BAL_AMT+FUTURE_CLR_BAL_AMT) FCY_CLR_BAL_AMT,
SUM((CLR_BAL_AMT+FUTURE_CLR_BAL_AMT)*C8RTE) KWD_CLR_BAL_AMT
 FROM TBAADM.GAM@DM1
 LEFT JOIN C8PF ON C8CCY = ACCT_CRNCY_CODE 
  WHERE BANK_ID='01' and CLR_BAL_AMT+FUTURE_CLR_BAL_AMT <> 0
  GROUP BY GL_SUB_HEAD_CODE,ACCT_CRNCY_CODE
) fin on equ.GL_SUB_HEAD_CODE = fin.GL_SUB_HEAD_CODE_FIN and equ.SCCCY = fin.ACCT_CRNCY_CODE
order by  GL_SUB_HEAD_CODE,SCCCY,equ.KWD_SCBAL-fin.KWD_CLR_BAL_AMT












------------------------
--Validation





--update  ALL_FINAL_TRIAL_BALANCE_RECON set GL_SUB_HEAD_CODE='TFS' where scact='TA' and scbaL<>0;
--commit;
--do not run multiple times








select FIN_ACC_NUM,foracid,scbal/c8pwd leg_amount,CLR_BAL_AMT+FUTURE_CLR_BAL_AMT fin_amount,scbal/c8pwd-CLR_BAL_AMT-FUTURE_CLR_BAL_AMT difference  from 
(select FIN_ACC_NUM,NEW_FIN_SOL_ID,GL_SUB_HEAD_CODE,scccy,sum(scbal) scbal from ALL_FINAL_TRIAL_BALANCE_RECON group by FIN_ACC_NUM,NEW_FIN_SOL_ID,GL_SUB_HEAD_CODE,scccy)  ALL_FINAL_TRIAL_BALANCE
left join c8pf on c8ccy = scccy
left join tbaadm.gam@dm1 on sol_id='610' and gam.GL_SUB_HEAD_CODE='48602' and clr_bal_amt<>0 and FIN_ACC_NUM = foracid AND  scbal/c8pwd!=CLR_BAL_AMT+FUTURE_CLR_BAL_AMT
where ALL_FINAL_TRIAL_BALANCE.gl_sub_head_code='48602' and NEW_FIN_SOL_ID='610' and scbal<>0;

 select FIN_ACC_NUM,foracid,scbal/c8pwd leg_amount,CLR_BAL_AMT+FUTURE_CLR_BAL_AMT fin_amount,scbal/c8pwd-CLR_BAL_AMT-FUTURE_CLR_BAL_AMT difference  from 
(select FIN_ACC_NUM,NEW_FIN_SOL_ID,GL_SUB_HEAD_CODE,scccy,sum(scbal) scbal from ALL_FINAL_TRIAL_BALANCE_RECON group by FIN_ACC_NUM,NEW_FIN_SOL_ID,GL_SUB_HEAD_CODE,scccy)  ALL_FINAL_TRIAL_BALANCE
left join c8pf on c8ccy = scccy
left join tbaadm.gam@dm1 on sol_id='&SOL_ID' and gam.GL_SUB_HEAD_CODE='&GLSH' and clr_bal_amt<>0 and FIN_ACC_NUM = foracid
where ALL_FINAL_TRIAL_BALANCE.gl_sub_head_code='&GLSH' and NEW_FIN_SOL_ID='&SOL_ID' and scbal<>0
and scbal/c8pwd!=CLR_BAL_AMT+FUTURE_CLR_BAL_AMT;


select * from ALL_FINAL_TRIAL_BALANCE_RECON where FIN_ACC_NUM='6100191020000' and scbal <>0;

select * from tbaadm.gam@dm1 where foracid='6100191020000' and clr_bal_amt <>0;

select SOL_ID,FORACID,ACCT_CRNCY_CODE,CLR_BAL_AMT FCY_CLR_BAL_AMT,(CLR_BAL_AMT*C8RTE) KWD_CLR_BAL_AMT
from tbaadm.gam@dm1
LEFT JOIN C8PF ON C8CCY = ACCT_CRNCY_CODE
where regexp_like(foracid,'[A-Z]') AND CLR_BAL_AMT <> 0



select FIN_ACC_NUM,TO_CHAR(SCCCY)SCCCY ,TO_NUMBER(SCBAL/C8PWD)SCBAL ,GL_SUB_HEAD_CODE,NEW_FIN_SOL_ID from ALL_FINAL_TRIAL_BALANCE_RECON 
LEFT JOIN C8PF ON C8CCY = SCCCY
where FIN_ACC_NUM IN('6170148602000') and scbal <>0
UNION ALL
select FORACID,ACCT_CRNCY_CODE,CLR_BAL_AMT,GL_SUB_HEAD_CODE,SOL_ID from tbaadm.gam@dm1 where foracid='6170148602000' and clr_bal_amt <>0;
 
