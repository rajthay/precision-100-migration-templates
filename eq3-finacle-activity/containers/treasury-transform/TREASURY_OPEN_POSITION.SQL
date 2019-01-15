

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

select case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END OPICS_EQUATION,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END BANK_CORP ,ccy1 CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount from(
Select 'ccy' ccy,PORT,ccy1, 
 case when case when CCY1AMT<0 then -1 else 1 end = 1 then Sum(CCY1AMT) else 0 end cr_amount,case when case when CCY1AMT<0 then -1 else 1 end = -1 then Sum(CCY1AMT)  else 0 end dr_amount
 From CPPR 
 Where br = '01' --AND  CCY1='AED'
 and vdate > TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY')  
 Group By 'ccy',PORT,ccy1,case when CCY1AMT<0 then -1 else 1 end
 Union All
Select 'ctr',PORT,ccy2, 
 case when case when CCY2AMT<0 then -1 else 1 end = 1 then Sum(CCY2AMT) else 0 end cr_amount,case when case when CCY2AMT<0 then -1 else 1 end = -1 then Sum(CCY2AMT)  else 0 end dr_amount
 From CPPR 
 Where br = '01'-- AND  CCY2='AED'
 and vdate > TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') 
 Group By 'ctr',PORT,ccy2,case when CCY2AMT<0 then -1 else 1 end
)
group by  case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END ,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ccy1
ORDER BY ccy1

---SPOT
SELECT TYPE OPICS_EQUATION,port BANK_CORP,CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount FROM(
select 'CCY' CCY_CTR,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ccy,
case when case when ccyamt<0 then -1 else 1 end = 1 then Sum(ccyamt) else 0 end cr_amount,case when case when ccyamt<0 then -1 else 1 end = -1 then Sum(ccyamt)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL AND (TRIM(SWAPDEAL)='0' AND SPOTFWDIND='S') 
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CCY',case when ccyamt<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,CCy
union all
select 'CTR',case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ctrccy,
case when case when CTRAMT<0 then -1 else 1 end = 1 then Sum(CTRAMT) else 0 end cr_amount,case when case when CTRAMT<0 then -1 else 1 end = -1 then Sum(CTRAMT)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL  AND (TRIM(SWAPDEAL)='0' AND SPOTFWDIND='S' )
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CTR',case when CTRAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ctrCCy
)GROUP BY TYPE,port,CCY


--FORWARD
SELECT TYPE OPICS_EQUATION,port BANK_CORP,CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount FROM(
select 'CCY' CCY_CTR,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ccy,
case when case when ccyamt<0 then -1 else 1 end = 1 then Sum(ccyamt) else 0 end cr_amount,case when case when ccyamt<0 then -1 else 1 end = -1 then Sum(ccyamt)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL AND (TRIM(SWAPDEAL)='0' AND SPOTFWDIND='F') 
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CCY',case when ccyamt<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,CCy
union all
select 'CTR',case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ctrccy,
case when case when CTRAMT<0 then -1 else 1 end = 1 then Sum(CTRAMT) else 0 end cr_amount,case when case when CTRAMT<0 then -1 else 1 end = -1 then Sum(CTRAMT)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL  AND (TRIM(SWAPDEAL)='0' AND SPOTFWDIND='F' )
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CTR',case when CTRAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ctrCCy
)GROUP BY TYPE,port,CCY

--SWAP FARWARD
SELECT TYPE OPICS_EQUATION,port BANK_CORP,CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount FROM(
select 'CCY' CCY_CTR,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ccy,
case when case when ccyamt<0 then -1 else 1 end = 1 then Sum(ccyamt) else 0 end cr_amount,case when case when ccyamt<0 then -1 else 1 end = -1 then Sum(ccyamt)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL AND (TRIM(SWAPDEAL) <> 0 and FARNEARIND='F' ) 
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CCY',case when ccyamt<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,CCy
union all
select 'CTR',case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ctrccy,
case when case when CTRAMT<0 then -1 else 1 end = 1 then Sum(CTRAMT) else 0 end cr_amount,case when case when CTRAMT<0 then -1 else 1 end = -1 then Sum(CTRAMT)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL  AND (TRIM(SWAPDEAL) <> 0 and FARNEARIND='F' )
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CTR',case when CTRAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ctrCCy
)GROUP BY TYPE,port,CCY

