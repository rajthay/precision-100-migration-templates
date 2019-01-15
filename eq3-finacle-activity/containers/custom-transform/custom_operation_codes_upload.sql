
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
