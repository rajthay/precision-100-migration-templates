
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


---------------------------------------------------------------------------


drop table RETAIL_COREINTERFACE;
create table RETAIL_COREINTERFACE
as
select 
accounts.ORGKEY,
accounts.Is_Swift_Code_Of_Bank Bank_SWIFT_Code_Indicator,
accounts.Cust_Swift_Code_Desc Customer_SWIFT_Code,
cust.CNO Treasury_Counterparty,
cust.CMNE Treasury_Counterparty_Mnemonic
from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID)
inner join map_cif on map_cif.GFBRNM||map_cif.GFCUS||map_cif.GFCLC = gfpf.GFBRNM||gfpf.GFCUS||gfpf.GFCLC and map_cif.INDIVIDUAL='Y'
inner join crmuser.accounts on accounts.ORGKEY=map_cif.FIN_CIF_ID
where cust.cmne like 'AE%';



drop table CORP_COREINTERFACE;
create table CORP_COREINTERFACE
as
select 
corporate.corp_key,
corporate.Is_Swift_Code_Of_Bank Bank_SWIFT_Code_Indicator,
corporate.Cust_Swift_Code_Desc Customer_SWIFT_Code,
'Y' Treasury_Counterparty,
cust.CMNE Treasury_Counterparty_Mnemonic
from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID)
inner join map_cif on map_cif.GFBRNM||map_cif.GFCUS||map_cif.GFCLC = gfpf.GFBRNM||gfpf.GFCUS||gfpf.GFCLC and map_cif.INDIVIDUAL='N'
inner join crmuser.corporate on corporate.corp_key=map_cif.FIN_CIF_ID
where cust.cmne like 'AE%';



----------------------------------------------------------------




select 
corporate.corp_key finacle_account_num,
corporate.Cust_Swift_Code_Desc finacle_swift_code,
cust.bic treasury_BIC,
cust.CMNE "Treasury Counterparty Mnemonic"
from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID)
inner join map_cif on map_cif.GFBRNM||map_cif.GFCUS||map_cif.GFCLC = gfpf.GFBRNM||gfpf.GFCUS||gfpf.GFCLC and map_cif.INDIVIDUAL='N'
inner join crmuser.corporate on corporate.corp_key=map_cif.FIN_CIF_ID
where cust.cmne like 'AE%'
and nvl(corporate.Cust_Swift_Code_Desc,' ') != nvl(cust.bic,' ')


select distinct trim(INTERMED_INST_BIC) INTERMED_INST_BIC,CPTY_NAME from TREASURY_SSI_O_TABLE where trim(INTERMED_INST_BIC) in('ARABAEADXXX','ARAIAEADAUH','BNPAAEADXXX','NBOMOMRXXXX','SCBLAEADDIF')




==================================================================================================================

select 
gfpf.GFCUS,gfpf.GFCLC,gfpf.GFCUN,cust.CMNE Treasury_cpty_Mnemonic,BIC
from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID)
inner join map_cif on map_cif.GFBRNM||map_cif.GFCUS||map_cif.GFCLC = gfpf.GFBRNM||gfpf.GFCUS||gfpf.GFCLC and map_cif.INDIVIDUAL='N'
where cust.cmne NOT like 'AE%'
UNION ALL
select 
gfpf.GFCUS,gfpf.GFCLC,gfpf.GFCUN,cust.CMNE Treasury_cpty_Mnemonic,BIC
from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID)
inner join map_cif on map_cif.GFBRNM||map_cif.GFCUS||map_cif.GFCLC = gfpf.GFBRNM||gfpf.GFCUS||gfpf.GFCLC and map_cif.INDIVIDUAL='Y'
where cust.cmne NOT like 'AE%'




select 
TRIM(cust.CMNE) Treasury_cpty_Mnemonic,TRIM(map_cif.FIN_CIF_ID) FIN_CIF_ID
from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID)
inner join map_cif on map_cif.GFBRNM||map_cif.GFCUS||map_cif.GFCLC = gfpf.GFBRNM||gfpf.GFCUS||gfpf.GFCLC and map_cif.INDIVIDUAL='N'
where cust.cmne NOT like 'AE%'
UNION ALL
select 
TRIM(cust.CMNE) Treasury_cpty_Mnemonic,TRIM(map_cif.FIN_CIF_ID) FIN_CIF_ID
from cust
inner join gfpf on trim(cust.cmne) = trim(gfpf.GFOCID)
inner join map_cif on map_cif.GFBRNM||map_cif.GFCUS||map_cif.GFCLC = gfpf.GFBRNM||gfpf.GFCUS||gfpf.GFCLC and map_cif.INDIVIDUAL='Y'
where cust.cmne NOT like 'AE%' 
