-- File Name		: cc8_upload.sql
-- File Created for	: Upload file for cu7
-- Created By		: Jagadeesh.M
-- Client		    : Emirates Islamic Bank
-- Created On		: 20-05-2015
-------------------------------------------------------------------
drop table corp_phone_numbers1;
create table corp_phone_numbers1 as
select  SVSEQ, SVNA1, SVNA2, SVNA3, SVNA4, SVNA5, 
SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id
from svpf svpf_kw 
inner join sxpf sxpf_kw  on sxpf_kw.sxseq=svpf_kw.svseq
inner join gfpf gfpf_kw  on trim(gfpf_kw.gfcus)=trim(sxpf_kw.sxcus) and nvl(trim(gfpf_kw.GFCLC),' ')=nvl(trim(sxpf_kw.sxclc),' ')  
inner join map_cif on trim(map_cif.gfcus) = trim(sxpf_kw.sxcus) and nvl(trim(map_cif.GFCLC),' ')=nvl(trim(sxpf_kw.sxclc),' ')  
where sxprim='6' and MAP_CIF.INDIVIDUAL='N' and del_flg<>'Y' ;
drop table corp_phone_numbers2;
create table corp_phone_numbers2 as select SVSEQ, replace(SVNA1,'MOB1-','') SVNA1, replace(SVNA2,'MOB1-','') SVNA2,replace(SVNA3,'MOB1-','') SVNA3,replace(SVNA4,'MOB1-','') SVNA4, replace(SVNA5,'MOB1-','') SVNA5, 
replace(SVPHN,'MOB1-','') SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id from  corp_phone_numbers1;
drop table corp_phone_numbers3;
create table corp_phone_numbers3 as select SVSEQ, replace(SVNA1,'MOB1 -','') SVNA1, replace(SVNA2,'MOB1 -','') SVNA2,replace(SVNA3,'MOB1 -','') SVNA3,replace(SVNA4,'MOB1 -','') SVNA4, replace(SVNA5,'MOB1 -','') SVNA5, 
replace(SVPHN,'MOB1 -','') SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id from  corp_phone_numbers2;
drop table corp_phone_numbers4;
create table corp_phone_numbers4 as select SVSEQ, replace(SVNA1,'MOB2 -','') SVNA1, replace(SVNA2,'MOB2 -','') SVNA2,replace(SVNA3,'MOB2 -','') SVNA3,replace(SVNA4,'MOB2 -','') SVNA4, replace(SVNA5,'MOB2 -','') SVNA5, 
replace(SVPHN,'MOB2 -','') SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id from  corp_phone_numbers3;
drop table corp_phone_numbers5;
create table corp_phone_numbers5 as select SVSEQ, replace(SVNA1,'MOB2-','') SVNA1, replace(SVNA2,'MOB2-','') SVNA2,replace(SVNA3,'MOB2-','') SVNA3,replace(SVNA4,'MOB2-','') SVNA4, replace(SVNA5,'MOB2-','') SVNA5, 
replace(SVPHN,'MOB1-','') SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id from  corp_phone_numbers4;
drop table corp_phone_numbers;
create table corp_phone_numbers as select SVSEQ, replace(SVNA1,' 0 ','') SVNA1, replace(SVNA2,' 0 ','') SVNA2,replace(SVNA3,' 0 ','') SVNA3,replace(SVNA4,' 0 ','') SVNA4, replace(SVNA5,' 0 ','') SVNA5, 
replace(SVPHN,' 0 ','') SVPHN, SVFAX, SVTLX, SVC08, SVDLM ,sxcus,sxclc,fin_cif_id from  corp_phone_numbers5;
create index corp_phone_no_idx on corp_phone_numbers(SVPHN);
create index corp_phone_no_idx1 on corp_phone_numbers(SVNA3);
create index corp_phone_no_idx2 on corp_phone_numbers(SVNA2);
create index corp_phone_no_idx3 on corp_phone_numbers(SVNA5);
create index corp_phone_no_idx4 on corp_phone_numbers(fin_cif_id);
truncate table CU8CORP_O_TABLE;
--phone numbers ---
INSERT INTO CU8CORP_O_TABLE
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
inner join YSMSCUPF01 on nvl(trim(map_cif.GFCLC),' ')=nvl(trim(cu01_clc),' ')  and  trim(map_cif.gfcus)=trim(cu01_cus)
inner join gfpf on nvl(trim(map_cif.GFCLC),' ')= nvl(trim(gfpf.GFCLC),' ') and  trim(map_cif.gfcus)=trim(gfpf.gfcus)
where  individual='N' and del_flg<>'Y' and trim(CU01_MOBPN) is not null ;
--where  individual='N' and del_flg<>'Y'; --ONE customer has null phone number changed by Kumar on 17-05-2017
commit;
INSERT INTO CU8CORP_O_TABLE
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
 case when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=8
     then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=11 and substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3) ='965' 
     then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
     when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=7 then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
	 else '99999999' 
     end,
