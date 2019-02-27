NSERT INTO DATA_VALID_O_TABLE

(

--- COLLATERALS ---

select

collateral_code CODE_VALUE,'Collateral Code needs to be created' DESCRIPTION,'Collateral' MODULE,'COLLATERAL_O_TABLE' TABLE_NAME,'Mandatory' FIELD_TYPE,'Assets' CATAGORY_TYPE

from map_collateral where collateral_code  not in (select secu_code from tbaadm.asm where bank_id = '01' )

union all

 ----  LOAN ACCOUNTS ------

select distinct(Free_Code_6) Code_Value,'FREE_CODE_6' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AF'  from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AG' and b.ref_code=trim(a.Free_Code_6) )

union all

select distinct(Free_Code_5) Code_Value,'FREE_CODE_5' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AF'  from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AF' and b.ref_code=trim(a.Free_Code_5) )

union all

select distinct(Sector_Code) Code_Value,'SECTOR_CODE' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=22'   from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='22' and b.ref_code=trim(a.sector_code) )

union all

select distinct(Industry_Type) Code_Value,'INDUSTRY_TYPE' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=18'  from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='18' and b.ref_code=trim(a.Industry_Type) )

union all

select distinct(sub_Sector_Code) Code_Value,'SUB_SECTOR_CODE' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=23'  from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='23' and b.ref_code=trim(a.sub_Sector_Code ) )

union all

select distinct(Purpose_of_Advance) Code_Value,'PURPOSE_OF_ADVANCE' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=41'  from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='41' and b.ref_code=trim(a.Purpose_of_Advance) )

union all

select distinct(Nature_of_Advance) Code_Value,'NATURE_OF_ADVANCE' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=38'  from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='38' and b.ref_code=trim(a.Nature_of_Advance) )

union all

select distinct(Free_Code_3) Code_Value,'FREE_CODE_3' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=98'  from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='98' and b.ref_code=trim(a.Free_Code_3) )

UNION ALL

select distinct(Free_Code_8) Code_Value,'FREE_CODE_8' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AI'  from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AI' and b.ref_code=trim(a.Free_Code_8) )

UNION ALL

select distinct(Free_Code_10) Code_Value,'FREE_CODE_10' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AK'  from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AK' and b.ref_code=trim(a.Free_Code_10) )

UNION ALL

select distinct(Sanction_Level_Code) CODE_VALUE,'SANCTION_LEVEL_CODE' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=11'  from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='11' and b.ref_code=trim(a.Sanction_Level_Code) )

UNION ALL

select distinct(Sanction_Authority_Code) CODE_VALUE,'SANCTION_AUTHORITY_CODE' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=12'  from devmig.lam_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='12' and b.ref_code=trim(a.Sanction_Authority_Code) )

UNION ALL

select distinct(Mode_of_Oper_Code) CODE_VALUE,'MODE_OF_OPERATION_CODE' DESCRIPTION,'LAM' MODULE,'LAM_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=27'   from devmig.LAM_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='27' and b.ref_code=trim(a.Mode_of_Oper_Code) )

------SB-CA-OD-CC-ADDRESS-------

union all

select distinct(Relation_Code) CODE_VALUE,'RELATION_CODE' DESCRIPTION,'AC2' MODULE,'AC2_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=04'  from devmig.AC2_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='04' and b.ref_code=trim(a.Relation_Code) )

union all

select distinct(Freeze_Reason_Code) CODE_VALUE,'Freeze_Reason_Code' DESCRIPTION,'AC1SBCA' MODULE,'AC1SBCA_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=31'  from devmig.AC1SBCA_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='31' and b.ref_code=trim(a.Freeze_Reason_Code)) and Freeze_Code <> ' '

UNION ALL

select distinct(Free_Code_6) Code_Value,'FREE_CODE_6' DESCRIPTION,'SBCA' MODULE,'AC1SBCA_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AF'  from devmig.ac1sbca_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AG' and b.ref_code=trim(a.Free_Code_6) )

UNION ALL

select distinct(Free_Code_5) Code_Value,'FREE_CODE_5' DESCRIPTION,'SBCA' MODULE,'AC1SBCA_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AF'  from devmig.ac1sbca_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AF' and b.ref_code=trim(a.Free_Code_5) )

UNION ALL

/*

select distinct(Security_Code) CODE_VALUE,'Security_Code' DESCRIPTION,'AC1SBCA' MODULE,'AC1SBCA_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'secu_code'  from devmig.AC1SBCA_O_TABLE a

where not exists(

select secu_code from tbaadm.ASM b where b.secu_code=trim(a.Security_Code) )

union all

*/

select distinct(scheme_code||' - '||currency_code) CODE_VALUE,'SCH || CUR CODE' DESCRIPTION,'AC1SBCA' MODULE,'ACISBCA_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'SCH | CUR COMBI.'  from devmig.AC1SBCA_O_TABLE a

where not exists(

select SCHM_CODE||CRNCY_CODE from tbaadm.csp b where  b.SCHM_CODE||b.CRNCY_CODE=trim(a.scheme_code||a.currency_code))

