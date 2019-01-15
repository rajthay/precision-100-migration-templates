
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
