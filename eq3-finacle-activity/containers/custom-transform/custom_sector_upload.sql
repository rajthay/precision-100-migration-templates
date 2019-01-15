
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