union all

select distinct(gl_sub_head_code||' - '||currency_code) CODE_VALUE,'GL_SUB || CUR' DESCRIPTION,'AC1SBCA' MODULE,'ACISBCA_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'GL SUB | CUR '  from devmig.AC1SBCA_O_TABLE a

where not exists(

select GL_SUB_HEAD_CODE||SOL_ID from tbaadm.GSh b where  b.GL_SUB_HEAD_CODE||b.sol_id=trim(a.GL_SUB_HEAD_CODE||a.service_outlet))

union all

select distinct(Free_Code_3) Code_Value,'FREE_CODE_3' DESCRIPTION,'SBCA' MODULE,'SBCA_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=98'  from devmig.Ac1sbca_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='98' and b.ref_code=trim(a.Free_Code_3) )


UNION ALL

select distinct(Free_Code_8) Code_Value,'FREE_CODE_8' DESCRIPTION,'SBCA' MODULE,'AC1SBCA_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AI'  from devmig.AC1SBCA_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AI' and b.ref_code=trim(a.Free_Code_8) )

UNION ALL

select distinct(Free_Code_10) Code_Value,'FREE_CODE_10' DESCRIPTION,'SBCA' MODULE,'AC1SBCA_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AK'  from devmig.AC1SBCA_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AK' and b.ref_code=trim(a.Free_Code_10) )

UNION ALL

------ODCC MASTER---------------

select distinct(Free_Code_6) Code_Value,'FREE_CODE_6' DESCRIPTION,'ODA' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AG'  from devmig.ac1odcc_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AG' and b.ref_code=trim(a.Free_Code_6) )

union all

select distinct(Free_Code_5) Code_Value,'FREE_CODE_5' DESCRIPTION,'ODA' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AF'  from devmig.ac1odcc_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AF' and b.ref_code=trim(a.Free_Code_5) )

union all

select distinct(Free_Code_3) Code_Value,'FREE_CODE_3' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=98'  from devmig.AC1ODCC_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='98' and b.ref_code=trim(a.Free_Code_3) )

union all

select distinct(Free_Code_8) Code_Value,'FREE_CODE_8' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AI'  from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AI' and b.ref_code=trim(a.Free_Code_8) )

UNION ALL

select distinct(Free_Code_10) Code_Value,'FREE_CODE_10' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=AK'  from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='AK' and b.ref_code=trim(a.Free_Code_10) )

UNION ALL

select distinct(Sector_Code) CODE_VALUE,'SECTOR_CODE' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=22'  from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='22' and b.ref_code=trim(a.Sector_Code) )

UNION ALL

select distinct(Sub_Sector_Code) CODE_VALUE,'SUB_SECTOR_CODE' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=23'   from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='23' and b.ref_code=trim(a.Sub_Sector_Code) )

UNION ALL

select distinct(Nature_Of_Advn_Code) CODE_VALUE,'NATURE_OF_ADVN_CODE' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=38'   from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='38' and b.ref_code=trim(a.Nature_Of_Advn_Code) )

UNION ALL

select distinct(Industry_Type_Code) CODE_VALUE,'INDUSTRY_TYPE_CODE' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=18'   from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='18' and b.ref_code=trim(a.Industry_Type_Code) )

UNION ALL

select distinct(Purpose_of_Advn_Code) CODE_VALUE,'PURPOSE_OF_ADVN_CODE' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=41'   from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='41' and b.ref_code=trim(a.Purpose_of_Advn_Code) )

UNION ALL

select distinct(Health_Code) CODE_VALUE,'HEALTH_CODE' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=17'   from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='17' and b.ref_code=trim(a.Health_Code) )

UNION ALL

select distinct(Sanction_Authority_Code) CODE_VALUE,'SANCTION_AUTHORITY_CODE' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory','ref_rec_type=12' Field_Type   from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='12' and b.ref_code=trim(a.Sanction_Authority_Code) )

UNION ALL

select distinct(Mode_of_Operation_Code) CODE_VALUE,'MODE_OF_OPERATION_CODE' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=27'   from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='27' and b.ref_code=trim(a.Mode_of_Operation_Code) )

UNION ALL

select distinct(Sanction_Level_Code) CODE_VALUE,'SANCTION_LEVEL_CODE' DESCRIPTION,'ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=11'   from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='11' and b.ref_code=trim(a.Sanction_Level_Code) )


UNION ALL

select distinct(Freeze_Reason_Code) CODE_VALUE,'Freeze_Reason_Code' DESCRIPTION,'AC1ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=31'  from devmig.AC1ODCC_O_TABLE a

where not exists(

select ref_code from tbaadm.rct b where Freeze_Code <> ' ' and ref_rec_type='31' and b.ref_code=trim(a.Freeze_Reason_Code) ) and Freeze_Code <> ' '

UNION ALL

select distinct(Security_Code) CODE_VALUE,'Security_Code' DESCRIPTION,'AC1ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'secu_code'  from devmig.AC1ODCC_O_TABLE a

