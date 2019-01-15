
-- File Name		: Related Party details
-- File Created for	: Upload file for balance
-- Created By		: Prashant
-- Client		: ENBD
-- Created On		: 01-11-2011
-------------------------------------------------------------------
truncate table AC2_O_TABLE;  
insert into AC2_O_TABLE  
select distinct
--   v_Account_Number             CHAR(16)
            rpad(map_acc.fin_acc_num,16,' '),
-- v_Currency                  CHAR(3)            
			lpad(scpf.scccy,3,' '),
--   v_Service_Outlet              CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),			
--   v_Record_Type             CHAR(1)
            lpad('J',1,' '),
--   v_Name                 CHAR(80)
            lpad(' ',80,' '),
--   v_Designation             CHAR(5)
            lpad(' ',5,' '),
--   v_Amount_allowed              CHAR(17)
            lpad(' ',17,' '),
--   v_Start_Date              CHAR(8)
            --lpad(' ',10,' '),
			case 
			when schm_type in ('TDA','CLA','LAA') and otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then  rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') 
			when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' then
            lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else lpad(' ',10,' ')
			end,
--   v_End_Date                 CHAR(8)
    '31-12-2099',
--   v_CIF_ID                 CHAR(32)
            lpad(relation.FIN_CIF_ID,32,' '),
--   v_Relation_Code            CHAR(5)          
          --lpad(RJREL,5,' '),
		  lpad('45',5,' '),
-- v_Pass_Sheet_flag              CHAR(1)
            'Y',
--   v_Standing_Instruction_ad_flag      CHAR(1)
            'Y',
-- v_TD_Maturity_Notice_Flag          CHAR(1)
            'Y',
--   v_Loan_Overdue_Notice_Flag        CHAR(1)
            'Y',
--   v_Communication_Address_1        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_Address_2        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_Address_3        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_City_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_State_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_Pin_Code        CHAR(6)
            lpad(' ',10,' '),
--   v_Communication_Country        CHAR(5)
            lpad(' ',5,' '),
-- v_Communication_Phone_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_FAX_Number        CHAR(15)
            lpad(' ',15,' '),
-- v_Communication_Telex_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_Email_Id        CHAR(50)
            lpad(' ',50,' '),
--   v_Exclude_for_combined_stateme    CHAR(1)
            'Y',
--   v_Statement_CIF_Id            CHAR(32)
            lpad(' ',32,' '),
--   v_Customer_Title_Code        CHAR(5)
--            rpad(convert_codes('SALUT',DT36.A1280),5,' '),
            rpad(' ',5,' '),
-- v_Incert_print_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Incert_adv_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Guarantor_liab_Pcnt        CHAR(8)
            lpad(' ',8,' '),
--   v_Guarantor_liab_sequence        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_type             CHAR(1)
            lpad(' ',1,' '),
--   v_PS_freq_week_num            CHAR(1)
        lpad(' ',1,' ') ,
--   v_PS_freq_week_day            CHAR(1)
            lpad(' ',1,' '),
--   v_PS_Freq_Start_month        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_holiday_status        CHAR(1)
            ' ',
-- v_SWIFT_statement_serial_num        CHAR(5)
            lpad(' ',5,' '),
--   v_PS_despatch_mode            CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_frequency_type        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_number        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_day        CHAR(1)
            lpad(' ',1,' '),
--   v_Swift_Freq_Start_Day        CHAR(2)
            lpad(' ',2,' '),
-- v_SWIFT_freq_holiday_status        CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_type            CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_receiver_bic        CHAR(12)
            lpad(' ',12,' '),
--   v_Address_type             CHAR(12)
            lpad(' ',12,' '),
-- v_Phone_type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_type                 CHAR(12)   
            lpad(' ',12,' '),
--Alternate authorized signatory name
            lpad(' ',80,' ')            
from scpf
inner join map_acc on scab=leg_branch_id and scan=leg_scan and scas=leg_scas
left join otpf on map_acc.LEG_ACC_NUM=trim(otbrnm)||trim(otdlp)||trim(otdlr)
inner join map_cif on map_cif.fin_cif_id=map_acc.fin_cif_id
left join rjpf on rjcus = gfcus and nvl(rjclc,' ') = nvl(gfclc,' ')
left  join map_cif relation on rjrcus = relation.gfcus and nvl(rjrclc,' ') = nvl(relation.gfclc,' ')
where  (scctp='EJ' or scaic7='Y') and (map_cif.fin_cif_id <> relation.fin_cif_id) and relation.fin_cif_id is not null
AND RJREL IN('JNC','JNP','JAC') and schm_type<>'OOO';		
COMMIT;
--GUARANTOR CIF RELATIONSHIP FOR WHICH GUARANTOR CIF AVAIALBLE --
insert into AC2_O_TABLE  
select distinct
--   v_Account_Number             CHAR(16)
            rpad(map_acc.fin_acc_num,16,' '),
-- v_Currency                  CHAR(3)            
			lpad(scpf.scccy,3,' '),
