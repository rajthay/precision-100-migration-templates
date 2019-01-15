-- File Name        : cu7_upload.sql
-- File Created for    : Upload file for cu5
-- Created By        : Jagadeesh M
-- Client            : ABK
-- Created On        : 21-05-2015
-------------------------------------------------------------------
drop table corp_document_exp_date;
create table  corp_document_exp_date as
select  SVNA4, fin_cif_id
from svpf  
inner join sxpf   on sxpf.sxseq=svpf.svseq
inner join gfpf   on trim(gfpf.gfcus) = trim(sxpf.sxcus) and nvl(trim(gfpf.GFCLC),' ')=nvl(trim(sxpf.sxclc),' ') 
inner join map_cif on trim(map_cif.gfcus) = trim(sxpf.sxcus) and nvl(trim(map_cif.GFCLC),' ')=nvl(trim(sxpf.sxclc),' ')
where sxprim='6' and MAP_CIF.INDIVIDUAL='N' and del_flg<>'Y' ;
create index corpdoc_exp_idx on corp_document_exp_date(fin_cif_id);
truncate table CU7CORP_O_TABLE;
INSERT INTO CU7CORP_O_TABLE
SELECT 
    --CORP_KEYvarchar(50) null
    map_cif.fin_cif_id,
    --CORP_REP_KEYvarchar(50) null
    '',
    --BENEFICIALOWNERKEYvarchar(50) null
    '',
    --ENTITYTYPEvarchar(50) null
    'CIFCorpCust',
    --DOCDUEDATEvarchar(11) null
    '',
    --DOCRECEIVEDDATE          varchar(11) null
     case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
    --DOCEXPIRYDATE            varchar(11) null
    case when  substr(trim(SVNA4),1,4)='IDE-' and ISDATE(substr(trim(svna4),5,8),'YYYYMMDD')<>0 and replace(trim(SVNA4),'IDE-','') is not null
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
    --DOCDELFLG                varchar(1) null
    '',
    --DOCREMARKS               varchar(255) null
    'Unique Identification Number',
    --SCANNED                  varchar(1) null
    '',
    --DOCCODE                  varchar(20) null
    'CIVID',
    --DOCDESCR                 varchar(255) null
    'Unique Identification Number',
    --REFERENCENUMBER          varchar(100) null
	case when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null
     then to_char(regexp_replace(trim(ID_CODE),'[A-Z, ,-]',''))
     else to_char(regexp_replace(trim(BGDID1),'[A-Z, ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
    --TYPE                     varchar(50) null
    '',
    --ISMANDATORY              varchar(1) null
    'N',
    --SCANREQUIRED             varchar(10) null
    '',
    --ROLE                     varchar(50) null
    '',
    --DOCTYPECODE              varchar(50) null
    'ID PROOF',
    --DOCTYPEDESCR             varchar(2000) null
    'CORPORATE',
    --MINDOCSREQD              varchar(38) null
    '',    
    --WAIVEDORDEFEREDDATE      varchar(11) null
    '',    
    --COUNTRYOFISSUE           varchar(50) null
    'KW',--- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --PLACEOFISSUE             varchar(200) null
    'KW',                     ---as per spira and vijay mail dt 10-01-2017 place of issue defaulted to KW only for civi id
    --DOCISSUEDATE             varchar(11) null
    case when length(trim(BGCODT))=8  and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017 
    --IDENTIFICATIONTYPE       varchar(50) null
    '',
    --CORE_CUST_ID             varchar(9) null
    '',
    --IS_DOCUMENT_VERIFIED     varchar(1) null
    'Y',
    --BANK_ID                  varchar(8) null
    get_param('BANK_ID'),
    --IDISSUEORGANISATION      varchar(255) null
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on nvl(trim(map_cif.GFCLC),' ')=nvl(trim(gfpf.GFCLC),' ')  and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join bgpf    on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and  trim(gfpf.GFCUS)=trim(bgpf.BGCUS )
left join corp_document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(trim(acc_no),'-','')=map_cif.fin_cif_id
where map_cif.individual='N' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'CID%' or substr(upper(trim(bgdid1)),1,4)='CID.' 
or substr(upper(trim(bgdid1)),1,3)='CDI' or substr(upper(trim(bgdid1)),1,3) like 'ID%' or  substr(trim(ID_CODE),1,3) like 'CID' ) ;
commit;
INSERT INTO CU7CORP_O_TABLE
SELECT 
    --CORP_KEYvarchar(50) null
     map_cif.fin_cif_id,
    --CORP_REP_KEYvarchar(50) null
    '',
    --BENEFICIALOWNERKEYvarchar(50) null
    '',
    --ENTITYTYPEvarchar(50) null
    'CIFCorpCust',
    --DOCDUEDATEvarchar(11) null
    '',
    --DOCRECEIVEDDATE          varchar(11) null
     case when length(trim(BGCODT))=8  and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
    --DOCEXPIRYDATE            varchar(11) null
    case when  substr(trim(SVNA4),1,4)='IDE-' and ISDATE(substr(trim(svna4),5,8),'YYYYMMDD')<>0 and replace(trim(SVNA4),'IDE-','') is not null
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
    --DOCDELFLG                varchar(1) null
    '',
    --DOCREMARKS               varchar(255) null
    'Passport Number',
    --SCANNED                  varchar(1) null
    '',
    --DOCCODE                  varchar(20) null
    'PP',
    --DOCDESCR                 varchar(255) null
    'Passport Number',
    --REFERENCENUMBER          varchar(100) null
         case when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),1,3)) ='PAS' then to_char(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),4,20))
	 when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null  then to_char(regexp_replace(trim(ID_CODE),'[ ,-]',''))
     when upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3)) ='PAS' then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
	 else to_char(regexp_replace(trim(BGDID1),'[ ,-]','')) end,---- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
    --TYPE                     varchar(50) null
    '',
    --ISMANDATORY              varchar(1) null
     'N',
    --SCANREQUIRED             varchar(10) null
    '',
    --ROLE                     varchar(50) null
    '',
    --DOCTYPECODE              varchar(50) null
    'ID PROOF',
    --DOCTYPEDESCR             varchar(2000) null
    'CORPORATE',
    --MINDOCSREQD              varchar(38) null
    '',    
    --WAIVEDORDEFEREDDATE      varchar(11) null
    '',    
    --COUNTRYOFISSUE           varchar(50) null
        case when trim(gfpf.GFCNAP)='AN' then 'AN'
              when trim(gfpf.GFCNAP)='CS' then 'CZ'    
              when trim(gfpf.GFCNAP)='WT' then 'TL'
			  when trim(gfpf.GFCNAP)='XX' then 'KW'
              when trim(GFCNAP)='CS' then 'CZ'
              when trim(GFCNAP)='DD' then 'DE'
              when trim(GFCNAP)='SU' then 'RU'
              when trim(GFCNAP) is not null then TO_CHAR(GFCNAP)
              else 'ZZZ' end, --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --PLACEOFISSUE             varchar(200) null
    case when trim(gfpf.GFCNAP)='AN' then 'AN'
              when trim(gfpf.GFCNAP)='CS' then 'CZ'    
              when trim(gfpf.GFCNAP)='WT' then 'TL'
              when trim(GFCNAP)='XX' then 'KW'
			  when trim(GFCNAP)='CS' then 'CZ'
              when trim(GFCNAP)='DD' then 'DE'
              when trim(GFCNAP)='SU' then 'RU'
              when trim(GFCNAP) is not null then TO_CHAR(GFCNAP)
              else 'ZZZ' end, --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --DOCISSUEDATE             varchar(11) null
    case when length(trim(BGCODT))=8  and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017 
    --IDENTIFICATIONTYPE       varchar(50) null
    '',
    --CORE_CUST_ID             varchar(9) null
    '',
    --IS_DOCUMENT_VERIFIED     varchar(1) null
    'Y',
    --BANK_ID                  varchar(8) null
    get_param('BANK_ID'),
    --IDISSUEORGANISATION      varchar(255) null
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS)
left join corp_document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(trim(acc_no),'-','')=map_cif.fin_cif_id
where map_cif.individual='N' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'PAS%' or  substr(trim(ID_CODE),1,3) like 'PAS') ;
commit;
INSERT INTO CU7CORP_O_TABLE
SELECT 
    --CORP_KEYvarchar(50) null
    map_cif.fin_cif_id,
    --CORP_REP_KEYvarchar(50) null
    '',
    --BENEFICIALOWNERKEYvarchar(50) null
    '',
    --ENTITYTYPEvarchar(50) null
    'CIFCorpCust',
    --DOCDUEDATEvarchar(11) null
    '',
    --DOCRECEIVEDDATE          varchar(11) null
     case when length(trim(BGCODT))=8  and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
    --DOCEXPIRYDATE            varchar(11) null
    case when  substr(trim(SVNA4),1,4)='IDE-' and ISDATE(substr(trim(svna4),5,8),'YYYYMMDD')<>0 and replace(trim(SVNA4),'IDE-','') is not null
    then to_char(to_date(substr(trim(svna4),5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
    --DOCDELFLG                varchar(1) null
    '',
    --DOCREMARKS               varchar(255) null
    'Driving Licence',
    --SCANNED                  varchar(1) null
    '',
    --DOCCODE                  varchar(20) null
    'OTH',
    --DOCDESCR                 varchar(255) null
    'Driving Licence',
    --REFERENCENUMBER          varchar(100) null
--case when ID_CODE is not null then ID_CODE else BGDID1 end,
case --when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null then to_char(regexp_replace(trim(ID_CODE),'[A-Z, ,-]',''))
     when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),1,3)) ='DRL' then to_char(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),4,20))
	 when regexp_replace(trim(BGDID1),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3)) ='DRL' then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
	 else to_char(regexp_replace(trim(BGDID1),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
    --TYPE                     varchar(50) null
    '',
    --ISMANDATORY              varchar(1) null
    'N',
    --SCANREQUIRED             varchar(10) null
    '',
    --ROLE                     varchar(50) null
    '',
    --DOCTYPECODE              varchar(50) null
    'OTHER',
    --DOCTYPEDESCR             varchar(2000) null
    'CORPORATE',
    --MINDOCSREQD              varchar(38) null
    '',    
    --WAIVEDORDEFEREDDATE      varchar(11) null
    '',    
    --COUNTRYOFISSUE           varchar(50) null
    'KW',--- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --PLACEOFISSUE             varchar(200) null
    'KW',                     
    --DOCISSUEDATE             varchar(11) null
    case when length(trim(BGCODT))=8  and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017 
    --IDENTIFICATIONTYPE       varchar(50) null
    '',
    --CORE_CUST_ID             varchar(9) null
    '',
    --IS_DOCUMENT_VERIFIED     varchar(1) null
    'Y',
    --BANK_ID                  varchar(8) null
    get_param('BANK_ID'),
    --IDISSUEORGANISATION      varchar(255) null
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS)
left join corp_document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(trim(acc_no),'-','')=map_cif.fin_cif_id
where map_cif.individual='N' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'DRL%' or  substr(trim(ID_CODE),1,3) like 'DRL') ;
commit;
INSERT INTO CU7CORP_O_TABLE
SELECT 
    --CORP_KEYvarchar(50) null
     map_cif.fin_cif_id,
    --CORP_REP_KEYvarchar(50) null
    '',
    --BENEFICIALOWNERKEYvarchar(50) null
    '',
    --ENTITYTYPEvarchar(50) null
    'CIFCorpCust',
    --DOCDUEDATEvarchar(11) null
    '',
    --DOCRECEIVEDDATE          varchar(11) null
     case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
    --DOCEXPIRYDATE            varchar(11) null
    case when  substr(trim(SVNA4),1,4)='IDE-' and ISDATE(substr(trim(svna4),5,8),'YYYYMMDD')<>0 and replace(trim(SVNA4),'IDE-','') is not null
    then to_char(to_date(substr(trim(svna4),5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
    --DOCDELFLG                varchar(1) null
    '',
    --DOCREMARKS               varchar(255) null
    'IDTypeR1',
    --SCANNED                  varchar(1) null
    '',
    --DOCCODE                  varchar(20) null
    'OTH',
    --DOCDESCR                 varchar(255) null
    'IDTypeR1',
    --REFERENCENUMBER          varchar(100) null
    --case when ID_CODE is not null then ID_CODE else BGDID1 end,
	case --when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null then to_char(regexp_replace(trim(ID_CODE),'[A-Z, ,-]',''))
     when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),1,3)) ='KWI' then to_char(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),4,20))
	 when regexp_replace(trim(BGDID1),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3)) ='KWI' then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
	 else to_char(regexp_replace(trim(BGDID1),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
    --TYPE                     varchar(50) null
    '',
    --ISMANDATORY              varchar(1) null
    'N',
    --SCANREQUIRED             varchar(10) null
    '',
    --ROLE                     varchar(50) null
    '',
    --DOCTYPECODE              varchar(50) null
    'OTHER',
    --DOCTYPEDESCR             varchar(2000) null
    'CORPORATE',
    --MINDOCSREQD              varchar(38) null
    '',    
    --WAIVEDORDEFEREDDATE      varchar(11) null
    '',    
    --COUNTRYOFISSUE           varchar(50) null
    'KW',--- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --PLACEOFISSUE             varchar(200) null
    'KW',                     
    --DOCISSUEDATE             varchar(11) null
    case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017 
    --IDENTIFICATIONTYPE       varchar(50) null
    '',
    --CORE_CUST_ID             varchar(9) null
    '',
    --IS_DOCUMENT_VERIFIED     varchar(1) null
    'Y',
    --BANK_ID                  varchar(8) null
    get_param('BANK_ID'),
    --IDISSUEORGANISATION      varchar(255) null
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf      on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(map_cif.gfclc),' ') and trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf     on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS)
left join corp_document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(trim(acc_no),'-','')=map_cif.fin_cif_id
where map_cif.individual='N' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'KWI%' or  substr(trim(ID_CODE),1,3) like 'KWI') ;
commit;
INSERT INTO CU7CORP_O_TABLE
SELECT 
    --CORP_KEYvarchar(50) null
     map_cif.fin_cif_id,
    --CORP_REP_KEYvarchar(50) null
    '',
    --BENEFICIALOWNERKEYvarchar(50) null
    '',
    --ENTITYTYPEvarchar(50) null
    'CIFCorpCust',
    --DOCDUEDATEvarchar(11) null
    '',
    --DOCRECEIVEDDATE          varchar(11) null
     case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
    --DOCEXPIRYDATE            varchar(11) null
    case when  substr(trim(SVNA4),1,4)='IDE-' and ISDATE(substr(trim(svna4),5,8),'YYYYMMDD')<>0 and replace(trim(SVNA4),'IDE-','') is not null
    then to_char(to_date(substr(trim(svna4),5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
    --DOCDELFLG                varchar(1) null
    '',
    --DOCREMARKS               varchar(255) null
    'IDTypeR4',
    --SCANNED                  varchar(1) null
    '',
    --DOCCODE                  varchar(20) null
    'CR',
    --DOCDESCR                 varchar(255) null
    'IDTypeR4',
    --REFERENCENUMBER          varchar(100) null
    --case when ID_CODE is not null then ID_CODE else BGDID1 end,
	case --when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null then to_char(regexp_replace(trim(ID_CODE),'[A-Z, ,-]',''))
	when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),1,3)) in ('REG','CRG','CID') then to_char(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),4,20))
	 when regexp_replace(trim(BGDID1),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3)) in ('REG','CRG','CID') then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
     else to_char(regexp_replace(trim(BGDID1),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
    --TYPE                     varchar(50) null
    '',
    --ISMANDATORY              varchar(1) null
    'Y',
    --SCANREQUIRED             varchar(10) null
    '',
    --ROLE                     varchar(50) null
    '',
    --DOCTYPECODE              varchar(50) null
    'ID PROOF',
    --DOCTYPEDESCR             varchar(2000) null
    'CORPORATE',
    --MINDOCSREQD              varchar(38) null
    '',    
    --WAIVEDORDEFEREDDATE      varchar(11) null
    '',    
    --COUNTRYOFISSUE           varchar(50) null
    'KW',--- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --PLACEOFISSUE             varchar(200) null
    'KW',                     
    --DOCISSUEDATE             varchar(11) null
    case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017 
    --IDENTIFICATIONTYPE       varchar(50) null
    '',
    --CORE_CUST_ID             varchar(9) null
    '',
    --IS_DOCUMENT_VERIFIED     varchar(1) null
    'Y',
    --BANK_ID                  varchar(8) null
    get_param('BANK_ID'),
    --IDISSUEORGANISATION      varchar(255) null
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(map_cif.gfclc),' ')  and trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS)
left join corp_document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(trim(acc_no),'-','')=map_cif.fin_cif_id
where map_cif.individual='N' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'REG%' or  substr(trim(ID_CODE),1,3) like 'REG') ;
commit;
-----------------Document extracted BGDID2(CR) field which is not avaialble in BGDID1------------------------
INSERT INTO CU7CORP_O_TABLE
SELECT 
    --CORP_KEYvarchar(50) null
     map_cif.fin_cif_id,
    --CORP_REP_KEYvarchar(50) null
    '',
    --BENEFICIALOWNERKEYvarchar(50) null
    '',
    --ENTITYTYPEvarchar(50) null
    'CIFCorpCust',
    --DOCDUEDATEvarchar(11) null
    '',
    --DOCRECEIVEDDATE          varchar(11) null
     case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
    --DOCEXPIRYDATE            varchar(11) null
    case when  substr(trim(SVNA4),1,4)='IDE-' and ISDATE(substr(trim(svna4),5,8),'YYYYMMDD')<>0 and replace(trim(SVNA4),'IDE-','') is not null
    then to_char(to_date(substr(trim(svna4),5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
    --DOCDELFLG                varchar(1) null
    '',
    --DOCREMARKS               varchar(255) null
    'IDTypeR4',
    --SCANNED                  varchar(1) null
    '',
    --DOCCODE                  varchar(20) null
    'CR',
    --DOCDESCR                 varchar(255) null
    'IDTypeR4',
    --REFERENCENUMBER          varchar(100) null
    --BGDID2,
	case when regexp_replace(trim(BGDID2),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID2),'[ ,-]',''),1,3)) in ('REG','CRG','CID') then to_char(substr(regexp_replace(trim(BGDID2),'[ ,-]',''),4,20))
     else to_char(regexp_replace(trim(BGDID2),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
    --TYPE                     varchar(50) null
    '',
    --ISMANDATORY              varchar(1) null
    'Y',
    --SCANREQUIRED             varchar(10) null
    '',
    --ROLE                     varchar(50) null
    '',
    --DOCTYPECODE              varchar(50) null
    'ID PROOF',
    --DOCTYPEDESCR             varchar(2000) null
    'CORPORATE',
    --MINDOCSREQD              varchar(38) null
    '',    
    --WAIVEDORDEFEREDDATE      varchar(11) null
    '',    
    --COUNTRYOFISSUE           varchar(50) null
    'KW',--- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --PLACEOFISSUE             varchar(200) null
    'KW',                     
    --DOCISSUEDATE             varchar(11) null
    case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017 
    --IDENTIFICATIONTYPE       varchar(50) null
    '',
    --CORE_CUST_ID             varchar(9) null
    '',
    --IS_DOCUMENT_VERIFIED     varchar(1) null
    'Y',
    --BANK_ID                  varchar(8) null
    get_param('BANK_ID'),
    --IDISSUEORGANISATION      varchar(255) null
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on trim(gfpf.gfclc)=trim(map_cif.gfclc) and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CU7CORP_O_TABLE on corp_key=map_cif.fin_cif_id and DOCCODE='CR'
where trim(bgdid2) is not null and map_cif.individual='N' and map_cif.del_flg<>'Y'
--and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','')
and nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--nvl added on 18-May-2017 by Kumar
and upper(trim(BGDID2)) like 'REG%' and corp_key is null ;
commit;
-----------------Document extracted gfcrf(CR) field which is not avaialble in BGDID1 and bgdid2------------------------
INSERT INTO CU7CORP_O_TABLE
SELECT 
    --CORP_KEYvarchar(50) null
     map_cif.fin_cif_id,
    --CORP_REP_KEYvarchar(50) null
    '',
    --BENEFICIALOWNERKEYvarchar(50) null
    '',
    --ENTITYTYPEvarchar(50) null
    'CIFCorpCust',
    --DOCDUEDATEvarchar(11) null
    '',
    --DOCRECEIVEDDATE          varchar(11) null
     case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
    --DOCEXPIRYDATE            varchar(11) null
    case when  substr(trim(SVNA4),1,4)='IDE-' and ISDATE(substr(trim(svna4),5,8),'YYYYMMDD')<>0 and replace(trim(SVNA4),'IDE-','') is not null
    then to_char(to_date(substr(trim(svna4),5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
    --DOCDELFLG                varchar(1) null
    '',
    --DOCREMARKS               varchar(255) null
    'IDTypeR4',
    --SCANNED                  varchar(1) null
    '',
    --DOCCODE                  varchar(20) null
    'CR',
    --DOCDESCR                 varchar(255) null
    'IDTypeR4',
    --REFERENCENUMBER          varchar(100) null
    --gfcrf,
     case when regexp_replace(trim(gfcrf),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(gfcrf),'[ ,-]',''),1,3)) in ('REG','CRG','CID') then to_char(substr(regexp_replace(trim(gfcrf),'[ ,-]',''),4,20))
     else to_char(regexp_replace(trim(gfcrf),'[ ,-]','')) end  , -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
    --TYPE                     varchar(50) null
    '',
    --ISMANDATORY              varchar(1) null
    'Y',
    --SCANREQUIRED             varchar(10) null
    '',
    --ROLE                     varchar(50) null
    '',
    --DOCTYPECODE              varchar(50) null
    'ID PROOF',
    --DOCTYPEDESCR             varchar(2000) null
    'CORPORATE',
    --MINDOCSREQD              varchar(38) null
    '',    
    --WAIVEDORDEFEREDDATE      varchar(11) null
    '',    
    --COUNTRYOFISSUE           varchar(50) null
    'KW',--- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --PLACEOFISSUE             varchar(200) null
    'KW',                     
    --DOCISSUEDATE             varchar(11) null
    case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017 
    --IDENTIFICATIONTYPE       varchar(50) null
    '',
    --CORE_CUST_ID             varchar(9) null
    '',
    --IS_DOCUMENT_VERIFIED     varchar(1) null
    'Y',
    --BANK_ID                  varchar(8) null
    get_param('BANK_ID'),
    --IDISSUEORGANISATION      varchar(255) null
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on trim(gfpf.gfclc)=trim(map_cif.gfclc) and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CU7CORP_O_TABLE on corp_key=map_cif.fin_cif_id and DOCCODE='CR'
where trim(gfcrf) is not null and map_cif.individual='N' and map_cif.del_flg<>'Y'
--and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
--and regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
and nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and nvl(regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and upper(trim(gfcrf)) like 'REG%' and corp_key is null ;
commit;
--- Document extracted BGDID2 field which is not avaialble in BGDID1--------------------------------
INSERT INTO CU7CORP_O_TABLE
SELECT 
    --CORP_KEYvarchar(50) null
    map_cif.fin_cif_id,
    --CORP_REP_KEYvarchar(50) null
    '',
    --BENEFICIALOWNERKEYvarchar(50) null
    '',
    --ENTITYTYPEvarchar(50) null
    'CIFCorpCust',
    --DOCDUEDATEvarchar(11) null
    '',
    --DOCRECEIVEDDATE          varchar(11) null
     case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
    --DOCEXPIRYDATE            varchar(11) null
    case when  substr(trim(SVNA4),1,4)='IDE-' and ISDATE(substr(trim(svna4),5,8),'YYYYMMDD')<>0 and replace(trim(SVNA4),'IDE-','') is not null
    then to_char(to_date(substr(trim(svna4),5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
    --DOCDELFLG                varchar(1) null
    '',
    --DOCREMARKS               varchar(255) null
    'IDTypeR5',
    --SCANNED                  varchar(1) null
    '',
    --DOCCODE                  varchar(20) null
    'OTH',
    --DOCDESCR                 varchar(255) null
    'IDTypeR5',
    --REFERENCENUMBER          varchar(100) null
--   BGDID2,
   to_char(regexp_replace(trim(BGDID2),'[A-Z, ,-]','')), -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
    --TYPE                     varchar(50) null
    '',
    --ISMANDATORY              varchar(1) null
    'N',
    --SCANREQUIRED             varchar(10) null
    '',
    --ROLE                     varchar(50) null
    '',
    --DOCTYPECODE              varchar(50) null
    'OTHER',
    --DOCTYPEDESCR             varchar(2000) null
    'CORPORATE',
    --MINDOCSREQD              varchar(38) null
    '',    
    --WAIVEDORDEFEREDDATE      varchar(11) null
    '',    
    --COUNTRYOFISSUE           varchar(50) null
    'KW',--- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --PLACEOFISSUE             varchar(200) null
    'KW',                     
    --DOCISSUEDATE             varchar(11) null
    case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017 
    --IDENTIFICATIONTYPE       varchar(50) null
    '',
    --CORE_CUST_ID             varchar(9) null
    '',
    --IS_DOCUMENT_VERIFIED     varchar(1) null
    'Y',
    --BANK_ID                  varchar(8) null
    get_param('BANK_ID'),
    --IDISSUEORGANISATION      varchar(255) null
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on trim(gfpf.gfclc)=trim(map_cif.gfclc) and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
where trim(bgdid2) is not null and map_cif.individual='N' and map_cif.del_flg<>'Y'
--and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','')
and nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')
and bgdid2 not in (select REFERENCENUMBER from cu7corp_o_table) ;
commit;
----------Document details extracted from GFCRF which is not avilable in BGDID1 and BGDID2-------------------------------------
INSERT INTO CU7CORP_O_TABLE
SELECT 
    --CORP_KEYvarchar(50) null
    map_cif.fin_cif_id,
    --CORP_REP_KEYvarchar(50) null
    '',
    --BENEFICIALOWNERKEYvarchar(50) null
    '',
    --ENTITYTYPEvarchar(50) null
    'CIFCorpCust',
    --DOCDUEDATEvarchar(11) null
    '',
    --DOCRECEIVEDDATE          varchar(11) null
     case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
    --DOCEXPIRYDATE            varchar(11) null
    case when  substr(trim(SVNA4),1,4)='IDE-' and ISDATE(substr(trim(svna4),5,8),'YYYYMMDD')<>0 and replace(trim(SVNA4),'IDE-','') is not null
    then to_char(to_date(substr(trim(svna4),5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
    --DOCDELFLG                varchar(1) null
    '',
    --DOCREMARKS               varchar(255) null
    'IDTypeR3',
    --SCANNED                  varchar(1) null
    '',
    --DOCCODE                  varchar(20) null
    'OTH',
    --DOCDESCR                 varchar(255) null
    'IDTypeR3',
    --REFERENCENUMBER          varchar(100) null
   --GFCRF,
   to_char(regexp_replace(trim(GFCRF),'[A-Z, ,-]','')), -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
    --TYPE                     varchar(50) null
    '',
    --ISMANDATORY              varchar(1) null
    'N',
    --SCANREQUIRED             varchar(10) null
    '',
    --ROLE                     varchar(50) null
    '',
    --DOCTYPECODE              varchar(50) null
    'OTHER',
    --DOCTYPEDESCR             varchar(2000) null
    'CORPORATE',
    --MINDOCSREQD              varchar(38) null
    '',    
    --WAIVEDORDEFEREDDATE      varchar(11) null
    '',    
    --COUNTRYOFISSUE           varchar(50) null
    'KW',--- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --PLACEOFISSUE             varchar(200) null
    'KW',                     
    --DOCISSUEDATE             varchar(11) null
    case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017 
    --IDENTIFICATIONTYPE       varchar(50) null
    '',
    --CORE_CUST_ID             varchar(9) null
    '',
    --IS_DOCUMENT_VERIFIED     varchar(1) null
    'Y',
    --BANK_ID                  varchar(8) null
    get_param('BANK_ID'),
    --IDISSUEORGANISATION      varchar(255) null
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on trim(gfpf.gfclc)=trim(map_cif.gfclc) and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
where trim(gfcrf) is not null and map_cif.individual='N' and map_cif.del_flg<>'Y'
--and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
--and regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
and nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and nvl(regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and gfcrf not in (select REFERENCENUMBER from cu7corp_o_table) ;
commit;
-----------------------------------------------------------------
INSERT INTO CU7CORP_O_TABLE
SELECT 
    --CORP_KEYvarchar(50) null
     map_cif.fin_cif_id,
    --CORP_REP_KEYvarchar(50) null
    '',
    --BENEFICIALOWNERKEYvarchar(50) null
    '',
    --ENTITYTYPEvarchar(50) null
    'CIFCorpCust',
    --DOCDUEDATEvarchar(11) null
    '',
    --DOCRECEIVEDDATE          varchar(11) null
     case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
    --DOCEXPIRYDATE            varchar(11) null
    case when  substr(trim(SVNA4),1,4)='IDE-' and ISDATE(substr(trim(svna4),5,8),'YYYYMMDD')<>0 and replace(trim(SVNA4),'IDE-','') is not null
    then to_char(to_date(substr(trim(svna4),5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
    --DOCDELFLG                varchar(1) null
    '',
    --DOCREMARKS               varchar(255) null
    'IDTypeR2',
    --SCANNED                  varchar(1) null
    '',
    --DOCCODE                  varchar(20) null
    'OTH',
    --DOCDESCR                 varchar(255) null
    'IDTypeR2',
    --REFERENCENUMBER          varchar(100) null
    --BGDID1,
	case when regexp_replace(trim(BGDID1),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3)) in ('REG','PAS','CID','DRL','KWI','GCC','RES','REG','CDI','CRG') then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
     else  to_char(regexp_replace(trim(BGDID1),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
    --TYPE                     varchar(50) null
    '',
    --ISMANDATORY              varchar(1) null
    'N',
    --SCANREQUIRED             varchar(10) null
    '',
    --ROLE                     varchar(50) null
    '',
    --DOCTYPECODE              varchar(50) null
    'OTHER',
    --DOCTYPEDESCR             varchar(2000) null
    'CORPORATE',
    --MINDOCSREQD              varchar(38) null
    '',    
    --WAIVEDORDEFEREDDATE      varchar(11) null
    '',    
    --COUNTRYOFISSUE           varchar(50) null
    'KW',--- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --PLACEOFISSUE             varchar(200) null
    'KW',                     
    --DOCISSUEDATE             varchar(11) null
    case when length(trim(BGCODT))=8 and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017 
    --IDENTIFICATIONTYPE       varchar(50) null
    '',
    --CORE_CUST_ID             varchar(9) null
    '',
    --IS_DOCUMENT_VERIFIED     varchar(1) null
    'Y',
    --BANK_ID                  varchar(8) null
    get_param('BANK_ID'),
    --IDISSUEORGANISATION      varchar(255) null
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(map_cif.gfclc),' ') and trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf  on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS)
left join corp_document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
where map_cif.individual='N' and map_cif.del_flg<>'Y' and  upper(trim(bgdid1)) not like 'PAS%' and upper(trim(bgdid1)) not like 'CID%' 
and  upper(trim(bgdid1)) not like 'DRL%' and  upper(trim(bgdid1))  not like 'KWI%' and upper(trim(bgdid1))   not like 'GCC%'
and upper(trim(bgdid1))   not  like 'RES%' and upper(trim(bgdid1))    not like 'REG%' and substr(upper(trim(bgdid1)),1,4)<>'CID.'
and  substr(upper(trim(bgdid1)),1,3)<>'CDI' and  substr(upper(trim(bgdid1)),1,3) not like 'ID%' ;
commit;
delete from CU7CORP_O_TABLE where  trim(REFERENCENUMBER) is null;
commit;
INSERT INTO CU7CORP_O_TABLE
SELECT 
    --CORP_KEYvarchar(50) null
     corp_key,
    --CORP_REP_KEYvarchar(50) null
    '',
    --BENEFICIALOWNERKEYvarchar(50) null
    '',
    --ENTITYTYPEvarchar(50) null
    'CIFCorpCust',
    --DOCDUEDATEvarchar(11) null
    '',
    --DOCRECEIVEDDATE          varchar(11) null
     RELATIONSHIP_STARTDATE,
    --DOCEXPIRYDATE            varchar(11) null
    '31-DEC-2099',
    --DOCDELFLG                varchar(1) null
    '',
    --DOCREMARKS               varchar(255) null
    'IDTypeR5',
    --SCANNED                  varchar(1) null
    '',
    --DOCCODE                  varchar(20) null
    'OTH',
    --DOCDESCR                 varchar(255) null
    'IDTypeR5',
    --REFERENCENUMBER          varchar(100) null
    'ZZZ999',
    --TYPE                     varchar(50) null
    '',
    --ISMANDATORY              varchar(1) null
    'N',
    --SCANREQUIRED             varchar(10) null
    '',
    --ROLE                     varchar(50) null
    '',
    --DOCTYPECODE              varchar(50) null
    'OTHER',
    --DOCTYPEDESCR             varchar(2000) null
    'CORPORATE',
    --MINDOCSREQD              varchar(38) null
    '',    
    --WAIVEDORDEFEREDDATE      varchar(11) null
    '',    
    --COUNTRYOFISSUE           varchar(50) null
    'KW',--- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
    --PLACEOFISSUE             varchar(200) null
    'KW',                     
    --DOCISSUEDATE             varchar(11) null
    RELATIONSHIP_STARTDATE, 
    --IDENTIFICATIONTYPE       varchar(50) null
    '',
    --CORE_CUST_ID             varchar(9) null
    '',
    --IS_DOCUMENT_VERIFIED     varchar(1) null
    'Y',
    --BANK_ID                  varchar(8) null
    get_param('BANK_ID'),
    --IDISSUEORGANISATION      varchar(255) null
    convert_codes('IDISSUEORGANISATION',' ')
from CU1CORP_O_TABLE where trim(corp_key) not in(select  corp_key from CU7CORP_O_TABLE);    
commit;
--update CU7CORP_O_TABLE set ismandatory='Y' where corp_key not in (select corp_key from cu7corp_o_table where ismandatory ='Y')
--and doccode='CR' ;
update cu7corp_o_table set ISMANDATORY = 'Y' where rowid in (
select min(rowid) from cu7corp_o_table b
where not exists(
select distinct corp_key from cu7corp_o_table a where ISMANDATORY='Y'
and a.corp_key=b.corp_key
) and b.ISMANDATORY='N' and doccode='CR'
group by corp_key 
);
commit;
--update CU7CORP_O_TABLE set ismandatory='Y' where corp_key not in (select corp_key from cu7corp_o_table where ismandatory ='Y')
--and doccode='CIVID'; 
update cu7corp_o_table set ISMANDATORY = 'Y' where rowid in (
select min(rowid) from cu7corp_o_table b
where not exists(
select distinct corp_key from cu7corp_o_table a where ISMANDATORY='Y'
and a.corp_key=b.corp_key
) and b.ISMANDATORY='N' and doccode='CIVID'
group by corp_key 
);
commit;
--update CU7CORP_O_TABLE set ismandatory='Y' where corp_key not in (select corp_key from cu7corp_o_table where ismandatory ='Y')
--and doccode='PP'; 
update cu7corp_o_table set ISMANDATORY = 'Y' where rowid in (
select min(rowid) from cu7corp_o_table b
where not exists(
select distinct corp_key from cu7corp_o_table a where ISMANDATORY='Y'
and a.corp_key=b.corp_key
) and b.ISMANDATORY='N' and doccode='PP'
group by corp_key 
);
commit;
update cu7corp_o_table set ISMANDATORY = 'Y' where rowid in (
select min(rowid) from cu7corp_o_table b
where not exists(
select distinct corp_key from cu7corp_o_table a where ISMANDATORY='Y'
and a.corp_key=b.corp_key
) and b.ISMANDATORY='N'
group by corp_key 
);
commit;
exit; 