where not exists(

select secu_code from tbaadm.ASM b where b.secu_code=trim(a.Security_Code) )


union all

select distinct(scheme_code||' - '||currency_code) code_value,'SCH || CUR CODE' description,'AC1ODCC' module,'AC1ODCC_O_TABLE' table_name, 'Mandatory' field_type,'SCH |CUR COMBI.'  from devmig.ac1odcc_o_table a

where not exists(

select SCHM_CODE||CRNCY_CODE from tbaadm.csp b where  b.SCHM_CODE||b.CRNCY_CODE=trim(a.scheme_code||a.currency_code))

union all

select distinct(gl_sub_head_code||' - '||service_outlet||' - '||currency_code) CODE_VALUE,'GL_SUB || CUR' DESCRIPTION,'AC1ODCC' MODULE,'AC1ODCC_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,' GL SUB | CUR' from devmig.AC1ODCC_O_TABLE a

where not exists(

select GL_SUB_HEAD_CODE||SOL_ID from tbaadm.GSh b where  b.GL_SUB_HEAD_CODE||b.sol_id=trim(a.GL_SUB_HEAD_CODE||a.service_outlet))

union all

select distinct(REASON_CODE_FOR_STOP_PAYMENT) Code_Value,'SPT REASON CODE' DESCRIPTION,'SPT' MODULE,'SPT_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=08'  from devmig.SPT_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='08' and b.ref_code=trim(a.REASON_CODE_FOR_STOP_PAYMENT) )

union all

select distinct(LIEN_REASON_CODE) Code_Value,'LIEN REASON CODE' DESCRIPTION,'LIEN' MODULE,'LIEN_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=BF'  from devmig.Lien_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='BF' and b.ref_code=trim(a.LIEN_REASON_CODE) )

UNION ALL

select distinct(DD_ISSUED_BRANCH_CODE) Code_Value,'DD ISSUED BRANCH CODE' DESCRIPTION,'DDS' MODULE,'DDS_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'  '  from devmig.dds_o_table a

where not exists(

select BR_code from tbaadm.bct b where  b.br_code=trim(a.DD_ISSUED_BRANCH_CODE) )

UNION ALL

select  sadrf Code_Value ,'Invalid DD Number' ,'DDS','DDS_O_TABLE','Mandatory','DD Number Validation' from map_ddrec2 where  dd_num_chk(sadrf) = 0

union all

select  sadrf Code_Value,'Invalid DD Number' ,'DDS','DDS_O_TABLE','Mandatory','DD Number Validation' from ddrec2 where  dd_num_chk(sadrf) = 0

union all

-----------TAM MASTER--------------------

select distinct(MODE_OF_OPERATION )  CODE_VALUE, 'MODE_OF_OPERATION' DESCRIPTION, 'TAM' MODULE, 'tdmasterplacements_o_table' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=27' from tdmasterplacements_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='27' and b.ref_code=trim(a.MODE_OF_OPERATION) )

UNION ALL

select distinct(ACCOUNT_LOCATION_CODE)  CODE_VALUE,('ACCOUNT_LOCATION_CODE') DESCRIPTION , 'TAM' MODULE, 'tdmasterplacements_o_table' TABLE_NAME, 'Optional' Field_Type,'ref_rec_type=19' from tdmasterplacements_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='19' and b.ref_code=trim(a.ACCOUNT_LOCATION_CODE) )

UNION ALL

select distinct(ACCOUNT_LOCATION_CODE)  CODE_VALUE,('ACCOUNT_LOCATION_CODE') DESCRIPTION , 'ODCC' MODULE, 'ac1odcc_o_table' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=19' from tdmasterplacements_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='19' and b.ref_code=trim(a.ACCOUNT_LOCATION_CODE) )

UNION ALL

select distinct(ACCOUNT_LOCATION_CODE)  CODE_VALUE,('ACCOUNT_LOCATION_CODE') DESCRIPTION , 'ODCC' MODULE, 'ac1sbca_o_table' TABLE_NAME, 'Mandatory' Field_Type,'ref_rec_type=19' from tdmasterplacements_o_table a

where not exists(

select ref_code from tbaadm.rct b where ref_rec_type='19' and b.ref_code=trim(a.ACCOUNT_LOCATION_CODE) )

UNION ALL

--select distinct(CHANNEL_ID )  CODE_VALUE,'CHANNEL_ID' DESCRIPTION,'TAM ' MODULE, 'tdmasterplacements_o_table' TABLE_NAME, 'Optional' Field_Type  from tdmasterplacements_o_table a

--where not exists(

--select ref_code from tbaadm.rct b where ref_rec_type='GB' and b.ref_code=trim(a.CHANNEL_ID) )

--UNION ALL

--select distinct(CHANNEL_LEVEL_CODE )  CODE_VALUE, 'CHANNEL_LEVEL_CODE' DESCRIPTION,'TAM ' MODULE, 'tdmasterplacements_o_table' TABLE_NAME, 'Optional' Field_Type  from tdmasterplacements_o_table a

