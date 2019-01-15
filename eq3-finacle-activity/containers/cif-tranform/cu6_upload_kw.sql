-- File Name        : cu6_upload.sql
-- File Created for    : Upload file for cu7
-- Created By        : Jagadeesh.M
-- Client            : ABK
-- Created On        : 10-05-2016
-------------------------------------------------------------------
drop table phone_numbers1;
create table phone_numbers1 as
select  SVSEQ, SVNA1, SVNA2, SVNA3, SVNA4, SVNA5, 
SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id
from svpf svpf_kw 
inner join sxpf sxpf_kw  on sxpf_kw.sxseq=svpf_kw.svseq
inner join gfpf gfpf_kw  on gfpf_kw.gfcus=sxpf_kw.sxcus and gfpf_kw.gfclc = sxpf_kw.sxclc
inner join map_cif on map_cif.gfcus = sxpf_kw.sxcus and map_cif.gfclc = sxpf_kw.sxclc
where sxprim='6' and MAP_CIF.INDIVIDUAL='Y' and del_flg<>'Y'; 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
drop table phone_numbers2;
create table phone_numbers2 as select SVSEQ, replace(SVNA1,'MOB1-','') SVNA1, replace(SVNA2,'MOB1-','') SVNA2,replace(SVNA3,'MOB1-','') SVNA3,replace(SVNA4,'MOB1-','') SVNA4, replace(SVNA5,'MOB1-','') SVNA5, 
replace(SVPHN,'MOB1-','') SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id from  phone_numbers1;
drop table phone_numbers3;
create table phone_numbers3 as select SVSEQ, replace(SVNA1,'MOB1 -','') SVNA1, replace(SVNA2,'MOB1 -','') SVNA2,replace(SVNA3,'MOB1 -','') SVNA3,replace(SVNA4,'MOB1 -','') SVNA4, replace(SVNA5,'MOB1 -','') SVNA5, 
replace(SVPHN,'MOB1 -','') SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id from  phone_numbers2;
drop table phone_numbers4;
create table phone_numbers4 as select SVSEQ, replace(SVNA1,'MOB2 -','') SVNA1, replace(SVNA2,'MOB2 -','') SVNA2,replace(SVNA3,'MOB2 -','') SVNA3,replace(SVNA4,'MOB2 -','') SVNA4, replace(SVNA5,'MOB2 -','') SVNA5, 
replace(SVPHN,'MOB2 -','') SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id from  phone_numbers3;
drop table phone_numbers5;
create table phone_numbers5 as select SVSEQ, replace(SVNA1,'MOB2-','') SVNA1, replace(SVNA2,'MOB2-','') SVNA2,replace(SVNA3,'MOB2-','') SVNA3,replace(SVNA4,'MOB2-','') SVNA4, replace(SVNA5,'MOB2-','') SVNA5, 
replace(SVPHN,'MOB1-','') SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id from  phone_numbers4;
drop table phone_numbers;
create table phone_numbers as select SVSEQ, replace(SVNA1,' 0 ','') SVNA1, replace(SVNA2,' 0 ','') SVNA2,replace(SVNA3,' 0 ','') SVNA3,replace(SVNA4,' 0 ','') SVNA4, replace(SVNA5,' 0 ','') SVNA5, 
replace(SVPHN,' 0 ','') SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id from  phone_numbers5;
create index phone_no_idx on phone_numbers(SVPHN);
create index phone_no_idx1 on phone_numbers(SVNA3);
create index phone_no_idx2 on phone_numbers(SVNA2);
create index phone_no_idx3 on phone_numbers(SVNA5);
create index phone_no_idx4 on phone_numbers(fin_cif_id);
update phone_numbers set svna1 =' ' where svseq='1395174';
commit;
truncate table CU6_O_TABLE;
--phone numbers ---
INSERT INTO CU6_O_TABLE
SELECT 
--ORGKEY           CHAR(32) 
  FIN_CIF_ID,
--PHONEEMAILTYPE     CHAR(200)    
  'CELLPH',
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
'',
--PHONENOLOCALCODE     CHAR(20) 
 --substr(CU01_MOBPN,3,6),
 CU01_MOBPN,
--PHONENOCITYCODE     CHAR(20) 
--substr(CU01_MOBPN,1,2),
'',
--PHONENOCOUNTRYCODE     CHAR(20) 
'965',
--WORKEXTENSION       CHAR(30) 
    '',
