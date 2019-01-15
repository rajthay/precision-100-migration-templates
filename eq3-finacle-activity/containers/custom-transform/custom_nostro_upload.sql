
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

 