--   v_Service_Outlet              CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),--As per vijay sir confirmation all the corporate customer sol id will be moved to 603 sol			
--   v_Record_Type             CHAR(1)
            lpad('G',1,' '),
--   v_Name                 CHAR(80)
            lpad(RELATION.CIF_NAME,80,' '),
--   v_Designation             CHAR(5)
            lpad(' ',5,' '),
--   v_Amount_allowed              CHAR(17)
            lpad(' ',17,' '),
--   v_Start_Date              CHAR(8)
            --lpad(' ',10,' '),
			case 
			when schm_type in ('TDA','CLA','LAA') and otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then  rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') 
			when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' then
            lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else lpad(' ',10,' ')
			end,
--   v_End_Date                 CHAR(8)
    '31-12-2099',
--   v_CIF_ID                 CHAR(32)
  --          lpad(nvl(relation.FIN_CIF_ID,relation1.FIN_CIF_ID)32,' '),
            lpad(relation.FIN_CIF_ID,32,' '),
--   v_Relation_Code            CHAR(5)          
          --lpad(RJREL,5,' '),
		  lpad('43',5,' '),
-- v_Pass_Sheet_flag              CHAR(1)
            'Y',
--   v_Standing_Instruction_ad_flag      CHAR(1)
            'Y',
-- v_TD_Maturity_Notice_Flag          CHAR(1)
            'Y',
--   v_Loan_Overdue_Notice_Flag        CHAR(1)
            'Y',
--   v_Communication_Address_1        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_Address_2        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_Address_3        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_City_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_State_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_Pin_Code        CHAR(6)
            lpad(' ',10,' '),
--   v_Communication_Country        CHAR(5)
            lpad(' ',5,' '),
-- v_Communication_Phone_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_FAX_Number        CHAR(15)
            lpad(' ',15,' '),
-- v_Communication_Telex_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_Email_Id        CHAR(50)
            lpad(' ',50,' '),
--   v_Exclude_for_combined_stateme    CHAR(1)
            'Y',
--   v_Statement_CIF_Id            CHAR(32)
            lpad(' ',32,' '),
--   v_Customer_Title_Code        CHAR(5)
--            rpad(convert_codes('SALUT',DT36.A1280),5,' '),
            rpad(' ',5,' '),
-- v_Incert_print_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Incert_adv_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Guarantor_liab_Pcnt        CHAR(8)
            lpad(' ',8,' '),
--   v_Guarantor_liab_sequence        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_type             CHAR(1)
            lpad(' ',1,' '),
--   v_PS_freq_week_num            CHAR(1)
        lpad(' ',1,' ') ,
--   v_PS_freq_week_day            CHAR(1)
            lpad(' ',1,' '),
--   v_PS_Freq_Start_month        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_holiday_status        CHAR(1)
            ' ',
-- v_SWIFT_statement_serial_num        CHAR(5)
            lpad(' ',5,' '),
--   v_PS_despatch_mode            CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_frequency_type        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_number        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_day        CHAR(1)
            lpad(' ',1,' '),
--   v_Swift_Freq_Start_Day        CHAR(2)
            lpad(' ',2,' '),
-- v_SWIFT_freq_holiday_status        CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_type            CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_receiver_bic        CHAR(12)
            lpad(' ',12,' '),
--   v_Address_type             CHAR(12)
            lpad(' ',12,' '),
-- v_Phone_type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_type                 CHAR(12)   
            lpad(' ',12,' '),
--Alternate authorized signatory name
            lpad(' ',80,' ')            
from scpf
inner join map_acc on scab=leg_branch_id and scan=leg_scan and scas=leg_scas
left join otpf on map_acc.LEG_ACC_NUM=trim(otbrnm)||trim(otdlp)||trim(otdlr)
inner join map_cif on map_cif.fin_cif_id=map_acc.fin_cif_id
--left join rjpf on rjcus = gfcus and nvl(rjclc,' ') = nvl(gfclc,' ')
--left  join map_cif relation on rjrcus = relation.gfcus and nvl(rjrclc,' ') = nvl(relation.gfclc,' ')
left join GUARANTOR_customer GTR on TRIM(GTR.LOC)=map_cif.gfcus and nvl(TRIM(GTR.CUSTOMER),' ')=nvl(maP_cif.gfclc,' ')
left join map_cif relation on TRIM(LOC1)=relation.gfcus and nvl(TRIM(CUST_NO),' ')=nvl(relation.gfclc,' ')
--left join map_cif_joint relation1 on TRIM(customer)=relation1.gfcus and nvl(TRIM(loc),' ')=nvl(relation1.gfclc,' ') AND RELATION1.CIF_NAME=GUARANTOR_NAME
--where  scaig5='Y' and (map_cif.fin_cif_id <> relation.fin_cif_id or  map_cif.fin_cif_id <> relation1.fin_cif_id ) and (relation.fin_cif_id is not null or relation1.fin_cif_id is not null )
where  scaig5='Y' and (map_cif.fin_cif_id <> relation.fin_cif_id ) and relation.fin_cif_id is not null 
and schm_type<>'OOO';		
COMMIT;
---POA IN DOC SAFE FOR WHICH poa CIF AVAIALBLE ----
insert into AC2_O_TABLE  
select distinct
--   v_Account_Number             CHAR(16)
            rpad(map_acc.fin_acc_num,16,' '),
