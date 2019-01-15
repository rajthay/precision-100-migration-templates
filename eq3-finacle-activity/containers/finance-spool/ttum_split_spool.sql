set head off
set feedback off
set term off
set linesize 2000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/ttum/TTUM_split.txt
select
ACCOUNT_NUMBER||             
CURRENCY_CODE||
SOL_ID||                
PART_TRAN_TYPE||               
TRANSACTION_AMOUNT||           
TRANSACTION_PARTICULAR||       
ACCOUNT_REPORT_CODE||          
REFERENCE_NUMBER||             
INSTRUMENT_TYPE||              
INSTRUMENT_DATE||              
INSTRUMENT_ALPHA||             
ACTUAL_INSTRUMENT_NUMBER||     
NAVIGATION_FLAG_FOR_HO_TRANS|| 
REFERENCE_AMOUNT||             
REFERENCE_CURRENCY_CODE||     
RATE_CODE||                    
RATE||                         
VALUE_DATE||                   
GL_DATE||                      
CATEGORY_CODE||                
TO__FROM_BANK_CODE||           
TO__FROM_BRANCH_CODE||         
ADVC_EXTENSION_COUNTER_CODE||  
BAR_ADVICE_GEN_INDICATOR||     
BAR_ADVICE_NUMBER||            
BAR_ADVICE_DATE||              
BILL_NUMBER||                  
HEADER_TEXT_CODE||             
HEADER_FREE_TEXT||             
PARTICULARS_LINE_1||           
PARTICULARS_LINE_2||          
PARTICULARS_LINE_3||           
PARTICULARS_LINE_4||           
PARTICULARS_LINE_5||           
AMOUNT_LINE_1||                
AMOUNT_LINE_2||                
AMOUNT_LINE_3||                
AMOUNT_LINE_4||                
AMOUNT_LINE_5||                
REMARKS||                      
PAYEE_ACCOUNT_NUMBER||         
RECEIVED_BAR_ADVICE_NUMBER||   
RECEIVED_BAR_ADVICE_DATE||     
ORIGINAL_TRANSACTION_DATE||    
ORIGINAL_TRANSACTION_ID||      
ORIGINAL_PART_TXN_SERIAL_NO||  
IBAN_NUMBER||                  
FREE_TEXT||                    
ENTITY_ID||                    
ENTITY_TYPE||                  
FLOW_ID                      
from ttum_split_o_table;
EXIT; 
