set head off
set feedback off
set term off
set linesize 5000
set page size 0
set pages 0
set trimspool on
spool $MIG_PATH/output/finacle/laa/KW/RL003.txt
Select  
Account_Number||Flow_ID||Flow_Start_Date||Frequency_Type||Freq_Week_Num_for_Principal||Freq_Week_Day_for_Principal||Freq_Start_DD_for_Principal||Freq_Months_for_Principal||Freq_Days_for_Principal||Freq_Hldy_Status_Principal||Number_of_Flows||Installment_Amount||Installment_Percentage||Number_of_Demands_Raised||Next_Installment_Date||Next_Int_Installment_Date||Frequency_Type_for_Interest||Frequency_Week_Number_for_Int||Frequency_Week_day_for_Int||Frequency_Start_DD_for_Int||Freq_Months_for_Int||Freq_Days_for_Int||Freq_Holiday_Status_for_Int||Installment_Indicator 
FROM LRS_O_TABLE 
--WHERE TRIM(ACCOUNT_NUMBER) IN (
--SELECT FORACID FROM TBAADM.GAM WHERE BANK_ID='01' AND SCHM_TYPE='LAA' AND ACID NOT IN (SELECT ACID FROM TBAADM.LRS))
order by account_number,flow_id,to_date(flow_start_date,'DD-MM-YYYY');
exit;
 
