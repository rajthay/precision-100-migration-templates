========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
ttum4_try_validation.sql 

--BACID
select a.BACID, CCY, amount, b.BACID, ACCT_CRNCY_CODE, CLR_BAL_AMT,case when amount=CLR_BAL_AMT then 'TRUE' else 'FALSE' end match_amount from ( 
select  CR_BACID BACID,CCY,sum(CR_AMOUNT) amount from TREASURY_POSITION group by CR_BACID,CCY having sum(CR_AMOUNT)  <>0
union
select  DR_BACID,CCY,sum(DR_AMOUNT)  from TREASURY_POSITION group by DR_BACID,CCY having sum(DR_AMOUNT)  <>0
) a
join (
select BACID,ACCT_CRNCY_CODE,sum(clr_bal_amt) CLR_BAL_AMT from tbaadm.gam where BACID in(select CR_BACID from TREASURY_POSITION
union
select DR_BACID from TREASURY_POSITION) and clr_bal_amt <>0 and SOL_ID='005' group by BACID,SOL_ID,ACCT_CRNCY_CODE
) b
on a.BACID = b.BACID(+) and a.CCY = b.ACCT_CRNCY_CODE(+)
--------------------------------------------------------------------------------------------------------------

--ACCOUNT
select * from (
SELECT to_char(ACCOUNT_NUMBER) ACCOUNT_NUMBER ,CURRENCY_CODE,case when PART_TRAN_TYPE='D' then '-1' else '1' end*SUM(TRANSACTION_AMOUNT) TRANSACTION_AMOUNT  FROM TTUM4_TRY_O_TABLE GROUP BY  ACCOUNT_NUMBER,CURRENCY_CODE,case when PART_TRAN_TYPE='D' then '-1' else '1' end having SUM(TRANSACTION_AMOUNT) <> 0
) a
left join 
(SELECT to_char(foracid) foracid,ACCT_CRNCY_CODE,SUM(CLR_BAL_AMT) FROM TBAADM.GAM  WHERE foracid IN(SELECT trim(ACCOUNT_NUMBER) FROM TTUM4_TRY_O_TABLE)
GROUP BY  foracid,ACCT_CRNCY_CODE HAVING  SUM(CLR_BAL_AMT) <> 0
) b on trim(a.ACCOUNT_NUMBER) = b.foracid




 
