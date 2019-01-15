-- File Name        : cu5_upload.sql
-- File Created for    : Upload file for cu5
-- Created By        : Jagadeesh M
-- Client            : ABK
-- Created On        : 11-05-2016
-------------------------------------------------------------------
drop table document_exp_date1;
create table  document_exp_date1 as
select  SVNA4, fin_cif_id
from svpf svpf_kw 
inner join sxpf sxpf_kw  on sxpf_kw.sxseq=svpf_kw.svseq
inner join gfpf gfpf_kw  on gfpf_kw.gfcus = sxpf_kw.sxcus and gfpf_kw.gfclc = sxpf_kw.sxclc
inner join map_cif on map_cif.gfcus = sxpf_kw.sxcus and map_cif.gfclc = sxpf_kw.sxclc
where sxprim='6' and MAP_CIF.INDIVIDUAL='Y' and del_flg<>'Y' and trim(SVNA4) is not null;
drop table document_exp_date;
create table  document_exp_date as
select fin_cif_id,max(svna4) svna4 from (select distinct * from document_exp_date1) group by fin_cif_id;
create index doc_exp_idx on document_exp_date(fin_cif_id);
truncate table CU5_O_TABLE;
--Civil ID Document--
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
    case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and trim(gfpf_kw.GFCOD) is not null and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
    case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and trim(gfpf_kw.GFCOD) is not null and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null and SVNA4 is not null     
    --then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else to_char(to_date(get_param('EOD_DATE'),'DD-MM-YYYY')+2,'DD-MON-YYYY') end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'CIVID',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'Unique Identification Number',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
case when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null
     then to_char(regexp_replace(trim(ID_CODE),'[A-Z, ,-]',''))
     else to_char(regexp_replace(trim(BGDID1),'[A-Z, ,-]','')) end,
     --case when ID_CODE is not null then ID_CODE else BGDID1 end,
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'ID PROOF',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Hardcoded, need to look into the same later---as per spira and vijay mail dt 10-01-2017 place of issue defaulted to KW only for civi id
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and trim(gfpf_kw.GFCOD) is not null and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf gfpf_kw  on gfpf_kw.gfclc=map_cif.gfclc and  gfpf_kw.gfcus=map_cif.gfcus
left join  bgpf bgpf_kw on nvl(GFPF_KW.GFCLC,'')=nvl(BGPF_KW.BGCLC,'') and GFPF_KW.GFCUS=BGPF_KW.BGCUS 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(acc_no,'-','')=map_cif.fin_cif_id
where map_cif.individual='Y' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'CID%' or substr(upper(trim(bgdid1)),1,4)='CID.' 
or substr(upper(trim(bgdid1)),1,3)='CDI' or substr(upper(trim(bgdid1)),1,3) like 'ID%' or  substr(trim(ID_CODE),1,3) like 'CID'); 
--and is_joint<>'Y'-------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--- Document extracted FROM BGDID2(CID) field which is not avaialble in BGDID1--------------------------------
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null    and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'CIVID',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'Unique Identification Number',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --trim(BGDID2),
     to_char(regexp_replace(trim(BGDID2),'[A-Z, ,-]','')), -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     --'Y',--
	 'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'ID PROOF',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Hardcoded, need to look into the same later-----as per spira and vijay mail dt 10-01-2017 place of issue defaulted to KW only for civi id
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on trim(gfpf.gfclc)=trim(map_cif.gfclc) and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CU5_O_TABLE on orgkey=map_cif.fin_cif_id
where trim(bgdid2) is not null and map_cif.individual='Y' and map_cif.del_flg<>'Y'
and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','')
and (upper(trim(BGDID2)) like 'CID%' or substr(upper(trim(bgdid2)),1,4)='CID.' 
or substr(upper(trim(bgdid2)),1,3)='CDI' or substr(upper(trim(bgdid2)),1,3) like 'ID%')
and trim(orgkey) is null; 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
Commit;
--- Document extracted FROM GFCRF(CID) field which is not avaialble in BGDID1 BGDID2--------------------------------
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null    and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'CIVID',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'Unique Identification Number',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --trim(GFCRF),
	 to_char(regexp_replace(trim(GFCRF),'[A-Z, ,-]','')), -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     --'Y',--
	 'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'ID PROOF',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Hardcoded, need to look into the same later---as per spira and vijay mail dt 10-01-2017 place of issue defaulted to KW only for civi id
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on trim(gfpf.gfclc)=trim(map_cif.gfclc) and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CU5_O_TABLE on orgkey=map_cif.fin_cif_id
where trim(gfcrf) is not null and map_cif.individual='Y' and map_cif.del_flg<>'Y'
--and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
--and regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
and nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and nvl(regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and trim(orgkey) is null and (upper(trim(gfcrf)) like 'CID%' or substr(upper(trim(gfcrf)),1,4)='CID.' 
or substr(upper(trim(GFCRF)),1,3)='CDI' or substr(upper(trim(GFCRF)),1,3) like 'ID%'); 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
Commit;
--Passport Documents --
INSERT INTO CU5_O_TABLE
SELECT --    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-'  and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null  and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'PP',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'PSPOT',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     case when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(ID_CODE),'[-]',''),1,3)) ='PAS' then to_char(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),4,20))
     when upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3)) ='PAS' then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
	 else to_char(regexp_replace(trim(BGDID1),'[ ,-]','')) end,---- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
    'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'ID PROOF',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
case when gfpf_kw.GFCNAP='AN' then 'AN'
              when gfpf_kw.GFCNAP='CS' then 'CZ'    
              when gfpf_kw.GFCNAP='WT' then 'TL'
              when GFCNAP='XX' then 'KW'
			  when GFCNAP='CS' then 'CZ'
              when GFCNAP='DD' then 'DE'
              when GFCNAP='SU' then 'RU'
              when trim(GFCNAP) is not null then TO_CHAR(GFCNAP)
              else 'ZZZ' end, --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    case when gfcnap='XX' then 'KW' else to_char(nvl(GFCNAP,'ZZZ')) end,             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf gfpf_kw  on gfpf_kw.gfclc=map_cif.gfclc and  gfpf_kw.gfcus=map_cif.gfcus