--EMAIL           CHAR(50) 
    '',
--EMAILPALM          CHAR(150) 
    '',
--URL             CHAR(150) 
    '',
--PREFERRED_FLAG     CHAR(50)
  'Y',
--Start_Date           CHAR(17) 
    '',
--End_Date           CHAR(17) 
    '',
--USERFIELD1           CHAR(200) 
    case when trim(CU01_MOBPR)='MTC' then 'ZAIN' 
when trim(CU01_MOBPR)='VIV' then 'VIVA'
when trim(CU01_MOBPR)='WAT' then 'OREDO'
when trim(CU01_MOBPR)='Wat' then 'OREDO'
else '' end, ---- changed on 19-03-2017. as per Vijay mail confirmation
--USERFIELD2         CHAR(200) 
    gfpf.GFCUN,
--USERFIELD3         CHAR(200) 
    '',
--DATE1         CHAR(17) 
    '',
--DATE2         CHAR(17) 
    '',
--DATE3         CHAR(17) 
    '',
--BANK_ID         CHAR(8) 
get_param('BANK_ID')
from  map_cif
inner join YSMSCUPF01 on trim(map_cif.gfclc)=trim(cu01_clc) and  trim(map_cif.gfcus)=trim(cu01_cus)
inner join gfpf on trim(map_cif.gfclc)=trim(gfpf.gfclc) and  trim(map_cif.gfcus)=trim(gfpf.gfcus)
where  individual='Y' and del_flg<>'Y' and trim(CU01_MOBPN) is not null;
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--where  individual='Y' and del_flg<>'Y';--ONE customer has null phone number changed by Kumar on 17-05-2017
INSERT INTO CU6_O_TABLE
SELECT 
--ORGKEY           CHAR(32) 
  FIN_CIF_ID,
--PHONEEMAILTYPE     CHAR(200)    
  'CELLPH1',
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
'',
--PHONENOLOCALCODE     CHAR(20) 
 --case when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=8
 --    then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),3,8)
   --  when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))>8
   --  then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),3,6)
    -- else '99999999' 
    -- end,
     case when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=8 then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=11 and substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
     when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=7 then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
	 else '99999999' 
     end,
--PHONENOCITYCODE     CHAR(20) 
--case when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=8
--then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,2) 
--when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))>8
--then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,2)
--     else '65'
--     end,
'',
--PHONENOCOUNTRYCODE     CHAR(20) 
'965',
--WORKEXTENSION       CHAR(30) 
    '',
--EMAIL           CHAR(50) 
    '',
--EMAILPALM          CHAR(150) 
    '',
--URL             CHAR(150) 
    '',
--PREFERRED_FLAG     CHAR(50)
  'N',
--Start_Date           CHAR(17) 
    '',
--End_Date           CHAR(17) 
    '',
--USERFIELD1           CHAR(200) 
    '',
--USERFIELD2         CHAR(200) 
    SVNA1,
--USERFIELD3         CHAR(200) 
    '',
--DATE1         CHAR(17) 
    '',
--DATE2         CHAR(17) 
    '',
--DATE3         CHAR(17) 
    '',
--BANK_ID         CHAR(8) 
get_param('BANK_ID')
from phone_numbers where regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','') is not null and 
to_number(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))<>0
and not exists(select distinct ORGKEY PHONENOLOCALCODE from cu6_o_table where orgkey=fin_cif_id
and ( case when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=8 then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=11 and substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
     when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=7 then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
	 else '99999999' 
     end)=PHONENOLOCALCODE);
commit;
--Added one more condtion for avoiding same customer and phone number migrated as different phone type. by Kumar 17-05-2017
INSERT INTO CU6_O_TABLE
SELECT 
--ORGKEY           CHAR(32) 
  FIN_CIF_ID,
--PHONEEMAILTYPE     CHAR(200)    
  'WORKPH1',
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
'',
--PHONENOLOCALCODE     CHAR(20) 
 --case when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8
 --    then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),3,8)
 --    when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))>8
 --    then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),3,6)
 --    else '234567' 
 --    end,
  case when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8 then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=11 and substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),4,8)
	 when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=7 then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,7)
     else '99999999' 
     end,