--where not exists(

--select ref_code from tbaadm.rct b where ref_rec_type='HX' and b.ref_code=trim(a.CHANNEL_LEVEL_CODE) )

--UNION ALL

-------CU1_o_table----------

--select orgkey,'STRUSR23 = PAN and STRUSR23 = FORM60' , 'RTCIF', 'CU1_O_TABLE' , 'Mandatory' , 'BANK_ENTITY'   from cu1_o_table where trim(struserfield23)='PAN' and trim(struserfield24) like  '%FORM%'

--union all



select distinct(ENTITYTYPE)  CODE_VALUE,'ENTITYTYPE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'BANK_ENTITY'   from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'BANK_ENTITY' and value = trim(ENTITYTYPE))

UNION ALL

select distinct(CUST_TYPE_CODE)  CODE_VALUE,'CUST_TYPE_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CUST_TYPE'  from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CUST_TYPE1' and value = trim(CUST_TYPE_CODE))

UNION ALL

select distinct(SALUTATION_CODE)  CODE_VALUE,'SALUTATION_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'PERSONSALUTATION'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'PERSONSALUTATION' and value = trim(SALUTATION_CODE))


/*

select distinct safa01  CODE_VALUE,'SALUTATION_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'PERSONSALUTATION'

from safpf where trim(safa01) not in

( select distinct(trim(crmuser.category_lang.localetext)) from crmuser.categories inner join crmuser.category_lang on crmuser.category_lang.categoryid = crmuser.categories.categoryid

where crmuser.categories.categorytype = 'PERSONSALUTATION'  and crmuser.categories.bank_id = '01')

*/

UNION ALL

select distinct(OCCUPATION_CODE)  CODE_VALUE,'OCCUPATION_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CONTACT_OCCUPATION'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CONTACT_OCCUPATION' and value = trim(OCCUPATION_CODE))

UNION ALL

select distinct(NATIONALITY) CODE_VALUE,'NATIONALITY' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'NATIONALITY'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'NATIONALITY' and value = trim(NATIONALITY))

UNION ALL

select distinct(NATIVELANG_TITLE)  CODE_VALUE,'NATIVELANG_TITLE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'PERSONSALUTATION'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'PERSONSALUTATION' and value = trim(NATIVELANG_TITLE))

UNION ALL

select distinct(MINOR_GUARD_CODE)   CODE_VALUE,'MINOR_GUARD_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'MINOR_GUARD_CODE'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'MINOR_GUARD_CODE' and value = trim(MINOR_GUARD_CODE))

UNION ALL

select distinct(REGION)  CODE_VALUE,'REGION' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'REGION'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'REGION' and value = trim(REGION))

UNION ALL

select distinct(STATUS_CODE)  CODE_VALUE,'STATUS_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CUSTOMER_STATUS'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CUSTOMER_STATUS' and value = trim(STATUS_CODE))

UNION ALL

select distinct(STATUS)  CODE_VALUE,'STATUS' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CUSTOMER_STATUS' from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CUSTOMER_STATUS' and value = trim(STATUS))

UNION ALL

--select distinct(RATING_CODE)  CODE_VALUE,'RATING_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'PRIORITY_IDENTIFIER'    from devmig.cu1_o_table a

--where not exists(

--select value from crmuser.categories b where categorytype = 'PRIORITY_IDENTIFIER' and value = trim(RATING_CODE))

--UNION ALL

select distinct(CUST_COMMU_CODE )  CODE_VALUE,'CUST_COMMU_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CUST_COMMUNITY'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'COMMUNITY_CODE' and value = trim(CUST_COMMU_CODE))

UNION ALL

select distinct(CUST_HLTH )  CODE_VALUE,'CUST_HLTH' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'HEALTH_CODE'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'HEALTH_CODE' and value = trim(CUST_HLTH))

UNION ALL

select distinct(Constitution_Code )  CODE_VALUE,'CONSTITUTION_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'CONSTITUTION_CODE'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CONSTITUTION_CODE' and value = trim(Constitution_Code))

UNION ALL

Select distinct(CHARGE_LEVEL_CODE )  CODE_VALUE,'CHARGE_LEVEL_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CHARGE_LEVEL_CODE'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CHARGE_LEVEL_CODE' and value = trim(CHARGE_LEVEL_CODE))

UNION ALL

select distinct(CUST_LANGUAGE )  CODE_VALUE,'CUST_LANGUAGE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'CONTACT_LANGUAGE'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CONTACT_LANGUAGE' and value = trim(CUST_LANGUAGE))

UNION ALL

select distinct(INDUSTRY )  CODE_VALUE,'INDUSTRY' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'INDUSTRY_TYPE'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'INDUSTRY_TYPE' and value = trim(INDUSTRY))

UNION ALL

select distinct(sector )  CODE_VALUE,'SECTOR' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Manditory' Field_Type, 'SECTOR_CODE'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'SECTOR_CODE' and value = trim(sector))

UNION ALL