--INTERNAL 
SELECT TYPE OPICS_EQUATION,port BANK_CORP,CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount FROM(
select 'CCY' CCY_CTR,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END PORT,ccy,
case when case when ccyamt<0 then -1 else 1 end = 1 then Sum(ccyamt) else 0 end cr_amount,case when case when ccyamt<0 then -1 else 1 end = -1 then Sum(ccyamt)  else 0 end dr_amount,SUM(CCYINTAMT) 
FROM FXIH WHERE MDATE > to_date(get_param('EOD_DATE'),'dd-mm-yyyy')
AND BR = '01' AND REVDATE IS NULL-- and (ccy='AED' OR CTRCCY='AED' )
GROUP BY 'CCY',case when ccyamt<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ccy
UNION ALL
select 'CTR',case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END PORT,CTRCCY,
case when case when CTRAMT<0 then -1 else 1 end = 1 then Sum(CTRAMT) else 0 end cr_amount,case when case when CTRAMT<0 then -1 else 1 end = -1 then Sum(CTRAMT)  else 0 end dr_amount,SUM(CTRINTAMT) 
FROM FXIH WHERE MDATE > to_date(get_param('EOD_DATE'),'dd-mm-yyyy')
AND BR = '01' AND REVDATE IS NULL-- and (ccy='AED' OR CTRCCY='AED' )
GROUP BY 'CTR',case when CTRAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,CTRCCY 
)GROUP BY TYPE,port,CCY

--SWAP
SELECT 'OPICS' OPICS_EQUATION,'CCIRST' SUBTYPE,S1.NOTCCY ccy ,case when case when S1.NOTCCYAMT<0 then -1 else 1 end = 1 then Sum(S1.NOTCCYAMT) else 0 end cr_amount,case when case when S1.NOTCCYAMT<0 then -1 else 1 end = -1 then Sum(S1.NOTCCYAMT)  else 0 end dr_amount FROM SWDT S1 
INNER JOIN SWDH H ON trim(S1.DEALNO)=trim(H.DEALNO) AND TRIM(H.REVDATE) IS NULL
WHERE S1.MATDATE>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND S1.PRODTYPE='CS'
GROUP BY S1.NOTCCY,case when S1.NOTCCYAMT<0 then -1 else 1 end;


================================================================================