--PHONENOCITYCODE     CHAR(20) 
--case when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8
    -- then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,2) 
    -- when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))>8
    -- then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,2)
    -- else '65'
   --  end,
   '',
--PHONENOCOUNTRYCODE     CHAR(20) 
'965',
--WORKEXTENSION       CHAR(30) 
    '1',
--EMAIL           CHAR(50) 
    '',
--EMAILPALM          CHAR(150) 
    '',
--URL             CHAR(150) 
    '',
--PREFERRED_FLAG     CHAR(50)
  'N',
--Start_Date           CHAR(17) 
    '',
--End_Date           CHAR(17) 
    '',
--USERFIELD1           CHAR(200) 
    '',
--USERFIELD2         CHAR(200) 
    SVNA1,
--USERFIELD3         CHAR(200) 
    '',
--DATE1         CHAR(17) 
    '',
--DATE2         CHAR(17) 
    '',
--DATE3         CHAR(17) 
    '',
--BANK_ID         CHAR(8) 
get_param('BANK_ID')
from phone_numbers where regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','') is not null and 
to_number(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))<>0 and svna1 <> '1395174';
commit;
INSERT INTO CU6_O_TABLE
SELECT 
--ORGKEY           CHAR(32) 
  FIN_CIF_ID,
--PHONEEMAILTYPE     CHAR(200)    
  'FAX1',
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
'',
--PHONENOLOCALCODE     CHAR(20) 
 --case when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=8
   --  then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),3,8)
    -- when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))>8
    -- then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),3,6)
    -- else '234567' 
    -- end,
case when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=8 then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=11 and  substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3) ='965'
     then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
	 when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=7 then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
     else '99999999' 
     end,     
--PHONENOCITYCODE     CHAR(20) 
--case when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=8
--     then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,2) 
--     when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))>8
--     then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,2)
--     else '65'
--     end,
'',
--PHONENOCOUNTRYCODE     CHAR(20) 
'965',
--WORKEXTENSION       CHAR(30) 
    '',
--EMAIL           CHAR(50) 
    '',
--EMAILPALM          CHAR(150) 
    '',
--URL             CHAR(150) 
    '',
--PREFERRED_FLAG     CHAR(50)
  'N',
--Start_Date           CHAR(17) 
    '',
--End_Date           CHAR(17) 
    '',
--USERFIELD1           CHAR(200) 
    '',
--USERFIELD2         CHAR(200) 
    SVNA1,
--USERFIELD3         CHAR(200) 
    '',
--DATE1         CHAR(17) 
    '',
--DATE2         CHAR(17) 
    '',
--DATE3         CHAR(17) 
    '',
--BANK_ID         CHAR(8) 
get_param('BANK_ID')
from phone_numbers where regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','') is not null and 
to_number(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))<>0
and not exists(select distinct ORGKEY PHONENOLOCALCODE from cu6_o_table where orgkey=fin_cif_id
and (case when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=8 then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=11 and substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
	 when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=7 then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
     else '99999999' 
     end)=PHONENOLOCALCODE);
commit;
--Added one more condtion for avoiding same customer and phone number migrated as different phone type. by Kumar 17-05-2017
INSERT INTO CU6_O_TABLE
SELECT 
--ORGKEY           CHAR(32) 
  FIN_CIF_ID,
--PHONEEMAILTYPE     CHAR(200)    
  'TELEX',
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
'',
--PHONENOLOCALCODE     CHAR(20) 
 --case when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8
 --    then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),3,8)
 --    when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))>8
  --   then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),3,6)
  --   else '234567' 
  --   end,
 case when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8 then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=11 and  substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),4,8)
	 when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=7 then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,7)
     else '99999999' 
     end,     
--PHONENOCITYCODE     CHAR(20) 
--case when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8
 --    then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,2) 
 --    when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))>8
 --    then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,2)
  --   else '65'
   --  end,
   '',
--PHONENOCOUNTRYCODE     CHAR(20) 
'965',
--WORKEXTENSION       CHAR(30) 
    '',
--EMAIL           CHAR(50) 
    '',
--EMAILPALM          CHAR(150) 
    '',
--URL             CHAR(150) 
    '',
--PREFERRED_FLAG     CHAR(50)
  'N',
--Start_Date           CHAR(17) 
    '',
--End_Date           CHAR(17) 
    '',
--USERFIELD1           CHAR(200) 
    '',