-- v_Currency                  CHAR(3)
           lpad(scpf.scccy,3,' '),
--   v_Service_Outlet              CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_Record_Type             CHAR(1)
            lpad('P',1,' '),
--   v_Name                 CHAR(80)            
			rpad(case when trim(BGRLNM) is not null then to_char(trim(BGRLNM))
			else 'ZZZ' end,80,' '),
--   v_Designation             CHAR(5)
            lpad(' ',5,' '),
--   v_Amount_allowed              CHAR(17)
            lpad(' ',17,' '),
--   v_Start_Date              CHAR(8)
            --lpad(' ',10,' '),
			case 
			when schm_type in ('TDA','CLA','LAA') and otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then  rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') 
			when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' then
            lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else lpad(' ',10,' ')
			end,
--   v_End_Date                 CHAR(8)
    '31-12-2099',
--   v_CIF_ID                 CHAR(32)
            lpad(relation.fin_cif_id,32,' '),
--   v_Relation_Code            CHAR(5)
          --  lpad('REP',5,' '),
          lpad('47',5,' '),
-- v_Pass_Sheet_flag              CHAR(1)
            'Y',
--   v_Standing_Instruction_ad_flag      CHAR(1)
            'Y',
-- v_TD_Maturity_Notice_Flag          CHAR(1)
            'Y',
--   v_Loan_Overdue_Notice_Flag        CHAR(1)
            'Y',
--   v_Communication_Address_1        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_Address_2        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_Address_3        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_City_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_State_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_Pin_Code        CHAR(6)
            lpad(' ',10,' '),
--   v_Communication_Country        CHAR(5)
            lpad(' ',5,' '),
-- v_Communication_Phone_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_FAX_Number        CHAR(15)
            lpad(' ',15,' '),
-- v_Communication_Telex_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_Email_Id        CHAR(50)
            lpad(' ',50,' '),
--   v_Exclude_for_combined_stateme    CHAR(1)
            'Y',
--   v_Statement_CIF_Id            CHAR(32)
            lpad(' ',32,' '),
--   v_Customer_Title_Code        CHAR(5)
            rpad('ZZZ',5,' '),
-- v_Incert_print_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Incert_adv_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Guarantor_liab_Pcnt        CHAR(8)
            lpad(' ',8,' '),
--   v_Guarantor_liab_sequence        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_type             CHAR(1)
            lpad(' ',1,' '),
--   v_PS_freq_week_num            CHAR(1)
        lpad(' ',1,' ') ,
--   v_PS_freq_week_day            CHAR(1)
            lpad(' ',1,' '),
--   v_PS_Freq_Start_month        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_holiday_status        CHAR(1)
            ' ',
-- v_SWIFT_statement_serial_num        CHAR(5)
            lpad(' ',5,' '),
--   v_PS_despatch_mode            CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_frequency_type        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_number        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_day        CHAR(1)
            lpad(' ',1,' '),
--   v_Swift_Freq_Start_Day        CHAR(2)
            lpad(' ',2,' '),
-- v_SWIFT_freq_holiday_status        CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_type            CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_receiver_bic        CHAR(12)
            lpad(' ',12,' '),
--   v_Address_type             CHAR(12)
            lpad(' ',12,' '),
-- v_Phone_type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_type                 CHAR(12)   
            lpad(' ',12,' '),
--Alternate authorized signatory name
            lpad(' ',80,' ')            
from scpf
inner join map_acc on scab=leg_branch_id and scan=leg_scan and scas=leg_scas
left join otpf on map_acc.LEG_ACC_NUM=trim(otbrnm)||trim(otdlp)||trim(otdlr)
inner join map_cif on map_cif.fin_cif_id=map_acc.fin_cif_id
left join poa_customer poa on poa.gfcus=map_cif.gfcus and nvl(poa.gfclc,' ')=nvl(maP_cif.gfclc,' ')
left join map_cif relation on bgcus=relation.gfcus and nvl(bgclc,' ')=nvl(relation.gfclc,' ')
--left join map_cif_joint relation1 on poa.gfcus=relation1.gfcus and nvl(poa.gfclc,' ')=nvl(relation1.gfclc,' ')
--where scai92='Y' and (map_cif.fin_cif_id <> relation.fin_cif_id or map_cif.fin_cif_id <> relation1.fin_cif_id ) and (relation.fin_cif_id is not null or relation1.fin_cif_id is not null)and schm_type<>'OOO';---based on mk5 issue raised by darine on 14-07-2017 issue fixed
where scai92='Y' and map_cif.fin_cif_id <> relation.fin_cif_id and relation.fin_cif_id is not null and schm_type<>'OOO';
COMMIT;
--GUARANTOR CIF RELATIONSHIP FOR WHICH GUARANTOR  CIF NOT AVAIALBLE BUT ONLY NAME AND CID AVAIALBLE --
insert into AC2_O_TABLE  
select distinct
--   v_Account_Number             CHAR(16)
            rpad(map_acc.fin_acc_num,16,' '),