--PHONENOCITYCODE     CHAR(20) 
--case when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=8
--     then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,2) 
--     when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))>8
--     then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,2)
--     else '99'
--     end,--changed by Kumar on 17-05-2017
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
from corp_phone_numbers where regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','') is not null and 
to_number(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))<>0
----and not exists(select * from CU8CORP_O_TABLE where corp_key=fin_cif_id)
and not exists(select distinct corp_key PHONENOLOCALCODE from CU8CORP_O_TABLE where corp_key=fin_cif_id
and ( case when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=8
     then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=11 and substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
	 when length(regexp_replace(upper(trim(SVNA3)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))=7 then substr(to_number(regexp_replace(upper(SVNA3),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
     else '99999999' 
     end)=PHONENOLOCALCODE);
commit;
--Added one more condtion for avoiding same customer and phone number migrated as different phone type. by Kumar 17-05-2017
INSERT INTO CU8CORP_O_TABLE
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
 case when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8
     then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=11 and  substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),4,8)
     when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=7 then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,7)
	 else '99999999' 
     end,
--PHONENOCITYCODE     CHAR(20) 
--case when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8
--     then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,2) 
--     when length(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))>8
--     then substr(to_number(regexp_replace(upper(SVNA1),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,2)
--     else '99'
--     end,--changed by Kumar on 17-05-2017
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
from corp_phone_numbers where regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','') is not null and 
to_number(regexp_replace(upper(trim(SVNA1)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))<>0;
commit;
INSERT INTO CU8CORP_O_TABLE
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
 case when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]',''))=8
     then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]',''))=11 and  substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]','')),4,8)
     when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]',''))=7  then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]','')),1,7)
	 else '99999999' 
     end,
--PHONENOCITYCODE     CHAR(20) 
--case when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]',''))=8
--     then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]','')),1,2) 
--     when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]',''))>8
--     then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]','')),1,2)
--     else '99'
--     end,--changed by Kumar on 17-05-2017
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
from corp_phone_numbers where regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]','') is not null and 
to_number(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,_,;,&,=,#,+,/,(,),;, ]',''))<>0
and not exists(select distinct corp_key PHONENOLOCALCODE from CU8CORP_O_TABLE where corp_key=fin_cif_id
and (case when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]',''))=8
     then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]',''))=11 and  substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]','')),4,8)
	 when length(regexp_replace(upper(trim(SVNA2)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]',''))=7
     then substr(to_number(regexp_replace(upper(SVNA2),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,),;, ]','')),1,7)
     else '99999999' 
     end)=PHONENOLOCALCODE);
commit;
--Added one more condtion for avoiding same customer and phone number migrated as different phone type. by Kumar 17-05-2017;
INSERT INTO CU8CORP_O_TABLE
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
 case when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8
     then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=11 and  substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),4,8)
	 when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=7 then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,7)
     else '99999999' 
     end,
--PHONENOCITYCODE     CHAR(20) 
--case when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8
--     then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,2) 
--     when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))>8
--     then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,2)
--     else '99'
--     end,--changed by Kumar on 17-05-2017
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
from corp_phone_numbers where regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','') is not null and 
to_number(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))<>0
and not exists(select distinct corp_key PHONENOLOCALCODE from CU8CORP_O_TABLE where corp_key=fin_cif_id
and ( case when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=8
     then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,8)
     when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=11 and  substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,3)='965'
     then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),4,8)
	 when length(regexp_replace(upper(trim(SVNA5)),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]',''))=7
     then substr(to_number(regexp_replace(upper(SVNA5),'[-,.,<,>,`,A-Z,@,_,;,&,=,#,+,/,(,), ]','')),1,7)
     else '99999999' 
     end)=PHONENOLOCALCODE);
commit;
--Added one more condtion for avoiding same customer and phone number migrated as different phone type. by Kumar 17-05-2017;
INSERT INTO CU8CORP_O_TABLE
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
case when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8
then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then   substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end,
--PHONENOCITYCODE     CHAR(20) 
--case when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8
--then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,2)
--else '99' end ,--changed by Kumar on 17-05-2017
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
from corp_phone_numbers 
where regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','') is not null 
and to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))<>0
and not exists(select distinct corp_key PHONENOLOCALCODE from CU8CORP_O_TABLE where corp_key=fin_cif_id
and ( case when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8
then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then   substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end)=PHONENOLOCALCODE);
commit;
------phone number extracted from sxprim is null  ---------------------------
INSERT INTO CU8CORP_O_TABLE
SELECT 
--ORGKEY           CHAR(32) 
  FIN_CIF_ID,