left join  bgpf bgpf_kw on nvl(GFPF_KW.GFCLC,'')=nvl(BGPF_KW.BGCLC,'') and GFPF_KW.GFCUS=BGPF_KW.BGCUS 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(acc_no,'-','')=map_cif.fin_cif_id
where map_cif.individual='Y' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'PAS%' or substr(trim(ID_CODE),1,3) like 'PAS' ); 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--- Document extracted FROM BGDID2(PASS PORT) field which is not avaialble in BGDID1--------------------------------
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-'  and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null  and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'PP',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'PSPOT',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --trim(BGDID2),
	 case when upper(substr(regexp_replace(trim(BGDID2),'[ ,-]',''),1,3)) ='PAS' then to_char(substr(regexp_replace(trim(BGDID2),'[ ,-]',''),4,20))
	 else to_char(regexp_replace(trim(BGDID2),'[ ,-]','')) end,---- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
    'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'ID PROOF',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
case when gfpf_kw.GFCNAP='AN' then 'AN'
              when gfpf_kw.GFCNAP='CS' then 'CZ'    
              when gfpf_kw.GFCNAP='WT' then 'TL'
              when GFCNAP='XX' then 'KW'
			  when GFCNAP='CS' then 'CZ'
              when GFCNAP='DD' then 'DE'
              when GFCNAP='SU' then 'RU'
              when trim(GFCNAP) is not null then TO_CHAR(GFCNAP)
              else 'ZZZ' end, --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    case when trim(gfcnap)='XX' then 'KW' else to_char(nvl(GFCNAP,'ZZZ')) end,             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf  gfpf_kw on trim(gfpf_kw.gfclc)=trim(map_cif.gfclc) and  trim(gfpf_kw.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf_kw.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf_kw.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CU5_O_TABLE on orgkey=map_cif.fin_cif_id and DOCCODE='PP'
where trim(bgdid2) is not null and map_cif.individual='Y' and map_cif.del_flg<>'Y'
--and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','')
and nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--nvl added on 18-May-2017 by Kumar
and trim(orgkey) is null and trim(BGDID2) like '%PAS%'; 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--- Document extracted FROM GFCRF(pass port) field which is not avaialble in BGDID1 BGDID2--------------------------------
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-'  and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null  and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'PP',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'PSPOT',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --trim(GFCRF),
	 case when upper(substr(regexp_replace(trim(GFCRF),'[ ,-]',''),1,3)) ='PAS' then to_char(substr(regexp_replace(trim(GFCRF),'[ ,-]',''),4,20))
	 else to_char(regexp_replace(trim(GFCRF),'[ ,-]','')) end,---- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
    'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'ID PROOF',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
case when gfpf_kw.GFCNAP='AN' then 'AN'
              when gfpf_kw.GFCNAP='CS' then 'CZ'    
              when gfpf_kw.GFCNAP='WT' then 'TL'
              when GFCNAP='XX' then 'KW'
			  when GFCNAP='CS' then 'CZ'
              when GFCNAP='DD' then 'DE'
              when GFCNAP='SU' then 'RU'
              when trim(GFCNAP) is not null then TO_CHAR(GFCNAP)
              else 'ZZZ' end, --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    case when trim(gfcnap)='XX' then 'KW' else to_char(nvl(GFCNAP,'ZZZ')) end ,             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf  GFPF_KW on trim(GFPF_KW.gfclc)=trim(map_cif.gfclc) and  trim(GFPF_KW.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(GFPF_KW.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(GFPF_KW.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CU5_O_TABLE on orgkey=map_cif.fin_cif_id AND DOCCODE='PP'
where trim(gfcrf) is not null and map_cif.individual='Y' and map_cif.del_flg<>'Y'
--and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
--and regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
and nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and nvl(regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and trim(orgkey) is null and trim(GFCRF) like '%PAS%'; 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
Commit;
--- Document extracted FROM svna2(pass port) field which is not avaialble in BGDID1,BGDID2 and gfcrf--------------------------------
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-'  and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null  and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'PP',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'PSPOT',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --trim(svna2),
	 case when upper(substr(regexp_replace(trim(svna2),'[ ,-]',''),1,3)) ='PAS' then to_char(substr(regexp_replace(trim(svna2),'[ ,-]',''),4,20))
	 else to_char(regexp_replace(trim(svna2),'[ ,-]','')) end,---- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
    'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'ID PROOF',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
case when gfpf_kw.GFCNAP='AN' then 'AN'
              when gfpf_kw.GFCNAP='CS' then 'CZ'    
              when gfpf_kw.GFCNAP='WT' then 'TL'
              when GFCNAP='XX' then 'KW'
			  when GFCNAP='CS' then 'CZ'
              when GFCNAP='DD' then 'DE'
              when GFCNAP='SU' then 'RU'
              when trim(GFCNAP) is not null then TO_CHAR(GFCNAP)
              else 'ZZZ' end, --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    case when trim(gfcnap)='XX' then 'KW' else to_char(nvl(GFCNAP,'ZZZ')) end,             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from svpf svpf_kw 
inner join sxpf sxpf_kw  on sxpf_kw.sxseq=svpf_kw.svseq
inner join map_cif on map_cif.gfcus = sxpf_kw.sxcus and map_cif.gfclc = sxpf_kw.sxclc
inner join bgpf on bgcus||bgclc = map_cif.gfcus||map_cif.gfclc
inner join gfpf gfpf_kw on map_cif.gfcus||map_cif.gfclc = gfpf_kw.gfcus||gfpf_kw.gfclc
left join CU5_O_TABLE on orgkey=map_cif.fin_cif_id AND DOCCODE='PP'
where MAP_CIF.INDIVIDUAL='Y' and del_flg<>'Y'
AND TRIM(SXPRIM)='9'AND TRIM(SVNA2) IS NOT NULL 
--AND regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]','') --commented and code changed for excluding null in the search by Mr.Kumar on 14-May-2017
--AND regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','')
--and regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]','')
AND nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')
AND nvl(regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace((trim(BGDID2)),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')
and nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')
and trim(orgkey) is null; 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--Driving Licence Documents --
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null     and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'OTH',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'DRLNO',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --case when trim(ID_CODE) is not null then trim(ID_CODE) else trim(BGDID1) end,
	 case --when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null then to_char(regexp_replace(trim(ID_CODE),'[A-Z, ,-]',''))
	 when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),1,3))='DRL' then to_char(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),4,20))
	 when regexp_replace(trim(BGDID1),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3))='DRL' then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
     else to_char(regexp_replace(trim(BGDID1),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'OTHER',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf gfpf_kw  on gfpf_kw.gfclc=map_cif.gfclc and  gfpf_kw.gfcus=map_cif.gfcus
left join  bgpf bgpf_kw on nvl(GFPF_KW.GFCLC,'')=nvl(BGPF_KW.BGCLC,'') and GFPF_KW.GFCUS=BGPF_KW.BGCUS 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(acc_no,'-','')=map_cif.fin_cif_id
where map_cif.individual='Y' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'DRL%' or substr(trim(ID_CODE),1,3) like 'DRL'); 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--KWI Documents --
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null     and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'OTH',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'IDTypeR1',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --case when trim(ID_CODE) is not null then trim(ID_CODE) else trim(BGDID1) end,
	 case when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),1,3))='KWI' then to_char(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),4,20))
     when regexp_replace(trim(BGDID1),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3))='KWI' then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
	 --then to_char(regexp_replace(trim(ID_CODE),'[A-Z, ,-]',''))
     else to_char(regexp_replace(trim(BGDID1),'[A-Z, ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'OTHER',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf gfpf_kw  on gfpf_kw.gfclc=map_cif.gfclc and  gfpf_kw.gfcus=map_cif.gfcus
left join  bgpf bgpf_kw on nvl(GFPF_KW.GFCLC,'')=nvl(BGPF_KW.BGCLC,'') and GFPF_KW.GFCUS=BGPF_KW.BGCUS 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(acc_no,'-','')=map_cif.fin_cif_id
where map_cif.individual='Y' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'KWI%' or substr(trim(ID_CODE),1,3) like 'KWI') ;
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--GCC Documents --
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null     and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'GCCID',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'IDTypeR2',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --case when trim(ID_CODE) is not null then trim(ID_CODE) else trim(BGDID1) end,
	 case --when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null  then to_char(regexp_replace(trim(ID_CODE),'[A-Z, ,-]',''))
     when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),1,3))='GCC' then to_char(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),4,20))
	 when regexp_replace(trim(BGDID1),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3))='GCC' then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
	 else to_char(regexp_replace(trim(BGDID1),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'ID PROOF',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
case when gfpf_kw.GFCNAP='AN' then 'AN'
              when gfpf_kw.GFCNAP='CS' then 'CZ'    
              when gfpf_kw.GFCNAP='WT' then 'TL'
              when gfpf_kw.GFCNAP='XX' then 'KW'
			  when gfpf_kw.GFCNAP='CS' then 'CZ'
              when gfpf_kw.GFCNAP='DD' then 'DE'
              when gfpf_kw.GFCNAP='SU' then 'RU'
              when trim(gfpf_kw.GFCNAP) is not null then TO_CHAR(GFCNAP)
              else 'ZZZ' end, --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'ZZZ',             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf gfpf_kw on gfpf_kw.gfclc=map_cif.gfclc and  gfpf_kw.gfcus=map_cif.gfcus
left join  bgpf bgpf_kw on nvl(GFPF_KW.GFCLC,'')=nvl(BGPF_KW.BGCLC,'') and GFPF_KW.GFCUS=BGPF_KW.BGCUS 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(acc_no,'-','')=map_cif.fin_cif_id
where map_cif.individual='Y' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'GCC%' or substr(trim(ID_CODE),1,3) like 'GCC') ;
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--- Document extracted FROM BGDID2(GCC ID) field which is not avaialble in BGDID1--------------------------------
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null     and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'GCCID',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'IDTypeR2',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
    --trim(BGDID2),
	case  when regexp_replace(trim(BGDID2),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID2),'[ ,-]',''),1,3))='GCC' then to_char(substr(regexp_replace(trim(BGDID2),'[ ,-]',''),4,20))
	else to_char(regexp_replace(trim(BGDID2),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'ID PROOF',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
case when gfpf_kw.GFCNAP='AN' then 'AN'
              when gfpf_kw.GFCNAP='CS' then 'CZ'    
              when gfpf_kw.GFCNAP='WT' then 'TL'
              when gfpf_kw.GFCNAP='XX' then 'KW'
			  when gfpf_kw.GFCNAP='CS' then 'CZ'
              when gfpf_kw.GFCNAP='DD' then 'DE'
              when gfpf_kw.GFCNAP='SU' then 'RU'
              when trim(gfpf_kw.GFCNAP) is not null then TO_CHAR(GFCNAP)
              else 'ZZZ' end, --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'ZZZ',             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf  gfpf_kw on trim(gfpf_kw.gfclc)=trim(map_cif.gfclc) and  trim(gfpf_kw.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf_kw.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf_kw.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CU5_O_TABLE on orgkey=map_cif.fin_cif_id and DOCCODE='GCCID'
where trim(bgdid2) is not null and map_cif.individual='Y' and map_cif.del_flg<>'Y'
and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','')
and trim(orgkey) is null and trim(BGDID2) like '%GCC%'; 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
COMMIT;
--- Document extracted FROM GFCRF(gccid) field which is not avaialble in BGDID1 AND BGDID2--------------------------------
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null     and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'GCCID',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'IDTypeR2',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --trim(GFCRF),
	 case  when regexp_replace(trim(gfcrf),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(gfcrf),'[ ,-]',''),1,3))='GCC' then to_char(substr(regexp_replace(trim(gfcrf),'[ ,-]',''),4,20))
	else to_char(regexp_replace(trim(gfcrf),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'ID PROOF',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
case when gfpf_kw.GFCNAP='AN' then 'AN'
              when gfpf_kw.GFCNAP='CS' then 'CZ'    
              when gfpf_kw.GFCNAP='WT' then 'TL'
              when gfpf_kw.GFCNAP='XX' then 'KW'
			  when gfpf_kw.GFCNAP='CS' then 'CZ'
              when gfpf_kw.GFCNAP='DD' then 'DE'
              when gfpf_kw.GFCNAP='SU' then 'RU'
              when trim(gfpf_kw.GFCNAP) is not null then TO_CHAR(GFCNAP)
              else 'ZZZ' end, --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'ZZZ',             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf  GFPF_KW on trim(GFPF_KW.gfclc)=trim(map_cif.gfclc) and  trim(GFPF_KW.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(GFPF_KW.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(GFPF_KW.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CU5_O_TABLE on orgkey=map_cif.fin_cif_id AND DOCCODE='GCCID'
where trim(gfcrf) is not null and map_cif.individual='Y' and map_cif.del_flg<>'Y'
--and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
--and regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
and nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and nvl(regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and trim(orgkey) is null and trim(GFCRF) like '%GCC%'; 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
Commit;
--RES Documents --
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null     and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'OTH',            -- Hardcoded, need to look into the same later------As per dicussion with vijay and sandeep 'CR' Doccode changed to 'OTH' on 12-04-2017
--    V_DOCDESCR        CHAR(255)
    'IDTypeR3',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --case when trim(ID_CODE) is not null then trim(ID_CODE) else trim(BGDID1) end,
	 case --when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null then to_char(regexp_replace(trim(ID_CODE),'[A-Z, ,-]',''))
	 when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),1,3))='RES' then to_char(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),4,20))
	 when regexp_replace(trim(BGDID1),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3))='RES' then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
     else to_char(regexp_replace(trim(BGDID1),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'OTHER',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf gfpf_kw  on gfpf_kw.gfclc=map_cif.gfclc and  gfpf_kw.gfcus=map_cif.gfcus
left join  bgpf bgpf_kw on nvl(GFPF_KW.GFCLC,'')=nvl(BGPF_KW.BGCLC,'') and GFPF_KW.GFCUS=BGPF_KW.BGCUS 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(acc_no,'-','')=map_cif.fin_cif_id
where map_cif.individual='Y' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'RES%' or substr(trim(ID_CODE),1,3) like 'RES') ;
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--RES Documents --
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null      and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'OTH',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'IDTypeR4',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --case when trim(ID_CODE) is not null then trim(ID_CODE) else trim(BGDID1) end,
	 case --when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null then to_char(regexp_replace(trim(ID_CODE),'[A-Z, ,-]',''))
	 when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),1,3))='REG' then to_char(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),4,20))
	 when regexp_replace(trim(BGDID1),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3))='REG' then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
     else to_char(regexp_replace(trim(BGDID1),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'OTHER',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf gfpf_kw  on gfpf_kw.gfclc=map_cif.gfclc and  gfpf_kw.gfcus=map_cif.gfcus
left join  bgpf bgpf_kw on nvl(GFPF_KW.GFCLC,'')=nvl(BGPF_KW.BGCLC,'') and GFPF_KW.GFCUS=BGPF_KW.BGCUS 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(acc_no,'-','')=map_cif.fin_cif_id
where map_cif.individual='Y' and map_cif.del_flg<>'Y' and (upper(trim(BGDID1)) like 'REG%' or substr(trim(ID_CODE),1,3) like 'REG' ) ;
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--Other  Documents --
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null      and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'OTH',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'IDTypeR5',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --case when trim(ID_CODE) is not null then trim(ID_CODE) else trim(BGDID1) end,
	 case --when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null  then to_char(regexp_replace(trim(ID_CODE),'[A-Z, ,-]',''))
	 when regexp_replace(trim(ID_CODE),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),1,3)) in ('PAS','CID','DRL','KWI','GCC','RES','REG','CDI') then to_char(substr(regexp_replace(trim(ID_CODE),'[ ,-]',''),4,20))
	 when regexp_replace(trim(BGDID1),'[A-Z, ,-]','') is not null and upper(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),1,3)) in ('PAS','CID','DRL','KWI','GCC','RES','REG','CDI') then to_char(substr(regexp_replace(trim(BGDID1),'[ ,-]',''),4,20))
     else to_char(regexp_replace(trim(BGDID1),'[ ,-]','')) end, -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'OTHER',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf_kw.GFCOD <> 0  and get_date_fm_btrv(gfpf_kw.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf_kw.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf gfpf_kw  on gfpf_kw.gfclc=map_cif.gfclc and  gfpf_kw.gfcus=map_cif.gfcus
left join  bgpf bgpf_kw on nvl(GFPF_KW.GFCLC,'')=nvl(BGPF_KW.BGCLC,'') and GFPF_KW.GFCUS=BGPF_KW.BGCUS
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
left join CBD_REGID on replace(acc_no,'-','')=map_cif.fin_cif_id
where map_cif.individual='Y' and map_cif.del_flg<>'Y' and  upper(trim(bgdid1)) not like 'PAS%' and upper(trim(bgdid1)) not like 'CID%' 
and  upper(trim(bgdid1)) not like 'DRL%' and  upper(trim(bgdid1))  not like 'KWI%' and upper(trim(bgdid1))   not like 'GCC%'
and upper(trim(bgdid1))   not  like 'RES%' and upper(trim(bgdid1))    not like 'REG%' and substr(upper(trim(bgdid1)),1,4)<>'CID.'
and  substr(upper(trim(bgdid1)),1,3)<>'CDI' and  substr(upper(trim(bgdid1)),1,3) not like 'ID%' ;
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--- Document extracted FROM BGDID2 field which is not avaialble in BGDID1--------------------------------
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null    and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'OTH',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'IDTypeR3',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --trim(BGDID2),
	 to_char(regexp_replace(trim(BGDID2),'[ ,-]','')), -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'OTHER',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on trim(gfpf.gfclc)=trim(map_cif.gfclc) and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
where trim(bgdid2) is not null and map_cif.individual='Y' and map_cif.del_flg<>'Y'
--and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','')
and nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--nvl added on 18-May-2017 by Kumar
and trim(bgdid2) not in (select trim(referencenumber) from cu5_o_table); 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
Commit;
----------Document details extracted from GFCRF which is not avilable in BGDID1 and BGDID2-------------------------------------
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null    and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'OTH',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'IDTypeR3',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --trim(GFCRF),
	 to_char(regexp_replace(trim(gfcrf),'[ ,-]','')) , -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'OTHER',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from map_cif 
inner join gfpf   on trim(gfpf.gfclc)=trim(map_cif.gfclc) and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS) 
left join document_exp_date exp_date on  exp_date.fin_cif_id=map_cif.fin_cif_id
where trim(gfcrf) is not null and map_cif.individual='Y' and map_cif.del_flg<>'Y'
--and regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
--and regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','')
and nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and nvl(regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')--code changed based on Spira issue reported to Vijay on 18-May-2017
and trim(GFCRF) not in (select trim(referencenumber) from cu5_o_table); 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
Commit;
----------Document details extracted from svna2 which is not avilable in BGDID1,BGDID2 and gfcrf-------------------------------------
INSERT INTO CU5_O_TABLE
SELECT 
--    V_ORGKEY            CHAR(32)
    map_cif.fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017        
--    V_DOCRECEIVEDDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_DOCEXPIRYDATE        CHAR(17)
    case when  substr(trim(SVNA4),1,4)='IDE-' and  conv_to_valid_date(substr(trim(svna4),5,8),'YYYYMMDD') is not null    and SVNA4 is not null     
    then to_char(to_date(substr(svna4,5,8),'YYYYMMDD'),'DD-MON-YYYY')else '31-DEC-2099' end,
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'OTH',            -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'IDTypeR3',         -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
     --trim(svna2),
	 to_char(regexp_replace(trim(svna2),'[ ,-]','')), -- alpha chrecter removed as per sandeep confirmation on 06-06-2017 by mk4a observation
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'OTHER',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Hardcoded, need to look into the same later
--    V_DOCISSUEDATE        CHAR(17)
        case when length(trim(BGCODT))=8 and trim(BGCODT) is not null and conv_to_valid_date(BGCODT,'YYYYMMDD') is not null then to_char(to_date(BGCODT,'YYYYMMDD'),'DD-MON-YYYY')
when gfpf.GFCOD <> 0  and get_date_fm_btrv(gfpf.GFCOD) <> 'ERROR' then  to_char(to_date(get_date_fm_btrv(gfpf.GFCOD),'YYYYMMDD'),'DD-MON-YYYY')
end, --- changed as per vijay mail confirmation on 20-01-2017
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from svpf svpf_kw 
inner join sxpf sxpf_kw  on sxpf_kw.sxseq=svpf_kw.svseq
inner join map_cif on map_cif.gfcus = sxpf_kw.sxcus and map_cif.gfclc = sxpf_kw.sxclc
inner join bgpf on bgcus||bgclc = map_cif.gfcus||map_cif.gfclc
inner join gfpf gfpf on map_cif.gfcus||map_cif.gfclc = gfpf.gfcus||gfpf.gfclc
where MAP_CIF.INDIVIDUAL='Y' and del_flg<>'Y'
AND TRIM(SXPRIM)='9'AND TRIM(SVNA2) IS NOT NULL 
--AND regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]','') --commented and code changed for excluding null in the search by Mr.Kumar on 14-May-2017
--AND regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(BGDID2),'[-,_,&,#,A-Z, ,-,/,.]','')
--and regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]','') <> regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]','')
AND nvl(regexp_replace(trim(BGDID1),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')
AND nvl(regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace((trim(BGDID2)),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')
AND nvl(regexp_replace(trim(gfcrf),'[-,_,&,#,A-Z, ,-,/,.]',''),' ') <> nvl(regexp_replace(trim(svna2),'[-,_,&,#,A-Z, ,-,/,.]',''),' ')
and trim(svna2) not in (select trim(referencenumber) from cu5_o_table) ;
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
-------------------------POA/Guarantor/GUARDIAN Customer which is joint cif not avaialble -----------------------------------------------
--INSERT INTO CU5_O_TABLE
--SELECT  distinct 
----    V_ORGKEY            CHAR(32)
--    fin_cif_id,
----    V_DOCDUEDATE        CHAR(17)
--    '01-JAN-1900',
----    V_DOCRECEIVEDDATE        CHAR(17)
--    '01-JAN-1900',
----    V_DOCEXPIRYDATE        CHAR(17)
--     '31-DEC-2099',
----    V_DOCDELFLG        CHAR(1)
--    'N',
----    V_DOCREMARKS        CHAR(255)
--    '',
----    V_SCANNED            CHAR(1)
--    'N',
----    V_DOCCODE            CHAR(20)
--    case when PRIM_GFCUS='POA' then 'CIVID'
--	  when PRIM_GFCUS='GTR' and trim(CID_NO) is not null  then 'CIVID'
--	  when PRIM_GFCUS='GTR' and trim(COMMERCIAL_REG) is not null  then 'OTH'
--	  when PRIM_GFCUS='GTR' and trim(PASSPORT_NO) is not null  then 'PP' 
--	  when PRIM_GFCUS='GUAR' and trim(CID_NO) is not null  then 'CIVID'
--	  when PRIM_GFCUS='SHARE' and substr(regexp_replace(trim(doc_id),'[-,., ]',''),1,3)='CID'  then  'CIVID'
--	  when PRIM_GFCUS='SHARE' and substr(regexp_replace(trim(doc_id),'[-,., ]',''),1,3)='PAS'  then  'PP'
--	  when PRIM_GFCUS='SHARE' and regexp_replace(trim(doc_id),'[-,., ]','') is not null  then  'OTH'
--	  else 'CIVID' 
--	  end ,            
----    V_DOCDESCR        CHAR(255)
--    case when PRIM_GFCUS='POA' then 'Unique Identification Number'
--	  when PRIM_GFCUS='GTR' and trim(CID_NO) is not null  then 'Unique Identification Number'
--	  when PRIM_GFCUS='GTR' and trim(COMMERCIAL_REG) is not null  then 'IDTypeR4'
--	  when PRIM_GFCUS='GTR' and trim(PASSPORT_NO) is not null  then 'PSPOT' 
--	  when PRIM_GFCUS='GUAR' then 'Unique Identification Number'
--	  when PRIM_GFCUS='SHARE' and substr(regexp_replace(trim(doc_id),'[-,., ]',''),1,3)='CID'  then  'Unique Identification Number'
--	  when PRIM_GFCUS='SHARE' and substr(regexp_replace(trim(doc_id),'[-,., ]',''),1,3)='PAS'  then  'PSPOT'
--	  when PRIM_GFCUS='SHARE' and regexp_replace(trim(doc_id),'[-,., ]','') is not null  then  'IDTypeR5'
--	  else 'Unique Identification Number' end,            
----    V_REFERENCENUMBER        CHAR(100)
--      case when PRIM_GFCUS='POA' then to_char(regexp_replace(trim(BGDIRL),'[A-Z, ,-]','')) 
--	  when PRIM_GFCUS='GTR' and trim(CID_NO) is not null  then to_char(regexp_replace(trim(CID_NO),'[A-Z, ,-]',''))
--	  when PRIM_GFCUS='GTR' and trim(COMMERCIAL_REG) is not null  then to_char(regexp_replace(trim(COMMERCIAL_REG),'[A-Z, ,-]',''))
--	  when PRIM_GFCUS='GTR' and trim(PASSPORT_NO) is not null  and upper(substr(regexp_replace(trim(PASSPORT_NO),'[A-Z, ,-]',''),1,3))='PAS' then to_char(substr(regexp_replace(trim(PASSPORT_NO),'[A-Z, ,-]',''),4,20)) 
--	  when PRIM_GFCUS='GTR' and trim(PASSPORT_NO) is not null  then to_char(regexp_replace(trim(PASSPORT_NO),'[A-Z, ,-]','')) 
--	  when PRIM_GFCUS='GUAR' and trim(GUARDIAN_CID) is not null  then to_char(regexp_replace(trim(GUARDIAN_CID),'[A-Z, ,-]',''))
--	  when PRIM_GFCUS='SHARE' and  substr(regexp_replace(trim(doc_id),'[-,., ]',''),1,3)='CID' then to_char(regexp_replace(trim(doc_id),'[A-Z,-,., ]',''))
--	  when PRIM_GFCUS='SHARE' and regexp_replace(trim(doc_id),'[-,., ]','') is not null then to_char(regexp_replace(trim(doc_id),'[-,., ]',''))
--	  end,
----    V_TYPE            CHAR(50)
--    '',
----    V_ISMANDATORY        CHAR(1)
--     'N',
----    V_SCANREQUIRED        CHAR(10)
--    'N',
----    V_ROLE            CHAR(50)
--    '',
----    V_DOCTYPECODE        CHAR(50)
--      case when PRIM_GFCUS='POA' then 'ID PROOF'
--	  when PRIM_GFCUS='GTR' and trim(CID_NO) is not null  then 'ID PROOF'
--	  when PRIM_GFCUS='GTR' and trim(COMMERCIAL_REG) is not null  then 'OTHER'
--	  when PRIM_GFCUS='GTR' and trim(PASSPORT_NO) is not null  then 'ID PROOF' 
--      when PRIM_GFCUS='GUAR' then 'ID PROOF' 
--	  when PRIM_GFCUS='SHARE' and substr(regexp_replace(trim(doc_id),'[-,., ]',''),1,3)='CID'  then  'ID PROOF'
--	  when PRIM_GFCUS='SHARE' and substr(regexp_replace(trim(doc_id),'[-,., ]',''),1,3)='PAS'  then  'ID PROOF'
--	  when PRIM_GFCUS='SHARE' and regexp_replace(trim(doc_id),'[-,., ]','') is not null  then  'OTHER'
--	  else 'ID PROOF' 
--	  end,
----    V_DOCTYPEDESCR        CHAR(2000)
--      'DOCUMENTS FOR INDIVIDUALS',
----    V_MINDOCSREQD        CHAR(38)
--    '',
----    V_WAIVEDORDEFEREDDATE    CHAR(17)
--    '',
----    V_COUNTRYOFISSUE        CHAR(50)
--    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
----    V_PLACEOFISSUE        CHAR(200)
--    'ZZZ',             -- Hardcoded, need to look into the same later
----    V_DOCISSUEDATE        CHAR(17)
--        '01-JAN-1900',
----    V_IDENTIFICATIONTYPE    CHAR(50)
--    '',
----    V_CORE_CUST_ID        CHAR(9)
--    '',
----    V_IS_DOCUMENT_VERIFIED    CHAR(1)
--    'Y',
----    V_BEN_OWN_KEY        CHAR(50)
--    '',
----    V_BANK_ID            CHAR(8)
--    get_param('BANK_ID'),
----    V_DOCTYPEDESCR_ALT1    CHAR(2000)
--    '',
----    V_DOCDESCR_ALT1        CHAR(255)
--    '',
----    V_IDISSUEORGANISATION    CHAR(255)
--    convert_codes('IDISSUEORGANISATION',' ')
--FROM MAP_CIF_JOINT JNT
--LEFT JOIN (SELECT DISTINCT * FROM POA_CUSTOMER) POA ON POA.GFCLC||POA.GFCUS=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='POA' AND CIF_NAME=BGRLNM
--LEFT JOIN guarantor_customer gtr ON gtr.LOC||gtr.CUSTOMER=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='GTR' AND CIF_NAME=GUARANTOR_NAME
--LEFT JOIN guardian_customer guar ON guar.LOC||guar.CUS=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='GUAR' AND CIF_NAME=GUARDIAN_NAME
--left join (SELECT DISTINCT GFCLC,GFCUS,DOC_ID,NAME,bgclc,bgcus  FROM shareholder_retail) shr on shr.GFCLC||shr.GFCUS=JNT.GFCLC||JNT.GFCUS AND PRIM_GFCUS='SHARE' and CIF_NAME=name;
----WHERE not exists   (select 1 from document_det where NVL(regexp_replace(trim(BGDIRL),'[A-Z, ,-]',''),NVL(regexp_replace(trim(CID_NO),'[A-Z, ,-]',''),NVL(regexp_replace(trim(COMMERCIAL_REG),'[A-Z, ,-]',''),NVL(regexp_replace(trim(PASSPORT_NO),'[A-Z, ,-]',''),NVL(regexp_replace(trim(GUARDIAN_CID),'[A-Z, ,-]',''),regexp_replace(trim(doc_id),'[A-Z, ,-]',''))))))=docu)
--commit; 
-----------------------POA/Guarantor/GUARDIAN Customer which is joint cif not avaialble -----------------------------------------------
INSERT INTO CU5_O_TABLE
SELECT  distinct 
--    V_ORGKEY            CHAR(32)
    fin_cif_id,
--    V_DOCDUEDATE        CHAR(17)
    '01-JAN-1900',
--    V_DOCRECEIVEDDATE        CHAR(17)
    '01-JAN-1900',
--    V_DOCEXPIRYDATE        CHAR(17)
     '31-DEC-2099',
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    case 
      when substr(regexp_replace(trim(jnt.doc_id),'[-,., ]',''),1,3)='CID'  then  'CIVID'
	  when substr(regexp_replace(trim(jnt.doc_id),'[-,., ]',''),1,3)='PAS'  then  'PP'	
	  when trim(cid_no) =trim(jnt.doc_id)  then 'CIVID'
	  when trim(COMMERCIAL_REG)=trim(jnt.doc_id) then 'OTH'
	  when trim(PASSPORT_NO)=trim(jnt.doc_id)  then 'PP' 
	  when trim(BGDIRL)=trim(jnt.doc_id) then 'CIVID'
	  when trim(GUARDIAN_CID)=trim(jnt.doc_id) then 'CIVID'
	  else 'OTH' 
	  end ,            
--    V_DOCDESCR        CHAR(255)
    case 
	when substr(regexp_replace(trim(jnt.doc_id),'[-,., ]',''),1,3)='CID'  then  'Unique Identification Number'
	  when substr(regexp_replace(trim(jnt.doc_id),'[-,., ]',''),1,3)='PAS'  then  'PSPOT'	
	  when trim(cid_no) =trim(jnt.doc_id)  then 'Unique Identification Number'
	  when trim(COMMERCIAL_REG)=trim(jnt.doc_id) then 'IDTypeR4'
	  when trim(PASSPORT_NO)=trim(jnt.doc_id)  then 'PSPOT' 
	  when trim(BGDIRL)=trim(jnt.doc_id) then 'Unique Identification Number'
	  when trim(GUARDIAN_CID)=trim(jnt.doc_id) then 'Unique Identification Number'
	  else 'IDTypeR5' end,            
--    V_REFERENCENUMBER        CHAR(100)
case 
      when substr(regexp_replace(trim(jnt.doc_id),'[-,., ]',''),1,3)='PAS'  then  to_char(regexp_replace(trim(jnt.doc_id),'[-,., ]',''))	
	  when trim(PASSPORT_NO)=trim(jnt.doc_id)  then to_char(regexp_replace(trim(jnt.doc_id),'[-,., ]','')) 
	  else to_char(regexp_replace(trim(jnt.doc_id),'[A-Z,-,., ]','')) end,    
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
     'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
      case 
	when substr(regexp_replace(trim(jnt.doc_id),'[-,., ]',''),1,3)='CID'  then  'ID PROOF'
	  when substr(regexp_replace(trim(jnt.doc_id),'[-,., ]',''),1,3)='PAS'  then  'ID PROOF'	
	  when trim(cid_no) =trim(jnt.doc_id)  then 'ID PROOF'
	  when trim(COMMERCIAL_REG)=trim(jnt.doc_id) then 'OTHER'
	  when trim(PASSPORT_NO)=trim(jnt.doc_id)  then 'ID PROOF' 
	  when trim(BGDIRL)=trim(jnt.doc_id) then 'ID PROOF'
	  when trim(GUARDIAN_CID)=trim(jnt.doc_id) then 'ID PROOF'
	  else 'OTHER' end,
--    V_DOCTYPEDESCR        CHAR(2000)
      'DOCUMENTS FOR INDIVIDUALS',
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    case 
      when substr(regexp_replace(trim(jnt.doc_id),'[-,., ]',''),1,3)='CID'  then  'KW'
	  when substr(regexp_replace(trim(jnt.doc_id),'[-,., ]',''),1,3)='PAS'  then  'ZZZ'	
	  when trim(cid_no) =trim(jnt.doc_id)  then 'KW'
	  when trim(COMMERCIAL_REG)=trim(jnt.doc_id) then 'KW'
	  when trim(PASSPORT_NO)=trim(jnt.doc_id)  then 'ZZZ' 
	  when trim(BGDIRL)=trim(jnt.doc_id) then 'KW'
	  when trim(GUARDIAN_CID)=trim(jnt.doc_id) then 'KW'
	  else 'ZZZ' 
	  end ,                         -- Hardcoded, need to look into the same later---as per spira and vijay mail dt 10-01-2017 place of issue defaulted to KW only for civi id
--    V_DOCISSUEDATE        CHAR(17)
        '01-JAN-1900',
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'Y',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
FROM MAP_CIF_JOINT JNT
LEFT JOIN guarantor_customer gtr ON trim(nvl(trim(cid_no),nvl(trim(COMMERCIAL_REG),passport_no)))=trim(jnt.doc_id) and trim(cif_name)=trim(GUARANTOR_NAME)
LEFT JOIN (SELECT DISTINCT * FROM POA_CUSTOMER) POA ON trim(poa.BGDIRL)=trim(jnt.doc_id) and trim(cif_name)=trim(BGRLNM)
LEFT JOIN guardian_customer guar ON trim(GUARDIAN_CID)=trim(jnt.doc_id) and trim(cif_name)=trim(GUARDIAN_NAME)
left join (SELECT DISTINCT GFCLC,GFCUS,DOC_ID,NAME,bgclc,bgcus  FROM shareholder_retail) shr on trim(shr.doc_id)=trim(jnt.doc_id) and trim(cif_name)=trim(name);
commit; 
delete from cu5_o_table  where trim(REFERENCENUMBER) is null;
commit; 
---DUMMY dOCUMENT WHICH IS NOT AVAILABLE IN LEGACY SYSTEM------------
INSERT INTO CU5_O_TABLE
SELECT distinct 
--    V_ORGKEY            CHAR(32)
  orgkey,
--    V_DOCDUEDATE        CHAR(17)
     RELATIONSHIPOPENINGDATE,
--    V_DOCRECEIVEDDATE        CHAR(17)
        RELATIONSHIPOPENINGDATE,
--    V_DOCEXPIRYDATE        CHAR(17)
      '31-DEC-2099',
--    V_DOCDELFLG        CHAR(1)
    'N',
--    V_DOCREMARKS        CHAR(255)
    '',
--    V_SCANNED            CHAR(1)
    'N',
--    V_DOCCODE            CHAR(20)
    'OTH',                        -- Hardcoded, need to look into the same later
--    V_DOCDESCR        CHAR(255)
    'IDTypeR5',             -- Hardcoded, need to look into the same later
--    V_REFERENCENUMBER        CHAR(100)
    'ZZZ999',
--    V_TYPE            CHAR(50)
    '',
--    V_ISMANDATORY        CHAR(1)
    'N',
--    V_SCANREQUIRED        CHAR(10)
    'N',
--    V_ROLE            CHAR(50)
    '',
--    V_DOCTYPECODE        CHAR(50)
    'OTHER',            -- Hardcoded, need to look into the same later
--    V_DOCTYPEDESCR        CHAR(2000)
    'DOCUMENTS FOR INDIVIDUALS',  -- Hardcoded, need to look into the same later
--    V_MINDOCSREQD        CHAR(38)
    '',
--    V_WAIVEDORDEFEREDDATE    CHAR(17)
    '',
--    V_COUNTRYOFISSUE        CHAR(50)
    'KW', --- as per Hiyam George <hiyam@abkuwait.com> mail dt 25-12-2016 changed.
--    V_PLACEOFISSUE        CHAR(200)
    'KW',             -- Default as all the DL are issued in UAE, need confirmation from Business
--    V_DOCISSUEDATE        CHAR(17)
    RELATIONSHIPOPENINGDATE,        -- Defaulted as there is no value in Legacy, need confirmation from Business, else we need to derive based on the expiry date
--    V_IDENTIFICATIONTYPE    CHAR(50)
    '',
--    V_CORE_CUST_ID        CHAR(9)
    '',
--    V_IS_DOCUMENT_VERIFIED    CHAR(1)
    'N',
--    V_BEN_OWN_KEY        CHAR(50)
    '',
--    V_BANK_ID            CHAR(8)
    get_param('BANK_ID'),
--    V_DOCTYPEDESCR_ALT1    CHAR(2000)
    '',
--    V_DOCDESCR_ALT1        CHAR(255)
    '',
--    V_IDISSUEORGANISATION    CHAR(255)
    convert_codes('IDISSUEORGANISATION',' ')
from CU1_O_TABLE where trim(orgkey) not in(select trim(orgkey) from CU5_O_TABLE);
commit;
---------------------------------------------------------------------------------------------------
--update CU5_O_TABLE set ismandatory='Y' where orgkey not in (select orgkey from cu5_o_table where ismandatory ='Y')
--and doccode='CIVID'; 
update cu5_o_table set ISMANDATORY = 'Y' where rowid in (
select min(rowid) from cu5_o_table b
where not exists(
select distinct orgkey from cu5_o_table a where ISMANDATORY='Y'
and a.orgkey=b.orgkey
) and b.ISMANDATORY='N' and doccode='CIVID'
group by orgkey 
);
commit;
--update cu5_o_table set ismandatory='Y' where orgkey not in (select orgkey from cu5_o_table where ismandatory ='Y')
--and doccode='PP'; 
update cu5_o_table set ISMANDATORY = 'Y' where rowid in (
select min(rowid) from cu5_o_table b
where not exists(
select distinct orgkey from cu5_o_table a where ISMANDATORY='Y'
and a.orgkey=b.orgkey
) and b.ISMANDATORY='N' and doccode='PP'
group by orgkey 
);
commit;
--update cu5_o_table set ismandatory='Y' where orgkey not in (select orgkey from cu5_o_table where ismandatory ='Y')
--and doccode='CR' ;
update cu5_o_table set ISMANDATORY = 'Y' where rowid in (
select min(rowid) from cu5_o_table b
where not exists(
select distinct orgkey from cu5_o_table a where ISMANDATORY='Y'
and a.orgkey=b.orgkey
) and b.ISMANDATORY='N' and doccode='CR'
group by orgkey 
);
commit;
update cu5_o_table set ISMANDATORY = 'Y' where rowid in (
select min(rowid) from cu5_o_table b
where not exists(
select distinct orgkey from cu5_o_table a where ISMANDATORY='Y'
and a.orgkey=b.orgkey
) and b.ISMANDATORY='N'
group by orgkey 
);
commit;
--update cu5_o_table set ISMANDATORY='N'
-- where (orgkey,to_char((to_date(DOCEXPIRYDATE,'DD-MON-YYYY')),'DD-MM-YYYY')) in(
--select orgkey,to_char(min(to_date(DOCEXPIRYDATE,'DD-MON-YYYY')),'DD-MM-YYYY')  from cu5_o_table where ISMANDATORY='Y'
--group by orgkey
--having count(*)>1);
--commit;
exit;
----------------------------END----------------------
 