-- v_Currency                  CHAR(3)            
			lpad(scpf.scccy,3,' '),
--   v_Service_Outlet              CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_Record_Type             CHAR(1)
            lpad('G',1,' '),
--   v_Name                 CHAR(80)
            lpad(RELATION.CIF_NAME,80,' '),
--   v_Designation             CHAR(5)
            lpad(' ',5,' '),
--   v_Amount_allowed              CHAR(17)
            lpad(' ',17,' '),
--   v_Start_Date              CHAR(8)
            --lpad(' ',10,' '),
			case 
			when schm_type in ('TDA','CLA','LAA') and otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then  rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') 
			when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' then
            lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else lpad(' ',10,' ')
			end,
--   v_End_Date                 CHAR(8)
    '31-12-2099',
--   v_CIF_ID                 CHAR(32)
            lpad(relation.FIN_CIF_ID,32,' '),
--   v_Relation_Code            CHAR(5)          
          --lpad(RJREL,5,' '),
		  lpad('43',5,' '),
-- v_Pass_Sheet_flag              CHAR(1)
            'Y',
--   v_Standing_Instruction_ad_flag      CHAR(1)
            'Y',
-- v_TD_Maturity_Notice_Flag          CHAR(1)
            'Y',
--   v_Loan_Overdue_Notice_Flag        CHAR(1)
            'Y',
--   v_Communication_Address_1        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_Address_2        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_Address_3        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_City_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_State_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_Pin_Code        CHAR(6)
            lpad(' ',10,' '),
--   v_Communication_Country        CHAR(5)
            lpad(' ',5,' '),
-- v_Communication_Phone_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_FAX_Number        CHAR(15)
            lpad(' ',15,' '),
-- v_Communication_Telex_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_Email_Id        CHAR(50)
            lpad(' ',50,' '),
--   v_Exclude_for_combined_stateme    CHAR(1)
            'Y',
--   v_Statement_CIF_Id            CHAR(32)
            lpad(' ',32,' '),
--   v_Customer_Title_Code        CHAR(5)
--            rpad(convert_codes('SALUT',DT36.A1280),5,' '),
            rpad(' ',5,' '),
-- v_Incert_print_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Incert_adv_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Guarantor_liab_Pcnt        CHAR(8)
            lpad(' ',8,' '),
--   v_Guarantor_liab_sequence        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_type             CHAR(1)
            lpad(' ',1,' '),
--   v_PS_freq_week_num            CHAR(1)
        lpad(' ',1,' ') ,
--   v_PS_freq_week_day            CHAR(1)
            lpad(' ',1,' '),
--   v_PS_Freq_Start_month        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_holiday_status        CHAR(1)
            ' ',
-- v_SWIFT_statement_serial_num        CHAR(5)
            lpad(' ',5,' '),
--   v_PS_despatch_mode            CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_frequency_type        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_number        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_day        CHAR(1)
            lpad(' ',1,' '),
--   v_Swift_Freq_Start_Day        CHAR(2)
            lpad(' ',2,' '),
-- v_SWIFT_freq_holiday_status        CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_type            CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_receiver_bic        CHAR(12)
            lpad(' ',12,' '),
--   v_Address_type             CHAR(12)
            lpad(' ',12,' '),
-- v_Phone_type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_type                 CHAR(12)   
            lpad(' ',12,' '),
--Alternate authorized signatory name
            lpad(' ',80,' ')            
from scpf
inner join map_acc on scab=leg_branch_id and scan=leg_scan and scas=leg_scas
left join otpf on map_acc.LEG_ACC_NUM=trim(otbrnm)||trim(otdlp)||trim(otdlr)
inner join map_cif on map_cif.fin_cif_id=map_acc.fin_cif_id
INNER join GUARANTOR_customer GTR on TRIM(GTR.LOC)=map_cif.gfcus and nvl(TRIM(GTR.CUSTOMER),' ')=nvl(maP_cif.gfclc,' ')
INNER join map_cif_JOINT relation on trim(nvl(trim(cid_no),nvl(trim(COMMERCIAL_REG),passport_no)))=trim(relation.doc_id) and trim(relation.cif_name)=trim(GUARANTOR_NAME)
--MAP_CIF.GFCUS = relation.gfcus and nvl(MAP_CIF.GFCLC,' ') = nvl(relation.gfclc,' ') AND RELATION.CIF_NAME=GUARANTOR_NAME and PRIM_GFCUS='GTR'
where  scaig5='Y'  and schm_type<>'OOO';
COMMIT;
---POA IN DOC SAFE FOR WHICH POA CIF NOT AVAIALBLE BUT ONLY NAME AND CID AVAIALBLE----
insert into AC2_O_TABLE  
select distinct
--   v_Account_Number             CHAR(16)
            rpad(map_acc.fin_acc_num,16,' '),
