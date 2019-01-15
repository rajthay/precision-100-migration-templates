drop table RETAIL_COREINTERFACE;
create table RETAIL_COREINTERFACE
as
select 
ORGKEY,
Is_Swift_Code_Of_Bank Bank_SWIFT_Code_Indicator,
trim(CUST.BIC) Customer_SWIFT_Code,
cust.CNO Treasury_Counterparty,
cust.CMNE Treasury_Counterparty_Mnemonic
from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID)
inner join map_cif on map_cif.GFBRNM||map_cif.GFCUS||map_cif.GFCLC = gfpf.GFBRNM||gfpf.GFCUS||gfpf.GFCLC and map_cif.INDIVIDUAL='Y'
inner join CU1_O_TABLE on ORGKEY=map_cif.FIN_CIF_ID
where cust.cmne not like 'AE%';
drop table CORP_COREINTERFACE;
create table CORP_COREINTERFACE
as
select 
corp_key,
Is_Swift_Code_Of_Bank Bank_SWIFT_Code_Indicator,
trim(CUST.BIC) Customer_SWIFT_Code,
'Y' Treasury_Counterparty,
cust.CMNE Treasury_Counterparty_Mnemonic
from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID)
inner join map_cif on map_cif.GFBRNM||map_cif.GFCUS||map_cif.GFCLC = gfpf.GFBRNM||gfpf.GFCUS||gfpf.GFCLC and map_cif.INDIVIDUAL='N'
inner join CU1CORP_O_TABLE on corp_key=map_cif.FIN_CIF_ID
where cust.cmne not like 'AE%';
exit;
 