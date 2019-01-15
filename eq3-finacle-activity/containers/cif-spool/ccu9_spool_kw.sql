-- File Name		: cu9crop.sql
-- File Created for	: Creation of source table
-- Created By		: Kumaresan.B
-- Client		    : Emirates Islamic Bank
-- Created On		: 26-05-2015
-------------------------------------------------------------------
set head off
set feedback off
set term off
set lines 800
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/cifkw/CC009.txt
select
trim(ORGKEY)||'|'||
trim(GROUPHOUSEHOLDCODE)||'|'||         
trim(CMNE)||'|'|| 
trim(SHAREHOLDING_IN_PERCENTAGE)||'|'|| 
trim(TEXT1)||'|'||                     
trim(TEXT2)||'|'||              
trim(TEXT3)||'|'||                      
trim(DATE1)||'|'||                      
trim(DATE2)||'|'||                      
trim(DATE3)||'|'||                      
trim(DROPDOWN1)||'|'||                  
trim(DROPDOWN2)||'|'||                  
trim(DROPDOWN3)||'|'||                 
trim(LOOKUP1)||'|'||                    
trim(LOOKUP2)||'|'||                    
trim(LOOKUP3)||'|'||                    
trim(GROUPHOUSEHOLDNAME)||'|'||
trim(BANK_ID)||'|'||                    
trim(GROUP_ID)||'|'||                   
trim(PRIMARY_GROUP_INDICATOR)
from CU9CORP_O_TABLE;
exit;