
--MCS Unpaid--
truncate table dds_o_table; 
insert into dds_o_table
select   
--   v_DD_Issued_Branch_Code     CHAR(6) 
         rpad(sol_id,6,' '),
-- v_DD_Number              CHAR(16)   
         lpad(to_number(substr(trim(CHEQUE_REFERENCE),instr(trim(CHEQUE_REFERENCE),'-',1)+1)),16,' ') ,--DD number has alpha characters so change the code changed on 11-05-2015
--   v_DD_Issue_Date         CHAR(8) 
       lpad(nvl(to_char(nvl(DraftValueDate,DRAFTISSUEDATE),'DD-MM-YYYY'),' '),10,' '),
--   v_DD_Issued_Bank_Code     CHAR(6) 
            rpad(bank_code,6,' '),
--   v_DD_Currency         CHAR(3) 
            lpad(case when get_param('BANK_ID')='01' then 'KWD'
            else 'AED' end,3,' '),
--   v_Scheme_Code         CHAR(5) 
           rpad('CHCHQ',5,' '),--Infy Provide schme code 
--Issue_Extm_cntr code
          rpad('00',2,' '),  --- Infy provide the information
--   v_Status               CHAR(1) 
            'U',
-- v_Status_Update_Date         CHAR(8) 
        lpad(nvl(to_char(nvl(DraftValueDate,DRAFTISSUEDATE),'DD-MM-YYYY'),' '),10,' '),
-- v_DD_Amount             CHAR(17) 
            --lpad(to_number(abs(amount))/POWER(10,C8CED),17,' '),
            lpad(nvl(DraftValue,' '),17,' '),--changed on 23-11-2015
--  v_Payee_Branch_Code         CHAR(6) 
            rpad(sol_id,6,' '),
--   v_Payee_Bank_Code         CHAR(6) 
            rpad(bank_code,6,' '),
--   v_Instrument_No         CHAR(16) 
     lpad(to_number(substr(trim(CHEQUE_REFERENCE),instr(CHEQUE_REFERENCE,'-',1)+1)),16,' '),             
--   v_DD_Revalidation_Date     CHAR(8) 
            lpad(' ',10,' '),
-- v_Print_Advice_Flag         CHAR(1) 
            lpad(' ',1,' '),
--   v_Print_Remarks         CHAR(50) 
            rpad(' ',50,' '),
-- v_Paying_Branch_Code         CHAR(6) 
            rpad(' ',6,' '),
--   v_Paying_Bank_Code         CHAR(6) 
            rpad(' ',6,' '),
--   v_Routig_Branch_Code     CHAR(6) 
            rpad(' ',6,' '),
--  v_Routing_Bank_Code         CHAR(6) 
            rpad(' ',6,' '),
--   v_Instrument_Type         CHAR(6) 
            --rpad('DDS',6,' '),
            rpad('MCS',6,' '),--changed on 23-12-2015 based on mapping desc
--   v_Instrument_Alpha         CHAR(6) 
            rpad(' ',6,' '),
--   v_Purchasers_Name         CHAR(80) 
            rpad(nvl(trim(DRAFTCUSTOMERNAME),'NOT AVAILABLE'),80,' '),--Null changed to DRAFTCUSTOMERNAME 11/01/2017   
--   v_Payees_Name         CHAR(80) 
            rpad(DraftBeneficiaryName1,80,' '),
--   v_Print_Option         CHAR(1) 
            rpad(' ',1,' '),
-- v_Print_Flag             CHAR(1) 
            rpad('Y',1,' '),
--   v_Print_Count         CHAR(3) 
            lpad('1',3,' '),
--   v_Duplicate_Issue_Count     CHAR(3) 
            lpad(' ',3,' '),
--   v_Duplicate_Issue_Date     CHAR(8) 
            lpad(' ',10,' '),
--   v_Rectified_Count         CHAR(3) 
            lpad(' ',3,' '),
--   v_Cautioned_Status         CHAR(1) 
            lpad(' ',1,' '),
-- v_Reason_for_Caution         CHAR(50) 
            rpad(' ',50,' '),
--   v_Paid_Ex_Advice         CHAR(1) 
            'N',
--   v_Inventory_Serial_No     CHAR(16) 
     lpad(to_number(substr(trim(CHEQUE_REFERENCE),instr(CHEQUE_REFERENCE,'-',1)+1)),16,' '),
--   v_Paid_Advice_Flag         CHAR(1) 
            'N',
--   v_Advice_Received_Date     CHAR(8) 
            lpad(' ',10,' ')
from mc_dd 
inner join DD_OUSTANDING on trim(DRAFTNUMBER) = trim(CHEQUE_REFERENCE) or trim(CHEQUE_REFERENCE) = trim(CASHIERORDERNUMBER)
--inner join map_sol on NVL(trim(DraftIssueBranchId),substr(trim(POSTING_DETAILS),1,4))  = trim(br_code)
inner join tbaadm.sol on  sol.sol_id = '003'
left join scpf on scpf.scab||scpf.scan||scpf.scas=trim(DRAFTCUSTOMERACCOUNT)
where trim(DRAFTPAYMENTTYPE) is not null;
commit;
exit;
--BEAMFRX_DRAFTSLD
--update BEAM_MEMOPAD set note=replace(note,'_x000D_','');
--select distinct MCC_DD_OUTSTANDING1.*,DRAFTSTATUS,DRAFTCURRENCY from MCC_DD_OUTSTANDING1 
--inner join mc_dd on (trim(DRAFTNUMBER) = substr(trim(CHEQUE_NUM),1,10)) and trim(AMOUNT) = trim(DRAFTVALUE) 
 