========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Custom_acct_closed_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Custom_acct_closed_upload.sql 
-- File Name		: custom_acct_closed.sql 
-- File Created for	: Upload file for cloased account flag
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 10-01-2016
-------------------------------------------------------------------
drop table custom_acct_closed;
create table custom_acct_closed as
select fin_acc_num,'Y' Acct_cls_flg,case when sccad<>0 and get_date_fm_btrv(sccad)<> 'ERROR'
         then lpad(to_char(to_date(get_date_fm_btrv(sccad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')          
         else lpad(' ',10,' ')
         end Acct_cls_date from scpf
inner join map_acc on leg_branch_id||leg_scan||leg_Scas=scab||Scan||scas
where scai30='Y' and scbal = 0
and schm_type in ('SBA','CAA','ODA','PCA');
exit;

 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_advance_int.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_advance_int.sql 
-- File Name		: custom_advance_int.sql 
-- File Created for	: Upload file for advance interest for BDT schm
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 25-01-2016
-------------------------------------------------------------------
truncate table custom_advance_int;
insert into custom_advance_int
select distinct
--account_id Nvarchar2(16),
rpad(fin_acc_num,16,' '),
--start_date Nvarchar2(10),
--rpad(ACCT_OPEN_DATE,8,' '),
to_char(to_date(ACCT_OPEN_DATE,'YYYYMMDD'),'DD-MM-YYYY'),
--End_date Nvarchar2(10),
--rpad(LIMIT_EXPIRY_DATE,8,' '),
to_char(to_date(LIMIT_EXPIRY_DATE,'YYYYMMDD'),'DD-MM-YYYY'),
--Sch_bal Nvarchar2(17),
lpad(SANCTION_LIMIT,17,' '),
--Int_amount Nvarchar2(17)
lpad(OMNWR/POWER(10,c8pf.C8CED),17,' ')
from map_acc 
inner join cl001_o_table on trim(acc_num)=fin_acc_num
inner join ompf ON trim(ombrnm)||trim(omdlp)||trim(omdlr)=LEG_ACC_NUM
inner join c8pf on c8ccy = currency
where map_acc.schm_code in ('BDT' ,'ATD')
and ommvt='I';
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_avg_bal_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_avg_bal_upload.sql 
-- File Name                       : custom_avg_bal_upload_ae.sql
-- File Created for            	   : average balance for cut off month 
-- Created By                      : Alavudeen Ali Badusha.R
-- Client                          : ABK
-- Created On                      : 30-01-2017
-------------------------------------------------------------------
drop table custom_avg_bal;
create table custom_avg_bal as
--select fin_acc_num,schm_type,SRBP03/power(10,c8ced) avg_bal from srpf  -- if it's cut off month end date then  SRBP01 field should be conoff month field.
select fin_acc_num,schm_type,to_number(SRBPTD)/power(10,c8ced) avg_bal from srpf 
inner join map_acc on srab||sran||sras=leg_branch_id||leg_scan||leg_scas
inner join c8pf on c8ccy=currency
where schm_type in ('SBA','CAA','ODA') and srsbtp='C';
--oda scheme type added on 08-06-2017 as per sandeep requirement.
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_cash_cr_lmit_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_cash_cr_lmit_upload.sql 
-- File Name		: custom_cash_cr_limit_upload.sql 
-- File Created for	: Upload file for cash deposit restricted for Currency exchange companies.
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 12-04-2016
-------------------------------------------------------------------
drop table custom_cash_cr_limit;
create table custom_cash_cr_limit as
select Fin_acc_num,'0' cash_cr_limit, schm_type from map_acc 
inner join scpf on scab||Scan||Scas=leg_branch_id||leg_scan||leg_scas
where schm_type in ('SBA','CAA','ODA')
and trim(scc3r)='EX';
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_core_limit_notes.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_core_limit_notes.sql 
TRUNCATE TABLE LLT_NOTES_MIG;

INSERT INTO LLT_NOTES_MIG
SELECT B.BANK_ID,
       B.LIMIT_PREFIX,
       B.LIMIT_SUFFIX,
      'N' DEL_FLG,
      SYSDATE LCHG_TIME,
      'SYSTEM' LCHG_USER_ID,
      'SYSTEM' RCRE_USER_ID,
       SYSDATE RCRE_TIME,
      TRIM(NOTE1)||' '||TRIM(NOTE2)||' '||TRIM(NOTE3) NOTES,
      MIN_STIP_COVG FREE_FIELD1,
      '' FREE_FIELD2,
      '' FREE_FIELD3
  FROM LIMIT_CORE_INFY_TABLE B
  LEFT JOIN LIMIT_CORE_NOTES_O_TABLE A  ON A.LIMIT_PREFIX = B.LIMIT_PREFIX
  LEFT JOIN (SELECT DISTINCT c.LIMIT_PREFIX,c.LIMIT_SUFFIX,MIN_STIP_COVG FROM COLL_LIM_LINKAGE_TMP A
  INNER JOIN COL_CUSTOM_O_TABLE B ON A.SECU_SRL_NUM= B.SECU_SRL_NUM
  inner join LIMIT_CORE_INFY_TABLE c on c.LIMIT_PREFIX = a.LIMIT_PREFIX ) C ON  B.LIMIT_PREFIX = C.LIMIT_PREFIX AND B.LIMIT_SUFFIX = C.LIMIT_SUFFIX
  ;
  
COMMIT; 
  
--INSERT INTO LLT_NOTES_MIG
--SELECT '01' BANK_ID,
--      LIMIT_PREFIX,
--      LIMIT_SUFFIX,
--      'N' DEL_FLG,
--      SYSDATE LCHG_TIME,
--      'SYSTEM' LCHG_USER_ID,
--      'SYSTEM' RCRE_USER_ID,
--       SYSDATE RCRE_TIME,
--      '' NOTES,
--      MIN_STIP_COVG FREE_FIELD1,
--      '' FREE_FIELD2,
--      '' FREE_FIELD3
--  FROM (SELECT DISTINCT c.LIMIT_PREFIX,c.LIMIT_SUFFIX,MIN_STIP_COVG FROM COLL_LIM_LINKAGE_TMP A
--  INNER JOIN COL_CUSTOM_O_TABLE B ON A.SECU_SRL_NUM= B.SECU_SRL_NUM
--    inner join LIMIT_CORE_INFY_TABLE c on c.LIMIT_PREFIX = a.LIMIT_PREFIX
--  WHERE c.LIMIT_PREFIX NOT IN(SELECT LIMIT_PREFIX FROM LLT_NOTES_MIG))
--  ;
--COMMIT;  
EXIT; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_Corp_sch_detl_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_Corp_sch_detl_upload.sql 
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
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_c_gac_ext_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_c_gac_ext_upload.sql 
-- File Name		: custom_c_gac_ext_upload.sql 
-- File Created for	: Upload file for account level analysis code,division and sub division details
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 07-03-2017
-------------------------------------------------------------------
set define off;
truncate table custom_c_gac_ext;
insert into custom_c_gac_ext
select 
--  BANK_ID       VARCHAR2(8 BYTE)                NOT NULL,
get_param('BANK_ID'),
--  FORACID          VARCHAR2(16 BYTE)               NOT NULL,
fin_acc_num,
--  DIVISION      VARCHAR2(100 BYTE)              NOT NULL,
case 
when nrd.officer_code is not null and trim(nrd.division)  is not null  then to_char(trim(nrd.division))
when trim(dv.DIVISION)='Corporate' then '001'
when trim(dv.DIVISION)='International' then '002'
when trim(dv.DIVISION)='Retail' then '003'
when trim(dv.DIVISION)='Treasury' then '005'
else '003' end,
--  SUB_DIVISION  VARCHAR2(100 BYTE)              NOT NULL,
--rpad(case when trim(DIVISION)='Corporate' then '725'
--when trim(DIVISION)='International' then '771'
--when trim(DIVISION)='Retail' then '500'
--when trim(DIVISION)='Treasury' then '781'
--else '500' end,100,' '),
case 
when nrd.officer_code is not null  and trim(SUBDIVISION)  is not null  then to_char(trim(nrd.subdivision))
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='CBD' then '00109'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Contracting' then '00140'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Financial Institutions' then '00160'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Infrastructure' then '00110'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Investment' then '00100'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Remedial' then '00180'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='SME' then '00120'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Services' then '00140'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Structured Workout' then '00170'
when trim(dv.DIVISION)='Corporate' and trim(dv.unit)='Trading' then '00150'
when trim(dv.DIVISION)='International' and trim(dv.unit)='Financial Institutions' then '00203'
when trim(dv.DIVISION)='International' and trim(dv.unit)='IBD' then '00200'
when trim(dv.DIVISION)='International' and trim(dv.unit)='Multinational & Oil' then '00204'
when trim(dv.DIVISION)='International' and trim(dv.unit)='NPL' then '00200'
when trim(dv.DIVISION)='Retail' and trim(dv.unit)='RBD' then '00339'  ----Changed on 26-7-2017 after discussion with Vijay
when trim(dv.DIVISION)='Treasury' and trim(dv.unit)='TRSY' then '00500'
else '00339' end,--Changed on 26-7-2017 after discussion with Vijay
--  DEL_FLG       CHAR(1 BYTE)                    NOT NULL,
'N',
--  LCHG_TIME     DATE                            NOT NULL,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--  LCHG_USER_ID  VARCHAR2(15 BYTE)               NOT NULL,
'SYSTEM',
--  RCRE_USER_ID  VARCHAR2(15 BYTE)               NOT NULL,
'SYSTEM',
--  RCRE_TIME     DATE                            NOT NULL,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--  ANALYSIS_CODE   VARCHAR2(100 BYTE),
SCACD,
--  FREE_FIELD2   VARCHAR2(100 BYTE),
'',
--  FREE_FIELD3   VARCHAR2(100 BYTE),
'',
--  FREE_FIELD4   VARCHAR2(100 BYTE)
''
from map_acc 
inner join scpf on scab||scan||Scas=leg_branch_id||leg_Scan||leg_Scas
left join rm_code_mapping dv on trim(dv.RESPONSIBILITY_CODE) =trim(scaco)
left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
where schm_type <> 'OOO'; 
--and trim(acc_closed) is null--- condition removed as per sandeep requirement on 08-06-2017 by mk4a observation
commit;
delete from custom_c_gac_ext where trim(division) is null and trim(sub_division) is null and trim(analysis_code) is null;
commit;
exit;

 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_deal_ref_number_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_deal_ref_number_upload.sql 
drop table custom_deal_ref_num;
create table custom_deal_ref_num as
select to_char(fin_acc_num) fin_acc_num,to_char(leg_acc_num) deal_ref_num from map_acc where schm_type in ('LAA','TDA') and schm_code NOT IN ('LAC','CLM') and length(leg_acc_num) > 5
union
select to_char(fin_acc_num) fin_acc_num,to_char(leg_branch_id||leg_scan||leg_scas) deal_ref_num from map_acc where schm_type in ('CLA') and schm_code NOT IN ('LAC','CLM') and length(leg_acc_num) > 5
union
select to_char(fin_acc_num),to_char(svna3) from svpf inner join sypf on syseq = svseq
inner join map_acc on syab||syan||syas = leg_branch_id||leg_scan||leg_scas
where trim(syprim) is null and map_acc.schm_code like 'P%'
and trim(SVNA3) is not null;
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_denomination_tacd_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_denomination_tacd_upload.sql 
drop table denom_table;
create table  denom_table as
select '001' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT01,case when CURRENCYCODE='EUR' then '500' when CURRENCYCODE='GBP' then '50' 
when CURRENCYCODE='KWD' then '20' when CURRENCYCODE='USD' then '100' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'N' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '002' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT02,case when CURRENCYCODE='EUR' then '200' when CURRENCYCODE='GBP' then '20'
when CURRENCYCODE='KWD' then '10' when CURRENCYCODE='USD' then '50'  else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'N' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault    where currencycode in ('EUR','GBP','KWD','USD')
union all
select '003' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT03,case when CURRENCYCODE='EUR' then '100' when CURRENCYCODE='GBP' then '10'
when CURRENCYCODE='KWD' then '5' when CURRENCYCODE='USD' then '20'  else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'N' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '004' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT04,case when CURRENCYCODE='EUR' then '50' when CURRENCYCODE='GBP' then '5'
when CURRENCYCODE='KWD' then '1' when CURRENCYCODE='USD' then '10'  else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'N' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '005' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT05,case when CURRENCYCODE='EUR' then '20' when CURRENCYCODE='GBP' then '0.01'
when CURRENCYCODE='KWD' then '0.500' when CURRENCYCODE='USD' then '5'  else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all 
select '006' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT06,case when CURRENCYCODE='EUR' then '10' when CURRENCYCODE='GBP' then '0.02'
when CURRENCYCODE='KWD' then '0.250' when CURRENCYCODE='USD' then '1'  else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'N' when CURRENCYCODE='USD' then 'N' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '007' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT07,case when CURRENCYCODE='EUR' then '5' when CURRENCYCODE='GBP' then '0.05'
when CURRENCYCODE='KWD' then '0.100' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'N' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '008' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT08,case when CURRENCYCODE='EUR' then '0.10' when CURRENCYCODE='GBP' then '0.10'
when CURRENCYCODE='KWD' then '0.050' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '009' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT09,case when CURRENCYCODE='EUR' then '0.20'  when CURRENCYCODE='GBP' then '0.20'
when CURRENCYCODE='KWD' then '0.020' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '010' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT10,case when CURRENCYCODE='EUR' then '0.50'  when CURRENCYCODE='GBP' then '0.10'
when CURRENCYCODE='KWD' then '0.010' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '011' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT11,case when CURRENCYCODE='EUR' then '1'  when CURRENCYCODE='GBP' then '1'
when CURRENCYCODE='KWD' then '0.005' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '012' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT12,case when CURRENCYCODE='EUR' then '2'  when CURRENCYCODE='GBP' then '2'
when CURRENCYCODE='KWD' then '0.001' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'C' 
when CURRENCYCODE='KWD' then 'C' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
case when CURRENCYCODE='KWD' then '50' else '' end STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '013' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT13,case when CURRENCYCODE='EUR' then '0.01'  when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '014' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT14,case when CURRENCYCODE='EUR' then '0.02'  when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '015' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT15,case when CURRENCYCODE='EUR' then '0.05'  when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'C' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault
union all
select '016' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT16,case when CURRENCYCODE='EUR' then  'XXX' when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX'else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '017' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT17,case when CURRENCYCODE='EUR' then 'XXX'  when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '018' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT18,case when CURRENCYCODE='EUR' then 'XXX'  when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '019' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT19,case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD')
union all
select '020' srl_num,BRANCHID,CURRENCYCODE,CURRENTBALANCE,DENOMINATIONCOUNT20,case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX'
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_VALUE,
case when CURRENCYCODE='EUR' then 'XXX' when CURRENCYCODE='GBP' then 'XXX' 
when CURRENCYCODE='KWD' then 'XXX' when CURRENCYCODE='USD' then 'XXX' else '' end DENOM_TYPE,
'100' STRAP_BUNDLE_SIZE from bank_vault where currencycode in ('EUR','GBP','KWD','USD');
------------------------------------------------------
truncate table tacd_o_table;
insert into tacd_o_table
select distinct 
--TELLER_ACCT
fin_acc_num,
--CRNCY_CODE
scccy,
--TRAN_ID
fin_sol_id,
--TRAN_DATE
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--CASH_TYPE
'RGLR',
--SRL_NUM
srl_num,
--BANK_ID
'01',
--ENTITY_CRE_FLG
'Y',
--DEL_FLG
' ',
--DENOM_VALUE
DENOM_VALUE,
--DENOM_TYPE
DENOM_TYPE,
--STRAP_BUNDLE_SIZE
STRAP_BUNDLE_SIZE,
--DENOM_COUNT
case when STRAP_BUNDLE_SIZE is null then to_char(DENOMINATIONCOUNT01) else to_char(mod(DENOMINATIONCOUNT01,STRAP_BUNDLE_SIZE)) end,
--DENOM_COUNT_PAYBACK
'0',
--STRAP_BUNDLE_COUNT
case when STRAP_BUNDLE_SIZE is null then '0' else to_char(DENOMINATIONCOUNT01-mod(DENOMINATIONCOUNT01,STRAP_BUNDLE_SIZE)) end,
--STRAP_BUNDLE_COUNT_PAYBACK
'0',
--LCHG_USER_ID
'SYSTEM',
--LCHG_TIME
GET_PARAM('EOD_DATE'),
--RCRE_USER_ID
'SYSTEM',
--RCRE_TIME
GET_PARAM('EOD_DATE'),
--TS_CNT
'0'
from all_final_trial_balance 
inner join c8pf on c8ccy=scccy
inner join denom_table a on scccy=CURRENCYCODE and scab=branchid
where gl_sub_head_code='10003' and scbal <> 0 and scab||scan||Scas not in ('0601800009414');
commit;
delete from tacd_o_table where DENOM_VALUE='XXX';
commit;
----------------hEAD OFFICE ACCOUNT -----------------
insert into tacd_o_table
select distinct 
--TELLER_ACCT
fin_acc_num,
--CRNCY_CODE
scccy,
--TRAN_ID
fin_sol_id,
--TRAN_DATE
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--CASH_TYPE
'RGLR',
--SRL_NUM
SRL_NUM,
--BANK_ID
'01',
--ENTITY_CRE_FLG
'Y',
--DEL_FLG
' ',
--DENOM_VALUE
DENOM_VALUE,
--DENOM_TYPE
DENOM_TYPE,
--STRAP_BUNDLE_SIZE
BUNDAL_SIZE,
--DENOM_COUNT
case when BUNDAL_SIZE is null then to_char(NO_OF_BUNDLES) else to_char(mod(NO_OF_BUNDLES,BUNDAL_SIZE)) end,
--DENOM_COUNT_PAYBACK
'0',
--STRAP_BUNDLE_COUNT
case when BUNDAL_SIZE is null then '0' else to_char(NO_OF_BUNDLES-mod(NO_OF_BUNDLES,BUNDAL_SIZE)) end,
--STRAP_BUNDLE_COUNT_PAYBACK
'0',
--LCHG_USER_ID
'SYSTEM',
--LCHG_TIME
GET_PARAM('EOD_DATE'),
--RCRE_USER_ID
'SYSTEM',
--RCRE_TIME
GET_PARAM('EOD_DATE'),
--TS_CNT
'0'
from all_final_trial_balance 
inner join c8pf on c8ccy=scccy
inner join denom a on EQ_GL_AC_NUMBER=SCAB||SCAN||SCAS
where scbal <> 0 and scab||scan||Scas in (
'0500800051414',
'0900800000826',
'0900800000840',
'0900800000978');
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_denomination_tach_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_denomination_tach_upload.sql 
truncate table tach_o_table;
insert into tach_o_table
select distinct 
--TELLER_ACCT
fin_acc_num,
--CRNCY_CODE
scccy,
--SOL_ID
fin_sol_id,
--TRAN_ID
null,
--TRAN_DATE
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BANK_ID
'01',
--STATUS
'O',
--ENTITY_CRE_FLG
'Y',
--DEL_FLG
' ',
--VAULT_BAL
sum(scbal/power(10,c8ced)),
--REG_AMT
'0',
--BAIT_AMT
'0',
--MUTILATED_AMT
'0',
--TOTAL_CASH_AMT
sum(scbal/power(10,c8ced)),
--PHYSICAL_CASH_AMT
'0',
--EXCESS_CASH
'0',
--SHORT_CASH
'0',
--LCHG_USER_ID
'SYSTEM',
--LCHG_TIME
GET_PARAM('EOD_DATE'),
--RCRE_USER_ID
'SYSTEM',
--RCRE_TIME
GET_PARAM('EOD_DATE'),
--TS_CNT
'0'
from all_final_trial_balance 
inner join c8pf on c8ccy=scccy
where gl_sub_head_code='10003' and scbal <> 0
group by fin_acc_num,scccy,fin_sol_id;
commit;
---------------HEAD OFFICE ACCOUNT-----------
insert into tach_o_table
select distinct 
--TELLER_ACCT
fin_acc_num,
--CRNCY_CODE
scccy,
--SOL_ID
fin_sol_id,
--TRAN_ID
null,
--TRAN_DATE
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BANK_ID
'01',
--STATUS
'O',
--ENTITY_CRE_FLG
'Y',
--DEL_FLG
' ',
--VAULT_BAL
sum(scbal/power(10,c8ced)),
--REG_AMT
'0',
--BAIT_AMT
'0',
--MUTILATED_AMT
'0',
--TOTAL_CASH_AMT
sum(scbal/power(10,c8ced)),
--PHYSICAL_CASH_AMT
'0',
--EXCESS_CASH
'0',
--SHORT_CASH
'0',
--LCHG_USER_ID
'SYSTEM',
--LCHG_TIME
GET_PARAM('EOD_DATE'),
--RCRE_USER_ID
'SYSTEM',
--RCRE_TIME
GET_PARAM('EOD_DATE'),
--TS_CNT
'0'
from all_final_trial_balance 
inner join c8pf on c8ccy=scccy
where scbal <> 0 AND TRIM(SCAB||SCAN||SCAS) IN  (
'0500800051414',
'0900800000826',
'0900800000840',
'0900800000978')
group by fin_acc_num,scccy,fin_sol_id;
commit;
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_draw_down_int.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_draw_down_int.sql 
-- File Name        : custom_draw_down_int_upload.sql 
-- File Created for    : Upload file for individual draw down interest
-- Created By        : R.Alavudeen Ali Badusha
-- Client            : ABK
-- Created On        : 10-05-2017
-------------------------------------------------------------------
truncate table draw_down_int_o_table;
insert into draw_down_int_o_table 
select 
--Account_Number  nvarchar2(16),
rpad(A.fin_acc_num,16,' '),
--Draw_Down_Date  nvarchar2(10), 
rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
    else ' ' end,10,' '),
--Draw_Down_Amount nvarchar2(17),
lpad(sum(abs(to_number(omnwp/POWER(10,c8pf.C8CED)))),17,' '),---Gop-- appended 1 to table name
--lpad(sum(abs(to_number(ompf_ld_cla.omnwp/POWER(10,c8pf.C8CED)))),17,' '),
--Effective_Int_Rate nvarchar2(10),
rpad(acc_pref_rate,10,' '),
--Event_Flag nvarchar2(1)
rpad(' ',1,' ')
from (select * from map_acc  where length(trim(leg_acc_num))<13)a
inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=serial_deal
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr)=b.LEG_ACC_NUM
inner join ompf on ombrnm||trim(omdlp)||trim(omdlr)=b.LEG_ACC_NUM
inner join c8pf on c8ccy = currency
where ommvt='P' and ommvts in ('C','O')
group by a.fin_acc_num,otsdte,acc_pref_rate;
commit;
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_draw_down_schedule.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_draw_down_schedule.sql 
drop table ompf_ld_cla2;
create table ompf_ld_cla2 as
select ombrnm||trim(omdlp)||trim(omdlr) ompf_leg_num,sum(omnwp) omnwp from  map_acc a 
inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
inner join ompf on ombrnm||trim(omdlp)||trim(omdlr) =b.leg_acc_num 
where ommvt='P' and ommvts in ('C','O') group by ombrnm||trim(omdlp)||trim(omdlr);
truncate table draw_down_o_table;
--insert into draw_down_o_table
--select
----Account_Number nvarchar2(16),
--rpad(fin_acc_num,16,' '),
----Start_Date     nvarchar2(10),
--START_DATE,
----End_Date nvarchar2(10),
--end_date, ---- based on sandepp requirement on 20-06-2017 changed from start_date to end_date
----Scheduled_Draw_Down_Amount nvarchar2(17),
--lpad(AMT,17,' '),
----Draw_Down_Currency nvarchar2(3),
--rpad(otccy,3,' '),
----Credit_Account_Num nvarchar2(16),
--rpad(' ',16,' '),
----ECS_Mandate_Serial nvarchar2(12),
--rpad(' ',12,' '),
----Mode_of_Draw_Down nvarchar2(1),
--rpad(' ',1,' '),
----Actual_Draw_Down_Amount nvarchar2(17),
--lpad(AMT,17,' '),-----------------value added on 15-08-2017 as per vijay discussion with nancy and natraj
----Remarks nvarchar2(60),
--rpad(deal_num,60,' '),---- based on sandeep requirement on 20-06-2017 deal num added
----Paysys_ID nvarchar2(5)
--rpad(' ',5,' ')
--from (select fin_acc_num,otccy,--LISTAGG(trim(b.leg_acc_num), ',')  WITHIN GROUP (ORDER BY fin_acc_num) deal_num,
--b.leg_acc_num deal_num,
--rpad(case --when v5lre<>'0' and get_date_fm_btrv(v5lre) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD'),'DD-MM-YYYY') ---based on nancy mail dt 20-08-2017 v5lre(last roll over date) commented
--     when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
--    else ' ' end,10,' ') start_date,
--rpad((case when --v5ncd<>'0' and get_date_fm_btrv(v5ncd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5ncd),'YYYYMMDD'),'DD-MM-YYYY') ---based on nancy mail dt 20-08-2017 v5ncd(next cycle date) commented)
--     when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY')
--     else ' ' end),10,' ') end_date,
----lpad(sum(abs(to_number(ompf_ld_cla2.omnwp/POWER(10,c8pf.C8CED)))),17,' ') amt
--lpad((abs(to_number(v5bal)/POWER(10,c8pf.C8CED))),17,' ') amt
--from (select * from map_acc where length(trim(leg_acc_num))<13) a
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
--left join otpf on otbrnm||trim(otdlp)||trim(otdlr)=b.LEG_ACC_NUM
--left join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr)=b.LEG_ACC_NUM
----left join ompf_ld_cla2 on ompf_leg_num=b.LEG_ACC_NUM
--inner join c8pf on c8ccy = currency
----group by fin_acc_num,otccy,rpad(case when v5lre<>'0' and get_date_fm_btrv(v5lre) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD'),'DD-MM-YYYY') when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
--    --else ' ' end,10,' ')
--);
--commit;
insert into draw_down_o_table
select
--Account_Number nvarchar2(16),
rpad(fin_acc_num,16,' '),
--Start_Date     nvarchar2(10),
rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
    else ' ' end,10,' '),
--End_Date nvarchar2(10),
rpad((case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY')
     else ' ' end),10,' '),
--Scheduled_Draw_Down_Amount nvarchar2(17),
--lpad(case when abs(v5bal) > omnwp then  (abs(to_number(omnwp)/POWER(10,c8pf.C8CED)))
--else (abs(to_number(v5bal)/POWER(10,c8pf.C8CED))) end,17,' '),
lpad(abs(to_number(otdla/POWER(10,c8pf.C8CED))),17,' '),------changes on 07-09-2017 based on vijay discussion in meeting original deal amount  changed to current outstanding deal amount
--Draw_Down_Currency nvarchar2(3),
rpad(otccy,3,' '),
--Credit_Account_Num nvarchar2(16),
rpad(' ',16,' '),
--ECS_Mandate_Serial nvarchar2(12),
rpad(' ',12,' '),
--Mode_of_Draw_Down nvarchar2(1),
rpad(' ',1,' '),
--Actual_Draw_Down_Amount nvarchar2(17),
--lpad((abs(to_number(v5bal)/POWER(10,c8pf.C8CED))),17,' '),
lpad((abs(to_number(omnwp)/POWER(10,c8pf.C8CED))),17,' '),------changed on 07-09-2017 as per dicussion with vijay,nataraj and sandeep and nancy mail
--Remarks nvarchar2(60),fs
rpad(A.leg_acc_num,60,' '),
--Paysys_ID nvarchar2(5)
rpad(' ',5,' ')
from map_acc a
left join otpf on otbrnm||trim(otdlp)||trim(otdlr)=a.LEG_ACC_NUM
left join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr)=a.LEG_ACC_NUM
inner join c8pf on c8ccy = currency
inner join ompf_cla ON OMPF_LEG_NUM=LEG_ACC_NUM
WHERE SCHM_TYPE='CLA' and a.schm_code not in ('BDT','LAC','CLM');
commit;
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_eit_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_eit_upload.sql 
--Corporate Loan Drawdown bloack added on 04-06-2017--
--drop table cla_ld_accrual;
--create table cla_ld_accrual as
--select a.fin_acc_num,sum(to_number(v5am1)+to_number(V5AIM)) accrual
--from map_acc a
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
--left join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr)=b.LEG_ACC_NUM
--group by a.fin_acc_num;
drop table s7pf_bal;
create table s7pf_bal as
select s7ab||s7an||s7as leg_num,s7bal1 min_bal,S7ND01 days,'01' Mnth,'01-01-2017' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal2,S7ND02,'02','01-02-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal3,S7ND03,'03','01-03-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal4,S7ND04,'04','01-04-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal5,S7ND05,'05','01-05-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal6,S7ND06,'06','01-06-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal7,S7ND07,'07','01-07-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal8,S7ND08,'08','01-08-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7bal9,S7ND09,'09','01-09-2016' dat from s7pf where s7sbtp='L' 
union all
--select s7ab||s7an||s7as leg_num,s7bala,S7ND10,'10','01-10-2016' dat from s7pf where s7sbtp='L' 
--union all
select s7ab||s7an||s7as leg_num,s7balb,S7ND11,'11','01-12-2016' dat from s7pf where s7sbtp='L' 
union all
select s7ab||s7an||s7as leg_num,s7balc,S7ND12,'12','01-12-2016' dat from s7pf where s7sbtp='L' 
----if it's cutoff date in between  month --enable s7balm
union all 
select s7ab||s7an||s7as leg_num,s7balm,S7NDtd,to_char(to_date(get_param('EOD_DATE'),'DD-MM_YYYY'),'MM'),to_char(trunc(to_date(get_param('EOD_DATE'),'DD-MM_YYYY'),'MM'),'DD-MM-YYYY') Dat from s7pf where s7sbtp='L'
; 
drop table s7pf_bal1;
create table s7pf_bal1 as
select distinct leg_num,min_bal/power(10,c8ced) min_bal,days,mnth,s5ifqc,s5ncdc,S5CCY from s5pf
inner join s7pf_bal a on leg_num=s5ab||s5an||s5as
inner join map_acc on leg_branch_id||leg_scan||leg_scas=leg_num
inner join c8pf on s5ccy=c8ccy
where s5ncdc <> '9999999' and schm_type ='SBA'
--and to_number(to_char(add_months(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),case when substr(s5ifqc,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then -12
--    when substr(s5ifqc,0,1) in ('V') then -1 when substr(s5ifqc,0,1) in ('S','T','U') then -3 when substr(s5ifqc,0,1) in ('M','N','O','P','Q','R') then -6 else -1 end),'MM')) <= to_number(mnth)
and add_months(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),case when substr(s5ifqc,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then -12
   when substr(s5ifqc,0,1) in ('V') then -1 when substr(s5ifqc,0,1) in ('S','T','U') then -3 when substr(s5ifqc,0,1) in ('M','N','O','P','Q','R') then -6 else -1 end)  < to_date(dat,'DD-MM-YYYY')
order by leg_num,mnth;
drop table s7pf_bal2;
create table s7pf_bal2 as
select distinct leg_num,min_bal,s5ifqc from s7pf_bal1 
where (leg_num,min_bal) in (
select leg_num,min(to_number(min_bal)) min_bal from s7pf_bal1  group by leg_num);
--create table s7pf_bal2 as
--select distinct leg_num,min_bal,TRANSACTION_DATE,RUNNING_BALANCE,s5ifqc,
--case when TRANSACTION_DATE is not null then TRANSACTION_DATE else add_months(to_date(get_date_fm_btrv(S5NCDC),'YYYYMMDD'),case when substr(s5ifqc,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then -12
--    when substr(s5ifqc,0,1) in ('V') then -1 when substr(s5ifqc,0,1) in ('S','T','U') then -3 when substr(s5ifqc,0,1) in ('M','N','O','P','Q','R') then -6 else -1 end) end tran_date 
-- from s7pf_bal1 
--left join archival_transaction b on to_char(transaction_date,'MM')=mnth and min_bal=RUNNING_BALANCE and leg_num=acc_number
--where (leg_num,mnth) in (
--select leg_num,min(mnth) mnth from s7pf_bal1 where (leg_num,min_bal) in (
--select leg_num,min(to_number(min_bal)) min_bal from s7pf_bal1  group by leg_num)
--group by leg_num );

--EIT FOR SBA CAA AND ODA---
truncate table CUSTOM_EIT;
insert into CUSTOM_EIT
select 
--ENTITY_ID,
gam.acid,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--ACCRUED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--INTEREST_CALC_UPTO_DATE_CR,
case when S5LCDC<>0 and   get_date_fm_btrv(S5LCDC) <> 'ERROR' then to_date(get_date_fm_btrv(S5LCDC),'YYYYMMDD') 
else to_date(get_param('EOD_DATE'),'DD-MM-YYYY') end, ---as per sandeep confirmation cut off date provided on 05-03-2017
--INTEREST_CALC_UPTO_DATE_DR,
case when S5LCDD<>0 and   get_date_fm_btrv(S5LCDD) <> 'ERROR' then to_date(get_date_fm_btrv(S5LCDD),'YYYYMMDD') 
else to_date(get_param('EOD_DATE'),'DD-MM-YYYY') end,
--LAST_INTEREST_RUN_DATE_CR,
case when S5LCDC<>0 and   get_date_fm_btrv(S5LCDC) <> 'ERROR' then to_date(get_date_fm_btrv(S5LCDC),'YYYYMMDD') 
else to_date(get_param('EOD_DATE'),'DD-MM-YYYY') end,
--LAST_INTEREST_RUN_DATE_DR,
case when S5LCDD<>0 and   get_date_fm_btrv(S5LCDD) <> 'ERROR' then to_date(get_date_fm_btrv(S5LCDD),'YYYYMMDD') 
else to_date(get_param('EOD_DATE'),'DD-MM-YYYY') end,
--XFER_MIN_BAL,
case when map_acc.schm_type='SBA' and min_bal is not null and s5pf.s5ifqc='Z' and scbal > 0 then scbal/power(10,c8ced) when map_acc.schm_type='SBA' and min_bal is not null then nvl(min_bal,0) else null end,
--XFER_MIN_BAL_DATE,
case when map_acc.schm_type='SBA' and min_bal is not null then to_date(get_param('EOD_DATE'),'DD-MM-YYYY') else null end,
--NRML_ACCRUED_AMOUNT_CR,
abs(to_number((s5am1c)/POWER(10,c8pf.C8CED))),
--NRML_BOOKED_AMOUNT_CR,
abs(to_number((s5am1c)/POWER(10,c8pf.C8CED))),
--NRML_BOOKED_AMOUNT_DR,
abs(to_number((s5am1d)/POWER(10,c8pf.C8CED))),
--NRML_ACCRUED_AMOUNT_DR
abs(to_number((s5am1d)/POWER(10,c8pf.C8CED)))
from map_acc
inner join scpf on scpf.scab=map_acc.leg_branch_id and scpf.scan=map_acc.leg_scan and scpf.scas=map_acc.leg_scas   
inner join s5pf on s5pf.s5ab=map_acc.leg_branch_id and s5pf.s5an=map_acc.leg_scan and s5pf.s5as=map_acc.leg_scas
--left join (select * from s7pf_bal2 where (leg_num,to_date(tran_date,'DD-MM-YYYY')) in ( 
--select leg_num, min(to_date(tran_date,'DD/MM/YYYY')) tran_date from s7pf_bal2 group by leg_num)) bal on leg_num=leg_branch_id||leg_scan||leg_scas
left join s7pf_bal2 on leg_num=leg_branch_id||leg_scan||leg_scas
left join (select * from tbaadm.gam where schm_type in('SBA','CAA','ODA')and bank_id=get_param('BANK_ID')) gam on gam.foracid=map_acc.fin_acc_num
inner join c8pf on c8ccy = map_acc.currency       
where map_acc.schm_type in ('SBA','CAA','ODA') and map_acc.schm_code<>'PISLA' and scai30 <> 'Y'
union
select 
--ENTITY_ID,
gam.acid,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--ACCRUED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 05-03-2017
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--BOOKED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 05-03-2017
--INTEREST_CALC_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--INTEREST_CALC_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--LAST_INTEREST_RUN_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--LAST_INTEREST_RUN_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--XFER_MIN_BAL,
0,
--XFER_MIN_BAL_DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--NRML_ACCRUED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_DR,
0,
--NRML_ACCRUED_AMOUNT_DR
(to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced)
from v5pf
inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
inner join c8pf on trim(c8ccy)=currency
left join ospf on v5brnm=osbrnm and v5dlp=osdlp and v5dlr=osdlr
left join (select * from otpf where OTTDT='L')otpf on  v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
left join (select * from tbaadm.gam where schm_type in('SBA','CAA','ODA')and bank_id=get_param('BANK_ID')) gam on gam.foracid=map_acc.fin_acc_num
where map_acc.SCHM_TYPE in('CAA') AND map_acc.schm_code='PISLA' and v5pf.v5tdt='L' and v5pf.v5bal<>'0' and scai30 <> 'Y';
commit;
--EIT FOR TDA--
insert into CUSTOM_EIT
select 
--ENTITY_ID,
gam.acid,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--ACCRUED_UPTO_DATE_DR,
case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') else NULL end, ---Based on Sandeep requirement added on 20-06-2017
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_DR,
case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') else NULL end, ---Based on Sandeep requirement added on 20-06-2017
--INTEREST_CALC_UPTO_DATE_CR,
case 
when map_acc.schm_code='TDATD' and v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999'  then to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD') ---added on 25-09-2017 based on vijay discussion with sandeep and ravi maturity dt provided for atd schm
when  trim(v5lre)=0 and v5lcd <> 0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') --Added by jagadeesh on 15/May as issue was reported by Infosys Spira 6335
when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1
when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')
when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1
else to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 end,
--INTEREST_CALC_UPTO_DATE_DR,
case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') else NULL end, ---Based on Sandeep requirement added on 20-06-2017
--LAST_INTEREST_RUN_DATE_CR,
case 
when map_acc.schm_code='TDATD' and v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999'  then to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD') ---added on 25-09-2017 based on vijay discussion with sandeep and ravi maturity dt provided for atd schm
when  trim(v5lre)=0 and v5lcd <> 0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') --Added by jagadeesh on 15/May as issue was reported by Infosys Spira 6335
when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1
when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')
when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1
else to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 end,
--LAST_INTEREST_RUN_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--XFER_MIN_BAL,
0,
--XFER_MIN_BAL_DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017,
--NRML_ACCRUED_AMOUNT_CR,
case when map_acc.schm_code='TDATD' then  to_number(nvl(atd_clmamount,0))/power(10,c8pf.c8ced)--(to_number(v5am1)+to_number(V5AIM)+to_number(nvl(atd_clmamount,0)))/power(10,c8pf.c8ced)--- TDATD scheme added based on vijay mail 11-08-2017 --changed on 19-09-2017 based on spira no 8631- logic removed and only paid amount provided for tdatd--int paid amont provided on 25-09-2017 based on vijay discussion with sandeep and ravi
--when map_acc.schm_code='TDGTD' then (to_number(v5am1)+to_number(V5AIM)+to_number(nvl(clmamount,0)))/power(10,c8pf.c8ced) -- TDGTD added based on spira 7674 and vijay mail dt 13-08-2017
when clmamount is not null then (to_number(v5am1)+to_number(V5AIM)+to_number(nvl(clmamount,0)))/power(10,c8pf.c8ced) -- TDGTD removed based on discussion with vijay and sridhar on 09-09-2017
else (to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced) end ,
--NRML_BOOKED_AMOUNT_CR,
case when map_acc.schm_code='TDATD' then to_number(nvl(atd_clmamount,0))/power(10,c8pf.c8ced) --(to_number(v5am1)+to_number(V5AIM)+to_number(nvl(atd_clmamount,0)))/power(10,c8pf.c8ced) --- TDATD scheme added based on vijay mail 11-08-2017 --changed on 19-09-2017 based on spira no 8631- logic removed and 0 provided for tdatd--int paid amont provided on 25-09-2017 based on vijay discussion with sandeep and ravi
--when map_acc.schm_code='TDGTD' then (to_number(v5am1)+to_number(V5AIM)+to_number(nvl(clmamount,0)))/power(10,c8pf.c8ced) -- TDGTD added based on spira 7674 and vijay mail dt 13-08-2017
when clmamount is not null then (to_number(v5am1)+to_number(V5AIM)+to_number(nvl(clmamount,0)))/power(10,c8pf.c8ced) -- TDGTD removed based on discussion with vijay and sridhar on 09-09-2017
else (to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced) end,
--NRML_BOOKED_AMOUNT_DR,
0,
--NRML_ACCRUED_AMOUNT_DR
0 
from v5pf
inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
inner join c8pf on trim(c8ccy)=currency
left join ospf on v5brnm=osbrnm and v5dlp=osdlp and v5dlr=osdlr
left join (select * from otpf where OTTDT='D')otpf on  v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
left join (select * from tbaadm.gam where schm_type in('TDA')and bank_id=get_param('BANK_ID')) gam on gam.foracid=map_acc.fin_acc_num
left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) atd_clmamount  from v5pf
inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') >= case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
                                                   when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
and trim(v4dlp)='ATD' and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
group by v5brnm,v5dlp,v5dlr)atd_int_amt on atd_int_amt.v5brnm =v5pf.v5brnm and atd_int_amt.v5dlp=v5pf.v5dlp  and  atd_int_amt.v5dlr=v5pf.v5dlr
left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) clmamount  from v5pf
inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') > case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
                                                    when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
group by v5brnm,v5dlp,v5dlr)int_amt on int_amt.v5brnm =v5pf.v5brnm and int_amt.v5dlp=v5pf.v5dlp  and  int_amt.v5dlr=v5pf.v5dlr
where map_acc.SCHM_TYPE='TDA' and v5pf.v5tdt='D' and v5pf.v5bal<>'0' ;
commit;
--EIT FOR LAA,CLA--
insert into CUSTOM_EIT
select 
--ENTITY_ID,
gam.acid,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--ACCRUED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--BOOKED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--INTEREST_CALC_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--INTEREST_CALC_UPTO_DATE_DR,
case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
--LAST_INTEREST_RUN_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--LAST_INTEREST_RUN_DATE_DR,
case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
--XFER_MIN_BAL,
0,
--XFER_MIN_BAL_DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--NRML_ACCRUED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_DR,
case when map_acc.schm_code in ('BDT' ,'ATD') then 0 
when MAP_ACC.schm_code in ('AUT', 'GFX', 'NCL', 'NFX', 'RSL', 'SPR', 'VTP', 'YAB','ZAB') and ((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced))-  (to_number(nvl(sum_overdue,0))/power(10,c8pf.c8ced)) <= 0 then abs(((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced))-  (to_number(nvl(sum_overdue,0))/power(10,c8pf.c8ced)))-----based on vijay mail 17-06-2017 added  -- modified on 13-07-2017 based on edwin mail
else abs((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced)) end,
--NRML_ACCRUED_AMOUNT_DR
case when MAP_ACC.schm_code in ('AUT', 'GFX', 'NCL', 'NFX', 'RSL', 'SPR', 'VTP', 'YAB','ZAB') and ((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced))-  (to_number(nvl(sum_overdue,0))/power(10,c8pf.c8ced)) <= 0 then abs(((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced))-  (to_number(nvl(sum_overdue,0))/power(10,c8pf.c8ced)))-----based on vijay mail 17-06-2017 added  -- modified on 13-07-2017 based on edwin mail
else abs((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced)) end 
from v5pf
inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
inner join map_acc on trim(map_acc.LEG_ACC_NUM)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
inner join c8pf on trim(c8ccy)=currency
left join ospf on v5brnm=osbrnm and v5dlp=osdlp and v5dlr=osdlr
left join (select * from otpf where OTTDT='L')otpf on  v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
left join (select * from tbaadm.gam where schm_type in('CLA','LAA')and bank_id=get_param('BANK_ID')) gam on gam.foracid=map_acc.fin_acc_num
left join (select lsbrnm,lsdlp,lsdlr,sum((to_number((lsamtd - lsamtp)))) sum_overdue from lspf where LSMVT = 'I' and  (lsamtd -lsamtp) < 0  and LSAMTD <> 0 and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num---based on vijay mail 17-06-2017 added 
where map_acc.SCHM_TYPE in('CLA','LAA')  and v5pf.v5tdt='L' and v5pf.v5bal<>'0';
commit;
insert into CUSTOM_EIT
select 
--ENTITY_ID,
gam.acid,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--ACCRUED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--BOOKED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--INTEREST_CALC_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--INTEREST_CALC_UPTO_DATE_DR,
case when S5LCDD <>0 and get_date_fm_btrv(S5LCDD)<> 'ERROR' then to_date(get_date_fm_btrv(S5LCDD),'YYYYMMDD')-1 
when SCOAD <>0 and get_date_fm_btrv(SCOAD)<> 'ERROR' then to_date(get_date_fm_btrv(SCOAD),'YYYYMMDD')-1          
end,
--LAST_INTEREST_RUN_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--LAST_INTEREST_RUN_DATE_DR,
case when S5LCDD <>0 and get_date_fm_btrv(S5LCDD)<> 'ERROR' then to_date(get_date_fm_btrv(S5LCDD),'YYYYMMDD')-1 
when SCOAD <>0 and get_date_fm_btrv(SCOAD)<> 'ERROR' then to_date(get_date_fm_btrv(SCOAD),'YYYYMMDD')-1          
end,
--XFER_MIN_BAL,
0,
--XFER_MIN_BAL_DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--NRML_ACCRUED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_DR,
abs(to_number((s5am1d)/POWER(10,c8pf.C8CED))),
--NRML_ACCRUED_AMOUNT_DR
abs(to_number((s5am1d)/POWER(10,c8pf.C8CED)))
from map_acc 
inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas
inner join s5pf on s5pf.s5ab=map_acc.leg_branch_id and s5pf.s5an=map_acc.leg_scan and s5pf.s5as=map_acc.leg_scas
inner join c8pf on c8ccy = currency
left join (select * from tbaadm.gam where schm_type='CLA' and schm_code in ('LAC','CLM'))gam on gam.foracid=MAP_ACC.FIN_ACC_NUM
where map_acc.schm_type='CLA'  and map_acc.schm_code in ('LAC','CLM') and scbal <> 0;
commit;
----Corporate Loan Drawdown bloack added on 04-06-2017--
--insert into CUSTOM_EIT
--select 
----ENTITY_ID,
--gam.acid,
----FORACID, 
--a.fin_acc_num,
----SCHM_TYPE,
--a.schm_type,
----ACCRUED_UPTO_DATE_CR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
----ACCRUED_UPTO_DATE_DR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
----BOOKED_UPTO_DATE_CR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
----BOOKED_UPTO_DATE_DR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
----INTEREST_CALC_UPTO_DATE_CR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
----INTEREST_CALC_UPTO_DATE_DR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY') dedit_Int_Calculated_Upto,
----case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
----when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
----LAST_INTEREST_RUN_DATE_CR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
----LAST_INTEREST_RUN_DATE_DR,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY') dedit_Int_Calculated_Upto,
----case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
----when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
----XFER_MIN_BAL,
--0,
----XFER_MIN_BAL_DATE,
--to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
----NRML_ACCRUED_AMOUNT_CR,
--0,
----NRML_BOOKED_AMOUNT_CR,
--0,
----NRML_BOOKED_AMOUNT_DR,
--abs(to_number(accrual)/power(10,c8pf.c8ced)),
----NRML_ACCRUED_AMOUNT_DR
--abs(to_number(accrual)/power(10,c8pf.c8ced)) 
--from map_acc a
--inner join cla_ld_acct_details b on b.fin_acc_num=a.fin_acc_num
--inner join c8pf on trim(c8ccy)=currency
--left join cla_ld_accrual c on c.fin_acc_num=a.fin_acc_num
--left join (select * from tbaadm.gam where schm_type='CLA' --and schm_code='LD' commented on 14-06-2017 for CLA changes
--)gam on gam.foracid=a.FIN_ACC_NUM;
--commit; 
truncate table CUSTOM_EIT_PCA;
insert into CUSTOM_EIT_PCA
select 
--ENTITY_ID,
DISB_ID,
--FORACID, 
map_acc.fin_acc_num,
--SCHM_TYPE,
map_acc.schm_type,
--ACCRUED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--ACCRUED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--BOOKED_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--BOOKED_UPTO_DATE_DR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),
--INTEREST_CALC_UPTO_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--INTEREST_CALC_UPTO_DATE_DR,
case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
--LAST_INTEREST_RUN_DATE_CR,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--LAST_INTEREST_RUN_DATE_DR,
case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD')-1
when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1  end,
--XFER_MIN_BAL,
0,
--XFER_MIN_BAL_DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),---as per sandeep confirmation cut off date provided on 11-07-2017
--NRML_ACCRUED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_CR,
0,
--NRML_BOOKED_AMOUNT_DR,
abs((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced)),
--NRML_ACCRUED_AMOUNT_DR
abs((to_number(v5am1)+to_number(V5AIM))/power(10,c8pf.c8ced)),
--ADVANCE_INT
abs(v4aim1/power(10,c8pf.c8ced)),
--AMORT_AMT 
abs((to_number(v4aim1)-to_number(v5am1))/power(10,c8pf.c8ced)),
--OPER_ACID
gam.acid
from map_acc
  inner join v5pf on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas 
  left join v4pf on trim(v4brnm)||trim(v4dlp)||trim(v4dlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
  inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  inner join c8pf on c8ccy = otccy
  left join tbaadm.disb on disb.REMARKS=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  left join pca_operacc oper on OMPF_LEG_NUM =trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  left join tbaadm.gam on foracid=oper.fin_acc_num
  where map_acc.schm_type='PCA' and map_acc.schm_code='LDADV'
  and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '');
commit;  
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_exe_exp_date.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_exe_exp_date.sql 
-- File Name		: custom_past_due_date.sql 
-- File Created for	: Upload file for past due date 
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 11-09-2017
-------------------------------------------------------------------
drop table custom_excess_dt_casa_od;
create table custom_excess_dt_casa_od as
select distinct  FIN_ACC_NUM,SCHM_TYPE, to_char(to_date(pass_due_dt,'YYYYMMDD'),'DD-MM-YYYY') EXC_EXP_date
from map_Acc 
--inner join (select lp10_acct acc_num,'Y' past_due_flg, case when LP10_LED <> 0 then LP10_LED else LP10_LXD end pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0 and LP10_LED <> 0 union all
--select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt,to_char( to_number(LP10_LGR_K)-to_number(LP10_LMT_K)) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXCESS' and to_number(LP10_LMT_C)<> 0)past on fin_acc_num=trim(acc_num)
inner join (select acc_num,past_due_flg,suspence_amt,min(PASS_DUE_DT) PASS_DUE_DT from  (
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LBD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where to_number(LP10_LMT_C)=0 
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LXD pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt, to_char(LP10_LGR_K) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXPIRED' and to_number(LP10_LMT_C)<> 0 and LP10_LED <> 0
    union all
    select lp10_acct acc_num,'Y' past_due_flg, LP10_LED pass_due_dt,to_char( to_number(LP10_LGR_K)-to_number(LP10_LMT_K)) Suspence_amt from uzlp10pf where trim(LP10_RMK)='EXCESS' and to_number(LP10_LMT_C)<> 0)
    group by acc_num,past_due_flg,suspence_amt)past on fin_acc_num=trim(acc_num)
where schm_type <> 'OOO' ;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_freetext_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_freetext_upload.sql 
--drop table cla_free_text;
--create table cla_free_text as select * from (
--select distinct fin_acc_num,lccmr,lcnr text1,lcnr1||' '||lcnr2 text2,lcnr3||' '||lcnr4 text3,DENSE_RANK() OVER(PARTITION BY fin_acc_num ORDER BY lccmr)  serial_details from map_acc c
--inner join ld_deal_int_wise a on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and c.leg_acc_num=to_char(serial_deal)
--inner join ldpf on ldbrnm||trim(lddlp)||trim(lddlr)=a.leg_acc_num
--inner join lcpf on lccmr=ldcmr);
--
--
--TRUNCATE TABLE FREETEXT_O_TABLE;
--
--INSERT INTO FREETEXT_O_TABLE
-- SELECT DISTINCT
--       RPAD (NVL (a.FIN_ACC_NUM, ' '), 16, ' ') ACID,
--       RPAD (NVL(a.text1,' '), 80, ' ') FREE_TEXT_1,
--       RPAD (NVL(a.text2,' '), 80, ' ') FREE_TEXT_2,
--       RPAD (NVL(a.text3,' '), 80, ' ') FREE_TEXT_3,
--       RPAD (case when b.SERIAL_DETAILS is not null  then to_char(NVL(b.text1,' ')) else ' ' end, 80, ' ') FREE_TEXT_4,
--       RPAD (case when b.SERIAL_DETAILS is not null  then to_char(NVL(b.text2,' ')) else ' ' end, 80, ' ') FREE_TEXT_5,
--       RPAD (case when b.SERIAL_DETAILS is not null  then to_char(NVL(b.text3,' ')) else ' ' end, 80, ' ') FREE_TEXT_6,
--       RPAD (case when c.SERIAL_DETAILS is not null  then to_char(NVL(c.text1,' ')) else ' ' end, 80, ' ') FREE_TEXT_7,
--       RPAD (case when c.SERIAL_DETAILS is not null  then to_char(NVL(c.text2,' ')) else ' ' end, 80, ' ') FREE_TEXT_8,
--       RPAD (case when c.SERIAL_DETAILS is not null  then to_char(NVL(c.text3,' ')) else ' ' end, 80, ' ') FREE_TEXT_9,
--       RPAD (case when d.SERIAL_DETAILS is not null  then to_char(NVL(d.text1,' ')) else ' ' end, 80, ' ') FREE_TEXT_10,
--       RPAD (case when d.SERIAL_DETAILS is not null  then to_char(NVL(d.text2,' ')) else ' ' end, 80, ' ') FREE_TEXT_11,
--       RPAD (case when d.SERIAL_DETAILS is not null  then to_char(NVL(d.text3,' ')) else ' ' end, 80, ' ') FREE_TEXT_12,
--       RPAD (case when e.SERIAL_DETAILS is not null  then to_char(NVL(e.text1,' ')) else ' ' end, 80, ' ') FREE_TEXT_13,
--       RPAD (case when e.SERIAL_DETAILS is not null  then to_char(NVL(e.text2,' ')) else ' ' end, 80, ' ') FREE_TEXT_14,
--       RPAD (case when last_6_digit is not null then to_char('.'||last_6_digit) else ' ' end, 80, ' ') FREE_TEXT_15
-- from cla_free_text a
--  left join cla_free_text b on a.fin_acc_num=b.fin_acc_num and b.SERIAL_DETAILS=2
--  left join cla_free_text c on a.fin_acc_num=c.fin_acc_num and c.SERIAL_DETAILS=3
--  left join cla_free_text d on a.fin_acc_num=d.fin_acc_num and d.SERIAL_DETAILS=4
--  left join cla_free_text e on a.fin_acc_num=d.fin_acc_num and e.SERIAL_DETAILS=5
--  left join (select distinct fin_acc_num,last_6_digit from (
--select  distinct a.fin_acc_num,leg_branch_id||leg_scan||leg_scas leg_acc_num,
--  lccmr commitment_ref_no,text1,text2,text3,substr(trim(text3),length(trim(text3))-5,6) last_6_digit from cla_free_text a 
--  inner join map_Acc b on a.fin_acc_num=b.fin_acc_num and SCHM_TYPE <> 'OOO'
--  left join ld_deal_int_wise c on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and to_char(serial_deal)=b.leg_acc_num 
--  left join ldpf on ldcmr=lccmr
--  where isnumber(substr(trim(text3),length(trim(text3))-5,6))=1 and substr(trim(text3),length(trim(text3))-5,6) is not null)
--  where last_6_digit not like '%.%') roll_over_fees on  roll_over_fees.fin_acc_num=a.fin_acc_num
--  where a.SERIAL_DETAILS=1;
-- 
--COMMIT;
drop table indemnity_date;
create table indemnity_date as
select FIN_ACC_NUM fin_num,TO_CHAR (START_DATE, 'DD-MM-YYYY') START_DATE,TO_CHAR (END_DATE, 'DD-MM-YYYY')  END_DATE
FROM BEAM_MEMOPAD
     INNER JOIN MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=TRIM(CUST_ACCT) and SCHM_TYPE <> 'OOO'
     left join (select distinct fin_cif_id,BGCSNO from MAP_CIF 
				inner JOIN BGPF  ON NVL(MAP_CIF.GFCLC,' ')=NVL(BGPF.BGCLC,' ') AND trim(MAP_CIF.GFCUS)=trim(BGPF.BGCUS)
				where  to_number(BGCSNO) <> 0)map_cif ON MAP_CIF.FIN_CIF_ID = MAP_ACC.FIN_CIF_ID
  WHERE (FIN_ACC_NUM,CREATE_DATE) IN( SELECT  FIN_ACC_NUM,MAX(CREATE_DATE)  CREATE_DATE FROM (
                                       SELECT DISTINCT FIN_ACC_NUM,CREATE_DATE FROM BEAM_MEMOPAD
                                                INNER JOIN MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=TRIM(CUST_ACCT)
                                        WHERE UPPER(NOTE) LIKE '%FAX%' and SCHM_TYPE!='OOO'
                                       ) GROUP BY FIN_ACC_NUM
                                    )
    AND  UPPER(NOTE) LIKE '%FAX%' and  SCHM_TYPE not in ('OOO');
 
 
TRUNCATE TABLE FREETEXT_O_TABLE;

INSERT INTO FREETEXT_O_TABLE
 SELECT DISTINCT
       RPAD (NVL (a.FIN_ACC_NUM, ' '), 16, ' ') ACID,
       RPAD (NVL(lcnr,' '), 80, ' ') FREE_TEXT_1,
       RPAD (NVL(lcnr1||' '||lcnr2,' '), 80, ' ') FREE_TEXT_2,
       RPAD (NVL(lcnr3||' '||lcnr4,' '), 80, ' ') FREE_TEXT_3,
       RPAD (NVL (START_DATE,' '), 80, ' ') FREE_TEXT_4,
       RPAD (NVL (END_DATE,' '), 80, ' ') FREE_TEXT_5,
       RPAD (' ', 80, ' ') FREE_TEXT_6,
       RPAD (' ', 80, ' ') FREE_TEXT_7,
       RPAD (' ', 80, ' ') FREE_TEXT_8,
       RPAD (' ', 80, ' ') FREE_TEXT_9,
       RPAD (' ', 80, ' ') FREE_TEXT_10,
       RPAD (' ', 80, ' ') FREE_TEXT_11,
       RPAD (' ', 80, ' ') FREE_TEXT_12,
       RPAD (' ', 80, ' ') FREE_TEXT_13,
       RPAD (' ', 80, ' ') FREE_TEXT_14,
       RPAD (case when schm_code='LFR' and trim(ossrc)='A'  and isnumber(substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6))=1 and substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6) is not null and (substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6)) not like '%.%' then to_char('.'||substr(trim(lcnr3||' '||lcnr4),length(trim(lcnr3||' '||lcnr4))-5,6)) 
       when schm_code='LFR' and trim(ossrc)='A' then '.250000'
       else ' ' end, 80, ' ') FREE_TEXT_15
from map_acc a
inner join ospf on osbrnm||trim(osdlp)||trim(osdlr)=leg_acc_num
inner join ldpf on ldbrnm||trim(lddlp)||trim(lddlr)=leg_acc_num
inner join lcpf on trim(lccmr)=trim(ldcmr)
left join indemnity_date on fin_num=a.fin_acc_num
where schm_type='CLA';
COMMIT;

INSERT INTO FREETEXT_O_TABLE
SELECT DISTINCT
       RPAD (NVL (FIN_ACC_NUM, ' '), 16, ' ') ACID,
       --RPAD (NVL(TRIM(BGCSNO),' '), 80, ' ') FREE_TEXT_1,---this is commented because EJ joint cif exculsion stopped
	   RPAD (' ', 80, ' ') FREE_TEXT_1,
       RPAD (' ', 80, ' ') FREE_TEXT_2,
	   RPAD (' ', 80, ' ') FREE_TEXT_3,
       RPAD (NVL (TO_CHAR (START_DATE, 'DD-MM-YYYY'), ' '), 80, ' ') FREE_TEXT_4,
       RPAD (NVL (TO_CHAR (END_DATE, 'DD-MM-YYYY'), ' '), 80, ' ') FREE_TEXT_5,
       RPAD (' ', 80, ' ') FREE_TEXT_6,
       RPAD (' ', 80, ' ') FREE_TEXT_7,
       RPAD (' ', 80, ' ') FREE_TEXT_8,
       RPAD (' ', 80, ' ') FREE_TEXT_9,
       RPAD (' ', 80, ' ') FREE_TEXT_10,
       RPAD (' ', 80, ' ') FREE_TEXT_11,
       RPAD (' ', 80, ' ') FREE_TEXT_12,
       RPAD (' ', 80, ' ') FREE_TEXT_13,
       RPAD (' ', 80, ' ') FREE_TEXT_14,
       RPAD (' ', 80, ' ') FREE_TEXT_15
  FROM BEAM_MEMOPAD
     INNER JOIN MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=TRIM(CUST_ACCT) and SCHM_TYPE <> 'OOO'
     left join (select distinct fin_cif_id,BGCSNO from MAP_CIF 
				inner JOIN BGPF  ON NVL(MAP_CIF.GFCLC,' ')=NVL(BGPF.BGCLC,' ') AND trim(MAP_CIF.GFCUS)=trim(BGPF.BGCUS)
				where  to_number(BGCSNO) <> 0)map_cif ON MAP_CIF.FIN_CIF_ID = MAP_ACC.FIN_CIF_ID
  WHERE (FIN_ACC_NUM,CREATE_DATE) IN( SELECT  FIN_ACC_NUM,MAX(CREATE_DATE)  CREATE_DATE FROM (
                                       SELECT DISTINCT FIN_ACC_NUM,CREATE_DATE FROM BEAM_MEMOPAD
                                                INNER JOIN MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=TRIM(CUST_ACCT)
                                        WHERE UPPER(NOTE) LIKE '%FAX%' and SCHM_TYPE!='OOO'
                                       ) GROUP BY FIN_ACC_NUM
                                    )
    AND  UPPER(NOTE) LIKE '%FAX%' and  SCHM_TYPE not in ('OOO') and FIN_ACC_NUM NOT IN(SELECT TRIM(ACID) FROM FREETEXT_O_TABLE );
    
 COMMIT;
 
  DELETE FROM FREETEXT_O_TABLE WHERE ACID IN(
 SELECT ACID FROM FREETEXT_O_TABLE GROUP BY ACID HAVING COUNT(*)>1
 ) AND TRIM(FREE_TEXT_4) IS NULL;
 
 COMMIT;
 
-- INSERT INTO FREETEXT_O_TABLE
-- SELECT DISTINCT
--       RPAD (NVL (FIN_ACC_NUM, ' '), 16, ' ') ACID,
--       --RPAD (NVL(TRIM(BGCSNO),' '), 80, ' ') FREE_TEXT_1,---this is commented because EJ joint cif exculsion stopped
--	   RPAD (' ', 80, ' ') FREE_TEXT_1,
--       RPAD (' ', 80, ' ') FREE_TEXT_2,
--       RPAD (' ', 80, ' ') FREE_TEXT_3,
--       RPAD (' ', 80, ' ') FREE_TEXT_4,
--       RPAD (' ', 80, ' ') FREE_TEXT_5,
--       RPAD (' ', 80, ' ') FREE_TEXT_6,
--       RPAD (' ', 80, ' ') FREE_TEXT_7,
--       RPAD (' ', 80, ' ') FREE_TEXT_8,
--       RPAD (' ', 80, ' ') FREE_TEXT_9,
--       RPAD (' ', 80, ' ') FREE_TEXT_10,
--       RPAD (' ', 80, ' ') FREE_TEXT_11,
--       RPAD (' ', 80, ' ') FREE_TEXT_12,
--       RPAD (' ', 80, ' ') FREE_TEXT_13,
--       RPAD (' ', 80, ' ') FREE_TEXT_14,
--       RPAD (' ', 80, ' ') FREE_TEXT_15
--  FROM MAP_ACC
--  inner join (select distinct fin_cif_id,BGCSNO from MAP_CIF 
--  inner JOIN BGPF  ON NVL(MAP_CIF.GFCLC,' ')=NVL(BGPF.BGCLC,' ') AND trim(MAP_CIF.GFCUS)=trim(BGPF.BGCUS)
--     where  IS_JOINT='Y' and  to_number(BGCSNO) <> 0)map_cif ON MAP_CIF.FIN_CIF_ID = MAP_ACC.FIN_CIF_ID
--  WHERE FIN_ACC_NUM NOT IN(SELECT TRIM(ACID) FROM FREETEXT_O_TABLE )  and  SCHM_TYPE not in ('OOO') and FIN_ACC_NUM NOT IN(SELECT TRIM(ACID) FROM FREETEXT_O_TABLE );
--  COMMIT;
  
 
 EXIT; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Custom_Group_code_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Custom_Group_code_kw.sql 

-- File Name        : custom_group_code.sql
-- File Created for    : Upload file for Group House Hold
-- Created By        : Sharanappa
-- Client            : ABK
-- Created On        : 10-01-2017
-------------------------------------------------------------------

DROP TABLE HPPF_BANK_GRP;
DROP TABLE HHPF_BANK_GRP;

CREATE TABLE HPPF_BANK_GRP AS 
SELECT DISTINCT NVL(UPDATED_RISK_COUNTRY_CODE,GFCNAR) HPCNA, HPGRP, GFCUS HPCUS, GFCLC HPCLC, HPLSTR, HPCCY, HPLED, HPYMDT, HPBRNM, HPLEDE, HPDLM, HPYRIT, HPYLCH, HPCF1, HPCF2, HPCF3, HPAUD FROM HPPF
INNER JOIN GFPF ON TRIM(HPGRP) = TRIM(GFGRP)
LEFT JOIN BANK_GRP_RISK_CNTRY ON TRIM(GROUP_NAME) = TRIM(HPGRP) ;

CREATE TABLE HHPF_BANK_GRP AS 
SELECT  DISTINCT NVL(UPDATED_RISK_COUNTRY_CODE,GFCNAR) HHCNA, HHGRP, GFCUS HHCUS, GFCLC HHCLC, HHLC, HHCCY, HHLED, HHAMA, HHLTST, HHYELG, HHYLCH, HHAAM, HHRAM FROM HHPF
INNER JOIN GFPF ON TRIM(HHGRP) = TRIM(GFGRP)
LEFT JOIN BANK_GRP_RISK_CNTRY ON TRIM(GROUP_NAME) = TRIM(HHGRP) ;

declare
 SEQ_START number;
begin
  SELECT (max(to_number(substr(CUST_ID,4)))+1) INTO SEQ_START  from tbaadm.llt where bank_id='02' and LIMIT_TYPE='G';
  If SEQ_START > 0 then
    begin
            execute immediate 'DROP SEQUENCE SEQ_CIF_GROUPS';
      exception when others then
        null;
    end;
    execute immediate 'CREATE SEQUENCE SEQ_CIF_GROUPS INCREMENT BY 1 START WITH ' || SEQ_START || ' NOCYCLE CACHE 20 NOORDER';
  end if;
end;

update CIF_GROUPS_DATA a set GROUP_REPORTING_ID = (select GROUP_REPORTING_ID from(
select CBK_CODE, ACCOUNT_NO, CIF_CREATED_DATE, CUSTOMER_NAME, ID_CODE, ENTITY_NAME, ENTITY_REPORTING_ID, ENTITY_ID, ENTITY_TYPE, GROUP_NAME, lpad(dense_rank() over  ( order by GROUP_NAME ),10,'0') GROUP_REPORTING_ID, GROUP_ID, GROUP_TYPE from CIF_GROUPS_DATA where (GROUP_NAME) is not null
) b where  a.ACCOUNT_NO = b.ACCOUNT_NO and a.GROUP_NAME = b.GROUP_NAME
);
commit;

UPDATE CIF_GROUPS_DATA SET ENTITY_NAME=TRIM(ENTITY_NAME),GROUP_NAME=TRIM(GROUP_NAME),ENTITY_TYPE =TRIM(ENTITY_TYPE),GROUP_TYPE=TRIM(GROUP_TYPE);
COMMIT;

truncate table GROUP_MASTER_O_TABLE;


INSERT INTO GROUP_MASTER_O_TABLE
select 'GRP'||SEQ_CIF_GROUPS.nextval,a.* from (
 SELECT distinct trim(ENTITY_NAME), value ,trim(ENTITY_REPORTING_ID)  FROM CIF_GROUPS_DATA
left join (select value,LOCALETEXT from CRMUSER.CATEGORIES a,CRMUSER.CATEGORY_LANG b where CATEGORYTYPE ='CIFGROUP_TYPE' and a.categoryid=b.categoryid and a.bank_id='01') b on upper(trim(ENTITY_TYPE)) = trim(LOCALETEXT)
where  trim(ENTITY_NAME) is not null
) a;

commit;

INSERT INTO GROUP_MASTER_O_TABLE
select 'GRP'||SEQ_CIF_GROUPS.nextval,a.* from (
 SELECT distinct trim(GROUP_NAME), value ,trim(GROUP_REPORTING_ID)  FROM CIF_GROUPS_DATA
left join (select value,LOCALETEXT from CRMUSER.CATEGORIES a,CRMUSER.CATEGORY_LANG b where CATEGORYTYPE ='CIFGROUP_TYPE' and a.categoryid=b.categoryid and a.bank_id='01') b on upper(trim(GROUP_TYPE)) = trim(LOCALETEXT)
where  trim(GROUP_NAME) is not null
) a;

commit;

INSERT INTO GROUP_MASTER_O_TABLE
SELECT 'GRP'||SEQ_CIF_GROUPS.nextval,A.* FROM(
select min(GROUP_NAME) GROUP_NAME,GROUP_TYPE,REPORTING_GROUP_ID from (
select  to_char(DESCR) GROUP_NAME,case when GRPTYPE='C' then '001' when GRPTYPE='P' then '005' end GROUP_TYPE , to_char(GRPID) REPORTING_GROUP_ID  from crgh
union
SELECT DISTINCT to_char(TAGRD),'001',to_char(TRIM(HHGRP)) FROM HHPF_BANK_GRP HH
       INNER JOIN HPPF_BANK_GRP HP
          ON TRIM(HHGRP) = TRIM(HPGRP) AND TRIM(HPLSTR)='BANKL'
          LEFT JOIN TAPF ON TRIM(HHGRP) = TRIM(TAGRP)
) group by  GROUP_TYPE,REPORTING_GROUP_ID
) A;

COMMIT;

--INSERT INTO GROUP_MASTER_O_TABLE
--select  GRPID ,DESCR GROUP_NAME,case when GRPTYPE='C' then '002' when GRPTYPE='P' then '001' end GROUP_TYPE , GRPID REPORTING_GROUP_ID  from crgh;

--INSERT INTO GROUP_MASTER_O_TABLE
--SELECT 'GRP'||SEQ_CIF_GROUPS.nextval,A.* FROM (
--SELECT DISTINCT TAGRD,'001',TRIM(HHGRP) FROM HHPF_BANK_GRP HH
       --INNER JOIN HPPF_BANK_GRP HP
          --ON TRIM(HHGRP) = TRIM(HPGRP) AND TRIM(HPLSTR)='BANKL'
          --LEFT JOIN TAPF ON TRIM(HHGRP) = TRIM(TAGRP)
--) A;

COMMIT;

update GROUP_MASTER_O_TABLE set GROUP_TYPE='002' where trim(GROUP_TYPE) is null;

commit;

update CIF_GROUPS_DATA set ENTITY_ID='',GROUP_ID='';
commit;

UPDATE CIF_GROUPS_DATA A SET ENTITY_ID = (SELECT CASE WHEN MIN(B.GROUP_ID) LIKE 'GRP%' THEN 'GRP'||min(TO_NUMBER(SUBSTR(B.GROUP_ID,4))) ELSE MAX(B.GROUP_ID)  END
  FROM GROUP_MASTER_O_TABLE B WHERE TRIM(A.ENTITY_NAME) = TRIM(B.GROUP_NAME)  GROUP BY B.GROUP_NAME );
  
UPDATE CIF_GROUPS_DATA A SET GROUP_ID = (SELECT CASE WHEN max(B.GROUP_ID) LIKE 'GRP%' THEN 'GRP'||max(TO_NUMBER(SUBSTR(B.GROUP_ID,4))) ELSE MIN(B.GROUP_ID)  END 
FROM GROUP_MASTER_O_TABLE B WHERE TRIM(A.GROUP_NAME) = TRIM(B.GROUP_NAME) GROUP BY B.GROUP_NAME );

COMMIT;



drop table custom_group_code;
create table custom_group_code as 
SELECT GROUP_ID,
       GROUP_NAME,
       REPORTING_GROUP_ID GROUP_DESC,
       GROUP_TYPE,
       ' ' PRIMARY_SOL_ID,
       ' ' RM_ID
  FROM GROUP_MASTER_O_TABLE;
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_hold_Statement_ae.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_hold_Statement_ae.sql 
drop table Hold_statement;
create table Hold_statement as
select distinct Fin_acc_num,schm_type,'Y' Hold_statment from  scpf 
inner join map_acc on leg_branch_id||leg_Scan||leg_Scas=scab||Scan||Scas
where scai64='Y' and schm_type in ('SBA','CAA','ODA');
commit;
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_htd_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_htd_upload.sql 
-- File Name                       : custom_htd_upload.sql
-- File Created for            	   : History Transaction file
-- Created By                      : Alavudeen Ali Badusha.R
-- Client                          : ABK
-- Created On                      : 15-01-2017
-------------------------------------------------------------------
truncate table  custom_htd_o_table;
insert into custom_htd_o_table 
select 
--    FORACID                 NVARCHAR2(16),
fin_acc_num,
--    TRAN_DATE               NVARCHAR2(10),
TRANSACTION_DATE,
--    VALUE_DATE              NVARCHAR2(10),
TRANSACTION_VALUEDATE,
--    DR_CR_INDICATION        NVARCHAR2(1),
case when to_number(TRANSACTION_AMOUNT) < 0 then 'D' else 'C' end,
--    TRAN_AMT                NVARCHAR2(20),
to_number(abs(TRANSACTION_AMOUNT)),
--    CRNCY_CODE              NVARCHAR2(3),
currency,
--    TRAN_PARTICULAR         NVARCHAR2(35),
substr(regexp_replace(trim(DESCRIPTION1)||' '||trim(DESCRIPTION2)||' '||trim(DESCRIPTION3)||' '||trim(DESCRIPTION4)||' '||trim(DESCRIPTION5),'[�,`,!,]',''),1,35),
--    TRAN_PARTICULAR_1       NVARCHAR2(35),
substr(regexp_replace(trim(DESCRIPTION1)||' '||trim(DESCRIPTION2)||' '||trim(DESCRIPTION3)||' '||trim(DESCRIPTION4)||' '||trim(DESCRIPTION5),'[�,`,!,]',''),36,35),
--    TRAN_RMKS               NVARCHAR2(35),
substr(regexp_replace(trim(DESCRIPTION1)||' '||trim(DESCRIPTION2)||' '||trim(DESCRIPTION3)||' '||trim(DESCRIPTION4)||' '||trim(DESCRIPTION5),'[�,`,!,]',''),71,35),
--    TRAN_RMKS_4             NVARCHAR2(35),
substr(regexp_replace(trim(DESCRIPTION1)||' '||trim(DESCRIPTION2)||' '||trim(DESCRIPTION3)||' '||trim(DESCRIPTION4)||' '||trim(DESCRIPTION5),'[�,`,!,]',''),106,35),
--    TRANCODE_DESC           NVARCHAR2(50),
trim(TRANSACTION_DESCRIPTION),
--    TRAN_CODE               NVARCHAR2(5),
'T',
--    TRAN_REF_NUM            NVARCHAR2(20),
'BI',
--    INITIATING_SOL_ID       NVARCHAR2(5),
FIN_SOL_ID,
--    RUNNING_BALANCE         NVARCHAR2(20),
to_number(RUNNING_BALANCE),
--    TRAN_TIME               NVARCHAR2(10),
TRANSACTION_DATE,
--    POSTING_USERID          NVARCHAR2(15),
trim(TRANSACTION_UID),
--    POSTING_SEQNO           NVARCHAR2(10),
trim(TRANSACTION_NUMBER),
--    GL_SUB_HEAD_CODE        NVARCHAR2(10),
GL_SUB_HEADCODE,
--    INSTR_NUM               NVARCHAR2(16),
'',
--    BANK_ID                 NVARCHAR2(8)
get_param('BANK_ID')
--from  all_final_trial_balance
from map_acc 
inner join archival_transaction on trim(acc_number)=leg_branch_id||leg_scan||leg_scas
--inner join archival_transaction on acc_number=scab||scan||scas
--where scheme_type in ('SBA','CAA','ODA','PCA') --office account extraction removed based on sebastian,santhosh,sandeep and naggi confirmation on 24-01-2017. Because ytd and mtd report generation purpose not solved. due to scbal and suma balance details.
where schm_type in ('SBA','CAA','ODA','PCA') ---as per naggi and sandeep cofirmation office account also exttracted on 23-01-2017
and transaction_date >= to_date('01-01-2017','DD-MM-YYYY')
and transaction_date <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY');
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_interest_flag_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_interest_flag_upload.sql 
-- File Name		: custom_interest_flag_upload.sql 
-- File Created for	: Upload file for intereag flag set to 'N' for 'ZERO' tiercode accounts
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 20-04-2016
-------------------------------------------------------------------
drop table interest_flag;
create table interest_flag as 
select fin_acc_num,case when trim(s5trcd) ='ZERO' then 'N' else null end int_coll_flg,case when trim(s5trcc) ='ZERO' then 'N' else null end int_pay_flg from acct_interest_tbl 
inner join map_acc on leg_branch_id||leg_scan||leg_scas = s5ab||s5an||s5as
where (s5trcd ='ZERO' or s5trcc='ZERO') and map_acc.schm_type in ('SBA','CAA','ODA');
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_laa_repricing_date.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_laa_repricing_date.sql 
-- File Name		: custom_laa_repricing_date.sql 
-- File Created for	: Upload file for repricing date upload
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 10-09-2017
-------------------------------------------------------------------
truncate table int_tbl_code;
insert into int_tbl_code
select 
--entity_id = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,0,16)))
rpad(foracid,16,' '),
--entity_type = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,16,5)))
rpad(ENTITY_TYPE,5,' '),
--start_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,21,10)))
rpad(to_char(REPRICING_DATE,'DD-MM-YYYY'),10,' '),
--end_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,31,10)))
rpad(to_char(itc.END_DATE,'DD-MM-YYYY'),10,' '),
--int_tbl_code = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,41,5)))
rpad(itc.INT_TBL_CODE,5,' '),
--cust_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,46,10)))
rpad(CUST_CR_PREF_PCNT,10,' '),
--cust_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,56,10)))
rpad(CUST_DR_PREF_PCNT,10,' '),
--id_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,66,10)))
rpad(ACCT_ID_CREDIT_PREF_PERCENT,10,' '),
--id_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,76,10)))
rpad(ACCT_ID_DEBIT_PREF_PERCENT,10,' '),
--pegged_flg = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,86,1)))
rpad(PEGGED_FLG,1,' '),
--peg_frequency_in_months = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,87,4)))
rpad(PEGGING_FREQUENCY_IN_MONTHS,4,' '),
--peg_frequency_in_days = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,91,3)))
rpad(PEGGING_FREQUENCY_IN_DAYS,3,' '),
--min_int_pcnt_cr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,94,10)))
rpad(MIN_INT_PCNT_CR,10,' '),
--min_int_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,104,10)))
rpad(MIN_INT_PCNT_DR,10,' '),
--max_int_pcnt_cr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,114,10)))
rpad(MAX_INT_PCNT_CR,10,' '),
--max_int_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,124,10)))
rpad(MAX_INT_PCNT_DR,10,' '),
--ac_level_nrml_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,134,10)))
rpad(AC_LEVEL_NRML_PCNT_DR,10,' '),
--ac_level_spread = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,144,10)))
rpad(AC_LEVEL_SPREAD,10,' '),
--ac_level_comp_int_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,154,10)))
rpad(AC_LEVEL_COMP_INT_PCNT,10,' '),
--ac_level_comp_prnc_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,164,10)))
rpad(AC_LEVEL_COMP_PRNC_PCNT,10,' '),
--ac_level_pen_int_pcnt_for_int = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,174,10)))
rpad(AC_LEVEL_PEN_INT_PCNT_FOR_INT,10,' '),
--ac_level_pen_int_pcnt_for_prnc = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,184,10)
rpad(AC_LEVEL_PEN_INT_PCNT_FOR_PRNC,10,' '),
--ac_level_penal_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,194,10)))
rpad(AC_LEVEL_PENAL_PCNT_DR,10,' '),
--reason_code = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,204,5)))
rpad(nvl(trim(REASON_CODE),' '),5,' '),
--compound_prnc_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,209,10)))
rpad(COMPOUND_PRNC_PCNT,10,' '),
--compound_int_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,219,10)))
rpad(COMPOUND_INT_PCNT,10,' '),
--penalty_int_pcnt_for_prnc = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,229,10)))
rpad(PENALTY_INT_PCNT_FOR_PRNC,10,' '),
--penalty_int_pcnt_for_int = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,239,10)))
rpad(PENALTY_INT_PCNT_FOR_INT,10,' '),
--chnl_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,249,10)))
rpad(CHNL_DR_PREF_PCNT,10,' '),
--chnl_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,259,10)))
rpad(CHNL_CR_PREF_PCNT,10,' '),
--negotiated_rate_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,269,10)))
rpad(NEGOTIATED_RATE_DR,10,' '),
--int_version = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,279,5)))
rpad(nvl(trim(INT_VERSION),' '),5,' '),
--int_rate_prd_in_months = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,284,4)))
rpad(nvl(INT_RATE_PRD_IN_MONTHS,0),4,' '),
--int_rate_prd_in_days = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,288,3)))
rpad(nvl(INT_RATE_PRD_IN_DAYS,0),3,' '),
--peg_review_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,291,10)))
rpad(to_char(PEG_REVIEW_DATE,'DD-MM-YYYY'),10,' '),
--review_reqd_on_start_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,301,1)))
rpad(nvl(REVIEW_REQD_ON_START_DATE,' '),1,' '),
--interpolation_method = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,302,1)))
rpad(nvl(itc.INTERPOLATION_METHOD,' '),1,' ')
from tbaadm.gam
inner join tbaadm.itc on gam.acid=itc.entity_id
inner join lam_o_table on trim(account_number)=foracid
inner join map_Acc on fin_acc_num=foracid
inner join int_tbl on INT_ACC_NUM =leg_acc_num
where REPRICING_DATE is not null;
commit;
--drop table v2pf_rate;
--create table v2pf_rate as
--select v5pf_acc_num,v2dte,v2rat,Lead(v2dte, 1) OVER (partition by v5pf_acc_num ORDER BY v5pf_acc_num) v2dte_end from v2pf
--inner join (select v5brnm||trim(v5dlp)||trim(v5dlr) v5pf_acc_num,case when V5LRE<>'0' then to_char(V5LRE)  else to_char(otsdte) end opn_dt from v5pf
--inner join otpf  on otbrnm=v5brnm and trim(otdlp)=trim(v5dlp) and trim(otdlr)=trim(v5dlr) where v5tdt='D')v5pf on v5pf_acc_num=v2brnm||trim(v2dlp)||trim(v2dlr) 
--where to_char(v2dte) >=opn_dt order by v5pf_acc_num,v2dte; 
--insert into int_tbl_code
--select 
----entity_id = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,0,16)))
--rpad(foracid,16,' '),
----entity_type = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,16,5)))
--rpad(ENTITY_TYPE,5,' '),
----start_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,21,10)))
--rpad(to_char(to_date(get_date_fm_btrv(v2dte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----end_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,31,10)))
--rpad(case when v2dte_end is not null then to_char(to_date(get_date_fm_btrv(v2dte_end),'YYYYMMDD'),'DD-MM-YYYY')  else to_char(itc.END_DATE,'DD-MM-YYYY') end,10,' '),
----int_tbl_code = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,41,5)))
--rpad(itc.INT_TBL_CODE,5,' '),
----cust_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,46,10)))
--rpad(CUSTOMER_CREDIT_PREF_PERCENT,10,' '),
----cust_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,56,10)))
--rpad(CUSTOMER_DEBIT_PREF_PERCENT,10,' '),
----id_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,66,10)))
--rpad(v2rat,10,' '),
----id_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,76,10)))
--rpad(ACCOUNT_DEBIT_PREF_PERCENT,10,' '),
----pegged_flg = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,86,1)))
--rpad('N',1,' '),
----peg_frequency_in_months = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,87,4)))
--rpad('0',4,' '),
----peg_frequency_in_days = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,91,3)))
--rpad('0',3,' '),
----min_int_pcnt_cr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,94,10)))
--rpad(MIN_INT_PCNT_CR,10,' '),
----min_int_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,104,10)))
--rpad(MIN_INT_PCNT_DR,10,' '),
----max_int_pcnt_cr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,114,10)))
--rpad(MAX_INT_PCNT_CR,10,' '),
----max_int_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,124,10)))
--rpad(MAX_INT_PCNT_DR,10,' '),
----ac_level_nrml_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,134,10)))
--rpad(AC_LEVEL_NRML_PCNT_DR,10,' '),
----ac_level_spread = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,144,10)))
--rpad(AC_LEVEL_SPREAD,10,' '),
----ac_level_comp_int_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,154,10)))
--rpad(AC_LEVEL_COMP_INT_PCNT,10,' '),
----ac_level_comp_prnc_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,164,10)))
--rpad(AC_LEVEL_COMP_PRNC_PCNT,10,' '),
----ac_level_pen_int_pcnt_for_int = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,174,10)))
--rpad(AC_LEVEL_PEN_INT_PCNT_FOR_INT,10,' '),
----ac_level_pen_int_pcnt_for_prnc = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,184,10)
--rpad(AC_LEVEL_PEN_INT_PCNT_FOR_PRNC,10,' '),
----ac_level_penal_pcnt_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,194,10)))
--rpad(AC_LEVEL_PENAL_PCNT_DR,10,' '),
----reason_code = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,204,5)))
--rpad(nvl(trim(REASON_CODE),' '),5,' '),
----compound_prnc_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,209,10)))
--rpad(COMPOUND_PRNC_PCNT,10,' '),
----compound_int_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,219,10)))
--rpad(COMPOUND_INT_PCNT,10,' '),
----penalty_int_pcnt_for_prnc = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,229,10)))
--rpad(PENALTY_INT_PCNT_FOR_PRNC,10,' '),
----penalty_int_pcnt_for_int = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,239,10)))
--rpad(PENALTY_INT_PCNT_FOR_INT,10,' '),
----chnl_dr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,249,10)))
--rpad(CHNL_DR_PREF_PCNT,10,' '),
----chnl_cr_pref_pcnt = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,259,10)))
--rpad(CHNL_CR_PREF_PCNT,10,' '),
----negotiated_rate_dr = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,269,10)))
--rpad(NEGOTIATED_RATE_DR,10,' '),
----int_version = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,279,5)))
--rpad(nvl(trim(INT_VERSION),' '),5,' '),
----int_rate_prd_in_months = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,284,4)))
--rpad(nvl(INT_RATE_PRD_IN_MONTHS,0),4,' '),
----int_rate_prd_in_days = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,288,3)))
--rpad(nvl(INT_RATE_PRD_IN_DAYS,0),3,' '),
----peg_review_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,291,10)))
--rpad(to_char(PEG_REVIEW_DATE,'DD-MM-YYYY'),10,' '),
----review_reqd_on_start_date = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,301,1)))
--rpad(nvl(REVIEW_REQD_ON_START_DATE,' '),1,' '),
----interpolation_method = ltrim(rtrim(MID$(BANCS.INPUT.Buffer,302,1)))
--rpad(nvl(itc.INTERPOLATION_METHOD,' '),1,' ')
--from tbaadm.gam
--inner join tbaadm.itc on gam.acid=itc.entity_id
--inner join tda_o_table on trim(deposit_account_number)=foracid
--inner join map_Acc on fin_acc_num=foracid
--inner join (select a.* from v2pf_rate a
--inner join (select v5pf_acc_num from v2pf_rate group by v5pf_acc_num having count(*) > 1 ) b on a.v5pf_acc_num=b.v5pf_acc_num
--order by a.v5pf_acc_num,v2dte) deal on v5pf_acc_num=leg_acc_num;
--commit; 
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_lcu001_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_lcu001_upload.sql 
-- File Name        : Custom_lcu001_upload.sql
-- File Created for : Lockers Customisation
-- Created By       : Sharanappa
-- Client           : ABK
-- Created On       : 10-21-2016
-------------------------------------------------------------------
truncate table custom_lcu001_o_table;
insert into custom_lcu001_o_table
select distinct  
-- SOL_ID                          NVARCHAR2(8),
lpad(nvl(map_sol.fin_sol_id,' '),8,' '),
--  CIF_ID                          NVARCHAR2(32),
lpad(nvl(map_acc.fin_cif_id,' '),32,' '),
--  CUSTOMER_NAME                   NVARCHAR2(80),
lpad(nvl(trim(CIF_NAME),' '),80,' '),
--  LOCKER_TYPE                     NVARCHAR2(10),
lpad(nvl(CASE WHEN trim(SDBTYP)='120X60' THEN TO_CHAR('60X120') ELSE TO_CHAR(trim(SDBTYP)) END,' '),10,' '),
--  LOCKER_NO                       NVARCHAR2(10),
rpad(lpad(nvl(to_char(SDBNBR),' '),4,'0'),10,' '),
--  JOINT_HOLDERNAME_1              NVARCHAR2(80),
lpad(' ',80,' '),--JOINT_HOLDER_NAME1***
--  JOINT_HOLDER_CIF_ID_1           NVARCHAR2(32),
lpad(' ',32,' '),
--  JOINT_HOLDER_RELATION_1         NVARCHAR2(5),
lpad(' ',5,' '),
--  JOINT_HOLDER_NAME_2             NVARCHAR2(80),
lpad(' ',80,' '),
--  JOINT_HOLDER_CIF_ID_2           NVARCHAR2(32),
lpad(' ',32,' '),
--  JOINT_HOLDER_RELATION_2         NVARCHAR2(5),
lpad(' ',5,' '),
--  JOINT_HOLDER_NAME_3             NVARCHAR2(80),
lpad(' ',80,' '),
--  JOINT_HOLDER_CIF_ID_3           NVARCHAR2(32),
lpad(' ',32,' '),
--  JOINT_HOLDER_RELATION_3         NVARCHAR2(5),
lpad(' ',5,' '),
--  OPACC                           NVARCHAR2(16),
lpad(nvl(map_acc.fin_acc_num,' '),16,' '),
--  SDACC                           NVARCHAR2(16),
lpad(' ',16,' '),
--  CODE_WORD                       NVARCHAR2(80),
RPAD('1234',80,' '), --trim(CODE_WORD)
--  OPEN_DATE                       NVARCHAR2(10),
lpad(case when trim(SDBSDT) is not null then nvl(to_char(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBSDT)),'YYYYMMDD'),'DD-MM-YYYY'),' ') else ' ' end ,10,' '),
--  CLOSED_DATE                     NVARCHAR2(10),
lpad('31-12-2099',10,' '),----NEED TO CHECK
--  FREQUENCY                       NVARCHAR2(2),
lpad('YR',2,' '),--NEED TO CHECK
--  TOTAL_RENT                      NVARCHAR2(17),
RPAD(NVL(
case when  
 CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD') > to_date(get_param('EOD_DATE'),'dd-mm-yyyy') then 
 (floor(months_between(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD') , CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBSDT)),'YYYYMMDD')) /12)+1)*case when STAFF_FLAG is null then SDPFEE else SDPSFE end/C8pwd
 else 
 (floor(months_between( to_date(get_param('EOD_DATE'),'dd-mm-yyyy') , CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBSDT)),'YYYYMMDD')) /12)+1)*case when STAFF_FLAG is null then SDPFEE else SDPSFE end/C8pwd
 end,'0.001'),17,' '),--TRIM(TOTAL_RENT)
--  REMARKS                         NVARCHAR2(100),
lpad(nvl(trim(SDBNR1)||' '||trim(SDBNR2)||' '||trim(SDBNR3),' '),100,' '),    
--  LAST_RENT_DATE                  NVARCHAR2(10),
lpad(case when trim(SDBLFD) is not null then nvl(to_char(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBLFD)),'YYYYMMDD'),'DD-MM-YYYY'),nvl(to_char(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBSDT)),'YYYYMMDD'),'DD-MM-YYYY'),' ')) else ' ' end,10,' '),
--lpad(regexp_replace(trim(LAST_RENT_DATE),'[A-Z,a-z,/]',''),10,' '),***
--  DUE_DATE                        NVARCHAR2(10),
lpad(case when trim(SDBNFD) is not null then nvl(to_char(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD'),'DD-MM-YYYY'),' ') else ' ' end,10,' '),
--lpad(regexp_replace(trim(DUE_DATE),'[A-Z,a-z,/]',''),10,' '),***
--  DUE_NOTICE_DATE                 NVARCHAR2(10),
lpad(case when trim(SDBNFD) is not null then nvl(to_char(CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD'),'DD-MM-YYYY'),' ') else ' ' end,10,' '),--NEED TO CHECK ***
--  DUE_RENT                        NVARCHAR2(17),
LPAD(nvl(case when  
 CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD') > to_date(get_param('EOD_DATE'),'dd-mm-yyyy') then case when STAFF_FLAG is null then SDPFEE else SDPSFE end/C8pwd
 else 
 (floor(months_between(to_date(get_param('EOD_DATE'),'dd-mm-yyyy') , CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD')) /12)+2)*case when STAFF_FLAG is null then SDPFEE else SDPSFE end/C8pwd
 --to_date(get_param('EOD_DATE'),'dd-mm-yyyy') - CONV_TO_VALID_DATE(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD')
 end,'0.001'),17,' '),
--  DELETE_FLAG                     NVARCHAR2(1),
lpad('N',1,' '),
--  FREE_TEXT_1                     NVARCHAR2(15),
lpad(' ',15,' '),
--  FREE_TEXT_2                     NVARCHAR2(15),
lpad(' ',15,' '),
--  PAYMENT_MODE                    NVARCHAR2(1),
lpad('T',1,' '),-- (trim(PAYMENT_MODE)
--  PAYMENT_DATE                    NVARCHAR2(10),
lpad(case when trim(SDBNFD) is not null then to_char(to_date(get_date_fm_btrv(trim(SDBNFD)),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end ,10,' '),
--  RENT_PAID                       NVARCHAR2(17),
lpad('0.01',17,' '),
--  PREFERABLE_LANGUAGE_CODE        NVARCHAR2(10),
lpad(' ',10,' '),
--  CUSTOMER_NAMEIN_PREF_LANG_CODE  NVARCHAR2(80),
lpad(' ',80,' '),
-- MODE_OF_OPER_CODE               NVARCHAR2(5)
lpad('999',5,' ')
from YSDBPF
inner JOIN NEPF ON TRIM(SDBEAN) = TRIM(NEEAN)
inner join scpf on SCAB||SCAN||SCAS=NEAB||NEAN||NEAS
inner join map_sol on br_code=SDBBRNM
inner join map_acc  on SCAB||SCAN||SCAS=LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
inner join map_cif on  trim(MAP_CIF.FIN_CIF_ID) = trim(map_acc.FIN_CIF_ID) and is_joint<>'Y'
LEFT JOIN C8PF ON C8CCY = 'KWD'
left join YSDPPF on trim(SDPTYP) = trim(SDBTYP)
left JOIN CU1_O_TABLE b ON TRIM (b.ORGKEY) = TRIM (map_cif.fin_cif_id) and trim(STAFF_FLAG) = 'Y';
commit;
--delete from custom_lcu001_o_table where length(trim(LAST_RENT_DATE))<10;
--commit;

--delete SDB_JOINT where RELATED_CUS='627878' and RELATIONSHIP='SMN'

update custom_lcu001_o_table set RENT_PAID = lpad(nvl(TOTAL_RENT - case when DUE_RENT = 0.001 then 0 else to_number(DUE_RENT) end ,'0.01'),17,' ');
commit;

truncate table SDB_JOINT;

insert into SDB_JOINT
SELECT fin_acc_num ACC_NUM ,trim(YSDBPF.SDBBRNM), trim(YSDBPF.SDBTYP), trim(YSDBPF.SDBNBR) ,trim(scctp)    ,trim(gfpf.gfcus),trim(gfpf.gfclc),                                                     
  trim(rjrcus),trim(rjrclc),trim(rjrel),  trim(rireld) FROM ysdbpf 
left outer join nepf on trim(neean)=trim(sdbean) 
left outer join scpf on trim(scab)=trim(neab) and trim(scan)=trim(nean) and trim(scas)=trim(neas)
inner join map_acc on scab||scan||scas =  LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
left join c4pf on trim(scctp)=trim(c4ctp)         
left join gfpf on trim(gfcpnc) = trim(scan) 
left outer join rjpf on  (rjcus =gfcus and rjclc = gfclc)                                 
left outer join ripf on rirel = rjrel                                    
inner join map_cif on map_cif.gfclc||map_cif.gfcus = trim(rjrclc)||trim(rjrcus)
where scctp = 'EJ' ;
commit;
delete from SDB_JOINT where CUS||CUS_LOC||RELATED_CUS||RELATIONSHIP='627877600627878JNP';
commit;

UPDATE custom_lcu001_o_table A SET (JOINT_HOLDER_CIF_ID_1,JOINT_HOLDER_RELATION_1,JOINT_HOLDERNAME_1) = 
(SELECT lpad(CASE WHEN TRIM(B.RELATED_CUS) IS NOT NULL THEN to_char('0'||TRIM(B.RELATED_CUS_LOC)||TRIM(B.RELATED_CUS)) ELSE ' ' END,32,' '),lpad(NVL(TRIM(RELATIONSHIP),' '),5,' '),lpad(nvl(JOINT_HOLDER_NAME,' '),80,' ') FROM 
(SELECT  ACC_NUM, BOX_BRANCH, BOX_TYPE, BOX_NUMBER, CUSTOMER_TYPE, CUS, CUS_LOC, RELATED_CUS, RELATED_CUS_LOC, FIN_CODE RELATIONSHIP, FIN_CODE_DESC RELATIONSHIP_DESC,DENSE_RANK() OVER(PARTITION BY CUS ORDER BY RELATED_CUS) JOINT_HOLDER_NUM,lpad(coalesce(to_char(trim(CUST_FIRST_NAME)),to_char(trim(CORPORATE_NAME)),to_char(' ')),80,' ') JOINT_HOLDER_NAME  FROM SDB_JOINT A
left join cu1_o_table on '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = ORGKEY
left join cu1corp_o_table on  '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = corp_key
left join map_codes on trim(LEG_CODE) = trim(relationship))B 
WHERE    TRIM(A.OPACC) = trim(B.ACC_NUM) AND B.JOINT_HOLDER_NUM='1'  AND TRIM(A.LOCKER_NO) = TRIM(lpad(nvl(trim(to_char(B.BOX_NUMBER)),' '),4,'0'))
);

commit;


UPDATE custom_lcu001_o_table A SET (JOINT_HOLDER_CIF_ID_2,JOINT_HOLDER_RELATION_2,JOINT_HOLDER_NAME_2) = 
(SELECT lpad(CASE WHEN TRIM(B.RELATED_CUS) IS NOT NULL THEN to_char('0'||TRIM(B.RELATED_CUS_LOC)||TRIM(B.RELATED_CUS)) ELSE ' ' END,32,' '),lpad(NVL(TRIM(RELATIONSHIP),' '),5,' '), 
lpad(nvl(JOINT_HOLDER_NAME,' '),80,' ')  FROM 
(SELECT  ACC_NUM, BOX_BRANCH, BOX_TYPE, BOX_NUMBER, CUSTOMER_TYPE, CUS, CUS_LOC, RELATED_CUS, RELATED_CUS_LOC, FIN_CODE RELATIONSHIP, FIN_CODE_DESC RELATIONSHIP_DESC,DENSE_RANK() OVER(PARTITION BY CUS ORDER BY RELATED_CUS) JOINT_HOLDER_NUM,lpad(coalesce(to_char(trim(CUST_FIRST_NAME)),to_char(trim(CORPORATE_NAME)),to_char(' ')),80,' ') JOINT_HOLDER_NAME  FROM SDB_JOINT A
left join cu1_o_table on '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = ORGKEY
left join cu1corp_o_table on  '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = corp_key
left join map_codes on trim(LEG_CODE) = trim(relationship))B 
WHERE    TRIM(A.OPACC) = trim(B.ACC_NUM) AND B.JOINT_HOLDER_NUM='2'  AND TRIM(A.LOCKER_NO) = TRIM(lpad(nvl(trim(to_char(B.BOX_NUMBER)),' '),4,'0'))
);
commit;

UPDATE custom_lcu001_o_table A SET (JOINT_HOLDER_CIF_ID_3,JOINT_HOLDER_RELATION_3,JOINT_HOLDER_NAME_3) = 
(SELECT lpad(CASE WHEN TRIM(B.RELATED_CUS) IS NOT NULL THEN to_char('0'||TRIM(B.RELATED_CUS_LOC)||TRIM(B.RELATED_CUS)) ELSE ' ' END,32,' '),lpad(NVL(TRIM(RELATIONSHIP),' '),5,' '),lpad(nvl(JOINT_HOLDER_NAME,' '),80,' ') FROM 
(SELECT  ACC_NUM, BOX_BRANCH, BOX_TYPE, BOX_NUMBER, CUSTOMER_TYPE, CUS, CUS_LOC, RELATED_CUS, RELATED_CUS_LOC, FIN_CODE RELATIONSHIP, FIN_CODE_DESC RELATIONSHIP_DESC,DENSE_RANK() OVER(PARTITION BY CUS ORDER BY RELATED_CUS) JOINT_HOLDER_NUM,lpad(coalesce(to_char(trim(CUST_FIRST_NAME)),to_char(trim(CORPORATE_NAME)),to_char(' ')),80,' ') JOINT_HOLDER_NAME  FROM SDB_JOINT A
left join cu1_o_table on '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = ORGKEY
left join cu1corp_o_table on  '0'||TRIM(RELATED_CUS_LOC)||TRIM(RELATED_CUS) = corp_key
left join map_codes on trim(LEG_CODE) = trim(relationship))B 
WHERE    TRIM(A.OPACC) = trim(B.ACC_NUM) AND B.JOINT_HOLDER_NUM='3'  AND TRIM(A.LOCKER_NO) = TRIM(lpad(nvl(trim(to_char(B.BOX_NUMBER)),' '),4,'0'))
);

commit;


update custom_lcu001_o_table set  JOINT_HOLDERNAME_1 =  lpad(nvl(JOINT_HOLDERNAME_1,' '),80,' '), JOINT_HOLDER_CIF_ID_1 =  lpad(nvl(JOINT_HOLDER_CIF_ID_1,' '),32,' '), JOINT_HOLDER_RELATION_1 =  lpad(nvl(JOINT_HOLDER_RELATION_1,' '),5,' '),
 JOINT_HOLDER_NAME_2 =  lpad(nvl(JOINT_HOLDER_NAME_2,' '),80,' '), JOINT_HOLDER_CIF_ID_2 =  lpad(nvl(JOINT_HOLDER_CIF_ID_2,' '),32,' '), JOINT_HOLDER_RELATION_2  =  lpad(nvl(JOINT_HOLDER_RELATION_2,' '),5,' '),
  JOINT_HOLDER_NAME_3 =  lpad(nvl(JOINT_HOLDER_NAME_3,' '),80,' '), JOINT_HOLDER_CIF_ID_3 =  lpad(nvl(JOINT_HOLDER_CIF_ID_3,' '),32,' '), JOINT_HOLDER_RELATION_3  =  lpad(nvl(JOINT_HOLDER_RELATION_3,' '),5,' '),
  TOTAL_RENT = RPAD(case when trim(TOTAL_RENT)='0' then '0.01' else to_char(trim(TOTAL_RENT)) end,17,' '),
  DUE_RENT = RPAD(case when trim(DUE_RENT)='0' then '0.01' else to_char(trim(DUE_RENT)) end,17,' '),
  RENT_PAID = RPAD(case when trim(RENT_PAID)='0' then '0.01' else to_char(trim(RENT_PAID)) end,17,' ')
;  

commit;  


truncate table LOCKER_STAFF;

insert into LOCKER_STAFF
 SELECT trim(SOL_ID) SOL_ID,
       trim(LOCKER_TYPE) LOCKER_TYPE,
       trim(LOCKER_NO) LOCKER_NO,
       trim(a.cif_id) CUST_ID,
       trim(STAFF_FLAG) STAFF_FLG,
       trim(STAFFEMPLOYEEID) STAFF_NO,
       SDPSFE/1000 RENT_AMOUNT_CHARGED,
       SDPSFE/SDPFEE*100 PERCENT_RENT,
       TO_DATE(trim(OPEN_DATE),'DD-MM-YYYY') START_DATE,
       TO_DATE(trim(CLOSED_DATE),'DD-MM-YYYY') END_DATE,
       '' REMARKS,
       '' LCHG_TIME,
       '' LCHG_USER_ID,
       '' RCRE_TIME,
       '' RCRE_USER_ID,
       'N' DEL_FLG,
       '' FREE_TEXT1,
       '' FREE_TEXT2,
       '1' TS_CNT,
       get_param('BANK_ID') BANK_ID
  FROM CUSTOM_LCU001_O_TABLE a
       INNER JOIN CU1_O_TABLE b ON TRIM (b.ORGKEY) = TRIM (a.cif_id)
       left join YSDPPF on  CASE WHEN trim(SDPTYP)='120X60' THEN TO_CHAR('60X120') ELSE TO_CHAR(trim(SDPTYP)) END = trim(LOCKER_TYPE)
 WHERE STAFF_FLAG = 'Y';
 commit;

 truncate table C_LCKR_INS_FLG_TBL;

insert into C_LCKR_INS_FLG_TBL
SELECT map_sol.fin_sol_id SOL_ID,
       CASE WHEN trim(SDBTYP)='120X60' THEN TO_CHAR('60X120') ELSE TO_CHAR(trim(SDBTYP)) END LOCKER_TYPE,
       lpad(nvl(to_char(SDBNBR),' '),4,'0') LOCKER_NO,
       map_acc.fin_cif_id CIF_ID,
       trim(SDBINSC) INS_FLG,
       '01' BANK_ID,
       '' RCRE_USER_ID,
       '' RCRE_TIME,
       '' LCHG_USER_ID,
       '' LCHG_TIME
  FROM YSDBPF
inner JOIN NEPF ON TRIM(SDBEAN) = TRIM(NEEAN)
inner join scpf on SCAB||SCAN||SCAS=NEAB||NEAN||NEAS
inner join map_sol on br_code=SDBBRNM
inner join map_acc  on SCAB||SCAN||SCAS=LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
inner join map_cif on  trim(MAP_CIF.FIN_CIF_ID) = trim(map_acc.FIN_CIF_ID) and is_joint<>'Y';
commit;

truncate table C_LCKR_POA_DTS_TBL;

insert into C_LCKR_POA_DTS_TBL
SELECT map_sol.fin_sol_id SOL_ID,
       CASE
          WHEN TRIM (SDBTYP) = '120X60' THEN TO_CHAR ('60X120')
          ELSE TO_CHAR (TRIM (SDBTYP))
       END
          LOCKER_TYPE,
       LPAD (NVL (TO_CHAR (SDBNBR), ' '), 4, '0') LOCKER_NO,
       map_acc.fin_cif_id CIF_ID,
       poa1 POA1,
       POA2 POA2,
       POA3 POA3,
       '01' BANK_ID,
       '' RCRE_USER_ID,
       '' RCRE_TIME,
       '' LCHG_USER_ID,
       '' LCHG_TIME,
       'N' DEL_FLG
  FROM YSDBPF INNER JOIN NEPF ON TRIM (SDBEAN) = TRIM (NEEAN)inner join scpf on SCAB||SCAN||SCAS=NEAB||NEAN||NEAS
inner join map_sol on br_code=SDBBRNM
inner join map_acc  on SCAB||SCAN||SCAS=LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
inner join map_cif on  trim(MAP_CIF.FIN_CIF_ID) = trim(map_acc.FIN_CIF_ID) and is_joint<>'Y'
inner join (select BRANCH,ACCOUNT_NUMBER,BOX_NO,'0'||min(clc||cust) poa1,case when count(*)>1  and count(*)<3 then '0'||max(clc||cust) end poa2,case when count(*)>2 then '0'||max(clc||cust) end poa3 from locker_poa 
where clc||cust is not null
group by BRANCH,ACCOUNT_NUMBER,BOX_NO) po_loc on po_loc.ACCOUNT_NUMBER=map_acc.fin_acc_num and po_loc.BOX_NO=trim(SDBNBR)
where SDBPOA='Y';
 
exit;

--validation
--select a.* from CUSTOM_LCU001_O_TABLE a
--left join tbaadm.sdlkm b  on bank_id='01' and trim(a.LOCKER_TYPE) = trim(b.LOCKER_TYPE) and trim(a.LOCKER_NO) =trim(b.LOCKER_NO) and trim(a.SOL_ID) = trim(b.SOL_ID) 
--where b.SOL_ID is null
--union
--select a.* from CUSTOM_LCU001_O_TABLE a
--left join map_acc b on trim(a.OPACC) = fin_acc_num
--where CURRENCY <> 'KWD'

--select a.SOL_ID, a.CIF_ID, a.CUSTOMER_NAME, a.LOCKER_TYPE, a.LOCKER_NO,A.OPACC ACCOUNT_NUMBER, 'Locker sol_id, locker type and locker number combination not present in BPD' reason_for_failure from CUSTOM_LCU001_O_TABLE a
--left join tbaadm.sdlkm b  on bank_id='01' and trim(a.LOCKER_TYPE) = trim(b.LOCKER_TYPE) and trim(a.LOCKER_NO) =trim(b.LOCKER_NO) and trim(a.SOL_ID) = trim(b.SOL_ID) 
--where b.SOL_ID is null
--union
--select a.SOL_ID, a.CIF_ID, a.CUSTOMER_NAME, a.LOCKER_TYPE, a.LOCKER_NO,A.OPACC ACCOUNT_NUMBER,'Non KWD currency account number'  reason_for_failure from CUSTOM_LCU001_O_TABLE a
--left join map_acc b on trim(a.OPACC) = fin_acc_num
--where CURRENCY <> 'KWD'
--order by  reason_for_failure 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_leg_acct_type_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_leg_acct_type_upload.sql 
-- File Name		: custom_leg_acct_type_upload.sql 
-- File Created for	: Upload file for leg account type migration in account 
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 13-08-2017
-------------------------------------------------------------------
drop table custom_leg_acct_type;
create table custom_leg_acct_type as
select fin_acc_num,leg_acct_type,schm_code from map_Acc where schm_type <> 'OOO';
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_linked_account_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_linked_account_upload.sql 
-- File Name		: custom_linked_account_upload.sql 
-- File Created for	: Upload file for linked account details
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 26-08-2017
-------------------------------------------------------------------
-------------------------------------------------------------------
truncate table LATU_o_table;
insert into LATU_o_table
select
--Account_Number
rpad(ma1.fin_acc_num,16,' '), 
--Linked_Account_Number
 rpad(ma2.fin_acc_num,16,' '),
--Link_Type
lpad(' ',5,' '),
--Linked_Amount
rpad(abs(to_number(otdla))/POWER(10,c8pf.C8CED),17,' '),
--Linked_Amount_Currency
rpad(ma2.currency,3,' '),
--Remarks
lpad(' ',60,' ')
from map_acc ma1 
left join map_acc ma2 on ma1.EXTERNAL_ACC=ma2.EXTERNAL_ACC
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = ma2.leg_acc_num
inner join c8pf on c8ccy = otccy 
where ma1.schm_type='CLA' and ma1.schm_code not in ('BDT','LAC','CLM') and ma1.fin_acc_num<>ma2.fin_acc_num;
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_ltu001_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_ltu001_upload.sql 
-- File Name		: Custom_ltu001_upload.sql
-- File Created for	: Lockers Customisation
-- Created By		: Sharanappa
-- Client		    : ABK
-- Created On		: 21-10-2016
-------------------------------------------------------------------
truncate table custom_ltu001_o_table;
insert into custom_ltu001_o_table
select distinct
--  SOL_ID                 NVARCHAR2(8),
lpad(fin_sol_id,8,' '),
--  LOCKER_TYPE            NVARCHAR2(10),
lpad(trim(SDBTYP),10,' '),
--  BRANCH_CLASSIFICATION  NVARCHAR2(5),
lpad('',5,' '),--BRANCH_CLASSIFICATION
--  REMARKS                NVARCHAR2(100),
lpad(' ',100,' '),
--  START_DATE             NVARCHAR2(10),
lpad(trim('01-01-1900'),10,' '),
--  END_DATE               NVARCHAR2(10),
lpad('31-12-2099',10,' '),--as per andrew conformation default to 31-12-2099 changed on 03-02-2016
--  DELETE_FLAG            NVARCHAR2(1),
lpad('N',1,' '),
--  RENT_EVENT_ID          NVARCHAR2(25)
lpad(' ',25,' ')--RENT_EVENT_ID nedd to ask
--lpad('LOCKER RENTAL MIGRATION',25,' ')
from YSDBPF
inner join map_sol on br_code=SDBBRNM;
commit;
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_nominated_acct_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_nominated_acct_upload.sql 
-- File Name		: custom_nominated_acct_upload.sql 
-- File Created for	: Upload file for SBA and CAA nominated accounts
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 24-04-2017
-------------------------------------------------------------------
drop table custom_nominated_accounts;
create table custom_nominated_accounts as
select map_acc.fin_acc_num,operative_acc_num,schm_type from map_acc     
inner join (select map_acc.fin_acc_num fin_num, oper.fin_acc_num operative_acc_num  from ubpf inner join map_acc on ubab=leg_branch_id and uban=leg_scan and ubas=leg_scas
inner join (select leg_branch_id||leg_Scan||leg_Scas leg_acc_num,fin_acc_num from map_acc where SCHM_TYPE<>'OOO') oper on ubnab||ubnan||ubnas=oper.leg_acc_num 
where map_acc.schm_type<>'OOO') oper on oper.fin_num=fin_acc_num
where map_acc.schm_type in ('SBA','CAA');
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_nostro_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_nostro_upload.sql 
-- File Name		: custom_nostro_upload.sql 
-- File Created for	: Upload file for entity_id for nostro accounts
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 15-02-2016
-------------------------------------------------------------------
drop table custom_nostro;
create table custom_nostro as
select distinct fin_acc_num,map_cif.fin_cif_id from all_final_trial_balance 
left join map_cif on gfcpnc=scan
where scact='CN' and  scheme_type='OAB'
and scbal<>0;
exit;

 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_office_blocked_acc_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_office_blocked_acc_upload.sql 
-- File Name		: custom_office_blocked_acc_upload.sql 
-- File Created for	: Upload file for office account freeze marking
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 13-08-2017
-------------------------------------------------------------------
drop table custom_office_acc_block;
create table custom_office_acc_block as
select distinct
rpad(foracid,16,' ') foracid,
rpad('T',1,' ') frez_code,           
rpad('017',5,' ') frez_reason_code,    
rpad(system_only_acct_flg,1,' ') system_only_acct_flg,
rpad(anw_non_cust_alwd_flg,1,' ') anw_non_cust_alwd_flg
from Office_acc_block
left join all_final_trial_balance on trim(account_number)=scab||scan||scas
--left join yp_mapping on MIGR_PLACEHOLDER =substr(fin_acc_num,6,13)
--inner join tbaadm.gam on foracid=case when scact='YP' then to_char(substr(fin_acc_num,1,5)||FINACLE_PLC) else to_char(fin_acc_num) end
inner join tbaadm.gam on foracid=fin_acc_num and gam.bank_id='01';
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_operation_codes_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_operation_codes_upload.sql 
-- File Name---------- : custom_operation_codes_upload.sql
-- File Created for----: Upload file for operation reason codes
-- Created By----------: Kumaresan.B
-- Client--------------: ABK
-- Created On----------: 15-03-2016
-------------------------------------------------------------------
drop table last_dormant_dt;
create table last_dormant_dt as
select distinct fin_cif_id,scai85
from map_acc
inner join scpf  on scab=map_acc.leg_branch_id and scan=leg_scan and scas=leg_scas
where acc_closed is null and schm_type in ('SBA','CAA','ODA','PCA');
truncate table CUSTOM_OPERATION_REASON_CODES;
insert into CUSTOM_OPERATION_REASON_CODES
select distinct 
--REASON_CODE_DESC     NVARCHAR2(30),
'',
--OPERATION            NVARCHAR2(50),
--case when trim(GFC5R) in ('BK','BL','BM','BN','BP','BW') then 'Blacklisted' else '' end,--commented based on discussion with anegha,vijay and sandeep on 15-07-2017
'Suspend',
--REASON_CODE          NVARCHAR2(50),
GFC5R,
--REASON_DESC          NVARCHAR2(30),
trim(GOC5D),
--REASON_CODE_REMOVED  NVARCHAR2(1),
'',
--START_DATE           NVARCHAR2(10),
to_char(to_date(modify_date,'MM/DD/YYYY'),'DD-MM-YYYY'),
--EXPIRY_DATE          NVARCHAR2(10),
--to_char(to_date(modify_date,'MM/DD/YYYY'),'DD-MM-YYYY'), --as per vijay confirmation on 10-05-2017 this value moved to start_date
'',
--USERFIELD1           NVARCHAR2(100),
'',
--USERFIELD2           NVARCHAR2(100),
'',
--USERFIELD3           NVARCHAR2(100),
'',
--USERFIELD4           NVARCHAR2(100),
'',
--USERFIELD5           NVARCHAR2(100),
'',
--USERFIELD6           NVARCHAR2(18),
'',
--USERFIELD7           NVARCHAR2(18),
'',
--ORGKEY               NVARCHAR2(50),
map_cif.fin_cif_id,
--BANK_ID              NVARCHAR2(8)
get_param('BANK_ID')
from map_cif 
inner join gfpf on gfpf.gfclc=map_cif.gfclc and  gfpf.gfcus=map_cif.gfcus
left join acc_c5 on fin_cif_id = substr(lpad(trim(ext_acc),13,0),1,10)
left join bgpf  on nvl(gfpf.GFCLC,' ')=nvl(bgpf.BGCLC,' ') and gfpf.GFCUS=bgpf.BGCUS
left join gopf  on trim(GOC5R)=trim(GFC5R)
where map_cif.individual='Y' and map_cif.del_flg<>'Y' and trim(gfpf.GFC5R) is not null --and is_joint<>'Y'
and trim(GFC5R) in ('AL','BK','BL','BW','CF','DC','LA','LC','LD','LE','LG','LH','LI','LP','LR','PL','SL','UL','US','UT','WL','XX');
commit;  
insert into CUSTOM_OPERATION_REASON_CODES
select distinct 
--REASON_CODE_DESC     NVARCHAR2(30),
'',
--OPERATION            NVARCHAR2(50),
--case when trim(GFC5R) in ('BK','BL','BM','BN','BP','BW') then 'Blacklisted' else '' end,--commented based on discussion with anegha,vijay and sandeep on 15-07-2017
'Suspend',
--REASON_CODE          NVARCHAR2(50),
GFC5R,
--REASON_DESC          NVARCHAR2(30),
trim(GOC5D),
--REASON_CODE_REMOVED  NVARCHAR2(1),
'',
--START_DATE           NVARCHAR2(10),
to_char(to_date(modify_date,'MM/DD/YYYY'),'DD-MM-YYYY'),
--EXPIRY_DATE          NVARCHAR2(10),
'',
--to_char(to_date(modify_date,'MM/DD/YYYY'),'DD-MM-YYYY'), --as per vijay confirmation on 10-05-2017 this value moved to start_date
--USERFIELD1           NVARCHAR2(100),
'',
--USERFIELD2           NVARCHAR2(100),
'',
--USERFIELD3           NVARCHAR2(100),
'',
--USERFIELD4           NVARCHAR2(100),
'',
--USERFIELD5           NVARCHAR2(100),
'',
--USERFIELD6           NVARCHAR2(18),
'',
--USERFIELD7           NVARCHAR2(18),
'',
--ORGKEY               NVARCHAR2(50),
map_cif.fin_cif_id,
--BANK_ID              NVARCHAR2(8)
get_param('BANK_ID')
from map_cif 
inner join gfpf on gfpf.gfclc=map_cif.gfclc and  gfpf.gfcus=map_cif.gfcus
left join acc_c5 on fin_cif_id = substr(lpad(trim(ext_acc),13,0),1,10)
left join bgpf  on nvl(gfpf.GFCLC,' ')=nvl(bgpf.BGCLC,' ') and gfpf.GFCUS=bgpf.BGCUS
left join gopf  on trim(GOC5R)=trim(GFC5R)
where map_cif.individual='N' and map_cif.del_flg<>'Y' and trim(gfpf.GFC5R) is not null --and is_joint<>'Y'
and trim(GFC5R) in ('AL','BK','BL','BW','CF','DC','LA','LC','LD','LE','LG','LH','LI','LP','LR','PL','SL','UL','US','UT','WL','XX');
commit;  
----------- c3 code 'NF' need to mark as suspended ----------------------
insert into CUSTOM_OPERATION_REASON_CODES
select distinct 
--REASON_CODE_DESC     NVARCHAR2(30),
'',
--OPERATION            NVARCHAR2(50),
'Suspend',
--REASON_CODE          NVARCHAR2(50),
trim(gfc3r),
--REASON_DESC          NVARCHAR2(30),
'No Facilities-Internal BL',
--REASON_CODE_REMOVED  NVARCHAR2(1),
'',
--START_DATE           NVARCHAR2(10),
to_char(to_date(modify_date,'MM/DD/YYYY'),'DD-MM-YYYY'),
--EXPIRY_DATE          NVARCHAR2(10),
'',
--USERFIELD1           NVARCHAR2(100),
'',
--USERFIELD2           NVARCHAR2(100),
'',
--USERFIELD3           NVARCHAR2(100),
'',
--USERFIELD4           NVARCHAR2(100),
'',
--USERFIELD5           NVARCHAR2(100),
'',
--USERFIELD6           NVARCHAR2(18),
'',
--USERFIELD7           NVARCHAR2(18),
'',
--ORGKEY               NVARCHAR2(50),
map_cif.fin_cif_id,
--BANK_ID              NVARCHAR2(8)
get_param('BANK_ID')
from map_cif 
inner join gfpf on gfpf.gfclc=map_cif.gfclc and  gfpf.gfcus=map_cif.gfcus
left join acc_c5 on fin_cif_id = substr(lpad(trim(ext_acc),13,0),1,10)
where map_cif.del_flg<>'Y' and trim(gfc3r) ='NF';
commit;  
----------- last dormancy date-----------------------------
insert into CUSTOM_OPERATION_REASON_CODES
select distinct 
--REASON_CODE_DESC     NVARCHAR2(30),
'',
--OPERATION            NVARCHAR2(50),
'Suspend',
--REASON_CODE          NVARCHAR2(50),
'DOACC',
--REASON_DESC          NVARCHAR2(30),
'Last Dormant date',
--REASON_CODE_REMOVED  NVARCHAR2(1),
'',
--START_DATE           NVARCHAR2(10),
to_char(max(case  when trim(LAST_DORMANCY_DATE) is not null then to_date(LAST_DORMANCY_DATE,'MM/DD/YYYY')  
            when scdlm <> 0 and get_date_fm_btrv(scdlm) <> 'ERROR' then to_date(get_date_fm_btrv(scdlm),'YYYYMMDD')end),'DD-MM-YYYY'),
--EXPIRY_DATE          NVARCHAR2(10),
'',
--USERFIELD1           NVARCHAR2(100),
'',
--USERFIELD2           NVARCHAR2(100),
'',
--USERFIELD3           NVARCHAR2(100),
'',
--USERFIELD4           NVARCHAR2(100),
'',
--USERFIELD5           NVARCHAR2(100),
'',
--USERFIELD6           NVARCHAR2(18),
'',
--USERFIELD7           NVARCHAR2(18),
'',
--ORGKEY               NVARCHAR2(50),
a.fin_cif_id,
--BANK_ID              NVARCHAR2(8)
get_param('BANK_ID')
from (select * from last_dormant_dt where fin_cif_id in (
select fin_cif_id from (select distinct fin_cif_id,scai85 from last_dormant_dt) group by fin_cif_id having count(*) =1) and scai85='Y')a
inner join map_acc b on a.fin_cif_id=b.fin_cif_id
inner join scpf  on scab=b.leg_branch_id and scan=leg_scan and scas=leg_scas
left join dormant_acc on  leg_branch_id||leg_scan||leg_scas=dormant_acc.scab||dormant_acc.scan||dormant_acc.scas
where acc_closed is null and schm_type in ('SBA','CAA','ODA','PCA') 
group by a.fin_cif_id;
commit;  
DELETE from CUSTOM_OPERATION_REASON_CODES where rowid not in (select min(rowid) from CUSTOM_OPERATION_REASON_CODES group by ORGKEY,REASON_CODE);
commit;  
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_paid_installment.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_paid_installment.sql 
-- File Name		: custom_paid installment details.sql 
-- File Created for	: Upload file for paid installment details
-- Created By		: B. Kumaresan
-- Client			: ABK
-- Created On		: 30-05-2017
-------------------------------------------------------------------
--drop table migappkw.mig_c_amort;
--create table migappkw.mig_c_amort as
--select fin_acc_num,'01' shdl_num,
--lpad(row_number() over (partition by fin_acc_num order by case when ompf_pt.omdte is not null then  to_number(ompf_pt.omdte)
--else to_number(ompf_it.omdte) end ),4,'0')SERIAL_NUM, 
--case when  ompf_pt.omdte is not null and ompf_pt.omdte<>0 then to_date(get_date_fm_btrv(ompf_pt.omdte),'YYYYMMDD')
--when  ompf_it.omdte is not null and ompf_it.omdte<>0 then to_date(get_date_fm_btrv(ompf_it.omdte),'YYYYMMDD') 
--end FLOW_DATE,
--(case when ompf_pt.omdte is not null then  ompf_pt.omnwr
--else 0 end)/POWER(10,c8pf.C8CED)+(case when ompf_it.omdte is not null then  ompf_it.omnwr
--else 0 end)/POWER(10,c8pf.C8CED) INSTALLMENT_AMT,
--case when ompf_pt.omdte is not null then  to_number(ompf_pt.omnwr/POWER(10,c8pf.C8CED))
--else 0 end PRINCIPAL_AMT,
--case when ompf_it.omdte is not null then  to_number(ompf_it.omnwr/POWER(10,c8pf.C8CED))
--else 0 end INTEREST_AMT,
--0 PRINCIPAL_OUTSTANDING,0 FIXEDCHARGE_AMT,
--case when ompf_pt.ommvt='P' and  ompf_pt.ommvts='T'  then 'Normal Interest Demand'
--else 'Regular Installment' end FLOW_DESC,'N' DEL_FLG,'Y'ENTITY_CRE_FLG,'MIG1' RCRE_USER_ID,sysdate RCRE_TIME,'MIG1'LCHG_USER_ID,sysdate LCHG_TIME,get_param('BANK_ID') BANK_ID
--from map_acc 
--inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and map_acc.leg_acc_num=to_char(serial_deal) 
--left join (select * from ompf where to_number(omdte) <= to_number(get_param('EODCYYMMDD')) 
--and ommvt = 'P' and ommvts in('T') 
--order by to_number(omdte))ompf_pt on b.leg_acc_num=ompf_pt.ombrnm||trim(ompf_pt.omdlp)||trim(ompf_pt.omdlr)
--left join (select * from ompf where to_number(omdte) <= to_number(get_param('EODCYYMMDD')) 
--and ommvt = 'I' and ommvts='T' 
--order by to_number(omdte))ompf_it on b.leg_acc_num=ompf_it.ombrnm||trim(ompf_it.omdlp)||trim(ompf_it.omdlr)
--and ompf_it.omdte=ompf_pt.omdte
--inner join c8pf on c8ccy=currency
--where map_acc.schm_type in('CLA') ;
--------------------------- LAA------------
--insert into migappkw.mig_c_amort 
drop table migappkw.mig_c_amort;
create table migappkw.mig_c_amort as
select fin_acc_num,'01' shdl_num,
lpad(row_number() over (partition by fin_acc_num order by case when ompf_pt.omdte is not null then  to_number(ompf_pt.omdte)
else to_number(ompf_it.omdte) end ),4,'0')SERIAL_NUM, 
case when  ompf_pt.omdte is not null and ompf_pt.omdte<>0 then to_date(get_date_fm_btrv(ompf_pt.omdte),'YYYYMMDD')
when  ompf_it.omdte is not null and ompf_it.omdte<>0 then to_date(get_date_fm_btrv(ompf_it.omdte),'YYYYMMDD') 
end FLOW_DATE,
(case when ompf_pt.omdte is not null then  ompf_pt.omnwr
else 0 end)/POWER(10,c8pf.C8CED)+(case when ompf_it.omdte is not null then  ompf_it.omnwr
else 0 end)/POWER(10,c8pf.C8CED) INSTALLMENT_AMT,
case when ompf_pt.omdte is not null then  to_number(ompf_pt.omnwr/POWER(10,c8pf.C8CED))
else 0 end PRINCIPAL_AMT,
case when ompf_it.omdte is not null then  to_number(ompf_it.omnwr/POWER(10,c8pf.C8CED))
else 0 end INTEREST_AMT,
0 PRINCIPAL_OUTSTANDING,0 FIXEDCHARGE_AMT,
case when ompf_pt.ommvt='P' and  ompf_pt.ommvts='T'  then 'Normal Interest Demand'
else 'Regular Installment' end FLOW_DESC,'N' DEL_FLG,'Y'ENTITY_CRE_FLG,'MIG1' RCRE_USER_ID,sysdate RCRE_TIME,'MIG1'LCHG_USER_ID,sysdate LCHG_TIME,get_param('BANK_ID') BANK_ID
from map_acc 
left join (select * from ompf where to_number(omdte) <= to_number(get_param('EODCYYMMDD')) 
and ommvt = 'P' and ommvts in('T') 
order by to_number(omdte))ompf_pt on leg_acc_num=ompf_pt.ombrnm||trim(ompf_pt.omdlp)||trim(ompf_pt.omdlr)
left join (select * from ompf where to_number(omdte) <= to_number(get_param('EODCYYMMDD')) 
and ommvt = 'I' and ommvts='T' 
order by to_number(omdte))ompf_it on leg_acc_num=ompf_it.ombrnm||trim(ompf_it.omdlp)||trim(ompf_it.omdlr)
and ompf_it.omdte=ompf_pt.omdte
inner join c8pf on c8ccy=currency
where map_acc.schm_type in('LAA','CLA') 
union all
select fin_acc_num,'01' shdl_num,
lpad(row_number() over (partition by fin_acc_num order by case when ompf_pt.omdte is not null then  to_number(ompf_pt.omdte)
else to_number(ompf_it.omdte) end ),4,'0')SERIAL_NUM, 
case when  ompf_pt.omdte is not null and ompf_pt.omdte<>0 then to_date(get_date_fm_btrv(ompf_pt.omdte),'YYYYMMDD')
when  ompf_it.omdte is not null and ompf_it.omdte<>0 then to_date(get_date_fm_btrv(ompf_it.omdte),'YYYYMMDD') 
end FLOW_DATE,
(case when ompf_pt.omdte is not null then  ompf_pt.omnwr
else 0 end)/POWER(10,c8pf.C8CED)+(case when ompf_it.omdte is not null then  ompf_it.omnwr
else 0 end)/POWER(10,c8pf.C8CED) INSTALLMENT_AMT,
case when ompf_pt.omdte is not null then  to_number(ompf_pt.omnwr/POWER(10,c8pf.C8CED))
else 0 end PRINCIPAL_AMT,
case when ompf_it.omdte is not null then  to_number(ompf_it.omnwr/POWER(10,c8pf.C8CED))
else 0 end INTEREST_AMT,
0 PRINCIPAL_OUTSTANDING,0 FIXEDCHARGE_AMT,
case when ompf_pt.ommvt='P' and  ompf_pt.ommvts='T'  then 'Normal Interest Demand'
else 'Regular Installment' end FLOW_DESC,'N' DEL_FLG,'Y'ENTITY_CRE_FLG,'MIG1' RCRE_USER_ID,sysdate RCRE_TIME,'MIG1'LCHG_USER_ID,sysdate LCHG_TIME,get_param('BANK_ID') BANK_ID
from map_acc 
left join (select om1.* from ompf om1 
left join (select  ombrnm||trim(omdlp)||trim(omdlr) del_no,min(omdte) min_dt from ompf where ommvt in ('P','I') and (ommvts in('R') or trim(ommvts) is null)  
and to_number(omdte) >= to_number(get_param('EODCYYMMDD')) group by ombrnm||trim(omdlp)||trim(omdlr) )om2 on om1.ombrnm||trim(om1.omdlp)||trim(om1.omdlr)= om2.del_no 
where to_number(omdte) = to_number(min_dt) 
and ((OMMVT = 'P' and OMMVTS='R')) 
order by to_number(omdte))ompf_pt on leg_acc_num=ompf_pt.ombrnm||trim(ompf_pt.omdlp)||trim(ompf_pt.omdlr)
left join (select * from ompf om1
left join (select  ombrnm||trim(omdlp)||trim(omdlr) del_no,min(omdte) min_dt from ompf where ommvt in ('P','I') and (ommvts in('R') or trim(ommvts) is null) 
and to_number(omdte) >= to_number(get_param('EODCYYMMDD')) group by ombrnm||trim(omdlp)||trim(omdlr) )om2 on om1.ombrnm||trim(om1.omdlp)||trim(om1.omdlr)= om2.del_no 
where to_number(omdte) = to_number(min_dt) 
and (ommvt = 'I' and trim(ommvts) is null) 
order by to_number(omdte))ompf_it on leg_acc_num=ompf_it.ombrnm||trim(ompf_it.omdlp)||trim(ompf_it.omdlr)
inner join c8pf on c8ccy=currency
where map_acc.schm_type in('LAA','CLA') ;
commit;
delete from mig_c_amort where FLOW_DATE is null;
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_pca_disb.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_pca_disb.sql 
-- File Name		: custom_pca_disb.sql 
-- File Created for	: Upload file for disburshment details for PCA schmtype
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 19-06-2017
-------------------------------------------------------------------
--DROP TABLE OMPF_PCA;
--CREATE TABLE OMPF_PCA AS
--select trim(ombrnm)||trim(omdlp)||trim(omdlr)OMPF_LEG_NUM,sum(omnwp) omnwp
--from map_acc
--  inner join v5pf on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas 
--  left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
--  inner join ompf ON trim(ombrnm)||trim(omdlp)||trim(omdlr)=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
--  where map_acc.schm_type='PCA' and map_acc.schm_code='LDADV'
--  and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '')
--  GROUP BY trim(ombrnm)||trim(omdlp)||trim(omdlr);
-----------------LEGACY INTEREST DETAILS BLOCK----------------------
drop table pca_int_tbl;
create table pca_int_tbl as
  SELECT trim(v5brnm)||trim(v5dlp)||trim(v5dlr)  int_acc_num, v5dlp,v5ccy, schm_code , v5brr, d4brar BASE_EQ_RATE, v5drr,d5drar DIFF_EQ_RATE, v5rtm,v5spr,v5rat, 
    CASE WHEN v5rat <> 0 THEN 'ZEROL' 
         else convert_codes('INT_TBL_CODE',v5brr) END INT_TBL_CODE,
    CASE 
    WHEN convert_codes('INT_TBL_CODE',v5brr) <> 'ZEROL' THEN v5rtm +nvl(d5drar,0)
    WHEN convert_codes('INT_TBL_CODE',trim(v5brr)) = 'ZEROL' and (trim(v5brr) is not null or trim(v5rtm) <> 0 )THEN nvl(d4brar,0) + v5rtm +nvl(d5drar,0)
         ELSE to_number(v5rat)
         END ACC_PREF_RATE,
         case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end acct_open_date
from map_acc
  inner join v5pf on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas 
  left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
  inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  LEFT JOIN d4pf ON v5brr = d4brr and d4dte = 9999999 
  LEFT JOIN d5pf ON v5drr = d5drr and d5dte = 9999999
  left join map_codes on leg_code=v5brr 
  where map_acc.schm_type='PCA' and map_acc.schm_code='LDADV'
  and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '');
create index pca_int_tbl_idx on pca_int_tbl(int_acc_num);
create index pca_int_tbl_idx1 on pca_int_tbl(acct_open_date);
-------------------------Finacle interest details and differential rate block-------------------
drop table pca_acc_fin_int_rate_less12;
create table pca_acc_fin_int_rate_less12
as
SELECT a.*,REPRICING_PLAN,csp.int_tbl_code tbl_code,X.base_pcnt_dr,X.base_pcnt_cr,nvl(c.nrml_int_pcnt,0) cr_nrml_int_pcnt, nvl(d.nrml_int_pcnt,0) dr_nrml_int_pcnt,acc_pref_rate - (nvl(X.base_pcnt_dr,0) + nvl(d.nrml_int_pcnt,0))actual_pref_rate
from pca_int_tbl a
LEFT JOIN (SELECT * FROM TBAADM.GSP WHERE DEL_FLG= 'N' AND bank_id = get_param('BANK_ID'))GSP ON A.SCHM_CODE = GSP.SCHM_CODE
left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on a.schm_code = csp.schm_code and a.v5ccy = csp.crncy_code
left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  csp.int_tbl_code =b.int_tbl_code and  csp.CRNCY_CODE = b.CRNCY_CODE 
and acct_open_date between b.start_date and b.MODIFY_END_DATE
left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))X on  X.int_tbl_code =b.BASE_int_tbl_code  
and  X.CRNCY_CODE = b.CRNCY_CODE and acct_open_date between X.start_date and X.MODIFY_END_DATE 
left join (select a.* from tbaadm.IVS a 
    inner join (select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM from tbaadm.IVS where del_flg = 'N' and bank_id = get_param('BANK_ID') and int_slab_dr_cr_flg = 'C' group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
left join (select a.* from tbaadm.IVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.IVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'D'
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )d  on csp.int_tbl_code =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(INT_ACC_NUM);----below lines are commented based on vijay mail dt 25-09-2017
--and (case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
--     else 0 end)<=12;
create index pca_int_tbl_idx_2 on pca_acc_fin_int_rate_less12(int_acc_num);
----below lines are commented based on vijay mail dt 25-09-2017
--drop table pca_acc_fin_int_rate_more12;
--create table pca_acc_fin_int_rate_more12
--as
--SELECT a.*,REPRICING_PLAN,'PCAEX' tbl_code,X.base_pcnt_dr,X.base_pcnt_cr,nvl(c.nrml_int_pcnt,0) cr_nrml_int_pcnt, nvl(d.nrml_int_pcnt,0) dr_nrml_int_pcnt,acc_pref_rate - (nvl(X.base_pcnt_dr,0) + nvl(d.nrml_int_pcnt,0))actual_pref_rate
--from pca_int_tbl a
--LEFT JOIN (SELECT * FROM TBAADM.GSP WHERE DEL_FLG= 'N' AND bank_id = get_param('BANK_ID'))GSP ON A.SCHM_CODE = GSP.SCHM_CODE
--left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on a.schm_code = csp.schm_code and a.v5ccy = csp.crncy_code
--left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  'PCAEX' =b.int_tbl_code and  csp.CRNCY_CODE = b.CRNCY_CODE 
--and acct_open_date between b.start_date and b.MODIFY_END_DATE
--left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))X on  X.int_tbl_code =b.BASE_int_tbl_code  
--and  X.CRNCY_CODE = b.CRNCY_CODE and acct_open_date between X.start_date and X.MODIFY_END_DATE
--left join (select a.* from tbaadm.IVS a 
--    inner join (select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM from tbaadm.IVS where del_flg = 'N' and bank_id = get_param('BANK_ID') and int_slab_dr_cr_flg = 'C' group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
--where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on 'PCAEX' =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
--left join (select a.* from tbaadm.IVS a
--inner join (
--select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
--from tbaadm.IVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
--and int_slab_dr_cr_flg = 'D'
--group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
--AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
--where del_flg = 'N' and bank_id = get_param('BANK_ID') )d  on 'PCAEX' =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE
--inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(INT_ACC_NUM)
--and (case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
--     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
--     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
--     else 0 end)>12;
--create index pca_int_tbl_idx_3 on pca_acc_fin_int_rate_more12(int_acc_num);
------------------------------------------------------------------------
truncate table pca_disb;
insert into pca_disb
select
  --ACCOUNT_NUMBER   NVARCHAR2(16),
  map_acc.fin_acc_num,
  --CRNCY_CODE       NVARCHAR2(3),
  map_acc.currency,
  --SOL_ID           NVARCHAR2(8),
  map_acc.fin_sol_id,
  --DS_AMT           NVARCHAR2(17),
  --abs(to_number(OMPF_PCA.omnwp/POWER(10,c8pf.C8CED))),
    to_number((otdla)/POWER(10,c8pf.C8CED)),
  --DS_CRNCY_CODE    NVARCHAR2(3),
  map_acc.currency,
  --DS_DATE          NVARCHAR2(10),
  case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') 
    else ' ' end,
  --DS_DUE_DATE      NVARCHAR2(10),
  case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY')
     else ' ' end,
  --PNL_INT_ST_DATE  NVARCHAR2(10),
  case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')+1,'DD-MM-YYYY')---as per niraj requirement on 22-07-2017 at the time of mk5a-observation. This has been added.
     else ' ' end,
  --OPER_ACC_NUM     NVARCHAR2(16),
  case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end,
  --INT_CODE         NVARCHAR2(5),
--csp.INT_TBL_CODE,
--NVL(LESS.TBL_CODE,MORE.TBL_CODE),--- INT TABLE CODE CHANGED ON 17-07-2017 BASED ON MK5 OBSERVATION AND INT TBL_CODE CODE CHANGED FROM ODPPC TO PCA12 AND PCAEX.
LESS.TBL_CODE,----below lines are commented based on vijay mail dt 25-09-2017
  --INT_CRNCY_CODE   NVARCHAR2(3),
  map_acc.currency,
  --PEGGED_FLG       NVARCHAR2(1),
  GSP.PEG_INT_FOR_AC_FLG,
  --PG_FREQ_IN_MON   NVARCHAR2(5),
  '',
  --PG_FREQ_IN_DAYS  NVARCHAR2(3),
  '',
  --CUST_PR_INT_DR   NVARCHAR2(10),
  '',
  --ACC_PR_INT_DR    NVARCHAR2(10),
  --nvl(less.ACTUAL_PREF_RATE,more.ACTUAL_PREF_RATE), --- INT TABLE CODE CHANGED ON 17-07-2017 BASED ON MK5 OBSERVATION AND INT TBL_CODE CODE CHANGED FROM ODPPC TO PCA12 AND PCAEX.
  less.ACTUAL_PREF_RATE,----below lines are commented based on vijay mail dt 25-09-2017
  --CHNL_PR_INT_DR   NVARCHAR2(10),
  '',
  --ECGC_FLG         NVARCHAR2(1),
  'N',
  --UPLOAD_STATUS    NVARCHAR2(1),
  '',
  --ACCT_SCHM        NVARCHAR2(5),
  map_acc.schm_code,
  --REMARKS          NVARCHAR2(70)
  trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)
  from map_acc
  inner join v5pf on trim(v5abd)||trim(v5and)||trim(v5asd) = leg_branch_id||leg_scan||leg_scas 
  left join ospf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=trim(osbrnm)||trim(osdlp)||trim(osdlr)
  --inner join OMPF_PCA ON OMPF_LEG_NUM=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
  inner join c8pf on c8ccy = otccy
  --inner join pca_account_finacle_int_rate int_tbl on trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)=int_acc_num
  left join pca_acc_fin_int_rate_less12 less on trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)=less.int_acc_num
  --left join pca_acc_fin_int_rate_more12 more on trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)=more.int_acc_num
  left join (select * from tbaadm.gsp where gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID'))gsp on gsp.schm_code = map_acc.schm_code  
  left join pca_operacc oper on  trim(oper.ompf_leg_num)=trim(v5brnm)||trim(v5pf.v5dlp)||trim(v5dlr)
  left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code =map_acc.CURRENCY     
  where map_acc.schm_type='PCA' and map_acc.schm_code='LDADV'
  and v5bal<>0 and v5act='LB' and  ((v5arc <> 'A' OR v5arc IS NULL) ) and (oscanr <> 'C' OR oscanr IS NULL OR oscanr = '');
  commit;
  exit;
   
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_pool_upload_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_pool_upload_kw.sql 
-- File Name        : Custom_Pool_upload_kw.sql
-- File Created for : Sweeps pool Upload
-- Created By       : R.Alavudeen Ali Badusha
-- Client           : ABK
-- Created On       : 27-12-2016
-------------------------------------------------------------------
drop table sweeps;
create table sweeps as
select dense_rank() over(order by r0ab||r0an||r0as ) pool_num,FIN_BO_DR_ACCT,FIN_BO_CR_ACCT,FUND_CCY,RECV_CCY
--from BALANCE_ORDER a
from VW_SWEEPS a
inner join map_acc dr on dr.fin_acc_num=trim(FIN_BO_DR_ACCT)
inner join map_acc cr on cr.fin_acc_num=trim(FIN_BO_CR_ACCT)
where --r7npr >get_param('EODCYYMMDD') AND r7fld>get_param('EODCYYMMDD')
--and r0frc ='R' 
-- and 
dr.schm_type in ('SBA','CAA','ODA') and cr.schm_type in ('SBA','CAA','ODA');
truncate table custom_pool_o_table;
insert into custom_pool_o_table
select
--  Pool_Number                     Nvarchar2(6),
RPAD(pool_num,6,' '),
--  Account_Number                  Nvarchar2(16),
rPAD(acc_num,16,' '),
--  Pool_Desc                       Nvarchar2(50),
RPAD(fin_cif_id,50,' '),
--  Suspend_Flag                    Nvarchar2(1),
'N',
--  Suspend_Date                    Nvarchar2(10),
rpad(' ',10,' '),
--  Order_of_Utilization            Nvarchar2(4),
rpad(row_number() over( partition by pool_num order by pool_num),4,' '),
--  Alternate_Pool_Desc             Nvarchar2(50),
RPAD(fin_cif_id,50,' '),
--  Pool_Type                       Nvarchar2(1),
case when trim(FUND_CCY) <> trim(RECV_CCY) then 'M' else 'S' end,
--  Auto_Regularize                 Nvarchar2(1)
'Y'
from 
(select pool_num,fin_bo_dr_acct acc_num,substr(fin_bo_dr_acct,1,10) fin_cif_id,fund_ccy,recv_ccy from sweeps
union
select pool_num,fin_bo_cr_acct acc_num,substr(fin_bo_cr_acct,1,10) fin_cif_id,fund_ccy,recv_ccy from sweeps);
commit;
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_provision_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_provision_upload.sql 
truncate table custom_provision_o_table;
---------CAA Retail provision--------------------
insert into custom_provision_o_table
select distinct 
--Account_ID nvarchar2(16)
fin_acc_num,              
--Principal_Outstanding_Amount nvarchar2(17)
abs(balfc),    
--Effective_Collateral_Value nvarchar2(17)
'',
--Effective_Provision_Amount nvarchar2(17)
round(abs(PROV_AMT),3),
--Adhoc_Provisional_Amount nvarchar2(17)
'', 
--Last_Provisional_Date nvarchar2(16)
to_char(to_date(DATA_DATE,'YYYYMMDD'),'DD-MM-YYYY'),
--IAS_Provisional_Amount nvarchar2(17)
--sum(PROV_AMT),as a mk4a observation and sandeep requirement, commented on 11-06-2017 
'',
--Discount_IAS_Provis_Amt nvarchar2(17)
''
from PROVISION_DETAILS1 --8935
inner join nepf on trim(neean)=trim(EXTACCNO)
inner join map_acc on leg_branch_id||leg_scan||leg_scas=trim(nEAB)||trim(nean)||trim(neas)
where schm_type in ('SBA','CAA','ODA','PCA')  and trim(EXTACCNO) is not null;
commit;
---------LAA Retail provision--------------------
insert into custom_provision_o_table
select distinct 
--Account_ID nvarchar2(16)
fin_acc_num,              
--Principal_Outstanding_Amount nvarchar2(17)
abs(SUMOFBALKD),    
--Effective_Collateral_Value nvarchar2(17)
'',
--Effective_Provision_Amount nvarchar2(17)
round(abs(PROVISION_AMT),3),
--Adhoc_Provisional_Amount nvarchar2(17)
'', 
--Last_Provisional_Date nvarchar2(16)
'30-06-2017',---- This date is from distinct data_date of provision_details1 table
--IAS_Provisional_Amount nvarchar2(17)
--sum(PROV_AMT),as a mk4a observation and sandeep requirement, commented on 11-06-2017 
'', 
--Discount_IAS_Provis_Amt nvarchar2(17)
''
from provision_acc_laa a
inner join v5pf on trim(v5dlr)=a.dlref and a.act=v5act and v5brnm =substr(acc,1,4)
inner join map_acc on leg_acc_num=v5brnm||trim(v5dlp)||trim(v5dlr)
where schm_type='LAA';
commit;
--------------------------------Corporate CAA,ODA Provision Upload-------------
insert into custom_provision_o_table
select distinct 
--Account_ID nvarchar2(16)
fin_acc_num,              
--Principal_Outstanding_Amount nvarchar2(17)
abs(balfc),    
--Effective_Collateral_Value nvarchar2(17)
'',
--Effective_Provision_Amount nvarchar2(17)
round(abs(PROV_AMT),3),
--Adhoc_Provisional_Amount nvarchar2(17)
'', 
--Last_Provisional_Date nvarchar2(16)
to_char(to_date(DATA_DATE,'YYYYMMDD'),'DD-MM-YYYY'),
--IAS_Provisional_Amount nvarchar2(17)
--sum(PROV_AMT),as a mk4a observation and sandeep requirement, commented on 11-06-2017 
'',
--Discount_IAS_Provis_Amt nvarchar2(17)
''
from provision_details_corp --8935
inner join nepf on trim(neean)=trim(EXTACCNO)
inner join map_acc on leg_branch_id||leg_scan||leg_scas=trim(nEAB)||trim(nean)||trim(neas)
where schm_type in ('SBA','CAA','ODA','PCA') and trim(EXTACCNO) is not null;
commit;
--------------------------------Non-Cash Provision Upload-------------
insert into custom_provision_o_table
select distinct 
--Account_ID nvarchar2(16)
fin_acc_num,              
--Principal_Outstanding_Amount nvarchar2(17)
sum(abs(balfc)),    
--Effective_Collateral_Value nvarchar2(17)
'',
--Effective_Provision_Amount nvarchar2(17)
'',
--Adhoc_Provisional_Amount nvarchar2(17)
'', 
--Last_Provisional_Date nvarchar2(16)
to_char(to_date(DATA_DATE,'YYYYMMDD'),'DD-MM-YYYY'),
--IAS_Provisional_Amount nvarchar2(17)
--sum(PROV_AMT),as a mk4a observation and sandeep requirement, commented on 11-06-2017 
'',
--Discount_IAS_Provis_Amt nvarchar2(17)
''
from provision_details_noncash --8935
inner join nepf on trim(neean)=trim(EXTACCNO)
inner join map_acc on leg_branch_id||leg_scan||leg_scas=trim(nEAB)||trim(nean)||trim(neas)
where schm_type <> 'OOO' and trim(EXTACCNO) is not null 
group by fin_acc_num,DATA_DATE;
commit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_purpose_of_adv_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_purpose_of_adv_upload.sql 
-- File Name		: custom_purpose_of_adv_upload.sql 
-- File Created for	: Upload file for sba and caa pupose of advance details
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 17-07-2017
-------------------------------------------------------------------
drop table purpose_of_advance;
create table purpose_of_advance as
select fin_acc_num,trim(SCC2R) Purpose_of_Advn_Code,schm_type from scpf
inner join map_acc on leg_branch_id||leg_scan||leg_Scas =scab||scan||Scas
where schm_type in ('SBA','CAA') and trim(SCC2R) is not null;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_return_chq_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_return_chq_upload.sql 
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


 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_rollover_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_rollover_upload.sql 
-- File Name        : custom_rollover_upload.sql 
-- File Created for    : Upload file for LFR rollover details
-- Created By        : R.Alavudeen Ali Badusha
-- Client            : ABK
-- Created On        : 02-03-2016
-------------------------------------------------------------------
drop table Rollover_acct_opn_date;
create table Rollover_acct_opn_date as
select fin_acc_num,min(otsdte) otsdte,max(otmdt) otmdt,sum(otdla) otdla,min(v5lcd) v5lcd from map_acc a
inner join ld_deal_int_wise b on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and a.leg_acc_num=to_char(serial_deal)
left join otpf on otbrnm||trim(otdlp)||trim(otdlr)=b.LEG_ACC_NUM
left join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr)=b.LEG_ACC_NUM
group by fin_acc_num;
truncate table rollover_o_Table; 
insert into  rollover_o_Table
select distinct 
--  ACCOUNT_ID                      NVARCHAR2(16),
rpad(map_acc.fin_acc_num,16,' '),
--  ROLLOVER_MONTHS                 NVARCHAR2(3),
lpad(round(((to_date(LIMIT_EXPIRY_DATE,'YYYYMMDD')-to_date(ACCT_OPEN_DATE,'YYYYMMDD'))-10)/30,0),3,' '),
--lpad(round(((to_date(LIMIT_EXPIRY_DATE,'YYYYMMDD')-case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end)-10)/30,0),3,' '), ---account open date taken as min start date from deal only for rollover--in master acct opn date is scoad tis is changed on 10-08-2017 as per vijay discussion with nancy
--  ROLLOVER_DAYS                   NVARCHAR2(3),
lpad('0',3,' '),
--  ROLLOVER_TYPE                   NVARCHAR2(1),
rpad('P',1,' '),
--  ROLLOVER_PRINCIPAL_AMOUNT       NVARCHAR2(17),
lpad(' ',17,' '),
--  PENDING_INTEREST_DEMANDS        NVARCHAR2(1),
lpad('O',1,' '),
--  INT_PAY_AFTER_ROLLOVER          NVARCHAR2(1),
rpad('S',1,' '),
--  MAX_NUM_TIMES_ROLLOVER_ALLOWED  NVARCHAR2(3),
--rpad(case when trim(ossrc) is null then '0' else '999' end,3,' '),
rpad('999',3,' '),
--  DEFERRED_INTEREST               NVARCHAR2(1),
lpad('D',1,' '),
--  TENOR_FOR_INTEREST_RATE         NVARCHAR2(1),
lpad('R',1,' '),
--  SUSPEND_ROLLOVER                NVARCHAR2(1),
rpad(' ',1,' '),    
--  NUMBER_OF_TIME_ROLLOVER_DONE    NVARCHAR2(3),
rpad(' ',3,' '),
--  ONLINE_BATCH_ROLLOVER           NVARCHAR2(1),
rpad(case when nvl(trim(ossrc),'F') = 'F' then 'O' else 'B' end,1,' '),
--  ADVANCE_INT_RECOVERY_AC_ID      NVARCHAR2(16),
rpad(' ',16,' '),
--  TRAN_EXCHANGE_RATE              NVARCHAR2(5),
--rpad('MID',5,' '), ----commented based on spira no 7957 and Vijay mail dt 27-08-2017 
rpad(' ',5,' '),
--  TRAN_RATE                       NVARCHAR2(10),
--rpad(abs(trim(ACCT_ID_DEBIT_PREF_PER)),10,' '), ----commented based on spira no 7957 and Vijay mail dt 27-08-2017 
rpad(' ',10,' '),
--  TRAN_TREASURY_RATE              NVARCHAR2(10),
--rpad(abs(trim(ACCT_ID_DEBIT_PREF_PER)),10,' '), ----commented based on spira no 7957 and Vijay mail dt 27-08-2017 
rpad(' ',10,' '),
--  TREASURY_REF_NO                 NVARCHAR2(20),
rpad(' ',20,' '),
--  ROLLOVER_EVENT                  NVARCHAR2(1)
rpad('R',1,' ')
from map_acc 
inner join cl001_o_table on trim(acc_num)=fin_acc_num
--inner join ld_deal_int_wise a on leg_branch_id||leg_scan||leg_scas=scab||scan||scas and map_acc.leg_acc_num=to_char(serial_deal)
inner join ospf on trim(osbrnm)||trim(osdlp)||trim(osdlr)=leg_acc_num 
--left join Rollover_acct_opn_date roll on  roll.fin_acc_num=map_acc.fin_acc_num ---account open date taken as min start date from deal only for rollover--in master acct opn date is scoad tis is changed on 10-08-2017 as per vijay discussion with nancy
where schm_type='CLA' and map_acc.schm_code='LFR' and trim(ossrc) in ('A','R');
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_salary_indemnity_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_salary_indemnity_upload.sql 
-- File Name		: custom_salary_indemnity.sql 
-- File Created for	: Upload file for salary indemnity flag updation
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 17-07-2017
-------------------------------------------------------------------
drop table custom_salary_indemnity;
create table custom_salary_indemnity as
select distinct fin_cif_id,'Y' Legal_status from salary_indemnity
inner join map_cif on fin_cif_id=cif_id
--inner join map_Acc on leg_branch_id||leg_scan||leg_Scas=cif_id---added on 13-09-2017--due to in excel file account number provided
where trim(indemnity)='Yes';
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_sector_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_sector_upload.sql 
-- File Name		: custom_sector_upload.sql 
-- File Created for	: Upload file for SBCA sector and sub sector
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 17-08-2017
-------------------------------------------------------------------
drop table custom_sector;
create table custom_sector as
select distinct fin_acc_num,convert_codes('SECTOR_CODE',trim(SCC2R)) sector_code,nvl(trim(SCC2R),'ZZZ') sub_sector_code  
from map_acc
inner join scpf  on scab=map_acc.leg_branch_id and scan=leg_scan and scas=leg_scas
where map_acc.schm_type in( 'SBA','CAA');
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_siu_tt_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_siu_tt_upload.sql 
-- File Name         : SIU_TT_UPLOAD.sql
-- File Created for  : Upload file for SI TT upload
-- Created By        : Alavudeen Ali Badusha.R
-- Client        	 : ABK
-- Created On        : 05-07-2017
-------------------------------------------------------------------
truncate table siu_tt_o_table;
insert into siu_tt_o_table
select 
--PR_SRL_NUM                   
--FUND_ACCT_NUM||TRIM(SO_REF),
r5ab||r5an||r5as||R5SOR,
--SERIAL_NUM                   
'',
--ENTITY_CRE_FLG
'',
--REG_TYPE                     
'FORT',
--REG_SUB_TYPE                 
'',
--PAYSYS_ID                    
'SWIFT',
--OPER_CHARGE_ACCT 
FUND_ACCOUNT,
--REMIT_ORIGIN_REF             
'',
--REMIT_ORIGIN_TYPE            
'',
--REMIT_CRNCY                  
'KWD',
--REMIT_CNTRY_CODE             
'KW',
--PURPOSE_OF_REM               
--'120',
'15',---- Based on sandeep mail dt 17-10-2017 changed from 120 to 15.
--RATE_CODE                    
'MID',
--PARTY_CODE                   
'',
--PARTY_NAME                   
Details,
--PARTY_ADDR_1                 
--'AB',
'Kuwait',---- Based on sandeep mail dt 17-10-2017 changed from AB to kuwait.
--PARTY_ADDR_2                 
'BC',
--PARTY_ADDR_3                 
'CD',
--PARTY_CITY_CODE              
'',
--PARTY_STATE_CODE             
'',
--PARTY_CNTRY_CODE             
'',
--PARTY_PIN_CODE               
'',
--OTHER_PARTY_CODE             
'',
--OTHER_PARTY_NAME             
iban,
--OTHER_PARTY_ADDR_1           
--'AB',
data1,
--OTHER_PARTY_ADDR_2           
'BC',
--OTHER_PARTY_ADDR_3           
'CD',
--OTHER_PARTY_CNTRY            
'KW',
--PAYEE_BANK_CODE              
BENEF_BANK,
--PAYEE_BR_CODE                
BENEF_BRANCH,
--PAYEE_BANK_NAME              
'',
--UNQ_BANK_IDENTIFIER          
'',
--PAYEE_BANK_ADDR_1            
'ZZZ',
--PAYEE_BANK_ADDR_2            
'',
--PAYEE_BANK_ADDR_3            
'',
--PAYEE_BANK_CITY              
'',
--PAYEE_BANK_STATE             
'',
--PAYEE_BANK_CNTRY             
'',
--PAYEE_BANK_PIN_CODE          
'',
--LOCAL_CORRESP_BANK_CODE      
'999',
--LOCAL_CORRESP_BRANCH_CODE    
'0',
--RECEIVER_CORRESP_BANK_CODE   
'',
--RECEIVER_CORRESP_BRANCH_CODE 
'',
--RECEIVER_CORRES_BANK_NAME    
'',
--RECEIVER_CORRES_ADDR_1       
'',
--RECEIVER_CORRES_ADDR_2       
'',
--RECEIVER_CORRES_ADDR_3       
'',
--RECEIVER_CORRES_BANK_CNTRY   
'',
--CORR_COLL_BANK_CODE          
'999',
--CORR_COLL_BR_CODE            
'0', ---- Based on sandeep mail dt 17-10-2017 changed from null to 0.
--SERIAL_COVER_FLAG            
'',
--SLA_CATEGORY                 
'CRED',
--DTLS_OF_CHARGE               
'OUR',
--SENDER_TO_RECVR_INFO         
'',
--RECVR_ACCT_TYPE              
'',
--FREE_CODE1                   
'',
--FREE_CODE2                   
'',
--FREE_CODE3                   
'',
--FREE_CODE4                   
'',
--FREE_CODE5                   
'',
--FREE_TEXT                    
'',
--LCHG_USER_ID                 
'',
--LCHG_TIME                    
'',
--RCRE_USER_ID                 
'',
--RCRE_TIME                    
'',
--TS_CNT                       
'',
--DEL_FLG                      
'N',
--TREA_RATE_CODE               
'',
--NOSTRO_ACCT                  
'',
--BANK_ID                      
'01'
from ACTIVE_SI 
inner join siu_tt ON trim(FUND_ACCOUNT)||TRIM(R5SOR) =trim(FUND_ACCT_NUM)||TRIM(SO_REF)
inner join SIU_TT_BANK on BANK_NAME=BENEF_ACCT_NAME
inner join scpf on r5ab||r5an||r5as=scab||scan||scas
WHERE trim(FUND_CCY) = trim(RECV_CCY) and  R5NPR>get_param('EODCYYMMDD') and r5fld>get_param('EODCYYMMDD');
commit;
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_statement_upload_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_statement_upload_kw.sql 
-- File Name        : custom_statement_upload.sql 
-- File Created for    : Upload file for statement and swift  details
-- Created By        : R.Alavudeen Ali Badusha
-- Client            : ABK
-- Created On        : 06-06-2016
-------------------------------------------------------------------
truncate table  CUSTOM_STATEMENT_TABLE;
insert into CUSTOM_STATEMENT_TABLE 
select   
--  ACID                            VARCHAR2(11 CHAR),
gam.acid,
--  PS_REQD_FLG                     CHAR(1 BYTE),
case  --when scaiG6='Y' then 'N' based on spira id 7983 -- withholding stament condition removed --PS flag provided for all accounts
when substr(SCSFC,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L','Z','V','W','Y','S','M','T','U','N','O','P','Q','R') then 'Y' when trim(ps_freq_type) is not null then 'Y' else 'N' end,
--  PB_REQD_FLG                     CHAR(1 BYTE),
case  when map_acc.schm_code in ('SBGER','SBDAL','SBKID') then 'Y' else 'N' end,
--  SWIFT_STMT_REQD_FLG             CHAR(1 BYTE),
case when swift_code is not null then 'Y' when account is not null then 'Y' else 'N' end,
--  PS_LAST_PRNT_TIME               DATE,
case when scstml <> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') end,
--  PS_FREQ_TYPE                    CHAR(1 BYTE),
case --when scaiG6='Y' then ''      --based on spira id 7983 -- withholding stament condition removed --frequency type provided for all accounts
when substr(SCSFC,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then 'Y'
         when substr(SCSFC,0,1) in ('Z') then 'D'
         when substr(SCSFC,0,1) in ('V') then 'M'
         when substr(SCSFC,0,1) in ('W') then 'W'
         when substr(SCSFC,0,1) in ('Y') then 'F'
         when substr(SCSFC,0,1) in ('S','T','U') then 'Q'
         when substr(SCSFC,0,1) in ('M','N','O','P','Q','R') then 'H'
         else to_char(ps_freq_type)
    end ,
--  PS_FREQ_WEEK_NUM                CHAR(1 BYTE),
' ',
--  PS_FREQ_WEEK_DAY                NUMBER(1),
--case when scaiG6='Y' then '' when substr(SCSFC,0,1) in ('W') then  to_char(substr(SCSFC,2,2)) end,--as per spira ticket and discussion with Vijay and sandeep . this is commented due to front end issue.
'0', 
--  PS_FREQ_START_DD                NUMBER(2),
case --when scaiG6='Y' then ''    --based on spira id 7983 -- withholding stament condition removed-- frequency start dd provided for all accounts
         when substr(SCSFC,0,1) in ('V') then  to_char(substr(SCSFC,2,3))
         when substr(SCSFC,0,1) in ('S','T','U') then to_char(substr(SCSFC,2,3))
         when substr(SCSFC,0,1) in ('M','N','O','P','Q','R') then to_char(substr(SCSFC,2,3))
         when substr(SCSFC,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then to_char(substr(SCSFC,2,3))
         else '0'
    end,
--  PS_FREQ_HLDY_STAT               CHAR(1 BYTE),
'N',
--  PS_NEXT_DUE_DATE                DATE,
--casse when scaiG6='Y' then null    based on spira id 7983 -- withholding stament condition removed --next due date provided for all accounts
--when substr(SCSFC,0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L','Z','V','W','Y','S','M','T','U','N','O','P','Q','R') then  to_date(si_next_exec_date(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end ,trim(mapfrequency(substr(trim(scsfc),1,1)))),'DD/MM/YY') 
--when trim(ps_freq_type) ='M' and (scstml <>  0 or scoad <> 0) and trim(scsfc) is not null then to_date(si_next_exec_date(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR' then to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end ,trim(mapfrequency(substr(trim(scsfc),1,1)))),'DD/MM/YY') end,
case when trim(ps_freq_type) ='M' or trim(scsfc) is not null  then to_date(si_next_exec_date(to_date(case when substr(case when trim(scsfc) ='Z'  then lpad(to_char(substr(get_param('EOD_DATE'),1,2)+1),2,'0') else lpad(to_char(substr(nvl(trim(scsfc),'V31'),2,2)),2,'0') end||TO_CHAR(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') else to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,'MMYYYY'),1,4) in ('2902','3002','3102') then '28'
when substr(case when trim(scsfc) ='Z'  then lpad(to_char(substr(get_param('EOD_DATE'),1,2)+1),2,'0') else lpad(to_char(substr(nvl(trim(scsfc),'V31'),2,2)),2,'0') end||TO_CHAR(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') else to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,'MMYYYY'),1,4) in ('3104','3106','3109','3111') then '30'
else substr(case when trim(scsfc) ='Z'  then lpad(to_char(substr(get_param('EOD_DATE'),1,2)+1),2,'0') else lpad(to_char(substr(nvl(trim(scsfc),'V31'),2,2)),2,'0') end||TO_CHAR(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') else to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,'MMYYYY'),1,2) end||
substr(case when trim(scsfc) ='Z'  then lpad(to_char(substr(get_param('EOD_DATE'),1,2)+1),2,'0') else lpad(to_char(substr(nvl(trim(scsfc),'V31'),2,2)),2,'0') end||TO_CHAR(case when scstml<> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') else to_date(get_date_fm_btrv(scoad),'YYYYMMDD') end,'MMYYYY'),3,6),'DDMMYYYY'),trim(mapfrequency(substr(nvl(trim(scsfc),'V'),1,1)))),'DD/MM/YY') 
end,
--  PS_DESPATCH_MODE                CHAR(1 BYTE),
case 
when map_acc.schm_code='SBAML' then 'N'  --condition added on 22-08-2017 based on vijay mail dated 21-08-2017
when scaiG6='Y' then 'N'  --based on spira id 7983 -- withholding stament condition removed --frequency type provided for all accounts but despatch mode marked as 'N'
when scaig6='N' and SCAI64='Y' then 'N'
    when scaig6='N' and SCAI64='N' then 'P'
    when scaig6='Y' and SCAI64='Y' then 'N'
    when scaig6='Y' and SCAI64='N' then 'N'
    ELSE  'N' end,
--  LOCAL_CAL_FLG                   CHAR(1 BYTE),
'N',
--  PB_LAST_PRNT_TIME               DATE,
case when map_acc.schm_code in ('SBGER','SBDAL','SBKID') and scstml <> 0 then to_date(get_date_fm_btrv(scstml),'YYYYMMDD') end,
--  PB_LAST_PRNT_BAL                NUMBER(20,4),
'0',
--  PB_NUM_OF_BOOKS_PRNT            NUMBER(2),
'0',
--  PB_LAST_PRNT_LINE_NUM           NUMBER(2),
'0',
--  PB_LAST_PRNT_PAGE_NUM           NUMBER(2),
'0',
--  SWIFT_LAST_DATE                 DATE,
case when swift_code is not null then to_date(get_param('EOD_DATE'),'DD-MM-YYYY') when account is not null then to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  end,
--  SWIFT_STMT_SRL_NUM              NUMBER(5),
case when swift_code is not null then '0' when account is not null then '0' else '' end,
--  SWIFT_FREQ_TYPE                 CHAR(1 BYTE),
case 
    when substr(trim(FREQUENCY),0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then 'Y'
         when substr(trim(FREQUENCY),0,1) in ('Z') then 'D'
         when substr(trim(FREQUENCY),0,1) in ('V') then 'M'
         when substr(trim(FREQUENCY),0,1) in ('W') then 'W'
         when substr(trim(FREQUENCY),0,1) in ('Y') then 'F'
         when substr(trim(FREQUENCY),0,1) in ('S','T','U') then 'Q'
         when substr(trim(FREQUENCY),0,1) in ('M','N','O','P','Q','R') then 'H' 
         when swift_code is not null then 'D'
         when account is not null then 'D'
         end ,
--  SWIFT_FREQ_WEEK_NUM             CHAR(1 BYTE),
' ',
--  SWIFT_FREQ_WEEK_DAY             NUMBER(1),
case  when substr(trim(FREQUENCY),0,1) in ('W') then  to_char(substr(trim(FREQUENCY),2,2)) else '0' end,
--  SWIFT_FREQ_START_DD             NUMBER(2),
case     when substr(trim(FREQUENCY),0,1) in ('V') then  to_char(substr(trim(FREQUENCY),2,2))
         when substr(trim(FREQUENCY),0,1) in ('S','T','U') then to_char(substr(trim(FREQUENCY),2,2))
         when substr(trim(FREQUENCY),0,1) in ('M','N','O','P','Q','R') then to_char(substr(trim(FREQUENCY),2,2))
         when substr(trim(FREQUENCY),0,1) in ('A','B','C','D','E','F','G','H','I','J','K','L') then to_char(substr(trim(FREQUENCY),2,2))
         else '0' 
         end,         
--  SWIFT_FREQ_HLDY_STAT            CHAR(1 BYTE),
'N',
--  SWIFT_NEXT_DUE_DATE             DATE,
to_date(get_param('EOD_DATE'),'DD-MM-YYYY')+1,
--  PB_LAST_PRNT_TRAN_ID            VARCHAR2(9 CHAR),
'',
--  PB_LAST_PRNT_PTRAN_NUM          VARCHAR2(4 CHAR),
'',
--  RCRE_USER_ID                    VARCHAR2(15 CHAR),
'',
--  RCRE_TIME                       DATE,
'',
--  LCHG_USER_ID                    VARCHAR2(15 CHAR),
'',
--  LCHG_TIME                       DATE,
'',
--  TS_CNT                          NUMBER(5),
'1',
--  SWFT_MSG_TYPE                   CHAR(1 BYTE),
case when swift_code is not null then 'N' when to_char(account) is not null then 'N' else 'N' end,
--  SWFT_MSG_RCVR_BIC               VARCHAR2(12 CHAR),
case when swift_code is not null then to_char(swift_code) when to_char(account) is not null then to_char(BICCODE) else '' end,
--  PAYSYS_ID                       VARCHAR2(5 CHAR),
case when swift_code is not null then 'SWIFT' when to_char(account) is not null then 'SWIFT' else '' end,
--  DEL_FLG                         CHAR(1 BYTE),
' ',
--  IC_NEXT_DUE_DATE                DATE,
'',
--  PS_DIFF_FREQ_REL_PARTY_FLG      CHAR(1 BYTE),
'N',
--  SWIFT_DIFF_FREQ_REL_PARTY_FLG   CHAR(1 BYTE),
'N',
--  INTRADAY_SWIFT_STMNT_SRL_NUM    NUMBER(5),
'0',
--  INTRADAY_SWIFT_LAST_DATE        DATE,
'',
--  GENERATE_STMNT_UNCONDITIONALLY  CHAR(1 BYTE),
'N',
--  BANK_ID                         VARCHAR2(8 CHAR),
'',
--  PS_FREQ_CAL_BASE                VARCHAR2(2 CHAR)
''
from map_acc
inner join  scpf  on leg_branch_id||leg_scan||leg_Scas=scab||scan||scas
inner join tbaadm.gsp on gsp.schm_code=map_acc.schm_code and bank_id='01'
left join (select * from map_cif where del_flg<>'Y' and is_joint<>'Y' ) map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
left join (select distinct GFCUS,GFCLC,SWIFT_CODE from swift_code2) swift on nvl(trim(swift.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(swift.gfcus)=map_cif.gfcus
left join kwt_swift on leg_branch_id||leg_Scan||leg_scas= trim(account)
inner join tbaadm.gam on foracid=fin_acc_num
where map_acc.schm_type in ('SBA','ODA','CAA','PCA') and scai30 <> 'Y'    ;
commit;
DELETE from custom_statement_table where rowid not in (select min(rowid) from custom_statement_table group by acid );
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_tda_rmcode_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_tda_rmcode_upload.sql 
-- File Name		: custom_tda_rmcode_upload.sql 
-- File Created for	: Upload file for TDA rmcode details
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 20-08-2017
-------------------------------------------------------------------
drop table custom_tda_rmcode;
create table custom_tda_rmcode as
select fin_acc_num,case when nrd.officer_code is not null and trim(nrd.loginid) is not null then to_char(trim(nrd.loginid))
when trim(scpf.scaco)='199' then '199_RBD'
else nvl(convert_codes('RMCODE',trim(scpf.scaco)),'UBSADMIN') end RMCODE from map_acc
inner join scpf on scab||Scan||Scas=leg_branch_id||leg_scan||leg_scas
left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
where schm_type='TDA';
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Custom_YTD_PL.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Custom_YTD_PL.sql 
drop table all_balance;
create table all_balance as select distinct scab,scan,scas,fin_acc_num,scccy currency,scact account_type,scheme_type,scacd Analysis_code,scctp customer_type,GL_SUB_HEAD_CODE,'0' MTD_BAL,get_param('EOD_DATE') Migration_date  from all_final_trial_balance where scheme_type ='OAB' and fin_acc_num is not null and isnumber(GL_SUB_HEAD_CODE)=1;
create index all_bal_idx on all_balance(scab,scan,scas);
drop table SCPF_jan1;
create table SCPF_jan1 as select scab,scan,scas,scbal+scsuma jan_bal,c8lsar jan_rate from scpf_jan inner join c8pf_jan on c8ccy=scccy where scbal+scsuma <> 0;
CREATE INDEX SCJAN_IND ON SCPF_JAN1 (SCAB, SCAN, SCAS);
drop table SCPF_feb1;
create table SCPF_feb1 as select scab,scan,scas,scbal+scsuma feb_bal,c8lsar feb_rate from scpf_feb inner join c8pf_feb on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCFEB_IND ON SCPF_FEB1 (SCAB, SCAN, SCAS);
drop table SCPF_mar1;
create table SCPF_mar1 as select scab,scan,scas,scbal+scsuma mar_bal,c8lsar mar_rate from scpf_mar inner join c8pf_mar on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCMAR_IND ON SCPF_MAR1 (SCAB, SCAN, SCAS);
drop table SCPF_apr1;
create table SCPF_apr1 as select scab,scan,scas,scbal+scsuma apr_bal,c8lsar apr_rate from scpf_apr inner join c8pf_apr on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCAPR_IND ON SCPF_APR1 (SCAB, SCAN, SCAS);
drop table SCPF_may1;
create table SCPF_may1 as select scab,scan,scas,scbal+scsuma may_bal,c8lsar may_rate from scpf_may inner join c8pf_may on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCMAY_IND ON SCPF_MAY1 (SCAB, SCAN, SCAS);
drop table SCPF_jun1;
create table SCPF_jun1 as select scab,scan,scas,scbal+scsuma jun_bal,c8lsar jun_rate from scpf_jun inner join c8pf_jun on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCJUN_IND ON SCPF_JUN1 (SCAB, SCAN, SCAS);
drop table SCPF_jul1;
create table SCPF_jul1 as select scab,scan,scas,scbal+scsuma jul_bal,c8lsar jul_rate from scpf_jul inner join c8pf_jul on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCJUL_IND ON SCPF_JUL1 (SCAB, SCAN, SCAS);
drop table SCPF_aug1;
create table SCPF_aug1 as select scab,scan,scas,scbal+scsuma aug_bal,c8lsar aug_rate from scpf_aug inner join c8pf_aug on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCAUG_IND ON SCPF_AUG1 (SCAB, SCAN, SCAS);
--drop table SCPF_sep1;
--create table SCPF_sep1 as select scab,scan,scas,scbal+scsuma sep_bal,c8lsar sep_rate from scpf_sep inner join c8pf_sep on c8ccy=scccy where scbal+scsuma <> 0; 
--CREATE INDEX SCSEP_IND ON SCPF_SEP1 (SCAB, SCAN, SCAS);
--drop table SCPF_oct1;
--create table SCPF_oct1 as select scab,scan,scas,scbal+scsuma oct_bal,c8lsar oct_rate from scpf_oct inner join c8pf_oct on c8ccy=scccy where scbal+scsuma <> 0; 
--CREATE INDEX SCOCT_IND ON SCPF_OCT1 (SCAB, SCAN, SCAS);
--drop table SCPF_nov1;
--create table SCPF_nov1 as select scab,scan,scas,scbal+scsuma nov_bal,c8lsar nov_rate from scpf_nov inner join c8pf_nov on c8ccy=scccy where scbal+scsuma <> 0; 
--CREATE INDEX SCNOV_IND ON SCPF_NOV1 (SCAB, SCAN, SCAS);
--drop table SCPF_dec1;
--create table SCPF_dec1 as select scab,scan,scas,scbal+scsuma dec_bal,c8lsar dec_rate from scpf_dec inner join c8pf_dec on c8ccy=scccy where scbal+scsuma <> 0; 
--CREATE INDEX SCDEC_IND ON SCPF_DEC1 (SCAB, SCAN, SCAS);
------------------------------------------------------------
--PL JAN--
drop table profit_loss_balance_trfr_jan;
create table profit_loss_balance_trfr_jan
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_jan
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
        SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_jan
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_JAN a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL FEB--
drop table profit_loss_balance_trfr_feb;
create table profit_loss_balance_trfr_feb
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_feb
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_feb
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_feb a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL MAR--
drop table profit_loss_balance_trfr_mar;
create table profit_loss_balance_trfr_mar
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_mar
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_mar
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_mar a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL apr--
drop table profit_loss_balance_trfr_apr;
create table profit_loss_balance_trfr_apr
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_apr
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_apr
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_apr a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL MAY--
drop table profit_loss_balance_trfr_may;
create table profit_loss_balance_trfr_may
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_may
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_may
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_may a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL JUN--
drop table profit_loss_balance_trfr_jun;
create table profit_loss_balance_trfr_jun
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_jun
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_jun
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_jun a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL JUL--
drop table profit_loss_balance_trfr_jul;
create table profit_loss_balance_trfr_jul
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_jul
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_jul
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_jul a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
--PL AUG--
drop table profit_loss_balance_trfr_aug;
create table profit_loss_balance_trfr_aug
as
select to_char(trim(BRN)||trim(a.DEAL_TYPE)||trim(DEAL_REF)) deal_no,ie_fc PL_CONV_CCY,to_char(acct_type) scact,
gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,to_char(currency) scccy
from (  SELECT BRNM brn ,  DDLP deal_type , DDLR deal_ref,DACT acct_type,DCCY currency,  
                 SUM (TOTACCFC) ie_fc,
                 SUM (TOTACCKD) ie_kd
            FROM deposit_pl_aug
        GROUP BY BRNM,  DDLP , DDLR,DACT,DCCY
        UNION ALL
            SELECT CDL1_BRNM, CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY,
                 SUM (CDL1_MTD),
                 SUM (CDL1_MTDK)
            FROM loans_pl_aug
        GROUP BY CDL1_BRNM , CDL1_DLP , CDL1_DLR,CDL1_ATYP,CDL1_CCY) a
left join(select distinct scact,deal_type,max(scheme_code)scheme_code from all_final_trial_balance where  SCHEME_TYPE in('CLA','LAA','TDA','PCA') and scbal<>0
group by scact,deal_type) b on a.acct_type=b.scact and nvl(trim(a.deal_type),' ')=nvl(trim(b.DEAL_TYPE),' ')
left join (select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
left join map_sol on BR_CODE=trim(brn)
where ie_fc<>0
union  all
select b.leg_Acc_num,PL_CONV_CCY,a.scact,gss.schm_code,gss.schm_type, int_pandl_bacid_cr,int_pandl_bacid_dr,fin_sol_id,scccy
from ACCT_WISE_PL_MAP_aug a
inner join(select leg_acc_num,scheme_code,new_fin_sol_id fin_sol_id from all_final_trial_balance where  scheme_type  in('SBA','CAA','ODA')
union all
select leg_branch_id||leg_scan||leg_scas,schm_code,fin_sol_id from map_acc where  schm_type  in('SBA','CAA','ODA') and ACC_CLOSED='CLOSED') b on a.s5ab||a.s5an||a.s5as=b.leg_acc_num
inner join(select schm_type,schm_code,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss on gss.schm_code = b.scheme_code
where cust_type='CUST' 
and PL_CONV_CCY<>0;
commit;
drop table custom_ytd_dtl;
create table custom_ytd_dtl as
select  lpad(z.scab||z.scan||z.scas,20,' ') EQ_account_no,fin_acc_num,currency,account_type,scheme_type,Analysis_code,customer_type,MTD_BAL,GL_SUB_HEAD_CODE,
jan_BAL,jan_rate,feb_BAL,feb_rate,mar_BAL,mar_rate,apr_BAL,apr_rate,may_BAL,may_rate,jun_BAL,jun_rate,jul_BAL,jul_rate,
aug_BAL,
aug_rate,
--sep_BAL,
--sep_rate,
--oct_BAL,
--oct_rate,
--nov_BAL,
--nov_rate,
--dec_BAL,
--dec_rate,
get_param('EOD_DATE') Migration_date 
from all_balance z 
--inner join tbaadm.gss on gss.gl_sub_head_code = z.GL_SUB_HEAD_CODE and bank_id='01'
left join SCPF_jan1 jan on z.scab=jan.scab and z.scan=jan.scan and z.scas=jan.scas 
left join SCPF_feb1 feb on z.scab=feb.scab and z.scan=feb.scan and z.scas=feb.scas 
left join SCPF_mar1 mar on z.scab=mar.scab and z.scan=mar.scan and z.scas=mar.scas 
left join SCPF_apr1 apr on z.scab=apr.scab and z.scan=apr.scan and z.scas=apr.scas 
left join SCPF_may1 may on z.scab=may.scab and z.scan=may.scan and z.scas=may.scas 
left join SCPF_jun1 jun on z.scab=jun.scab and z.scan=jun.scan and z.scas=jun.scas 
left join SCPF_jul1 jul on z.scab=jul.scab and z.scan=jul.scan and z.scas=jul.scas 
left join SCPF_aug1 aug on z.scab=aug.scab and z.scan=aug.scan and z.scas=aug.scas 
--left join SCPF_sep1 sep on z.scab=sep.scab and z.scan=sep.scan and z.scas=sep.scas 
--left join SCPF_oct1 oct on z.scab=oct.scab and z.scan=oct.scan and z.scas=oct.scas 
--left join SCPF_nov1 nov on z.scab=nov.scab and z.scan=nov.scan and z.scas=nov.scas 
--left join SCPF_dec1 dec on z.scab=dec.scab and z.scan=dec.scan and z.scas=dec.scas 
;
commit;
insert into custom_ytd_dtl
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny, a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE, scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,PL_CONV_CCY jan_bal,to_char(C8LSAR) JAN_RATE,0 FEB_BAL,to_char('') FEB_RATE,0 MAR_BAL,to_char('') MAR_RATE,
0 APR_BAL,to_char('') APR_RATE,0 MAY_BAL,to_char('') MAY_RATE,0 JUN_BAL,to_char('') JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_jan a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_jan on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_jan
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_jan) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
union all
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,0 jan_bal,'' JAN_RATE,PL_CONV_CCY FEB_bal,to_char(C8LSAR) FEB_RATE,
0 MAR_BAL,to_char('') MAR_RATE,
0 APR_BAL,to_char('') APR_RATE,0 MAY_BAL,to_char('') MAY_RATE,0 JUN_BAL,to_char('') JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_feb a 
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_feb on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_feb
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_feb) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
union all
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,
PL_CONV_CCY MAR_bal,to_char(C8LSAR) MAR_RATE,0 APR_BAL,to_char('') APR_RATE,0 MAY_BAL,to_char('') MAY_RATE,0 JUN_BAL,to_char('') JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_mar  a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_mar on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_mar
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_mar) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
union all
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,0 mar_bal,to_char('') mar_RATE,
PL_CONV_CCY APR_bal,to_char(C8LSAR) APR_RATE,0 MAY_BAL,to_char('') MAY_RATE,0 JUN_BAL,to_char('') JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_apr a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_apr on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_apr
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_apr) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
union all
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,0 mar_bal,to_char('') mar_RATE,0 apr_bal,to_char('') apr_RATE,
PL_CONV_CCY MAY_bal,to_char(C8LSAR) MAY_RATE,0 JUN_BAL,to_char('') JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_may a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_may on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_may
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_may) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
union all
select case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end eq_account_no,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,0 mar_bal,to_char('') mar_RATE,0 apr_bal,to_char('') apr_RATE,
0 may_bal,to_char('') may_RATE,PL_CONV_CCY jun_bal,to_char(C8LSAR) JUN_RATE,0 JUL_BAL,to_char('') JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,
GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_jun a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_jun on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_jun
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_jun) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
UNION ALL
select DEAL_NO,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,
0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,0 mar_bal,to_char('') mar_RATE,0 apr_bal,to_char('') apr_RATE,
0 may_bal,to_char('') may_RATE,0 JUN_bal,to_char('') JUN_RATE,
PL_CONV_CCY juL_bal,TO_CHAR(C8LSAR) JUL_RATE,0 AUG_BAL,to_char('') AUG_RATE,GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_jul a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_jul on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_jul
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_jul) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null)
UNION ALL
select DEAL_NO,fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end fin_acc_num,a.scccy currecny,a.SCACT,SCHM_TYPE,scpf.scacd ANALYSIS_CODE,scpf.scctp CUSTOMER_TYPE,0MTD_BAL,substr(fin_sol_id||cnc.CRNCY_ALIAS_NUM||
case when INT_PANDL_BACID_CR is not null then INT_PANDL_BACID_CR
when INT_PANDL_BACID_DR is not null then INT_PANDL_BACID_DR
end,6,5) GL_SUB_HEAD_CODE,
0 jan_bal,to_char('') JAN_RATE,0 feb_bal,to_char('') feb_RATE,0 mar_bal,to_char('') mar_RATE,0 apr_bal,to_char('') apr_RATE,
0 may_bal,to_char('') may_RATE,0 JUN_bal,to_char('') JUN_RATE,
PL_CONV_CCY juL_bal,TO_CHAR(C8LSAR) JUL_RATE,PL_CONV_CCY aug_bal,TO_CHAR(C8LSAR) aug_RATE,GET_PARAM('EOD_DATE') MIGRATION_DATE
from profit_loss_balance_trfr_aug a
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID')) cnc on cnc.CRNCY_CODE=scccy
left join c8pf_aug on C8CCY=a.scccy
left join (select distinct DINTA internal_no,trim(brnm)||trim(ddlp)||trim(ddlr) deal_num from deposit_pl_aug
union all
select distinct CDL1_INTN internal_no, trim(CDL1_BRNM)||trim(CDL1_DLP)||trim(CDL1_DLR) deal_num from loans_pl_aug) deal on deal.deal_num=DEAL_NO
left join scpf on scab||scan||scas=(case when deal.deal_num is not null then to_char(deal.internal_no)
else to_char(DEAL_NO) end)
where (INT_PANDL_BACID_CR is not null or INT_PANDL_BACID_DR is not null);
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_ytd_upload_ae.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
custom_ytd_upload_ae.sql 
-- File Name                       : custom_htd_upload.sql
-- File Created for            	   : History Transaction file
-- Created By                      : Alavudeen Ali Badusha.R
-- Client                          : ABK
-- Created On                      : 15-01-2017
-------------------------------------------------------------------
drop table all_balance;
create table all_balance as select distinct scab,scan,scas,fin_acc_num,scccy currency,scact account_type,scheme_type,scacd Analysis_code,scctp customer_type,GL_SUB_HEAD_CODE,'0' MTD_BAL,get_param('EOD_DATE') Migration_date  from all_final_trial_balance where scheme_type ='OAB' and fin_acc_num is not null and isnumber(GL_SUB_HEAD_CODE)=1;
create index all_bal_idx on all_balance(scab,scan,scas);
drop table SCPF_jan1;
create table SCPF_jan1 as select scab,scan,scas,scbal+scsuma jan_bal,c8lsar jan_rate from scpf_jan inner join c8pf_jan on c8ccy=scccy where scbal+scsuma <> 0;
CREATE INDEX SCJAN_IND ON SCPF_JAN1 (SCAB, SCAN, SCAS);
drop table SCPF_feb1;
create table SCPF_feb1 as select scab,scan,scas,scbal+scsuma feb_bal,c8lsar feb_rate from scpf_feb inner join c8pf_feb on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCFEB_IND ON SCPF_FEB1 (SCAB, SCAN, SCAS);
drop table SCPF_mar1;
create table SCPF_mar1 as select scab,scan,scas,scbal+scsuma mar_bal,c8lsar mar_rate from scpf_mar inner join c8pf_mar on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCMAR_IND ON SCPF_MAR1 (SCAB, SCAN, SCAS);
drop table SCPF_apr1;
create table SCPF_apr1 as select scab,scan,scas,scbal+scsuma apr_bal,c8lsar apr_rate from scpf_apr inner join c8pf_apr on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCAPR_IND ON SCPF_APR1 (SCAB, SCAN, SCAS);
drop table SCPF_may1;
create table SCPF_may1 as select scab,scan,scas,scbal+scsuma may_bal,c8lsar may_rate from scpf_may inner join c8pf_may on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCMAY_IND ON SCPF_MAY1 (SCAB, SCAN, SCAS);
drop table SCPF_jun1;
create table SCPF_jun1 as select scab,scan,scas,scbal+scsuma jun_bal,c8lsar jun_rate from scpf_jun inner join c8pf_jun on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCJUN_IND ON SCPF_JUN1 (SCAB, SCAN, SCAS);
drop table SCPF_jul1;
create table SCPF_jul1 as select scab,scan,scas,scbal+scsuma jul_bal,c8lsar jul_rate from scpf_jul inner join c8pf_jul on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCJUL_IND ON SCPF_JUL1 (SCAB, SCAN, SCAS);
drop table SCPF_aug1;
create table SCPF_aug1 as select scab,scan,scas,scbal+scsuma aug_bal,c8lsar aug_rate from scpf_aug inner join c8pf_aug on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCAUG_IND ON SCPF_AUG1 (SCAB, SCAN, SCAS);
drop table SCPF_sep1;
create table SCPF_sep1 as select scab,scan,scas,scbal+scsuma sep_bal,c8lsar sep_rate from scpf_sep inner join c8pf_sep on c8ccy=scccy where scbal+scsuma <> 0; 
CREATE INDEX SCSEP_IND ON SCPF_SEP1 (SCAB, SCAN, SCAS);
--drop table SCPF_oct1;
--create table SCPF_oct1 as select scab,scan,scas,scbal+scsuma oct_bal,c8lsar oct_rate from scpf_oct inner join c8pf_oct on c8ccy=scccy where scbal+scsuma <> 0; 
--CREATE INDEX SCOCT_IND ON SCPF_OCT1 (SCAB, SCAN, SCAS);
--drop table SCPF_nov1;
--create table SCPF_nov1 as select scab,scan,scas,scbal+scsuma nov_bal,c8lsar nov_rate from scpf_nov inner join c8pf_nov on c8ccy=scccy where scbal+scsuma <> 0; 
--CREATE INDEX SCNOV_IND ON SCPF_NOV1 (SCAB, SCAN, SCAS);
--drop table SCPF_dec1;
--create table SCPF_dec1 as select scab,scan,scas,scbal+scsuma dec_bal,c8lsar dec_rate from scpf_dec inner join c8pf_dec on c8ccy=scccy where scbal+scsuma <> 0; 
--CREATE INDEX SCDEC_IND ON SCPF_DEC1 (SCAB, SCAN, SCAS);
------------------------------------------------------------
drop table custom_ytd_dtl;
create table custom_ytd_dtl as
select  z.scab||z.scan||z.scas EQ_account_no,fin_acc_num,currency,account_type,scheme_type,Analysis_code,customer_type,MTD_BAL,GL_SUB_HEAD_CODE,
jan_BAL,jan_rate,feb_BAL,feb_rate,mar_BAL,mar_rate,apr_BAL,apr_rate,may_BAL,may_rate,jun_BAL,jun_rate,jul_BAL,jul_rate,
aug_BAL,
aug_rate,
sep_BAL,
sep_rate,
--oct_BAL,
--oct_rate,
--nov_BAL,
--nov_rate,
--dec_BAL,
--dec_rate,
get_param('EOD_DATE') Migration_date 
from all_balance z 
--inner join tbaadm.gss on gss.gl_sub_head_code = z.GL_SUB_HEAD_CODE and bank_id='01'
left join SCPF_jan1 jan on z.scab=jan.scab and z.scan=jan.scan and z.scas=jan.scas 
left join SCPF_feb1 feb on z.scab=feb.scab and z.scan=feb.scan and z.scas=feb.scas 
left join SCPF_mar1 mar on z.scab=mar.scab and z.scan=mar.scan and z.scas=mar.scas 
left join SCPF_apr1 apr on z.scab=apr.scab and z.scan=apr.scan and z.scas=apr.scas 
left join SCPF_may1 may on z.scab=may.scab and z.scan=may.scan and z.scas=may.scas 
left join SCPF_jun1 jun on z.scab=jun.scab and z.scan=jun.scan and z.scas=jun.scas 
left join SCPF_jul1 jul on z.scab=jul.scab and z.scan=jul.scan and z.scas=jul.scas 
left join SCPF_aug1 aug on z.scab=aug.scab and z.scan=aug.scan and z.scas=aug.scas 
left join SCPF_sep1 sep on z.scab=sep.scab and z.scan=sep.scan and z.scas=sep.scas 
--left join SCPF_oct1 oct on z.scab=oct.scab and z.scan=oct.scan and z.scas=oct.scas 
--left join SCPF_nov1 nov on z.scab=nov.scab and z.scan=nov.scan and z.scas=nov.scas 
--left join SCPF_dec1 dec on z.scab=dec.scab and z.scan=dec.scan and z.scas=dec.scas 
;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Dormant_Charge_Upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Dormant_Charge_Upload.sql 
-- File Name		: Dormant_charge_upload.sql 
-- File Created for	: Upload file for cloased account flag
-- Created By		: R.Alavudeen Ali Badusha
-- Client			: ABK
-- Created On		: 06-04-2017
-------------------------------------------------------------------
drop table dormant_charges;
create table dormant_charges as (
select fin_acc_num,abs(saama/power(10,c8ced)) Last_Collected_Amount,to_char(to_date(get_date_fm_btrv(sapf.sapod),'YYYYMMDD'),'DD-MM-YYYY') Last_Charge_Collected_date from sapf
inner join scpf on scab||scan||Scas=saab||saan||saas
inner join map_acc on leg_branch_id||leg_scan||leg_scas=saab||saan||saas
inner join (select saab||saan||saas leg_number,max(SAPOD) sapod from sapf where SATCD ='010' and SAPBR like  '%@DRM%'
group by saab||saan||saas) a 
on leg_number=saab||saan||saas and a.sapod=sapf.sapod
inner join c8pf on c8ccy = scccy
where satcd='010' and SAPBR like  '%@DRM%' and scai85='Y' and schm_type in ('SBA','ODA','CAA'));
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Dummy_accounts_o_table.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Dummy_accounts_o_table.sql 
-- File Name		: dummy_accounts_o_table.sql
-- File Created for	: Upload file for all closed accounts 
-- Created By		: R.Alavudeen Ali Badusha
-- Client		    : ABK
-- Created On		: 09-02-2017
-------------------------------------------------------------------
truncate table dummy_accountS_o_Table;
insert into dummy_accountS_o_Table
select distinct 
--   v_Account_Number             CHAR(16)
            rpad(account_number,16,' '),
--   v_With_holding_tax_flg        CHAR(1)
            rpad('N',1,' '),
--Withholding tax Amount scope flag
            lpad(' ',1,' '),
--   v_With_holding_tax_percent        CHAR(8)
            lpad(' ',8,' '),
--   v_With_holding_tax_floor_limit    CHAR(17)
            lpad(' ',17,' '),
--   v_CIF_ID                 CHAR(32)
            rpad('DUMMY',32,' '),
--   v_Customer_Cr_Pref_Percent        CHAR(10)
            lpad(' ',10,' '),
--   v_Customer_Dr_Pref_Percent        CHAR(10)
            lpad(' ',10,' '),
--   v_Account_Cr_Pref_Percent         CHAR(10) ~!@
			lpad('0',10,' '),
--   v_Account_Dr_Pref_Percent        CHAR(10) ~!@
			lpad('0',10,' '),
--   v_Channel_Cr_Pref             CHAR(10)
            lpad(' ',10,' '),
--   v_Channel_Dr_Pref             CHAR(10)
            lpad(' ',10,' '),
--   v_Pegged_Flag             CHAR(1)
            'N',
--   v_Peg_Frequency_in_Mnth        CHAR(4)
            lpad(' ',4,' '),
--   v_Peg_Frequency_in_Days        CHAR(3)
            lpad(' ',3,' '),
--   v_Int_freq_type_Credit        CHAR(1) -- ~!@     
		   lpad(' ',1,' '),
--   v_Int_freq_week_num_Credit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_week_day_Credit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_start_dd_Credit        CHAR(2) ~!@          
			lpad(' ',2,' '),
--  v_Int_freq_hldy_stat_Credit        CHAR(1)     
			lpad(' ',1,' '),
--  v_Next_Cr_interest_run_date        CHAR(10)  ~!@ 
			lpad(' ',10,' '),
--   v_Int_freq_type_Debit        CHAR(1) ~!@ 
			lpad(' ',1,' '),
--   v_Int_freq_week_num_Debit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_week_day_Debit        CHAR(1)
            lpad(' ',1,' '),
--   v_Int_freq_start_dd_Debit        CHAR(2) ~!@
			lpad(' ',2,' '),
--   v_Int_freq_hldy_stat_Debit        CHAR(1)
            lpad(' ',1,' '),
-- v_Next_Debit_interest_run_dt        CHAR(10)
			lpad(' ',10,' '),
--   v_Ledger_Number            CHAR(3)
            lpad(' ',3,' '),
--   v_Employee_Id            CHAR(10)
            lpad(' ',10,' '),
--  v_Account_Open_Date            CHAR(10)
			case when scoad<>0 and get_date_fm_btrv(scoad)<> 'ERROR'
			then lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')          
			else lpad(' ',10,' ')
			end,
--   v_Mode_of_Operation_Code        CHAR(5)            
			lpad('999',5,' '),
--   v_Gl_Sub_Head_Code            CHAR(5)
            lpad('99999',5,' '),
--   v_Scheme_Code             CHAR(5)
            lpad('DUMMY',5,' '),
--   v_Cheque_Allowed_Flag        CHAR(1) ~!@
			lpad('N',1,' '),
--  v_Pass_Book_Pass_Sheet_Code        CHAR(1)
			lpad('N',1,' '),
--   v_Freeze_Code             CHAR(1) ~!@
			lpad(' ',1,' '),
-- v_Freeze_Reason_Code             CHAR(5) ~!@
			rpad(' ',5,' '),
--  v_Free_Text                 CHAR(240)
            lpad(' ' ,240,' '),
--   v_Account_Dormant_Flag        CHAR(1)
			lpad('A',1,' '),
--   v_Free_Code_1            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_2            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_3            CHAR(5)--Mandatory Field          
			lpad('999',5,' '),
--   v_Free_Code_4            CHAR(5)
            lpad(' ',5,' '),			
--   v_Free_Code_5            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_6            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_7            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_8            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_9            CHAR(5)
            lpad(' ',5,' '),
--   v_Free_Code_10            CHAR(5)            
			 lpad(' ',5,' '),			 
--   v_Interest_Table_Code        CHAR(5) 
            lpad('ZEROA',5,' '),
--   v_Account_Location_Code        CHAR(5)
            rpad(' ',5,' '),
--   v_Currency_Code             CHAR(3)	        
            lpad('AED',3,' '),
--   v_Service_Outlet             CHAR(8)
            rpad(' ',8,' '),
--   v_Account_Mgr_User_Id        CHAR(15)            
			lpad(' ',15,' '),
--   v_Account_Name             CHAR(80)
            rpad(' ',80,' '),
--  v_Swift_Allowed_Flg             CHAR(1)
			'N',
--   v_Last_Transaction_Date        CHAR(8)
			case when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
			lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
			else lpad(' ',10,' ') end,
--  v_Last_Transaction_any_date        CHAR(8)      
			case when scdle <> 0 and get_date_fm_btrv(scdle) <> 'ERROR' then
			lpad(to_char(to_date(get_date_fm_btrv(scdle),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
			else lpad(' ',10,' ')  end,
--   v_Exclude_for_combined_stateme    CHAR(1)
            lpad(' ',1,' '),
--   v_Statement_CIF_ID             CHAR(32)
            lpad(' ',32,' '),
--  v_Charge_Level_Code             CHAR(5)
            lpad(' ',5,' '),
-- v_PBF_download_Flag             CHAR(1)
            'N',
--   v_wtax_level_flg             CHAR(1)
			lpad(' ',1,' '),
--   v_Sanction_Limit             CHAR(17)
			lpad(' ',17,' '),
--   v_Drawing_Power             CHAR(17)
			lpad(' ',17,' '),
--   v_DACC_ABSOLUTE_LIMIT        CHAR(17)
            lpad(' ',17,' '),
-- v_DACC_PERCENT_LIMIT             CHAR(8)
            lpad(' ',8,' '),
--   v_Maximum_Allowed_Limit        CHAR(17)
			lpad(' ',17,' '),
--   v_Health_Code             CHAR(5)
            lpad('1',5,' '),
--Sanction Level Code
            lpad(' ',5,' '),
--Sanction Reference Number
            lpad(' ',25,' '),
--   v_Limit_Sanction_Date        CHAR(8)
            lpad(' ',10,' '),
--   v_Limit_Expiring_Date        CHAR(8)--need  clarification
			lpad(' ',10,' '),	
--   v_Account_Review_Date        CHAR(8)
            lpad(' ',10,' '),
--   v_Loan_Paper_Date             CHAR(8)
            lpad(' ',10,' '),
--   v_Sanction_Authority_Code        CHAR(5)
            lpad(' ',5,' '),
-- v_Last_Compound_date             CHAR(8)
            lpad(' ',10,' '),
--   v_Daily_compounding_of_int_fla    CHAR(1)
            lpad(' ',1,' '),
-- v_Comp_rest_day_flag             CHAR(1)
            lpad(' ',1,' '),
--   v_Use_discount_rate_flg        CHAR(1)
            lpad(' ',1,' '),
--   v_Dummy                 CHAR(100)
            lpad(' ',100,' '),
--   v_Account_status_date        CHAR(8)         
			case when scdlm <> 0 and get_date_fm_btrv(scdlm) <> 'ERROR' then
            lpad(to_char(to_date(get_date_fm_btrv(scdlm),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else lpad(get_param('EOD_DATE'),10,' ')
            end, 
--   v_Iban_number             CHAR(34)
            lpad(' ',34,' '),
--   v_Ias_code                 CHAR(5)
            lpad(' ',5,' '),
-- v_channel_id                 CHAR(5)
            lpad(' ',5,' '),
-- v_channel_level_code             CHAR(5)
            lpad(' ',5,' '),
--   v_int_suspense_amt             CHAR(17)
            lpad('0',17,' '),
--   v_penal_int_suspense_amt        CHAR(17)
            lpad('0',17,' '),
--   v_chrge_off_flg             CHAR(1)
            lpad(' ',1,' '),
--   v_pd_flg                 CHAR(1)
            'N',
--   v_pd_xfer_date             CHAR(8)
            lpad(' ',10,' '),
--   v_chrge_off_date             CHAR(8)
            lpad(' ',10,' '),
--   v_chrge_off_principal        CHAR(17)
            lpad(' ',17,' '),
--   v_pending_interest             CHAR(17)
            lpad(' ',17,' '),
-- v_principal_recovery             CHAR(17)
            lpad(' ',17,' '),
-- v_interest_recovery             CHAR(17)
            lpad(' ',17,' '),
--   v_charge_off_type             CHAR(1)
            lpad(' ',1,' '),
--   v_Master_acct_num             CHAR(16)
            lpad(' ',16,' '),
-- v_ps_diff_freq_rel_party_flg        CHAR(1)
            lpad(' ',1,' '),
--   v_swift_diff_freq_rel_party_fl    CHAR(1)
            lpad(' ',1,' '),
--   v_Address_Type             CHAR(12)
			rpad('Mailing',12,' '),
-- v_Phone_Type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_Type                 CHAR(12)   
            lpad(' ',12,' '),
--   v_Alternate_Account_Name        CHAR(80)
            lpad(' ',80,' '),
--   v_Interest_Rate_Period_Months    CHAR(4)
            lpad(' ',4,' '),
-- v_Interest_Rate_Period_Days         CHAR(3)
            lpad(' ',3,' '),
--   v_Interpolation_Method         CHAR(1)
            lpad(' ',1,' '),
--   v_Is_Account_hedged_Flag         CHAR(1)
            lpad(' ',1,' '),
-- v_Used_for_netting_off_flag         CHAR(1)
            lpad(' ',1,' '),
-- v_Security_Indicator             CHAR(10)
            lpad(' ',10,' '),
--   v_Debt_Security             CHAR(1)
            lpad(' ',1,' '),
--   v_Security_Code             CHAR(8)
            lpad(' ',8,' '),
--   Debit_int_Method            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--  Service_Chrge_Coll_Flg        VARCHAR2(1) NUL
            lpad('Y',1,' '),
--   Last_Purge_Date                VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   Total_Profit_Amt              VARCHAR2(17) NULL
		    lpad('0',17,' '),
--   Min_Age_Not_Met_Amt            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Br_Per_Prof_Paid_Flg            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--   Br_Per_Prof_Paid_Amt            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Prof_To_Be_Recovered            VARCHAR2(17) NULL
            lpad(' ',17,' '),
--   Prof_Distr_Upto_Date            VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   Nxt_Profit_Distr_Date        VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   unclaim_status            VARCHAR2(1) NULL
            lpad(' ',1,' '),
--   unclaim_status_date            VARCHAR2(10) NULL
            lpad(' ',10,' '),
--   orig_gl_sub_head_code        VARCHAR2(16) NUL
            lpad(' ',16,' ')
from DUMMY_ACCOUNTS
INNER JOIN SCPF ON SCAB||SCAN||sCAS=ACCOUNT_NUMBER
LEFT JOIN MAP_ACC ON FIN_ACC_NUM=ACCOUNT_NUMBER AND SCHM_TYPE IN ('CAA','CLA','LAA','ODA','PCA','SBA','TDA')
WHERE FIN_ACC_NUM IS NULL;
commit;
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
icv_dr_kw_new_tableoutput.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
icv_dr_kw_new_tableoutput.sql 
--select * from tier_entry_dr_new ORDER BY INT_TIER_TBL_CODE_MIG,S5CCY,seq (THIS IS THE SPOOL QUERY)
drop table d9pf_d4pf_d5pf_merge_dr;
create table d9pf_d4pf_d5pf_merge_dr as select * from vw_d9pf_d4pf_d5pf_merge_dr;
drop table lht_dr; 
create table lht_dr
as
select leg_acc_num,s5ccy,d9trc,
0 begin_amt,
d9tlv0/power(10,c8ced) end_amt, b1 base_rate , d1 diff_rate, 1 slab_level
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv0/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv1/power(10,c8ced), b2 base_rate , d2 diff_rate, 2
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv0 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv1/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv2/power(10,c8ced), b2 base_rate , d2 diff_rate, 3
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv1 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv2/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv3/power(10,c8ced), b3 base_rate , d3 diff_rate, 4
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv2 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv3/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv4/power(10,c8ced), b4 base_rate , d4 diff_rate, 5
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv3 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv4/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv5/power(10,c8ced), b5 base_rate , d5 diff_rate, 6
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv4 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv5/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv6/power(10,c8ced), b6 base_rate , d6 diff_rate, 7
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv5 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv6/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv7/power(10,c8ced), b7 base_rate , d7 diff_rate, 8
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv6 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv7/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv8/power(10,c8ced), b8 base_rate , d8 diff_rate, 9
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv7 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv8/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv9/power(10,c8ced), b9 base_rate , d9 diff_rate, 10
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv8 <>  999999999999999;

truncate table tier_entry;
truncate table tier_entry_dr_new;
DECLARE
   CURSOR c1
   IS
--select distinct a0090,a1010,a6000,a0230, eff_date from tier;
select distinct s5ccy,d9trc from lht_dr where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%';
   todo       NUMBER;
   BEGIN
      todo := 1;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry
            values 
            (
            l_record.d9trc||'_D',
            'ICVI'||l_record.d9trc||'_D'||l_record.s5ccy||'01-01-1900'||'31-12-2099'||
            lpad('ZEROB',5,' ')||
            lpad(' ',85,' ')||
            '01-01-1900'||
            'N'
           ,1,l_record.s5ccy,0
            );
         todo := todo +1;
            COMMIT;
   END LOOP;
   COMMIT;
END;
/
DECLARE
   CURSOR c1
   IS
    select DISTINCT 
    trim(d9trc)||'D' INT_TIER_TBL_CODE_MIG,
    'D' D_C_ind ,
    lpad(to_number(begin_amt),17,' ') begin_amt,
    lpad(to_number(end_amt),17,' ') end_amt,
    to_char(base_rate,'fm90.000000')base_rate,
    to_char(diff_rate,'fm90.000000') diff_rate,
    case 
    when end_amt = 999999999999.99 
    or end_amt = 999999999999.999
    or end_amt = 999999999999999 then 'Y'
    else 'N' end end_slab_ind,
    100 seq,
    S5CCY,
    SLAB_LEVEL
   from lht_dr
   where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%' 
   order by INT_TIER_TBL_CODE_MIG;
   todo       NUMBER;
   BEGIN
      todo := 100000;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry_dr_new
            values 
     (
        l_record.INT_TIER_TBL_CODE_MIG,
        l_record.D_C_ind,
        l_record.begin_amt,
        l_record.end_amt,
        l_record.base_rate,
        l_record.diff_rate,
        l_record.seq,
        todo,
        l_record.S5CCY,
        l_record.SLAB_LEVEL
     );
    -- insert into manage_rates values (l_record.CR_TIER_BASE_S1,l_record.INT_TIER_TBL_CODE_MIG);
         todo := todo +1;
            COMMIT;
   END LOOP;
   COMMIT;
END;
/
  
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
icv_kw_cr_byicvstructure.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
icv_kw_cr_byicvstructure.sql 
--SELECT * FROM TIER_ENTRY_CR ORDER BY TIER_CODE,S5CCY,ORDERBY (THIS IS THE SPOOL QUERY)

drop table d9pf_d4pf_d5pf_merge_cr;
create table d9pf_d4pf_d5pf_merge_cr as select * from vw_d9pf_d4pf_d5pf_merge_cr;
drop table lht_cr; 
create table lht_cr
as
select leg_acc_num,s5ccy,d9trc,
0 begin_amt,
d9tlv0/power(10,c8ced) end_amt, b1 base_rate , d1 diff_rate, 1 slab_level
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv0/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv1/power(10,c8ced), b2 base_rate , d2 diff_rate, 2
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv0 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv1/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv2/power(10,c8ced), b2 base_rate , d2 diff_rate, 3
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv1 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv2/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv3/power(10,c8ced), b3 base_rate , d3 diff_rate, 4
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv2 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv3/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv4/power(10,c8ced), b4 base_rate , d4 diff_rate, 5
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv3 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv4/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv5/power(10,c8ced), b5 base_rate , d5 diff_rate, 6
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv4 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv5/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv6/power(10,c8ced), b6 base_rate , d6 diff_rate, 7
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv5 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv6/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv7/power(10,c8ced), b7 base_rate , d7 diff_rate, 8
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv6 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv7/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv8/power(10,c8ced), b8 base_rate , d8 diff_rate, 9
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv7 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv8/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv9/power(10,c8ced), b9 base_rate , d9 diff_rate, 10
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv8 <>  999999999999999;

truncate table tier_entry_cr;
DECLARE
   CURSOR c1
   IS
--select distinct a0090,a1010,a6000,a0230, eff_date from tier;
select distinct s5ccy,d9trc from lht_cr where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%' ;
   todo       NUMBER;
   BEGIN
      todo := 1;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry_cr
            values 
            (
            l_record.d9trc||'_C',
            'ICVI'||l_record.d9trc||'_C'||l_record.s5ccy||'01-01-1900'||'31-12-2099'||
            lpad('ZEROB',5,' ')||
            lpad(' ',85,' ')||
            '01-01-1900'||
            'N'
           ,1,l_record.s5ccy,0
            );
         todo := todo +1;
            COMMIT;
   END LOOP;
   COMMIT;
END;
/
DECLARE
   CURSOR c1
   IS
    select distinct d9trc||'_C' INT_TIER_TBL_CODE_MIG, 'C' ,'IVS'||'C'||' '||lpad(to_number(begin_amt),17,' ')||
    lpad(to_number(end_amt),17,' ') ||to_char(base_rate,'fm90.000000')||to_char(diff_rate,'fm90.000000')||
    ' ' || lpad('0.000000',8,' ') ||
    ' ' || lpad('0.000000',8,' ') ||
    ' ' || lpad('0.000000',8,' ') ||
    ' ' || lpad('0.000000',8,' ') ||
    case 
    when end_amt = 999999999999.99 
    or end_amt = 999999999999.999
    or end_amt = 999999999999999 then 'Y'
    else 'N' end t_r,
    100 seq,S5CCY,SLAB_LEVEL
   from lht_cr
   where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%' 
    --order by leg_acc_num,slab_level;
	order by INT_TIER_TBL_CODE_MIG,S5CCY,SLAB_LEVEL;
   todo       NUMBER;
   BEGIN
      todo := 100000;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry_cr
            values 
     (
        l_record.INT_TIER_TBL_CODE_MIG,l_record.t_r,todo,l_record.S5CCY,l_record.SLAB_LEVEL
     );
    -- insert into manage_rates values (l_record.CR_TIER_BASE_S1,l_record.INT_TIER_TBL_CODE_MIG);
         todo := todo +1;
            COMMIT;
   END LOOP;
   COMMIT;
END;
/
  
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
icv_kw_cr_newtableoutput.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
icv_kw_cr_newtableoutput.sql 
--select * from tier_entry_cr_new ORDER BY INT_TIER_TBL_CODE_MIG,S5CCY,seq (THIS IS THE SPOOL QUERY)

drop table d9pf_d4pf_d5pf_merge_cr;
create table d9pf_d4pf_d5pf_merge_cr as select * from vw_d9pf_d4pf_d5pf_merge_cr;
drop table lht_cr; 
create table lht_cr
as
select leg_acc_num,s5ccy,d9trc,
0 begin_amt,
d9tlv0/power(10,c8ced) end_amt, b1 base_rate , d1 diff_rate, 1 slab_level
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv0/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv1/power(10,c8ced), b2 base_rate , d2 diff_rate, 2
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv0 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv1/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv2/power(10,c8ced), b2 base_rate , d2 diff_rate, 3
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv1 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv2/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv3/power(10,c8ced), b3 base_rate , d3 diff_rate, 4
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv2 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv3/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv4/power(10,c8ced), b4 base_rate , d4 diff_rate, 5
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv3 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv4/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv5/power(10,c8ced), b5 base_rate , d5 diff_rate, 6
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv4 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv5/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv6/power(10,c8ced), b6 base_rate , d6 diff_rate, 7
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv5 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv6/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv7/power(10,c8ced), b7 base_rate , d7 diff_rate, 8
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv6 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv7/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv8/power(10,c8ced), b8 base_rate , d8 diff_rate, 9
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv7 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv8/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv9/power(10,c8ced), b9 base_rate , d9 diff_rate, 10
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv8 <>  999999999999999;

truncate table tier_entry_cr;
truncate table tier_entry_cr_new;
DECLARE
   CURSOR c1
   IS
--select distinct a0090,a1010,a6000,a0230, eff_date from tier;
select distinct s5ccy,d9trc from lht_cr where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%' ;
   todo       NUMBER;
   BEGIN
      todo := 1;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry_cr
            values 
            (
            l_record.d9trc||'_C',
            'ICVI'||l_record.d9trc||'_C'||l_record.s5ccy||'01-01-1900'||'31-12-2099'||
            lpad('ZEROB',5,' ')||
            lpad(' ',85,' ')||
            '01-01-1900'||
            'N'
           ,1,l_record.s5ccy,0
            );
         todo := todo +1;
            COMMIT;
   END LOOP;
   COMMIT;
END;
/
DECLARE
   CURSOR c1
   IS
    select DISTINCT 
    trim(d9trc)||'C' INT_TIER_TBL_CODE_MIG,
    'C' D_C_ind ,
    lpad(to_number(begin_amt),17,' ') begin_amt,
    lpad(to_number(end_amt),17,' ') end_amt,
    to_char(base_rate,'fm90.000000')base_rate,
    to_char(diff_rate,'fm90.000000') diff_rate,
    case 
    when end_amt = 999999999999.99 
    or end_amt = 999999999999.999
    or end_amt = 999999999999999 then 'Y'
    else 'N' end end_slab_ind,
    100 seq,
    S5CCY,
    SLAB_LEVEL
   from lht_cr
   where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%' 
   order by INT_TIER_TBL_CODE_MIG;
   todo       NUMBER;
   BEGIN
      todo := 100000;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry_cr_new
            values 
     (
        l_record.INT_TIER_TBL_CODE_MIG,
        l_record.D_C_ind,
        l_record.begin_amt,
        l_record.end_amt,
        l_record.base_rate,
        l_record.diff_rate,
        l_record.seq,
        todo,
        l_record.S5CCY,
        l_record.SLAB_LEVEL
     );
    -- insert into manage_rates values (l_record.CR_TIER_BASE_S1,l_record.INT_TIER_TBL_CODE_MIG);
         todo := todo +1;
            COMMIT;
   END LOOP;
   COMMIT;
END;
/
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
icv_kw_dr_icvstructure.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
icv_kw_dr_icvstructure.sql 
--SELECT * FROM TIER_ENTRY ORDER BY TIER_CODE,S5CCY,ORDERBY (THIS IS THE SPOOL QUERY)
drop table d9pf_d4pf_d5pf_merge_dr;
create table d9pf_d4pf_d5pf_merge_dr as select * from vw_d9pf_d4pf_d5pf_merge_dr;
drop table lht_dr; 
create table lht_dr
as
select leg_acc_num,s5ccy,d9trc,
0 begin_amt,
d9tlv0/power(10,c8ced) end_amt, b1 base_rate , d1 diff_rate, 1 slab_level
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv0/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv1/power(10,c8ced), b2 base_rate , d2 diff_rate, 2
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv0 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv1/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv2/power(10,c8ced), b2 base_rate , d2 diff_rate, 3
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv1 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv2/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv3/power(10,c8ced), b3 base_rate , d3 diff_rate, 4
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv2 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv3/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv4/power(10,c8ced), b4 base_rate , d4 diff_rate, 5
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv3 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv4/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv5/power(10,c8ced), b5 base_rate , d5 diff_rate, 6
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv4 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv5/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv6/power(10,c8ced), b6 base_rate , d6 diff_rate, 7
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv5 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv6/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv7/power(10,c8ced), b7 base_rate , d7 diff_rate, 8
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv6 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv7/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv8/power(10,c8ced), b8 base_rate , d8 diff_rate, 9
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv7 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv8/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv9/power(10,c8ced), b9 base_rate , d9 diff_rate, 10
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv8 <>  999999999999999;

truncate table tier_entry;
DECLARE
   CURSOR c1
   IS
--select distinct a0090,a1010,a6000,a0230, eff_date from tier;
select distinct s5ccy,d9trc from lht_dr where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%';
   todo       NUMBER;
   BEGIN
      todo := 1;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry
            values 
            (
            l_record.d9trc||'_D',
            'ICVI'||l_record.d9trc||'_D'||l_record.s5ccy||'01-01-1900'||'31-12-2099'||
            lpad('ZEROB',5,' ')||
            lpad(' ',85,' ')||
            '01-01-1900'||
            'N'
           ,1,l_record.s5ccy,0
            );
         todo := todo +1;
            COMMIT;
   END LOOP;
   COMMIT;
END;
/
DECLARE
   CURSOR c1
   IS
    select DISTINCT d9trc||'_D' INT_TIER_TBL_CODE_MIG, 'D' ,'IVS'||'D'||' '||lpad(to_number(begin_amt),17,' ')||
    lpad(to_number(end_amt),17,' ') ||to_char(base_rate,'fm90.000000')||to_char(diff_rate,'fm90.000000')||
    ' ' || lpad('0.000000',8,' ') ||
    ' ' || lpad('0.000000',8,' ') ||
    ' ' || lpad('0.000000',8,' ') ||
    ' ' || lpad('0.000000',8,' ') ||
    case 
    when end_amt = 999999999999.99 
    or end_amt = 999999999999.999
    or end_amt = 999999999999999 then 'Y'
    else 'N' end t_r,
    100 seq,S5CCY,SLAB_LEVEL
   from lht_dr
   where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%' 
    order by INT_TIER_TBL_CODE_MIG;
   todo       NUMBER;
   BEGIN
      todo := 100000;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry
            values 
     (
        l_record.INT_TIER_TBL_CODE_MIG,l_record.t_r,todo,l_record.S5CCY,l_record.SLAB_LEVEL
     );
    -- insert into manage_rates values (l_record.CR_TIER_BASE_S1,l_record.INT_TIER_TBL_CODE_MIG);
         todo := todo +1;
            COMMIT;
   END LOOP;
   COMMIT;
END;
/
  
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
limit_core_kw_exp_date_update.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
limit_core_kw_exp_date_update.sql 

---MANUAL LIMIT EXPIRY DATE UPDATE 

truncate table limit_core_exp_date

insert into limit_core_exp_date
select a.limit_prefix,a.limit_suffix,b.EARLIEST_EXPIRY_DATE LIMIT_EXPIRY_DATE, b.EARLIEST_EXPIRY_DATE -1 LIMIT_REVIEW_DATE from LIMIT_CORE_INFY_TABLE a
inner join limit_core_exp_date_data b on trim(limit_prefix) = trim(CIF_NO);


insert into limit_core_exp_date
select distinct  a.limit_prefix,a.limit_suffix,c.LIMIT_EXPIRY_DATE,c.LIMIT_EXPIRY_DATE-1 from LIMIT_CORE_INFY_TABLE a
inner join CU9CORP_O_TABLE b on  trim(limit_prefix) = trim(ORGKEY)
inner join LIMIT_CORE_EXP_DATE_BANK_DATA c on trim(GROUPHOUSEHOLDCODE) = trim(GROUP_CODE);

insert into limit_core_exp_date
select distinct  a.limit_prefix,a.limit_suffix,c.LIMIT_EXPIRY_DATE,c.LIMIT_EXPIRY_DATE-1 from LIMIT_CORE_INFY_TABLE a
inner join CU9CORP_O_TABLE b on  trim(limit_prefix) = trim(GROUP_ID)
inner join LIMIT_CORE_EXP_DATE_BANK_DATA c on trim(GROUPHOUSEHOLDCODE) = trim(GROUP_CODE);

insert into limit_core_exp_date
select distinct a.limit_prefix,a.limit_suffix,b.LIMIT_EXPIRY_DATE ,b.LIMIT_EXPIRY_DATE-1 from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_EXP_DATE_IBD_DATA b on trim(CUSTOMER) = trim(limit_prefix);


create index limit_indx1 on  LIMIT_CORE_INFY_TABLE(limit_prefix,limit_suffix);

create index limit_indx2 on  LIMIT_CORE_O_TABLE(limit_prefix,limit_suffix);

create index limit_indx3 on  limit_core_exp_date(limit_prefix,limit_suffix);

update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE)=(
select LIMIT_EXPIRY_DATE , LIMIT_REVIEW_DATE from(
select * from limit_core_exp_date
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (a.limit_prefix,a.limit_suffix) in(
select limit_prefix,limit_suffix from limit_core_exp_date
);

update LIMIT_CORE_O_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE)=(
select to_char(LIMIT_EXPIRY_DATE,'dd-mm-yyyy') , to_char(LIMIT_REVIEW_DATE,'dd-mm-yyyy') from(
select * from limit_core_exp_date
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (a.limit_prefix,a.limit_suffix) in(
select limit_prefix,limit_suffix from limit_core_exp_date
);


 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
limit_core_kw_new_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
limit_core_kw_new_upload.sql 

DROP TABLE HPPF_BANK_GRP;
DROP TABLE HHPF_BANK_GRP;
DROP TABLE HHPF_MIG;
DROP TABLE HPPF_MIG;

CREATE TABLE HPPF_BANK_GRP AS 
SELECT DISTINCT NVL(UPDATED_RISK_COUNTRY_CODE,GFCNAR) HPCNA, HPGRP, GFCUS HPCUS, GFCLC HPCLC, HPLSTR, HPCCY, HPLED, HPYMDT, HPBRNM, HPLEDE, HPDLM, HPYRIT, HPYLCH, HPCF1, HPCF2, HPCF3, HPAUD FROM HPPF
INNER JOIN GFPF ON TRIM(HPGRP) = TRIM(GFGRP)
LEFT JOIN BANK_GRP_RISK_CNTRY ON TRIM(GROUP_NAME) = TRIM(HPGRP) ;

CREATE TABLE HHPF_BANK_GRP AS 
SELECT  DISTINCT NVL(UPDATED_RISK_COUNTRY_CODE,GFCNAR) HHCNA, HHGRP, GFCUS HHCUS, GFCLC HHCLC, HHLC, HHCCY, HHLED, HHAMA, HHLTST, HHYELG, HHYLCH, HHAAM, HHRAM FROM HHPF
INNER JOIN GFPF ON TRIM(HHGRP) = TRIM(GFGRP)
LEFT JOIN BANK_GRP_RISK_CNTRY ON TRIM(GROUP_NAME) = TRIM(HHGRP) ;

CREATE TABLE  HHPF_MIG AS 
SELECT * FROM (
SELECT * FROM HHPF WHERE TRIM(HHGRP) IS NULL
UNION
SELECT * FROM HHPF_BANK_GRP
) ;

TRUNCATE TABLE IBD_CUSTOMER;

INSERT INTO IBD_CUSTOMER
SELECT GFPF.GFCLC,GFPF.GFCUS,GFCNAR,FIN_CIF_ID,GFACO FROM GFPF
INNER JOIN MAP_CIF ON GFPF.GFCLC||GFPF.GFCUS = MAP_CIF.GFCLC||MAP_CIF.GFCUS
WHERE (NVL(TRIM(GFACO),0)>= 300 AND NVL(TRIM(GFACO),0) <=399) OR TRIM(GFACO)='450';

COMMIT;

UPDATE HHPF_MIG A SET HHCNA = (select GFCNAR from(SELECT distinct hhclc,hhcus,GFCNAR FROM HHPF_MIG a
inner join gfpf b on  a.hhclc||a.hhcus  = b.gfclc||b.gfcus ) b where a.hhclc||a.hhcus  = b.hhclc||b.hhcus)
where trim(HHCNA) is null and a.hhclc||a.hhcus in(select gfclc||gfcus from gfpf where GFCNAR <> 'KW');
commit;


drop table YCRLC1LF02_MIG;

create table YCRLC1LF02_MIG as 
select CRC1_GRP, nvl(GFCUS,CRC1_CUS) CRC1_CUS, nvl(GFCLC,CRC1_CLC) CRC1_CLC, CRC1_LSTR, CRC1_CGN, CRC1_PSEQ, CRC1_LSEQ, CRC1_LC, CRC1_LCN, CRC1_SUB, CRC1_HIF, CRC1_RLMA, CRC1_RLCY, CRC1_RLXD, CRC1_RADTE, CRC1_RGDTE,
 CRC1_RPLC, CRC1_RPLCN, CRC1_RICR, CRC1_RPC, CRC1_RRLVG, CRC1_BLNKF, CRC1_ULMA, CRC1_ULCY, CRC1_ULXD, CRC1_UADTE, CRC1_UGDTE, CRC1_UPLC, CRC1_UPLCN, CRC1_UICR, CRC1_UPC,
  CRC1_URLVG, CRC1_FILL from YCRLC1LF02 
left JOIN GFPF ON TRIM(CRC1_GRP) = TRIM(GFGRP)
where  (CRC1_CUS||CRC1_CLC||CRC1_GRP||CRC1_LC,CRC1_PSEQ) in(
select CRC1_CUS||CRC1_CLC||CRC1_GRP||CRC1_LC ,max(to_number(CRC1_PSEQ)) from YCRLC1LF02 group by CRC1_CUS||CRC1_CLC||CRC1_GRP||CRC1_LC
);

delete YCRLC1LF02_mig where rowid in(
select rowid from YCRLC1LF02_mig where CRC1_CUS||CRC1_CLC||CRC1_LC in(
select CRC1_CUS||CRC1_CLC||CRC1_LC  from YCRLC1LF02_mig where trim(CRC1_CUS) is not null  group by CRC1_CUS||CRC1_CLC||CRC1_LC having count(*)>1
) and  trim(CRC1_GRP) is null
);

--------------------------------------------
--Ignoring cash limit if customer have only Syndicate loan or there is no cash product in child level
--drop table cash_limit_customer;
 
--create table cash_limit_customer as 
--select hhclc,hhcus from hhpf_mig where trim(hhlc) in(       
--SELECT TRIM (COLUMN_VALUE) LIMIT_LINE
--  FROM limit_mapping,
--       XMLTABLE ( ('"' || REPLACE (LIMIT_LINE, ',', '","') || '"'))
-- WHERE LEVEL_6_PARENT = 'GECSH'
-- ) and trim(HHCUS) is not null and hhama <> 0 ;
-- 
-- update hhpf_mig set HHAMA='0' where hhclc||hhcus not in(
-- select hhclc||hhcus from cash_limit_customer
-- ) and trim(HHCUS) is not null and hhama <> 0 and trim(hhlc) in('LG083');
--commit;
------------------------------------------------
 
 
--SUBSTRACT FX LIMIT FROM CUSTL LIMIT
--UPDATE HHPF_MIG A SET A.HHAMA = (
--SELECT NEW_HHAMA FROM(
--select A.HHCLC,A.HHCUS,A.HHLC,A.HHAMA - ((C82.C8SPT/C81.C8SPT)*(B.HHAMA/C82.C8PWD))*C81.C8PWD  NEW_HHAMA from HHPF_MIG A
--INNER JOIN (select HHCUS,HHCLC,HHCCY,HHAMA from HHPF_MIG where HHLC='LG092' AND HHAMA <> 0) B ON A.HHCUS = B.HHCUS AND A.HHCLC = B.HHCLC
--LEFT JOIN C8PF C81 ON C81.C8CCY = A.HHCCY
--LEFT JOIN C8PF C82 ON C82.C8CCY = B.HHCCY
--where A.HHLC='LG098' AND A.HHAMA <> 0 
--) B WHERE A.HHCLC||A.HHCUS = B.HHCLC||B.HHCUS 
--) WHERE (A.HHCLC||A.HHCUS||A.HHLC) IN(
--select A.HHCLC||A.HHCUS||A.HHLC from HHPF_MIG A
--INNER JOIN (select HHCUS,HHCLC,HHCCY,HHAMA from HHPF_MIG where HHLC='LG092' AND HHAMA <> 0) B ON A.HHCUS = B.HHCUS AND A.HHCLC = B.HHCLC
--where A.HHLC='LG098' AND A.HHAMA <> 0);

CREATE TABLE  HPPF_MIG AS 
SELECT * FROM (
SELECT * FROM HPPF WHERE TRIM(HPGRP) IS NULL
UNION
SELECT * FROM HPPF_BANK_GRP
) ;

--CREATE CUSTL LIMIT FROM LS127 IF LG098 IS ZERO
--BELOW CODE COMMENTED BEACUSE NOW ARE COPING GENRL LIMIT TO CUSTL LIMIT
--UPDATE HHPF_MIG A SET (A.HHAMA,A.HHAAM,A.HHRAM) =( SELECT HHAMA,HHAAM,HHRAM FROM(
--SELECT B.* FROM HHPF_MIG A
--INNER JOIN (SELECT * FROM HHPF_MIG WHERE HHLC='LS127' AND HHAMA+HHRAM<>0) B ON A.HHCLC||A.HHCUS = B.HHCLC||B.HHCUS
-- WHERE A.HHLC='LG098' AND  A.HHAMA=0 
-- ) B WHERE A.HHCLC||A.HHCUS = B.HHCLC||B.HHCUS
-- ) WHERE A.HHLC='LG098' AND A.HHAMA=0 ;
-- 
-- COMMIT;

--update hhpf set HHAMA='600000000' where hhcus||hhclc='075007600' and hhlc='LG089';--exception ******
--update hhpf set HHAMA='40000000' where hhcus||hhclc='505752603' and hhlc='LG083';--exception ******

TRUNCATE TABLE LIMIT_CORE_TEMP_TABLE;

--Level 7
INSERT INTO LIMIT_CORE_TEMP_TABLE
SELECT distinct HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       CIF.fin_cif_id BORROWER_NAME,
       '7' NODE_LEVEL,
       CIF.fin_cif_id LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_7 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       CIF.fin_cif_id PARENT_LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_7_PARENT END PARENT_LIMIT_SUFFIX,
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_7 IS NOT NULL 
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON LS.LIMIT_SUFFIX_CODE= LM.level_7
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
 WHERE  --HH.HHLED > get_param ('EODCYYMMDD')AND
       CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1';
       
commit;
       
--Level 6
INSERT INTO LIMIT_CORE_TEMP_TABLE        
SELECT  DISTINCT HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       CIF.fin_cif_id BORROWER_NAME,
       '6' NODE_LEVEL,
       CIF.fin_cif_id LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_6 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       CIF.fin_cif_id PARENT_LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_6_PARENT END PARENT_LIMIT_SUFFIX,
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit,
       get_param('BANK_ID')  
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_6 IS NOT NULL 
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON LS.LIMIT_SUFFIX_CODE= LM.level_6
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
 WHERE  --HH.HHLED > get_param ('EODCYYMMDD')AND
       CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1';
       
commit;
        
--Level 5
INSERT INTO LIMIT_CORE_TEMP_TABLE        
SELECT  DISTINCT HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       CIF.fin_cif_id BORROWER_NAME,
       '5' NODE_LEVEL,
       CIF.fin_cif_id LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_5 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       CIF.fin_cif_id PARENT_LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_5_PARENT END PARENT_LIMIT_SUFFIX,
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit ,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_5 IS NOT NULL 
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON LS.LIMIT_SUFFIX_CODE= LM.level_5
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
 WHERE  --HH.HHLED > get_param ('EODCYYMMDD')AND
        CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1';
                        
commit;
        
--Level 4
INSERT INTO LIMIT_CORE_TEMP_TABLE        
SELECT  DISTINCT HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       CIF.fin_cif_id BORROWER_NAME,
       '4' NODE_LEVEL,
       CIF.fin_cif_id LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_4 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       CIF.fin_cif_id PARENT_LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_4_PARENT END PARENT_LIMIT_SUFFIX,
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_4 IS NOT NULL 
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON LS.LIMIT_SUFFIX_CODE= LM.level_4
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
 WHERE  --HH.HHLED > get_param ('EODCYYMMDD')AND
        CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1';
           
commit;

--Level 3
INSERT INTO LIMIT_CORE_TEMP_TABLE        
SELECT DISTINCT HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       CIF.fin_cif_id BORROWER_NAME,
       '3' NODE_LEVEL,
       CIF.fin_cif_id LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_3 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       CASE WHEN IBD_CUSTOMER.FIN_CIF_ID IS NOT NULL THEN TO_CHAR(TRIM(HHCNA)) ELSE TO_CHAR(GM.GROUP_ID) END PARENT_LIMIT_PREFIX,--NEED TO PUT GROUP NAME
       CASE WHEN IBD_CUSTOMER.FIN_CIF_ID IS NOT NULL THEN 'CNTRY' WHEN GM.GROUP_ID IS NOT NULL THEN 'GROUP' END PARENT_LIMIT_SUFFIX,--CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_3_PARENT END
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_3 IS NOT NULL 
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= LM.level_3
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
       LEFT JOIN GROUP_MASTER_O_TABLE GM ON TRIM(REPORTING_GROUP_ID) = TRIM(HHGRP)
       LEFT JOIN IBD_CUSTOMER ON IBD_CUSTOMER.FIN_CIF_ID = CIF.fin_cif_id AND TRIM(HHCNA) IS NOT NULL AND TRIM(HHGRP) IS NULL
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
 WHERE  --HH.HHLED > get_param ('EODCYYMMDD')AND
       CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1';
        
commit;       



--LEVEL 1 (BANK GROUP LIMIT)
INSERT INTO LIMIT_CORE_TEMP_TABLE
SELECT DISTINCT HH.HHLC LIMIT_CAT,
       HPLSTR LIMIT_STRUCTURE,
       TRIM(GH.GROUP_ID) BORROWER_NAME,
       '1' NODE_LEVEL,
       TRIM(GH.GROUP_ID) LIMIT_PREFIX,
       CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_1 END LIMIT_SUFFIX,
       LS.LIMIT_SUFFIX_DESC LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       HH.HHCNA PARENT_LIMIT_PREFIX,--NEED TO PUT GROUP NAME
       'CNTRY' PARENT_LIMIT_SUFFIX,--CASE WHEN TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%'  THEN LM.level_3_PARENT END
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when CONV_TO_VALID_DATE(get_date_fm_btrv(trim(CRC1_UGDTE)),'yyyymmdd') is not null then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(CRC1_UGDTE),'yyyymmdd'),'DD-MM-YYYY') 
            when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') 
            else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'G' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SC.SCC3R Purpose_of_limit,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON hhcus = hpcus AND NVL (hhclc, ' ') = NVL (hpclc, ' ')
       INNER JOIN map_cif CIF
          ON hhcus = gfcus AND NVL (hhclc, ' ') = NVL (gfclc, ' ')
       INNER JOIN limit_mapping LM
          ON  TRIM(LM.LIMIT_LINE) LIKE '%'||TRIM(HH.HHLC)||'%' AND hplstr = LIMIT_STRUCTURE AND LM.level_1 IS NOT NULL 
       INNER JOIN GROUP_MASTER_O_TABLE GH ON TRIM(GH.REPORTING_GROUP_ID) = TRIM(HH.HHGRP)
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= LM.level_1
       left join SCPF SC on CIF.fin_cif_id = SCAB||SCAN||SCAS
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY
	   left join YCRLC1LF02_MIG on trim(hhcus) = trim(CRC1_CUS) AND NVL (trim(hhclc), ' ') = NVL (trim(CRC1_CLC), ' ')  and trim(hhlc) = trim(CRC1_LC)
  WHERE CASE WHEN LM.IS_ZERO_LIMIT_REQ ='1' THEN '1' ELSE  CASE WHEN HH.hhama <> 0 THEN '1' ELSE '0' END END ='1'
 ;
  
COMMIT;       

UPDATE LIMIT_CORE_TEMP_TABLE SET LIMIT_SUFFIX=CASE WHEN CRNCY_CODE='KWD' THEN 'SYLHC' ELSE 'SYLFC' END WHERE LIMIT_SUFFIX ='SYLXX';

COMMIT;

UPDATE LIMIT_CORE_TEMP_TABLE SET LIMIT_SUFFIX=CASE WHEN CRNCY_CODE='KWD' THEN 'GETLH' ELSE 'GETLF' END WHERE LIMIT_SUFFIX ='GETXX';

COMMIT;

UPDATE LIMIT_CORE_TEMP_TABLE SET LIMIT_SUFFIX=CASE WHEN CRNCY_CODE='KWD' THEN 'GELLH' ELSE 'GELLF' END WHERE LIMIT_SUFFIX ='GELXX';

COMMIT;

--Substracting GECNC sanction amount from GECSH
update LIMIT_CORE_TEMP_TABLE x set x.SANCTION_LIMIT = (select SANCTION_LIMIT from(
select a.limit_prefix,a.limit_suffix,a.SANCTION_LIMIT-b.SANCTION_LIMIT SANCTION_LIMIT from 
(select * from LIMIT_CORE_TEMP_TABLE where LIMIT_SUFFIX='GECSH') a
inner join ((select * from LIMIT_CORE_TEMP_TABLE where LIMIT_SUFFIX='GECNC')) b on a.limit_prefix = b.limit_prefix
) y where x.limit_prefix = y.limit_prefix and x.limit_suffix = y.limit_suffix)
where x.limit_prefix||x.limit_suffix in(
select a.limit_prefix||a.limit_suffix from 
(select * from LIMIT_CORE_TEMP_TABLE where LIMIT_SUFFIX='GECSH') a
inner join ((select * from LIMIT_CORE_TEMP_TABLE where LIMIT_SUFFIX='GECNC')) b on a.limit_prefix = b.limit_prefix
);
commit;

       
TRUNCATE TABLE LIMIT_CORE_O_TABLE;
INSERT INTO LIMIT_CORE_O_TABLE
   SELECT BORROWER_NAME,
          NODE_LEVEL,
          LIMIT_PREFIX,
          LIMIT_SUFFIX,
          LIMIT_DESC,
          CRNCY_CODE,
          PARENT_LIMIT_PREFIX,
          PARENT_LIMIT_SUFFIX,
          SANCTION_LIMIT,
          DRAWING_POWER_IND,
          LIMIT_APPROVAL_DATE,
          LIMIT_EXPIRY_DATE,
          LIMIT_REVIEW_DATE,
          APPROVAL_AUTH_CODE,
          APPROVAL_LEVEL,
          LIMIT_APPROVAL_REF,
          NOTES,
          TERMS_AND_CONDITIONS,
          LIMIT_TYPE,
          LOAN_TYPE,
          MASTER_LIMIT_NODE,
          MIN_COLL_VALUE_BASED_ON,
          DRWNG_POWER_PCNT,
          PATTERN_OF_FUNDING,
          DEBIT_ACCOUNT_FOR_FEES,
          COMMITTED_LINES,
          CONTRACT_SIGN_DATE,
          UPLOAD_STATUS,
          COND_PRECEDENT_FLG,
          GLOBAL_LIMIT_FLG,
          MAIN_PRODUCT_TYPE,
          PROJECT_NAME,
          PRODUCT_NAME,
          PURPOSE_OF_LIMIT,
          BANK_ID
     FROM LIMIT_CORE_TEMP_TABLE -- WHERE to_date(LIMIT_EXPIRY_DATE,'DD-MM-YYYY')>to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
     ;
COMMIT;    



--DELETE FROM LIMIT_CORE_O_TABLE A WHERE NOT EXISTS (
--SELECT 1 FROM (
--select TRIM(CIF_ID) BORROWER_NAME from tf001
--union all
--select TRIM(DC_CIF_ID) from tf004
--union all
--select TRIM(CIF_ID) BORROWER_NAME from tf001_risk
--) B WHERE  A.BORROWER_NAME = B.BORROWER_NAME
--) and SANCTION_LIMIT='0';

--delete from LIMIT_CORE_O_TABLE where NODE_LEVEL !='7' and SANCTION_LIMIT='0';

--update LIMIT_CORE_O_TABLE set PARENT_LIMIT_PREFIX='' , PARENT_LIMIT_SUFFIX='' where NODE_LEVEL ='7' and SANCTION_LIMIT='0';

--COMMIT;



DROP TABLE CIF_GROUPS_DATA_MIG;

CREATE TABLE CIF_GROUPS_DATA_MIG AS SELECT * FROM CIF_GROUPS_DATA;

UPDATE CIF_GROUPS_DATA_MIG SET ENTITY_NAME='',ENTITY_REPORTING_ID='',ENTITY_ID='' WHERE ENTITY_NAME NOT IN(select a.ENTITY_NAME from (
(select ENTITY_NAME ,count(*) no_of_cif from CIF_GROUPS_DATA where ENTITY_NAME is not null group by ENTITY_NAME) a
inner join (
SELECT ENTITY_NAME,count(*) no_of_cif_limit FROM CIF_GROUPS_DATA 
INNER JOIN (SELECT DISTINCT LIMIT_PREFIX FROM LIMIT_CORE_TEMP_TABLE) ON LIMIT_PREFIX = ACCOUNT_NO 
GROUP BY ENTITY_NAME
) b on a.ENTITY_NAME = b.ENTITY_NAME
)
where --NO_OF_CIF = no_of_cif_limit and
 NO_OF_CIF != 1 and no_of_cif_limit!=1
);

UPDATE CIF_GROUPS_DATA_MIG SET GROUP_NAME='',GROUP_REPORTING_ID='',GROUP_ID='' WHERE GROUP_NAME NOT IN(
select a.GROUP_NAME from (
(select GROUP_NAME ,count(*) no_of_cif from CIF_GROUPS_DATA where GROUP_NAME is not null group by GROUP_NAME) a
inner join (
SELECT GROUP_NAME,count(*) no_of_cif_limit FROM CIF_GROUPS_DATA 
INNER JOIN (SELECT DISTINCT LIMIT_PREFIX FROM LIMIT_CORE_TEMP_TABLE) ON LIMIT_PREFIX = ACCOUNT_NO 
GROUP BY GROUP_NAME
) b on a.GROUP_NAME = b.GROUP_NAME
)
where NO_OF_CIF != 1 and no_of_cif_limit!=1
);

commit;


--LEVEL 2 (ENTITY LIMIT)
INSERT INTO LIMIT_CORE_O_TABLE
SELECT ENTITY_ID BORROWER_NAME,
       '2' NODE_LEVEL,
       ENTITY_ID LIMIT_PREFIX,
       'ENTTY' LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       CRNCY_CODE CRNCY_CODE,
       TRIM(GROUP_ID) PARENT_LIMIT_PREFIX,
       CASE WHEN TRIM(GROUP_ID) IS NOT NULL THEN 'GROUP' END PARENT_LIMIT_SUFFIX,
       SANCTION_LIMIT SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       LIMIT_APPROVAL_DATE LIMIT_APPROVAL_DATE,
       LIMIT_EXPIRY_DATE LIMIT_EXPIRY_DATE,
       LIMIT_REVIEW_DATE LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'G' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (SELECT TRIM(ENTITY_ID) ENTITY_ID,SANCTION_LIMIT SANCTION_LIMIT,
       'L2- Entity Limit' LIMIT_SUFFIX_DESC,
       LIMIT_EXPIRY_DATE, 
       LIMIT_REVIEW_DATE,
       LIMIT_APPROVAL_DATE,
       CRNCY_CODE,
       TRIM(GROUP_ID) GROUP_ID
       FROM CIF_GROUPS_DATA_MIG
       INNER JOIN MAP_CIF CIF ON TRIM(ACCOUNT_NO )= CIF.GFBRNM || CIF.GFCUS
       INNER JOIN LIMIT_CORE_O_TABLE LC ON LC.BORROWER_NAME = TRIM(ACCOUNT_NO) AND LC.NODE_LEVEL = '3'
       WHERE TRIM(ENTITY_ID) IS NOT NULL
       );
commit;       



UPDATE LIMIT_CORE_O_TABLE A SET (A.PARENT_LIMIT_SUFFIX,A.PARENT_LIMIT_PREFIX)=(
SELECT DISTINCT LIMIT_SUFFIX,ENTITY_ID FROM (
SELECT 'ENTTY' LIMIT_SUFFIX,TO_CHAR(TRIM(ACCOUNT_NO)) ACCOUNT_NO,TO_CHAR(TRIM(ENTITY_ID))ENTITY_ID  FROM CIF_GROUPS_DATA_MIG WHERE ENTITY_ID IS NOT NULL
UNION
SELECT 'GROUP',TO_CHAR(TRIM(ACCOUNT_NO)) ACCOUNT_NO,TO_CHAR(TRIM(GROUP_ID))GROUP_ID FROM CIF_GROUPS_DATA_MIG WHERE ENTITY_ID IS NULL AND GROUP_ID IS NOT NULL
) B WHERE A.BORROWER_NAME  = B.ACCOUNT_NO)
WHERE NODE_LEVEL='3' AND PARENT_LIMIT_PREFIX IS NULL;
UPDATE LIMIT_CORE_O_TABLE SET PARENT_LIMIT_SUFFIX='' WHERE PARENT_LIMIT_PREFIX IS NULL;

COMMIT;

--LEVEL 1 (GROUP LIMIT)
INSERT INTO LIMIT_CORE_O_TABLE
SELECT DISTINCT GROUP_ID BORROWER_NAME,
       '1' NODE_LEVEL,
       GROUP_ID LIMIT_PREFIX,
       'GROUP' LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       CRNCY_CODE CRNCY_CODE,
       '' PARENT_LIMIT_PREFIX,
       '' PARENT_LIMIT_SUFFIX,
       SANCTION_LIMIT SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       LIMIT_APPROVAL_DATE LIMIT_APPROVAL_DATE,
       LIMIT_EXPIRY_DATE LIMIT_EXPIRY_DATE,
       LIMIT_REVIEW_DATE LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'G' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (SELECT DISTINCT TRIM(GROUP_ID) GROUP_ID,SANCTION_LIMIT SANCTION_LIMIT,LC.BORROWER_NAME,
       'L1- Group Limit' LIMIT_SUFFIX_DESC,
       LIMIT_EXPIRY_DATE, 
       LIMIT_REVIEW_DATE,
       LIMIT_APPROVAL_DATE,
       CRNCY_CODE
       FROM CIF_GROUPS_DATA_MIG
       INNER JOIN LIMIT_CORE_O_TABLE LC ON LC.PARENT_LIMIT_PREFIX = TRIM(GROUP_ID) AND LC.NODE_LEVEL IN( '2','3') AND LC.PARENT_LIMIT_SUFFIX='GROUP'
       );
COMMIT;    


--LEVEL 0 (COUNTRY LIMIT)
INSERT INTO LIMIT_CORE_O_TABLE
SELECT  DISTINCT 
       TRIM(HHCNA) BORROWER_NAME,
       '0' NODE_LEVEL,
       TRIM(HHCNA)LIMIT_PREFIX,
       'CNTRY' LIMIT_SUFFIX,
       'L0-Country Limit' LIMIT_DESC,
       HH.HHCCY CRNCY_CODE,
       '' PARENT_LIMIT_PREFIX,
       '' PARENT_LIMIT_SUFFIX,
       to_number(HH.HHAMA)/C8.C8PWD SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       case when HP.HPAUD!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPAUD),'yyyymmdd'),'DD-MM-YYYY') else TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HP.HPDLM),'yyyymmdd'),'DD-MM-YYYY') end LIMIT_APPROVAL_DATE,
       case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE,
       case when HH.HHLED!='0' then TO_CHAR((CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd')-1),'DD-MM-YYYY') else null end LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,--Parant Level
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       '' Limit_Type,
       'N'  Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       get_param('BANK_ID')
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON trim(HPCNA) = trim(HHCNA) AND TRIM(HPCNA) IS NOT NULL AND TRIM(HPGRP) IS NULL
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY	   
 WHERE  trim(HHLC)='LG156' AND HHAMA <> 0 AND TRIM(HHCNA) IS NOT NULL AND TRIM(HHGRP) IS NULL and trim(HHCUS)  is null;
 
 COMMIT;

DECLARE
V_CCY_CNT NUMBER;
   CURSOR c1
   IS
        SELECT NODE_LEVEL,LIMIT_PREFIX,LIMIT_SUFFIX,MAX(CONV_TO_VALID_DATE(LIMIT_EXPIRY_DATE,'DD-MM-YYYY')) LIMIT_EXPIRY_DATE FROM LIMIT_CORE_O_TABLE GROUP BY NODE_LEVEL,LIMIT_PREFIX,LIMIT_SUFFIX HAVING COUNT(*)>1 order by NODE_LEVEL desc;
BEGIN

   FOR l_record IN c1
   LOOP
        SELECT COUNT(DISTINCT CRNCY_CODE) INTO V_CCY_CNT FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX;
   
        IF V_CCY_CNT = 1 THEN 
            
            UPDATE LIMIT_CORE_O_TABLE SET NOTES='U' ,SANCTION_LIMIT = (SELECT SUM(to_number(SANCTION_LIMIT)) FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX 
            AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX ) 
            WHERE  LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX AND CONV_TO_VALID_DATE(LIMIT_EXPIRY_DATE,'DD-MM-YYYY') = l_record.LIMIT_EXPIRY_DATE AND ROWNUM =1 ;
            COMMIT;
            
            delete from LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX and trim(NOTES) is null;
            
            --DELETE FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX AND SANCTION_LIMIT != (
            --SELECT MAX(TO_NUMBER(SANCTION_LIMIT)) FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX);                                                                              
            COMMIT;
            
        ELSE 
            UPDATE LIMIT_CORE_O_TABLE SET  NOTES='U' ,CRNCY_CODE= CASE WHEN GET_PARAM('BANK_ID') = '01' THEN 'KWD' WHEN GET_PARAM('BANK_ID') = '02' THEN 'AED' END ,
                                           SANCTION_LIMIT = (SELECT SUM(to_number(SANCTION_LIMIT) * TO_NUMBER (C8RTE)) FROM LIMIT_CORE_O_TABLE A
                                                             LEFT JOIN C8PF B ON A.CRNCY_CODE = B.C8CCY
                                                                WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX
                                                                  )
                        WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX AND CONV_TO_VALID_DATE(LIMIT_EXPIRY_DATE,'DD-MM-YYYY') = l_record.LIMIT_EXPIRY_DATE 
                        AND ROWNUM =1;
            COMMIT;
                              
            delete from LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX and trim(NOTES) is null;
            
           -- DELETE FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX=l_record.LIMIT_SUFFIX AND (SANCTION_LIMIT != (
           -- SELECT MAX(TO_NUMBER(SANCTION_LIMIT)) FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX=l_record.LIMIT_PREFIX AND LIMIT_SUFFIX='GEREV' 
           -- and CRNCY_CODE = CASE WHEN GET_PARAM('BANK_ID') = '01' THEN 'KWD' WHEN GET_PARAM('BANK_ID') = '02' THEN 'AED' END) or 
           -- CRNCY_CODE != CASE WHEN GET_PARAM('BANK_ID') = '01' THEN 'KWD' WHEN GET_PARAM('BANK_ID') = '02' THEN 'AED' END);                                                              
           COMMIT;
        END IF;
        
   END LOOP;

   COMMIT;
END;

update LIMIT_CORE_O_TABLE set NOTES='';
commit;

DROP TABLE LIMIT_CORE_O_TABLE_BCK;

CREATE TABLE LIMIT_CORE_O_TABLE_BCK AS SELECT DISTINCT * FROM LIMIT_CORE_O_TABLE;
--COMMIT;

TRUNCATE TABLE LIMIT_CORE_O_TABLE;

INSERT INTO LIMIT_CORE_O_TABLE SELECT * FROM LIMIT_CORE_O_TABLE_BCK;
COMMIT;



DECLARE
V_CCY_CNT NUMBER;
   CURSOR c1
   IS
        SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,SUM(TO_NUMBER(SANCTION_LIMIT)) SANCTION_LIMIT  FROM LIMIT_CORE_O_TABLE 
            WHERE PARENT_LIMIT_PREFIX||PARENT_LIMIT_SUFFIX IN ( SELECT LIMIT_PREFIX||LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE  SANCTION_LIMIT='0')
            GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX having SUM(TO_NUMBER(SANCTION_LIMIT)) >0;

BEGIN

   FOR l_record IN c1
   LOOP
        SELECT COUNT(DISTINCT CRNCY_CODE) INTO V_CCY_CNT FROM LIMIT_CORE_O_TABLE WHERE  PARENT_LIMIT_SUFFIX=l_record.PARENT_LIMIT_SUFFIX and PARENT_LIMIT_PREFIX=l_record.PARENT_LIMIT_PREFIX ;
   
        IF V_CCY_CNT = 1 THEN 
            
             UPDATE LIMIT_CORE_O_TABLE A SET A.SANCTION_LIMIT = (
                SELECT SUM(TO_NUMBER(SANCTION_LIMIT)) FROM LIMIT_CORE_O_TABLE 
                LEFT JOIN C8PF B ON CRNCY_CODE = B.C8CCY
                WHERE PARENT_LIMIT_SUFFIX=l_record.PARENT_LIMIT_SUFFIX and PARENT_LIMIT_PREFIX=l_record.PARENT_LIMIT_PREFIX 
                ) where  LIMIT_SUFFIX = l_record.PARENT_LIMIT_SUFFIX and  LIMIT_PREFIX=l_record.PARENT_LIMIT_PREFIX;
            commit;
            
        ELSE 
            UPDATE LIMIT_CORE_O_TABLE A SET A.CRNCY_CODE= CASE WHEN GET_PARAM('BANK_ID') = '01' THEN 'KWD' WHEN GET_PARAM('BANK_ID') = '02' THEN 'AED' END ,A.SANCTION_LIMIT = (
                SELECT SUM(TO_NUMBER(SANCTION_LIMIT) * TO_NUMBER (C8RTE)) SANCTION_LIMIT  FROM LIMIT_CORE_O_TABLE 
                LEFT JOIN C8PF B ON CRNCY_CODE = B.C8CCY
                WHERE PARENT_LIMIT_SUFFIX=l_record.PARENT_LIMIT_SUFFIX and PARENT_LIMIT_PREFIX=l_record.PARENT_LIMIT_PREFIX 
                ) where  LIMIT_SUFFIX = l_record.PARENT_LIMIT_SUFFIX and  LIMIT_PREFIX=l_record.PARENT_LIMIT_PREFIX;
            commit;
        END IF;
        
   END LOOP;

END;

COMMIT;

DELETE FROM LIMIT_CORE_O_TABLE WHERE LIMIT_SUFFIX='GECSH' AND SANCTION_LIMIT='0' 
AND  (LIMIT_PREFIX||LIMIT_SUFFIX) NOT IN(
SELECT B.LIMIT_PREFIX||B.LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE  A
INNER JOIN (SELECT LIMIT_PREFIX,LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE LIMIT_SUFFIX='GECSH' AND SANCTION_LIMIT='0') B ON A.PARENT_LIMIT_PREFIX = B.LIMIT_PREFIX AND A.PARENT_LIMIT_SUFFIX = B.LIMIT_SUFFIX
);
COMMIT;

UPDATE LIMIT_CORE_O_TABLE SET SANCTION_LIMIT='0.001' WHERE SANCTION_LIMIT='0';
COMMIT;


delete from LIMIT_CORE_O_TABLE  where borrower_name='0603762840' and LIMIT_SUFFIX='GELCU' and PARENT_LIMIT_PREFIX is null;
commit;

update LIMIT_CORE_O_TABLE a set LIMIT_DESC=(select trim(LIMIT_SUFFIX_DESC) from LIMIT_SUFFIX_CODE_AND_DESC b where b.LIMIT_SUFFIX_CODE = a.limit_suffix) where  LIMIT_DESC is null;
commit;

--update LIMIT_CORE_O_TABLE set LIMIT_DESC='L'||NODE_LEVEL||'-'||LIMIT_SUFFIX where  LIMIT_DESC is null;
--commit;


--CHANGED ON 22-07-2117

--update LIMIT_CORE_O_TABLE set LIMIT_REVIEW_DATE = to_char(to_date(LIMIT_EXPIRY_DATE,'dd-mm-yyyy')-1,'dd-mm-yyyy') where to_date(LIMIT_EXPIRY_DATE,'dd-mm-yyyy') = to_date(LIMIT_REVIEW_DATE,'dd-mm-yyyy');
--commit;



--UPDATE LIMIT_CORE_O_TABLE A SET (LIMIT_EXPIRY_DATE ,LIMIT_REVIEW_DATE)=(SELECT LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM (SELECT BORROWER_NAME,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM LIMIT_CORE_O_TABLE B WHERE BORROWER_NAME IN(
--SELECT BORROWER_NAME FROM LIMIT_CORE_O_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND CONV_TO_VALID_DATE(B.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') < CONV_TO_VALID_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') and to_number(NODE_LEVEL)> 2)
--) AND  NODE_LEVEL='3') C WHERE  TRIM(A.BORROWER_NAME) = TRIM(C.BORROWER_NAME) ) 
--WHERE A.BORROWER_NAME IN(
--SELECT BORROWER_NAME FROM LIMIT_CORE_O_TABLE B WHERE  EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE A WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND CONV_TO_VALID_DATE(B.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') < CONV_TO_VALID_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY')) and  to_number(NODE_LEVEL)> 2
--);
--commit;

--update LIMIT_CORE_O_TABLE set LIMIT_EXPIRY_DATE='31-05-2017',LIMIT_REVIEW_DATE='31-05-2017' where limit_prefix='KW';



TRUNCATE TABLE LIMIT_ENTITY_AND_GROUP_MAP;     
INSERT INTO LIMIT_ENTITY_AND_GROUP_MAP 
select DISTINCT ENTITY_ID,ENTITY_NAME,ENTITY_REPORTING_ID,GROUP_ID,GROUP_NAME,GROUP_REPORTING_ID from CIF_GROUPS_DATA_MIG where ENTITY_NAME is not null AND GROUP_NAME IS NOT NULL ORDER BY GROUP_NAME;
COMMIT;


--NEED TO CHECK
--DELETE FROM LIMIT_CORE_O_TABLE WHERE BORROWER_NAME IN (
--SELECT BORROWER_NAME FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='1'
--MINUS
--SELECT DISTINCT PARENT_LIMIT_PREFIX FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='2' AND PARENT_LIMIT_PREFIX IS NOT NULL
--) AND NODE_LEVEL='1';
--COMMIT;

--------------------------------------------------------------------------------------


--update LIMIT_CORE_O_TABLE set PARENT_LIMIT_PREFIX='',PARENT_LIMIT_SUFFIX='' where limit_prefix='GRP793';--exception *******
--update LIMIT_CORE_O_TABLE set  LIMIT_EXPIRY_DATE='31-03-2018',LIMIT_REVIEW_DATE='30-03-2018' where BORROWER_NAME='KW';--exception *******

-----------------------------------------------------------------------------------------

truncate table BANK_RISK_PART_DATA;

insert into BANK_RISK_PART_DATA
select LIMIT_PREFIX, CRNCY_CODE, SANCTION_LIMIT, LIMIT_APPROVAL_DATE, LIMIT_EXPIRY_DATE, LIMIT_REVIEW_DATE from
LIMIT_CORE_temp_TABLE where LIMIT_STRUCTURE='BANKL' and LIMIT_SUFFIX='CUSTL' and PARENT_LIMIT_SUFFIX='GROUP';
 commit;

--MANUAL RISK PARTICIPATION LIMIT

INSERT INTO LIMIT_CORE_O_TABLE
SELECT a.LIMIT_PREFIX BORROWER_NAME,
       a.NODE_LEVEL,
       a.LIMIT_PREFIX,
       a.LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       a.CRNCY_CODE,
       a.PARENT_LIMIT_PREFIX,
       a.PARENT_LIMIT_SUFFIX,
       A.SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       a.LIMIT_APPROVAL_DATE,
       a.LIMIT_EXPIRY_DATE,
       a.LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (
       SELECT '7' NODE_LEVEL, LIMIT_PREFIX, 'RPBLG' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPTLG' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT ,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '7' NODE_LEVEL, LIMIT_PREFIX, 'RPBLC' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPTLC' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '7' NODE_LEVEL, LIMIT_PREFIX, 'RPBLO' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPBNL' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '6' NODE_LEVEL,LIMIT_PREFIX, 'RPTLG' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPNSH' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '6' NODE_LEVEL,LIMIT_PREFIX, 'RPTLC' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPNSH' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '6' NODE_LEVEL,LIMIT_PREFIX, 'RPBNL' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPNSH' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '5' NODE_LEVEL,LIMIT_PREFIX, 'RPNSH' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'RPATL' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '4' NODE_LEVEL,LIMIT_PREFIX, 'RPATL' LIMIT_SUFFIX, CRNCY_CODE, LIMIT_PREFIX PARENT_LIMIT_PREFIX , 'CUSTL' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       UNION ALL
       SELECT '3' NODE_LEVEL,LIMIT_PREFIX, 'CUSTL' LIMIT_SUFFIX, CRNCY_CODE, '' PARENT_LIMIT_PREFIX , '' PARENT_LIMIT_SUFFIX, SANCTION_LIMIT,LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM BANK_RISK_PART_DATA A
       ) A
       left join LIMIT_CORE_O_TABLE b on a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= a.LIMIT_SUFFIX
       where b.limit_prefix is null  ;
COMMIT;       




----CLA LIMIT(COMMITMENT)

drop table  COMMITMENT_LIMIT_DATA;

create table  COMMITMENT_LIMIT_DATA as
SELECT DISTINCT LCCMR,LCCCY, ORG_COMMITMENT_AMOUNT, LOAN_AMOUNT,COMMITMENT_TO_BE_DISB, LEG_INTERNAL_ACC_NUM ,
LEG_ACC_NUM, FIN_ACC_nUM, LEG_ACCT_TYPE,SCHM_CODE,FIN_CIF_ID,SCC2R--, G.SCC2R 
, expiry_date, First_drawdown_date ,
LIMIT_SUFFIX||(dense_rank() over(partition by FIN_CIF_ID,LIMIT_SUFFIX order by LCCMR ))
     LIMIT_SUFFIX,
      PARENT_LIMIT_SUFFIX
FROM (
select LCCMR,LCCCY,LCAMT/POWER(10,C8CED) ORG_COMMITMENT_AMOUNT,OTDLA/POWER(10,C8CED) LOAN_AMOUNT, LCAMTU/POWER(10,C8CED) COMMITMENT_TO_BE_DISB,LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS LEG_INTERNAL_ACC_NUM ,
to_char(LEG_ACC_NUM)LEG_ACC_NUM, FIN_ACC_nUM, LEG_ACCT_TYPE,SCHM_CODE,FIN_CIF_ID,C.SCC2R,
CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(LCDTEX),'YYYYMMDD')   expiry_date,CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(LCDTEF),'YYYYMMDD')   First_drawdown_date,
CASE WHEN TRIM(SCHM_CODE)='LF' AND LCCCY='KWD' THEN 'GTLH'
     WHEN TRIM(SCHM_CODE)='LF' AND LCCCY!='KWD' THEN 'GTLF'
     WHEN TRIM(SCHM_CODE)='LFR' AND LCCCY='KWD' THEN 'GRVH'
     WHEN TRIM(SCHM_CODE)='LFR' AND LCCCY!='KWD' THEN 'GRVF'
     WHEN TRIM(SCHM_CODE) in('LD','LDADV') AND LCCCY='KWD' THEN 'GLLH'
     WHEN TRIM(SCHM_CODE) in('LD','LDADV') AND LCCCY!='KWD' THEN 'GLLF'
     WHEN TRIM(SCHM_CODE) LIKE 'S%' AND LCCCY ='KWD' THEN 'SYLH'
     WHEN TRIM(SCHM_CODE) LIKE 'S%' AND LCCCY !='KWD' THEN 'SYLF'
     END LIMIT_SUFFIX,
     CASE WHEN TRIM(SCHM_CODE)='LF' THEN 'GETTL'
     WHEN TRIM(SCHM_CODE)='LFR' THEN 'GEREV'
     WHEN TRIM(SCHM_CODE) in('LD','LDADV') THEN 'GETLL'
     WHEN TRIM(SCHM_CODE) LIKE 'S%' THEN 'SYLOA'
     END PARENT_LIMIT_SUFFIX
FROM (select LEG_BRANCH_ID,LEG_SCAN,LEG_SCAS,case when SCHM_TYPE='PCA' then V5BRNM||V5DLP||V5DLR else to_nchar(LEG_ACC_NUM) end  LEG_ACC_NUM,FIN_CIF_ID,LEG_ACCT_TYPE,FIN_ACC_nUM,SCHM_TYPE,SCHM_CODE
FROM MAP_ACC 
left join v5pf on v5abd||V5AND||v5asd = LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS and SCHM_TYPE='PCA'
where SCHM_TYPE in('PCA','CLA') AND SCHM_CODE NOT IN ('BDT','LAC','CLM','WK')) 
LEFT  JOIN LDPF ON TRIM(LDBRNM)||TRIM(LDDLP)||TRIM(LDDLR)=TRIM(LEG_ACC_NUM)
LEFT JOIN  LCPF ON TRIM(LCCMR)=TRIM(LDCMR) and TRIM(LCAMT) <> 0
left JOIN C8PF ON LCCCY=C8CCY
INNER JOIN SCPF G ON G.SCAB||G.sCAN||G.SCAS=LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
left join SCPF C ON C.SCAB||C.sCAN||C.SCAS=LCABC||LCANC||LCASC
LEFT  JOIN OTPF ON OTBRNM||TRIM(OTDLP)||TRIM(OTDLR)=LEG_ACC_NUM
WHERE trim(LCCMR) is not null
union
select DISTINCT LCCMR,LCCCY,LCAMT/POWER(10,C8CED) ORG_COMMITMENT_AMOUNT,OTDLA/POWER(10,C8CED) LOAN_AMOUNT, LCAMTU/POWER(10,C8CED) COMMITMENT_TO_BE_DISB,LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS LEG_INTERNAL_ACC_NUM ,
to_char(LEG_ACC_NUM)LEG_ACC_NUM, FIN_ACC_nUM, LEG_ACCT_TYPE,SCHM_CODE,map_cif.FIN_CIF_ID,C.SCC2R
,CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(LCDTEX),'YYYYMMDD')   expiry_date,CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(LCDTEF),'YYYYMMDD')   First_drawdown_date,
CASE 
     WHEN TRIM(LCCMR) like 'LFR%' AND LCCCY='KWD' THEN 'GRVH'
     WHEN TRIM(LCCMR) like 'LFR%' AND LCCCY!='KWD' THEN 'GRVF'
     WHEN TRIM(LCCMR) like 'LD%' AND LCCCY='KWD' THEN 'GLLH'
     WHEN TRIM(LCCMR) like 'LD%' AND LCCCY!='KWD' THEN 'GLLF'
     WHEN TRIM(LCCMR) like 'LF%' AND LCCCY='KWD' THEN 'GTLH'
     WHEN TRIM(LCCMR) like 'LF%' AND LCCCY!='KWD' THEN 'GTLF'
     WHEN TRIM(LCCMR) LIKE 'S%' AND LCCCY ='KWD' THEN 'SYLH'
     WHEN TRIM(LCCMR) LIKE 'S%' AND LCCCY !='KWD' THEN 'SYLF'
     END LIMIT_SUFFIX,
     CASE WHEN TRIM(LCCMR) like 'LFR%' THEN 'GEREV'
     WHEN TRIM(LCCMR) like 'LF%' THEN 'GETTL'
     WHEN TRIM(LCCMR) like 'LD%' THEN 'GETLL'
     WHEN TRIM(LCCMR) LIKE 'S%' THEN 'SYLOA'
     END PARENT_LIMIT_SUFFIX
from lcpf 
left join c8pf on c8ccy = LCCCY
LEFT JOIN  LDPF ON TRIM(LCCMR)=TRIM(LDCMR)
left join map_cif on gfclc||gfcus = trim(lcclc)||trim(lccus)
left join map_acc on  TRIM(LDBRNM)||TRIM(LDDLP)||TRIM(LDDLR)=TRIM(LEG_ACC_NUM)
--INNER JOIN SCPF G ON G.SCAB||G.sCAN||G.SCAS=LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS
left join SCPF C ON C.SCAB||C.sCAN||C.SCAS=LCABC||LCANC||LCASC
LEFT  JOIN OTPF ON OTBRNM||TRIM(OTDLP)||TRIM(OTDLR)=LEG_ACC_NUM
where lcamt= LCAMTU and lcamt <> 0);


truncate table LIMIT_CORE_O_TABLE_CLA;

INSERT INTO LIMIT_CORE_O_TABLE_CLA
SELECT distinct a.FIN_CIF_ID BORROWER_NAME,
       '7' NODE_LEVEL,
       a.FIN_CIF_ID LIMIT_PREFIX,
       a.LIMIT_SUFFIX LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       LCCCY CRNCY_CODE,
       a.FIN_CIF_ID PARENT_LIMIT_PREFIX,
       a.PARENT_LIMIT_SUFFIX,
       A.ORG_COMMITMENT_AMOUNT SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       TO_CHAR(FIRST_DRAWDOWN_DATE,'DD-MM-YYYY') LIMIT_APPROVAL_DATE,
       nvl(b.LIMIT_EXPIRY_DATE,GET_PARAM('EOD_DATE')) LIMIT_EXPIRY_DATE,
       nvl(b.LIMIT_REVIEW_DATE,TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY')) LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       LCCMR NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       SCC2R Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (select LCCMR,FIN_CIF_ID,LCCCY,EXPIRY_DATE,FIRST_DRAWDOWN_DATE,LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,SCC2R,avg(ORG_COMMITMENT_AMOUNT) ORG_COMMITMENT_AMOUNT from COMMITMENT_LIMIT_DATA        
       group by LCCMR,FIN_CIF_ID,LCCCY,EXPIRY_DATE,FIRST_DRAWDOWN_DATE,LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,SCC2R) A
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= a.LIMIT_SUFFIX
       left join limit_core_o_table b on FIN_CIF_ID = limit_prefix and a.PARENT_LIMIT_SUFFIX = b.PARENT_LIMIT_SUFFIX;
       
       commit;
       
       
--drop table cla_cif_suffix;
       
--create table cla_cif_suffix as
--select a.LIMIT_PREFIX,a.PARENT_LIMIT_SUFFIX from (   
--       SELECT LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,sum(SANCTION_LIMIT*c8rte) commitment_amount FROM LIMIT_CORE_O_TABLE_CLA
--       left join c8pf on c8ccy = CRNCY_CODE
--        GROUP BY LIMIT_PREFIX,PARENT_LIMIT_SUFFIX
--       ) a
--       inner join (
--       select LIMIT_PREFIX,LIMIT_SUFFIX ,LIMIT_DESC,sum(SANCTION_LIMIT*c8rte)  SANCTION_LIMIT from LIMIT_CORE_INFY_TABLE 
--       left join c8pf on c8ccy = CRNCY_CODE 
--       where NODE_LEVEL='6' and limit_suffix in('GETTL','GEREV','GETLL','SYLOA')
--       group by LIMIT_PREFIX,LIMIT_SUFFIX ,LIMIT_DESC
--       ) b on a.LIMIT_PREFIX = b.LIMIT_PREFIX and a.PARENT_LIMIT_SUFFIX = b.LIMIT_SUFFIX
--       --where  round(a.commitment_amount-b.SANCTION_LIMIT,0) = 0 
--       ;   
--       
--delete LIMIT_CORE_O_TABLE where PARENT_LIMIT_PREFIX||PARENT_LIMIT_SUFFIX in(select LIMIT_PREFIX||PARENT_LIMIT_SUFFIX from cla_cif_suffix);
--commit;

--insert into LIMIT_CORE_O_TABLE
--select * from LIMIT_CORE_O_TABLE_CLA where PARENT_LIMIT_PREFIX||PARENT_LIMIT_SUFFIX in(select LIMIT_PREFIX||PARENT_LIMIT_SUFFIX from cla_cif_suffix);
--commit;


TRUNCATE TABLE MISSING_LIMIT_DIFF_CLA;

insert into MISSING_LIMIT_DIFF_CLA
select a.LIMIT_PREFIX,case when a.PARENT_LIMIT_SUFFIX='GETTL' then 'GTLH0' 
                           when a.PARENT_LIMIT_SUFFIX='GEREV' then 'GRVH0'
                           when a.PARENT_LIMIT_SUFFIX='GETLL' then 'GLLH0'
                           when a.PARENT_LIMIT_SUFFIX='SYLOA' then 'SYLF0' end limit_suffix,
nvl(b.CRNCY_CODE,'KWD')crncy_code,round(NVL(abs(a.commitment_amount-b.SANCTION_LIMIT),a.commitment_amount)/c8rte,C8CED) SANCTION_LIMIT,a.PARENT_LIMIT_SUFFIX from (   
       SELECT LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,sum(SANCTION_LIMIT*c8rte) commitment_amount FROM LIMIT_CORE_O_TABLE_CLA
       left join c8pf on c8ccy = CRNCY_CODE
        GROUP BY LIMIT_PREFIX,PARENT_LIMIT_SUFFIX
       ) a
       LEFT join (
       select LIMIT_PREFIX,LIMIT_SUFFIX ,LIMIT_DESC,sum(SANCTION_LIMIT*c8rte)  SANCTION_LIMIT,CRNCY_CODE from LIMIT_CORE_O_TABLE 
       left join c8pf on c8ccy = CRNCY_CODE 
       where NODE_LEVEL='6' and limit_suffix in('GETTL','GEREV','GETLL','SYLOA')
       group by LIMIT_PREFIX,LIMIT_SUFFIX ,LIMIT_DESC,CRNCY_CODE
       ) b on a.LIMIT_PREFIX = b.LIMIT_PREFIX and a.PARENT_LIMIT_SUFFIX = b.LIMIT_SUFFIX
       left join c8pf on c8ccy =  nvl(b.CRNCY_CODE,'KWD')
       where  round(a.commitment_amount-b.SANCTION_LIMIT,0) < 0 ;

COMMIT;
       
INSERT INTO MISSING_LIMIT_DIFF_CLA       
       SELECT LIMIT_PREFIX,LIMIT_SUFFIX,CRNCY_CODE,SANCTION_LIMIT,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE_CLA A WHERE  NOT EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE SANCTION_LIMIT != 0 and
        A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX )  AND PARENT_LIMIT_PREFIX IS NOT NULL AND NODE_LEVEL='7';    
COMMIT;        
       
DELETE FROM LIMIT_CORE_O_TABLE WHERE (PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) IN(SELECT DISTINCT FIN_CIF_ID,PARENT_LIMIT_SUFFIX FROM COMMITMENT_LIMIT_DATA );
COMMIT;
       
INSERT INTO LIMIT_CORE_O_TABLE_CLA       
       SELECT a.LIMIT_PREFIX BORROWER_NAME,
       a.NODE_LEVEL,
       a.LIMIT_PREFIX,
       a.LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       A.CRNCY_CODE,
       a.PARENT_LIMIT_PREFIX,
       a.PARENT_LIMIT_SUFFIX,
       A.SANCTION_AMOUNT SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY') LIMIT_APPROVAL_DATE,
       GET_PARAM('EOD_DATE') LIMIT_EXPIRY_DATE,
       TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY') LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (
     SELECT DISTINCT '7' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(NEW_LIMIT_SUFFIX) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,A.PARENT_LIMIT_SUFFIX PARENT_LIMIT_SUFFIX,CRNCY_CODE,1*SANCTION_AMOUNT SANCTION_AMOUNT  FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT FROM MISSING_LIMIT_DIFF_CLA) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        union 
     select NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE, sum(SANCTION_AMOUNT) SANCTION_AMOUNT from(
        SELECT DISTINCT '6' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(c.LEVEL_6) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(c.LEVEL_6_PARENT) PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT  FROM MISSING_LIMIT_DIFF_CLA) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =  NVL(TRIM(b.LEVEL_7_PARENT),A.PARENT_LIMIT_SUFFIX)
        )group by NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE
        union
        select NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE, sum(SANCTION_AMOUNT) SANCTION_AMOUNT from( 
        SELECT DISTINCT '5' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(d.LEVEL_5) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(d.LEVEL_5_PARENT) PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT  FROM MISSING_LIMIT_DIFF_CLA) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =   NVL(TRIM(b.LEVEL_7_PARENT),A.PARENT_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        )group by NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE
        union
        select NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE, sum(SANCTION_AMOUNT) SANCTION_AMOUNT from(          
        SELECT DISTINCT '4' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(e.LEVEL_4) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(e.LEVEL_4_PARENT) PARENT_LIMIT_SUFFIX,CRNCY_CODE, SANCTION_AMOUNT FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT  FROM MISSING_LIMIT_DIFF_CLA) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =   NVL(TRIM(b.LEVEL_7_PARENT),A.PARENT_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        LEFT JOIN LIMIT_MAPPING e ON TRIM(e.LEVEL_4) =  TRIM(d.LEVEL_5_PARENT)
        )group by NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE
        union 
        select NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE, sum(SANCTION_AMOUNT) SANCTION_AMOUNT from( 
        SELECT DISTINCT '3' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(f.LEVEL_3) LIMIT_SUFFIX ,'' PARENT_LIMIT_PREFIX ,'' PARENT_LIMIT_SUFFIX,CRNCY_CODE, SANCTION_AMOUNT FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,PARENT_LIMIT_SUFFIX,CRNCY_CODE,SANCTION_AMOUNT  FROM MISSING_LIMIT_DIFF_CLA) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =   NVL(TRIM(b.LEVEL_7_PARENT),A.PARENT_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        LEFT JOIN LIMIT_MAPPING e ON TRIM(e.LEVEL_4) =  TRIM(d.LEVEL_5_PARENT)
        LEFT JOIN LIMIT_MAPPING f ON TRIM(f.LEVEL_3) =  TRIM(e.LEVEL_4_PARENT)
        )group by NODE_LEVEL, LIMIT_PREFIX, LIMIT_SUFFIX, PARENT_LIMIT_PREFIX, PARENT_LIMIT_SUFFIX, CRNCY_CODE
        ) a
        left join LIMIT_CORE_O_TABLE b on a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix --AND B.node_level!='7'
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= a.LIMIT_SUFFIX
       LEFT JOIN LIMIT_CORE_O_TABLE_CLA C ON a.limit_prefix = C.limit_prefix and a.limit_suffix = C.limit_suffix
       where b.limit_prefix is null AND c.limit_prefix is null;
commit;

update LIMIT_CORE_O_TABLE_CLA set LIMIT_DESC='L7- Gen Term Loan HCCY-diff Cmt' where LIMIT_SUFFIX='GLLH0' and LIMIT_DESC is null;
update LIMIT_CORE_O_TABLE_CLA set LIMIT_DESC='L7- Gen Rev Loan HCCY-diff Cmt' where LIMIT_SUFFIX='GRVH0' and LIMIT_DESC is null;
update LIMIT_CORE_O_TABLE_CLA set LIMIT_DESC='L7- Gen Term Loan HCCY-diff Cmt' where LIMIT_SUFFIX='GTLH0' and LIMIT_DESC is null;
update LIMIT_CORE_O_TABLE_CLA set LIMIT_DESC='L7- Syndication Loan HCCY-diff Cmt' where LIMIT_SUFFIX='SYLF0' and LIMIT_DESC is null;

--delete LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN (SELECT LIMIT_PREFIX,LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE_CLA);
--commit;

UPDATE LIMIT_CORE_O_TABLE_CLA A SET (LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) = (SELECT LIMIT_APPROVAL_DATE,LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE FROM(
SELECT A.LIMIT_PREFIX,A.LIMIT_SUFFIX,B.LIMIT_APPROVAL_DATE,B.LIMIT_EXPIRY_DATE,B.LIMIT_REVIEW_DATE FROM LIMIT_CORE_O_TABLE_CLA A
LEFT JOIN LIMIT_CORE_O_TABLE B ON A.PARENT_LIMIT_PREFIX = B.LIMIT_PREFIX AND A.PARENT_LIMIT_SUFFIX = B.LIMIT_SUFFIX 
 WHERE A.LIMIT_EXPIRY_DATE IS NULL  
 ) B WHERE A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX
 ) WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
 SELECT A.LIMIT_PREFIX,A.LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE_CLA A
LEFT JOIN LIMIT_CORE_O_TABLE B ON A.PARENT_LIMIT_PREFIX = B.LIMIT_PREFIX AND A.PARENT_LIMIT_SUFFIX = B.LIMIT_SUFFIX 
 WHERE A.LIMIT_EXPIRY_DATE IS NULL);

commit;
 
insert into LIMIT_CORE_O_TABLE
select * from LIMIT_CORE_O_TABLE_CLA ;
commit;


-- ODA ZERO LIMIT

truncate table MISSING_LIMIT;

insert into MISSING_LIMIT
SELECT TO_NCHAR(MAP_CIF.FIN_CIF_ID) NEW_LIMIT_PREFIX,CASE WHEN IBD_CUSTOMER.FIN_CIF_ID IS NOT NULL THEN 'GEVOD' ELSE 'GEODR' END NEW_LIMIT_SUFFIX,'KWD' CRNCY_CODE FROM MAP_ACC 
LEFT JOIN MAP_CIF ON MAP_ACC.FIN_CIF_ID = MAP_CIF.FIN_CIF_ID
LEFT JOIN LIMIT_CORE_O_TABLE ON TRIM(LIMIT_PREFIX)  = TRIM(MAP_ACC.FIN_CIF_ID) AND NODE_LEVEL='7' AND LIMIT_SUFFIX IN('GEODR','GEVOD')
LEFT JOIN IBD_CUSTOMER ON IBD_CUSTOMER.FIN_CIF_ID = MAP_CIF.FIN_CIF_ID
WHERE SCHM_TYPE='ODA' AND LIMIT_PREFIX IS NULL
and (MAP_CIF.FIN_CIF_ID,CASE WHEN IBD_CUSTOMER.FIN_CIF_ID IS NOT NULL THEN 'GEVOD' ELSE 'GEODR' END ) not in(select NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX from MISSING_LIMIT);

commit;


--FT MISSING LIMIT NODE

insert into MISSING_LIMIT
SELECT distinct NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX,case when  b.LIMIT_PREFIX is not null then b.CRNCY_CODE else to_nchar('KWD') end CRNCY_CODE FROM TF_MISSING_LIMIT a
left join (
SELECT distinct a.LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE A
INNER JOIN (
SELECT LIMIT_PREFIX FROM (SELECT DISTINCT LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='7') GROUP BY LIMIT_PREFIX HAVING COUNT(*)=1
) B ON A.LIMIT_PREFIX = B.LIMIT_PREFIX
) b on a.NEW_LIMIT_PREFIX = b.LIMIT_PREFIX
where (NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX) not in(select NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX from MISSING_LIMIT)
; 

commit;



INSERT INTO LIMIT_CORE_O_TABLE
SELECT a.LIMIT_PREFIX BORROWER_NAME,
       a.NODE_LEVEL,
       a.LIMIT_PREFIX,
       a.LIMIT_SUFFIX,
       LIMIT_SUFFIX_DESC LIMIT_DESC,
       'KWD' CRNCY_CODE,
       a.PARENT_LIMIT_PREFIX,
       a.PARENT_LIMIT_SUFFIX,
       '0.001' SANCTION_LIMIT,
       'E' DRAWING_POWER_IND,
       TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY') LIMIT_APPROVAL_DATE,
       GET_PARAM('EOD_DATE') LIMIT_EXPIRY_DATE,
       TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')-1,'DD-MM-YYYY') LIMIT_REVIEW_DATE,
       '' APPROVAL_AUTH_CODE,
       '' APPROVAL_LEVEL,
       '' LIMIT_APPROVAL_REF,
       '' NOTES,
       '' TERMS_AND_CONDITIONS,
       'C' Limit_Type,
       'N' Loan_Type,
       'DEF' Master_Limit_Node,
       '' Min_coll_value_based_on,
       '' drwng_power_pcnt,
       '' Pattern_of_Funding,
       '' Debit_Account_for_fees,
       '' Committed_Lines,
       '' Contract_Sign_Date,
       '0' Upload_status,
       'N' COND_PRECEDENT_FLG,
       'N' GLOBAL_LIMIT_FLG,
       '' Main_product_type,
       '' Project_Name,
       '' Product_Name,
       '' Purpose_of_limit,
       GET_PARAM('BANK_ID')
  FROM (
     SELECT DISTINCT '7' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(NEW_LIMIT_SUFFIX) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(LEVEL_7_PARENT) PARENT_LIMIT_SUFFIX FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX FROM MISSING_LIMIT) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        union 
     SELECT DISTINCT '6' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(c.LEVEL_6) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(c.LEVEL_6_PARENT) PARENT_LIMIT_SUFFIX FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX FROM MISSING_LIMIT) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =  TRIM(b.LEVEL_7_PARENT)
        union 
        SELECT DISTINCT '5' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(d.LEVEL_5) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(d.LEVEL_5_PARENT) PARENT_LIMIT_SUFFIX FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX FROM MISSING_LIMIT) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =  TRIM(b.LEVEL_7_PARENT)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        union         
        SELECT DISTINCT '4' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(e.LEVEL_4) LIMIT_SUFFIX ,TO_CHAR(NEW_LIMIT_PREFIX)PARENT_LIMIT_PREFIX ,TO_CHAR(e.LEVEL_4_PARENT) PARENT_LIMIT_SUFFIX FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX FROM MISSING_LIMIT) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =  TRIM(b.LEVEL_7_PARENT)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        LEFT JOIN LIMIT_MAPPING e ON TRIM(e.LEVEL_4) =  TRIM(d.LEVEL_5_PARENT)
        union 
        SELECT DISTINCT '3' node_level,TO_CHAR(NEW_LIMIT_PREFIX) LIMIT_PREFIX,TO_CHAR(f.LEVEL_3) LIMIT_SUFFIX ,'' PARENT_LIMIT_PREFIX ,'' PARENT_LIMIT_SUFFIX FROM
        (SELECT DISTINCT NEW_LIMIT_PREFIX,NEW_LIMIT_SUFFIX FROM MISSING_LIMIT) A
        LEFT JOIN LIMIT_MAPPING B ON TRIM(LEVEL_7) =  TRIM(NEW_LIMIT_SUFFIX)
        LEFT JOIN LIMIT_MAPPING c ON TRIM(c.LEVEL_6) =  TRIM(b.LEVEL_7_PARENT)
        LEFT JOIN LIMIT_MAPPING d ON TRIM(d.LEVEL_5) =  TRIM(c.LEVEL_6_PARENT)
        LEFT JOIN LIMIT_MAPPING e ON TRIM(e.LEVEL_4) =  TRIM(d.LEVEL_5_PARENT)
        LEFT JOIN LIMIT_MAPPING f ON TRIM(f.LEVEL_3) =  TRIM(e.LEVEL_4_PARENT)
        ) a
        left join LIMIT_CORE_O_TABLE b on a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
       LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC LS ON TRIM(LS.LIMIT_SUFFIX_CODE)= a.LIMIT_SUFFIX
       where b.limit_prefix is null ;
       
COMMIT;



update LIMIT_CORE_O_TABLE set limit_suffix='GLLF0' where limit_suffix='GELLF';
update LIMIT_CORE_O_TABLE set limit_suffix='GLLH0' where limit_suffix='GELLH';
update LIMIT_CORE_O_TABLE set limit_suffix='GRVF0' where limit_suffix='GERVF';
update LIMIT_CORE_O_TABLE set limit_suffix='GRVH0' where limit_suffix='GERVH';
update LIMIT_CORE_O_TABLE set limit_suffix='GTLF0' where limit_suffix='GETLF';
update LIMIT_CORE_O_TABLE set limit_suffix='GTLH0' where limit_suffix='GETLH';
update LIMIT_CORE_O_TABLE set limit_suffix='SYLH0' where limit_suffix='SYLHC';
update LIMIT_CORE_O_TABLE set limit_suffix='SYLF0' where limit_suffix='SYLFC';

commit;



--CONVERTING MULTI CURRENCY TO SINGLE CURRENCY 


DROP TABLE CORP_KWD_EQU_LIMIT;

CREATE TABLE CORP_KWD_EQU_LIMIT AS
SELECT NODE_LEVEL,LIMIT_PREFIX,LIMIT_SUFFIX,'KWD' NEW_CRNCY_CODE,ROUND(SANCTION_LIMIT*C8RTE,3) KWD_EQU_AMT FROM (
SELECT * FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX  in(select LIMIT_PREFIX from (SELECT distinct LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE WHERE node_level='7' ) group by  LIMIT_PREFIX having count(*) > 1)
AND NODE_LEVEL IN('6','5','4','3')
UNION
SELECT * FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX  in(select LIMIT_PREFIX from (SELECT distinct LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE WHERE node_level='7' ) group by  LIMIT_PREFIX having count(*) > 1)
AND NODE_LEVEL ='3' AND TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
)
UNION
SELECT * FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX  in(select LIMIT_PREFIX from (SELECT distinct LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE WHERE node_level='7' ) group by  LIMIT_PREFIX having count(*) > 1)
AND NODE_LEVEL ='3' AND  TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
)AND NODE_LEVEL ='2' AND  TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
) 
UNION
SELECT * FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN( 
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_PREFIX,LIMIT_SUFFIX) IN(
SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE WHERE LIMIT_PREFIX  in(select LIMIT_PREFIX from (SELECT distinct LIMIT_PREFIX,CRNCY_CODE FROM LIMIT_CORE_O_TABLE WHERE node_level='7' ) group by  LIMIT_PREFIX having count(*) > 1)
AND NODE_LEVEL ='3' AND  TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
)AND NODE_LEVEL ='2' AND  TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
) AND NODE_LEVEL ='1' AND  TRIM(PARENT_LIMIT_PREFIX) IS NOT NULL
)
)
LEFT JOIN C8PF ON TRIM(C8CCY) = TRIM(CRNCY_CODE)
 WHERE CRNCY_CODE <> 'KWD' and NODE_LEVEL != 0;


UPDATE LIMIT_CORE_O_TABLE  A SET (CRNCY_CODE,SANCTION_LIMIT) =(SELECT NEW_CRNCY_CODE,KWD_EQU_AMT FROM CORP_KWD_EQU_LIMIT B WHERE A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX )
WHERE (A.LIMIT_PREFIX,A.LIMIT_SUFFIX) IN(SELECT LIMIT_PREFIX,LIMIT_SUFFIX FROM CORP_KWD_EQU_LIMIT);

COMMIT;

--------------------Exception
--update LIMIT_CORE_O_TABLE set PARENT_LIMIT_PREFIX='',PARENT_LIMIT_SUFFIX='' where PARENT_LIMIT_PREFIX='RU';
--commit;
---

update LIMIT_CORE_O_TABLE set COMMITTED_LINES='Y' where NODE_LEVEL='3';
commit;

--LINKING TO COUNTRY LIMIT FOR FCCY CORPORATE CUSTOMER 
UPDATE LIMIT_CORE_O_TABLE X SET (PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) =( SELECT GFCNAR ,'CNTRY' FROM(
SELECT DISTINCT FIN_CIF_ID,GFCNAR FROM HHPF_MIG a
inner join gfpf b on  a.hhclc||a.hhcus  = b.gfclc||b.gfcus
INNER JOIN MAP_CIF ON MAP_CIF.GFCLC||MAP_CIF.GFCUS = a.hhclc||a.hhcus 
INNER JOIN LIMIT_CORE_O_TABLE ON LIMIT_PREFIX = FIN_CIF_ID AND NODE_LEVEL='3' AND PARENT_LIMIT_PREFIX IS NULL
WHERE HHCLC||HHCUS NOT IN(SELECT GFCLC||GFCUS FROM IBD_CUSTOMER) AND GFCNAR<>'KW'
) Y WHERE  X.LIMIT_PREFIX = Y.FIN_CIF_ID)
WHERE X.LIMIT_PREFIX IN(
SELECT DISTINCT FIN_CIF_ID FROM HHPF_MIG a
inner join gfpf b on  a.hhclc||a.hhcus  = b.gfclc||b.gfcus
INNER JOIN MAP_CIF ON MAP_CIF.GFCLC||MAP_CIF.GFCUS = a.hhclc||a.hhcus 
INNER JOIN LIMIT_CORE_O_TABLE ON LIMIT_PREFIX = FIN_CIF_ID AND NODE_LEVEL='3' AND PARENT_LIMIT_PREFIX IS NULL
WHERE HHCLC||HHCUS NOT IN(SELECT GFCLC||GFCUS FROM IBD_CUSTOMER) AND GFCNAR<>'KW'
) AND X.NODE_LEVEL='3';
COMMIT;


TRUNCATE TABLE LIMIT_CORE_INFY_TABLE;
INSERT INTO LIMIT_CORE_INFY_TABLE
   SELECT BORROWER_NAME,
          NODE_LEVEL,
          LIMIT_PREFIX,
          LIMIT_SUFFIX,
          LIMIT_DESC,
          CRNCY_CODE,
          PARENT_LIMIT_PREFIX,
          PARENT_LIMIT_SUFFIX,
          SANCTION_LIMIT,
          DRAWING_POWER_IND,
          TO_DATE(LIMIT_APPROVAL_DATE,'DD-MM-YYYY'),
          TO_DATE(LIMIT_EXPIRY_DATE,'DD-MM-YYYY'),
          TO_DATE(LIMIT_REVIEW_DATE,'DD-MM-YYYY'),
          APPROVAL_AUTH_CODE,
          APPROVAL_LEVEL,
          LIMIT_APPROVAL_REF,
          NOTES,
          TERMS_AND_CONDITIONS,
          LIMIT_TYPE,
          LOAN_TYPE,
          MASTER_LIMIT_NODE,
          MIN_COLL_VALUE_BASED_ON,
          DRWNG_POWER_PCNT,
          PATTERN_OF_FUNDING,
          DEBIT_ACCOUNT_FOR_FEES,
          COMMITTED_LINES,
          TO_DATE(CONTRACT_SIGN_DATE,'DD-MM-YYYY'),
          UPLOAD_STATUS,
          COND_PRECEDENT_FLG,
          GLOBAL_LIMIT_FLG,
          --MAIN_PRODUCT_TYPE,
          --PROJECT_NAME,
          --PRODUCT_NAME,
          --PURPOSE_OF_LIMIT,
          BANK_ID
     FROM LIMIT_CORE_O_TABLE;


TRUNCATE TABLE LIMIT_ENTITY_AND_GROUP_MAP;     
INSERT INTO LIMIT_ENTITY_AND_GROUP_MAP 
select DISTINCT ENTITY_ID,ENTITY_NAME,ENTITY_REPORTING_ID,GROUP_ID,GROUP_NAME,GROUP_REPORTING_ID from CIF_GROUPS_DATA where ENTITY_NAME is not null AND GROUP_NAME IS NOT NULL ORDER BY GROUP_NAME;
COMMIT;

--update expiry and review date from parent to child if parent expiry date is lesser than child

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='1' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='1' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='2' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='2' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='3' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='3' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='4' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='4' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='5' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='5' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='6' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='6' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_INFY_TABLE a set (limit_expiry_date,limit_review_date) = (select limit_expiry_date,limit_expiry_date-1 from(
select a.limit_prefix,a.limit_suffix,b.limit_expiry_date from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='7' and a.limit_expiry_date > b.limit_expiry_date 
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (limit_prefix,limit_suffix) in (
select a.limit_prefix,a.limit_suffix from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_INFY_TABLE b on b.limit_prefix = a.parent_limit_prefix and b.limit_suffix = a.parent_limit_suffix
where a.node_level='7' and a.limit_expiry_date > b.limit_expiry_date
);

update LIMIT_CORE_O_TABLE a set  (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
SELECT A.NODE_LEVEL,A.LIMIT_PREFIX,A.LIMIT_SUFFIX,to_char(B.LIMIT_EXPIRY_DATE,'dd-mm-yyyy') LIMIT_EXPIRY_DATE,to_char(b.LIMIT_REVIEW_DATE,'dd-mm-yyyy' ) LIMIT_REVIEW_DATE FROM LIMIT_CORE_O_TABLE A
LEFT JOIN LIMIT_CORE_INFY_TABLE B ON A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX
WHERE TO_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') != B.LIMIT_EXPIRY_DATE 
) b where a.LIMIT_PREFIX = b.LIMIT_PREFIX and a.LIMIT_SUFFIX = b.LIMIT_SUFFIX
)
where (LIMIT_PREFIX,LIMIT_SUFFIX) in(
SELECT A.LIMIT_PREFIX,A.LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE A
LEFT JOIN LIMIT_CORE_INFY_TABLE B ON A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX
WHERE TO_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') != B.LIMIT_EXPIRY_DATE 
);

commit;

--update expiry and review date from child to parent if parent expiry date is lesser than child

--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='7'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='7');
--
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='6'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='6');
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='5'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='5');
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='4'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='4');
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='3'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='3');
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='2'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='2');
--
--update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX,MAX(LIMIT_EXPIRY_DATE) LIMIT_EXPIRY_DATE,MAX(LIMIT_EXPIRY_DATE)-1 LIMIT_REVIEW_DATE FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='1'
--GROUP BY PARENT_LIMIT_PREFIX,PARENT_LIMIT_SUFFIX) b where  B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX) 
--WHERE (LIMIT_PREFIX||LIMIT_SUFFIX) IN(
--SELECT A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX FROM LIMIT_CORE_INFY_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_INFY_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND B.LIMIT_EXPIRY_DATE < A.LIMIT_EXPIRY_DATE) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL and NODE_LEVEL='1');
--
--
--update LIMIT_CORE_O_TABLE a set  (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE) =(
--select LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE from(
--SELECT A.NODE_LEVEL,A.LIMIT_PREFIX,A.LIMIT_SUFFIX,to_char(B.LIMIT_EXPIRY_DATE,'dd-mm-yyyy') LIMIT_EXPIRY_DATE,to_char(b.LIMIT_REVIEW_DATE,'dd-mm-yyyy' ) LIMIT_REVIEW_DATE FROM LIMIT_CORE_O_TABLE A
--LEFT JOIN LIMIT_CORE_INFY_TABLE B ON A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX
--WHERE TO_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') != B.LIMIT_EXPIRY_DATE 
--) b where a.LIMIT_PREFIX = b.LIMIT_PREFIX and a.LIMIT_SUFFIX = b.LIMIT_SUFFIX
--)
--where (LIMIT_PREFIX,LIMIT_SUFFIX) in(
--SELECT A.LIMIT_PREFIX,A.LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE A
--LEFT JOIN LIMIT_CORE_INFY_TABLE B ON A.LIMIT_PREFIX = B.LIMIT_PREFIX AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX
--WHERE TO_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') != B.LIMIT_EXPIRY_DATE 
--);
--
--commit;

TRUNCATE TABLE LIMIT_CORE_NOTES_O_TABLE;
INSERT INTO LIMIT_CORE_NOTES_O_TABLE 
SELECT DISTINCT FIN_CIF_ID BORROWER_NAME,
                TRIM(HPCF1) NOTE1,
                TRIM(HPCF2) NOTE2,
                TRIM(HPCF3) NOTE3
  FROM HPPF
       INNER JOIN MAP_CIF ON TRIM (GFCUS) || TRIM (GFCLC) = TRIM (HPCUS) || TRIM (HPCLC)
       INNER JOIN LIMIT_CORE_O_TABLE ON BORROWER_NAME = FIN_CIF_ID
 WHERE    TRIM (HPCF1) IS NOT NULL OR TRIM (HPCF2) IS NOT NULL OR TRIM (HPCF3) IS NOT NULL;
 
INSERT INTO LIMIT_CORE_NOTES_O_TABLE  
 SELECT DISTINCT GROUP_ID BORROWER_NAME,
                TRIM(HPCF1) NOTE1,
                TRIM(HPCF2) NOTE2,
                TRIM(HPCF3) NOTE3 FROM HPPF
 INNER JOIN GROUP_MASTER_O_TABLE ON TRIM(HPGRP) = TRIM(REPORTING_GROUP_ID)
    WHERE TRIM (HPCF1) IS NOT NULL OR TRIM (HPCF2) IS NOT NULL OR TRIM (HPCF3) IS NOT NULL;
    
INSERT INTO LIMIT_CORE_NOTES_O_TABLE     
     SELECT DISTINCT HPCNA BORROWER_NAME,
                TRIM(HPCF1) NOTE1,
                TRIM(HPCF2) NOTE2,
                TRIM(HPCF3) NOTE3 FROM HPPF
 INNER JOIN LIMIT_CORE_O_TABLE ON TRIM(HPCNA) = TRIM(BORROWER_NAME)
    WHERE (TRIM (HPCF1) IS NOT NULL OR TRIM (HPCF2) IS NOT NULL OR TRIM (HPCF3) IS NOT NULL)  AND TRIM(HPCNA) IS NOT NULL AND TRIM(HPGRP) IS NULL AND  TRIM(HPCUS) IS NULL;
 COMMIT;
 
update LIMIT_CORE_O_TABLE set limit_prefix=trim(limit_prefix)||'01',BORROWER_NAME=trim(BORROWER_NAME)||'01' where limit_suffix='CNTRY';
update LIMIT_CORE_O_TABLE set parent_limit_prefix=trim(parent_limit_prefix)||'01' where parent_limit_suffix='CNTRY';
update LIMIT_CORE_INFY_TABLE set limit_prefix=trim(limit_prefix)||'01',BORROWER_NAME=trim(BORROWER_NAME)||'01' where limit_suffix='CNTRY';
update LIMIT_CORE_INFY_TABLE set parent_limit_prefix=trim(parent_limit_prefix)||'01' where parent_limit_suffix='CNTRY';
UPDATE LIMIT_CORE_NOTES_O_TABLE SET LIMIT_PREFIX=LIMIT_PREFIX||'01' WHERE LENGTH(TRIM(LIMIT_PREFIX))=2;
 
exit;


-------------------------------------------------------------------------------------------------     

--UPDATE limit_mapping SET LIMIT_LINE = TRIM(LIMIT_LINE), LIMIT_STRUCTURE= TRIM(LIMIT_STRUCTURE), LINE_DESCRIPTION= TRIM(LINE_DESCRIPTION), LEVEL_7= TRIM(LEVEL_7), LEVEL_6= TRIM(LEVEL_6)
--, LEVEL_5= TRIM(LEVEL_5), LEVEL_4= TRIM(LEVEL_4), LEVEL_3= TRIM(LEVEL_3), LEVEL_2= TRIM(LEVEL_2),
-- LEVEL_1= TRIM(LEVEL_1), LEVEL_7_PARENT= TRIM(LEVEL_7_PARENT), LEVEL_6_PARENT= TRIM(LEVEL_6_PARENT), LEVEL_5_PARENT= TRIM(LEVEL_5_PARENT)
-- , LEVEL_4_PARENT= TRIM(LEVEL_4_PARENT), LEVEL_3_PARENT= TRIM(LEVEL_3_PARENT), LEVEL_2_PARENT= TRIM(LEVEL_2_PARENT), IS_ZERO_LIMIT_REQ= TRIM(IS_ZERO_LIMIT_REQ);
-- COMMIT;

--VALIDATIONS

--SELECT * FROM LIMIT_CORE_O_TABLE A WHERE  SANCTION_LIMIT != 0 and 
-- NOT EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE SANCTION_LIMIT != 0 and A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX ) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL 

--SELECT * FROM LIMIT_CORE_O_TABLE A WHERE 
-- NOT EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX ) 
--AND LIMIT_PREFIX IS NOT NULL AND NODE_LEVEL!='7'

--SELECT * FROM LIMIT_CORE_O_TABLE A WHERE 
-- NOT EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX ) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL

--SELECT * FROM LIMIT_CORE_O_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_O_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND CONV_TO_VALID_DATE(B.LIMIT_EXPIRY_DATE,'DD-MM-YYYY') < CONV_TO_VALID_DATE(A.LIMIT_EXPIRY_DATE,'DD-MM-YYYY')) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL

--SELECT * FROM LIMIT_CORE_infy_TABLE A WHERE  EXISTS (SELECT * FROM LIMIT_CORE_infy_TABLE B WHERE  A.PARENT_LIMIT_PREFIX|| A.PARENT_LIMIT_SUFFIX = B.LIMIT_PREFIX||B.LIMIT_SUFFIX 
--AND (B.LIMIT_EXPIRY_DATE) < (A.LIMIT_EXPIRY_DATE)) 
--AND PARENT_LIMIT_PREFIX IS NOT NULL

--select * from LIMIT_CORE_infy_TABLE where  LIMIT_APPROVAL_DATE>=LIMIT_EXPIRY_DATE;

--select * from LIMIT_CORE_INFY_TABLE where LIMIT_APPROVAL_DATE > LIMIT_EXPIRY_DATE

--SELECT * FROM LIMIT_CORE_O_TABLE A WHERE   CONV_TO_VALID_DATE(LIMIT_EXPIRY_DATE,'DD-MM-YYYY') < CONV_TO_VALID_DATE(LIMIT_REVIEW_DATE,'DD-MM-YYYY');

--select  * from LIMIT_CORE_O_TABLE where  BORROWER_NAME||LIMIT_PREFIX||LIMIT_SUFFIX in(
--select BORROWER_NAME||LIMIT_PREFIX||LIMIT_SUFFIX from LIMIT_CORE_O_TABLE group by BORROWER_NAME||LIMIT_PREFIX||LIMIT_SUFFIX having count(*) > 1)

--select * from LIMIT_CORE_O_TABLE where borrower_name in(
--SELECT borrower_name FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_APPROVAL_DATE is null or LIMIT_EXPIRY_DATE is null) );

--edit LIMIT_CORE_O_TABLE where LIMIT_PREFIX in(
--select LIMIT_PREFIX from LIMIT_CORE_O_TABLE where borrower_name in(
--SELECT borrower_name FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_APPROVAL_DATE is null or LIMIT_EXPIRY_DATE is null) )
--and SANCTION_LIMIT !='0');
--
--edit LIMIT_CORE_infy_TABLE where LIMIT_PREFIX in(
--select LIMIT_PREFIX from LIMIT_CORE_infy_TABLE where borrower_name in(
--SELECT borrower_name FROM LIMIT_CORE_infy_TABLE WHERE (LIMIT_APPROVAL_DATE is null or LIMIT_EXPIRY_DATE is null) )
--and SANCTION_LIMIT !='0');

--select * from LIMIT_CORE_O_TABLE where LIMIT_PREFIX in(
--select LIMIT_PREFIX from LIMIT_CORE_O_TABLE where borrower_name in(
--SELECT borrower_name FROM LIMIT_CORE_O_TABLE WHERE (LIMIT_APPROVAL_DATE is null or LIMIT_EXPIRY_DATE is null) )
--and SANCTION_LIMIT !='0');

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='6' and BORROWER_NAME not in (select BORROWER_NAME from LIMIT_CORE_O_TABLE where node_level='7');

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='5' and BORROWER_NAME not in (select BORROWER_NAME from LIMIT_CORE_O_TABLE where node_level='6');

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='4' and BORROWER_NAME not in (select BORROWER_NAME from LIMIT_CORE_O_TABLE where node_level='5');

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='3' and BORROWER_NAME not in (select BORROWER_NAME from LIMIT_CORE_O_TABLE where node_level='4');

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL='3' and BORROWER_NAME not in (select BORROWER_NAME from LIMIT_CORE_O_TABLE where node_level='4');


--select * from LIMIT_CORE_O_TABLE where LIMIT_DESC is null;

--select * from LIMIT_CORE_O_TABLE where SANCTION_LIMIT='0.001';

--SELECT * FROM LIMIT_CORE_O_TABLE WHERE NODE_LEVEL||LIMIT_PREFIX||LIMIT_SUFFIX NOT IN (
--SELECT NODE_LEVEL||LIMIT_PREFIX||LIMIT_SUFFIX FROM LIMIT_CORE_O_TABLE A
--LEFT JOIN LIMIT_SUFFIX_CODE_AND_DESC B ON SUBSTR(B.LIMIT_SUFFIX_DESC,2,1) = A.NODE_LEVEL AND A.LIMIT_SUFFIX = B.LIMIT_SUFFIX_CODE);

--select HHCUS from (select distinct HHCUS,HHCCY from hhpf where HHLC in( 'LS096', 'LG083') and hhama <> 0) group by HHCUS having count(*)>1

--select distinct LIMIT_SUFFIX from limit_core_o_table where limit_suffix not in(
--select REF_CODE from tbaadm.rct where REF_REC_TYPE='57' and bank_id='01'
--)

--select LIMIT_SUFFIX_CODE,count(*) from LIMIT_SUFFIX_CODE_AND_DESC group by LIMIT_SUFFIX_CODE having count(*)>1

--select * from map_acc
--left join LIMIT_LINKAGE_TO_ACCT_O_TABLE on fin_acc_num = acct_num 
--where  schm_type='ODA' and limit_prefix is null

--UPDATE CHECK

--delete  LIMIT_CORE_infy_TABLE where LIMIT_PREFIX in(
--SELECT LIMIT_PREFIX FROM LIMIT_CORE_infy_TABLE A WHERE 
-- NOT EXISTS (SELECT * FROM LIMIT_CORE_infy_TABLE B WHERE B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX ) 
--AND LIMIT_PREFIX IS NOT NULL AND NODE_LEVEL!='7' and LIMIT_SUFFIX='GECSH' and LIMIT_PREFIX not in('0900067347','0900136048')
--) and LIMIT_SUFFIX in('GECSH','GENRL');
--
--
--delete  LIMIT_CORE_o_TABLE where LIMIT_PREFIX in(
--SELECT LIMIT_PREFIX FROM LIMIT_CORE_o_TABLE A WHERE 
-- NOT EXISTS (SELECT * FROM LIMIT_CORE_o_TABLE B WHERE B.PARENT_LIMIT_PREFIX|| B.PARENT_LIMIT_SUFFIX = A.LIMIT_PREFIX||A.LIMIT_SUFFIX ) 
--AND LIMIT_PREFIX IS NOT NULL AND NODE_LEVEL not in('7','0') and LIMIT_SUFFIX='GECSH' and LIMIT_PREFIX not in('0900067347','0900136048')
--) and LIMIT_SUFFIX in('GECSH','GENRL'); 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
limit_core_linkage_to_account_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
limit_core_linkage_to_account_upload.sql 

drop table hmpf_mig;
create table hmpf_mig as
select HMCNA, HMGRP, nvl(trim(HMCUS),TRIM(GFCUS)) HMCUS, nvl(trim(HMCLC),TRIM(GFCLC)) HMCLC,TRIM(HMLC)HMLC, HMCCY, HMMDT, HMSEQ, HMYGUA, HMYE, HMYOVD, HMEXPM, HMAMT, HMGCCY, HMXDT, HMGTP, HMGPC from hmpf
left JOIN GFPF ON TRIM(HmGRP) = TRIM(GFGRP);
DROP TABLE HNPF_MAX_SEQ;
CREATE TABLE HNPF_MAX_SEQ AS
SELECT TRIM(HNAB) HNAB,TRIM(HNAN) HNAN,TRIM(HNAS) HNAS,MAX(TO_NUMBER(TRIM(HNSEQ))) HNSEQ FROM HMPF_MIG HM 
INNER JOIN HNPF HN ON TRIM(HM.HMSEQ)=TRIM(HN.HNSEQ)
GROUP BY TRIM(HNAB),TRIM(HNAN),TRIM(HNAS);
CREATE INDEX HMPF_MIG_IDX1 ON HMPF_MIG(HMCLC||HMCUS);
CREATE INDEX HMPF_MIG_ID21 ON HMPF_MIG( HMLC);
create index HNPF_MIG_HNSEQ_IDX on HNPF_MAX_SEQ(HNSEQ);
create index  limit_core_temp_idx on LIMIT_CORE_TEMP_TABLE(LIMIT_PREFIX,LIMIT_SUFFIX);
create index  limit_core_idx on LIMIT_CORE_O_TABLE(LIMIT_PREFIX,LIMIT_SUFFIX);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('MIGAPPKW','HMPF_MIG',CASCADE=>TRUE);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('MIGAPPKW','MAP_ACC',CASCADE=>TRUE);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('MIGAPPKW','HNPF_MAX_SEQ',CASCADE=>TRUE);


truncate table LIMIT_LINKAGE_TO_ACCT_O_TABLE;
DROP TABLE LIMIT_LINK_TEMP;


CREATE TABLE LIMIT_LINK_TEMP AS
select DISTINCT LT.LIMIT_PREFIX,LT.LIMIT_SUFFIX,
SANCTION_LIMIT LIMIT_AMOUNT,CRNCY_CODE LIMIT_CCY, HN.HNAB||HN.HNAN||HN.HNAS ACCT_NUM,LT.LIMIT_EXPIRY_DATE
FROM HNPF_MAX_SEQ HN
inner join HMPF_MIG  HM ON trim(hmseq) = trim(hnseq)
INNER JOIN MAP_CIF ON  gfclc||gfcus =  hmclc||hmcus
INNER JOIN (SELECT DISTINCT LIMIT_CAT,LIMIT_PREFIX,LIMIT_SUFFIX,NODE_LEVEL,LIMIT_EXPIRY_DATE,SANCTION_LIMIT,CRNCY_CODE FROM LIMIT_CORE_TEMP_TABLE WHERE NODE_LEVEL='7' AND TRIM(limit_suffix) NOT in ('GEODR','GEVOD') ) LT 
ON fin_cif_id=lt.LIMIT_PREFIX AND LIMIT_CAT = hmlc
WHERE  TRIM(LT.limit_suffix) NOT in ('GEODR','GEVOD') AND  LT.NODE_LEVEL='7';


INSERT INTO LIMIT_LINKAGE_TO_ACCT_O_TABLE 
SELECT LIMIT_PREFIX, LIMIT_SUFFIX, LIMIT_AMOUNT, LIMIT_CCY, MAP_ACC.FIN_ACC_NUM ACCT_NUM, LIMIT_EXPIRY_DATE FROM LIMIT_LINK_TEMP A
INNER JOIN MAP_ACC ON LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS = ACCT_NUM and SCHM_TYPE not in('CAA','OOO','ODA');


INSERT INTO LIMIT_LINKAGE_TO_ACCT_O_TABLE 
select DISTINCT LOT.LIMIT_PREFIX,LOT.LIMIT_SUFFIX,
LOT.SANCTION_LIMIT LIMIT_AMOUNT,CRNCY_CODE LIMIT_CCY, MAP_ACC.FIN_ACC_NUM ACCT_NUM,LOT.LIMIT_EXPIRY_DATE 
from MAP_ACC 
left join LIMIT_CORE_O_TABLE LOT on FIN_CIF_ID = borrower_name and limit_suffix in ('GEODR','GEVOD')
where SCHM_TYPE='ODA' and borrower_name is not null; 


delete from LIMIT_LINKAGE_TO_ACCT_O_TABLE where trim(ACCT_NUM) is null;
commit;

delete from LIMIT_LINKAGE_TO_ACCT_O_TABLE where rowid not in(
select a.rowid row_id from LIMIT_LINKAGE_TO_ACCT_O_TABLE a
inner join map_acc b on a.LIMIT_PREFIX = b.fin_cif_id and a.ACCT_NUM = b.FIN_ACC_NUM
);


commit;
DROP index  limit_core_temp_idx ;
DROP index  limit_core_idx ;



--SELECT SANCT_LIMIT_LINK_ACCNT.*,SCODL/C8PWD FROM SANCT_LIMIT_LINK_ACCNT
--INNER JOIN MAP_ACC ON TRIM(FIN_ACC_NUM) = TRIM(FORACID)
--INNER JOIN SCPF ON SCAB||SCAN||SCAS = LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS 
--LEFT JOIN C8PF ON C8CCY = SCCCY
--WHERE SANCT_LIM != ABS(SCODL/C8PWD) AND  ABS(SCODL/C8PWD)<>0 
  

delete from LIMIT_LINKAGE_TO_ACCT_O_TABLE where ( LIMIT_PREFIX,LIMIT_SUFFIX ) in(
select distinct c.limit_prefix,c.limit_suffix from COMMITMENT_LIMIT_DATA a
inner join LIMIT_CORE_O_TABLE_CLA b on FIN_CIF_ID =b.limit_prefix  and a.LIMIT_SUFFIX=b.LIMIT_SUFFIX
inner join LIMIT_CORE_temp_TABLE c on FIN_CIF_ID = c.PARENT_LIMIT_PREFIX and c. PARENT_LIMIT_SUFFIX = a.PARENT_LIMIT_SUFFIX
where trim(FIN_ACC_NUM) is not null
);

commit;

insert into LIMIT_LINKAGE_TO_ACCT_O_TABLE
select distinct b.LIMIT_PREFIX, b.LIMIT_SUFFIX, b.SANCTION_LIMIT LIMIT_AMOUNT, b.CRNCY_CODE  LIMIT_CCY, FIN_ACC_NUM ACCT_NUM, b.LIMIT_EXPIRY_DATE LIMIT_EXPIRY_DATE from COMMITMENT_LIMIT_DATA a
inner join LIMIT_CORE_O_TABLE_CLA b on b.LIMIT_PREFIX=a.FIN_CIF_ID and a.LIMIT_SUFFIX=b.LIMIT_SUFFIX
inner join LIMIT_CORE_INFY_TABLE c on  c.LIMIT_PREFIX=a.FIN_CIF_ID and a.LIMIT_SUFFIX=c.LIMIT_SUFFIX
where trim(FIN_ACC_NUM) is not null;
commit;



update LIMIT_LINKAGE_TO_ACCT_O_TABLE set limit_suffix='GLLF0' where limit_suffix='GELLF';
update LIMIT_LINKAGE_TO_ACCT_O_TABLE set limit_suffix='GLLH0' where limit_suffix='GELLH';
update LIMIT_LINKAGE_TO_ACCT_O_TABLE set limit_suffix='GRVF0' where limit_suffix='GERVF';
update LIMIT_LINKAGE_TO_ACCT_O_TABLE set limit_suffix='GRVH0' where limit_suffix='GERVH';
update LIMIT_LINKAGE_TO_ACCT_O_TABLE set limit_suffix='GTLF0' where limit_suffix='GETLF';
update LIMIT_LINKAGE_TO_ACCT_O_TABLE set limit_suffix='GTLH0' where limit_suffix='GETLH';
update LIMIT_LINKAGE_TO_ACCT_O_TABLE set limit_suffix='SYLH0' where limit_suffix='SYLHC';
update LIMIT_LINKAGE_TO_ACCT_O_TABLE set limit_suffix='SYLF0' where limit_suffix='SYLFC';
commit;  

delete LIMIT_LINKAGE_TO_ACCT_O_TABLE where (LIMIT_PREFIX,LIMIT_SUFFIX) not in(select LIMIT_PREFIX,LIMIT_SUFFIX from LIMIT_CORE_INFY_TABLE);
commit;

truncate table SANCT_LIMIT_LINK_ACCNT;

INSERT INTO SANCT_LIMIT_LINK_ACCNT

SELECT ACCT_NUM FORACID,
       TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') LIMITAPPDATE,
       ROWNUM SRL_NUM,
       '0' UPLOAD_STATUS,
       CURRENCY CRNCY_CODE,
        LIMIT_AMOUNT*(C8A.C8SPT/C8B.C8SPT) SANCT_LIM,
       '99999999999' MAXALLWDLIMIT,
       TO_DATE(LIMIT_EXPIRY_DATE,'DD-MM-YYYY') EXPDATE,
       TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') SANCTDATE,
       TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') DOCDATE
  FROM LIMIT_LINKAGE_TO_ACCT_O_TABLE
  INNER JOIN MAP_ACC ON TRIM(FIN_ACC_NUM) = TRIM(ACCT_NUM) 
  LEFT JOIN C8PF C8A ON TRIM(C8A.C8CCY) = TRIM(LIMIT_CCY)
  LEFT JOIN C8PF C8B ON TRIM(C8B.C8CCY) = TRIM(CURRENCY);

  commit;
  
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
limit_core_org_exp_date.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
limit_core_org_exp_date.sql 
drop table limit_org_exp_date_temp;


create table limit_org_exp_date_temp as 
select distinct LIMIT_PREFIX,LIMIT_SUFFIX,LIMIT_EXPIRY_DATE from LIMIT_CORE_TEMP_TABLE;


insert into limit_org_exp_date_temp
select * from (
SELECT LIMIT_PREFIX, 'RPBLG' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPBLC' LIMIT_SUFFIX,LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT  LIMIT_PREFIX, 'RPBLO' LIMIT_SUFFIX,LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPTLG' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPTLC' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPBNL' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPNSH' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPATL' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'CUSTL' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
) where  (limit_prefix,limit_suffix) not in(select limit_prefix,limit_suffix from limit_org_exp_date_temp);
       

insert into limit_org_exp_date_temp
select TRIM(HHCNA)||'01' LIMIT_PREFIX,
'CNTRY' LIMIT_SUFFIX,
case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON trim(HPCNA) = trim(HHCNA) AND TRIM(HPCNA) IS NOT NULL AND TRIM(HPGRP) IS NULL
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY 
 WHERE  trim(HHLC)='LG156' AND HHAMA <> 0 AND TRIM(HHCNA) IS NOT NULL AND TRIM(HHGRP) IS NULL and trim(HHCUS)  is null;
 


insert into limit_org_exp_date_temp
select a.limit_prefix,a.limit_suffix,b.LIMIT_EXPIRY_DATE from LIMIT_CORE_O_TABLE a
left join LIMIT_CORE_TEMP_TABLE b on b.limit_prefix||b.limit_suffix = a.parent_limit_prefix||a.parent_limit_suffix
 where (a.limit_prefix,a.limit_suffix) not in(select limit_prefix,limit_suffix from limit_org_exp_date_temp) and a.node_level='7' and regexp_like(a.limit_suffix,'[0-9]') ; 
 
 
 
  insert into limit_org_exp_date_temp
select a.limit_prefix,a.limit_suffix,to_char(max(to_date(a.LIMIT_EXPIRY_DATE,'dd-mm-yyyy')),'dd-mm-yyyy') LIMIT_EXPIRY_DATE from LIMIT_CORE_O_TABLE a
left join LIMIT_CORE_TEMP_TABLE b on b.limit_prefix = a.limit_prefix and b.limit_suffix='CUSTL'
 where (a.limit_prefix,a.limit_suffix) not in(select limit_prefix,limit_suffix from limit_org_exp_date_temp) and a.limit_suffix in('GROUP','ENTTY')
 group by a.limit_prefix,a.limit_suffix; 
 
 
 
insert into limit_org_exp_date_temp 
select a.limit_prefix,a.limit_suffix,a.LIMIT_EXPIRY_DATE from LIMIT_CORE_O_TABLE a
 where (a.limit_prefix,a.limit_suffix) not in(select limit_prefix,limit_suffix from limit_org_exp_date_temp) ;
 
 delete from limit_org_exp_date_temp  a where(a.limit_prefix,a.limit_suffix) not in (select a.limit_prefix,a.limit_suffix from limit_core_infy_table a);
 
 drop table limit_org_exp_date;
 
 create table limit_org_exp_date as select distinct * from limit_org_exp_date_temp;
  
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
OFFSET_TTUM.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
OFFSET_TTUM.sql 
truncate table OFFSET_MIGRA_BAL;
truncate bal_tran_offbook_to_onbook;

INSERT INTO OFFSET_MIGRA_BAL 
select FORACID,ACCT_CRNCY_CODE,SOL_ID,CASE WHEN CLR_BAL_AMT>0 THEN 'D' ELSE 'C' END INDICATOR,ABS(CLR_BAL_AMT),'OFFSET MIGRA' 
from tbaadm.gam where clr_bal_amt!=0 AND BACID IN ('52000SBA','52000CAA','52000ODA');
commit;

INSERT INTO OFFSET_MIGRA_BAL 
select FORACID,ACCT_CRNCY_CODE,SOL_ID,CASE WHEN CLR_BAL_AMT>0 THEN 'D' ELSE 'C' END INDICATOR,ABS(CLR_BAL_AMT),'OFFSET MIGRA' 
from tbaadm.gam where clr_bal_amt!=0 AND BACID IN ('520000RX','520000TX','520000YF','520000YL');
commit;

insert into OFFSET_MIGRA_BAL
select * from( 
select FORACID,ACCT_CRNCY_CODE,SOL_ID,CASE WHEN CLR_BAL_AMT>0 THEN 'D' ELSE 'C' END INDICATOR,case when sol_id='612'
then ABS(CLR_BAL_AMT-5.016)
else ABS(CLR_BAL_AMT)  end AMOUNT ,'OFFSET MIGRA' 
from tbaadm.gam where clr_bal_amt!=0 AND BACID IN ('52000LAA')
union all
select  sol_id||substr(FORACID,4,7)||'0YD' FORACID,ACCT_CRNCY_CODE,SOL_ID, 'C'  INDICATOR,case when sol_id='612'
then ABS(CLR_BAL_AMT-5.016)
else ABS(CLR_BAL_AMT)  end AMOUNT ,'OFFSET MIGRA' 
from tbaadm.gam where clr_bal_amt!=0 AND BACID IN ('52000LAA'))
order by FORACID;
commit;

truncate table offset_ttum;
insert into offset_ttum
select 
--Account Number
    rpad(ACCOUNT,16,' '),
--Currency Code     
    rpad(ccy,3,' '),
--SOLID
    rpad(SOL_ID,8,' '),
--Part Tran Type
    INDICATOR,
--Transaction Amount
    lpad(abs(AMOUNT),17,' '),
--Transaction Particular
    rpad(PERTICULARS,30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(AMOUNT),17,' '),
    rpad(ccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(get_param('EOD_DATE'),10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from OFFSET_MIGRA_BAL;
commit;
--INTEREST SUSPANCE AMOUNT MOVING OFF BOOK TO ON BOOK changed on 03-09-2017
insert into offset_ttum
select 
--Account Number
    rpad(ACCOUNT,16,' '),
--Currency Code     
    rpad(ccy,3,' '),
--SOLID
    rpad(SOL_ID,8,' '),
--Part Tran Type
    INDICATOR,
--Transaction Amount
    lpad(abs(AMOUNT),17,' '),
--Transaction Particular
    rpad(PERTICULARS,30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(AMOUNT),17,' '),
    rpad(ccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(get_param('EOD_DATE'),10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from bal_tran_offbook_to_onbook;
commit; 

========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
RL001_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
RL001_upload.sql 
-- File Name           : LAM_upload.sql
-- File Created for    : Upload file for LAM
-- Created By          : Alavudeen Ali Badusha.R
-- Client              : ABK
-- Created On          : 20-06-2016 
-------------------------------------------------------------------
drop table ompf_pr_min;
create table ompf_pr_min as
select ombrnm,omdlp,omdlr,min(omdte) omdte from ompf where ommvt = 'P' and ommvts = 'R' and omabf is not null  and to_number(omdte) > to_number(get_param('EODCYYMMDD')) 
group by ombrnm,omdlp,omdlr;
CREATE INDEX OMPF_PR_MIN_IDX ON OMPF_PR_MIN(OMBRNM, OMDLP, OMDLR, OMDTE);
drop table ompf_i_min;
create table ompf_i_min as
select ombrnm,omdlp,omdlr,min(omdte) omdte from ompf where ommvt = 'I' and trim(ommvts) is null and omabf is not null and to_number(omdte) > to_number(get_param('EODCYYMMDD'))
group by ombrnm,omdlp,omdlr;
CREATE INDEX ompf_i_min_idx ON ompf_i_min(OMBRNM, OMDLP, OMDLR, OMDTE);
drop table proper;
create table proper as (
select /*+ index(a OMPF_IDX,OMPF_IDX1,OMPF_ID2,MOMPF_IDXXX) */ a.* from ompf a 
inner join map_acc on leg_acc_num=a.ombrnm||trim(a.omdlp)||trim(a.omdlr)
inner join ompf_pr_min c on c.ombrnm=a.ombrnm and c.omdlp=a.omdlp and c.omdlr =a.omdlr and c.omdte = a.omdte 
where a.ommvt = 'P' and a.ommvts ='R' and schm_type='LAA');
create index proper_idx on proper(omabf,omanf,omasf);  
drop table ioper;
create table ioper as (
select /*+ index(a OMPF_IDX,OMPF_IDX1,OMPF_ID2,MOMPF_IDXXX) */ a.* from ompf a 
inner join map_acc on leg_acc_num=a.ombrnm||trim(a.omdlp)||trim(a.omdlr)
inner join ompf_i_min c on c.ombrnm=a.ombrnm and c.omdlp=a.omdlp and c.omdlr =a.omdlr and c.omdte = a.omdte 
where a.ommvt = 'I' and trim(a.ommvts) is null and schm_type='LAA');
create index ioper_idx on ioper(omabf,omanf,omasf);  
drop table operacc;
create table operacc as (
select a.*,fin_acc_num, map_acc.fin_sol_id,currency from (
select distinct nvl(a.ombrnm||a.omdlp||a.omdlr,b.ombrnm||b.omdlp||b.omdlr) ompf_leg_num,nvl(a.omabf||trim(a.omanf)||trim(a.omasf),b.omabf||trim(b.omanf)||trim(b.omasf)) oper_leg_acc from proper a
full join ioper b on b.ombrnm=a.ombrnm and b.omdlp=a.omdlp and b.omdlr =a.omdlr 
--where a.omabf=b.omabf and a.omanf=b.omanf  and a.omasf = b.omasf
)a
inner join map_acc on  leg_branch_id||leg_scan||leg_scas=oper_leg_acc
where schm_type in ('SBA','CAA','ODA'));
create index oper_idx on operacc(ompf_leg_num);
drop table iompf_laa;
create table iompf_laa as
select trim(ombrnm)||trim(omdlp)||trim(omdlr) del_ref_num,sum(omnwr) iomnwr   from ompf where OMMVT = 'I' and ommvts is null  group by ombrnm,omdlp,omdlr;
create index iompf_laa_idx on iompf_laa(del_ref_num);
------------------demand counter----------------
drop table demand_count;
create table demand_count as (    
--(select a.lsbrnm,a.lsdlp,A.lsdlr,max(lsdte) lsdte from lspf a
--inner join (select lsbrnm,lsdlp,lsdlr,max(lspdte) lspdte from lspf where LSAMTP <> 0  and lsamtd <> 0 and LSPDTE <> '9999999'   and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr) b on a.lsbrnm||a.lsdlp||A.lsdlr=b.lsbrnm||b.lsdlp||b.lsdlr and a.lspdte=b.lspdte  
--where (LSAMTD - LSAMTP) <> 0 
--group by a.lsbrnm,a.lsdlp,A.lsdlr) )
    select lsbrnm,lsdlp,lsdlr,min(lsdte) lsdte from lspf
    inner join map_acc on leg_acc_num=lsbrnm||trim(lsdlp)||trim(lsdlr)
    where (LSAMTD - LSAMTP) <> 0  and lsamtd <> 0  and lsdte <= get_param('EODCYYMMDD') 
    and schm_type ='LAA'  group by lsbrnm,lsdlp,lsdlr);
create index dmd_cnt_idx on demand_count(lsbrnm,lsdlp,lsdlr,lsbrnm||lsdlp||lsdlr);
------------------------Interest table code----------------------
drop table int_tbl;
create table int_tbl as
  SELECT leg_acc_num int_acc_num, v5dlp,v5ccy, schm_code , v5brr, d4brar BASE_EQ_RATE, v5drr,d5drar DIFF_EQ_RATE, v5rtm,v5spr,v5rat, 
    CASE WHEN v5rat <> 0 THEN 'ZEROL' 
         else convert_codes('INT_TBL_CODE',v5brr) END INT_TBL_CODE,
    CASE 
    WHEN convert_codes('INT_TBL_CODE',v5brr) <> 'ZEROL' THEN v5rtm +nvl(d5drar,0)
    WHEN convert_codes('INT_TBL_CODE',trim(v5brr)) = 'ZEROL' and (trim(v5brr) is not null or trim(v5rtm) <> 0 )THEN nvl(d4brar,0) + v5rtm +nvl(d5drar,0)
         ELSE to_number(v5rat)
         END ACC_PREF_RATE,
         case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end acct_open_date,
         case when R02RDT<>'0' and get_date_fm_btrv(R02RDT) <> 'ERROR' then to_date(get_date_fm_btrv(R02RDT),'YYYYMMDD') end Repricing_date
  FROM map_acc 
  inner join v5pf on v5brnm||v5dlp||trim(v5dlr) = leg_acc_num
  inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = map_acc.leg_acc_num -- Deal Account open date added on 22-05-2017
  left join (select  * from YRLN02PF where R02BRNM||TRIM(R02DLP)||TRIM(R02DLR)||trim(R02SEQ) in (select R02BRNM||TRIM(R02DLP)||TRIM(R02DLR)||max(trim(R02SEQ)) from YRLN02PF GROUP BY R02BRNM||TRIM(R02DLP)||TRIM(R02DLR)) and to_number(R02RDT) < to_number(get_param('EODCYYMMDD'))) rep_acc on R02BRNM||TRIM(R02DLP)||TRIM(R02DLR)=otbrnm||trim(otdlp)||trim(otdlr) 
  LEFT JOIN d4pf ON v5brr = d4brr and d4dte = 9999999 
  LEFT JOIN d5pf ON v5drr = d5drr and d5dte = 9999999
  left join map_codes on leg_code=v5brr 
  WHERE schm_type = 'LAA';
create index int_tbl_idx on int_tbl(int_acc_num);
create index int_tbl_idx1 on int_tbl(acct_open_date);
drop table loan_account_finacle_int_rate;
create table loan_account_finacle_int_rate
as
SELECT a.*,REPRICING_PLAN,csp.int_tbl_code tbl_code,X.base_pcnt_dr,X.base_pcnt_cr,nvl(c.nrml_int_pcnt,0) cr_nrml_int_pcnt, nvl(d.nrml_int_pcnt,0) dr_nrml_int_pcnt,acc_pref_rate - (nvl(X.base_pcnt_dr,0) + nvl(d.nrml_int_pcnt,0))actual_pref_rate
from int_tbl a
left join r8pf on r8lnp=trim(v5dlp)
LEFT JOIN (SELECT * FROM TBAADM.GSP WHERE DEL_FLG= 'N' AND bank_id = get_param('BANK_ID'))GSP ON A.SCHM_CODE = GSP.SCHM_CODE
left join(select * from tbaadm.csp where del_flg = 'N' and bank_id = get_param('BANK_ID'))csp on a.schm_code = csp.schm_code and a.v5ccy = csp.crncy_code
left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))b on  csp.int_tbl_code =b.int_tbl_code and  csp.CRNCY_CODE = b.CRNCY_CODE 
--and (CASE WHEN  GSP.schm_code in ('ERLI','GFX','NFX')  or  r8pf.r8crl = 'Y' or ( gsp.schm_code in ('NAF','NFD') and trim(v5brr) is null) THEN nvl(Repricing_date,acct_open_date) ELSE to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  END between b.start_date and b.MODIFY_END_DATE)
and (CASE WHEN  GSP.repricing_plan in ('F','M') or ( gsp.schm_code in ('NAF','NFD') and trim(v5brr) is null) THEN nvl(Repricing_date,acct_open_date) ELSE to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  END between b.start_date and b.MODIFY_END_DATE) ---changed on 01-08-2017 as per confirmation from Vijay,nagi,mehdi and hussaini reprising plan from bpd 
left join (select c.* from migr_int_icv c where c.del_flg = 'N' and c.bank_id = get_param('BANK_ID') and START_DATE <= to_date(get_param('EOD_DATE'),'DD-MM-YYYY'))X on  X.int_tbl_code =b.BASE_int_tbl_code and  X.CRNCY_CODE = b.CRNCY_CODE 
--and (CASE WHEN GSP.schm_code in ('ERLI','GFX','NFX')  or  r8pf.r8crl = 'Y' or (gsp.schm_code in ('NAF','NFD') and trim(v5brr) is null)  THEN nvl(Repricing_date,acct_open_date) ELSE to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  END between X.start_date and X.MODIFY_END_DATE)
and (CASE WHEN  GSP.repricing_plan in ('F','M') or ( gsp.schm_code in ('NAF','NFD') and trim(v5brr) is null) THEN nvl(Repricing_date,acct_open_date) ELSE to_date(get_param('EOD_DATE'),'DD-MM-YYYY')  END between X.start_date and X.MODIFY_END_DATE) ---changed on 01-08-2017 as per confirmation from Vijay,nagi,mehdi and hussaini reprising plan from bpd 
left join (select a.* from tbaadm.LAVS a 
    inner join (select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') and int_slab_dr_cr_flg = 'C' group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'C'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )C  on csp.int_tbl_code =C.int_tbl_code  and  csp.CRNCY_CODE = C.CRNCY_CODE 
left join (select a.* from tbaadm.LAVS a
inner join (
select  int_tbl_code,crncy_code,max(INT_TBL_VER_NUM) INT_TBL_VER_NUM, MIN(INT_SLAB_SRL_NUM)INT_SLAB_SRL_NUM
from tbaadm.LAVS where del_flg = 'N' and bank_id = get_param('BANK_ID') 
and int_slab_dr_cr_flg = 'D'
group by int_tbl_code,crncy_code) b on a.int_tbl_code=b.int_tbl_code and a.crncy_code=b.crncy_code and a.INT_TBL_VER_NUM=b.INT_TBL_VER_NUM
AND A.INT_SLAB_SRL_NUM = B.INT_SLAB_SRL_NUM AND A.int_slab_dr_cr_flg = 'D'
where del_flg = 'N' and bank_id = get_param('BANK_ID') )d  on csp.int_tbl_code =d.int_tbl_code  and  csp.CRNCY_CODE = d.CRNCY_CODE;
create index int_tbl_idx_1 on loan_account_finacle_int_rate(int_acc_num);
drop table owpf_note_laa;
create table owpf_note_laa as
select trim(owbrnm)||trim(owdlp)||trim(owdlr) leg_acc,OWSD1,OWSD2,OWSD3,OWSD4 from owpf 
where owmvt = 'P' and owmvts = 'C';
create index owpf_idx1 on owpf_note_laa(leg_acc);
---------------------------------------------------------------
truncate table LAM_O_TABLE;
insert into LAM_O_TABLE
select distinct
    rpad(map_acc.fin_acc_num,16,' '),
-- v_Customer_Credit_Pref_Percent  CHAR(10)
    lpad(' ',10,' '),
-- v_Customer_Debit_Pref_Percent   CHAR(10)
    lpad(' ',10,' '),
-- v_Acct_ID_Credit_Pref_Percent   CHAR(10)
    lpad(' ',10,' '),
-- v_Acct_ID_Debit_Pref_Percent       CHAR(10)
--    lpad(case when TO_number(ACC_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(ACC_PREF_RATE) else to_char(nvl(ACC_PREF_RATE,0)) end,10,' ') ,
    lpad(case 
	when trim(ret_loan.deal_reference) is not null then '6' ---added on 30-04-2017 based on vijay mail dt 30-04-2017
    --when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then to_char(nvl(ACC_PREF_RATE,0))
	--when r8pf.r8crl = 'Y' then to_char(nvl(ACC_PREF_RATE,0))--changed on 22-05-2017 by kumar
	when TO_number(ACTUAL_PREF_RATE) between 0.001 and 0.999 then '0'||to_char(ACTUAL_PREF_RATE) else to_char(nvl(ACTUAL_PREF_RATE,0)) end,10,' ') ,
-- v_Repricing_Plan           CHAR(1)
    --rpad( case when tbaadm.LSP.upfront_int_loan_flg = 'Y' then 'F' else tbaadm.GSP.repricing_plan end,1,' '),
    --rpad( case when obcrcl = 'Y' then 'F' else 'V' end,1,' '), --changed on 03-10-2016 because obpf -obcrcl has null value.
    --rpad( case when map_acc.schm_code in ('ERLI','GFX','NFX') THEN 'M' 	when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'F' when r8pf.r8crl = 'Y' then 'F' else 'V' end,1,' '), ---commented on 01-08-2017 as per confirmation from Vijay,nagi,mehdi and hussaini reprising plan from bpd 
	rpad( case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'F' else tbaadm.GSP.repricing_plan end,1,' '), ---changed on 01-08-2017 as per confirmation from Vijay,nagi,mehdi and hussaini reprising plan from bpd 
-- v_Pegging_Frequency_in_Months   CHAR(4)
    lpad(case when map_acc.schm_code in ('ERLI','GFX','NFX') THEN '60' else ' ' end,4,' '),
-- v_Pegging_Frequency_in_Days       CHAR(3)
    lpad(' ',3,' '),
--   v_Interest_Route_Flag       CHAR(1)
    --lpad(nvl(tbaadm.lsp.int_route_flg,' '),1,' '),
    lpad('O',1,' '),
	--lpad('L',1,' '), ---changed as per karthik sir confirmation on 27-04-2017.---- commented on 17-07-2017 based on mk5 observation --overdue interest not included in otdla hence commented
-- v_Acct_Currency_Code           CHAR(3)
    rpad(otccy,3,' '),
--   v_Sol_ID               CHAR(8)
    rpad(map_acc.fin_sol_id,8,' '),
--   v_GL_Sub_Head_Code           CHAR(5)
    --rpad(nvl(tbaadm.gss.gl_sub_head_code,' '),5,' '),
    rpad(nvl(map_acc.gl_sub_headcode,' '),5,' '),
--   v_Schm_Code             CHAR(5)
    rpad(map_acc.schm_code,5,' '),
--   v_CIF_ID                 CHAR(32)
    rpad(map_acc.fin_cif_id,32,' '),
--   v_Acct_Open_Date           CHAR(10)
    rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
    else ' ' end,10,' '),  
--   v_Sanction_Limit           CHAR(17)
    --lpad(to_number(omnwp)/POWER(10,c8pf.C8CED),17,' '),
    --case when obcrcl='Y' then lpad(ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED),17,' ')--changed on 03-10-2016 because obpf -obcrcl has null value.
    --case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null  then  lpad(ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED),17,' ')
	--when r8pf.r8crl='Y' then lpad(ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED),17,' ') else lpad(to_number(ompf.omnwp/POWER(10,c8pf.C8CED)),17,' ') end,---changed on 01-08-2017 as per vijay confirmation
	case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null  then  lpad(ompf.omnwp/POWER(10,c8pf.C8CED),17,' ')
	when r8pf.r8crl='Y' then lpad(ompf.omnwp/POWER(10,c8pf.C8CED),17,' ') else lpad(to_number(ompf.omnwp/POWER(10,c8pf.C8CED)),17,' ') end,
--   v_Ledger_Number           CHAR(3)
    rpad(' ',3,' '),
--   v_Sector_Code           CHAR(5)KTWORKS
    case when get_param('BANK_ID')='02'then rpad(convert_codes('SECTOR_CODE',trim(gf.GFC3R)),5,' ') 
      --else rpad(convert_codes('SECTOR_CODE',trim(gf.GFC2R)),5,' ') end,--changed on 07-03-2017 as per vijay confirmation
	  else rpad(convert_codes('SECTOR_CODE',trim(SCC2R)),5,' ') end,--changed on 17-08-2017 as per vijay discussion with Sandeep 
--   v_Sub_Sector_Code           CHAR(5)KTWORKS
    case when get_param('BANK_ID')='02' then rpad(nvl(trim(gf.GFC3R),'ZZZ'),5,' ')
          --else rpad(nvl(trim(gf.GFC2R),'ZZZ'),5,' ') end,--changed on 07-03-2017 as per vijay confirmation
		  else rpad(nvl(trim(SCC2R),'ZZZ'),5,' ') end,--changed on 17-08-2017 as per vijay discussion with Sandeep 
-- v_Purpose_of_Advance           CHAR(5)
    case when get_param('BANK_ID')='02' then rpad(nvl(trim(SCC3R),'999'),5,' ')
    else rpad(nvl(trim(SCC2R),'999'),5,' ') end,  
--  v_Nature_of_Advance           CHAR(5)
    rpad('999',5,' '),
--   v_Free_Code_3           CHAR(5)
    lpad(' ',5,' '),
--  v_Sanction_Reference_Number       CHAR(25)
    rpad(' ',25,' '),
--   v_Sanction_Limit_Date       CHAR(10)
      rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY')
    else ' ' end,10,' '),  
--   v_Sanction_Level_Code       CHAR(5)
    --rpad('99999',5,' '),
    rpad('999',5,' '),
--  v_Limit_Expiry_Date           CHAR(10)
    rpad(case when otmdt<>'0' and otmdt<>'9999999'  and get_date_fm_btrv(otmdt) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY')
     else '' end,10,' '),
--   v_Sanction_Authority_Code       CHAR(5)
    --rpad('99999',5,' '),
    rpad('999',5,' '),
--   v_Loan_Paper_Date           CHAR(10)
    rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end,10,' '),      
--  v_Operative_Acct_ID           CHAR(16)
    rpad(case when oper.fin_acc_num is not null then oper.fin_acc_num else ' ' end ,16,' '),
--   v_Operative_Currency_Code       CHAR(3)
    rpad(case when oper.fin_acc_num is not  null then oper.currency else ' ' end ,3,' '),
--   v_Operative_Sol_ID           CHAR(8)
    rpad(case when oper.fin_acc_num is not  null then oper.fin_sol_id else ' ' end ,8,' '),
--   v_Demand_Satisfy_Method       CHAR(1)
    rpad(case when map_acc.schm_code in ('YCB','ZCB','ZFF','ZCO','YCO') then 'N' when trim(oper.fin_acc_num) is not null then  'E' else 'N' end,1,' '),
-- v_Lien_on_Operative_Acct_Flag   CHAR(1)
    rpad(case when oper.fin_acc_num is not null then tbaadm.LSP.lien_on_oper_Acct_flg else 'N' end,1,' '), 
-- v_Repayment_currency_rate_code  CHAR(5)
    rpad(' ',5,' '),
-- v_Interest_table_code       CHAR(5)
   -- rpad(nvl(int_tbl.INT_TBL_CODE,'ZEROL'),5,' '),
    case when trim(ret_loan.deal_reference) is not null then 'ZEROL' ---added on 30-04-2017 based on vijay mail dt 30-04-2017
	--when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'ZEROL'
	--when r8pf.r8crl = 'Y' then 'ZEROL'--changed on 22-05-2017 by kumar
	else rpad(nvl(int_tbl.TBL_CODE,'ZEROL'),5,' ') end,
-- v_Interest_on_principal_Flag       CHAR(1)
    rpad(nvl(tbaadm.LSP.int_on_p_flg,' '),1,' '),
-- v_Penal_int_ovdue_princ_dmd_Fl CHAR(1)
--    rpad(nvl(tbaadm.LSP.pi_on_pdmd_ovdu_flg,' '),1,' '),
     'N', --based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_Princ_Dmd_Ovdue_end_month_Fl CHAR(1)
    rpad(nvl(tbaadm.LSP.pdmd_ovdu_eom_flg,' '),1,' '),
--   v_Int_On_Int_Demand_Flag       CHAR(1)
    --rpad(nvl(tbaadm.LSP.int_on_idmd_flg,' '),1,' '),
    'N', --based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_penal_int_overdue_int_dmd_Fl CHAR(1)
    --rpad(nvl(tbaadm.LSP.pi_on_idmd_ovdu_flg,' '),1,' '),
    'N', --based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_Int_Demand_Ovdue_End_Mnth_Fl CHAR(1)
    rpad(nvl(tbaadm.LSP.idmd_ovdu_eom_flg,' '),1,' '),
-- v_Transfer_Effective_Date       CHAR(10) ~
    rpad(get_param('EOD_DATE'),10,' '),   
-- v_Cumulative_Normal_int_am       CHAR(17)
    lpad(' ',17,' '),  --Inital mapping not done. Field mapping and logic to be provide by bank 
--   v_Cumulative_penal_int_amt       CHAR(17)
    lpad(' ',17,' '),  --Inital mapping not done. Field mapping and logic to be provide by bank 
-- v_cumulative_additional_int_am CHAR(17)
    lpad(' ',17,' '),
-- v_Liab_Transfer_Effective_date  CHAR(17)
    rpad(to_number(otdla)/POWER(10,c8pf.C8CED),17,' '),
-- v_Disbursement_Previous_Sche    CHAR(17)
    --lpad(to_number(ompf.omnwp)/POWER(10,c8pf.C8CED) - otdla/POWER(10,c8pf.C8CED) ,17,' '),
    --lpad(to_number(case when obcrcl='Y' and ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED) > 0 then ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED) --changed on 03-10-2016 because obpf -obcrcl has null value.
    --lpad(case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null and ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED) > 0 then ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED)
	--when r8pf.r8crl='Y' and ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED) > 0 then ompf.omnwp/POWER(10,c8pf.C8CED)-nvl(iomnwr,0)/POWER(10,c8pf.C8CED)
    --when nvl(trim(r8pf.r8crl),'N')='N' and (to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)) > 0  then to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) else 0 end,17,' '), ---changed on 01-08-2017 as per vijay confirmation--interest amount should not subtract
	--lpad(case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then ompf.omnwp/POWER(10,c8pf.C8CED)
	--when r8pf.r8crl='Y' then ompf.omnwp/POWER(10,c8pf.C8CED)
    --when nvl(trim(r8pf.r8crl),'N')='N' and (to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)) > 0  then to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) else 0 end,17,' '),	-- changed on 24-08-2017 as per Sandeep requirment changed done by Kumar
	lpad(case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null  and (to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)) > 0 then to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) 
	when r8pf.r8crl='Y' and (to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)) > 0 then to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) 
    when nvl(trim(r8pf.r8crl),'N')='N' and (to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED)) > 0  then to_number(ompf.omnwp)/POWER(10,c8pf.C8CED)- otdla/POWER(10,c8pf.C8CED) else 0 end,17,' '),
-- v_Debit_Int_Calc_upto_date      CHAR(10)
    rpad( case when v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY')
               when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') else '' end,10,' '),   
--   v_Repayment_Schedule_Date       CHAR(10) 
    rpad(case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end,10,' '),      
-- v_Repayment_Period_in_months       CHAR(3) KTWORKS change key_value to get_config
     rpad(
     --case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
     case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then  floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1))
     else floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'))) end
     --else 0 end
     ,3,' '),                                                             
--   v_Repayment_Period_in_Days       CHAR(3) KTWORKS change key_value to get_config
lpad(--case when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' and otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt <> '9999999' then 
case when last_day(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')) = to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') then 
          to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1 - add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')-1,to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1 ))) 
     else to_date(get_date_fm_btrv(otmdt),'YYYYMMDD')- add_months(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),floor(MONTHS_BETWEEN( to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') ))) end
--else 0 end
,3,' '),
--   v_Past_Due_Flag           CHAR(1)
    --lpad(case when iis.accc is not null then 'Y'
     --else 'N' end,1,' '), ---This is added on 02-08-2017. based on discussion with vijay and sandeep mail dt 02-08-2017.-----based on discussion with vijay on 06-08-2017 script changed-----commented on 11-09-2017 based on vijay confirmation
     lpad('N',1,' '),
--   v_Past_Due_Transfer_Date       CHAR(10)
--  rpad(case when iis.accc is not null then to_char(to_date(get_param('EOD_DATE'),'DD-MM-YYYY')-to_number(nvl(MAXOFDUDAYS,0)),'DD-MM-YYYY')
--     else ' ' end,10,' '), ---This is added on 02-08-2017. based on discussion with vijay and sandeep mail dt 02-08-2017.-----based on discussion with vijay on 06-08-2017 script changed
	 --rpad(case  when iis.accc is not null and dmd_cnt.lsbrnm is not null and lsdte <> 0  then to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY')
     ----when iis.accc is not null then to_char(to_date(get_param('EODCYYMMDD'),'YYYYMMDD'),'DD-MM-YYYY')
	 --when iis.accc is not null then get_param('EOD_DATE')
	 --else ' ' end,10,' '), ---This is added on 02-08-2017. based on discussion with vijay and sandeep mail dt 02-08-2017.-----based on discussion with vijay on 06-08-2017 script changed-------commented on 11-09-2017 based on vijay confirmation
	 lpad(' ',10,' '),
-- v_Prv_To_Pd_GL_Sub_Head_Code       CHAR(5)
    --rpad(case when iis.accc is not null then nvl(tbaadm.gss.gl_sub_head_code,' ') else ' ' end,5,' '), ---This is added on 02-08-2017. based on discussion with vijay and sandeep mail dt 02-08-2017.--commented on 11-09-2017 based on vijay confirmation
	lpad(' ',5,' '),
--   v_Interest_Suspense_Amount       CHAR(17)
     --lpad(case when iis.accc is not null  then to_char(nvl(trim(TOTAL_INTEREST_PAST_DUE),0))
     --else ' ' end,17,' '), ---This is added on 02-08-2017. based on discussion with vijay and sandeep mail dt 02-08-2017.-----based on discussion with vijay on 06-08-2017 script changed--commented on 11-09-2017 based on vijay confirmation
	 lpad(' ',17,' '),
-- v_Penal_Interest_Suspense_Amt   CHAR(17)
    lpad(' ',17,' '),
--   v_Charge_Off_Flag           CHAR(1)
    'N',
--   v_Charge_Off_Date           CHAR(10)
    rpad(' ',10,' '),
--   v_Charge_Off_Principle       CHAR(17)
    rpad(' ',17,' '),
--   v_Pending_Interest           CHAR(17)
    lpad(' ',17,' '),
-- v_Principal_Recovery           CHAR(17)
    lpad(' ',17,' '),
-- v_Interest_Recovery           CHAR(17)
    lpad(' ',17,' '),
-- v_source_dealer_code           CHAR(20)
    rpad(' ',20,' '),
--   v_Disburse_dealer_code       CHAR(20)
    rpad(' ',20,' '),
--   v_Apply_late_fee_Flag       CHAR(1)
    rpad(tbaadm.lsp.apply_late_fee_flg,1,' '),
-- v_Late_Fee_Grace_Period_Months  CHAR(3)
    lpad(LATEFEE_GRACE_PERD_MNTHS,3,' '),
-- v_Late_Fee_Grace_Period_Days       CHAR(3)
    lpad(LATEFEE_GRACE_PERD_days,3,' '),
-- v_Instal_amt_collect_upfront       CHAR(1)
    lpad(tbaadm.lsp.upfront_instlmnt_coll,1,' '),
-- v_Num_of_instal_collec_upfront  CHAR(2)
    lpad(' ',2,' '),
-- v_upfront_instalment_amount       CHAR(17)
    lpad(' ',17,' '),
--   v_Demand_Past_Due_counter       CHAR(5)
    case --when iis.accc is not null then rpad(to_char(nvl(trim(MAXOFDUDAYS),'0')),5,' ')  --commented on 24-08-2017 based on discussion with vijay --from iis file maxofduedays not extracted actual overdue date considered.
	 when dmd_cnt.lsbrnm is not null and lsdte <> 0 and to_number(get_param('EODCYYMMDD'))-to_number(lsdte) >=0 then rpad(to_date(get_date_fm_btrv(get_param('EODCYYMMDD')),'YYYYMMDD')-to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),5,' ')
     else rpad('0',5,' ') end,
-- v_Sum_of_the_princ_demand_amt   CHAR(17)
    lpad(abs(to_number(nvl(sum_overdue,0)))/POWER(10,c8pf.C8CED),17,' '),
--   v_Payoff_Flag           CHAR(1)
    'N',
-- v_ExcLd_for_Combined_Statement  CHAR(1)
    ' ',
--   v_Statement_CIF_ID           CHAR(32)
    rpad(' ',32,' '),
--   v_Transfer_Cycle_String       CHAR(45)
    rpad( '000000000000000000000000000000000000000000000',45,' '),
--   v_Bank_IRR_Rate           CHAR(8)
    lpad(' ',8,' '),
--   v_Value_Of_Asset           CHAR(17)
    lpad(' ',17,' '),
--   v_Occupation_code_customer       CHAR(5)
    rpad(convert_codes('SUNDRY_ANALYSIS_CODE',trim(SCSAC)),5,' '),
--   v_Borrower_category_code       CHAR(5)
    rpad(' ',5,' '),
--   v_Mode_of_the_advance       CHAR(5)
    rpad(' ',5,' '),
--   v_Type_of_the_advance       CHAR(5)
    rpad(' ',5,' '),
--   v_guarantee_coverage_Code       CHAR(5)
    rpad(' ',5,' '),
--   v_Industry_Type           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_1           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_2           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_4           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_5           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_6           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_7           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_8           CHAR(5)
    rpad(' ',5,' ') ,
--   v_Free_Code_9           CHAR(5)
    rpad(' ',5,' '),
--   v_Free_Code_10           CHAR(5)
    rpad(' ',5,' '),
-- v_Acct_Location_Code           CHAR(5)
    rpad(' ',5, ' '),
-- v_credit_report_file_Ref_ID       CHAR(15)
    rpad(' ',15,' '),
-- v_DICGC_Fee_Percent           CHAR(8)
    lpad(' ',8,' '),
-- v_Last_Compound_Date           CHAR(10)KTWORKS 
    --rpad(case when tbaadm.LSP.int_on_idmd_flg ='Y' then get_param('EOD_DATE') else ' ' end ,10,' '),
    ' ',--based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_Daily_Compound_Interest_Flag  CHAR(1)
--    rpad(tbaadm.LSP.int_on_idmd_flg,1,' '),
'N',--based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_CalculateOverdue_Int_rate_Fl  CHAR(1)
    rpad(' ',1,' '),
-- v_EI_paying_period_start_date   CHAR(10)
    rpad(--case  when obpf.obcrcl = 'Y' and v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY') --changed on 03-10-2016 because obpf -obcrcl has null value.
    case  
	when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null and v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY')
	when r8pf.r8crl= 'Y' and v5lcd<> 0 and get_date_fm_btrv(v5lcd) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY')
               when otsdte<>'0' and get_date_fm_btrv(otsdte) <> 'ERROR' then to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end,10,' '),
-- v_EI_paying_period_end_date       CHAR(10)
    rpad(case when otmdt<>'0' and get_date_fm_btrv(otmdt) <> 'ERROR' and otmdt<>'9999999' then to_char(to_date(get_date_fm_btrv(otmdt),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end,10,' '),
--   v_IRR_Rate               CHAR(8)
    lpad(' ',8,' '),
--   v_Advance_interest_amount       CHAR(17)
    lpad(' ',17,' '),
--   v_Amortised_Amount           CHAR(17)
    lpad(' ',17,' '),
--   v_Debit_Booked_Upto_Date       CHAR(10)
    rpad(' ',10,' '),
-- v_Adv_Int_Collection_upto_Date  CHAR(10)
    rpad(' ',10,' '),
--   v_Accrual_Rate           CHAR(9)
    lpad(' ',9,' '),
-- v_Int_Rate_Sanction_Limit_Flg   CHAR(1)
    case 
        when tbaadm.LSP.int_prod_method = 'S' then  'Y'
        else tbaadm.LSP.int_rate_based_on_sanct_lim
    end,
--   v_Interest_Rest_Frequency       CHAR(1) KTWORKS I will give you the map frequency function
    rpad(' ',1,' '),
--   v_Interest_Rest_Basis       CHAR(1)
    rpad(' ',1,' '),
-- v_Charge_Route_Flag           CHAR(1)
    rpad(tbaadm.LSP.chrg_route_flg,1,' '),
--  v_Final_Disbursement_Flag       CHAR(1)
    'Y',
-- v_Auto_Resch_after_Holiday_Prd  CHAR(1)
    rpad(' ',1,' '),
-- v_total_number_of_deferments       CHAR(2)
    lpad(' ',2,' '),
-- v_num_deferments_current_repay  CHAR(2)
    lpad(' ',2,' '),
--   v_End_Date               CHAR(10)
    rpad(' ',10,' '),
-- v_Penal_interest_on_Outstandin  CHAR(1)
    --case when tbaadm.LSP.pi_on_pdmd_ovdu_flg = 'N' then ' ' else tbaadm.LSP.pi_based_on_outstanding end,
    ' ', --based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
--   v_Charge_off_type           CHAR(1)
    rpad(' ',1,' ') ,
-- v_Deferred_appli_int_rate_fl    CHAR(1)
    rpad(' ',1,' '),
--   v_Def_applicable_int_rate       CHAR(10)
    rpad(' ',10,' '),
--   v_Deferred_Interest_Amount       CHAR(17)
    lpad(' ',17,' '),
-- v_Auto_Reschedule_Not_Allowed   CHAR(1)
    rpad( nvl(tbaadm.LSP.auto_reshdl_not_allowed,' '),1,' '),
-- v_Rescheduled_Overdue_Principa  CHAR(17)
    lpad(' ',17,' '),
-- v_Reschedule_Overdue_Interest   CHAR(17)
    lpad(' ',17,' '),
-- v_Loan_Type               CHAR(1)
    lpad('N',1,' '),
--   v_Pay_Off_Reason_Code       CHAR(5)
    rpad(' ',5,' '),
--   v_Related_Deposit_Acct_ID       CHAR(16)
    rpad(' ',16,' '),
-- v_Last_AckNowledgt_Dr_Prd_date  CHAR(10)
    rpad(' ',10,' '),
--   v_Refinance_Sanction_Date       CHAR(10)
    rpad(' ',10,' '),
--   v_Refinance_Amount           CHAR(17)
    lpad(' ',17,' '),
--   v_Subsidy_Acct_ID           CHAR(16)
    rpad(' ',16,' '),
--   v_Subsidy_Agency           CHAR(16)
    rpad(' ',16,' '),
--   v_Subsidy_Claimed_Date       CHAR(10)
    rpad(' ',10,' '),
--   v_Subsidy_Activity_Code       CHAR(10)
    rpad(' ',10,' '),
-- v_Debit_AckNowledgement_Type       CHAR(1)
    rpad(' ',1,' '),
-- v_Refinance_Sanction_Number       CHAR(25)
    rpad(' ',25,' '),
-- v_Refinance_Reference_Number       CHAR(25)
    rpad(' ',25,' '),
--   v_Refinance_Claimed_Date       CHAR(10)
    rpad(' ',10,' '),
--   v_Subsidy_Amount           CHAR(17)
    lpad(' ',17,' '),
--   v_Subsidy_Received_Date       CHAR(10)
    rpad(' ',10,' '),
--   v_Preprocess_Fee           CHAR(17)
    lpad(' ',17,' '),
--   v_Activity_Code           CHAR(6)
    rpad(' ',6,' '),
-- v_Probation_Period_in_Months       CHAR(3)
    lpad(' ',3,' '),
--   v_Probation_Period_in_Days       CHAR(3)
    lpad(' ',3,' '),
-- v_Compound_Rest_Indicator_Flag  CHAR(1)
    rpad(' ',1,' '),
--   v_Discounted_Int_Rate_Flag       CHAR(1)
    rpad(' ',1,' '),
--   v_Collect_Interest_Flag       CHAR(1)
    rpad('Y',1,' '),
--   v_Despatch_mode           CHAR(1)
    rpad('N',1,' '),
--   v_Acct_Manager           CHAR(15)
    --rpad(' ',15,' '),
    rpad( case when nrd.officer_code is not null and trim(nrd.loginid) is not null then to_char(trim(nrd.loginid))
when trim(scpf.scaco)='199' then '199_RBD'
	else nvl(convert_codes('RMCODE',trim(scpf.scaco)),'UBSADMIN') end,15,' '), -- changed on 06-01-2017 as per Vijay Confirmation
-- v_Mode_of_Oper_Code           CHAR(5)
    rpad(' ',5,' '),
--   v_Statement_Frequency_Type       CHAR(1)
    rpad(' ',1,' '),
-- v_Week_num_for_Statement_Date   CHAR(1)
    rpad(' ',1,' '),
-- v_Week_Day_for_Statement_Date   CHAR(1)
    rpad(' ',1,' '),
-- v_Week_Dt_for_Statement_Date       CHAR(2)
    rpad(' ',2,' '),
-- v_Statement_Freq_case_of_Hldys  CHAR(1)
    rpad(' ',1,' '),
--   v_Statement_of_the_Account       CHAR(1)
    'N',
--   v_Next_Print_date           CHAR(10)
    rpad(' ',10,' '),
-- v_Fixed_Rate_Term_in_Months       CHAR(3)
    lpad(' ',3,' '),
--   v_Fixed_Rate_Term_in_Days       CHAR(3)
    lpad(' ',3,' '),
-- v_Minimum_Int_Percent_Debit       CHAR(10)
    lpad(' ',10,' '),
-- v_Maximum_Int_Percent_Debit       CHAR(10)
    lpad(' ',10,' '),
--   v_Instalment_Income_Ratio       CHAR(9)
    lpad(' ',9,' '),
--   v_Product_Group           CHAR(5)
    rpad(' ',5,' '),
-- v_Free_Text               CHAR(240)
    case when trim(OWSD1||OWSD2||OWSD3||OWSD4) is not null and trim(FTEXT) is not null then     to_char(rpad('Govt fund :'|| trim(OWSD1)||' '||trim(OWSD2)||' '||trim(OWSD3)||' '||trim(OWSD4)||'Deal Notes :' ||trim(FTEXT) ,240,' '))
    when trim(OWSD1||OWSD2||OWSD3||OWSD4) is not null and trim(FTEXT) is null then     to_char(rpad('Govt fund :' ||trim(OWSD1)||' '||trim(OWSD2)||' '||trim(OWSD3)||' '||trim(OWSD4),240,' '))
    when trim(OWSD1||OWSD2||OWSD3||OWSD4) is null and trim(FTEXT) is not null then     to_char(rpad('Deal Notes :'||trim(FTEXT),240,' '))
    else rpad(' ',240,' ') end,
   ---------------rpad(' ',240,' '),
--   case when trim(OWSD1||OWSD2||OWSD3||OWSD4) is not null then     to_char(rpad('Govt fund :' ||trim(OWSD1)||' '||trim(OWSD2)||' '||trim(OWSD3)||' '||trim(OWSD4),240,' '))
  --      else rpad(' ',240,' ') end,
-- v_Linked_Account_ID           CHAR(16)
    rpad(' ',16,' '),
-- v_Delinquency_Resch_Method_Flg  CHAR(1)
    rpad(' ',1,' '),
-- v_Total_Number_of_Switch_Over   CHAR(3)
    lpad(' ',3,' '),
--   v_Non_Starter_Flag           CHAR(1)
    rpad(' ',1,' '),
-- v_Floating_Interest_Table_Code  CHAR(5)
    rpad(' ',5,' '),
-- v_Floating_Repricing_Frequency  CHAR(3)
    lpad(' ',3,' '),
-- v_Floating_Repricing_Freq_Days  CHAR(3)
    lpad(' ',3,' '),
-- v_Single_EMI_Turn_Over_Diff_Fl  CHAR(1)
    rpad(' ',1,' '),
--   v_IBAN_Number           CHAR(34)
    lpad(nvl(map_acc.iban_number,' '),34,' '),
--   v_IAS_CLASSIFICATION_CODE       CHAR(5)
    rpad(' ',5,' '),
--   v_Account_Number1           CHAR(16)
    rpad(' ',16,' '),
--   v_Type_of_top_up           CHAR(1)
    rpad(' ',1,' '),
-- v_Negotiated_Rate_Debit_Percen CHAR(10)
    lpad(' ',10,' '),
-- v_Normal_Int_Product_Method       CHAR(1)
    rpad('F',1,' '),
-- v_Penal_Interest_Rate_Method       CHAR(1)
    --rpad(' ',1,' '),
    rpad('D',1,' '),    
--   v_Penal_Interest_Method       CHAR(1)
    --rpad(LSP.full_penal_mthd_flg,1,' '),
    'Y', --based on dicussion with Nagi and sandeep. Defaulted to 'N' becuase in legacy all the accounts interest routing will be in office account
-- v_hldy_prd_frm_first_disb_flg   CHAR(1)
    rpad(' ',1,' '),
--   v_EI_Scheme_Flag           CHAR(1)
    --rpad(nvl(tbaadm.LSP.ei_schm_flg,' '),1,' '),
    rpad(case 
	when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'Y'
	when r8pf.r8crl='Y' then 'Y'
    else 'N' end,1,' '),
-- v_EI_Method               CHAR(1)
    rpad(case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'R' else ' ' end,1,' '),
--   v_Ei_Formula_Flag           CHAR(1)
    rpad(case when map_acc.schm_code in ('NAF','NFD') and trim(v5pf.v5brr) is null then 'P' else ' ' end,1,' '),
--    rpad(lsp.ei_formula_flg,1,' '),
-- v_Normal_Holiday_Period_in_Mnt CHAR(3)
    lpad(' ',3,' '),
-- v_Holiday_Period_Interest_Flag  CHAR(1)
    rpad(' ',1,' '),
-- v_Holiday_Period_Interest_Amt   CHAR(17)
    lpad(' ',17,' '),
-- v_Resche_by_Adjust_TeNor_Amt       CHAR(1)
    rpad(' ',1,' '),
-- v_Auto_Reschedule_every_Disb       CHAR(1)
    rpad(' ',1,' '),
-- v_Auto_Reschule_Int_Rate_Chang  CHAR(1)
    rpad(' ',1,' '),
-- v_Auto_Reschedule_Prepayment       CHAR(1)
    rpad(' ',1,' '),
--   v_Rescheduling_Amount_flag       CHAR(1)
    rpad(' ',1,' '),
-- v_Capitalize_Int_on_Rephasemen  CHAR(1)
    rpad(' ',1,' '),
-- v_Carry_over_Demands           CHAR(1)
    rpad(' ',1,' '),
-- v_Type_Instalment_Combination   CHAR(1)
    rpad(' ',1,' '),
-- v_Cap_Int_to_EMI_Flg           CHAR(1)
    rpad(' ',1,' '),
-- v_Deferred_Int_Due_to_EMI_Cap   CHAR(17)
    lpad(' ',17,' '),
--   v_Month_for_Deferment       CHAR(2)
    lpad(' ',2,' '),
--   v_Num_Months_Deferred       CHAR(2)
    lpad(' ',2,' '),
-- v_Channel_Credit_Pref_Percent   CHAR(10)
    lpad(' ',10,' '),
-- v_Channel_Debit_Pref_Percent       CHAR(10)
    lpad(' ',10,' '),
-- v_Channel_Id               CHAR(5)
    rpad(' ',5,' '),
-- v_Channel_Level_Code           CHAR(5)
    rpad(' ',5,' '),
-- v_Instalment_Effective_Flag       CHAR(1)
    rpad(' ',1,' '),
--   v_Notice_Period           CHAR(3)
    rpad(' ',3,' '),
--   v_Shift_Instalment_Flag       CHAR(1)
    rpad(' ',1,' '),
--   v_Include_Maturity_Date       CHAR(1)
    rpad(' ',1,' '),
-- v_Interest_Rule_Code           CHAR(5)
    rpad(' ',5,' '),
-- v_Cumulative_Capitalize_Fees       CHAR(17)
    lpad(' ',17,' '),
-- v_upfront_instalment_int_amoun  CHAR(17)
    lpad( ' ',17,' '),
--  v_Recall_Flag           CHAR(1)
    rpad(' ',1,' '),
--   v_Recall_Date           CHAR(10)
    rpad(' ',10,' '),
-- v_Diff_PS_Freq_For_Rel_Part       CHAR(1)
    rpad(' ',1,' '),
-- v_Diff_Swift_Freq_For_Rel_Part  CHAR(1)
    rpad(' ',1,' '),
-- v_Penal_Interest_table_code       CHAR(5)
    rpad(' ',5,' '),
-- v_Penal_Preferential_Percent       CHAR(10)
    lpad(' ',10,' '),
--   v_RA_ref_number           CHAR(16)
    rpad(' ',16,' '),
--   v_Interest_table_Version       CHAR(5)
    rpad(' ',5,' '),
--   v_Address_Type           CHAR(12)
    rpad(' ',12,' '),
-- v_Phone_Type               CHAR(12)
    rpad(' ',12,' '),
-- v_Email_Type               CHAR(12)
    rpad(' ',12,' '),
-- v_Accrued_Penal_Int_Recover       CHAR(17)
    lpad(' ',17,' '),
-- v_Penal_Interest_Recovery       CHAR(17)
    lpad(' ',17,' '),
-- v_Collection_Interest_Recovery  CHAR(17)
    lpad(' ',17,' '),
-- v_Collection_Penal_Int_Recover  CHAR(17)
    lpad(' ',17,' '),
--   v_Mark_Up_Applicable_Flag       CHAR(1)   
    rpad(' ',1,' '),
-- v_Pref_Calendar_base_processin CHAR(2)
    rpad(' ',2,' '),
-- v_Purchase_Reference           CHAR(12)
    rpad(' ',12,' '),
--  v_Frez_code               CHAR(1)
    rpad(' ',1,' '),
--   v_Frez_reason_code           CHAR(5)
    rpad(' ',5,' '),
--   Bank_Profit_Share_Pcnt    CHAR(10) NULL,
lpad(' ',10,' '),
--   Bank_Loss_Share_Pcnt    CHAR(10) NULL,
lpad(' ',10,' '),
--   Next_Profit_Adj_Due_Dt    CHAR(10) NULL,
rpad(' ',10,' '),
--   Profit_Adj_Freq    CHAR(1) NULL,
rpad(' ',1,' '),
--   Week_Num_for_Profit_Adj    CHAR(1) NULL,
lpad(' ',1,' '),
--   Week_Day_for_Profit_Adj    CHAR(1) NULL,
lpad(' ',1,' '),
--   Start_Day_for_Profit_Adj    CHAR(2) NULL,
lpad(' ',2,' '),
--   Profit_Adj_Freq_holidays    CHAR(1) NULL,
rpad(' ',1,' '),
--   Adj_Freq_Calendar_Base    CHAR(2) NULL,
rpad(' ',2,' '),
--   Salam_Sale_Ref_ID    CHAR(10) NULL,
rpad(' ',10,' '),
--   Salam_Asset_Code    CHAR(12) NULL,
rpad(' ',12,' '),
--   Seller_Dealer_ID    CHAR(15) NULL,
rpad(' ',15,' '),
--   Salam_Seller_Det    CHAR(50) NULL,
rpad(' ',50,' '),
--   Para_Salam_Seller_Ref_ID    CHAR(10) NULL,
rpad(' ',10,' '),
--   Para_Salam_Asset_Code    CHAR(12) NULL,
rpad(' ',12,' '),
--   Buyer_Dealer_ID    CHAR(15) NULL,
rpad(' ',15,' '),
--   Salam_Buyer_Details    CHAR(50) NULL,
rpad(' ',50,' '),
--   Purchase_Price_Per_Unit    CHAR(17) NULL,
lpad(' ',17,' '),
--   Dealer_Id    CHAR(15) NULL,
rpad(' ',15,' '),
--   Asset_Code    CHAR(15) NULL,
rpad(' ',15,' '),
--   Margin_Money_Acc_Flag    CHAR(1) NULL,
rpad(' ',1,' '),
--   Margin_Money_Type    CHAR(1) NULL,
rpad(' ',1,' '),
--   Margin_Money_Pcnt    CHAR(3) NULL,
lpad(' ',3,' '),
--   Margin_Money_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Invoice_Amount    CHAR(17) NULL,
lpad(' ',17,' '),
--   Debit_Account_ID    CHAR(25) NULL,
rpad(' ',25,' '),
--   Purchase_Aqad_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Sale_Aqad_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Purc_Aqad_Ref    CHAR(12) NULL,
rpad(' ',12,' '),
--   Sale_Aqad_Ref    CHAR(12) NULL,
rpad(' ',12,' '),
--   Purc_Aqad_Date    CHAR(10) NULL,
rpad(' ',10,' '),
--   Purc_Aqad_DateHH    CHAR(2) NULL,
rpad(' ',2,' '),
--   Purc_Aqad_DateMM    CHAR(2) NULL,
rpad(' ',2,' '),
--   Purc_Aqad_DateSS    CHAR(2) NULL,
rpad(' ',2,' '),
--   Sale_Aqad_Date    CHAR(10) NULL,
rpad(' ',10,' '),
--   Sale_Aqad_DateHH    CHAR(2) NULL,
rpad(' ',2,' '),
--   Sale_Aqad_DateMM    CHAR(2) NULL,
rpad(' ',2,' '),
--   Sale_Aqad_DateSS    CHAR(2) NULL,
rpad(' ',2,' '),
--   No_Of_Units    CHAR(5) NULL,
lpad(' ',5,' '),
--   Asset_Particulars    CHAR(30) NULL,
rpad(' ',30,' '),
--   Unearned_Income    CHAR(17) NULL,
lpad(' ',17,' '),
--   Security_Dep_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Adj_Advance_Rent    CHAR(1) NULL,
rpad(' ',1,' '),
--   Repossess_Flag    CHAR(1) NULL,
rpad(' ',1,' '),
--   Cumu_Deposit_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Last_Dep_Date    CHAR(10) NULL,
rpad(' ',10,' '),
--   Istisna_with_Parallel_Istisna    CHAR(1) NULL,
rpad(' ',1,' '),
--   Construction_TenorMM    CHAR(3) NULL,
lpad(' ',3,' '),
--   SettlementTenorMM    CHAR(3) NULL,
lpad(' ',3,' '),
--   SettlementTenorDD    CHAR(3) NULL,
lpad(' ',3,' '),
--   Istisna_Contract_ID    CHAR(15) NULL,
rpad(' ',15,' '),
--   Cost_Of_Construction    CHAR(17) NULL,
lpad(' ',17,' '),
--   Unearned_Inc_for_Cons_Prd    CHAR(17) NULL,
lpad(' ',17,' '),
--   Unearned_Inc_for_Settle_Prd    CHAR(17) NULL,
lpad(' ',17,' '),
--   Const_Prd_Profit_Method    CHAR(1) NULL,
rpad(' ',1,' '),
--   Retention_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Retentio_Rel_Flg    CHAR(1) NULL,
rpad(' ',1,' '),
--   Parallel_Istisna_Delivery_Dt    CHAR(10) NULL,
rpad(' ',10,' '),
--   Builder_Profit    CHAR(1) NULL,
rpad(' ',1,' '),
--   Builder_Profit_Pcnt    CHAR(10) NULL,
lpad(' ',10,' '),
--   Builder_Profit_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Notes    CHAR(80) NULL,
rpad(' ',80,' '),
--   Builder_ACC_ID    CHAR(16) NULL,
lpad(' ',16,' '),
--   Is_CP_Over    CHAR(1) NULL,
rpad(' ',1,' '),
--   Rebate_Benefit_Amount    CHAR(17) NULL,
lpad(' ',17,' '),
--   Process_Rebate_on_Mat    CHAR(1) NULL,
rpad(' ',1,' '),
--   Print_Print_Statement    CHAR(1) NULL,
rpad(' ',1,' '),
--   Print_Advice_for_SI    CHAR(1) NULL,
rpad(' ',1,' '),
--   Print_Deposit_Notice    CHAR(1) NULL,
rpad(' ',1,' '),
--   Print_Loan_Notice    CHAR(1) NULL,
rpad(' ',1,' '),
--   Interest_Certificate    CHAR(1) NULL,
rpad(' ',1,' '),
--   Interest_Rate_Change_Adv    CHAR(1) NULL,
rpad(' ',1,' '),
--   Collect_Excess_Profit    CHAR(1) NULL,
rpad(' ',1,' '),
--   Carry_Forward    CHAR(1) NULL,
rpad(' ',1,' '),
--   Adj_Order_for_CF_PL    CHAR(1) NULL,
rpad(' ',1,' '),
--   Expected_Turnover_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Turn_Over_Currency    CHAR(3) NULL,
rpad(' ',3,' '),
--   Expected_Profit_Amt    CHAR(17) NULL,
lpad(' ',17,' '),
--   Profit_Currency    CHAR(3) NULL,
rpad(' ',3,' '),
--   Nature_of_Business    CHAR(255) NULL,
rpad(' ',255,' '),
--   Free_Text2    CHAR(255) NULL,
--case when trim(FTEXT) is not null then     to_char(rpad('Deal Notes :'||trim(FTEXT),255,' ')) else rpad(' ',255,' ') end,
rpad(' ',255,' '),
--rpad(' ',255,' '),
--   Asset_Id    CHAR(16) NULL,
rpad(' ',16,' '),
--   Lease_type    CHAR(1) NULL,
rpad(' ',1,' '),
--   End_of_Lease_Option    CHAR(1) NULL,
rpad(' ',1,' '),
--   Collect_security_Deposit    CHAR(1) NULL,
rpad(' ',1,' '),
--   Adjust_Security_Deposit    CHAR(1) NULL,
rpad(' ',1,' '),
--   Agreed_Usage_Freq    CHAR(1) NULL,
rpad(' ',1,' '),
--   Agreed_Usage    CHAR(17) NULL,
lpad(' ',17,' '),
--   Collect_Tax    CHAR(1) NULL,
rpad(' ',1,' '),
--   Collect_Insu_Premium    CHAR(1) NULL,
rpad(' ',1,' '),
--   Residual_Value_type    CHAR(1) NULL,
rpad(' ',1,' '),
--   Guaranteed_by    CHAR(1) NULL,
rpad(' ',1,' '),
--   Apply_Lease_Canc_Fee    CHAR(1) NULL,
rpad(' ',1,' '),
--   Lease_Canc_not_acce_after_days    CHAR(2) NULL,
lpad(' ',2,' '),
--   Lease_Canc_not_accp_after_Mths    CHAR(2) NULL,
lpad(' ',2,' '),
--   Expected_Future_Value    CHAR(17) NULL,
lpad(' ',17,' '),
--   Carry_Over_Rents    CHAR(1) NULL,
rpad(' ',1,' '),
--   Rent_Dmd_OD_at_end_of_Mnth    CHAR(1) NULL,
rpad(' ',1,' '),
--   Rent_Dmd_OD_at_end_of_days    CHAR(3) NULL,
rpad(' ',3,' '),
--   Rent_OD_After_MMMDDD    CHAR(3) NULL,
lpad(' ',3,' '),
--   Lnk_Trade_Fin_Entity_Type    CHAR(5) NULL,
rpad(' ',5,' '),
--   Linked_Entity_Sol_ID    CHAR(8) NULL,
rpad(' ',8,' '),
--   Linked_Trade_Fin_Entity_ID    CHAR(16) NULL,
rpad(' ',16,' '),
--   Intend_to_Export    CHAR(1) NULL,
rpad(' ',1,' '),
--   Exp_Financing_Type    CHAR(1) NULL,
rpad(' ',1,' '),
--   Exp_Financing_Perc    CHAR(8) NULL,
lpad(' ',8,' '),
--   Broken_Prd_Int_Flag    CHAR(1) NULL,
rpad(' ',1,' '),
--   Normal_Hldy_Prd_in_Days    CHAR(2) NULL
rpad(' ',2,' ')       
from map_acc 
inner join v5pf on v5brnm||v5dlp||trim(v5dlr) = map_acc.leg_acc_num
left join scpf on scab||scan||scas=V5ABD||v5AND||V5ASD
left join tbaadm.lsp on tbaadm.lsp.schm_code = map_acc.schm_code and map_acc.currency=lsp.crncy_code and lsp.del_flg <> 'Y' and lsp.bank_id=get_param('BANK_ID')
left join tbaadm.gsp on tbaadm.gsp.schm_code = map_acc.schm_code and gsp.del_flg <> 'Y' and gsp.bank_id=get_param('BANK_ID')
left join tbaadm.gss on tbaadm.gss.schm_code = map_acc.schm_code and gss.del_flg <> 'Y' and gss.default_flg='Y' and  gss.bank_id=get_param('BANK_ID')
inner join otpf on otbrnm||trim(otdlp)||trim(otdlr) = map_acc.leg_acc_num
--left join jgpf on jgbrnm||trim(jgdlp)||trim(jgdlr) = map_acc.leg_acc_num------changed by gopal because of duplicates in free text
left join (SELECT trim(jgbrnm)||trim(jgdlp)||trim(jgdlr) jgacc, LISTAGG(trim(jgcf), ',')  WITHIN GROUP (ORDER BY trim(jgbrnm)||trim(jgdlp)||trim(jgdlr)) FTEXT
FROM jgpf
GROUP BY trim(jgbrnm)||trim(jgdlp)||trim(jgdlr))jgpf on jgacc=map_acc.leg_acc_num 
inner join (select ombrnm||omdlp||trim(omdlr) ompf_leg_num,sum(omnwp) omnwp from ompf inner join map_acc on ombrnm||omdlp||trim(omdlr) =leg_acc_num where schm_type='LAA' and ommvt='P' and ommvts in ('C','O') group by ombrnm||omdlp||trim(omdlr))OMPF ON trim(OMPF_LEG_NUM)=LEG_ACC_NUM
--inner join obpf on obdlp=v5dlp
left join r8pf on r8lnp=trim(v5dlp)
--left join (select ombrnm,omdlp,omdlr,sum(omnwr) iomnwr   from ompf where OMMVT = 'I' and ommvts is null  group by ombrnm,omdlp,omdlr) iompf on iompf.ombrnm||iompf.omdlp||trim(iompf.omdlr)=LEG_ACC_NUM
left join iompf_laa on iompf_laa.del_ref_num=map_acc.LEG_ACC_NUM
left join (select lsbrnm,lsdlp,lsdlr,sum(lsamtd - lsamtp) sum_overdue from lspf where lsmvt='P' and (LSAMTD - LSAMTP) < 0 and lsamtd <> 0  and lsdte <= get_param('EODCYYMMDD') group by lsbrnm,lsdlp,lsdlr)lspf on lspf.lsbrnm||trim(lspf.lsdlp)||trim(lspf.lsdlr)=leg_acc_num
left join operacc oper on  trim(oper.ompf_leg_num)=leg_acc_num
left join demand_count dmd_cnt on  dmd_cnt.lsbrnm||trim(dmd_cnt.lsdlp)||trim(dmd_cnt.lsdlr)=leg_acc_num
left join loan_account_finacle_int_rate int_tbl on trim(int_acc_num)=leg_acc_num
left join owpf_note_laa on leg_acc=map_acc.leg_acc_num
left join (select * from map_cif where del_flg<>'Y') map_cif on map_cif.FIN_CIF_ID=map_acc.FIN_CIF_ID
left join gfpf gf on gf.gfcus=map_cif.gfcus and gf.gfclc=map_cif.gfclc and gf.gfcpnc=MAP_CIF.GFCPNC
left  join retail_loans_2008 ret_loan on leg_acc_num=trim(deal_branch)||trim(ret_loan.deal_type)||trim(deal_reference)
inner join c8pf on c8ccy = otccy
left join NEWRMCODE_DATA nrd on trim(nrd.officer_code)=trim(scaco)
left join iis_laa_account iis on trim(v5dlr)=dlref and act=v5act and v5brnm =substr(accc,1,4)
where map_acc.schm_type='LAA';
commit;
-----------duplicate deleted because in tbaadm.gss table duplicate entry's. Eq one product linked with multiple gl sub head code----------------------------
delete from lam_o_table where rowid not in (select min(rowid) from lam_o_table group by account_number);
commit; 
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
RL003_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
RL003_upload.sql 
-- File Name        : LRS_upload.sql
-- File Created for : Upload file for LRS
-- Created By       : R.Alavudeen Ali badusha
-- Client           : ABK
-- Created On       : 20-06-2016 
-------------------------------------------------------------------
DROP TABLE OMPF_TEST;
truncate table OMPF_MAIN;
CREATE TABLE OMPF_TEST AS
SELECT FIN_ACC_NUM,CONV_TO_VALID_DATE(GET_DATE_FM_BTRV(OMDTE),'yyyymmdd') OMDTE ,'        ' NO_OF_FLOWS,SUM(OMNWR) OMNWR FROM OMPF 
INNER JOIN MAP_ACC ON LEG_ACC_NUM=TRIM(OMBRNM)||TRIM(OMDLP)||TRIM(OMDLR)
left join v5pf on v5brnm||v5dlp||trim(v5dlr) = map_acc.leg_acc_num
left JOIN R8PF ON TRIM(R8LNP)=TRIM(OMDLP)
WHERE (nvl(r8crl,'N')='Y' or (schm_code in ('NAF','NFD') and trim(v5brr) is null))
AND SCHM_TYPE='LAA'
AND ((OMMVT = 'P' and OMMVTS='R') OR (OMMVT = 'I' AND trim(OMMVTS) IS NULL))
AND CONV_TO_VALID_DATE(GET_DATE_FM_BTRV(OMDTE),'yyyymmdd') > TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY')
GROUP BY FIN_ACC_NUM,CONV_TO_VALID_DATE(GET_DATE_FM_BTRV(OMDTE),'yyyymmdd'),'        ';
CREATE INDEX OMPF_TEST_FIN_ACC_NUM ON OMPF_TEST(FIN_ACC_NUM);
CREATE INDEX OMPF_TEST_OMDTE ON OMPF_TEST(OMDTE);
CREATE INDEX OMPF_TEST_OMNWR ON OMPF_TEST(OMNWR);
DECLARE
   V_FIN_ACC_NUM VARCHAR2(13);
   CURSOR C1
   IS
   SELECT * FROM OMPF_TEST ORDER BY FIN_ACC_NUM,OMDTE;
   V_OMNWR NUMBER ;
   V_NO_FLOWS NUMBER := 0;
   V_OMDTE DATE; 
   START_FLG INT :=0;
BEGIN 
    FOR L_RECORD IN C1 LOOP
        IF(START_FLG = 0) THEN 
                   V_NO_FLOWS := 0;
                   V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
                   V_OMNWR := L_RECORD.OMNWR;
                   V_OMDTE := L_RECORD.OMDTE;
                   START_FLG := 1;
        END IF;
        IF (V_FIN_ACC_NUM = L_RECORD.FIN_ACC_NUM ) THEN
            IF (V_OMNWR = L_RECORD.OMNWR) THEN
                 V_NO_FLOWS := V_NO_FLOWS+1;
            ELSE 
            insert into OMPF_MAIN values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
               V_NO_FLOWS := 1;
               V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
               V_OMNWR := L_RECORD.OMNWR;
               V_OMDTE := L_RECORD.OMDTE;
            END IF;
         ELSE 
         insert into OMPF_MAIN values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
              V_NO_FLOWS := 1;
              V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
              V_OMNWR := L_RECORD.OMNWR;
              V_OMDTE := L_RECORD.OMDTE;
         END IF;     
    END LOOP;
    insert into OMPF_MAIN values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
    update OMPF_main set NO_OF_FLOWS='1' where NO_OF_FLOWS='0';
    COMMIT;
END; 
drop table ompf_eidem;
create table ompf_eidem as
select ombrnm,omdlp,omdlr,min(omdte) omdte,count(*) flows,omnwr from 
(select ombrnm,omdlp,omdlr,omdte,sum(omnwr) omnwr from ompf where omdte > get_param('EODCYYMMDD')  and omnwr <> 0 and ((ommvt ='P' and ommvts ='R') or (ommvt ='I' and trim(ommvts) is null) ) group by  ombrnm,omdlp,omdlr,omdte)
group by ombrnm,omdlp,omdlr,omnwr;
create index ompf_eidem_idx on ompf_eidem(ombrnm||omdlp||trim(omdlr));
drop table ompf_prdem;
create table ompf_prdem as
select * from ompf where omdte > get_param('EODCYYMMDD')  and omnwr <> 0 and ommvt ='P' and ommvts ='R';
create index ompf_prdem_idx on ompf_prdem(ombrnm||omdlp||trim(omdlr));
drop table ompf_indem; 
create table ompf_indem as 
select ombrnm,omdlp,omdlr ,min(omdte) omdte from ompf where omdte > get_param('EODCYYMMDD')  and ommvt ='I' and trim(ommvts) is null group by ombrnm,omdlp,omdlr;
create index ompf_indem_idx on ompf_indem(ombrnm||omdlp||trim(omdlr));
-----------------------------------------------
DROP TABLE OMPF_TEST1;
truncate table OMPF_MAIN1;
CREATE TABLE OMPF_TEST1 AS
SELECT FIN_ACC_NUM,CONV_TO_VALID_DATE(GET_DATE_FM_BTRV(OMDTE),'yyyymmdd') OMDTE ,'        ' NO_OF_FLOWS,OMNWR OMNWR FROM OMPF 
INNER JOIN MAP_ACC ON LEG_ACC_NUM=TRIM(OMBRNM)||TRIM(OMDLP)||TRIM(OMDLR)
left join v5pf on v5brnm||v5dlp||trim(v5dlr) = map_acc.leg_acc_num
left JOIN R8PF ON TRIM(R8LNP)=TRIM(OMDLP)
WHERE (nvl(trim(r8crl),'N')='N' and not(schm_code in ('NAF','NFD') and trim(v5brr) is null))
AND SCHM_TYPE='LAA'
AND ((OMMVT = 'P' and OMMVTS='R'))
AND CONV_TO_VALID_DATE(GET_DATE_FM_BTRV(OMDTE),'yyyymmdd') > TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY');
CREATE INDEX OMPF_TEST_FIN_ACC_NUM1 ON OMPF_TEST1(FIN_ACC_NUM);
CREATE INDEX OMPF_TEST_OMDTE1 ON OMPF_TEST1(OMDTE);
CREATE INDEX OMPF_TEST_OMNWR1 ON OMPF_TEST1(OMNWR);
DECLARE
   V_FIN_ACC_NUM VARCHAR2(13);
   CURSOR C1
   IS
   SELECT * FROM OMPF_TEST1 ORDER BY FIN_ACC_NUM,OMDTE;
   V_OMNWR NUMBER ;
   V_NO_FLOWS NUMBER := 0;
   V_OMDTE DATE; 
   START_FLG INT :=0;
BEGIN 
    FOR L_RECORD IN C1 LOOP
        IF(START_FLG = 0) THEN 
                   V_NO_FLOWS := 0;
                   V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
                   V_OMNWR := L_RECORD.OMNWR;
                   V_OMDTE := L_RECORD.OMDTE;
                   START_FLG := 1;
        END IF;
        IF (V_FIN_ACC_NUM = L_RECORD.FIN_ACC_NUM ) THEN
            IF (V_OMNWR = L_RECORD.OMNWR) THEN
                 V_NO_FLOWS := V_NO_FLOWS+1;
            ELSE 
            insert into OMPF_MAIN1 values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
               V_NO_FLOWS := 1;
               V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
               V_OMNWR := L_RECORD.OMNWR;
               V_OMDTE := L_RECORD.OMDTE;
            END IF;
         ELSE 
         insert into OMPF_MAIN1 values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
              V_NO_FLOWS := 1;
              V_FIN_ACC_NUM := L_RECORD.FIN_ACC_NUM ;
              V_OMNWR := L_RECORD.OMNWR;
              V_OMDTE := L_RECORD.OMDTE;
         END IF;     
    END LOOP;
    insert into OMPF_MAIN1 values(V_FIN_ACC_NUM,V_OMDTE,V_NO_FLOWS,V_OMNWR);
    update OMPF_main1 set NO_OF_FLOWS='1' where NO_OF_FLOWS='0';
    COMMIT;
END; 
------------------------------------ Capitalised Loan EIDEM schedule -------------------------------------------------
truncate table LRS_O_TABLE;
insert into LRS_O_TABLE
select 
--   Account_Number         CHAR(16) NULL,
    rpad(map_acc.fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('EIDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
    case 
     --   when omdte is not null then to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY')
        when omdte is not null then to_char(omdte,'DD-MM-YYYY')--changed on 27-02-2017
        else get_param('EOD_DATE')
    end,
--   Frequency_Type         CHAR(1) NULL,
      case when regexp_like(substr(IZRFRQ,1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(IZRFRQ,1,1),'[M-R]') then 'H'
         when regexp_like(substr(IZRFRQ,1,1),'[S-U]') then 'Q'
         when regexp_like(substr(IZRFRQ,1,1),'[V]') then 'M'
         when regexp_like(substr(IZRFRQ,1,1),'[W]') then 'W'
         when regexp_like(substr(IZRFRQ,1,1),'[Y]') then 'F'
         when regexp_like(substr(IZRFRQ,1,1),'[Z]') then 'D'
		 when regexp_like(substr(trim(v5ifq),1,1),'[A-L]') then 'Y' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[M-R]') then 'H' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[S-U]') then 'Q' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[V]') then 'M'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[W]') then 'W'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[Y]') then 'F'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[Z]') then 'D'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
    else 'M' end,
--   Freq_Week_Num_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Week_Day_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Start_DD_for_Principal     CHAR(2) NULL,
    rpad(case when trim(IZRFRQ) is not null then to_char(substr(trim(IZRFRQ),2,2)) 
    when TRIM(v5ifq) is not null then to_char(substr(trim(v5ifq),2,2))   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	when omdte is not null then  substr(to_char(OMDTE,'DD-MM-YYYY'),1,2) ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	else '31' end,2,' '),
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
     --lpad(nvl(flows,1),3,' '),
     lpad(nvl(NO_OF_FLOWS,1),3,' '),---changed on 27-02-2017
--   Installment_Amount         CHAR(17) NULL,
    case 
        when  omnwr is not null then  lpad(to_char(to_number(omnwr)/POWER(10,C8CED)),17,' ')
        else lpad('0.01',17,' ')
    end,
--   Installment_Percentage     CHAR(8) NULL,
    lpad(' ',8,' '),
--   Number_of_Demands_Raised     CHAR(3) NULL,
    case 
        when  omnwr is not null then  lpad(' ',3,' ')
        else lpad('1',3,' ')
    end,
--   Next_Installment_Date     CHAR(10) NULL,
    lpad(' ',10,' '),        
--   Next_Int_Installment_Date     CHAR(10) NULL,
    rpad(' ',10,' '),
--   Frequency_Type_for_Interest     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_Number_for_Int CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_day_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Start_DD_for_Int     CHAR(2) NULL,
    rpad(' ',2,' '),
--   Freq_Months_for_Int     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Int     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Holiday_Status_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Installment_Indicator     CHAR(1) NULL
    rpad(' ',1,' ')
from map_acc
inner join c8pf on c8ccy = currency
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=leg_acc_num
--inner join obpf on obdlp=v5dlp -----changed on 03-10-2016 because obpf -obcrcl has null value.
left join r8pf on r8lnp=trim(v5dlp)
--left join (select ombrnm,omdlp,omdlr,min(omdte) omdte,count(*) flows,omnwr from 
--(select ombrnm,omdlp,omdlr,omdte,sum(omnwr) omnwr from ompf where omdte > get_param('EODCYYMMDD')  and omnwr <> 0 and ((ommvt ='P' and ommvts ='R') or (ommvt ='I' and ommvts is null) ) group by  ombrnm,omdlp,omdlr,omdte)
--group by ombrnm,omdlp,omdlr,omnwr) 
--left join ompf_eidem on leg_acc_num=ombrnm||omdlp||trim(omdlr)
left join ompf_main on ompf_main.fin_acc_num=map_acc.fin_acc_num --changed on 27-02-2017
left join (select a.* from izpf a inner join (select izbrnm,izdlp,izdlr,max(izdtes) izdtes from izpf group by izbrnm,izdlp,izdlr)b on  a.izbrnm= b.izbrnm  and a.izdlp=b.izdlp and a.izdlr = b.izdlr and a.izdtes=b.izdtes)izpf on leg_acc_num=izbrnm||izdlp||trim(izdlr)
where map_acc.schm_type='LAA'  
and (nvl(r8crl,'N')='Y' or (schm_code in ('NAF','NFD') and trim(v5brr) is null))
--and nvl(obcrcl,'N')='Y' --changed on 03-10-2016 because obpf -obcrcl has null value.
order by map_acc.fin_acc_num;
commit;
------------------------------------ Non Capitalised Loan PRDEM schedule -------------------------------------------------
insert into LRS_O_TABLE
select 
--   Account_Number         CHAR(16) NULL,
    rpad(map_acc.fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('PRDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
    case 
        when omdte is not null then to_char(OMDTE,'DD-MM-YYYY')
        else get_param('EOD_DATE')
    end,
--   Frequency_Type         CHAR(1) NULL,
      case when map_acc.schm_code in ('BTP','FMP','FMX') then 'B'
	     when regexp_like(substr(trim(IZRFRQ),1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(trim(IZRFRQ),1,1),'[M-R]') then 'H'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[S-U]') then 'Q'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[V]') then 'M'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[W]') then 'W'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Y]') then 'F'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Z]') then 'D'
         when regexp_like(substr(trim(v5ifq),1,1),'[A-L]') then 'Y' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[M-R]') then 'H' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[S-U]') then 'Q' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[V]') then 'M'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[W]') then 'W'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[Y]') then 'F'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(v5ifq),1,1),'[Z]') then 'D'   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	else 'M' end,
--   Freq_Week_Num_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Week_Day_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Start_DD_for_Principal     CHAR(2) NULL,
    --rpad(case when IZRFRQ is not null then to_char(substr(IZRFRQ,2,2)) else '31' end,2,' '),
    rpad(case when 	map_acc.schm_code in ('BTP','FMP','FMX') then ' '
	when trim(IZRFRQ) is not null then to_char(substr(trim(IZRFRQ),2,2))  
    when TRIM(v5ifq) is not null then to_char(substr(trim(v5ifq),2,2))   ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	when omdte is not null then  substr(to_char(OMDTE,'DD-MM-YYYY'),1,2) 
    else substr(get_param('EOD_DATE'),1,2) end,2,' '),
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '), 
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
     lpad(nvl(NO_OF_FLOWS,1),3,' '),
--   Installment_Amount         CHAR(17) NULL,
    case 
        when  omnwr is not null then  lpad(to_char(to_number(omnwr)/POWER(10,C8CED)),17,' ')
        else lpad('0.01',17,' ')
    end,
--   Installment_Percentage     CHAR(8) NULL,
    lpad(' ',8,' '),
--   Number_of_Demands_Raised     CHAR(3) NULL,
    case 
        when  omnwr is not null then  lpad(' ',3,' ')
        else lpad('1',3,' ')
    end,
--   Next_Installment_Date     CHAR(10) NULL,
    lpad(' ',10,' '),        
--   Next_Int_Installment_Date     CHAR(10) NULL,
    rpad(' ',10,' '),
--   Frequency_Type_for_Interest     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_Number_for_Int CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_day_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Start_DD_for_Int     CHAR(2) NULL,
    rpad(' ',2,' '),
--   Freq_Months_for_Int     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Int     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Holiday_Status_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Installment_Indicator     CHAR(1) NULL
    rpad(' ',1,' ')
from map_acc
inner join c8pf on c8ccy = currency
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=leg_acc_num
left join r8pf on r8lnp=trim(v5dlp)
left join OMPF_MAIN1  a on map_acc.fin_acc_num=a.FIN_ACC_NUM and OMNWR <> 0
left join (select a.* from izpf a inner join (select izbrnm,izdlp,izdlr,max(izdtes) izdtes from izpf group by izbrnm,izdlp,izdlr)b on  a.izbrnm= b.izbrnm  and a.izdlp=b.izdlp and a.izdlr = b.izdlr and a.izdtes=b.izdtes)izpf on leg_acc_num=izbrnm||izdlp||trim(izdlr)
where map_acc.schm_type='LAA'  
and (nvl(trim(r8crl),'N')='N' and not(schm_code in ('NAF','NFD') and trim(v5brr) is null)) 
order by map_acc.fin_acc_num;
commit; 
/*insert into LRS_O_TABLE
select 
--   Account_Number         CHAR(16) NULL,
    rpad(fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('PRDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
    case 
        when omdte is not null then to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY')
        else get_param('EOD_DATE')
    end,
--   Frequency_Type         CHAR(1) NULL,
      case when regexp_like(substr(trim(IZRFRQ),1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(trim(IZRFRQ),1,1),'[M-R]') then 'H'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[S-U]') then 'Q'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[V]') then 'M'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[W]') then 'W'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Y]') then 'F'
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Z]') then 'D'
    else 'M' end,
--   Freq_Week_Num_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Week_Day_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Start_DD_for_Principal     CHAR(2) NULL,
    --rpad(case when IZRFRQ is not null then to_char(substr(IZRFRQ,2,2)) else '31' end,2,' '),
    rpad(case when trim(IZRFRQ) is not null then to_char(substr(trim(IZRFRQ),2,2))  
    when omdte is not null then  substr(to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY'),1,2) 
    else substr(get_param('EOD_DATE'),1,2) end,2,' '),
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
     lpad('1',3,' '),
--   Installment_Amount         CHAR(17) NULL,
    case 
        when  omnwr is not null then  lpad(to_char(to_number(omnwr)/POWER(10,C8CED)),17,' ')
        else lpad('0.01',17,' ')
    end,
--   Installment_Percentage     CHAR(8) NULL,
    lpad(' ',8,' '),
--   Number_of_Demands_Raised     CHAR(3) NULL,
    case 
        when  omnwr is not null then  lpad(' ',3,' ')
        else lpad('1',3,' ')
    end,
--   Next_Installment_Date     CHAR(10) NULL,
    lpad(' ',10,' '),        
--   Next_Int_Installment_Date     CHAR(10) NULL,
    rpad(' ',10,' '),
--   Frequency_Type_for_Interest     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_Number_for_Int CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_day_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Start_DD_for_Int     CHAR(2) NULL,
    rpad(' ',2,' '),
--   Freq_Months_for_Int     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Int     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Holiday_Status_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Installment_Indicator     CHAR(1) NULL
    rpad(' ',1,' ')
from map_acc
inner join c8pf on c8ccy = currency
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=leg_acc_num
--inner join obpf on obdlp=v5dlp --changed on 03-10-2016 because obpf -obcrcl has null value.
left join r8pf on r8lnp=trim(v5dlp)
left join ompf_prdem  on leg_acc_num=ombrnm||omdlp||trim(omdlr)
left join (select a.* from izpf a inner join (select izbrnm,izdlp,izdlr,max(izdtes) izdtes from izpf group by izbrnm,izdlp,izdlr)b on  a.izbrnm= b.izbrnm  and a.izdlp=b.izdlp and a.izdlr = b.izdlr and a.izdtes=b.izdtes)izpf on leg_acc_num=izbrnm||izdlp||trim(izdlr)
where map_acc.schm_type='LAA'  
--and nvl(obcrcl,'N')='N' --changed on 03-10-2016 because obpf -obcrcl has null value.
and (nvl(trim(r8crl),'N')='N' and not(schm_code in ('NAF','NFD') and trim(v5brr) is null))
order by map_acc.fin_acc_num;
commit; */
------------------------------------ Non Capitalised Loan INDEM schedule -------------------------------------------------
insert into LRS_O_TABLE
select 
--   Account_Number         CHAR(16) NULL,
    rpad(fin_acc_num,16,' '),
--   Flow_ID             CHAR(5) NULL,
    rpad('INDEM',5,' '),
--   Flow_Start_Date         CHAR(10) NULL,
    case 
        when omdte is not null then to_char(to_date(get_date_fm_btrv(omdte),'YYYYMMDD'),'DD-MM-YYYY')
        else get_param('EOD_DATE')
    end,
--   Frequency_Type         CHAR(1) NULL,
    case when regexp_like(substr(trim(IZRFRQ),1,1),'[A-L]') then 'Y' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[M-R]') then 'H' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[S-U]') then 'Q' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[V]') then 'M' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[W]') then 'W' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Y]') then 'F' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
         when regexp_like(substr(trim(IZRFRQ),1,1),'[Z]') then 'D' ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	     when regexp_like(substr(trim(v5ifq),1,1),'[A-L]') then 'Y' 
         when regexp_like(substr(trim(v5ifq),1,1),'[M-R]') then 'H'
         when regexp_like(substr(trim(v5ifq),1,1),'[S-U]') then 'Q'
         when regexp_like(substr(trim(v5ifq),1,1),'[V]') then 'M'
         when regexp_like(substr(trim(v5ifq),1,1),'[W]') then 'W'
         when regexp_like(substr(trim(v5ifq),1,1),'[Y]') then 'F'
         when regexp_like(substr(trim(v5ifq),1,1),'[Z]') then 'D'
    else 'M' end,
--   Freq_Week_Num_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Week_Day_for_Principal     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Freq_Start_DD_for_Principal     CHAR(2) NULL,
    rpad(case when trim(IZRFRQ) is not null then to_char(substr(trim(IZRFRQ),2,2))  ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	     when TRIM(v5ifq) is not null then to_char(substr(trim(v5ifq),2,2))   
      	 when omdte is not null then  substr(OMDTE,6,2) ------------ script changed 18-07-2017 based on Edwin mail and vijay confirmation
	    else '31' end,2,' '),
--   Freq_Months_for_Principal     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Principal     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Hldy_Status_Principal     CHAR(1) NULL,
    rpad('N',1,' '),
--   Number_of_Flows         CHAR(3) NULL,
    lpad(' ',3,' '),
--   Installment_Amount         CHAR(17) NULL,
    lpad(' ',17,' '),
--   Installment_Percentage     CHAR(8) NULL,
    lpad(' ',8,' '),
--   Number_of_Demands_Raised     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Next_Installment_Date     CHAR(10) NULL,
    lpad(' ',10,' '),        
--   Next_Int_Installment_Date     CHAR(10) NULL,
    rpad(' ',10,' '),
--   Frequency_Type_for_Interest     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_Number_for_Int CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Week_day_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Frequency_Start_DD_for_Int     CHAR(2) NULL,
    rpad(' ',2,' '),
--   Freq_Months_for_Int     CHAR(4) NULL,
    lpad(' ',4,' '),
--   Freq_Days_for_Int     CHAR(3) NULL,
    lpad(' ',3,' '),
--   Freq_Holiday_Status_for_Int     CHAR(1) NULL,
    rpad(' ',1,' '),
--   Installment_Indicator     CHAR(1) NULL
    rpad(' ',1,' ')
from map_acc
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr) = map_acc.leg_acc_num
inner join c8pf on c8ccy = currency
--inner join obpf on obdlp=v5dlp ----changed on 03-10-2016 because obpf -obcrcl has null value.
left join r8pf on r8lnp=trim(v5dlp)
left join ompf_indem on leg_acc_num=ombrnm||omdlp||trim(omdlr)
left join (select a.* from izpf a inner join (select izbrnm,izdlp,izdlr,max(izdtes) izdtes from izpf group by izbrnm,izdlp,izdlr)b on  a.izbrnm= b.izbrnm  and a.izdlp=b.izdlp and a.izdlr = b.izdlr and a.izdtes=b.izdtes)izpf on leg_acc_num=izbrnm||izdlp||trim(izdlr)
where map_acc.schm_type='LAA' 
--and nvl(obcrcl,'N')='N' --changed on 03-10-2016 because obpf -obcrcl has null value.
and (nvl(trim(r8crl),'N')='N' and not(schm_code in ('NAF','NFD') and trim(v5brr) is null))
order by map_acc.fin_acc_num;
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
RL004_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
RL004_upload.sql 
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
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
RL005_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
RL005_upload.sql 
-- File Name           : LAT1_upload.sql
-- File Created for    : Upload file for Loan Interest
-- Created By          : Alavudeen Ali Badusha.R
-- Client              : ABK
-- Created On          : 20-06-2016 
-------------------------------------------------------------------
-------INTEREST OVERDUE TRANSACTION PASSED IN BELOW ------------------------------------------------
truncate table LAT1_O_TABLE;
insert into LAT1_O_TABLE
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
lpad(abs(to_number((lsamtd - lsamtp))/POWER(10,c8pf.C8CED)),17,' '),
--   Part_tran_type         CHAR(1) NULL,
rpad('D',1,' '),
--   Type_of_demands         CHAR(1) NULL,
rpad(' ',1,' '),
--   Value_Date             CHAR(10) NULL,
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--   Flow_Id             CHAR(5) NULL,
rpad('INDEM',5,' '),
--   Demand_Date             CHAR(10) NULL,
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--   Last_part_transaction_flag     CHAR(1) NULL,
rpad('N',1,' '),
--   Tran_end_ind             CHAR(1) NULL,
rpad('N',1,' '),
--   Advance_Payment_Flag         CHAR(1) NULL,
rpad(' ',1,' '),
--   Prepayment_Type         CHAR(1) NULL,
rpad(' ',1,' '),
--   int_coll_on_prepayment_flg     CHAR(1) NULL,
rpad(' ',1,' '),
--   Transaction_Remarks         CHAR(30) NULL,
rpad(' ',30,' '),
--   Transaction_Particulars     CHAR(50) NULL
rpad(fin_acc_num,50,' ')   
FROM map_acc
inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =leg_acc_num 
inner join c8pf on c8ccy = map_acc.currency
where map_acc.schm_type='LAA'
and lsmvt = 'I' and lsamtd <> 0 and (lsamtd -lsamtp) < 0 and lsdte <= get_param('EODCYYMMDD');
commit;
-------PRINCIPAL PENAL INTEREST OVERDUE TRANSACTION PASSED IN BELOW ------------------------------------------------
--insert into LAT1_O_TABLE
--select 
----   Transaction_Type         CHAR(1) NULL,
--rpad('T',1,' '),
----   Transaction_sub_Type         CHAR(2) NULL,
--rpad('BI',2,' '),
----   Account_Number         CHAR(16) NULL,
--rpad(fin_acc_num,16,' '),
----   Currency             CHAR(3) NULL,
--rpad(currency,3,' '),
----   Service_Outlet         CHAR(8) NULL,
--rpad(fin_sol_id,8,' '),
----   Amount             CHAR(17) NULL,
--lpad(abs(to_number(lsup))/POWER(10,c8pf.C8CED),17,' '),
----   Part_tran_type         CHAR(1) NULL,
--rpad('D',1,' '),
----   Type_of_demands         CHAR(1) NULL,
--rpad(' ',1,' '),
----   Value_Date             CHAR(10) NULL,
--rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----   Flow_Id             CHAR(5) NULL,
--rpad('PIDEM',5,' '),
----   Demand_Date             CHAR(10) NULL,
--rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----   Last_part_transaction_flag     CHAR(1) NULL,
--rpad('N',1,' '),
----   Tran_end_ind             CHAR(1) NULL,
--rpad('N',1,' '),
----   Advance_Payment_Flag         CHAR(1) NULL,
--rpad(' ',1,' '),
----   Prepayment_Type         CHAR(1) NULL,
--rpad(' ',1,' '),
----   int_coll_on_prepayment_flg     CHAR(1) NULL,
--rpad(' ',1,' '),
----   Transaction_Remarks         CHAR(30) NULL,
--rpad(' ',30,' '),
----   Transaction_Particulars     CHAR(50) NULL
--rpad(fin_acc_num,50,' ')   
--FROM map_acc
--inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =leg_acc_num 
--inner join c8pf on c8ccy = map_acc.currency
--where map_acc.schm_type='LAA'
--and lsmvt = 'P' and lsmvts ='R' and lsup <> 0 and lsdte <= get_param('EODCYYMMDD');
--commit;
-------CONTRA TRANSACTION FOR PRINCIPAL PENAL INTEREST AND INTEREST OVERDUE TRANSACTION IS PASSED IN BELOW ------------------------------------------------
insert into LAT1_O_TABLE
select 'T','BI',rpad((trim(Service_Outlet)||crncy_alias_num||'52000LAA'),16,' '), currency,rpad(Service_Outlet,8,' '),lpad(calc_bal,17,' '),'C',' ',get_param('EOD_DATE'),rpad(' ',5,' '),rpad(' ',10,' '),'Y','N','N',' ',' ',rpad(' ',30,' '),rpad(account_number,50,' ')
from
--(select Service_Outlet,currency,sum(Amount) calc_bal from LAT1_O_TABLE ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
(select account_number,Service_Outlet,currency,sum(Amount) calc_bal from LAT1_O_TABLE
group by account_number,currency,Service_Outlet ---in mock3b observation commented on 12-04-2017 as per Sandeep requirement 
order by currency,Service_Outlet
)
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on crncy_code=currency; 
commit;
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
RL006_upload.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
RL006_upload.sql 
-- File Name           : LDT_upload.sql
-- File Created for    : Upload file for Loan Demand
-- Created By          : Alavudeen Ali Badusha.R
-- Client              : ENBD
-- Created On          : 08-07-2014 
-------------------------------------------------------------------
----------------PRINCIPAL AND INTEREST OVERDUE OUTSTANDING INFORMATION PASSED IN BELOW  ------------------------------------------------
truncate table LDT_O_TABLE;
insert into LDT_O_TABLE
select 
--   Account_ID             CHAR(16) NULL,
rpad(Fin_acc_num,16,' '),
--   Demand_Date             CHAR(10) NULL,
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--   Demand_Effective_Date     CHAR(10) NULL,
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--   Principal_Demand_ID         CHAR(5) NULL,
rpad(case when lsmvt='P' then 'PRDEM' when lsmvt='I' then 'INDEM' else ' ' end,5,' '),
--   Demand_Amount         CHAR(17) NULL,
lpad(abs(to_number(lsamtd - lsamtp))/POWER(10,c8pf.C8CED),17,' '),
--   Late_Fee_Applied         CHAR(1) NULL,
rpad(case when lsup <> 0 then 'B' else 'N' end,1,' '),
--   Late_Fee_Amount         CHAR(17) NULL,
lpad(case when lsup <> 0 then to_char(abs(to_number(lsup))/POWER(10,c8pf.C8CED)) else ' ' end,17,' '),
--   Late_Fee_Date         CHAR(10) NULL,
rpad(case when lsup <> 0 then to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY') else ' ' end,10,' '),
--   Status_Of_Late_Fee         CHAR(1) NULL,
rpad(case when lsup <> 0 then 'A' else ' ' end,1,' '),
--   Late_Fee_Currency_Code     CHAR(3) NULL,
rpad(case when lsup <> 0 then currency else ' ' end,3,' '),
--   Demand_Overdue_Date         CHAR(10) NULL,
rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
--   Accrued_Penal_Interest_Amount CHAR(17) NULL,
lpad(' ',17,' '),
--   IBAN_Number             CHAR(34) NULL
rpad(' ',34,' ')
FROM map_acc
inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =leg_acc_num 
inner join c8pf on c8ccy = map_acc.currency
where map_acc.schm_type='LAA' and lsamtd <> 0 and (lsamtd -lsamtp) < 0 and lsdte <= get_param('EODCYYMMDD');
commit;
----------------PRINCIPAL PENAL INTEREST OUTSTANDING INFORMATION PASSED IN BELOW  ------------------------------------------------
--insert into LDT_O_TABLE
--select 
----   Account_ID             CHAR(16) NULL,
--rpad(Fin_acc_num,16,' '),
----   Demand_Date             CHAR(10) NULL,
--rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----   Demand_Effective_Date     CHAR(10) NULL,
--rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----   Principal_Demand_ID         CHAR(5) NULL,
--rpad('PIDEM',5,' '),
----   Demand_Amount         CHAR(17) NULL,
--lpad(abs(to_number(lsup))/POWER(10,c8pf.C8CED),17,' '),
----   Late_Fee_Applied         CHAR(1) NULL,
--rpad('N',1,' '),
----   Late_Fee_Amount         CHAR(17) NULL,
--lpad(' ',17,' '),
----   Late_Fee_Date         CHAR(10) NULL,
--rpad(' ',10,' '),
----   Status_Of_Late_Fee         CHAR(1) NULL,
--rpad(' ',1,' '),
----   Late_Fee_Currency_Code     CHAR(3) NULL,
--rpad(' ',3,' '),
----   Demand_Overdue_Date         CHAR(10) NULL,
--rpad(to_char(to_date(get_date_fm_btrv(lsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
----   Accrued_Penal_Interest_Amount CHAR(17) NULL,
--lpad(' ',17,' '),
----   IBAN_Number             CHAR(34) NULL
--rpad(' ',34,' ')
--FROM map_acc
--inner join lspf on  lsbrnm||trim(lsdlp)||trim(lsdlr) =leg_acc_num 
--inner join c8pf on c8ccy = map_acc.currency
--where map_acc.schm_type='LAA'
--and lsmvt = 'P' and lsmvts ='R' and lsup <> 0 and lsdte <= get_param('EODCYYMMDD');
--commit;
exit;
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
sol_recon.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
sol_recon.sql 
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
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TDA02_upload_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TDA02_upload_kw.sql 
-- File Name        : TDA02_upload.sql
-- File Created for    : Upload file for TD Master
-- Created By        : Jagadeesh.M
-- Client            : ENBD
-- Created On        : 24-06-2015
-------------------------------------------------------------------
drop table ompf_pm;
create table ompf_pm as
select * from ompf where ommvt='P' and OMMVTS='M';
create index ompf_pm_idx on ompf_pm(ombrnm,omdlp,omdlr);
drop table owpf_note_tda;
create table owpf_note_tda as
select trim(owbrnm)||trim(owdlp)||trim(owdlr) leg_acc,OWSD1,OWSD2,OWSD3,OWSD4 from owpf 
where owmvt = 'P' and owmvts = 'C';
create index owpf_idx on owpf_note_tda(leg_acc);
drop table future_interest;
create table future_interest as 
select leg_acc_num,sum((omnwp +omnwr)/power(10,c8ced))interest_to_be_paid_in_future from map_acc
inner join (select * from ompf where to_number(omdte) > to_number(get_param('EODCYYMMDD')) and ommvt = 'I' and trim(ommvts) is null)ompf on ombrnm||omdlp||omdlr = leg_acc_num
inner join v5pf on v5brnm||trim(v5dlp)||trim(v5dlr) = leg_acc_num
inner join c8pf on c8ccy =currency
where schm_type= 'TDA'
group by leg_acc_num;
truncate table TDA_O_TABLE;
insert into TDA_O_TABLE 
select distinct/*+use_hash(scab,scan,scas,scccy,ombrnm,omdlp,omdlr) */
--   v_Employee_Id                  CHAR(9)
            lpad(' ',9,' '),
-- v_Customer_Credit_Pref_Percent   CHAR(10)
            lpad(' ',10,' '),
-- v_Customer_Debit_Pref_Percent    CHAR(10)
            lpad(' ',10,' '),
-- v_Account_Credit_Pref_Percent    CHAR(10)
            lpad(' ',10,' '),
-- v_Account_Debit_Pref_Percent     CHAR(10)
            lpad(' ',10,' '),
-- v_Channel_Credit_Pref_Percent    CHAR(10)
            lpad(' ',10,' '),
-- v_Channel_Debit_Pref_Percent     CHAR(10)
            lpad(' ',10,' '),
--   v_Pegged_Flag                  CHAR(1)
            rpad(case when v5pf_acc_num is not null then 'N' when trim(v5prc) is not null then 'Y' else 'N' end,1,' '),
--   v_Peg_Frequency_in_Months      CHAR(4)
            lpad(case when v5pf_acc_num is not null then ' ' when v5prc like '%M%' then to_Char(replace(v5prc,'M',''))
            when v5prc like '%Y%' then to_Char(replace(v5prc,'Y','')*12)
            else ' ' end,4,' '),
--   v_Peg_Frequency_in_Days        CHAR(3)
            lpad(case when v5pf_acc_num is not null then ' ' when v5prc like '%D%' then to_char(replace(v5prc,'D',''))
            else ' ' end,3,' '),
-- v_sulabh_flg                     CHAR(1)
            rpad(' ',1,' '),
--   v_interest_accrual_flag        CHAR(1)
            rpad('Y',1,' '),                                   -- Need confirmation from Business
-- v_Passbook_Sheet_Receipt_Ind     CHAR(1)
            rpad('N',1,' '),
-- v_With_holdng_tax_amt_scope_flg  CHAR(1)
            lpad(' ',1,' '),
--   v_With_holding_tax_flag        CHAR(1)
            lpad('N',1,' '),
-- v_safe_custody_flag              CHAR(1)
            rpad('N',1,' '),
--   v_cash_excp_amount_limit       CHAR(17)
            lpad(' ',17,' '),
-- v_clearing_excp_amount_limit     CHAR(17)
            lpad(' ',17,' '),
-- v_Transfer_excp_amount_limit     CHAR(17)
            lpad(' ',17,' '),
--   v_cash_cr_excp_amt_lim         CHAR(17)
            lpad(' ',17,' '),
--   v_Clearing_cr_excp_amt_lim     CHAR(17)
            lpad(' ',17,' '),
--   v_Transfer_cr_excp_amt_lim     CHAR(17)
            lpad(' ',17,' '),
--   v_Deposit_Account_Number       CHAR(16)
            lpad(map_acc.fin_acc_num,16,' '),        -- Need to write the a/c number generation for TD
--   v_Currency_Code                CHAR(3)
            lpad(map_acc.currency,3,' '),
--   v_SOL_ID                       CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_GL_Sub_head_code             CHAR(5)
            rpad(nvl(map_acc.GL_SUB_HEADCODE,' '),5,' '),
--   v_Scheme_Code                  CHAR(5)
            rpad(map_acc.schm_code,5,' '),                    -- Defaulted as no BPD values
--   v_CIF_ID                       CHAR(32)
            lpad(map_acc.fin_cif_id,32,' '),
--   v_Deposit_amount               CHAR(17)
            --lpad(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi or trim(v5ifq) is null)  and nvl(clmamount,0)  <> 0 
			lpad(case when map_acc.schm_code='TDATD' then nvl(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),0)-nvl(to_number(atd_clmamount)/POWER(10,C8CED),0) -- nvl(to_number(atd_clmamount)/POWER(10,C8CED),0)- subtracted on 25-09-2017 as per vijay,ravi and sandeep discusion. Only deposit amount need to provided
			when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi)  and nvl(clmamount,0)  <> 0 then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end,17,' '),
--   v_Deposit_period_months        CHAR(3)
            lpad(' ',3,' '),                                -- Maturity date value is given in TD002-065 filed so this is not required.
--   v_Deposit_period_days          CHAR(3)
            lpad(' ',3,' '),                                -- Maturity date value is given in TD002-065 filed so this is not required.
--   v_Interest_table_code          CHAR(5)
            rpad(case when v5pf_acc_num is not null then to_char(dep_rate.tbl_code) else to_char(csp.INT_TBL_CODE) end,5,' '),                        
--  v_Mode_of_operation             CHAR(5)
            rpad('012',5,' '),                                    -- Defaulted as no BPD values
--   v_Account_location_code        CHAR(5)
            lpad(' ',5,' '),
--  v_Auto_Renewal_Flag             CHAR(1)
           rpad(case when v5pf.v5arc in ('A','P') then 'N'
                --when HYDBNM||HYDLP||HYDLR is not null then 'U'  --commented as per spira 7096 and vijay confirmation on 06-07-2017. auto renewal no need for collateral account
                when v5pf.v5mdt=9999999 then 'U'
                else 'N' end,1,' '),    
-- v_Prd_in_mnths_for_auto_renewal  CHAR(3)
            lpad(case when v5pf.v5mdt=9999999 then case when jrpf.jrddy like 'M'  then 
                        to_char(jrpf.jrnum)
                    when jrpf.jrddy like 'Y'  then 
                              to_char(jrpf.jrnum*12)
                    when jrpf.jrddy like 'D'  and jrpf.jrnum > 360 then 
                          to_char(floor(jrpf.jrnum/30))
                          else '0'
               end else '0' end,3,' '),                            
-- v_Prd_in_days_for_auto_renewal   CHAR(3)
            lpad( case when v5pf.v5mdt=9999999 then case when jrpf.jrddy = 'D' and jrpf.jrnum > 360  then 
                    to_char(mod(jrpf.jrnum,30)) 
                when jrpf.jrddy = 'D' and jrpf.jrnum <= 360  then 
                     to_char(jrpf.jrnum)
                when jrpf.jrddy = 'W'  then to_char(JRNUM*7)     
                else '0' end
				else '0' end
             ,3,' '),                            
--  v_Account_Open_Date             CHAR(10)
            case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else rpad(' ',10,' ') end,
--   v_Open_Effective_Date          CHAR(10)
            case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else  rpad(' ',10,' ')
            end,
-- v_Nominee_Print_Flag             CHAR(1)
            rpad('N',1,' '),
--   v_Printing_Flag                CHAR(1)
            case when SCAID3='Y' then rpad('Y',1,' ')
            else rpad('N',1,' ') end,
--   v_Ledger_Number                CHAR(3)
            lpad(' ',3,' '),
-- v_Last_Credit_Int_Posted_Date    CHAR(10)
            case --when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')---- commented on 09-09-2017 based on sandeep requirement and finding from day 1 recon
                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
                 when v5lcd<>0 and v5lre=0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')------Added on 09-09-2017 based on sandeep requirement and day1 recon
			else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end,
--   v_Last_Credit_Int_Run_Date     CHAR(10)
            case --when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')---commented on 09-09-2017 based on sandeep requirement and day1 recon
                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
                 when v5lcd<>0 and v5lre=0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')------Added on 09-09-2017 based on sandeep requirement and day1 recon
			else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end ,
-- v_Last_Interest_Provision_Date   CHAR(10)            
             case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
             rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
             when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
             rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
             else  rpad(' ',10,' ')
             end,
--   v_Printed_date                 CHAR(10)
            --lpad(' ',10,' '),
            case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else  rpad(' ',10,' ')
            end,
--   v_Cumulative_Interest_Paid     CHAR(17)
            --lpad(case when (v5abd||v5and||v5asd<>v5abi||v5ani||v5asi and trim(v5ifq) is not null)  then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0') --commented on 06-07-2017 based on RTD0600000027699 deal issue
			lpad(case 
			--when trim(v5pf.v5dlp)='ATD' then nvl(to_char(to_number((atd_clmamount)/POWER(10,C8CED))),'0') ---commented changed on 29-09-2017 based on drill 1 observation and sandeep requirement
			when (v5abd||v5and||v5asd<>v5abi||v5ani||v5asi)  then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0') 
			else ' ' end,17,' '),
-- v_Cumulative_interest_credited   CHAR(17)
            --lpad(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi  or trim(v5ifq) is null)  then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0')
			lpad(case 
			when trim(v5pf.v5dlp)='ATD' then nvl(to_char(to_number((atd_clmamount)/POWER(10,C8CED))),'0') ---added changed on 29-09-2017 based on drill 1 observation and sandeep requirement
			when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi )  then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0')--commented on 06-07-2017 based on RTD0600000027699 deal issue
            else ' ' end,17,' '),       
-- v_Cumulative_installments_paid   CHAR(17)            
            --lpad(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),17,' '),
            --lpad(nvl(to_char(case when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi  or trim(v5ifq) is null) and nvl(clmamount,0)  <> 0   --commented on 06-07-2017 based on RTD0600000027699 deal issue
			lpad(nvl(to_char(case 
			when map_acc.schm_code='TDATD' then nvl(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),0)-nvl(to_number(atd_clmamount)/POWER(10,C8CED),0) ---added changed on 29-09-2017 based on drill 1 observation and sandeep requirement
			when (v5abd||v5and||v5asd=v5abi||v5ani||v5asi ) and nvl(clmamount,0)  <> 0 
                then to_number(v5pf.v5bal)/power(10,c8pf.c8ced) - to_number((clmamount)/POWER(10,C8CED))
            else to_number(v5pf.v5bal)/power(10,c8pf.c8ced) end),' '),17,' '),
--   v_Maturity_amount              CHAR(17)           
            --case when (v5abd||v5and||v5asd<>v5abi||v5ani||v5asi and trim(v5ifq) is not null) then lpad(nvl(to_char(to_number(v5pf.v5bal)/power(10,c8pf.c8ced)),' '),17,' ')--commented on 06-07-2017 based on RTD0600000027699 deal issue
			case when map_acc.schm_code='TDATD' then lpad(to_char(nvl(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),0)),17,' ') -- nvl(to_number(atd_clmamount)/POWER(10,C8CED),0)+ removed on 25-09-2017 as per vijay,ravi and sandeep discusion. Only deposit amount need to provided
			when tsd.FLOW_CODE ='IO' then lpad(nvl(to_char(to_number(v5pf.v5bal)/power(10,c8pf.c8ced)),' '),17,' ') --added on 01-08-2017 as per dicussion with vijay and sandeep due to maturity amount issue for II account
			--when (v5abd||v5and||v5asd<>v5abi||v5ani||v5asi) then lpad(nvl(to_char(to_number(v5pf.v5bal)/power(10,c8pf.c8ced)),' '),17,' ')--commented on 01-08-2017 as per dicussion with vijay and sandeep due to maturity amount issue for II account
			--else lpad(nvl(to_char(to_number(v5pf.v5bal+nvl(interest_to_be_paid_in_future,0))/power(10,c8pf.c8ced)),' '),17,' ') end, -- commented as interest_to_be_paid_in_future was divided twice, changed on 18-4-2017 based on issues from Users
            else lpad(nvl(to_char(to_number(v5pf.v5bal)/power(10,c8pf.c8ced)+nvl(interest_to_be_paid_in_future,0)),' '),17,' ') end,
--   v_Operative_Account_Number     CHAR(16)
           case          
           when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null            
           then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')                     
           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
           then rpad(get_oper_acct(iv.omabf||iv.omanf||iv.omasf),16,' ') 
           else rpad(' ',16,' ') end,
           --case
           --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null 
           --then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')           
           --else rpad(' ',16,' ') end,
-- v_Operative_Account_Crncy_Code   CHAR(3)           
           case           
           when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
           then rpad(get_oper_ccy(v5abi||v5ani||v5asi),3,' ')           
           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
           then rpad(trim(get_oper_ccy(iv.omabf||iv.omanf||iv.omasf)),3,' ') 
           else rpad(' ',3,' ')end,
           --case
           --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
           --then rpad(get_oper_ccy(v5abi||v5ani||v5asi),3,' ')             
           --else rpad(' ',3,' ')end,
--   v_Operative_Account_SOL        CHAR(8)          
          case          
          when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
          then rpad(to_char(get_oper_sol(v5abi||v5ani||v5asi)),8,' ')          
          when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
          then rpad(to_char(get_oper_sol(iv.omabf||iv.omanf||iv.omasf)),8,' ')
          else rpad(' ',8,' ') end,
          --case
          --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
          --then rpad(to_char(get_oper_sol(v5abi||v5ani||v5asi)),8,' ')
          --else rpad(' ',8,' ') end,
-- v_Notice_prd_Mnts_forNotice_Dep  CHAR(3)
            lpad(' ',3,' '),                
-- v_Notice_prd_Days_forNotice_Dep  CHAR(3)
            lpad(' ',3,' '),
--V_NOTICE_DATE CHAR(10)
            lpad(' ',10,' '),            
--   v_Stamp_Duty_Borne_By_Cust     CHAR(1)
            lpad(' ',1,' '),
-- v_Stamp_Duty_Amount              CHAR(1)
            lpad(' ',17,' '),
-- v_Stamp_Duty_Amount_Crncy_Code   CHAR(3)
            lpad(' ',3,' '),
--   v_Original_Deposit_Amt         CHAR(17)
            lpad(' ',17,' '),                                        -- Need to check if we need to bring this value
-- v_Absolute_Rate_of_Interest      CHAR(8)            
            case when v5pf.v5rat='0' then lpad(to_char(nvl(D4BRAR,0)),8,' ')
            when  TO_number(v5pf.v5rat) between 0.001 and 0.999 then lpad('0'||to_char(v5pf.v5rat),8,' ')
            else lpad(to_char(v5pf.v5rat),8,' ')
            end,
-- v_Exclude_for_combined_stmnt     CHAR(1)
            lpad(' ',1,' '),
--   v_Statement_CIF_ID             CHAR(32)
            lpad(' ',32,' '),
--   v_Maturity_Date                CHAR(10)            
            rpad(case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
            to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
            else to_char(to_date(get_date_fm_btrv(V5NRD),'YYYYMMDD'),'DD-MM-YYYY') end,10,' '),   ----based on Spira issue 7089- script  changed on 02-07-2017         
 --      rpad(case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
 --         to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'M' and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
 --        to_char(add_months(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),JRNUM),'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'Y' and v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
 --        to_char(add_months(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),JRNUM*12),'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'W'and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
 --        to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')+JRNUM*7,'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'D'and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
 --        to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')+JRNUM,'DD-MM-YYYY')        
 --  when  jrpf.jrddy like 'M'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
 --        to_char(add_months(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD'),JRNUM),'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'Y'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
 --        to_char(add_months(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD'),JRNUM*12),'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'W'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
 --        to_char(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD')+JRNUM*7,'DD-MM-YYYY')
 --  when  jrpf.jrddy like 'D'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
 --        to_char(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD')+JRNUM,'DD-MM-YYYY')        
 --          end,10,' '),
--  v_Treasury_Rate_MOR             CHAR(8)
            lpad(' ',8,' '),
--   v_Renewal_Option               CHAR(1)
           rpad(case when v5pf.v5arc in ('A','P') then ' '
                --when HYDBNM||HYDLP||HYDLR is not null and v5abd||v5and||v5asd<>v5abi||v5ani||v5asi then 'P' --commented as per spira 7096 and vijay confirmation on 06-07-2017. auto renewal no need for collateral account
                --when HYDBNM||HYDLP||HYDLR is not null and v5abd||v5and||v5asd=v5abi||v5ani||v5asi then 'M'  --commented as per spira 7096 and vijay confirmation on 06-07-2017. auto renewal no need for collateral account
                when v5pf.v5mdt=9999999 and  v5abd||v5and||v5asd<>v5abi||v5ani||v5asi then 'P'
                when v5pf.v5mdt=9999999 and  v5abd||v5and||v5asd=v5abi||v5ani||v5asi then 'M'
                else ' ' end,1,' '), 
--   v_Renewal_Amount               CHAR(17)
            lpad(' ',17,' '),
--   v_Additional_Amt               CHAR(17)
            lpad(' ',17,' '),
--   v_Addnl_Amt_Crncy              CHAR(3)
            lpad(' ',3,' '),
--   v_Renewal_Crncy                CHAR(3)
            lpad(' ',3,' '),
-- v_Additional_Source_Account      CHAR(16)
            lpad(' ',16,' '),
-- v_Aditional_Src_acct_Crncy_Code  CHAR(3)
            lpad(' ',3,' '),
--   v_Additional_Ac_Sol_Id         CHAR(8)
            lpad(' ',8,' '),
--   v_Additional_Rate_Code         CHAR(5)
            lpad(' ',5,' '),
--  v_Renewal_Rate_Code             CHAR(5)
            lpad(' ',5,' '),
--   v_Additional_Rate              CHAR(8)
            lpad(' ',8,' '),
--   v_Renewal_Rate                 CHAR(8)
            lpad(' ',8,' '),
--   v_Link_Operative_Account       CHAR(16)
            lpad(' ',16,' '),
--  v_Break_in_Steps_Of             CHAR(17)
            lpad(' ',17,' '),
--   v_wtax_level_flg               CHAR(1)
            lpad(' ',1,' '),
--  v_Wtax_pcnt                     CHAR(8)
            lpad(' ',8,' '),
--   v_Wtax_floor_limit             CHAR(17)
            lpad(' ',17,' '),
--   v_Iban_number                  CHAR(34)
            lpad(' ',34,' '),
--   v_Ias_code                     CHAR(5)
            lpad(' ',5,' '),
-- v_Channel_ID                     CHAR(5)
            lpad(' ',5,' '),
-- v_Channel_Level_Code             CHAR(5)
            lpad(' ',5,' '),
--   v_Master_acct_num              CHAR(16)
            lpad(' ',16,' '),
--   v_acct_status                  CHAR(1)
            rpad('A',1,' '),
--   v_acct_status_date             CHAR(8)
            lpad(' ',10,' '),
--   v_Dummy                        CHAR(100)
            lpad(nvl(trim(' ')||' '||trim(' ')||' '||trim(' ')||' '||trim(' '),' '),100,' '),
-- v_ps_diff_freq_rel_party_flg     CHAR(1)
            lpad(' ',1,' '),
-- v_swift_diff_freq_rel_party_flg  CHAR(1)
            lpad(' ',1,' '),
-- v_Fixed_instal_amt_Amt_topup     CHAR(17)
            lpad(' ',17,' '),
-- v_Normal_Installment_Percentage  CHAR(10)
            lpad(' ',10,' '),
-- v_Installment_basis              CHAR(1)
            lpad(' ',1,' '),
-- v_Max_missed_contribut_allowed   CHAR(3)
            lpad(' ',3,' '),
-- v_Auto_closure_of_irregular_act  CHAR(1)
            lpad(' ',1,' '),
-- v_Total_num_of_missed_contribut  CHAR(3)
            lpad(' ',3,' '),
--   v_Account_Irregular_status     CHAR(1)
            lpad(' ',1,' '),
-- v_Account_Irregular_Status_Date  CHAR(8)
            lpad(' ',10,' '),
-- v_Cumulative_Normal_Instal_paid  CHAR(17)
            lpad(' ',17,' '),
-- v_Cumulative_Initial_Dep_paid    CHAR(17)
            lpad(' ',17,' '),
--   v_Cumulative_Top_up_paid       CHAR(17)
            lpad(' ',17,' '),
-- v_AutoClosure_Zero_Bal_Acct_Mnts CHAR(3)
            lpad(' ',3,' '),
-- v_AutoClosure_Zero_Bal_Acct_Days CHAR(3)
            lpad(' ',3,' '),
--   v_Last_Bonus_Run_Date          CHAR(8)
            lpad(' ',10,' '),
-- v_Last_Calculated_Bonus_Amount   CHAR(17)
            lpad(' ',17,' '),
--   v_Bonus_Up_to_Date             CHAR(17)
            lpad(' ',17,' '),
--   v_Next_Bonus_Run_Date          CHAR(8)
            lpad(' ',10,' '),
-- v_Normal_Int_Paid_tilllast_Bonus CHAR(17)
            lpad(' ',17,' '),
--   v_Bonus_Cycle                  CHAR(3)
            lpad(' ',3,' '),
-- v_Last_Calc_Bonus_percentage     CHAR(10)
            lpad(' ',10,' '),
--   v_Penalty_Amount               CHAR(17)
            lpad(' ',17,' '),
--   v_Penalty_Charge_Event_Id      CHAR(25)
            lpad(' ',25,' '),
--   v_Address_Type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Phone_Type                     CHAR(12)
            lpad(' ',12,' '),
-- v_Email_Type                     CHAR(12)
            lpad(' ',12,' '),
-- v_Local_Deposit_period_months    CHAR(3)
            lpad(' ',3,' '),
--  v_Local_Deposit_period_days     CHAR(3)
            lpad(' ',3,' '),
--   v_Is_Account_hedged_flag       CHAR(1)
            lpad(' ',1,' '),
--  v_Used_For_Netting_Off_flag     CHAR(1)
            lpad(' ',1,' '),
    --MAX_AUTO_RENEWAL_ALLOWED    nvarchar2(3),
rpad(' ',3,' '),    
--AUTO_CLOSURE_IND    nvarchar2(1),
           rpad(case when v5pf.v5arc in ('A','P') then 'N'
                --when HYDBNM||HYDLP||HYDLR is not null then 'N' ----commented as per spira 7096 and vijay confirmation on 06-07-2017. auto renewal no need for collateral account
                when v5pf.v5mdt=9999999 then 'N'
                when map_acc.schm_code='TDATD' then 'N' ---- as per sandeep confirmation on mock 3a upload and error shared in mail dt 12-03-2017---'N' to 'Y' changed on 16-07-2017 based on hiyam and vijay confirmation due to mk5 issue raised by hiyam--as per sandeep confirmation TDATD scheme auto closure flg should't be 'Y'. So 'Y' to 'N' changed on 17-07-2017
                else 'Y' end,1,' '),    
--LAST_PURGE_DATE    nvarchar2(10),
rpad(' ',10,' '),    
    --PAY_PRECLS_PROFIT    nvarchar2(1),
rpad(' ',1,' '),    
    --PAY_MATURITY_PROFIT    nvarchar2(1),
rpad(' ',1,' '),    
    --MURABAHA_DEPOSIT_AMOUNT    nvarchar2(17),
rpad(' ',17,' '),    
    --CUSTOMER_PURCHASE_ID    nvarchar2(20),
rpad(' ',20,' '),
    --TOTAL_PROFIT_AMOUNT    nvarchar2(17),
rpad(' ',17,' '),    
    --MINIMUM_AGE_NOT_MET    nvarchar2(17),
rpad(' ',17,' '),    
    --BROKEN_PERIOD_PROFIT_PAID nvarchar2(1),
rpad(' ',1,' '),    
    --BROKEN_PERIOD_PROFIT_AMOUNT    nvarchar2(17),
rpad(' ',17,' '),    
    --PROFIT_BE_RECOVERED    nvarchar2(17),
rpad(' ',17,' '),    
    --INDICATE_PROFIT_DIST_UPTO_DATE    nvarchar2(10),
rpad(' ',10,' '),    
    --INDICATE_NEXT_PROFIT_DIST_DATE    nvarchar2(10),
rpad(' ',10,' '),    
    --TRANSFER_IN_IND    nvarchar2(1),
rpad(' ',1,' '),    
--REPAYMENT_ACCOUNT    nvarchar2(16),
rpad(get_oper_acct(pm.omabf||pm.omanf||pm.omasf),16,' '),    
--rpad(' ',16,' '),    
    --REBATE_AMOUNT    nvarchar2(17),
rpad(' ',17,' '),    
    --BRANCH_OFFICE    nvarchar2(20),
rpad(' ',20,' '),    
    --DEFERMENT_PERIOD_MONTHS    nvarchar2(3),
rpad(' ',3,' '),    
    --CONTINUATION_IND    nvarchar2(1)
rpad(' ',1,' ')            
from v5pf
inner join scpf on SCAB=V5ABD and scan=V5AND and scas=V5ASD 
inner join map_acc on map_acc.LEG_ACC_NUM=v5brnm||trim(v5dlp)||trim(v5dlr)
inner join c8pf on c8ccy =scccy
left join (select * from tbaadm.TSD where srl_num='002' and bank_id='01' ) tsd on tsd.schm_code=map_acc.schm_code
left join ospf on v5brnm=osbrnm and trim(v5dlp)=trim(osdlp) and trim(v5dlr)=trim(osdlr)
left join (select * from otpf where ottdt='D')otpf on v5brnm=otbrnm and trim(v5dlp)=trim(otdlp) and trim(v5dlr)=trim(otdlr)
left join ompf_iv iv on v5brnm=iv.ombrnm and trim(v5dlp)=trim(iv.omdlp) and trim(v5dlr)=trim(iv.omdlr)
left join ompf_pm pm on v5brnm=pm.ombrnm and trim(v5dlp)=trim(pm.omdlp) and trim(v5dlr)=trim(pm.omdlr)
left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) clmamount  from v5pf
inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') > case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
                                                    when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
group by v5brnm,v5dlp,v5dlr)int_amt on int_amt.v5brnm =v5pf.v5brnm and int_amt.v5dlp=v5pf.v5dlp  and  int_amt.v5dlr=v5pf.v5dlr
left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) atd_clmamount  from v5pf
inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') >= case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
                                                   when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
and trim(v4dlp)='ATD' and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
group by v5brnm,v5dlp,v5dlr)atd_int_amt on atd_int_amt.v5brnm =v5pf.v5brnm and atd_int_amt.v5dlp=v5pf.v5dlp  and  atd_int_amt.v5dlr=v5pf.v5dlr
left join d4pf on d4brr=v5brr
left join jrpf on trim(jrpf.jrprc) =trim(v5pf.v5prc) 
--left join (select* from hypf where hydlr is not null) hypf on HYDBNM||HYDLP||HYDLR = map_acc.leg_acc_num
--left join owpf_note_tda on leg_acc=map_acc.leg_acc_num
left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code = map_acc.CURRENCY  
left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'N' group by schm_code)gss  on map_acc.schm_code = gss.schm_code
left join (select * from tbaadm.TSP where bank_id = get_param('BANK_ID') and del_flg = 'N' )TSP  on map_acc.schm_code = TSP.schm_code AND Tsp.crncy_code = map_acc.CURRENCY    
left join future_interest fi on fi.leg_acc_num=map_acc.leg_acc_num
left join (select distinct v5pf_acc_num,tbl_code from dep_rate)dep_rate on  v5pf_acc_num=map_acc.leg_acc_num
where map_acc.SCHM_TYPE='TDA' and v5pf.v5tdt='D' and v5pf.v5bal<>'0';
commit;
--update tda_o_table set RENEWAL_OPTION ='M' where trim(Auto_Renewal_Flag)='U';
--commit; --commented on 29/06/2017 based on issue raised by haiyam. Why was this updated??? there are some renewal option as 'P' in Equation which are updated as "M" which is incorrect 
--CLOSED DEPOSIT ACCOUNTS--
--insert into TDA_O_TABLE 
--select +use_hash(scab,scan,scas,scccy,ombrnm,omdlp,omdlr) 
----   v_Employee_Id                  CHAR(9)
--            lpad(' ',9,' '),
---- v_Customer_Credit_Pref_Percent   CHAR(10)
--            lpad(' ',10,' '),
---- v_Customer_Debit_Pref_Percent    CHAR(10)
--            lpad(' ',10,' '),
---- v_Account_Credit_Pref_Percent    CHAR(10)
--            lpad(' ',10,' '),
---- v_Account_Debit_Pref_Percent     CHAR(10)
--            lpad(' ',10,' '),
---- v_Channel_Credit_Pref_Percent    CHAR(10)
--            lpad(' ',10,' '),
---- v_Channel_Debit_Pref_Percent     CHAR(10)
--            lpad(' ',10,' '),
----   v_Pegged_Flag                  CHAR(1)
--            rpad('N',1,' '),
----   v_Peg_Frequency_in_Months      CHAR(4)
--            lpad(' ',4,' '),
----   v_Peg_Frequency_in_Days        CHAR(3)
--            lpad(' ',3,' '),
---- v_sulabh_flg                     CHAR(1)
--            rpad(' ',1,' '),
----   v_interest_accrual_flag        CHAR(1)
--            rpad('Y',1,' '),                                   -- Need confirmation from Business
---- v_Passbook_Sheet_Receipt_Ind     CHAR(1)
--            rpad('N',1,' '),
---- v_With_holdng_tax_amt_scope_flg  CHAR(1)
--            lpad(' ',1,' '),
----   v_With_holding_tax_flag        CHAR(1)
--            lpad('N',1,' '),
---- v_safe_custody_flag              CHAR(1)
--            rpad('N',1,' '),
----   v_cash_excp_amount_limit       CHAR(17)
--            lpad(' ',17,' '),
---- v_clearing_excp_amount_limit     CHAR(17)
--            lpad(' ',17,' '),
---- v_Transfer_excp_amount_limit     CHAR(17)
--            lpad(' ',17,' '),
----   v_cash_cr_excp_amt_lim         CHAR(17)
--            lpad(' ',17,' '),
----   v_Clearing_cr_excp_amt_lim     CHAR(17)
--            lpad(' ',17,' '),
----   v_Transfer_cr_excp_amt_lim     CHAR(17)
--            lpad(' ',17,' '),
----   v_Deposit_Account_Number       CHAR(16)
--            lpad(map_acc.fin_acc_num,16,' '),        -- Need to write the a/c number generation for TD
----   v_Currency_Code                CHAR(3)
--            lpad(map_acc.currency,3,' '),
----   v_SOL_ID                       CHAR(8)
--            lpad(map_acc.fin_sol_id,8,' '),
----   v_GL_Sub_head_code             CHAR(5)
--            rpad(nvl(map_acc.GL_SUB_HEADCODE,' '),5,' '),
----   v_Scheme_Code                  CHAR(5)
--            rpad(map_acc.schm_code,5,' '),                    -- Defaulted as no BPD values
----   v_CIF_ID                       CHAR(32)
--            lpad(map_acc.fin_cif_id,32,' '),
----   v_Deposit_amount               CHAR(17)
--            lpad(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),17,' '),
----   v_Deposit_period_months        CHAR(3)
--            lpad(' ',3,' '),                                -- Maturity date value is given in TD002-065 filed so this is not required.
----   v_Deposit_period_days          CHAR(3)
--            lpad(' ',3,' '),                                -- Maturity date value is given in TD002-065 filed so this is not required.
----   v_Interest_table_code          CHAR(5)
--            rpad(csp.INT_TBL_CODE,5,' '),                        
----  v_Mode_of_operation             CHAR(5)
--            rpad('012',5,' '),                                    -- Defaulted as no BPD values
----   v_Account_location_code        CHAR(5)
--            lpad(' ',5,' '),
----  v_Auto_Renewal_Flag             CHAR(1)
--           rpad(case when v5pf.v5arc in ('A','P') then 'N'
--                when HYDBNM||HYDLP||HYDLR is not null then 'U' 
--                when v5pf.v5mdt=9999999 then 'U'
--                else 'N' end,1,' '),    
---- v_Prd_in_mnths_for_auto_renewal  CHAR(3)
--            lpad( case when v5pf.v5mdt=9999999 then 
--              case when jrpf.jrddy like 'M'  then 
--                        to_char(jrpf.jrnum)
--                    when jrpf.jrddy like 'Y'  then 
--                              to_char(jrpf.jrnum*12)
--                    when jrpf.jrddy like 'D'  and jrpf.jrnum > 360 then 
--                          to_char(floor(jrpf.jrnum/30))
--                          else '0'
--                          end
--                    else '0'
--               end,3,' '),                            
---- v_Prd_in_days_for_auto_renewal   CHAR(3)
--            lpad( case when v5pf.v5mdt=9999999 then 
--           case when jrpf.jrddy = 'D' and jrpf.jrnum > 360  then 
--                    to_char(mod(jrpf.jrnum,30)) 
--                when jrpf.jrddy = 'D' and jrpf.jrnum <= 360  then 
--                     to_char(jrpf.jrnum)
--                when jrpf.jrddy = 'W'  then to_char(JRNUM*7)     
--                else '0' end
--             else '0'     end,3,' '),                            
----  v_Account_Open_Date             CHAR(10)
--            case when otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            else rpad(' ',10,' ') end,
----   v_Open_Effective_Date          CHAR(10)
--            case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            else  rpad(' ',10,' ')
--            end,
---- v_Nominee_Print_Flag             CHAR(1)
--            rpad('N',1,' '),
----   v_Printing_Flag                CHAR(1)
--            case when SCAID3='Y' then rpad('Y',1,' ')
--            else rpad('N',1,' ') end,
----   v_Ledger_Number                CHAR(3)
--            lpad(' ',3,' '),
---- v_Last_Credit_Int_Posted_Date    CHAR(10)
--            case when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
--                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end,
----   v_Last_Credit_Int_Run_Date     CHAR(10)
--            case when  otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' and v5lcd=0 then rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--                 when v5lcd<>0 and v5lre<>0 and  get_date_fm_btrv(v5lcd) <> 'ERROR' and to_date(get_date_fm_btrv(v5lre),'YYYYMMDD') <to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD') 
--                                     then rpad(to_char(to_date(get_date_fm_btrv(v5lcd),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--                 when v5lre<>0  and get_date_fm_btrv(v5lre) <> 'ERROR'  then rpad(to_char(to_date(get_date_fm_btrv(v5lre),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ')
--            else rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD')-1,'DD-MM-YYYY'),10,' ') end ,
---- v_Last_Interest_Provision_Date   CHAR(10)            
--             case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--             rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--             when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--             rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--             else  rpad(' ',10,' ')
--             end,
----   v_Printed_date                 CHAR(10)
--            --lpad(' ',10,' '),
--            case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then
--            rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
--            else  rpad(' ',10,' ')
--            end,
----   v_Cumulative_Interest_Paid     CHAR(17)
--            lpad(case when v5abd||v5and||v5asd<>v5abi||v5ani||v5asi then nvl(to_char(to_number((clmamount)/POWER(10,C8CED))),'0')
--            else ' ' end,17,' '),
---- v_Cumulative_interest_credited   CHAR(17)
--            lpad(nvl(case when v5abd||v5and||v5asd=v5abi||v5ani||v5asi then to_char(to_number((clmamount)/POWER(10,C8CED)))
--            else ' ' end,' '),17,' '),       
---- v_Cumulative_installments_paid   CHAR(17)            
--            lpad(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),17,' '),
----   v_Maturity_amount              CHAR(17)           
--            lpad(to_number(v5pf.v5bal)/power(10,c8pf.c8ced),17,' '),
----   v_Operative_Account_Number     CHAR(16)
--           case          
--           when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null            
--           then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')                     
--           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--           then rpad(get_oper_acct(iv.omabf||iv.omanf||iv.omasf),16,' ') 
--           else rpad(' ',16,' ') end,
--           --case
--           --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null 
--           --then rpad(get_oper_acct(v5abi||v5ani||v5asi),16,' ')           
--           --else rpad(' ',16,' ') end,
---- v_Operative_Account_Crncy_Code   CHAR(3)           
--           case           
--           when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
--           then rpad(get_oper_ccy(v5abi||v5ani||v5asi),3,' ')           
--           when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--           then rpad(trim(get_oper_ccy(iv.omabf||iv.omanf||iv.omasf)),3,' ') 
--           else rpad(' ',3,' ')end,
--           --case
--           --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
--           --then rpad(get_oper_ccy(v5abi||v5ani||v5asi),3,' ')             
--           --else rpad(' ',3,' ')end,
----   v_Operative_Account_SOL        CHAR(8)          
--          case          
--          when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
--          then rpad(to_char(get_oper_sol(v5abi||v5ani||v5asi)),8,' ')          
--          when trim(get_oper_acct(iv.omabf||iv.omanf||iv.omasf)) is not null 
--          then rpad(to_char(get_oper_sol(iv.omabf||iv.omanf||iv.omasf)),8,' ')
--          else rpad(' ',8,' ') end,
--          --case
--          --when trim(get_oper_acct(v5abi||v5ani||v5asi)) is not null  
--          --then rpad(to_char(get_oper_sol(v5abi||v5ani||v5asi)),8,' ')
--          --else rpad(' ',8,' ') end,
---- v_Notice_prd_Mnts_forNotice_Dep  CHAR(3)
--            lpad(' ',3,' '),                
---- v_Notice_prd_Days_forNotice_Dep  CHAR(3)
--            lpad(' ',3,' '),
----V_NOTICE_DATE CHAR(10)
--            lpad(' ',10,' '),            
----   v_Stamp_Duty_Borne_By_Cust     CHAR(1)
--            lpad(' ',1,' '),
---- v_Stamp_Duty_Amount              CHAR(1)
--            lpad(' ',17,' '),
---- v_Stamp_Duty_Amount_Crncy_Code   CHAR(3)
--            lpad(' ',3,' '),
----   v_Original_Deposit_Amt         CHAR(17)
--            lpad(' ',17,' '),                                        -- Need to check if we need to bring this value
---- v_Absolute_Rate_of_Interest      CHAR(8)            
--            case when v5pf.v5rat='0' then lpad(to_char(nvl(D4BRAR,0)),8,' ')
--            when  TO_number(v5pf.v5rat) between 0.001 and 0.999 then lpad('0'||to_char(v5pf.v5rat),8,' ')
--            else lpad(to_char(v5pf.v5rat),8,' ')
--            end,
---- v_Exclude_for_combined_stmnt     CHAR(1)
--            lpad(' ',1,' '),
----   v_Statement_CIF_ID             CHAR(32)
--            lpad(' ',32,' '),
----   v_Maturity_Date                CHAR(10)            
--            --rpad(case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
--            --to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
--            --else to_char(to_date(get_date_fm_btrv(V5NRD),'YYYYMMDD'),'DD-MM-YYYY') end,10,' '),            
--            rpad(case when v5mdt<>0 and   get_date_fm_btrv(v5mdt) <> 'ERROR' and v5mdt<>'9999999' then
--            to_char(to_date(get_date_fm_btrv(v5mdt),'YYYYMMDD'),'DD-MM-YYYY')
--     when  jrpf.jrddy like 'M' and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--           to_char(add_months(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),JRNUM),'DD-MM-YYYY')
--     when  jrpf.jrddy like 'Y' and v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--           to_char(add_months(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD'),JRNUM*12),'DD-MM-YYYY')
--     when  jrpf.jrddy like 'W'and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--           to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')+JRNUM*7,'DD-MM-YYYY')
--     when  jrpf.jrddy like 'D'and  v5mdt= '9999999' and V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then
--           to_char(to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')+JRNUM,'DD-MM-YYYY')        
--     when  jrpf.jrddy like 'M'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
--           to_char(add_months(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD'),JRNUM),'DD-MM-YYYY')
--     when  jrpf.jrddy like 'Y'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
--           to_char(add_months(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD'),JRNUM*12),'DD-MM-YYYY')
--     when  jrpf.jrddy like 'W'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
--           to_char(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD')+JRNUM*7,'DD-MM-YYYY')
--     when  jrpf.jrddy like 'D'and  v5mdt= '9999999' and Otsdte<>'0' and   get_date_fm_btrv(Otsdte) <> 'ERROR' then
--           to_char(to_date(get_date_fm_btrv(Otsdte),'YYYYMMDD')+JRNUM,'DD-MM-YYYY')        
--             end,10,' '),
----  v_Treasury_Rate_MOR             CHAR(8)
--            lpad(' ',8,' '),
----   v_Renewal_Option               CHAR(1)
--            ' ',
----   v_Renewal_Amount               CHAR(17)
--            lpad(' ',17,' '),
----   v_Additional_Amt               CHAR(17)
--            lpad(' ',17,' '),
----   v_Addnl_Amt_Crncy              CHAR(3)
--            lpad(' ',3,' '),
----   v_Renewal_Crncy                CHAR(3)
--            lpad(' ',3,' '),
---- v_Additional_Source_Account      CHAR(16)
--            lpad(' ',16,' '),
---- v_Aditional_Src_acct_Crncy_Code  CHAR(3)
--            lpad(' ',3,' '),
----   v_Additional_Ac_Sol_Id         CHAR(8)
--            lpad(' ',8,' '),
----   v_Additional_Rate_Code         CHAR(5)
--            lpad(' ',5,' '),
----  v_Renewal_Rate_Code             CHAR(5)
--            lpad(' ',5,' '),
----   v_Additional_Rate              CHAR(8)
--            lpad(' ',8,' '),
----   v_Renewal_Rate                 CHAR(8)
--            lpad(' ',8,' '),
----   v_Link_Operative_Account       CHAR(16)
--            lpad(' ',16,' '),
----  v_Break_in_Steps_Of             CHAR(17)
--            lpad(' ',17,' '),
----   v_wtax_level_flg               CHAR(1)
--            lpad(' ',1,' '),
----  v_Wtax_pcnt                     CHAR(8)
--            lpad(' ',8,' '),
----   v_Wtax_floor_limit             CHAR(17)
--            lpad(' ',17,' '),
----   v_Iban_number                  CHAR(34)
--            lpad(' ',34,' '),
----   v_Ias_code                     CHAR(5)
--            lpad(' ',5,' '),
---- v_Channel_ID                     CHAR(5)
--            lpad(' ',5,' '),
---- v_Channel_Level_Code             CHAR(5)
--            lpad(' ',5,' '),
----   v_Master_acct_num              CHAR(16)
--            lpad(' ',16,' '),
----   v_acct_status                  CHAR(1)
--            rpad('A',1,' '),
----   v_acct_status_date             CHAR(8)
--            lpad(' ',10,' '),
----   v_Dummy                        CHAR(100)
--            lpad(nvl(trim(' ')||' '||trim(' ')||' '||trim(' ')||' '||trim(' '),' '),100,' '),
---- v_ps_diff_freq_rel_party_flg     CHAR(1)
--            lpad(' ',1,' '),
---- v_swift_diff_freq_rel_party_flg  CHAR(1)
--            lpad(' ',1,' '),
---- v_Fixed_instal_amt_Amt_topup     CHAR(17)
--            lpad(' ',17,' '),
---- v_Normal_Installment_Percentage  CHAR(10)
--            lpad(' ',10,' '),
---- v_Installment_basis              CHAR(1)
--            lpad(' ',1,' '),
---- v_Max_missed_contribut_allowed   CHAR(3)
--            lpad(' ',3,' '),
---- v_Auto_closure_of_irregular_act  CHAR(1)
--            lpad(' ',1,' '),
---- v_Total_num_of_missed_contribut  CHAR(3)
--            lpad(' ',3,' '),
----   v_Account_Irregular_status     CHAR(1)
--            lpad(' ',1,' '),
---- v_Account_Irregular_Status_Date  CHAR(8)
--            lpad(' ',10,' '),
---- v_Cumulative_Normal_Instal_paid  CHAR(17)
--            lpad(' ',17,' '),
---- v_Cumulative_Initial_Dep_paid    CHAR(17)
--            lpad(' ',17,' '),
----   v_Cumulative_Top_up_paid       CHAR(17)
--            lpad(' ',17,' '),
---- v_AutoClosure_Zero_Bal_Acct_Mnts CHAR(3)
--            lpad(' ',3,' '),
---- v_AutoClosure_Zero_Bal_Acct_Days CHAR(3)
--            lpad(' ',3,' '),
----   v_Last_Bonus_Run_Date          CHAR(8)
--            lpad(' ',10,' '),
---- v_Last_Calculated_Bonus_Amount   CHAR(17)
--            lpad(' ',17,' '),
----   v_Bonus_Up_to_Date             CHAR(17)
--            lpad(' ',17,' '),
----   v_Next_Bonus_Run_Date          CHAR(8)
--            lpad(' ',10,' '),
---- v_Normal_Int_Paid_tilllast_Bonus CHAR(17)
--            lpad(' ',17,' '),
----   v_Bonus_Cycle                  CHAR(3)
--            lpad(' ',3,' '),
---- v_Last_Calc_Bonus_percentage     CHAR(10)
--            lpad(' ',10,' '),
----   v_Penalty_Amount               CHAR(17)
--            lpad(' ',17,' '),
----   v_Penalty_Charge_Event_Id      CHAR(25)
--            lpad(' ',25,' '),
----   v_Address_Type                 CHAR(12)
--            lpad(' ',12,' '),
---- v_Phone_Type                     CHAR(12)
--            lpad(' ',12,' '),
---- v_Email_Type                     CHAR(12)
--            lpad(' ',12,' '),
---- v_Local_Deposit_period_months    CHAR(3)
--            lpad(' ',3,' '),
----  v_Local_Deposit_period_days     CHAR(3)
--            lpad(' ',3,' '),
----   v_Is_Account_hedged_flag       CHAR(1)
--            lpad(' ',1,' '),
----  v_Used_For_Netting_Off_flag     CHAR(1)
--            lpad(' ',1,' '),
--    --MAX_AUTO_RENEWAL_ALLOWED    nvarchar2(3),
--rpad(' ',3,' '),    
--    --AUTO_CLOSURE_IND    nvarchar2(1),
--rpad('N',1,' '),     
----LAST_PURGE_DATE    nvarchar2(10),
--rpad(' ',10,' '),    
--    --PAY_PRECLS_PROFIT    nvarchar2(1),
--rpad(' ',1,' '),    
--    --PAY_MATURITY_PROFIT    nvarchar2(1),
--rpad(' ',1,' '),    
--    --MURABAHA_DEPOSIT_AMOUNT    nvarchar2(17),
--rpad(' ',17,' '),    
--    --CUSTOMER_PURCHASE_ID    nvarchar2(20),
--rpad(' ',20,' '),
--    --TOTAL_PROFIT_AMOUNT    nvarchar2(17),
--rpad(' ',17,' '),    
--    --MINIMUM_AGE_NOT_MET    nvarchar2(17),
--rpad(' ',17,' '),    
--    --BROKEN_PERIOD_PROFIT_PAID nvarchar2(1),
--rpad(' ',1,' '),    
--    --BROKEN_PERIOD_PROFIT_AMOUNT    nvarchar2(17),
--rpad(' ',17,' '),    
--    --PROFIT_BE_RECOVERED    nvarchar2(17),
--rpad(' ',17,' '),    
--    --INDICATE_PROFIT_DIST_UPTO_DATE    nvarchar2(10),
--rpad(' ',10,' '),    
--    --INDICATE_NEXT_PROFIT_DIST_DATE    nvarchar2(10),
--rpad(' ',10,' '),    
--    --TRANSFER_IN_IND    nvarchar2(1),
--rpad(' ',1,' '),    
----REPAYMENT_ACCOUNT    nvarchar2(16),
--rpad(get_oper_acct(pm.omabf||pm.omanf||pm.omasf),16,' '),    
----rpad(' ',16,' '),    
--    --REBATE_AMOUNT    nvarchar2(17),
--rpad(' ',17,' '),    
--    --BRANCH_OFFICE    nvarchar2(20),
--rpad(' ',20,' '),    
--    --DEFERMENT_PERIOD_MONTHS    nvarchar2(3),
--rpad(' ',3,' '),    
--    --CONTINUATION_IND    nvarchar2(1)
--rpad(' ',1,' ')            
--from v5pf
--inner join scpf on scpf.SCAB=v5pf.V5ABD and scpf.scan=v5pf.V5AND and scpf.scas=v5pf.V5ASD and scpf.scccy=v5pf.V5CCY
--inner join map_acc on map_acc.LEG_ACC_NUM=trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
--inner join c8pf on c8ccy =scpf.scccy
--left join ospf on v5brnm=osbrnm and v5dlp=osdlp and v5dlr=osdlr
--left join (select * from otpf where ottdt='D')otpf on v5brnm=otbrnm and v5dlp=otdlp and v5dlr=otdlr
--left join ompf_iv iv on v5brnm=iv.ombrnm and v5dlp=iv.omdlp and v5dlr=iv.omdlr
--left join ompf_pm pm on v5brnm=pm.ombrnm and v5dlp=pm.omdlp and v5dlr=pm.omdlr
--left join (select v5brnm,v5dlp,v5dlr,sum(v4aim1)+sum(v4aim2) clmamount  from v5pf
--inner join v4pf on v5brnm=v4brnm and v5dlp=v4dlp and v5dlr=v4dlr
--inner join (select * from otpf where ottdt='D')otpf on otbrnm=v4brnm and otdlp=v4dlp and otdlr=v4dlr
--where to_date(get_date_fm_btrv(V4DTE),'YYYYMMDD') > case when V5LRE<>'0' and   get_date_fm_btrv(V5LRE) <> 'ERROR' then to_date(get_date_fm_btrv(V5LRE),'YYYYMMDD')
--                                                    when  otsdte<>'0' and   get_date_fm_btrv(otsdte) <> 'ERROR' then to_date(get_date_fm_btrv(otsdte),'YYYYMMDD') end
--and v5pf.v5tdt='D' and v5pf.v5bal<>'0'                                                    
--group by v5brnm,v5dlp,v5dlr)int_amt on int_amt.v5brnm =v5pf.v5brnm and int_amt.v5dlp=v5pf.v5dlp  and  int_amt.v5dlr=v5pf.v5dlr
--left join d4pf on d4brr=v5brr
--left join jrpf on trim(jrpf.jrprc) =trim(v5pf.v5prc) 
--left join (select* from hypf where hydlr is not null) hypf on HYDBNM||HYDLP||HYDLR = map_acc.leg_acc_num
----left join owpf_note_tda on leg_acc=map_acc.leg_acc_num
--left join (select * from tbaadm.csp where bank_id = get_param('BANK_ID') and del_flg = 'N')csp on csp.schm_code = map_acc.schm_code and csp.crncy_code = map_acc.CURRENCY  
--left join (select schm_code,max(GL_SUB_HEAD_CODE) GL_SUB_HEAD_CODE from tbaadm.gss where bank_id = get_param('BANK_ID') and del_flg = 'N' and default_flg = 'N' group by schm_code)gss  on map_acc.schm_code = gss.schm_code
--left join (select * from tbaadm.TSP where bank_id = get_param('BANK_ID') and del_flg = 'N' )TSP  on map_acc.schm_code = TSP.schm_code AND Tsp.crncy_code = map_acc.CURRENCY    
--where map_acc.SCHM_TYPE='TDA' and v5pf.v5tdt='D' and ACC_CLOSED='CLOSED'; 
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TDA04_upload_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TDA04_upload_kw.sql 
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
 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Tran_details.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Tran_details.sql 
truncate table tran_details;

insert into tran_details
------------------------------CA,SA OD Balance---------------------------
select 
to_char(account_number) account_number,
gl_sub_headcode ,
schm_code,
to_char(dummy) scheme_type,
case when to_number(amount) < 0 then 'D' else 'C' end dr_cr_ind,
abs(to_number(amount)) amount,
'BAL' out_file,
leg_acc_num,
to_char(leg_acct_type)scact,
to_char(currency_code)currency_code,
to_char(service_outlet)service_outlet,
case when to_number(amount) < 0 then abs(to_number(amount)) else 0 end dr_bal,
case when to_number(amount) >= 0 then abs(to_number(amount)) else 0 end cr_bal,
TO_CHAR(trim(dummy))
from ac_balance_o_table
inner join map_acc on fin_acc_num = trim(account_number)
union all
select 
'',--to_char(TTUM1_MIGR_ACCT),
'52000' ,
schm_code,
to_char(dummy) scheme_type,
case when to_number(amount) < 0 then 'C' else 'D' end dr_cr_ind,
abs(to_number(amount)) amount,
'BAL' out_file,
leg_acc_num,
to_char(leg_acct_type),
to_char(currency_code)currency_code,
to_char(service_outlet)service_outlet,
case when to_number(amount) >= 0 then abs(to_number(amount)) else 0 end dr_bal,
case when to_number(amount) < 0 then abs(to_number(amount)) else 0 end cr_bal,
to_char('52000'||trim(dummy))
from ac_balance_o_table
inner join map_acc on fin_acc_num = trim(account_number)
-------------------------------------PCA---------------------
union all
select 
to_char(account_number) account_number,
gl_sub_headcode ,
schm_code,
to_char('PCA') scheme_type,
case when to_number(amount) > 0 then 'D' else 'C' end dr_cr_ind, ----intentionally added the sign otherwise because its debit balance but there is not part tran indicator
abs(to_number(amount)) amount,
'PCA' out_file,
leg_acc_num,
to_char(leg_acct_type)scact,
to_char(currency)currency_code,
to_char(fin_sol_id)service_outlet,
case when to_number(amount) > 0 then abs(to_number(amount)) else 0 end dr_bal,
case when to_number(amount) <= 0 then abs(to_number(amount)) else 0 end cr_bal,
TO_CHAR(trim('PCA'))
from 
(
select account_number,sum(ds_amt) amount from pca_disb group by account_number
)
inner join map_acc on fin_acc_num = trim(account_number)
union all
select 
'',--to_char(TTUM1_MIGR_ACCT),
'52000' ,
schm_code,
to_char('PCA') scheme_type,
case when to_number(amount) > 0 then 'C' else 'D' end dr_cr_ind,
abs(to_number(amount)) amount,
'PCA' out_file,
leg_acc_num,
to_char(leg_acct_type),
to_char(currency)currency_code,
to_char(fin_sol_id)service_outlet,
case when to_number(amount) <= 0 then abs(to_number(amount)) else 0 end dr_bal,
case when to_number(amount) > 0 then abs(to_number(amount)) else 0 end cr_bal,
to_char('52000'||trim('PCA'))
from 
(
select account_number,sum(ds_amt) amount from pca_disb group by account_number
)a
inner join map_acc on fin_acc_num = trim(account_number)
------------------------------Term deposit---------------------------------------------
union all
select 
to_char(trim(account_number)),
to_char(case when substr(trim(account_number),11,3) = 'TDA'  then '52000' else gl_sub_head_code end) gl_sub_head_code,
scheme_code,
to_char('TDA') scheme_type,
to_char(PART_TRANSACTION_TYPE) dr_cr_ind,
abs(to_number(amount)) amount,
'TDT' out_file,
leg_acc_num,
to_char(scact)scact,
to_char(currency_code)currency_code,
to_char(sol_code)service_outlet,
case when PART_TRANSACTION_TYPE = 'D' then abs(to_number(amount)) else 0 end dr_bal,
case when PART_TRANSACTION_TYPE = 'C' then abs(to_number(amount)) else 0 end cr_bal,
case when substr(trim(account_number),11,3) = 'TDA'  then '52000TDA' else 'TDA' END
from tdt_o_table
left join all_final_trial_balance on fin_acc_num = trim(account_number)
-------------------LAT---
union all
select 
to_char(trim(account_number)),
to_char(case when substr(trim(account_number),11,3) = 'LAA'  then '52000' else gl_sub_head_code end )gl_sub_head_code,
scheme_code,
to_char('LAA') scheme_type,
PART_TRAN_TYPE dr_cr_ind,
abs(to_number(amount)) amount,
'LAT' out_file,
leg_acc_num,
to_char(scact)scact,
to_char(currency)currency_code,
to_char(service_outlet)service_outlet,
case when PART_TRAN_TYPE = 'D' then ABS(to_number(amount)) else 0 end dr_bal,
case when PART_TRAN_TYPE = 'C' then ABS(to_number(amount)) else 0 end cr_bal,
case when substr(trim(account_number),11,3) = 'LAA'  then '52000LAA' else 'LAA' END
from lat_o_table
left join all_final_trial_balance on fin_acc_num = trim(account_number)
union all
select 
to_char(trim(account_number)),
to_char(case when substr(trim(account_number),11,3) = 'LAA'  then '52000' else gl_sub_head_code end) gl_sub_head_code,
scheme_code,
to_char('LAA') scheme_type,
PART_TRAN_TYPE dr_cr_ind,
abs(to_number(amount)) amount,
'LAT1' out_file,
leg_acc_num,
to_char(scact)scact,
to_char(currency)currency_code,
to_char(service_outlet)service_outlet,
case when PART_TRAN_TYPE = 'D' then abs(to_number(amount)) else 0 end dr_bal,
case when PART_TRAN_TYPE = 'C' then abs(to_number(amount)) else 0 end cr_bal,
case when substr(trim(account_number),11,3) = 'LAA'  then '52000LAA' else 'LAA' END
from lat1_o_table
left join all_final_trial_balance on fin_acc_num = trim(account_number)
--------------------------------------CLA--------------------------------------
union all
select 
to_char(trim(acc_num)),
to_char(case when substr(trim(acc_num),11,3) = 'CLA'  then '52000' else gl_sub_headcode end) gl_sub_head_code,
schm_code,
to_char('CLA') scheme_type,
to_char(PART_TRAN_TYPE) dr_cr_ind,
abs(to_number(trans_amt)) amount,
'CLA' out_file,
'',
leg_acct_type,
to_char(curr)currency_code,
to_char(sol_id)service_outlet,
case when PART_TRAN_TYPE = 'D' then abs(to_number(trans_amt)) else 0 end dr_bal,
case when PART_TRAN_TYPE = 'C' then abs(to_number(trans_amt)) else 0 end cr_bal,
case when substr(trim(ACC_NUM),11,3) = 'CLA'  then '52000CLA' else 'CLA' END
from cl007_o_table
left join map_acc on fin_acc_num = trim(acc_num)
-----------------------TTUM1-------------------------------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM1',
'',
'',
currency_code,
substr(account_number,1,3),
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum1_o_table
------------TTUM2-------------------------------
union all
select 
trim(account_number),
--gam.gl_sub_head_code,
substr(account_number,6,5),
gam.schm_code,
gam.schm_type,
part_tran_type,
to_number(transaction_amount),
'TTUM2',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum2_o_table
left join tbaadm.gam on foracid = trim(account_number)
------------TTUM2_set2-------------------------------
union all
select 
trim(account_number),
--gam.gl_sub_head_code,
substr(account_number,6,5),
gam.schm_code,
gam.schm_type,
part_tran_type,
to_number(transaction_amount),
'TTUM2set2',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from TTUM2_O_TABLE_SET2
left join tbaadm.gam on foracid = trim(account_number)
------------TTUM3-------------------------------
union all
select 
trim(account_number),
case when substr(trim(account_number),6,5) = '52000'  then '52000' else gl_sub_head_code end gl_sub_head_code,
scheme_code,
scheme_type,
part_tran_type,
to_number(transaction_amount),
'TTUM3',
'',
'',
currency_code,
fin_sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
case when substr(trim(account_number),6,5) = '52000' then substr(trim(account_number),6,8) else scheme_type end 
from ttum3_o_table
left join all_final_trial_balance on fin_acc_num = trim(account_number)
------------TTUM4-------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM4',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum4_o_table
left join tbaadm.gam on foracid = trim(account_number)
-----------------------------TRY-----------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM4_TRY',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum4_try_o_table
left join tbaadm.gam on foracid = trim(account_number)
------------TTUM5-------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM5',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum5_o_table
left join tbaadm.gam on foracid = trim(account_number)
------------TTUM6-------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM6',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum6_o_table
left join tbaadm.gam on foracid = trim(account_number)
------------TTUM7-------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'TTUM7',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttum7_o_table
left join tbaadm.gam on foracid = trim(account_number)
------------RLTL-------------------------------
union all
select 
trim(account_number),
substr(account_number,6,5),
'',
'',
part_tran_type,
to_number(transaction_amount),
'RLTL',
'',
'',
currency_code,
gam.sol_id,
case when part_tran_type= 'D' then to_number(transaction_amount) else 0 end,
case when part_tran_type= 'C' then to_number(transaction_amount) else 0 end,
substr(account_number,6,10)
from ttumrltl_o_table
left join tbaadm.gam on foracid = trim(account_number);

commit;


 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM01_upload_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM01_upload_kw.sql 
-- File Name		: TTUM1
-- File Created for	: Upload file for sum of all ledger balance currency wise, sol wise and scheme type wise
-- Created By		: Prashant
-- Client			: ENBD
-- Created On		: 01-11-2011
-------------------------------------------------------------------
--drop table all_final_trial_balance;
--create table all_final_trial_balance as select * from final_trial_balance;
truncate table TTUM1_O_TABLE ;
insert into TTUM1_O_TABLE 
select 
--Account Number
    rpad(ttum1_migr_acct,16,' '),
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when acbal > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs(acbal),17,' '),
--Transaction Particular
    rpad('TTUM1 Migration upload',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(acbal),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from
(
select fin_sol_id,scccy,ttum1_migr_acct,sum(acbal) acbal
from
(
select a.scab,fin_sol_id,ttum1_migr_acct,scccy,(scbal+scsuma)/power(10,c8ced) acbal
from scpf a
inner join
(
select distinct scab,scan,scas,ttum1_migr_acct from all_final_trial_balance
---Every mock ensure to check one account (scab,scan,scas does not flow across multiple migr accounts. If flows them this logic of ttum1 will not work)
) b
on a.scab = b.scab and a.scan = b.scan and a.scas = b.scas
inner join c8pf on c8ccy = scccy
left join map_sol on a.scab = br_code
)
group by fin_sol_id,scccy,ttum1_migr_acct
having sum(acbal) <> 0
)X;
      COMMIT;
delete from TTUM1_O_TABLE  where trim(TRANSACTION_AMOUNT)= 0;
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM02_upload_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM02_upload_kw.sql 
-- File Name		: TTUM2
-- File Created for	: Upload file for Office accounts
-- Created By		: Prashant
-- Client		: ENBD
-- Created On		: 01-11-2011
-------------------------------------------------------------------
truncate table TTUM2_O_TABLE ;
truncate table TTUM2_O_TABLE_SET2;
insert into TTUM2_O_TABLE 
select 
--Account Number
	FIN_ACC_NUM,	
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||customer_account,30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from 
(
select  fin_sol_id,  scccy,  fin_acc_num,scbal/power(10,c8ced) acbal,case when scact='MS' then to_char(trim(neean))
else to_char('') end customer_account
from all_final_trial_balance
left join c8pf on c8ccy = scccy
left join nepf on neab||nean||neas=scab||scan||scas
where scheme_type = 'OAB' and fin_acc_num is not null and scbal <> 0
and fin_acc_num not like '%NOT%' and fin_acc_num not like '%FIN_TRES%' and length(fin_acc_num) = 13 
and scact not in ('3A','3B','3C','3D','3E','3F','3G','3H','3I','3J','3K','3L','3W','3X','3Y','3Z','4A','RL','TL','YX')
and scab||scan||scas not in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840') --As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar
and leg_acc_num not in(select leg_acc_num from tfs_sol_map_acc)
--and scan not in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
--'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230',
--'970800')---TFA sol changes GL's ignoreing in TTUM2 and passing in TTUM7 changed on 22-08-2017 by kumar 
union all
select fin_sol_id,scccy,ttum1_migr_acct, sum((scbal/power(10,c8ced)))*-1 acbal,''
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scheme_type = 'OAB' and fin_acc_num is not null and scbal <> 0 
and fin_acc_num not like '%NOT%' and fin_acc_num not like '%FIN_TRES%' and length(fin_acc_num) = 13
and scact not in ('3A','3B','3C','3D','3E','3F','3G','3H','3I','3J','3K','3L','3W','3X','3Y','3Z','4A','RL','TL','YX') 
and scab||scan||scas not in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840') --As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar
and leg_acc_num not in(select leg_acc_num from tfs_sol_map_acc)
--and scan not in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
--'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230',
--'970800')---TFA sol changes GL's ignoreing in TTUM2 and passing in TTUM7 changed on 22-08-2017 by kumar 
group by fin_sol_id,scccy,ttum1_migr_acct
)  where fin_sol_id not in('900','600','005','015','003','603');
COMMIT;
--Divdend cheques for 2013
insert into TTUM2_O_TABLE_SET2
select 
--Account Number
    '6030148100035',
--Currency Code 
    rpad(trim(CURRENCY),3,' '),
--SOLID
    rpad('603',8,' '),
--Part Tran Type
    PART_TRAN_TYPE,
--Transaction Amount
    lpad(AMOUNT,17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||CHQ_NO,30,' '),
    rpad(' ',5,' '),
    rpad(CHQ_NO,20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(AMOUNT,17,' '),
    rpad(trim(CURRENCY),3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(CHQ_NO,16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from kcc_chq_2013;
commit;
--Divdend cheques for 2014
insert into TTUM2_O_TABLE_SET2
select 
--Account Number
    '6030148100036',
--Currency Code 
    rpad(trim(CURRENCY),3,' '),
--SOLID
    rpad('603',8,' '),
--Part Tran Type
    PART_TRAN_TYPE,
--Transaction Amount
    lpad(AMOUNT,17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||CHQ_NO,30,' '),
    rpad(' ',5,' '),
    rpad(CHQ_NO,20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(AMOUNT,17,' '),
    rpad(trim(CURRENCY),3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(CHQ_NO,16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from kcc_chq_2014;
commit;
--Divdend cheques for 2015
insert into TTUM2_O_TABLE_SET2
select 
--Account Number
    '6030148100037',
--Currency Code 
    rpad(trim(CURRENCY),3,' '),
--SOLID
    rpad('603',8,' '),
--Part Tran Type
    PART_TRAN_TYPE,
--Transaction Amount
    lpad(AMOUNT,17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||CHQ_NO,30,' '),
    rpad(' ',5,' '),
    rpad(CHQ_NO,20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(AMOUNT,17,' '),
    rpad(trim(CURRENCY),3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(CHQ_NO,16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from kcc_chq_2015;
commit;
--Divdend cheques for 2016
insert into TTUM2_O_TABLE_SET2
select 
--Account Number
    '6030148100038',
--Currency Code 
    rpad(trim(CURRENCY),3,' '),
--SOLID
    rpad('603',8,' '),
--Part Tran Type
    PART_TRAN_TYPE,
--Transaction Amount
    lpad(AMOUNT,17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||CHQ_NO,30,' '),
    rpad(' ',5,' '),
    rpad(CHQ_NO,20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(AMOUNT,17,' '),
    rpad(trim(CURRENCY),3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(CHQ_NO,16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from kcc_chq_2016;
commit;
insert into TTUM2_O_TABLE_SET2 
select 
--Account Number
	--case when trim(CURRENCY)='KWD' then '9000148602000'
	--when trim(CURRENCY)='USD' then '9000448602000' end,--As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar
	case when trim(CURRENCY)='KWD' then '9000148602001'
	when trim(CURRENCY)='USD' then '9000448602001' end,
--Currency Code 
    rpad(trim(CURRENCY),3,' '),
--SOLID
    rpad('900',8,' '),
--Part Tran Type
    case when (AMOUNT) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(regexp_replace(abs(AMOUNT),'[,]',''),17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||CHEQUE_NO,30,' '),
    rpad(' ',5,' '),
    rpad(CHEQUE_NO,20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(regexp_replace(abs(AMOUNT),'[,]',''),17,' '),
    rpad(trim(currency),3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(CHEQUE_NO,16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from certified_cheques;
commit;
insert into TTUM2_O_TABLE_SET2 
select 
--Account Number
	FIN_ACC_NUM,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM2 Migration-'||customer_account,30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from 
(
select  fin_sol_id,  scccy,  fin_acc_num,scbal/power(10,c8ced) acbal,case when scact='MS' then to_char(trim(neean))
else to_char('') end customer_account
from all_final_trial_balance
left join c8pf on c8ccy = scccy
left join nepf on neab||nean||neas=scab||scan||scas
where scheme_type = 'OAB' and fin_acc_num is not null and scbal <> 0
and fin_acc_num not like '%NOT%' and fin_acc_num not like '%FIN_TRES%' and length(fin_acc_num) = 13 
and scact not in ('3A','3B','3C','3D','3E','3F','3G','3H','3I','3J','3K','3L','3W','3X','3Y','3Z','4A','RL','TL','YX') 
and scab||scan||scas not in ('0900802525414','0900802525840')
and scab||scan||scas not in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840') --As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar
and scab||scan||scas not in('0600802616414','0600802617414','0600802618414','0600802619414')--DIVIDEND cheques execlude changed on 29-09-2017
and leg_acc_num not in(select leg_acc_num from tfs_sol_map_acc)
--and scan not in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
--'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230',
--'970800')---TFA sol changes GL's ignoreing in TTUM2 and passing in TTUM7 changed on 22-08-2017 by kumar 
union all
select fin_sol_id,scccy,ttum1_migr_acct, sum((scbal/power(10,c8ced)))*-1 acbal,''
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scheme_type = 'OAB' and fin_acc_num is not null and scbal <> 0 
and fin_acc_num not like '%NOT%' and fin_acc_num not like '%FIN_TRES%' and length(fin_acc_num) = 13
and scact not in ('3A','3B','3C','3D','3E','3F','3G','3H','3I','3J','3K','3L','3W','3X','3Y','3Z','4A','RL','TL','YX')
and scab||scan||scas not in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840') --As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar 
and leg_acc_num not in(select leg_acc_num from tfs_sol_map_acc)
--and scan not in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
--'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230',
--'970800')---TFA sol changes GL's ignoreing in TTUM2 and passing in TTUM7 changed on 22-08-2017 by kumar 
group by fin_sol_id,scccy,ttum1_migr_acct
)  where fin_sol_id  in('900','600','005','015','003','603');
commit;
delete from TTUM2_O_TABLE  where trim(TRANSACTION_AMOUNT)= 0;
commit;
delete from TTUM2_O_TABLE_SET2 where trim(TRANSACTION_AMOUNT)= 0;
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM03_upload_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM03_upload_kw.sql 
-- File Name         : TTUM3
-- File Created for  : Upload file for Office accounts
-- Created By        : Kumaresan.B
-- Client            : EIB
-- Created On        : 13-08-2015
-------------------------------------------------------------------
drop table future_tran;
create table future_tran as (
select saab,saan,saas,c8ccy,saama/power(10,c8ced) saama,sanegp,savfr,new_FIN_SOL_ID FIN_SOL_ID,fin_acc_num,TTUM1_MIGR_ACCT from 
scpf
inner join sapf on scpf.scab = saab and scpf.scan = saan and scpf.scas = saas 
inner join (select * from all_final_trial_balance where scheme_type in ('SBA','CAA','ODA'))a on scpf.scab = a.scab and scpf.scan = a.scan and scpf.scas =  a.scas
inner join c8pf on c8ccy =  saccy 
where savfr > get_param('EODCYYMMDD') 
and (to_number(scpf.scsum1) + to_number(scpf.scsum2)) <> 0);
-- delete for more than 999 days future transaction date --
delete  future_tran where to_date(get_date_fm_btrv(savfr),'YYYYMMDD')>to_date('2020','YYYY');
commit;
truncate table TTUM3_O_TABLE ;
insert into TTUM3_O_TABLE 
select 
--Account Number
    rpad(FIN_ACC_NUM,16,' '),
--Currency Code 	
	rpad(c8ccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when to_number(saama) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs(to_number(saama)),17,' '),
--Transaction Particular
    rpad('TTUM3 Migration- '||to_char(saab)||to_char(saan)||trim(saas)||trim(c8ccy),30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((saama)),17,' '),
    rpad(c8ccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(to_char(to_date(get_date_fm_btrv(savfr),'YYYYMMDD'),'DD-MM-YYYY'),10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from future_tran ;
commit;
insert into TTUM3_O_TABLE
--union for OABMIGR account
select 
--Account Number
    rpad(TTUM1_MIGR_ACCT,16,' '),
--Currency Code 
    rpad(c8ccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when to_number(saama) > 0 then 'D'
         else 'C'
    end,
--Transaction Amount
    lpad(abs(to_number(saama)),17,' '),
--Transaction Particular
    rpad('TTUM3 Migration Contra' ,30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((saama)),17,' '),
    rpad(c8ccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from future_tran;
COMMIT;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM04_try_upload_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM04_try_upload_kw.sql 


--SELECT SCACT,SCCCY,SUM(SCBAL/C8PWD) FROM SCPF 
--LEFT JOIN C8PF ON C8CCY = SCCCY
--WHERE SCACT IN('D1','F1','M1','M2','F2','R4','V2','V1','V4','V3','OS','S8','W7','S7','W8','W1','W2','W4','W3')
--AND SCBAL <>0 GROUP BY SCACT,SCCCY

--SELECT ACCOUNT_NUMBER,CURRENCY_CODE,PART_TRAN_TYPE,CASE WHEN PART_TRAN_TYPE='C' THEN '-1' ELSE '1' END*SUM(TRANSACTION_AMOUNT) TRANSACTION_AMOUNT FROM TTUM4_TRY1_O_TABLE WHERE REGEXP_LIKE(ACCOUNT_NUMBER ,'[A-Z]') GROUP BY ACCOUNT_NUMBER,CURRENCY_CODE,PART_TRAN_TYPE


--select PRODUCT_TYPE,a.INDICATOR,CCY,sum(FCY_AMOUNT) FCY_AMOUNT ,EQU_ACCT_TYPE,CONTINGENT_LIABILITY_BACID,CONTINGENT_ASSET_BACID from TREASURY_OPEN_DEALS a
--left join treasury_product_mapping b  on trim(a.PRODUCT_TYPE) = trim(b.DEPT_NAME) and trim(a.SUBTYPE) = trim(b.SUBTYPE) and trim(a.INDICATOR) = trim(b.INDICATOR)
--group by PRODUCT_TYPE,a.INDICATOR,CCY,EQU_ACCT_TYPE,CONTINGENT_LIABILITY_BACID,CONTINGENT_ASSET_BACID


TRUNCATE TABLE ttum_excel_TREASURY;

--MM AND FX DEAL

INSERT INTO ttum_excel_TREASURY
SELECT '005'||CRNCY_ALIAS_NUM||TOD.CONTINGENT_ASSET_BACID ACCOUNT,CCY,'005' SOL_ID,'D' INDICATOR,ABS(FCY_AMOUNT) AMOUNT,'TREASURY DEAL BAL - '||TRIM(DEAL_IDENTIFIER) PERTICULARS, DEAL_IDENTIFIER
FROM (select PRODUCT_TYPE,DEAL_IDENTIFIER,a.INDICATOR,CCY, FCY_AMOUNT ,EQU_ACCT_TYPE,CONTINGENT_ASSET_BACID from TREASURY_OPEN_DEALS a
left join treasury_product_mapping b  on trim(a.PRODUCT_TYPE) = trim(b.DEPT_NAME) and trim(a.SUBTYPE) = trim(b.SUBTYPE) and trim(a.INDICATOR) = trim(b.INDICATOR)
) TOD 
LEFT JOIN TBAADM.CNC C ON CRNCY_CODE=CCY  AND BANK_ID='01'
WHERE CONTINGENT_ASSET_BACID IS NOT NULL and (PRODUCT_TYPE not in('MM','ISLAMIC') or EQU_ACCT_TYPE  IN('R3','R4','R1'))
UNION ALL
SELECT '005'||CRNCY_ALIAS_NUM||TOD.CONTINGENT_ASSET_CONTRA_BACID ACCOUNT,CCY,'005' SOL_ID,'C' INDICATOR,ABS(FCY_AMOUNT) AMOUNT,'TREASURY DEAL BAL - '||TRIM(DEAL_IDENTIFIER) PERTICULARS, DEAL_IDENTIFIER
FROM (select PRODUCT_TYPE,DEAL_IDENTIFIER,a.INDICATOR,CCY, FCY_AMOUNT ,EQU_ACCT_TYPE,CONTINGENT_ASSET_CONTRA_BACID from TREASURY_OPEN_DEALS a
left join treasury_product_mapping b  on trim(a.PRODUCT_TYPE) = trim(b.DEPT_NAME) and trim(a.SUBTYPE) = trim(b.SUBTYPE) and trim(a.INDICATOR) = trim(b.INDICATOR)
) TOD 
LEFT JOIN TBAADM.CNC C ON CRNCY_CODE=CCY  AND BANK_ID='01'
WHERE CONTINGENT_ASSET_CONTRA_BACID IS NOT NULL and (PRODUCT_TYPE not in('MM','ISLAMIC') or EQU_ACCT_TYPE IN('R3','R4','R1'))
UNION ALL
SELECT '005'||CRNCY_ALIAS_NUM||TOD.CONTINGENT_LIABILITY_BACID ACCOUNT,CCY,'005' SOL_ID,'C' INDICATOR,ABS(FCY_AMOUNT) AMOUNT,'TREASURY DEAL BAL - '||TRIM(DEAL_IDENTIFIER) PERTICULARS, DEAL_IDENTIFIER
FROM (select PRODUCT_TYPE,DEAL_IDENTIFIER,a.INDICATOR,CCY, FCY_AMOUNT ,EQU_ACCT_TYPE,CONTINGENT_LIABILITY_BACID from TREASURY_OPEN_DEALS a
left join treasury_product_mapping b  on trim(a.PRODUCT_TYPE) = trim(b.DEPT_NAME) and trim(a.SUBTYPE) = trim(b.SUBTYPE) and trim(a.INDICATOR) = trim(b.INDICATOR)
) TOD 
LEFT JOIN TBAADM.CNC C ON CRNCY_CODE=CCY  AND BANK_ID='01'
WHERE CONTINGENT_LIABILITY_BACID IS NOT NULL and (PRODUCT_TYPE not in('MM','ISLAMIC') or EQU_ACCT_TYPE IN('R3','R4','R1'))
UNION ALL
SELECT '005'||CRNCY_ALIAS_NUM||TOD.CONTG_LIABILITY_CONTRA_BACID ACCOUNT,CCY,'005' SOL_ID,'D' INDICATOR,ABS(FCY_AMOUNT) AMOUNT,'TREASURY DEAL BAL - '||TRIM(DEAL_IDENTIFIER) PERTICULARS, DEAL_IDENTIFIER
FROM (select PRODUCT_TYPE,DEAL_IDENTIFIER,a.INDICATOR,CCY, FCY_AMOUNT ,EQU_ACCT_TYPE,CONTG_LIABILITY_CONTRA_BACID from TREASURY_OPEN_DEALS a
left join treasury_product_mapping b  on trim(a.PRODUCT_TYPE) = trim(b.DEPT_NAME) and trim(a.SUBTYPE) = trim(b.SUBTYPE) and trim(a.INDICATOR) = trim(b.INDICATOR)
) TOD 
LEFT JOIN TBAADM.CNC C ON CRNCY_CODE=CCY  AND BANK_ID='01'
WHERE CONTG_LIABILITY_CONTRA_BACID IS NOT NULL and (PRODUCT_TYPE not in('MM','ISLAMIC') or EQU_ACCT_TYPE IN('R3','R4','R1'))
UNION ALL
SELECT '005'||CRNCY_ALIAS_NUM||TOD.BORROWING_BACID ACCOUNT,CCY,'005' SOL_ID,'C' INDICATOR,ABS(FCY_AMOUNT) AMOUNT,'TREASURY DEAL BAL - '||TRIM(DEAL_IDENTIFIER) PERTICULARS, DEAL_IDENTIFIER
FROM (select PRODUCT_TYPE,DEAL_IDENTIFIER,a.INDICATOR,CCY,FCY_AMOUNT ,EQU_ACCT_TYPE,BORROWING_BACID from TREASURY_OPEN_DEALS a
left join treasury_product_mapping b  on trim(a.PRODUCT_TYPE) = trim(b.DEPT_NAME) and trim(a.SUBTYPE) = trim(b.SUBTYPE) and trim(a.INDICATOR) = trim(b.INDICATOR)
) TOD 
LEFT JOIN TBAADM.CNC C ON CRNCY_CODE=CCY  AND BANK_ID='01'
WHERE BORROWING_BACID IS NOT NULL and EQU_ACCT_TYPE NOT  IN('R3','R4','R1')
UNION ALL
SELECT '005'||CRNCY_ALIAS_NUM||TOD.PLACEMENT_BACID ACCOUNT,CCY,'005' SOL_ID,'D' INDICATOR,ABS(FCY_AMOUNT) AMOUNT,'TREASURY DEAL BAL - '||TRIM(DEAL_IDENTIFIER) PERTICULARS, DEAL_IDENTIFIER
FROM (select PRODUCT_TYPE,DEAL_IDENTIFIER,a.INDICATOR,CCY, FCY_AMOUNT ,EQU_ACCT_TYPE,PLACEMENT_BACID from TREASURY_OPEN_DEALS a
left join treasury_product_mapping b  on trim(a.PRODUCT_TYPE) = trim(b.DEPT_NAME) and trim(a.SUBTYPE) = trim(b.SUBTYPE) and trim(a.INDICATOR) = trim(b.INDICATOR)
) TOD 
LEFT JOIN TBAADM.CNC C ON CRNCY_CODE=CCY  AND BANK_ID='01'
WHERE PLACEMENT_BACID IS NOT NULL and EQU_ACCT_TYPE NOT  IN('R3','R4','R1')
UNION ALL
SELECT CASE WHEN TRIM(SCACT)='VC' THEN '900' ELSE '005' END||CRNCY_ALIAS_NUM||'520000'||to_char(TRIM(SCACT)) ACCOUNT,to_char(TRIM(SCCCY)) SCCCY,CASE WHEN TRIM(SCACT)='VC' THEN '900' ELSE '005' END SOL_ID,CASE WHEN SCBAL < 0 THEN 'C' ELSE 'D' END INDICATOR,ABS(SCBAL/C8PWD) AMOUNT,'TREASURY MIGRA BALANCE','' FROM SCPF
LEFT JOIN C8PF ON C8CCY = SCCCY
LEFT JOIN TBAADM.CNC C ON CRNCY_CODE=TRIM(SCCCY)  AND BANK_ID='01'
WHERE (SCACT IN('R1','R3','R4','T1','T2','V1','V2','V5','V3','V4','V6','VC','W1','W2','W3','W4','W5','W6','S7','S8','S9','D1','F1','F2','M1','M2','V7') OR SCAB||SCAN||SCAS='0781800225414') AND SCBAL <> 0;


COMMIT;

----CHANGE FINACLE ACCOUNT NUMBER FOR INTERBANK PLACEMENT OPICS
--UPDATE ttum_excel_TREASURY A SET ACCOUNT =( SELECT NEW_ACCOUNT FROM(
--SELECT DEAL_IDENTIFIER,ACCOUNT,SUBSTR(TRIM(ACCOUNT),1,5)||'10401000' NEW_ACCOUNT FROM ttum_excel_TREASURY WHERE TRIM(DEAL_IDENTIFIER) IN(
--SELECT TRIM(DEAL_IDENTIFIER) FROM COM_LOAN_O_TABLE WHERE DEPT_NAME='MM' AND SUBTYPE='BANK' AND SIDE_SIDE_ONE_LONG_OR_SHORT='LONG' AND COUNTERPARTY_STRING='CENTRALKWT'
--)
--) B WHERE TRIM(A.DEAL_IDENTIFIER) = TRIM(B.DEAL_IDENTIFIER)
--) WHERE TRIM(A.DEAL_IDENTIFIER) IN(
--SELECT TRIM(DEAL_IDENTIFIER) FROM COM_LOAN_O_TABLE WHERE DEPT_NAME='MM' AND SUBTYPE='BANK' AND SIDE_SIDE_ONE_LONG_OR_SHORT='LONG' AND COUNTERPARTY_STRING='CENTRALKWT'
--);

COMMIT;

--INVESTMENT DEAL

INSERT INTO ttum_excel_TREASURY
SELECT '005'||CRNCY_ALIAS_NUM||ON_BOOK_BACID ACCOUNT, ISSUE_CCY CCY, '005' SOL_ID, CASE WHEN AMOUNT <0 THEN 'D' ELSE 'C' END INDICATOR, ROUND(ABS(AMOUNT),C8CED)AMOUNT,TO_CHAR('TREASURY INV BAL - '||DEAL_IDENTIFIER) PERTICULARS,DEAL_IDENTIFIER FROM (
SELECT DEAL_IDENTIFIER,ON_BOOK_BACID,ISSUE_CCY,AMOUNT AMOUNT FROM (
select DEAL_IDENTIFIER,INSTRUMENT_CLASS_DATA_NAME,SUBTYPE,BUY_OR_SELL,ISSUE_CCY,CASE WHEN BUY_OR_SELL='SELL' THEN 1 ELSE -1 END*QTY QTY,CASE WHEN substr(TRIM(NAME),1,3) IN('CBK','KTB') THEN 1 ELSE  BID END  BID,CASE WHEN BUY_OR_SELL='SELL' THEN 1 ELSE -1 END*QTY*CASE WHEN substr(TRIM(NAME),1,3) IN('CBK','KTB') THEN 1 ELSE  BID END  AMOUNT from SEC_BUY_SELL_O_TABLE a
left join SECURITY_DEFN_O_TABLE b on trim(b.NAME) = trim(a.SEC_DEFN_NAME)
left join spsh on trim(dealno) = trim(DEAL_IDENTIFIER)
left join SECURITY_PRICES_O_TABLE c on trim(a.SEC_DEFN_NAME) = trim(c.SECURITY)
WHERE TRIM(B.NAME) NOT IN(SELECT TRIM(SECID) FROM ttum_excel_TREASURY_deal)
UNION
select DEAL_IDENTIFIER,INSTRUMENT_CLASS_DATA_NAME,SUBTYPE,BUY_OR_SELL,ISSUE_CCY,CASE WHEN BUY_OR_SELL='SELL' THEN 1 ELSE -1 END*nvl(QTY_TRADED,round(SETTLEMENT/PRICE_STRING,2)) QTY,price,CASE WHEN BUY_OR_SELL='SELL' THEN 1 ELSE -1 END*nvl(QTY_TRADED,round(SETTLEMENT/PRICE_STRING,2))*price AMOUNT from EQUITY_MF_O_TABLE a
left join EQUITY_DEFN_O_TABLE b on trim(b.NAME) = trim(a.EQUITY_MF_DEFN_NAME)
left join EQUITY_PRICES_O_TABLE c on trim(a.EQUITY_MF_DEFN_NAME) = trim(c.SECURITY)
) A
LEFT JOIN TREASURY_INV_PRODUCT_MAPPING B ON TRIM(INSTRUMENT_CLASS_DATA_NAME) = TRIM(INSTRUMENT_CLASS) AND TRIM(A.SUBTYPE) = TRIM(B.SUBTYPE) AND TRIM(BUY_OR_SELL) = TRIM(INDICATOR)
WHERE ON_BOOK_BACID LIKE '151%'
)
LEFT JOIN TBAADM.CNC C ON CRNCY_CODE=TRIM(ISSUE_CCY)  AND BANK_ID='01'
LEFT JOIN C8PF ON C8CCY = CRNCY_CODE
UNION 
SELECT TO_CHAR(CASE WHEN TRIM(SCACT)='VC' THEN '900' ELSE '005' END||CRNCY_ALIAS_NUM||'520000'||(TRIM(SCACT))) ACCOUNT,(TRIM(SCCCY)) SCCCY,'005' SOL_ID,CASE WHEN SCBAL < 0 THEN 'C' ELSE 'D' END INDICATOR,ABS(SCBAL/C8PWD) AMOUNT,'TREASURY INVEST MIG BALANCE',N'' FROM SCPF
LEFT JOIN C8PF ON C8CCY = SCCCY
LEFT JOIN TBAADM.CNC C ON CRNCY_CODE=TRIM(SCCCY)  AND BANK_ID='01'
WHERE SCACT IN('3A','3D','3G','3K','3W','3X','3Y','3Z','4A','4D') AND SCBAL <> 0;

COMMIT;

--UPDATE TTUM_EXCEL_TREASURY_INV SET AMOUNT = AMOUNT- 0.029 WHERE  TRIM(PERTICULARS)='TREASURY INV BAL - 4440016';

--commit;

INSERT INTO ttum_excel_TREASURY
SELECT ACCOUNT, CCY, SOL_ID, INDICATOR, ROUND(ABS(AMOUNT),C8CED), 'TRY INV - '||trim(SECID), trim(SECID) DEAL_IDENTIFIER FROM ttum_excel_TREASURY_deal
LEFT JOIN C8PF ON C8CCY=CCY 
;

--FVR MANUAL DATA

INSERT INTO ttum_excel_TREASURY
SELECT ACCOUNT, CCY, SOL_ID, INDICATOR, AMOUNT, PERTICULARS, '' DEAL_IDENTIFIER FROM ttum_excel_TREASURY_FVR
UNION 
SELECT '005'||CRNCY_ALIAS_NUM||'520000'||(TRIM(SCACT)) ACCOUNT,(TRIM(SCCCY)) SCCCY,TO_NCHAR('005') SOL_ID,TO_NCHAR(CASE WHEN SCBAL < 0 THEN 'C' ELSE 'D' END) INDICATOR,TO_NCHAR(ABS(SCBAL/C8PWD)) AMOUNT,TO_NCHAR('TREASURY INVEST MIG BALANCE'),'' FROM SCPF
LEFT JOIN C8PF ON C8CCY = SCCCY
LEFT JOIN TBAADM.CNC C ON CRNCY_CODE=TRIM(SCCCY)  AND BANK_ID='01'
WHERE SCACT IN('YM','TY') AND SCBAL <> 0
AND TRIM(SCAN) IN('804225','804250','804930','804935','804950','804955','804960','804965');

COMMIT;

update ttum_excel_TREASURY set ACCOUNT='0050110201000' where trim(DEAL_IDENTIFIER) like '%3019801%';
 --0050110200000

truncate table ttum4_try_o_table;

insert into ttum4_try_o_table
select 
--Account Number
    rpad(ACCOUNT,16,' '),
--Currency Code     
    rpad(ccy,3,' '),
--SOLID
    rpad(SOL_ID,8,' '),
--Part Tran Type
    INDICATOR,
--Transaction Amount
    lpad(abs(AMOUNT),17,' '),
--Transaction Particular
    rpad(PERTICULARS,30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(AMOUNT),17,' '),
    rpad(ccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(get_param('EOD_DATE'),10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from ttum_excel_TREASURY;

commit;

delete TTUM4_TRY_O_TABLE where TRANSACTION_AMOUNT=0;

COMMIT;
exit;


--validation
--select* from (select substr(trim(ACCOUNT_NUMBER),6,5) GLSH,CURRENCY_CODE,PART_TRAN_TYPE,sum(TRANSACTION_AMOUNT) TRANSACTION_AMOUNT from TTUM4_TRY_O_TABLE where TRANSACTION_PARTICULAR not like '%MIGR%' group by substr(trim(ACCOUNT_NUMBER),6,5),CURRENCY_CODE,PART_TRAN_TYPE)
--left join (select GL_SUB_HEADCODE,CURRENCY,CREDIT_DEBIT_INDICATOR,sum(abs(BALANCE))  BALANCE from PREMOCK_TREASURY_RECON  group by GL_SUB_HEADCODE,CURRENCY,CREDIT_DEBIT_INDICATOR) on  GL_SUB_HEADCODE = GLSH and CURRENCY_CODE = CURRENCY
--and CREDIT_DEBIT_INDICATOR = PART_TRAN_TYPE 


--SELECT SUBSTR(ACCOUNT,6,5),CCY,SUM(CASE WHEN INDICATOR='D' THEN  -1*AMOUNT ELSE TO_NUMBER(AMOUNT) END) AMOUNT FROM ttum_excel_TREASURY WHERE NOT REGEXP_LIKE(ACCOUNT,'[A-Z]') GROUP BY SUBSTR(ACCOUNT,6,5),CCY HAVING 
--SUM(CASE WHEN INDICATOR='D' THEN  -1*AMOUNT ELSE TO_NUMBER(AMOUNT) END) <> 0
--
--
--SELECT GL_SUB_HEADCODE,CURRENCY,SUM(BALANCE) FROM PREMOCK_TREASURY_RECON where NVL(trim(scact),' ') not in('NL','NT','OT') GROUP BY GL_SUB_HEADCODE,CURRENCY HAVING SUM(BALANCE) <> 0
--

--select* from (select substr(trim(ACCOUNT_NUMBER),6)  bacid,CURRENCY_CODE,sum(case when PART_TRAN_TYPE='D' then -1*TRANSACTION_AMOUNT else 1*TRANSACTION_AMOUNT end) TRANSACTION_AMOUNT from TTUM4_TRY_O_TABLE group by substr(trim(ACCOUNT_NUMBER),6),CURRENCY_CODE) ttum
--left join (select bacid,acct_crncy_code,sum(clr_bal_amt) from tbaadm.gam where bank_id='01' group by bacid,acct_crncy_code) gam on  gam.bacid = ttum.bacid and acct_crncy_code = CURRENCY_CODE 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM05_upload_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM05_upload_kw.sql 
-- File Name           : TTUM5
-- File Created for    : Upload file for Office accounts
-- Created By          : Kumaresan.B
-- Client               : EIB
-- Created On          : 19-01-2015
-------------------------------------------------------------------
---interest receivable/Payable customer accounts Same sol added on 04-06-2017 by kumar
drop table int_recv_pay_balance_trfr;
create table int_recv_pay_balance_trfr
as
SELECT 
s5ab,contra_basic,c8ccyn,S5ACT, INTEREST_FCY,b.leg_acc_num,b.scheme_code,b.scheme_type, int_paid_bacid,int_coll_bacid,int_pandl_bacid_cr,int_pandl_bacid_dr 
FROM ACCT_WISE_INT_RECV_PAY_MAP a
inner join (select * from all_final_trial_balance where fin_sol_id=new_fin_sol_id)b on b.leg_acc_num = BRN||TRIM(a.DEAL_TYPE)||TRIM(a.DEAL_REF)
left join (select schm_code,int_paid_bacid,int_coll_bacid,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss 
on gss.schm_code = b.scheme_code
where INTEREST_FCY <> 0; 
---interest receivable/Payable customer accounts difference sol added on 04-06-2017 by kumar
drop table int_recv_pay_bal_trfr_dif_sol;
create table int_recv_pay_bal_trfr_dif_sol
as
SELECT 
s5ab,contra_basic,c8ccyn,S5ACT, INTEREST_FCY,b.leg_acc_num,b.scheme_code,b.scheme_type, int_paid_bacid,int_coll_bacid,int_pandl_bacid_cr,int_pandl_bacid_dr 
FROM ACCT_WISE_INT_RECV_PAY_MAP a
inner join (select * from all_final_trial_balance where fin_sol_id<>new_fin_sol_id)b on b.leg_acc_num = BRN||TRIM(a.DEAL_TYPE)||TRIM(a.DEAL_REF)
left join (select schm_code,int_paid_bacid,int_coll_bacid,int_pandl_bacid_cr,int_pandl_bacid_dr from tbaadm.gsp where bank_id = '01' and del_flg = 'N')gss 
on gss.schm_code = b.scheme_code
where INTEREST_FCY <> 0; 
---interest receivable/Payable account where int miss match customer accounts same sol added on 04-06-2017 by kumar
drop table account_where_int_match;
create table account_where_int_match
as
select scab brn,scan basic,scas suf,scbal/power(10,c8ced)bal,interest from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
left join
(
select s5ab,contra_basic,c8ccyn,sum(interest_fcy)interest from int_recv_pay_balance_trfr
group by s5ab,contra_basic,c8ccyn
)b
on scab||scan||scas = s5ab||contra_basic||c8ccyn
inner join c8pf on c8ccy = scccy;
---interest receivable/Payable account where int miss match customer accounts difference sol added on 04-06-2017 by kumar
drop table acct_where_int_match_dif_sol;
create table acct_where_int_match_dif_sol
as
select scab brn,scan basic,scas suf,scbal/power(10,c8ced)bal,interest from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
left join
(
select s5ab,contra_basic,c8ccyn,sum(interest_fcy)interest from int_recv_pay_bal_trfr_dif_sol
group by s5ab,contra_basic,c8ccyn
)b
on scab||scan||scas = s5ab||contra_basic||c8ccyn
inner join c8pf on c8ccy = scccy;
-----------------------------interest_payable_diff  customer accounts same sol added on 04-06-2017 by kumar-----------------------------------
drop table interest_payable_diff;
create table interest_payable_diff as
select scab,scan,scas,ttum1_migr_acct,scsuma/power(10,c8ced)scsuma,nvl(interest,0)interest, scbal/power(10,c8ced) scbal, (scbal+scsuma)/power(10,c8ced) -nvl(interest,0) diff_amount,
fin_sol_id||CRNCY_ALIAS_NUM||'29398000' fin_acc_num,scccy,fin_sol_id
from scpf a
inner join
(select scab brn,scan basic,scas suf,scbal/power(10,c8ced)bal,interest,ttum1_migr_acct,fin_sol_id,CRNCY_ALIAS_NUM from
(
select * from all_final_trial_balance 
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
left join
(
select s5ab,contra_basic,c8ccyn,sum(interest_fcy)interest from int_recv_pay_balance_trfr
group by s5ab,contra_basic,c8ccyn
)b
on scab||scan||scas = s5ab||contra_basic||c8ccyn
inner join c8pf on c8ccy = scccy
where scbal/power(10,c8ced) <> nvl(interest,0)
)b
on brn||basic||suf = scab||scan||scas
inner join c8pf on c8ccy = scccy
where a.scbal <> 0 and nvl(interest,0) = scsuma/power(10,c8ced);
--where scbal/power(10,c8ced) = nvl(interest,0);  --- as per analysis interest receivable/payable from scsuma migrated and scbal balance(ie. Creadited in P&L) not migrated. As per Karthik sir confirmation commented on 10-04-2017.
-----------------------------interest_payable_diff_sol_dif  customer accounts difference sol added on 04-06-2017 by kumar-----------------------------------
drop table interest_payable_diff_sol_dif;
create table interest_payable_diff_sol_dif as
select scab,scan,scas,ttum1_migr_acct,scsuma/power(10,c8ced)scsuma,nvl(interest,0)interest, scbal/power(10,c8ced) scbal, (scbal+scsuma)/power(10,c8ced) -nvl(interest,0) diff_amount,
fin_sol_id||CRNCY_ALIAS_NUM||'29398000' fin_acc_num,scccy,fin_sol_id
from scpf a
inner join
(select scab brn,scan basic,scas suf,scbal/power(10,c8ced)bal,interest,ttum1_migr_acct,fin_sol_id,CRNCY_ALIAS_NUM from
(
select * from all_final_trial_balance 
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
left join
(
select s5ab,contra_basic,c8ccyn,sum(interest_fcy)interest from int_recv_pay_bal_trfr_dif_sol
group by s5ab,contra_basic,c8ccyn
)b
on scab||scan||scas = s5ab||contra_basic||c8ccyn
inner join c8pf on c8ccy = scccy
where scbal/power(10,c8ced) <> nvl(interest,0)
)b
on brn||basic||suf = scab||scan||scas
inner join c8pf on c8ccy = scccy
where a.scbal <> 0 and nvl(interest,0) = scsuma/power(10,c8ced);
--where scbal/power(10,c8ced) = nvl(interest,0);  --- as per analysis interest receivable/payable from scsuma migrated and scbal balance(ie. Creadited in P&L) not migrated. As per Karthik sir confirmation commented on 10-04-2017.
-----------------------------interest_payable  customer accounts same sol added on 04-06-2017 by kumar-----------------------------------
truncate table TTUM5_O_TABLE ;
insert into TTUM5_O_TABLE 
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(MAP_SOL.FIN_SOL_ID,8,' '),----------changed for m4   
   --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'D'
         else 'C'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((INTEREST_FCY)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_balance_trfr group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_balance_trfr on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join account_where_int_match on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL;
COMMIT;
-----------------------------interest_payable  customer accounts difference sol added on 04-06-2017 by kumar-----------------------------------
insert into TTUM5_O_TABLE
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(map_sol.fin_sol_id,8,' '),----------changed for m4   
   --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'D'
         else 'C'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((INTEREST_FCY)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL;
commit;
-----------------------------interest_payable  customer accounts same sol added on 04-06-2017 by kumar-----------------------------------
insert into TTUM5_O_TABLE 
select 
--Account Number
TO_CHAR (
MAP_SOL.FIN_SOL_ID 
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
)IR_IP_ACCT,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(MAP_SOL.FIN_SOL_ID,8,' '),----changed for mock4kw
    --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((INTEREST_FCY)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_balance_trfr group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_balance_trfr on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join account_where_int_match on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL;
COMMIT;
-----------------------------interest_payable  customer accounts difference sol added on 04-06-2017 by kumar-----------------------------------
insert into TTUM5_O_TABLE 
select 
--Account Number
TO_CHAR (
'603'
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
)IR_IP_ACCT,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    --rpad(map_sol.fin_sol_id,8,' '),
	rpad('603',8,' '),
    --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((INTEREST_FCY)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL;
commit;
/*--------Interest receivable/Payable Difference -------------------------------- commented on 17-04-2017 as per mock 3b observation. difference between scbal+scsuma-interest block
insert into TTUM5_O_TABLE 
select 
--Account Number
    fin_acc_num,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when (diff_amount) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((diff_amount)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR DIFFERENCE ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((diff_amount)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from interest_payable_diff;
commit;
--------Interest receivable/Payable Difference Contra Entry--------------------------------
insert into TTUM5_O_TABLE 
select 
--Account Number
    TTUM1_MIGR_ACCT,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when (diff_amount) > 0 then 'D'
         else 'C'
    end,
--Transaction Amount
    lpad(abs((diff_amount)),17,' '),
--Transaction Particular
    rpad('INT RECV PAY DR CR DIFFERENCE ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((diff_amount)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from interest_payable_diff;
commit;*/
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM06_upload_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM06_upload_kw.sql 
-- File Name           : TTUM7_upload.sql
-- File Created for    : Upload file for YP split 
-- Created By          : R.Alavudeen Ali Badusha
-- Client              : ABK
-- Created On          : 13-04-2017
-------------------------------------------------------------------
truncate table TTUM6_O_TABLE ;
insert into TTUM6_O_TABLE 
select 
--Account Number
rpad(SUBSTR(FIN_ACC_NUM,1,5)||TO_CHAR(Finacle_PLC),16,' '),
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(FIN_SOL_ID,8,' '),----------changed for m4   
--Part Tran Type
    CASE WHEN SCBAL <0 THEN 'D' ELSE 'C' END,
--Transaction Amount
    lpad(abs(SCBAL)/POWER(10,C8CED),17,' '),
--Transaction Particular
    rpad('YP SPLIT DR CR ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(SCBAL)/POWER(10,C8CED),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
FROM
(
select * from all_final_trial_balance where scact = 'YP' and substr(fin_acc_num,6,8) like '52000%' AND SCBAL <> 0
 )A
LEFT JOIN YP_MAPPING ON  MigR_placeholder = substr(fin_acc_num,6,8)
INNER JOIN C8PF ON C8CCY = SCCCY
union
select 
--Account Number
rpad(FIN_ACC_NUM,16,' '),
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(FIN_SOL_ID,8,' '),----------changed for m4   
--Part Tran Type
    CASE WHEN SCBAL <0 THEN 'C' ELSE 'D' END,
--Transaction Amount
    lpad(abs(SCBAL)/POWER(10,C8CED),17,' '),
--Transaction Particular
    rpad('YP SPLIT DR CR CONTRA ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(SCBAL)/POWER(10,C8CED),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
FROM
(
select * from all_final_trial_balance where scact = 'YP' and substr(fin_acc_num,6,8) like '52000%' AND SCBAL <> 0
 )A
LEFT JOIN YP_MAPPING ON  MigR_placeholder = substr(fin_acc_num,6,8)
INNER JOIN C8PF ON C8CCY = SCCCY;
commit;
exit; 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM07_upload_kw.sql 
========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
TTUM07_upload_kw.sql 
-- File Name        : TTUM7
-- File Created for    : Upload file for Office accounts
-- Created By        : Kumaresan
-- Client            : ABK
-- Created On        : 03-06-2011
-------------------------------------------------------------------
truncate table TTUM7_O_TABLE;
insert into TTUM7_O_TABLE
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(new_fin_sol_id,8,' '),
--Part Tran Type
   case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 SOL REV Migration',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from 
(
select new_fin_sol_id,scccy,new_fin_sol_id||substr(ttum1_migr_acct,4,13) ttum1_migr_acct, scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where fin_sol_id<>new_fin_sol_id and scbal<>0
union all
select fin_sol_id,scccy,ttum1_migr_acct, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where fin_sol_id<>new_fin_sol_id and scbal<>0
);
commit;
-----------------------------interest_payable  customer accounts difference sol added on 04-06-2017 by kumar-----------------------------------
/*insert into TTUM7_O_TABLE
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
rpad(fin_sol_id,8,' '),----------changed for m4   
   --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'D'
         else 'C'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('TTUM7 SOL REV INT RECV PAY DR CR ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((INTEREST_FCY)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from(
select '603' FIN_SOL_ID,scccy,'603'||substr(ttum1_migr_acct,4,13) ttum1_migr_acct,interest_fcy
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL
union all
select MAP_SOL.FIN_SOL_ID,scccy,ttum1_migr_acct ttum1_migr_acct,interest_fcy
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)*-1interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL);
commit;
-----------------------------interest_payable  customer accounts difference sol added on 04-06-2017 by kumar-----------------------------------
insert into TTUM7_O_TABLE 
select 
--Account Number
IR_IP_ACCT,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad('603',8,' '),----changed for mock4kw
    --rpad('600',8,' '),
--Part Tran Type
    case when (INTEREST_FCY) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((INTEREST_FCY)),17,' '),
--Transaction Particular
    rpad('TTUM7 SOL REV INT RECV PAY DR CR ENTRY',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((INTEREST_FCY)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from
(
select '603' fin_sol_id,TO_CHAR (
'603' 
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
)IR_IP_ACCT,scccy,INTEREST_FCY
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL
union all
select MAP_SOL.FIN_SOL_ID fin_sol_id,TO_CHAR (
MAP_SOL.FIN_SOL_ID
|| TO_CHAR (CRNCY_ALIAS_NUM)
||
CASE 
WHEN scact='YI' and TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN scact='YD' and TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
WHEN TRIM(INT_PAID_BACID) IS NOT NULL THEN INT_PAID_BACID 
WHEN TRIM(INT_COLL_BACID) IS NOT NULL THEN INT_COLL_BACID 
END
)IR_IP_ACCT,scccy,INTEREST_FCY
from
(
select * from all_final_trial_balance where scact in ('YD','YI')
and isnumber(fin_acc_num) = 0 and scbal <> 0
)a
inner join (select s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' ')INT_PAID_BACID,NVL(INT_COLL_BACID,' ')INT_COLL_BACID, sum(interest_fcy)*-1interest_fcy
from int_recv_pay_bal_trfr_dif_sol group by s5ab,contra_basic,c8ccyn,NVL(INT_PAID_BACID,' '),NVL(INT_COLL_BACID,' ')
)int_recv_pay_bal_trfr_dif_sol on scab||scan||scas = s5ab||contra_basic||c8ccyn
LEFT JOIN (SELECT * FROM tbaadm.cnc WHERE bank_id = get_param ('BANK_ID')) CNC ON SCCCY = CRNCY_CODE
LEFT JOIN MAP_SOL ON SCAB = BR_CODE
inner join acct_where_int_match_dif_sol on brn = scab and basic = scan and suf = scas
WHERE TRIM(INT_PAID_BACID) IS NOT NULL OR TRIM(INT_COLL_BACID) IS NOT NULL
);
commit;*/
---Trade finance sol Reversal block--
insert into TTUM7_O_TABLE
select 
--Account Number
    FIN_ACC_NUM,    
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 SOL REV Migration',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from 
(
select case when substr(trim(FIN_ACC_NUM),6,5)  in('70004','70011') then  '900'
         when substr(trim(FIN_ACC_NUM),6,5)  in('70000','70001','70002','70003','70010','70020',
         '70021','70022','70030','70031','70040','70041','70042','70043','70099') then  '700'
         when substr(FIN_ACC_NUM,1,3) ='700' then  '700'
         else fin_sol_id end fin_sol_id,  scccy, case when substr(trim(FIN_ACC_NUM),6,5)  in('70004','70011') then  trim(FIN_ACC_NUM)
         when substr(trim(FIN_ACC_NUM),6,5)  in('70000','70001','70002','70003','70010','70020',
         '70021','70022','70030','70031','70040','70041','70042','70043','70099') then  trim(FIN_ACC_NUM)
         else fin_acc_num end fin_acc_num,scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scbal<>0 and 
 SCHEME_TYPE='OAB'  and leg_acc_num  in(select leg_acc_num from tfs_sol_map_acc)
union all
select fin_sol_id,scccy,TTUM1_MIGR_ACCT, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scbal<>0
and SCHEME_TYPE='OAB' and leg_acc_num  in(select leg_acc_num from tfs_sol_map_acc)
);    
commit;
---Trade finance sol Reversal block Added on 22-08-2017 as per  Sanjay mail on Mon 8/14/2017 5:08 PM
/*insert into TTUM7_O_TABLE
select 
--Account Number
    FIN_ACC_NUM,    
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 SOL REV Migration',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from 
(
select case when scan in(
'900050','900055','900060','900075','900090','900190','901050','901075',
'901090','903290','903590','907000','915127','915128','915129','915130',
'915205','915210','915228','915229','915230','970800') then '700'
when scan='913500' then '900' end fin_sol_id,scccy,
case when  scan in(
'900050','900055','900060','900075','900090','900190','901050','901075',
'901090','903290','903590','907000','915127','915128','915129','915130',
'915205','915210','915228','915229','915230','970800') then  '700'||substr(trim(FIN_ACC_NUM),4,13)
when scan='913500' then '900'||substr(trim(FIN_ACC_NUM),4,13) end fin_acc_num,scbal/power(10,c8ced) acbal      
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scbal<>0 and 
SCHEME_TYPE='OAB' and scan in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230','970800')
union all
select fin_sol_id,scccy,TTUM1_MIGR_ACCT, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scbal<>0
and SCHEME_TYPE='OAB' and scan in('900050','900055','900060','900075','900090','900190','901050','901075','901090','903290','903590',
'907000','913500','915127','915128','915129','915130','915205','915210','915228','915229','915230','970800')
);*/    
commit;
--As per Sebi mail Fri 6/9/2017 8:02 PM changed on 09-06-2017 by Kumar--
insert into TTUM7_O_TABLE
select 
--Account Number
    FIN_ACC_NUM,    
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
    case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 SOL REV Migration',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from (
select case when new_fin_sol_id<>'005' then
'603' else
new_fin_sol_id end fin_sol_id  ,scccy,(case when new_fin_sol_id<>'005' then
'603' else
new_fin_sol_id end)||substr(fin_acc_num,4,13) fin_acc_num, scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scbal<>0
and scab||scan||scas  in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840')
union all
select fin_sol_id,scccy,ttum1_migr_acct, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where  scab||scan||scas  in('0601871100414','0602871100414','0604871100414','0605871100414','0607871100414','0609871100414','0610871100414','0612871100414','0616871100414','0621871100414','0780871135840')
and scbal<>0);    
commit;
--Overdue interest TTUM transaction added on 29-06-2017 by Kumar--
/*insert into TTUM7_O_TABLE
select 
--Account Number
    FIN_ACC_NUM,
--Currency Code 
    rpad(currency,3,' '),
--SOLID
    rpad(FIN_SOL_ID,8,' '),
--Part Tran Type
   Part_Tran_Type,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 Overdue interest Migration',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(currency,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from (
select fin_sol_id,to_char(currency) currency, case when trim(NPL) in('20','50')
then to_char(map_acc.fin_sol_id||cnc.CRNCY_ALIAS_NUM||PAST_DUE_INT_COLL_BACID)
else to_char(map_acc.fin_sol_id||cnc.CRNCY_ALIAS_NUM||PRINCIPAL_LOSSLINE_BACID) end fin_Acc_num,to_number(TOTAL_INTEREST_PAST_DUE) acbal,
'D' Part_Tran_Type 
from iis 
left join map_Acc on DEL_REF=substr(leg_acc_num,8,15) and trim(ACC_NO)=fin_cif_id
left join (select * from tbaadm.gsp where bank_id=get_param('BANK_ID'))gss on gss.schm_code=MAP_ACC.SCHM_CODE
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on cnc.CRNCY_CODE=map_acc.currency
where leg_acc_num is   not null and trim(PAST_DUE_INT_COLL_BACID) is not null and triM(PRINCIPAL_LOSSLINE_BACID) is not null
union all
select '003','KWD','0030152000013',sum(to_number(TOTAL_INTEREST_PAST_DUE)),'C'
from iis 
left join map_Acc on DEL_REF=substr(leg_acc_num,8,15) and trim(ACC_NO)=fin_cif_id
left join (select * from tbaadm.gsp where bank_id=get_param('BANK_ID'))gss on gss.schm_code=MAP_ACC.SCHM_CODE
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on cnc.CRNCY_CODE=map_acc.currency
where leg_acc_num is   not null and trim(PAST_DUE_INT_COLL_BACID) is not null and triM(PRINCIPAL_LOSSLINE_BACID) is not null
group by '003','KWD','0030152000013','C'
);
commit;*/
--TRY MIGR SOL and account type merge  changed on 09-06-2017 by Kumar--
/*insert into TTUM7_O_TABLE
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(new_fin_sol_id,8,' '),
--Part Tran Type
   case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 TRY SOL REV Migration',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from 
(
select '005' new_fin_sol_id,scccy,'005'||substr(TTUM1_MIGR_ACCT,4,2)||'520000V6' ttum1_migr_acct, scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scbal<>0 and scact in('VC','V6') 
union all
select fin_sol_id,scccy,ttum1_migr_acct, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scbal<>0 and scact in('VC','V6') 
);
commit;*/
--TRY MIGR SOL and account type merge  changed on 09-06-2017 by Kumar--
/*insert into TTUM7_O_TABLE
select 
--Account Number
    ttum1_migr_acct,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(new_fin_sol_id,8,' '),
--Part Tran Type
   case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 TRY SOL REV Migration',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from 
(
select '005' new_fin_sol_id,scccy,'005'||substr(TTUM1_MIGR_ACCT,4,2)||'520000W6' ttum1_migr_acct, scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scbal<>0 and scact in('W5','W6') 
union all
select fin_sol_id,scccy,ttum1_migr_acct, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scbal<>0 and scact in('W5','W6') 
);
commit;*/
--TRY MIGR SOL and account type merge  changed on 09-06-2017 by Kumar--
insert into TTUM7_O_TABLE
select 
--Account Number
    fin_acc_num,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(new_fin_sol_id,8,' '),
--Part Tran Type
   case when (acbal) > 0 then 'C'
         else 'D'
    end,
--Transaction Amount
    lpad(abs((acbal)),17,' '),
--Transaction Particular
    rpad('TTUM7 TRY SOL REV Migration',30,' '),
    rpad(' ',5,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs((acbal)),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from 
(
select '005' new_fin_sol_id,scccy,fin_acc_num , scbal/power(10,c8ced) acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
where scbal<>0 and scact in('YX') 
union all
select map_sol.fin_sol_id,scccy,ttum1_migr_acct, scbal/power(10,c8ced)*-1 acbal
from all_final_trial_balance
left join c8pf on c8ccy = scccy
left join map_sol on br_code=scab
where scbal<>0 and scact in('YX')
);
commit;
--- Advance interest balance transfer ttum added on 20-07-2017--
insert into ttum7_o_table
select 
--Account Number
    FIN_ACC_NUM,
--Currency Code 
    rpad(scccy,3,' '),
--SOLID
    rpad(NEW_FIN_SOL_ID,8,' '),
--Part Tran Type
   Part_Tran_Type,
--Transaction Amount
    lpad( abs(acbal),17,' '),
--Transaction Particular
    rpad('TTUM7 Advance interest Migration',30,' '),
    rpad(' ',5,' '), 
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',10,' '),
    rpad(' ',6,' '),
    rpad(' ',16,' '),
    rpad(' ',1,' '),
    lpad(abs(acbal),17,' '),
    rpad(scccy,3,' '),
    rpad(' ',5,' '),
    rpad(' ',15,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',5,' '),
    rpad(' ',6,' '),
    rpad(' ',6,' '),
    rpad(' ',2,' '),
    rpad(' ',1,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',20,' '),
    rpad(' ',5,' '),
    rpad(' ',30,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',40,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',17,' '),
    rpad(' ',30,' '),
    rpad(' ',16,' '),
    rpad(' ',12,' '),
    rpad(' ',10,' '),
    rpad(' ',10,' '),
    rpad(' ',9,' '),
    rpad(' ',4,' '),
    rpad(' ',34,' '),
    rpad(' ',256,' '),
    rpad(' ',16,' '),
    rpad(' ',5,' '),
    rpad(' ',5,' ')
from (
select new_fin_sol_id,scccy,fin_acc_num,sum(acbal)  acbal, Part_Tran_Type from (
select   new_fin_sol_id,scccy,NEW_FIN_SOL_ID||cnc.CRNCY_ALIAS_NUM||gsp.ADVANCE_INT_BACID fin_acc_num,
abs((nvl(to_number(V4AIM1),0)-nvl(to_number(V5AM1),0)) / power(10,c8ced)) acbal,'C' Part_Tran_Type  
from all_final_trial_balance
inner join v5pf on trim(v5brnm)||trim(v5dlp)||trim(v5dlr)=leg_acc_num
inner join c8pf on c8ccy = v5ccy
left join v4pf on trim(v4brnm)||trim(v4dlp)||trim(v4dlr) = trim(v5brnm)||trim(v5dlp)||trim(v5dlr)
left join (select * from tbaadm.gsp where bank_id=get_param('BANK_ID'))gsp on gsp.schm_code=scheme_code
left join (select * from tbaadm.cnc where bank_id=get_param('BANK_ID'))cnc on cnc.CRNCY_CODE=scccy
where  DEAL_TYPE iN('LDA','BDT') and scbaL<>0 and (nvl(to_number(V4AIM1),0)-nvl(to_number(V5AM1),0))<>0)
group by new_fin_sol_id,scccy,fin_acc_num,Part_Tran_Type
union  all
select fin_sol_id,scccy,ttum1_migr_acct,sum(scbal/power(10,c8ced))acbal,'D'Part_Tran_Type from all_final_trial_balance
inner join c8pf on c8ccy = scccy 
where scact='YU' and scbal<>0
group by fin_sol_id,scccy,ttum1_migr_acct,'D' 
having sum(scbal/power(10,c8ced))<>0
);
commit;
--update ttum7_o_table  set TRANSACTION_AMOUNT=lpad(to_number(TRANSACTION_AMOUNT)-111.364,17,' '),
--REFERENCE_AMOUNT=lpad(to_number(REFERENCE_AMOUNT)-111.364,17,' ')  where trim(account_number)='60101520000YU';
--commit;-- this update for 10 Aug advance interst scabl balance
update ttum7_o_table  set TRANSACTION_AMOUNT=lpad(to_number(TRANSACTION_AMOUNT)-0.001,17,' '),
REFERENCE_AMOUNT=lpad(to_number(REFERENCE_AMOUNT)-0.001,17,' ')  where trim(account_number)='60101520000YU';
commit;-- this update for 30 JUN advance interst scabl balance
exit;