select distinct(subsector )  CODE_VALUE,'SUBSECTOR' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Manditory' Field_Type,'SUB_SECTOR_CODE'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'SUB_SECTOR_CODE' and value = trim(subsector))

UNION ALL

select distinct(DESIGNATION )  CODE_VALUE,'DESIGNATION' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'DESIGNATION'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'DESIGNATION' and value = trim(DESIGNATION))

UNION ALL

select distinct(PLACE_OF_BIRTH )  CODE_VALUE,'PLACE_OF_BIRTH' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CITY'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CITY' and value = trim(PLACE_OF_BIRTH))

UNION ALL

select distinct(PROOF_OF_AGE_DOCUMENT )  CODE_VALUE,'PROOF_OF_AGE_DOCUMENT' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type, 'PROOF_OF_AGE'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'PROOF_OF_AGE' and value = trim(PROOF_OF_AGE_DOCUMENT))

UNION ALL

select distinct(Country_OF_BIRTH )  CODE_VALUE,'Country_OF_BIRTH' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'COUNTRY'    from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'COUNTRY' and value = trim(Country_OF_BIRTH))

UNION ALL

--select distinct(strfield10 )  CODE_VALUE,'strfield10' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type     from devmig.cu1_o_table a

--where not exists(

--select value from crmuser.categories b where categorytype = 'RESERVE_BANK_CODES' and value = trim(strfield10))

--UNION ALL

--select distinct(strfield11 )  CODE_VALUE,'strfield11' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type     from devmig.cu1_o_table a

--where not exists(

--select value from crmuser.categories b where categorytype = 'RETURNS_CLASSIFICATION_CODE' and value = trim(strfield11))

--UNION ALL

--select distinct(strfield14 )  CODE_VALUE,'strfield14' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type      from devmig.cu1_o_table a

--where not exists(

--select value from crmuser.categories b where categorytype = 'SBG_ROLE_CATEGORY' and value = trim(strfield14))

--UNION ALL

select distinct(Segmentation_Class )  CODE_VALUE,'Segmentation_Class' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'SEGMENTATION_CLASS'  from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'SEGMENTATION_CLASS' and value = trim(Segmentation_Class))

UNION ALL

select distinct(Cust_Community )  CODE_VALUE,'Cust_Community' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'COMMUNITY_CODE'  from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'COMMUNITY_CODE' and value = trim(Cust_Community))

UNION ALL

select distinct(NativeLangTitle_code )  CODE_VALUE,'NativeLangTitle_code' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'PERSONSALUTATION'  from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'PERSONSALUTATION' and value = trim(NativeLangTitle_code))

UNION ALL

select distinct(PreferredEmailType )  CODE_VALUE,'PreferredEmailType' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'EMAIL_TYPE'      from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'EMAIL_TYPE' and value = trim(PreferredEmailType))

UNION ALL

select distinct(PREFERRED_CHANNEL_ID )  CODE_VALUE,'PREFERRED_CHANNEL_ID' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'EMAIL_TYPE'      from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CHANNEL_AVABLE' and value = trim(PREFERRED_CHANNEL_ID))

UNION ALL

select distinct(PreferredPhone )  CODE_VALUE,'PreferredPhone' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'EMAIL_TYPE'      from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'EMAIL_TYPE' and value = trim(PreferredPhone))

UNION ALL

select distinct(SUBSEGMENT )  CODE_VALUE,'SUBSEGMENT' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'SUB_SEGMENT' from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'SUB_SEGMENT' and value = trim(SUBSEGMENT))

UNION ALL

--select distinct(StrUserField13 )  CODE_VALUE,'StrUserField13' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type      from devmig.cu1_o_table a

--where not exists(

--select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(StrUserField13))

--UNION ALL

--select distinct(StrUserField22 )  CODE_VALUE,'StrUserField22' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type      from devmig.cu1_o_table a

--where not exists(

--select value from crmuser.categories b where categorytype = 'INSIDER_RELATIONSHIP_TYPE' and value = trim(StrUserField22))

--UNION ALL

/*

select distinct(ASSET_CLASSIFICATION )  CODE_VALUE,'ASSET_CLASSIFICATION' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'TYPE_OF_ASSET'  from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'TYPE_OF_ASSET' and value = trim(ASSET_CLASSIFICATION))

UNION ALL

*/

select distinct(tds_tbl_code)  CODE_VALUE,'TDS_TBL_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type, 'TAX_SLAB'   from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'TAX_SLAB' and value = trim(tds_tbl_code))

UNION ALL

select distinct(primary_sol_id)  CODE_VALUE,'PRIMARY_SOL_ID' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type, 'SERVICE_OUTLET'   from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'SERVICE_OUTLET' and value = trim(primary_sol_id))

UNION ALL

select distinct(COUNTRY )  CODE_VALUE,'COUNTRY' DESCRIPTION,'RTCIF ' MODULE, 'CU1_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'COUNTRY'  from devmig.cu1_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'COUNTRY' and value = trim(COUNTRY))

UNION ALL