--USERFIELD2         CHAR(200) 
    SVNA1,
--USERFIELD3         CHAR(200) 
    '',
--DATE1         CHAR(17) 
    '',
--DATE2         CHAR(17) 
    '',
--DATE3         CHAR(17) 
    '',
--BANK_ID         CHAR(8) 
get_param('BANK_ID')
from phone_numbers where regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','') is not null and 
to_number(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))<>0
and not exists(select distinct ORGKEY PHONENOLOCALCODE from cu6_o_table where orgkey=fin_cif_id
and (case when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8 then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=11 and  substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),4,8)
	 when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=7 then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,7)
     else '99999999' 
     end)=PHONENOLOCALCODE);
commit;
--Added one more condtion for avoiding same customer and phone number migrated as different phone type. by Kumar 17-05-2017;
INSERT INTO CU6_O_TABLE
SELECT 
--ORGKEY           CHAR(32) 
  FIN_CIF_ID,
--PHONEEMAILTYPE     CHAR(200)    
  'REGPH1',
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
'',
--PHONENOLOCALCODE     CHAR(20) 
--case when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8
--then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),3,8)
--else '234567' end,
case when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end,
--PHONENOCITYCODE     CHAR(20) 
--case when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8
--then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,2)
--else '65' end ,
'',
--PHONENOCOUNTRYCODE     CHAR(20) 
'965',
--WORKEXTENSION       CHAR(30) 
    '',
--EMAIL           CHAR(50) 
    '',
--EMAILPALM          CHAR(150) 
    '',
--URL             CHAR(150) 
    '',
--PREFERRED_FLAG     CHAR(50)
  'N',
--Start_Date           CHAR(17) 
    '',
--End_Date           CHAR(17) 
    '',
--USERFIELD1           CHAR(200) 
    '',
--USERFIELD2         CHAR(200) 
    SVNA1,
--USERFIELD3         CHAR(200) 
    '',
--DATE1         CHAR(17) 
    '',
--DATE2         CHAR(17) 
    '',
--DATE3         CHAR(17) 
    '',
--BANK_ID         CHAR(8) 
get_param('BANK_ID')
from phone_numbers 
where regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','') is not null 
and to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))<>0
and not exists(select distinct ORGKEY PHONENOLOCALCODE from cu6_o_table where orgkey=fin_cif_id
and (case when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end)=PHONENOLOCALCODE);
commit;
------phone number extracted from sxprim is null  ---------------------------
INSERT INTO CU6_O_TABLE
SELECT 
--ORGKEY           CHAR(32) 
  FIN_CIF_ID,
--PHONEEMAILTYPE     CHAR(200)    
  case when orgkey is null then 'CELLPH' 
  else 'COMMPH1' end,
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
'',
--PHONENOLOCALCODE     CHAR(20) 
case when
length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=11 and substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)=965 then  substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end,
--PHONENOCITYCODE     CHAR(20) 
'',
--PHONENOCOUNTRYCODE     CHAR(20) 
'965',
--WORKEXTENSION       CHAR(30) 
    '',
--EMAIL           CHAR(50) 
    '',
--EMAILPALM          CHAR(150) 
    '',
--URL             CHAR(150) 
    '',
--PREFERRED_FLAG     CHAR(50)
  'N',
--Start_Date           CHAR(17) 
    '',
--End_Date           CHAR(17) 
    '',
--USERFIELD1           CHAR(200) 
    '',
--USERFIELD2         CHAR(200) 
    SVNA1,
--USERFIELD3         CHAR(200) 
    '',
--DATE1         CHAR(17) 
    '',
--DATE2         CHAR(17) 
    '',
--DATE3         CHAR(17) 
    '',
