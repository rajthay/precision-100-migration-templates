
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