-----------CU2_o_TABLE-------------

Select distinct(ADDRESSCATEGORY)  CODE_VALUE,'ADDRESSCATEGORY' DESCRIPTION,'RTCIF ' MODULE, 'CU2_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'ORG_ADDRESS_TYPE'   from devmig.cu2_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'ORG_ADDRESS_TYPE' and value = trim(ADDRESSCATEGORY))

UNION ALL

Select distinct(ADDRESSCATEGORY)  CODE_VALUE,'ADDRESSCATEGORY' DESCRIPTION,'CORPCIF ' MODULE, 'cu2crop_o_table' TABLE_NAME, 'Mandatory' Field_Type,'CORP_ADDRESS'   from devmig.cu2crop_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CORP_ADDRESS' and value = trim(ADDRESSCATEGORY))


UNION ALL

select distinct(CITY_CODE)  CODE_VALUE,'CITY_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU2_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'CITY'   from devmig.cu2_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CITY' and value = trim(CITY_CODE))

--select distinct safa07 code_value,'CITY_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU2_O_TABLE' TABLE_NAME, 'Manditory' Field_Type,'CITY'

--from safpf where trim(safa07) not in

--( select distinct(trim(crmuser.category_lang.localetext)) from crmuser.categories inner join crmuser.category_lang on crmuser.category_lang.categoryid = crmuser.categories.categoryid

--where crmuser.categories.categorytype = 'CITY' and crmuser.categories.bank_id = '01')

UNION ALL

select distinct(STATE_CODE )  CODE_VALUE,'STATE_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU2_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'STATE'  from devmig.cu2_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'STATE' and value = trim(STATE_CODE))

--safpf.safa08

--select distinct safa08 code_value,'STATE_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU2_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'STATE'

--from safpf where trim(safa08) not in

--( select distinct(trim(crmuser.category_lang.localetext)) from crmuser.categories inner join crmuser.category_lang on crmuser.category_lang.categoryid = crmuser.categories.categoryid

--where crmuser.categories.categorytype = 'STATE'  and crmuser.categories.bank_id = '01')


UNION ALL

select distinct(COUNTRY_CODE )  CODE_VALUE,'COUNTRY_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU2_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'COUNTRY'  from devmig.cu2_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'COUNTRY' and value = trim(COUNTRY_CODE))

--safpf.safa09

--select distinct safa09 code_value,'COUNTRY_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU2_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'COUNTRY'

--from safpf where trim(safa09) not in

--( select distinct(trim(crmuser.category_lang.localetext)) from crmuser.categories inner join crmuser.category_lang on crmuser.category_lang.categoryid = crmuser.categories.categoryid

--where crmuser.categories.categorytype = 'COUNTRY'  and crmuser.categories.bank_id = '01')


UNION ALL

select distinct(HoldMailInitiatedBy )  CODE_VALUE,'HoldMailInitiatedBy' DESCRIPTION,'RTCIF ' MODULE, 'CU2_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'HOLD_MAIL_INITIATED_BY' from devmig.cu2_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'HOLD_MAIL_INITIATED_BY' and value = trim(HoldMailInitiatedBy))

UNION ALL

----------CU3_o_TABLE----------------

select distinct(EmployerID )  CODE_VALUE,'EmployerID' DESCRIPTION,'RTCIF ' MODULE, 'CU3_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'EMPLOYER_ID'  from devmig.cu3_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'EMPLOYER_ID' and value = trim(EmployerID))

UNION ALL

select distinct(CUSTOMERCURRENCY)  CODE_VALUE,'CUSTOMERCURRENCY' DESCRIPTION,'RTCIF ' MODULE, 'CU3_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'  from devmig.CU3_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CUSTOMERCURRENCY))

UNION ALL

select distinct(STRTEXT10)  CODE_VALUE,'STRTEXT10_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU3_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'       from devmig.cu3_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(STRTEXT10))

--UNION ALL

--select distinct(STRTEXT2_CODE )  CODE_VALUE,'STRTEXT2_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU3_O_TABLE' TABLE_NAME, 'Optional' Field_Type       from devmig.cu3_o_table a

--where not exists(

--select value from crmuser.categories b where categorytype = 'CONTACT_OCCUPATION' and value = trim(STRTEXT2_CODE))

UNION ALL

------------CU4_o_TABLE-------------

select distinct(JHDSG), 'RELATION CODE', 'CU4_LOAD','CU4_O_TABLE','RELATION', 'CRM_Category_type = RELATION' from cajhpf where trim(JHDSG) not in

(

select distinct crmuser.category_lang.localetext from CRMUSER.category_lang inner join crmuser.categories on crmuser.categories.categoryid = CRMUSER.category_lang.categoryid

where crmuser.categories.categorytype='RELATION' and crmuser.categories.bank_id = '01'

)

and jhsrn <>1

union all

select distinct(RELATIONSHIP )  CODE_VALUE,'RELATIONSHIP' DESCRIPTION,'RTCIF ' MODULE, 'CU4_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type, 'RELATION'  from devmig.cu4_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'RELATION' and value = trim(RELATIONSHIP))

