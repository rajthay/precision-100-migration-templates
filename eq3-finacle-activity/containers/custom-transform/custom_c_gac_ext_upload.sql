
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

 
