
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
 