-- v_Currency                  CHAR(3)
           lpad(scpf.scccy,3,' '),
--   v_Service_Outlet              CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_Record_Type             CHAR(1)
            lpad('P',1,' '),
--   v_Name                 CHAR(80)            
			rpad(case when trim(RELATION.CIF_NAME) is not null then to_char(trim(RELATION.CIF_NAME))
			else 'ZZZ' end,80,' '),
--   v_Designation             CHAR(5)
            lpad(' ',5,' '),
--   v_Amount_allowed              CHAR(17)
            lpad(' ',17,' '),
--   v_Start_Date              CHAR(8)
            --lpad(' ',10,' '),
			case 
			when schm_type in ('TDA','CLA','LAA') and otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then  rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') 
			when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' then
            lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else lpad(' ',10,' ')
			end,
--   v_End_Date                 CHAR(8)
    '31-12-2099',
--   v_CIF_ID                 CHAR(32)
            lpad(relation.fin_cif_id,32,' '),
--   v_Relation_Code            CHAR(5)
          --  lpad('REP',5,' '),
          lpad('47',5,' '),
-- v_Pass_Sheet_flag              CHAR(1)
            'Y',
--   v_Standing_Instruction_ad_flag      CHAR(1)
            'Y',
-- v_TD_Maturity_Notice_Flag          CHAR(1)
            'Y',
--   v_Loan_Overdue_Notice_Flag        CHAR(1)
            'Y',
--   v_Communication_Address_1        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_Address_2        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_Address_3        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_City_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_State_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_Pin_Code        CHAR(6)
            lpad(' ',10,' '),
--   v_Communication_Country        CHAR(5)
            lpad(' ',5,' '),
-- v_Communication_Phone_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_FAX_Number        CHAR(15)
            lpad(' ',15,' '),
-- v_Communication_Telex_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_Email_Id        CHAR(50)
            lpad(' ',50,' '),
--   v_Exclude_for_combined_stateme    CHAR(1)
            'Y',
--   v_Statement_CIF_Id            CHAR(32)
            lpad(' ',32,' '),
--   v_Customer_Title_Code        CHAR(5)
            rpad('ZZZ',5,' '),
-- v_Incert_print_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Incert_adv_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Guarantor_liab_Pcnt        CHAR(8)
            lpad(' ',8,' '),
--   v_Guarantor_liab_sequence        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_type             CHAR(1)
            lpad(' ',1,' '),
--   v_PS_freq_week_num            CHAR(1)
        lpad(' ',1,' ') ,
--   v_PS_freq_week_day            CHAR(1)
            lpad(' ',1,' '),
--   v_PS_Freq_Start_month        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_holiday_status        CHAR(1)
            ' ',
-- v_SWIFT_statement_serial_num        CHAR(5)
            lpad(' ',5,' '),
--   v_PS_despatch_mode            CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_frequency_type        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_number        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_day        CHAR(1)
            lpad(' ',1,' '),
--   v_Swift_Freq_Start_Day        CHAR(2)
            lpad(' ',2,' '),
-- v_SWIFT_freq_holiday_status        CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_type            CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_receiver_bic        CHAR(12)
            lpad(' ',12,' '),
--   v_Address_type             CHAR(12)
            lpad(' ',12,' '),
-- v_Phone_type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_type                 CHAR(12)   
            lpad(' ',12,' '),
--Alternate authorized signatory name
            lpad(' ',80,' ')            
from scpf
inner join map_acc on scab=leg_branch_id and scan=leg_scan and scas=leg_scas
left join otpf on map_acc.LEG_ACC_NUM=trim(otbrnm)||trim(otdlp)||trim(otdlr)
inner join map_cif on map_cif.fin_cif_id=map_acc.fin_cif_id
INNER join poa_customer poa on poa.gfcus=map_cif.gfcus and nvl(poa.gfclc,' ')=nvl(maP_cif.gfclc,' ')
INNER join map_cif_JOINT relation on  trim(poa.BGDIRL)=trim(relation.doc_id) and trim(relation.cif_name)=trim(BGRLNM)
--MAP_CIF.GFCUS = relation.gfcus and nvl(MAP_CIF.GFCLC,' ') = nvl(relation.gfclc,' ') AND RELATION.CIF_NAME=BGRLNM and PRIM_GFCUS='POA' 
where  scai92='Y' and schm_type<>'OOO';	
COMMIT;
--GUARANTOR CIF RELATIONSHIP ADDED WHICH IS MAIL RECEIVED FROM VIJAY ON 13-06-2017--
insert into AC2_O_TABLE  
select distinct
--   v_Account_Number             CHAR(16)
            rpad(map_acc.fin_acc_num,16,' '),
-- v_Currency                  CHAR(3)            
			lpad(map_acc.Currency,3,' '),
