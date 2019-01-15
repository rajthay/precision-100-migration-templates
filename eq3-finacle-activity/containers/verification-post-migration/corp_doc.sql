
set head off
set feedback off
set term off
set lines 1100
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/reports/kw/cif/corp_doc.dat
select
'LEG_CLIENT_BRANCH'||'|'||
'LEG_CUST_NUMBER'||'|'||           
'FINACLE_SOL_ID'||'|'||            
'FINACLE_CIF_ID'||'|'||            
'LEG_DOC_CREATION_DATE'||'|'||  
'FINACLE_DOC_DATE'||'|'||          
'DOC_DATE_MATCH'||'|'||            
'LEG_EXP_DATE'||'|'||              
'FINACLE_EXP_DATE'||'|'||          
'EXP_DATE_MATCH'||'|'||            
'LEG_DOCCODE'||'|'||               
'FINACLE_DOCCODE'||'|'||           
'LEGACY_DOCDESCR'||'|'||           
'FINACLE_DOCDESCR'||'|'||          
'LEG_REF_NUM'||'|'||               
'FINACLE_REF_NUM'||'|'||           
'REF_NUM_MATCH'||'|'||             
'LEG_COUNTRYOFISSUE'||'|'||        
'FINACLE_COUNTRYOFISSUE'||'|'||    
'COUNTRYOFISSUE_MATCH'||'|'||      
'LEG_PLACEOFISSUE'||'|'||          
'FINACLE_PLACEOFISSUE'      
from dual
union all
select  
to_char(mc.LEG_CUST_BRANCH)||'|'||         
to_char(mc.LEG_CUST_NUMBER)||'|'||
TO_CHAR(mc.FIN_SOL_ID)||'|'||          
TO_CHAR(mc.fin_cif_id)||'|'||
to_char(cu7.DOCRECEIVEDDATE) ||'|'||
to_char(b.DOCRECEIVEDDATE,'DD-MON-YYYY')||'|'||   
case when (to_char(cu7.DOCRECEIVEDDATE)) = (to_char(b.DOCRECEIVEDDATE,'DD-MON-YYYY')) then 'TRUE' else 'FALSE' end||'|'||
case when to_char(cu7.DOCEXPIRYDATE) ='31-DEC-2099' then ' ' else to_char(cu7.DOCEXPIRYDATE) end ||'|'||
TO_CHAR (b.docexpirydate, 'DD-MON-YYYY')||'|'||
case when (case when to_char(cu7.DOCEXPIRYDATE) ='31-DEC-2099' then ' ' else to_char(cu7.DOCEXPIRYDATE) end ) = (TO_CHAR (b.docexpirydate, 'DD-MON-YYYY')) then 'TRUE' else 'FALSE' end||'|'||  
to_char(cu7.DOCCODE)||'|'||
to_char(b.doccode) ||'|'||          
to_char(cu7.DOCTYPECODE)||'|'||           
to_char(b.docdescr)||'|'||
--to_char(LEG_REF_NUM)||'|'||
to_char(cu7.referencenumber)||'|'||               
--to_char(FINACLE_REF_NUM)||'|'||  
to_char(b.referencenumber)||'|'||         
--to_char(REF_NUM_MATCH)||'|'||
case when trim(to_char(cu7.referencenumber)) = trim(to_char(b.referencenumber)) then 'TRUE' else 'FALSE' end||'|'||             
--to_char(LEG_COUNTRYOFISSUE)||'|'||        
to_char(cu7.COUNTRYOFISSUE)||'|'||
--to_char(FINACLE_COUNTRYOFISSUE)||'|'||    
to_char(b.COUNTRYOFISSUE)||'|'||
--to_char(COUNTRYOFISSUE_MATCH)||'|'||
case when (to_char(cu7.COUNTRYOFISSUE)) = (to_char(b.COUNTRYOFISSUE)) then 'TRUE' else 'FALSE'  end ||'|'||      
--to_char(LEG_PLACEOFISSUE)||'|'|| 
case when cu7.PLACEOFISSUE='ZZZ' then '' else cu7.PLACEOFISSUE end||'|'||
--to_char(FINACLE_PLACEOFISSUE) 
to_char(b.PLACEOFISSUE)
from cu7corp_o_table cu7 
inner join map_cif mc on cu7.corp_key=mc.fin_cif_id
left join (select * from crmuser.accounts where bank_id=get_param('BANK_ID') and corp_id is null)acct on acct.orgkey=mc.fin_cif_id 
left join CRMUSER.ENTITYDOCUMENT b on  b.orgkey=mc.fin_cif_id and trim(cu7.REFERENCENUMBER)=trim(b.REFERENCENUMBER);
exit;
--select
--to_char(LEG_CLIENT_BRANCH)||'|'||         
--to_char(LEG_CUST_NUMBER)||'|'||           
--to_char(FINACLE_SOL_ID)||'|'||            
--to_char(FINACLE_CIF_ID)||'|'||            
--to_char(LEG_CLIENT_CREATION_DATE)||'|'||  
--to_char(FINACLE_DOC_DATE)||'|'||          
--to_char(DOC_DATE_MATCH)||'|'||            
--to_char(LEG_EXP_DATE)||'|'||              
--to_char(FINACLE_EXP_DATE)||'|'||          
--to_char(EXP_DATE_MATCH)||'|'||            
--to_char(LEG_DOCCODE)||'|'||               
--to_char(FINACLE_DOCCODE)||'|'||           
--to_char(LEGACY_DOCDESCR)||'|'||           
--to_char(FINACLE_DOCDESCR)||'|'||          
--to_char(LEG_REF_NUM)||'|'||               
--to_char(FINACLE_REF_NUM)||'|'||           
--to_char(REF_NUM_MATCH)||'|'||             
--to_char(LEG_COUNTRYOFISSUE)||'|'||        
--to_char(FINACLE_COUNTRYOFISSUE)||'|'||    
--to_char(COUNTRYOFISSUE_MATCH)||'|'||      
--to_char(LEG_PLACEOFISSUE)||'|'||          
--to_char(FINACLE_PLACEOFISSUE) 
--from rep_corp_doc;
--exit; 
