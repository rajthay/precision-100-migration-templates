-- File Name           : MPT_upload.sql
-- File Created for    : Upload file for MPT
-- Created By          : Kumaresan.B
-- Client              : EIB
-- Created On          : 23-12-2015
-------------------------------------------------------------------
update BEAM_MEMOPAD set NOTE =replace(NOTE,'_x000D_','');
COMMIT;
truncate table MEMOPAD_O_TABLE;
---Account Level Memmopad in Equation system for SAO condition---
insert into MEMOPAD_O_TABLE
select  distinct
--   Memo_Pad_Title         NVARCHAR2(30) NULL,
Rpad('MPT',30,' '),
--   Function_Code         NVARCHAR2(5) NULL,
Rpad('FT',5,' '),
--   Intent               NVARCHAR2(1) NULL,
'G',
--   Security               NVARCHAR2(1) NULL,
'P',
--   Text_Message             NVARCHAR2(240) NULL,
--case when scaij7 = 'Y' then 'High Risk' else 'SAO Account' end
Rpad('SAO Account',240,' '),
--   Account_No               NVARCHAR2(16) NULL,
Rpad(fin_acc_num,16,' '),
--   Transaction_ID         NVARCHAR2(9) NULL,
Rpad(' ',9,' '),
--   Transaction_Date         NVARCHAR2(8) NULL,
Rpad(to_char(to_date(modify_date,'MM/DD/YYYY'),'DD-MM-YYYY'),10,' '),
--   Trx_Serial_No         NVARCHAR2(4) NULL,
Rpad(' ',4,' '),
--   CIF_ID               NVARCHAR2(32) NULL,
Rpad(' ',32,' '),
--   Standing_Order_Serial_No     NVARCHAR2(12) NULL,
Rpad(' ',12,' '),
--   Instrument_Type         NVARCHAR2(5) NULL,
Rpad(' ',5,' '),
--   Instrument_ID         NVARCHAR2(16) NULL,
Rpad(' ',16,' '),
--   Employee_ID              NVARCHAR2(10) NULL,
Rpad(' ',10,' '),
--   Signatory                NVARCHAR2(9) NULL,
Rpad(' ',9,' '),
--   Inventory_Class         NVARCHAR2(3) NULL,
Rpad(' ',3,' '),
--   Inventory_Type         NVARCHAR2(6) NULL,
Rpad(' ',6,' '),
--   Inventory_Serial_No         NVARCHAR2(16) NULL,
Rpad(' ',16,' '),
--   Inventory_Location_Class     NVARCHAR2(2) NULL,
Rpad(' ',2,' '),
--   Inventory_Location_Code     NVARCHAR2(10) NULL,
Rpad(' ',10,' '),
--   Key_Word               NVARCHAR2(5) NULL,
Rpad(' ',5,' '),
--   Audit_Ref_No             NVARCHAR2(9) NULL,
Rpad(' ',15,' '),
--   Sol_ID               NVARCHAR2(8) NULL,
Rpad(map_acc.fin_sol_id,8,' '),
--   Text_Message_in_the_Alt_Lang  NVARCHAR2(240) NULL,
Rpad(to_char(add_months(to_date(modify_date,'MM/DD/YYYY'),24),'DD-MM-YYYY'),240,' '),
--   Memo_Pad_Title_in_Alt_Lang     NVARCHAR2(30) NULL)
Rpad(' ',30,' ')
from map_acc
inner join acc_sao on fin_acc_num=lpad(trim(EXT_ACC),13,0)
--inner join scpf on scab||scan||scas=leg_branch_id||leg_scan||leg_scas 
--and  (scaij7 = 'Y' or upper(scp2r) = 'SAO')
where map_acc.schm_type in('SBA','CAA','ODA','PCA') and add_months(to_date(get_param('EOD_DATE'),'DD-MM-YYYY'),-24) <= to_date(modify_date,'MM/DD/YYYY');
commit;
--BEAM MEMOPAD for Kwuait--
update BEAM_MEMOPAD set CUST_ACCT =trim(CUST_ACCT), NAME=trim(CUST_ACCT), NOTE=trim(replace(replace(NOTE,chr(10),' '),chr(13),' '));
commit;
insert into MEMOPAD_O_TABLE
select  distinct
--   Memo_Pad_Title         NVARCHAR2(30) NULL,
Rpad('MPT',30,' '),
--   Function_Code         NVARCHAR2(5) NULL,
Rpad('FT',5,' '),
--   Intent               NVARCHAR2(1) NULL,
'G',
--   Security               NVARCHAR2(1) NULL,
'P',
--   Text_Message             NVARCHAR2(240) NULL,
Rpad(trim(NOTE),240,' '),
--   Account_No               NVARCHAR2(16) NULL,
Rpad(map_acc.fin_acc_num,16,' '),
--   Transaction_ID         NVARCHAR2(9) NULL,
Rpad(' ',9,' '),
--   Transaction_Date         NVARCHAR2(8) NULL,
Rpad(nvl(to_char(START_DATE,'dd-mm-yyyy'),' '),10,' '),
--   Trx_Serial_No         NVARCHAR2(4) NULL,
Rpad(' ',4,' '),
--   CIF_ID               NVARCHAR2(32) NULL,
Rpad(' ',32,' '),
--   Standing_Order_Serial_No     NVARCHAR2(12) NULL,
Rpad(' ',12,' '),
--   Instrument_Type         NVARCHAR2(5) NULL,
Rpad(' ',5,' '),
--   Instrument_ID         NVARCHAR2(16) NULL,
Rpad(' ',16,' '),
--   Employee_ID              NVARCHAR2(10) NULL,
Rpad(' ',10,' '),
--   Signatory                NVARCHAR2(9) NULL,
Rpad(' ',9,' '),
--   Inventory_Class         NVARCHAR2(3) NULL,
Rpad(' ',3,' '),
--   Inventory_Type         NVARCHAR2(6) NULL,
Rpad(' ',6,' '),
--   Inventory_Serial_No         NVARCHAR2(16) NULL,
Rpad(' ',16,' '),
--   Inventory_Location_Class     NVARCHAR2(2) NULL,
Rpad(' ',2,' '),
--   Inventory_Location_Code     NVARCHAR2(10) NULL,
Rpad(' ',10,' '),
--   Key_Word               NVARCHAR2(5) NULL,
Rpad(' ',5,' '),
--   Audit_Ref_No             NVARCHAR2(9) NULL,
Rpad(' ',15,' '),
--   Sol_ID               NVARCHAR2(8) NULL,
--Rpad(nvl(trim(BRANCHID),' '),8,' '),--- commented based on Mock4 observation 01-05-2017
Rpad(nvl(map_sol.fin_sol_id,map_acc.fin_sol_id),8,' '),
--   Text_Message_in_the_Alt_Lang  NVARCHAR2(240) NULL,
Rpad(nvl(to_char(END_DATE,'dd-mm-yyyy'),'31-12-2099'),240,' '),
--   Memo_Pad_Title_in_Alt_Lang     NVARCHAR2(30) NULL)
Rpad(' ',30,' ')
from BEAM_MEMOPAD
inner join map_Acc on LEG_BRANCH_ID||LEG_SCAN||LEG_SCAS=trim(CUST_ACCT)
left join branch on trim(BEAM_MEMOPAD.CreateBranchGuid) = trim(branch.GUID) and trim(branch.INSTITUTIONGUID)='1107769F-F3BB-44EE-EE6B-527CAD4EEEA5' --added on 19/04/2017 based on existing request from Business
left join map_sol on br_code=branchid
where map_acc.schm_type in('SBA','CAA','ODA','PCA')
and case when END_DATE is not null and END_DATE <= to_date(get_param('EOD_DATE'),'dd-mm-yyyy') then 0 else 1 end =1;
commit;
--------------------------------Upload file for cash deposit restricted for Currency exchange companies----------------------
insert into MEMOPAD_O_TABLE
select  distinct
--   Memo_Pad_Title         NVARCHAR2(30) NULL,
Rpad('MPT',30,' '),
--   Function_Code         NVARCHAR2(5) NULL,
Rpad('FT',5,' '),
--   Intent               NVARCHAR2(1) NULL,
'G',
--   Security               NVARCHAR2(1) NULL,
'P',
--   Text_Message             NVARCHAR2(240) NULL,
--case when scaij7 = 'Y' then 'High Risk' else 'SAO Account' end
Rpad('CASH CREDIT RESTRICTED--EXCHANGE COMPANIES',240,' '),
--   Account_No               NVARCHAR2(16) NULL,
Rpad(fin_acc_num,16,' '),
--   Transaction_ID         NVARCHAR2(9) NULL,
Rpad(' ',9,' '),
--   Transaction_Date         NVARCHAR2(8) NULL,
Rpad(' ',10,' '),
--   Trx_Serial_No         NVARCHAR2(4) NULL,
Rpad(' ',4,' '),
--   CIF_ID               NVARCHAR2(32) NULL,
Rpad(' ',32,' '),
--   Standing_Order_Serial_No     NVARCHAR2(12) NULL,
Rpad(' ',12,' '),
--   Instrument_Type         NVARCHAR2(5) NULL,
Rpad(' ',5,' '),
--   Instrument_ID         NVARCHAR2(16) NULL,
Rpad(' ',16,' '),
--   Employee_ID              NVARCHAR2(10) NULL,
Rpad(' ',10,' '),
--   Signatory                NVARCHAR2(9) NULL,
Rpad(' ',9,' '),
--   Inventory_Class         NVARCHAR2(3) NULL,
Rpad(' ',3,' '),
--   Inventory_Type         NVARCHAR2(6) NULL,
Rpad(' ',6,' '),
--   Inventory_Serial_No         NVARCHAR2(16) NULL,
Rpad(' ',16,' '),
--   Inventory_Location_Class     NVARCHAR2(2) NULL,
Rpad(' ',2,' '),
--   Inventory_Location_Code     NVARCHAR2(10) NULL,
Rpad(' ',10,' '),
--   Key_Word               NVARCHAR2(5) NULL,
Rpad(' ',5,' '),
--   Audit_Ref_No             NVARCHAR2(9) NULL,
Rpad(' ',15,' '),
--   Sol_ID               NVARCHAR2(8) NULL,
Rpad(map_acc.fin_sol_id,8,' '),
--   Text_Message_in_the_Alt_Lang  NVARCHAR2(240) NULL,
Rpad('31-12-2099',240,' '),
--   Memo_Pad_Title_in_Alt_Lang     NVARCHAR2(30) NULL)
Rpad(' ',30,' ')
from map_acc 
inner join scpf on scab||Scan||Scas=leg_branch_id||leg_scan||leg_scas
where schm_type in ('SBA','CAA','ODA','PCA')
and trim(scc3r)='EX'; 
commit;
------------------ THUMP impression and special needs  -------------------------
insert into MEMOPAD_O_TABLE
select  distinct
--   Memo_Pad_Title         NVARCHAR2(30) NULL,
Rpad('MPT',30,' '),
--   Function_Code         NVARCHAR2(5) NULL,
Rpad('FT',5,' '),
--   Intent               NVARCHAR2(1) NULL,
'G',
--   Security               NVARCHAR2(1) NULL,
'P',
--   Text_Message             NVARCHAR2(240) NULL,
--case when scaij7 = 'Y' then 'High Risk' else 'SAO Account' end
Rpad(case when scaig7='Y' and scaij6='Y' then 'Thumb impression/Special needs'
    when scaig7='Y' and scaij6='N' then 'Thumb Impression'
    when scaig7='N' and scaij6='Y' then 'Special needs' else ' ' end,240,' '),