--   v_Service_Outlet              CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_Record_Type             CHAR(1)
            lpad('G',1,' '),
--   v_Name                 CHAR(80)
            lpad(' ',80,' '),
--   v_Designation             CHAR(5)
            lpad(' ',5,' '),
--   v_Amount_allowed              CHAR(17)
            lpad(' ',17,' '),
--   v_Start_Date              CHAR(8)
            --lpad(' ',10,' '),
			case 
			when map_acc.schm_type in ('TDA','CLA','LAA') and otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then  rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') 
			when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' then
            lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else lpad(' ',10,' ')
			end,
--   v_End_Date                 CHAR(8)
    '31-12-2099',
--   v_CIF_ID                 CHAR(32)
            lpad(relation.FIN_CIF_ID,32,' '),
--   v_Relation_Code            CHAR(5)          
          --lpad(RJREL,5,' '),
		  lpad('43',5,' '),
-- v_Pass_Sheet_flag              CHAR(1)
            'Y',
--   v_Standing_Instruction_ad_flag      CHAR(1)
            'Y',
-- v_TD_Maturity_Notice_Flag          CHAR(1)
            'Y',
--   v_Loan_Overdue_Notice_Flag        CHAR(1)
            'Y',
--   v_Communication_Address_1        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_Address_2        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_Address_3        CHAR(45)
            lpad(' ',45,' '),
--   v_Communication_City_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_State_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_Pin_Code        CHAR(6)
            lpad(' ',10,' '),
--   v_Communication_Country        CHAR(5)
            lpad(' ',5,' '),
-- v_Communication_Phone_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_FAX_Number        CHAR(15)
            lpad(' ',15,' '),
-- v_Communication_Telex_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_Email_Id        CHAR(50)
            lpad(' ',50,' '),
--   v_Exclude_for_combined_stateme    CHAR(1)
            'Y',
--   v_Statement_CIF_Id            CHAR(32)
            lpad(' ',32,' '),
--   v_Customer_Title_Code        CHAR(5)
--            rpad(convert_codes('SALUT',DT36.A1280),5,' '),
            rpad(' ',5,' '),
-- v_Incert_print_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Incert_adv_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Guarantor_liab_Pcnt        CHAR(8)
            lpad(' ',8,' '),
--   v_Guarantor_liab_sequence        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_type             CHAR(1)
            lpad(' ',1,' '),
--   v_PS_freq_week_num            CHAR(1)
        lpad(' ',1,' ') ,
--   v_PS_freq_week_day            CHAR(1)
            lpad(' ',1,' '),
--   v_PS_Freq_Start_month        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_holiday_status        CHAR(1)
            ' ',
-- v_SWIFT_statement_serial_num        CHAR(5)
            lpad(' ',5,' '),
--   v_PS_despatch_mode            CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_frequency_type        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_number        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_day        CHAR(1)
            lpad(' ',1,' '),
--   v_Swift_Freq_Start_Day        CHAR(2)
            lpad(' ',2,' '),
-- v_SWIFT_freq_holiday_status        CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_type            CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_receiver_bic        CHAR(12)
            lpad(' ',12,' '),
--   v_Address_type             CHAR(12)
            lpad(' ',12,' '),
-- v_Phone_type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_type                 CHAR(12)   
            lpad(' ',12,' '),
--Alternate authorized signatory name
            lpad(' ',80,' ')            
from RETAIL_GUAR_ACCOUNT
inner join map_acc on map_acc.EXTERNAL_ACC= EXTERNAL_ACCOUNT
inner join scpf on scab=map_acc.leg_branch_id and scan=map_acc.leg_scan and scas=map_acc.leg_scas
left join otpf on map_acc.LEG_ACC_NUM=trim(otbrnm)||trim(otdlp)||trim(otdlr)
inner join map_acc relation on trim(replace(GUARANTOR_ACCOUNT,'-',''))=relation.EXTERNAL_ACC
where map_acc.schm_type <> 'OOO';
COMMIT;
----------------------Guardian from map_cif_joint----------------------
insert into AC2_O_TABLE  
select distinct
--   v_Account_Number             CHAR(16)
            rpad(map_acc.fin_acc_num,16,' '),
-- v_Currency                  CHAR(3)
           lpad(scpf.scccy,3,' '),
--   v_Service_Outlet              CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_Record_Type             CHAR(1)
            lpad('O',1,' '),---------changed from p to o as per vijay confirmation on 02-08-2017. guardian record type is not avaialble in Finacle hence changed to o others.
--   v_Name                 CHAR(80)            
			rpad(case when trim(RELATION.CIF_NAME) is not null then to_char(trim(RELATION.CIF_NAME))
			else 'ZZZ' end,80,' '),
--   v_Designation             CHAR(5)
            lpad(' ',5,' '),
--   v_Amount_allowed              CHAR(17)
            lpad(' ',17,' '),