select * from (select case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END OPICS_EQUATION,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END BANK_CORP ,ccy1 CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount from(
Select 'ccy' ccy,PORT,ccy1, 
 case when case when CCY1AMT<0 then -1 else 1 end = 1 then Sum(CCY1AMT) else 0 end cr_amount,case when case when CCY1AMT<0 then -1 else 1 end = -1 then Sum(CCY1AMT)  else 0 end dr_amount
 From CPPR 
 Where br = '01' --AND  CCY1='AED'
 and vdate > TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY')  
 Group By 'ccy',PORT,ccy1,case when CCY1AMT<0 then -1 else 1 end
 Union All
Select 'ctr',PORT,ccy2, 
 case when case when CCY2AMT<0 then -1 else 1 end = 1 then Sum(CCY2AMT) else 0 end cr_amount,case when case when CCY2AMT<0 then -1 else 1 end = -1 then Sum(CCY2AMT)  else 0 end dr_amount
 From CPPR 
 Where br = '01'-- AND  CCY2='AED'
 and vdate > TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') 
 Group By 'ctr',PORT,ccy2,case when CCY2AMT<0 then -1 else 1 end
)
group by  case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END ,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ccy1
ORDER BY ccy1) a
left join 
(SELECT TYPE OPICS_EQUATION,port BANK_CORP,CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount FROM(
select 'CCY' CCY_CTR,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ccy,
case when case when ccyamt<0 then -1 else 1 end = 1 then Sum(ccyamt) else 0 end cr_amount,case when case when ccyamt<0 then -1 else 1 end = -1 then Sum(ccyamt)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL AND (TRIM(SWAPDEAL)='0' AND SPOTFWDIND='S') 
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CCY',case when ccyamt<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,CCy
union all
select 'CTR',case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ctrccy,
case when case when CTRAMT<0 then -1 else 1 end = 1 then Sum(CTRAMT) else 0 end cr_amount,case when case when CTRAMT<0 then -1 else 1 end = -1 then Sum(CTRAMT)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL  AND (TRIM(SWAPDEAL)='0' AND SPOTFWDIND='S' )
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CTR',case when CTRAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ctrCCy
)GROUP BY TYPE,port,CCY) b on a.OPICS_EQUATION = b.OPICS_EQUATION and a.BANK_CORP =b.BANK_CORP and a.CCY = b.CCY
left join 
(SELECT TYPE OPICS_EQUATION,port BANK_CORP,CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount FROM(
select 'CCY' CCY_CTR,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ccy,
case when case when ccyamt<0 then -1 else 1 end = 1 then Sum(ccyamt) else 0 end cr_amount,case when case when ccyamt<0 then -1 else 1 end = -1 then Sum(ccyamt)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL AND (TRIM(SWAPDEAL)='0' AND SPOTFWDIND='F') 
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CCY',case when ccyamt<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,CCy
union all
select 'CTR',case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ctrccy,
case when case when CTRAMT<0 then -1 else 1 end = 1 then Sum(CTRAMT) else 0 end cr_amount,case when case when CTRAMT<0 then -1 else 1 end = -1 then Sum(CTRAMT)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL  AND (TRIM(SWAPDEAL)='0' AND SPOTFWDIND='F' )
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CTR',case when CTRAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ctrCCy
)GROUP BY TYPE,port,CCY) c on a.OPICS_EQUATION = c.OPICS_EQUATION and a.BANK_CORP =c.BANK_CORP and a.CCY = c.CCY
left join 
(SELECT TYPE OPICS_EQUATION,port BANK_CORP,CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount FROM(
select 'CCY' CCY_CTR,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ccy,
case when case when ccyamt<0 then -1 else 1 end = 1 then Sum(ccyamt) else 0 end cr_amount,case when case when ccyamt<0 then -1 else 1 end = -1 then Sum(ccyamt)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL AND (TRIM(SWAPDEAL) <> 0  ) 
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CCY',case when ccyamt<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,CCy
union all
select 'CTR',case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ctrccy,
case when case when CTRAMT<0 then -1 else 1 end = 1 then Sum(CTRAMT) else 0 end cr_amount,case when case when CTRAMT<0 then -1 else 1 end = -1 then Sum(CTRAMT)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL  AND (TRIM(SWAPDEAL) <> 0 )
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CTR',case when CTRAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ctrCCy
)GROUP BY TYPE,port,CCY) d on a.OPICS_EQUATION = d.OPICS_EQUATION and a.BANK_CORP =d.BANK_CORP and a.CCY = d.CCY
left join 
(SELECT TYPE OPICS_EQUATION,port BANK_CORP,CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount FROM(
select 'CCY' CCY_CTR,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END PORT,ccy,
case when case when ccyamt<0 then -1 else 1 end = 1 then Sum(ccyamt) else 0 end cr_amount,case when case when ccyamt<0 then -1 else 1 end = -1 then Sum(ccyamt)  else 0 end dr_amount
FROM FXIH WHERE MDATE > to_date(get_param('EOD_DATE'),'dd-mm-yyyy')
AND BR = '01' AND REVDATE IS NULL-- and (ccy='AED' OR CTRCCY='AED' )
GROUP BY 'CCY',case when ccyamt<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ccy
UNION ALL
select 'CTR',case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END PORT,CTRCCY,
case when case when CTRAMT<0 then -1 else 1 end = 1 then Sum(CTRAMT) else 0 end cr_amount,case when case when CTRAMT<0 then -1 else 1 end = -1 then Sum(CTRAMT)  else 0 end dr_amount
FROM FXIH WHERE MDATE > to_date(get_param('EOD_DATE'),'dd-mm-yyyy')
AND BR = '01' AND REVDATE IS NULL-- and (ccy='AED' OR CTRCCY='AED' )
GROUP BY 'CTR',case when CTRAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,CTRCCY 
union all
select 'CCY' CCY_CTR,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ccy,
case when case when ccyamt<0 then -1 else 1 end = 1 then Sum(ccyamt) else 0 end cr_amount,case when case when ccyamt<0 then -1 else 1 end = -1 then Sum(ccyamt)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL AND (TRIM(SWAPDEAL) <> 0 and FARNEARIND='N' ) 
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CCY',case when ccyamt<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,CCy
union all
select 'CTR',case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ctrccy,
case when case when CTRAMT<0 then -1 else 1 end = 1 then Sum(CTRAMT) else 0 end cr_amount,case when case when CTRAMT<0 then -1 else 1 end = -1 then Sum(CTRAMT)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL  AND (TRIM(SWAPDEAL) <> 0 and FARNEARIND='N' )
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CTR',case when CTRAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ctrCCy
)GROUP BY TYPE,port,CCY) e on a.OPICS_EQUATION = e.OPICS_EQUATION and a.BANK_CORP =e.BANK_CORP and a.CCY = e.CCY
left join 
(SELECT 'OPICS' OPICS_EQUATION,'BANK' BANK_CORP,S1.NOTCCY ccy ,case when case when S1.NOTCCYAMT<0 then -1 else 1 end = 1 then Sum(S1.NOTCCYAMT) else 0 end cr_amount,case when case when S1.NOTCCYAMT<0 then -1 else 1 end = -1 then Sum(S1.NOTCCYAMT)  else 0 end dr_amount FROM SWDT S1 
INNER JOIN SWDH H ON trim(S1.DEALNO)=trim(H.DEALNO) AND TRIM(H.REVDATE) IS NULL
WHERE S1.MATDATE>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND S1.PRODTYPE='CS'
GROUP BY S1.NOTCCY,case when S1.NOTCCYAMT<0 then -1 else 1 end) F on a.OPICS_EQUATION = F.OPICS_EQUATION and a.BANK_CORP =F.BANK_CORP and a.CCY = f.CCY
order by a.ccy,a.BANK_CORP