--   Account_No               NVARCHAR2(16) NULL,
Rpad(fin_acc_num,16,' '),
--   Transaction_ID         NVARCHAR2(9) NULL,
Rpad(' ',9,' '),
--   Transaction_Date         NVARCHAR2(8) NULL,
Rpad(' ',10,' '),
--   Trx_Serial_No         NVARCHAR2(4) NULL,
Rpad(' ',4,' '),
--   CIF_ID               NVARCHAR2(32) NULL,
Rpad(' ',32,' '),
--   Standing_Order_Serial_No     NVARCHAR2(12) NULL,
Rpad(' ',12,' '),
--   Instrument_Type         NVARCHAR2(5) NULL,
Rpad(' ',5,' '),
--   Instrument_ID         NVARCHAR2(16) NULL,
Rpad(' ',16,' '),
--   Employee_ID              NVARCHAR2(10) NULL,
Rpad(' ',10,' '),
--   Signatory                NVARCHAR2(9) NULL,
Rpad(' ',9,' '),
--   Inventory_Class         NVARCHAR2(3) NULL,
Rpad(' ',3,' '),
--   Inventory_Type         NVARCHAR2(6) NULL,
Rpad(' ',6,' '),
--   Inventory_Serial_No         NVARCHAR2(16) NULL,
Rpad(' ',16,' '),
--   Inventory_Location_Class     NVARCHAR2(2) NULL,
Rpad(' ',2,' '),
--   Inventory_Location_Code     NVARCHAR2(10) NULL,
Rpad(' ',10,' '),
--   Key_Word               NVARCHAR2(5) NULL,
Rpad(' ',5,' '),
--   Audit_Ref_No             NVARCHAR2(9) NULL,
Rpad(' ',15,' '),
--   Sol_ID               NVARCHAR2(8) NULL,
Rpad(map_acc.fin_sol_id,8,' '),
--   Text_Message_in_the_Alt_Lang  NVARCHAR2(240) NULL,
Rpad('31-12-2099',240,' '),
--   Memo_Pad_Title_in_Alt_Lang     NVARCHAR2(30) NULL)
Rpad(' ',30,' ')
from map_acc 
inner join scpf on scab||Scan||Scas=leg_branch_id||leg_scan||leg_scas
where schm_type in ('SBA','CAA','ODA','PCA')
and (scaig7='Y' or scaij6='Y'); 
commit;
--------------------------
update MEMOPAD_O_TABLE set TEXT_MESSAGE=replace (replace(TEXT_MESSAGE,chr(10),' '),chr(13),' ');
commit;
update MEMOPAD_O_TABLE set TEXT_MESSAGE_IN_THE_ALT_LANG='31-12-2099' where trim(TEXT_MESSAGE_IN_THE_ALT_LANG) is null;
update MEMOPAD_O_TABLE set TEXT_MESSAGE_IN_THE_ALT_LANG='31-12-2099' where to_date(TEXT_MESSAGE_IN_THE_ALT_LANG,'dd-mm-yyyy') > to_date('31-12-2099','dd-mm-yyyy');
commit;
exit;
--select  CustAcctNbr,Name,CreateDate, StartDate,EndDate,note from CustomerNotes where InstitutionGuid ='1107769F-F3BB-44EE-EE6B-527CAD4EEEA5';
--update BEAM_MEMOPAD set NOTE =replace(NOTE,'_x000D_','');
--select cast(Guid as varchar(4000)) as Guid ,cast(InstitutionGuid as varchar(4000)) as InstitutionGuid,NoteType,CustAcctNbr,Name,NoteTypeClass,StartDate,EndDate,CreateDate
--,CreateUserGuid,CreateBranchGuid,CreateName,Note from "BA_BeamDB_ABKBankV510_20170220"."dbo"."CustomerNotes";
 --select cast(Guid as varchar(4000)) as GUID, cast(INSTITUTIONGUID as varchar(4000)) as INSTITUTIONGUID, BRANCHID, DEPARTMENTID, NAME, LONGNAME, ADDRESS1, ADDRESS2, ADDRESS3, ADDRESS4,
 -- TOWN, COUNTRYCODE, PHONE, FAX, OTHERPHONE, EMAILADDRESS, IDCODE, ROUTECODE, BRANCHMEM, INTERNETBRANCH, 
 -- HOSTADDRESS01, HOSTADDRESS02, HOSTADDRESS03, HOSTADDRESS04, COMMTIMEOUT01, COMMTIMEOUT02, 
 -- COMMTIMEOUT03, COMMTIMEOUT04, COMMMODE01, COMMMODE02, COMMMODE03, COMMMODE04, UPDATEDATE,
 -- CLEARINGAREA, PERM01, PERM02, PERM03, PERM04, PERM05, PERM06, PERM07, PERM08, PERM09, PERM10,
 -- PERM11, PERM12, PERM13, PERM14, PERM15, PERM16, PERM17, PERM18, PERM19, PERM20, PARAMETER01,
 -- PARAMETER02, PARAMETER03, PARAMETER04, PARAMETER05, STARTTERMNUMBER, ENDTERMNUMBER, BRANCHBSBCODE, SWIFTCODE from "BA_BeamDB_ABKBankV510_20170220"."dbo"."branch"
-- SELECT CAST (Guid AS VARCHAR (4000)) AS Guid,CAST (InstitutionGuid AS VARCHAR (4000)) AS InstitutionGuid,NoteType,
 --      CustAcctNbr, Name, NoteTypeClass, StartDate, EndDate, CreateDate, CreateUserGuid, CreateBranchGuid,
 --      AckFlag, AckDate, AckUserGuid, AckBranchGuid, ViewDate, ViewUserGuid, ViewBranchGuid, UpdateDate,
  --     SequenceNumber, CreateName, ViewName,AckName,Note,CAST (CreateBranchGuid AS VARCHAR (4000)) AS CreateBranchGuid 
  --FROM "BA_BeamDB_ABKBankV510_20170420"."dbo"."CUSTOMERNOTES" 