--   v_Start_Date              CHAR(8)
            --lpad(' ',10,' '),
			case 
			when schm_type in ('TDA','CLA','LAA') and otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then  rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') 
			when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' then
            lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else lpad(' ',10,' ')
			end,
--   v_End_Date                 CHAR(8)
    '31-12-2099',
--   v_CIF_ID                 CHAR(32)
            lpad(relation.fin_cif_id,32,' '),
--   v_Relation_Code            CHAR(5)
          --  lpad('REP',5,' '),
          lpad('50',5,' '), --- based on discussion with vijay,nagi and sandeep on 20-08-2017 and new bpd creation modified from 42 --50
-- v_Pass_Sheet_flag              CHAR(1)
            'Y',
--   v_Standing_Instruction_ad_flag      CHAR(1)
            'Y',
-- v_TD_Maturity_Notice_Flag          CHAR(1)
            'Y',
--   v_Loan_Overdue_Notice_Flag        CHAR(1)
            'Y',
--   v_Communication_Address_1        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_Address_2        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_Address_3        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_City_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_State_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_Pin_Code        CHAR(6)
            lpad(' ',10,' '),
--   v_Communication_Country        CHAR(5)
            lpad(' ',5,' '),
-- v_Communication_Phone_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_FAX_Number        CHAR(15)
            lpad(' ',15,' '),
-- v_Communication_Telex_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_Email_Id        CHAR(50)
            lpad(' ',50,' '),
--   v_Exclude_for_combined_stateme    CHAR(1)
            'Y',
--   v_Statement_CIF_Id            CHAR(32)
            lpad(' ',32,' '),
--   v_Customer_Title_Code        CHAR(5)
            rpad('ZZZ',5,' '),
-- v_Incert_print_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Incert_adv_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Guarantor_liab_Pcnt        CHAR(8)
            lpad(' ',8,' '),
--   v_Guarantor_liab_sequence        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_type             CHAR(1)
            lpad(' ',1,' '),
--   v_PS_freq_week_num            CHAR(1)
        lpad(' ',1,' ') ,
--   v_PS_freq_week_day            CHAR(1)
            lpad(' ',1,' '),
--   v_PS_Freq_Start_month        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_holiday_status        CHAR(1)
            ' ',
-- v_SWIFT_statement_serial_num        CHAR(5)
            lpad(' ',5,' '),
--   v_PS_despatch_mode            CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_frequency_type        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_number        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_day        CHAR(1)
            lpad(' ',1,' '),
--   v_Swift_Freq_Start_Day        CHAR(2)
            lpad(' ',2,' '),
-- v_SWIFT_freq_holiday_status        CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_type            CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_receiver_bic        CHAR(12)
            lpad(' ',12,' '),
--   v_Address_type             CHAR(12)
            lpad(' ',12,' '),
-- v_Phone_type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_type                 CHAR(12)   
            lpad(' ',12,' '),
--Alternate authorized signatory name
            lpad(' ',80,' ')            
from scpf
inner join map_acc on scab=leg_branch_id and scan=leg_scan and scas=leg_scas
left join otpf on map_acc.LEG_ACC_NUM=trim(otbrnm)||trim(otdlp)||trim(otdlr)
inner join map_cif on map_cif.fin_cif_id=map_acc.fin_cif_id
inner join cu1_o_table  on map_cif.fin_cif_id =orgkey
INNER JOIN guardian_customer guar ON guar.LOC||guar.CUS=map_cif.GFCLC||map_cif.GFCUS  
INNER join map_cif_JOINT relation on trim(GUARDIAN_CID)=trim(relation.doc_id) and trim(relation.cif_name)=trim(GUARDIAN_NAME)
--MAP_CIF.GFCUS = relation.gfcus and nvl(MAP_CIF.GFCLC,' ') = nvl(relation.gfclc,' ') AND RELATION.CIF_NAME=GUARDIAN_NAME where  PRIM_GFCUS='GUAR' and schm_type<>'OOO'
where CUSTOMER_MINOR='Y' and map_acc.fin_cif_id <>  relation.fin_cif_id and schm_type <> 'OOO';
COMMIT;
----------------------Guardian from map_cif----------------------
insert into AC2_O_TABLE  
select distinct
--   v_Account_Number             CHAR(16)
            rpad(map_acc.fin_acc_num,16,' '),
-- v_Currency                  CHAR(3)
           lpad(scpf.scccy,3,' '),
--   v_Service_Outlet              CHAR(8)
            rpad(map_acc.fin_sol_id,8,' '),
--   v_Record_Type             CHAR(1)
            lpad('O',1,' '),---------changed from p to o as per vijay confirmation on 02-08-2017. guardian record type is not avaialble in Finacle hence changed to o others.
--   v_Name                 CHAR(80)            
			rpad(case when trim(RELATION.CIF_NAME) is not null then to_char(trim(RELATION.CIF_NAME))
			else 'ZZZ' end,80,' '),
--   v_Designation             CHAR(5)
            lpad(' ',5,' '),
--   v_Amount_allowed              CHAR(17)
            lpad(' ',17,' '),