UNION ALL

select distinct(TITLE )  CODE_VALUE,'TITLE' DESCRIPTION,'RTCIF ' MODULE, 'CU4_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'PERSONSALUTATION'  from devmig.cu4_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'PERSONSALUTATION' and value = trim(TITLE))

UNION ALL

select distinct(GENDER )  CODE_VALUE,'GENDER' DESCRIPTION,'RTCIF ' MODULE, 'CU4_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'GENDER'       from devmig.cu4_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'GENDER' and value = trim(GENDER))

UNION ALL

select distinct(GAURDIANTYPE )  CODE_VALUE,'GAURDIANTYPE' DESCRIPTION,'RTCIF ' MODULE, 'CU4_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'MINOR_GUARD_CODE'  from devmig.cu4_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'MINOR_GUARD_CODE' and value = trim(GAURDIANTYPE))

UNION ALL

select distinct(RELATIONSHIP_CATEGORY )  CODE_VALUE,'RELATIONSHIP_CATEGORY' DESCRIPTION,'RTCIF ' MODULE, 'CU4_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'RELATIONSHIP'   from devmig.cu4_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'RELATIONSHIP' and value = trim(RELATIONSHIP_CATEGORY))

UNION ALL

select distinct(COUNTRY_CODE)  CODE_VALUE,'COUNTRY_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU4_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'COUNTRY'  from devmig.cu4_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'COUNTRY' and value = trim(country_code))

union all


--------------CU5_o_TABLE-----------------

select distinct(COUNTRYOFISSUE )  CODE_VALUE,'COUNTRYOFISSUE' DESCRIPTION,'RTCIF ' MODULE, 'CU5_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type, 'COUNTRY'  from devmig.cu5_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'COUNTRY' and value = trim(COUNTRYOFISSUE))

UNION ALL

select distinct(PLACEOFISSUE )  CODE_VALUE,'PLACEOFISSUE' DESCRIPTION,'RTCIF ' MODULE, 'CU5_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'CITY'  from devmig.cu5_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'CITY' and value = trim(PLACEOFISSUE))

UNION ALL

select distinct(IDISSUEORGANISATION )  CODE_VALUE,'IDISSUEORGANISATION' DESCRIPTION,'RTCIF ' MODULE, 'CU5_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'IDISSUEDORG'  from devmig.cu5_o_table a

where not exists(

select value from crmuser.categories b where categorytype = 'IDISSUEDORG' and value = trim(IDISSUEORGANISATION))

UNION ALL

---------------CU6_o_TABLE------------------

/*

select distinct(PHONEEMAILTYPE )  CODE_VALUE,'PHONEEMAILTYPE' DESCRIPTION,'RTCIF ' MODULE, 'CU6PHONE_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'EMAIL_TYPE'  from devmig.CU6PHONE_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'EMAIL_TYPE' and value = trim(PHONEEMAILTYPE))

UNION ALL

*/

---------------CU8_o_TABLE------------------

select distinct(MARITAL_STATUS_CODE )  CODE_VALUE,'MARITAL_STATUS_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'MARITAL_STATUS' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'MARITAL_STATUS' and value = trim(MARITAL_STATUS_CODE))

UNION ALL

select distinct(EMPLOYMENT_STATUS )  CODE_VALUE,'EMPLOYMENT_STATUS' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'EMPLOYMENT_STATUS'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'EMPLOYMENT_STATUS' and value = trim(EMPLOYMENT_STATUS))

UNION ALL

select distinct(CUSTCASTE )  CODE_VALUE,'CUSTCASTE' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CASTECODE'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CASTECODE' and value = trim(CUSTCASTE))

UNION ALL

select distinct(NATIONALITY_CODE )  CODE_VALUE,'NATIONALITY_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type, 'NATIONALITY' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'NATIONALITY' and value = trim(NATIONALITY_CODE))

UNION ALL

select distinct(RESIDENCE_COUNTRY )  CODE_VALUE,'RESIDENCECOUNTRY_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'COUNTRY' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'NRECOUNTRY_TYPE' and value = trim(RESIDENCE_COUNTRY))

UNION ALL

select distinct(CUSTOMER_SEGMENT )  CODE_VALUE,'CUSTOMER_SEGMENT' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'SEGMENTATION_CLASS'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'SEGMENTATION_CLASS' and value = trim(CUSTOMER_SEGMENT))

UNION ALL

select distinct(CUSTOMER_TYPE )  CODE_VALUE,'CUSTOMER_TYPE' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type, 'ACCOUNT_TYPE' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'ACCOUNT_TYPE' and value = trim(CUSTOMER_TYPE))

UNION ALL

select distinct(NATIONALITY )  CODE_VALUE,'NATIONALITY' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Mandatory' Field_Type,'NATIONALITY'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'NATIONALITY' and value = trim(NATIONALITY))

UNION ALL