--PHONEEMAILTYPE     CHAR(200)    
  case when corp_key is null then 'CELLPH' 
  else 'COMMPH1' end,
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
'',
--PHONENOLOCALCODE     CHAR(20) 
case when
length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=11 and substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)=965 then  substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end,
--PHONENOCITYCODE     CHAR(20) 
--case when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8
--then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,2)
--else '99' end ,--changed by Kumar on 17-05-2017
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
left join CU8CORP_O_TABLE on corp_key=fin_cif_id and PHONEEMAILTYPE='CELLPH'
where MAP_CIF.INDIVIDUAL='N' and del_flg<>'Y'
and trim(sxprim) is null and regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','') is not null 
and not exists(select distinct corp_key PHONENOLOCALCODE from CU8CORP_O_TABLE where corp_key=fin_cif_id
and ( case when
length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=11 and substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)=965 then  substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end)=PHONENOLOCALCODE) ;
commit;
------phone number extracted from sxprim <> 6  ---------------------------
INSERT INTO CU8CORP_O_TABLE
SELECT 
--ORGKEY           CHAR(32) 
  FIN_CIF_ID,
--PHONEEMAILTYPE     CHAR(200)    
 case when corp_key is null then 'CELLPH' 
  when PHONEEMAILTYPE = 'COMMPH1' then 'COMMPH2' 
  else 'COMMPH2' end,
--PHONEOREMAIL      CHAR(50) 
    'PHONE',
--PHONE_NO           CHAR(25) 
'',
--PHONENOLOCALCODE     CHAR(20) 
case when
length(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=11 and substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)=965 then  substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end,
--PHONENOCITYCODE     CHAR(20) 
--case when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8
--then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,2)
--else '99' end ,--changed by Kumar on 17-05-2017
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
left join CU8CORP_O_TABLE on corp_key=fin_cif_id and PHONEEMAILTYPE in ('CELLPH','COMMPH1')
where MAP_CIF.INDIVIDUAL='N' and del_flg<>'Y'
and trim(sxprim) <> '6' and regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','') is not null 
and ((length((regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=11 and substr((regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)=965) or
length((regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]',''))) in (8,7))
and not exists(select distinct corp_key PHONENOLOCALCODE from CU8CORP_O_TABLE where corp_key=fin_cif_id
and ( case when
length((regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=11 and substr((regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,3)=965 then  substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),4,8)
when  length((regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=8 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,8)
when  length(to_number(regexp_replace(upper(trim(svphn)),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')))=7 then substr(to_number(regexp_replace(upper(svphn),'[-,.,<,`,A-Z,@,&,=,#,+,/,(,), ]','')),1,7)
else '99999999' end)=PHONENOLOCALCODE) ;
commit;
--Added one more condtion for avoiding same customer and phone number migrated as different phone type. by Kumar 17-05-2017;;
------Dummy PHONE Block-------
INSERT INTO CU8CORP_O_TABLE
SELECT  
--ORGKEY           CHAR(32) 
  corp_key,
--PHONEEMAILTYPE     CHAR(200)	
	'CELLPH',-- Changed to PALMEML as ELML will be preferred for valid Emails
--PHONEOREMAIL      CHAR(50) 
	'PHONE',
--PHONE_NO           CHAR(25) 
	'',
--PHONENOLOCALCODE     CHAR(20) 
	'99999999',
--PHONENOCITYCODE     CHAR(20) 
	--'99',--changed by Kumar on 17-05-2017
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
	CORPORATENAME_NATIVE,
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
from CU1corp_O_TABLE 
where corp_key not in(select distinct corp_key from CU8corp_O_TABLE  where PHONEOREMAIL='PHONE');
commit;
--where corp_key not in(select distinct corp_key from CU8corp_O_TABLE  where PHONEOREMAIL='PHONE'  and PHONEEMAILTYPE='CELLPH');--changed by Kumar on 17-05-2017
INSERT INTO CU8CORP_O_TABLE
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
   regexp_replace(BGINID,'[ ]',''),
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
inner join gfpf   on nvl(trim(gfpf.gfclc),' ')=nvl(trim(map_cif.gfclc),' ') and  trim(gfpf.gfcus)=trim(map_cif.gfcus)
left join  bgpf   on nvl(trim(gfpf.GFCLC),' ')=nvl(trim(bgpf.BGCLC),' ') and trim(gfpf.GFCUS)=trim(bgpf.BGCUS) 
where map_cif.individual='N' and map_cif.del_flg<>'Y' and BGINID   like '%@%' ;
commit;
update CU8CORP_O_TABLE set PREFERRED_FLAG = 'Y' where rowid in (
select min(rowid)  
from CU8CORP_O_TABLE
where phoneoremail = 'PHONE' and preferred_flag <> 'Y'
and corp_key not in (select distinct corp_key from CU8CORP_O_TABLE  where PHONEOREMAIL='PHONE' and preferred_flag = 'Y')
group by corp_key );
commit;
--Added by Kumar on 17-05-2017
update CU8CORP_O_TABLE set PHONE_NO='+'||PHONENOCOUNTRYCODE||'('||PHONENOCITYCODE||')'||PHONENOLOCALCODE WHERE   PHONEOREMAIL='PHONE';
commit;
delete from cu8corp_o_table where  phonenolocalcode is null and phoneoremail <> 'EMAIL';
commit;
exit; 