--INTERNAL NEAR LEG

SELECT TYPE OPICS_EQUATION,port BANK_CORP,CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount FROM(
select 'CCY' CCY_CTR,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END PORT,ccy,
case when case when CCYPRINAMT<0 then -1 else 1 end = 1 then Sum(CCYPRINAMT) else 0 end cr_amount,case when case when CCYPRINAMT<0 then -1 else 1 end = -1 then Sum(CCYPRINAMT)  else 0 end dr_amount
FROM FXIH WHERE VDATE > to_date(get_param('EOD_DATE'),'dd-mm-yyyy')
AND BR = '01' AND REVDATE IS NULL-- and (ccy='AED' OR CTRCCY='AED' )
GROUP BY 'CCY',case when CCYPRINAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ccy
UNION ALL
select 'CTR',case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END PORT,CTRCCY,
case when case when CTRPRINAMT<0 then -1 else 1 end = 1 then Sum(CTRPRINAMT) else 0 end cr_amount,case when case when CTRPRINAMT<0 then -1 else 1 end = -1 then Sum(CTRPRINAMT)  else 0 end dr_amount 
FROM FXIH WHERE VDATE > to_date(get_param('EOD_DATE'),'dd-mm-yyyy')
AND BR = '01' AND REVDATE IS NULL-- and (ccy='AED' OR CTRCCY='AED' )
GROUP BY 'CTR',case when CTRPRINAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,CTRCCY 
)GROUP BY TYPE,port,CCY


--SWAP NEAR LEG
SELECT TYPE OPICS_EQUATION,port BANK_CORP,CCY,(sum(CR_AMOUNT)) CR_AMOUNT,(sum(DR_AMOUNT)) DR_AMOUNT,sum(DR_AMOUNT+CR_AMOUNT) net_amount FROM(
select 'CCY' CCY_CTR,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ccy,
case when case when ccyamt<0 then -1 else 1 end = 1 then Sum(ccyamt) else 0 end cr_amount,case when case when ccyamt<0 then -1 else 1 end = -1 then Sum(ccyamt)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL AND (TRIM(SWAPDEAL) <> 0 and FARNEARIND='N' ) 
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CCY',case when ccyamt<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,CCy
union all
select 'CTR',case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END TYPE,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END port,ctrccy,
case when case when CTRAMT<0 then -1 else 1 end = 1 then Sum(CTRAMT) else 0 end cr_amount,case when case when CTRAMT<0 then -1 else 1 end = -1 then Sum(CTRAMT)  else 0 end dr_amount from fxdh
INNER JOIN CUST C ON TRIM(C.CNO)=TRIM(CUST)
WHERE TO_DATE(VDATE,'YYYY-MM-DD')>TO_DATE(get_param('EOD_DATE'),'DD-MM-YYYY') AND TRIM(PRODCODE)!='CCS' AND TRIM(REVDATE) IS NULL  AND (TRIM(SWAPDEAL) <> 0 and FARNEARIND='N' )
AND TRIM(C.CMNE)!='CCIRS' and trim(PORT)!='EQFX' group by 'CTR',case when CTRAMT<0 then -1 else 1 end,case when PORT ='EQFX' then 'EQUATION' ELSE 'OPICS' END,case when PORT in('CORP','EQFX') then 'CORP' ELSE 'BANK' END,ctrCCy
)GROUP BY TYPE,port,CCY 