--BANK_ID         CHAR(8) 
get_param('BANK_ID')
from svpf svpf_kw 
inner join sxpf sxpf_kw  on sxpf_kw.sxseq=svpf_kw.svseq
inner join map_cif on map_cif.gfcus = sxpf_kw.sxcus and map_cif.gfclc = sxpf_kw.sxclc
left join cu6_o_table on orgkey=fin_cif_id and PHONEEMAILTYPE='CELLPH'
where MAP_CIF.INDIVIDUAL='Y' and del_flg<>'Y'
and trim(sxprim) is null and regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','') is not null 
and not exists(select distinct ORGKEY PHONENOLOCALCODE from cu6_o_table where orgkey=fin_cif_id
and (case when length((regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=11 and substr((regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)=965 then  substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
when  length((regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end)=PHONENOLOCALCODE) ;
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
------phone number extracted from sxprim <> 6  ---------------------------
INSERT INTO CU6_O_TABLE
SELECT distinct
--ORGKEY           CHAR(32) 
  FIN_CIF_ID,
--PHONEEMAILTYPE     CHAR(200)    
  case when orgkey is null then 'CELLPH' 
  when PHONEEMAILTYPE = 'COMMPH1' then 'COMMPH2' 
  else 'COMMPH2' end,
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
'',
--PHONENOLOCALCODE     CHAR(20) 
case when
length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=11 and substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)=965 then  substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end,
--PHONENOCITYCODE     CHAR(20) 
'',
--PHONENOCOUNTRYCODE     CHAR(20) 
'965',
--WORKEXTENSION       CHAR(30) 
    '',
--EMAIL           CHAR(50) 
    '',
--EMAILPALM          CHAR(150) 
    '',
--URL             CHAR(150) 
    '',
--PREFERRED_FLAG     CHAR(50)
  'N',
--Start_Date           CHAR(17) 
    '',
--End_Date           CHAR(17) 
    '',
--USERFIELD1           CHAR(200) 
    '',
--USERFIELD2         CHAR(200) 
    SVNA1,
--USERFIELD3         CHAR(200) 
    '',
--DATE1         CHAR(17) 
    '',
--DATE2         CHAR(17) 
    '',
--DATE3         CHAR(17) 
    '',
--BANK_ID         CHAR(8) 
get_param('BANK_ID')
from svpf svpf_kw 
inner join sxpf sxpf_kw  on sxpf_kw.sxseq=svpf_kw.svseq
inner join map_cif on map_cif.gfcus = sxpf_kw.sxcus and map_cif.gfclc = sxpf_kw.sxclc
left join cu6_o_table on orgkey=fin_cif_id and PHONEEMAILTYPE in ('CELLPH','COMMPH1')
where MAP_CIF.INDIVIDUAL='Y' and del_flg<>'Y'
and trim(sxprim) <> '6' and regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','') is not null 
and ((length((regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=11 and substr((regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)=965) or
length((regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))) in (7,8))
and not exists(select distinct ORGKEY PHONENOLOCALCODE from cu6_o_table where orgkey=fin_cif_id
and (case when length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=11 and substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)=965 then  substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end)=PHONENOLOCALCODE); 
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
--Added one more condtion for avoiding same customer and phone number migrated as different phone type. by Kumar 17-05-2017 
INSERT INTO CU6_O_TABLE
SELECT  
--ORGKEY           CHAR(32) 
  map_cif.FIN_CIF_ID,
--PHONEEMAILTYPE     CHAR(200)
  'REGEML',    
--PHONEOREMAIL      CHAR(50) 
    'EMAIL',
--PHONE_NO           CHAR(25) 
    '',
--PHONENOLOCALCODE     CHAR(20) 
    '',
--PHONENOCITYCODE     CHAR(20) 
    '',
--PHONENOCOUNTRYCODE     CHAR(20) 
    '',
--WORKEXTENSION       CHAR(30) 
    '',
--EMAIL           CHAR(50) 
    replace(BGINID,' ',''),
--EMAILPALM          CHAR(150) 
    '',
--URL             CHAR(150) 
    '',
--PREFERRED_FLAG     CHAR(50)  --This flag is updated after the insert to the table and the update script is below
  'Y',
--Start_Date           CHAR(17) 
    '',
--End_Date           CHAR(17) 
    '',
--USERFIELD1           CHAR(200) 
    '',
--USERFIELD2         CHAR(200) 
    '',
--USERFIELD3         CHAR(200) 
    '',
--DATE1         CHAR(17) 
    '',
--DATE2         CHAR(17) 
    '',
--DATE3         CHAR(17) 
    '',
--BANK_ID         CHAR(8) 
    get_param('BANK_ID')
from map_cif 
inner join gfpf gfpf_kw  on gfpf_kw.gfclc=map_cif.gfclc and  gfpf_kw.gfcus=map_cif.gfcus
left join  bgpf bgpf_kw on nvl(GFPF_KW.GFCLC,'')=nvl(BGPF_KW.BGCLC,'') and GFPF_KW.GFCUS=BGPF_KW.BGCUS 
where map_cif.individual='Y' and map_cif.del_flg<>'Y' and BGINID   like '%@%';
--and is_joint<>'Y' -------------commented on 24-07-2017.Post 23-07-2017 meeting with nancy Vijay has confirmed to remove EJ joint cif logic
commit;
---------------------------POA/Guarantor Customer where joint cif not avaialble -------------------------------------------------
INSERT INTO CU6_O_TABLE
SELECT  distinct
--ORGKEY           CHAR(32) 
  fin_cif_id,
--PHONEEMAILTYPE     CHAR(200)    
    'CELLPH',-- Changed to PALMEML as ELML will be preferred for valid Emails
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
    '',
--PHONENOLOCALCODE     CHAR(20) 
    --'234567',
    '99999999',
--PHONENOCITYCODE     CHAR(20) 
    --'65',
    '',
--PHONENOCOUNTRYCODE     CHAR(20) 
    '965',
--WORKEXTENSION       CHAR(30) 
    '',
--EMAIL           CHAR(50) 
    '',
--EMAILPALM          CHAR(150) 
    '',
--URL             CHAR(150) 
    '',
--PREFERRED_FLAG     CHAR(50)  --This flag is updated after the insert to the table and the update script is below
'Y', 
--Start_Date           CHAR(17) 
    '',
--End_Date           CHAR(17) 
    '',
--USERFIELD1           CHAR(200) 
    '',
--USERFIELD2         CHAR(200) 
    '',
--USERFIELD3         CHAR(200) 
    '',
--DATE1         CHAR(17) 
    '',
--DATE2         CHAR(17) 
    '',
--DATE3         CHAR(17) 
    '',
--BANK_ID         CHAR(8) 
    get_param('BANK_ID')
FROM MAP_CIF_JOINT JNT;
commit; 
------Dummy PHONE Block-------
INSERT INTO CU6_O_TABLE
SELECT  
--ORGKEY           CHAR(32) 
  orgkey,
--PHONEEMAILTYPE     CHAR(200)    
    'CELLPH',-- Changed to PALMEML as ELML will be preferred for valid Emails
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
    '',
--PHONENOLOCALCODE     CHAR(20) 
    --'234567',
    '99999999',
--PHONENOCITYCODE     CHAR(20) 
    --'65',
    '',
--PHONENOCOUNTRYCODE     CHAR(20) 
    '965',
--WORKEXTENSION       CHAR(30) 
    '',
--EMAIL           CHAR(50) 
    '',
--EMAILPALM          CHAR(150) 
    '',
--URL             CHAR(150) 
    '',
--PREFERRED_FLAG     CHAR(50)  --This flag is updated after the insert to the table and the update script is below
'Y', 
--Start_Date           CHAR(17) 
    '',
--End_Date           CHAR(17) 
    '',
--USERFIELD1           CHAR(200) 
    '',
--USERFIELD2         CHAR(200) 
    CUST_FIRST_NAME||' '||CUST_MIDDLE_NAME||' '||CUST_LAST_NAME,
--USERFIELD3         CHAR(200) 
    '',
--DATE1         CHAR(17) 
    '',
--DATE2         CHAR(17) 
    '',
--DATE3         CHAR(17) 
    '',
--BANK_ID         CHAR(8) 
    get_param('BANK_ID')
from CU1_O_TABLE 
where orgkey not in(select distinct orgkey from CU6_O_TABLE  where PHONEOREMAIL='PHONE');
commit;
----------------------------------------------------------------------------
update cu6_o_table set PREFERRED_FLAG = 'Y' where rowid in (
select min(rowid)  
from cu6_o_table
where phoneoremail = 'PHONE' and preferred_flag <> 'Y'
and orgkey not in (select distinct orgkey from CU6_O_TABLE  where PHONEOREMAIL='PHONE' and preferred_flag = 'Y')
group by orgkey );
commit;
update cu6_o_table set PHONE_NO='+'||PHONENOCOUNTRYCODE||'('||PHONENOCITYCODE||')'||PHONENOLOCALCODE WHERE   PHONEOREMAIL='PHONE';
commit;
--delete from cu6_o_table where trim(PHONENOLOCALCODE) is null;
--commit;--Changed by Kumar on 17-05-2017
exit; 