--   v_Start_Date              CHAR(8)
            --lpad(' ',10,' '),
			case 
			when schm_type in ('TDA','CLA','LAA') and otsdte<>0 and   get_date_fm_btrv(otsdte) <> 'ERROR' then  rpad(to_char(to_date(get_date_fm_btrv(otsdte),'YYYYMMDD'),'DD-MM-YYYY'),10,' ') 
			when scoad <> 0 and get_date_fm_btrv(scoad) <> 'ERROR' then
            lpad(to_char(to_date(get_date_fm_btrv(scoad),'YYYYMMDD'),'DD-MM-YYYY'),10,' ')
            else lpad(' ',10,' ')
			end,
--   v_End_Date                 CHAR(8)
    '31-12-2099',
--   v_CIF_ID                 CHAR(32)
            lpad(relation.fin_cif_id,32,' '),
--   v_Relation_Code            CHAR(5)
          --  lpad('REP',5,' '),
          lpad('50',5,' '),---------changed from p to o as per vijay confirmation on 02-08-2017. guardian record type is not avaialble in Finacle hence changed to o others.
-- v_Pass_Sheet_flag              CHAR(1)
            'Y',
--   v_Standing_Instruction_ad_flag      CHAR(1)
            'Y',
-- v_TD_Maturity_Notice_Flag          CHAR(1)
            'Y',
--   v_Loan_Overdue_Notice_Flag        CHAR(1)
            'Y',
--   v_Communication_Address_1        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_Address_2        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_Address_3        CHAR(45)
            --lpad('ZZZ999',45,' '),
            lpad(' ',45,' '),---changed as per vijay confirmation on 02-04-2017
--   v_Communication_City_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_State_Code        CHAR(5)
            lpad(' ',5,' '),
--   v_Communication_Pin_Code        CHAR(6)
            lpad(' ',10,' '),
--   v_Communication_Country        CHAR(5)
            lpad(' ',5,' '),
-- v_Communication_Phone_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_FAX_Number        CHAR(15)
            lpad(' ',15,' '),
-- v_Communication_Telex_Number        CHAR(15)
            lpad(' ',15,' '),
--   v_Communication_Email_Id        CHAR(50)
            lpad(' ',50,' '),
--   v_Exclude_for_combined_stateme    CHAR(1)
            'Y',
--   v_Statement_CIF_Id            CHAR(32)
            lpad(' ',32,' '),
--   v_Customer_Title_Code        CHAR(5)
            rpad('ZZZ',5,' '),
-- v_Incert_print_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Incert_adv_flag            CHAR(1)
            lpad(' ',1,' '),
--   v_Guarantor_liab_Pcnt        CHAR(8)
            lpad(' ',8,' '),
--   v_Guarantor_liab_sequence        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_type             CHAR(1)
            lpad(' ',1,' '),
--   v_PS_freq_week_num            CHAR(1)
        lpad(' ',1,' ') ,
--   v_PS_freq_week_day            CHAR(1)
            lpad(' ',1,' '),
--   v_PS_Freq_Start_month        CHAR(2)
            lpad(' ',2,' '),
--   v_PS_freq_holiday_status        CHAR(1)
            ' ',
-- v_SWIFT_statement_serial_num        CHAR(5)
            lpad(' ',5,' '),
--   v_PS_despatch_mode            CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_frequency_type        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_number        CHAR(1)
            lpad(' ',1,' '),
--   v_SWIFT_freq_week_day        CHAR(1)
            lpad(' ',1,' '),
--   v_Swift_Freq_Start_Day        CHAR(2)
            lpad(' ',2,' '),
-- v_SWIFT_freq_holiday_status        CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_type            CHAR(1)
            lpad(' ',1,' '),
-- v_SWIFT_message_receiver_bic        CHAR(12)
            lpad(' ',12,' '),
--   v_Address_type             CHAR(12)
            lpad(' ',12,' '),
-- v_Phone_type                 CHAR(12)
            lpad(' ',12,' '),
-- v_Email_type                 CHAR(12)   
            lpad(' ',12,' '),
--Alternate authorized signatory name
            lpad(' ',80,' ')            
from scpf
inner join map_acc on scab=leg_branch_id and scan=leg_scan and scas=leg_scas
left join otpf on map_acc.LEG_ACC_NUM=trim(otbrnm)||trim(otdlp)||trim(otdlr)
inner join map_cif p on p.fin_cif_id=map_acc.fin_cif_id
inner  join guardian_customer guar on nvl(p.GFCLC,'')=nvl(trim(LOC),'') and p.GFCUS=trim(guar.cus)
inner join cu1_o_table  on p.fin_cif_id =orgkey
inner join map_cif relation on nvl(relation.GFCLC,'')=nvl(trim(guar_loc),'') and relation.GFCUS=trim(guar_cust)
where CUSTOMER_MINOR='Y' and map_acc.fin_cif_id <>  relation.fin_cif_id and schm_type <> 'OOO';
commit;
exit; 