select distinct(RESIDENCE_COUNTRY )  CODE_VALUE,'RESIDENCE_COUNTRY' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'COUNTRY'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'COUNTRY' and value = trim(RESIDENCE_COUNTRY))

UNION ALL

select distinct(INCOME_NATURE )  CODE_VALUE,'INCOME_NATURE' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'INCOME_NATURE'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'INCOME_NATURE' and value = trim(INCOME_NATURE))

UNION ALL

select distinct(PAYMENT_MODE )  CODE_VALUE,'PAYMENT_MODE' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'PAYMENT_MODE'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'PAYMENT_MODE' and value = trim(PAYMENT_MODE))

UNION ALL

select distinct(CU_ANNUAL_SALARY_INCOME )  CODE_VALUE,'CU_ANNUAL_SALARY_INCOME' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_ANNUAL_SALARY_INCOME))

UNION ALL

select distinct(CU_ANNUAL_STOCK_BOND_INCOME )  CODE_VALUE,'CU_ANNUAL_STOCK_BOND_INCOME' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_ANNUAL_STOCK_BOND_INCOME))

UNION ALL

select distinct(CU_ANNUAL_OTHERS_INCOME )  CODE_VALUE,'CU_ANNUAL_OTHERS_INCOME' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_ANNUAL_OTHERS_INCOME))

UNION ALL

select distinct(CU_ANNUAL_TOTAL_INCOME )  CODE_VALUE,'CU_ANNUAL_TOTAL_INCOME' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_ANNUAL_TOTAL_INCOME))

UNION ALL

select distinct(CU_ANNUAL_OPERATING_EXP )  CODE_VALUE,'CU_ANNUAL_OPERATING_EXP' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'   from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_ANNUAL_OPERATING_EXP))

UNION ALL

select distinct(CU_ANNUAL_LOAN_INSTAL )  CODE_VALUE,'CU_ANNUAL_LOAN_INSTAL' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'       from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_ANNUAL_LOAN_INSTAL))

UNION ALL

select distinct(CU_ANNUAL_INTPROD_EXP )  CODE_VALUE,'CU_ANNUAL_INTPROD_EXP' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_ANNUAL_INTPROD_EXP))

UNION ALL

select distinct(CU_ANNUAL_EXTPROD_EXP )  CODE_VALUE,'CU_ANNUAL_EXTPROD_EXP' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_ANNUAL_EXTPROD_EXP))

UNION ALL

select distinct(CU_ANNUAL_COMMIT_EXP )  CODE_VALUE,'CU_ANNUAL_COMMIT_EXP' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_ANNUAL_COMMIT_EXP))

UNION ALL

select distinct(CU_ANNUAL_OTHER_EXP )  CODE_VALUE,'CU_ANNUAL_OTHER_EXP' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_ANNUAL_OTHER_EXP))

UNION ALL

select distinct(CU_ANNUAL_TOTAL_EXP )  CODE_VALUE,'CU_ANNUAL_TOTAL_EXP' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_ANNUAL_TOTAL_EXP))

UNION ALL

select distinct(CU_SALALLOWANCES )  CODE_VALUE,'CU_SALALLOWANCES' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_SALALLOWANCES))

UNION ALL

select distinct(CU_SALPRORATAMONTHLYINCENTI )  CODE_VALUE,'CU_SALPRORATAMONTHLYINCENTI' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_SALPRORATAMONTHLYINCENTI))

UNION ALL

select distinct(CU_SALINTERESTSUBSIDY )  CODE_VALUE,'CU_SALINTERESTSUBSIDY' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_SALINTERESTSUBSIDY))

UNION ALL

select distinct(CU_SALOTHERINCOME2 )  CODE_VALUE,'CU_SALOTHERINCOME2' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_SALOTHERINCOME2))

UNION ALL

select distinct(CU_SALOTHERINCOME3 )  CODE_VALUE,'CU_SALOTHERINCOME3' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_SALOTHERINCOME3))

UNION ALL

select distinct(CU_TOTALESTACCOUNTVALUE )  CODE_VALUE,'CU_TOTALESTACCOUNTVALUE' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_TOTALESTACCOUNTVALUE))

UNION ALL

select distinct(CU_TOTALINVESTMENT )  CODE_VALUE,'CU_TOTALINVESTMENT' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY' from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_TOTALINVESTMENT))

UNION ALL

select distinct(CU_TOTALMONTHLYDEBTSERVICE )  CODE_VALUE,'CU_TOTALMONTHLYDEBTSERVICE' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'  from devmig.CU8_O_TABLE a

where not exists(

select value from crmuser.categories b where categorytype = 'CURRENCY' and value = trim(CU_TOTALMONTHLYDEBTSERVICE))

UNION ALL

select distinct(CU_SELFEMPTAXRETURNFIELD )  CODE_VALUE,'CU_SELFEMPTAXRETURNFIELD' DESCRIPTION,'RTCIF ' MODULE, 'CU8_O_TABLE' TABLE_NAME, 'Optional' Field_Type,'CURRENCY'  from devmig.CU8_O_TABLE a

