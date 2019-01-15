
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
