--File Name         : Stop Cheque.sql
-- File Created for  : Upload file for SPT
-- Created By        : Kumaresan.B
-- Client             : ENBD
-- Created On        : 02-06-2015
-------------------------------------------------------------------
truncate table SPT_O_TABLE;
insert into SPT_O_TABLE
select         distinct 
            --ACCOUNT_NUMBER                NVARCHAR2(16),
            rpad(fin_acc_num,16,' '),
            --BEGIN_CHEQUE_NUMBER           NVARCHAR2(16),            
            lpad(START_NO,16,' '),
            --SP_ACCEPTANCE_DATE            NVARCHAR2(10),
            rpad(POSTDT,10,' '),
            -- CHEQUE_DATE                   NVARCHAR2(10),
            rpad(' ',10,' ') end,
            --CHEQUE_AMOUNT                 NVARCHAR2(17),
            --case when trim(amount) is not null and  trim(amount)<>0  then
            --lpad(to_number(amount/POWER(10,C8CED)),17,' ') 
            --else lpad(' ',17,' ') end ,
            case when trim(AMOUNT) is not null and  trim(AMOUNT)<>0  then
            lpad(AMOUNT/power(10,c8ced),17,' ') 
            else lpad(' ',17,' ') end ,--changed on 23-11-2015
            --PAYEE_NAME                    NVARCHAR2(80),
            --rpad(' ',40,' '),
            rpad(nvl(BENEFICIARY,' '),40,' '),--as per TFS-348029 changed on 28-02-2016
            --NO_OF_LEAVES                  NVARCHAR2(3),
            lpad(NO_LEAVS,3,' ') ,
            --CHEQUE_ALPHA_CODE             NVARCHAR2(6),
            rpad(' ',6,' '),
            --REASON_CODE_FOR_STOP_PAYMENT  NVARCHAR2(5),
            --rpad('99999',5,' '),
            case when FIN_STOP_PAY_REASON_CODE is not null then rpad(to_char(FIN_STOP_PAY_REASON_CODE),5,' ')
            else rpad('014',5,' ') end,
            --ACCOUNT_BALANCE               NVARCHAR2(17),
            lpad(' ',17,' '),
            --CURRENCY_CODE                 NVARCHAR2(3)           
            rpad(CURRENCY,3,' ')
from spt_temp
inner join c8pf on c8ccy=CURRENCY
left join stop_reason_code on trim(LEG_STOP_REASON_CODE)=trim(narration);
COMMIT;
exit; 
