TRUNCATE TABLE SECURITY_PRICES_O_TABLE;
INSERT INTO SECURITY_PRICES_O_TABLE
SELECT
'' Response,
trim(S.SECID) Security,
to_char(S.CLPRICE_8,'9999999990.99999999') Bid,
to_char(S.CLPRICE_8,'9999999990.99999999') Offer,
TO_CHAR(S.LSTMNTDATE,'DD-Mon-YYYY') Base_Date
FROM (select * from SECP a where exists( select 1 from(
select br,secid,max(LSTMNTDATE) LSTMNTDATE from SECP group by br,secid) b where a.br = b.br and a.secid = b.secid and a.LSTMNTDATE = b.LSTMNTDATE)) S
inner join secm M on trim(S.secid)=trim(m.secid) 
where --S.CLPRICE_8<>0
--and MDATE > to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
--and S.LSTMNTDATE >= to_date(get_param('EOD_DATE'),'DD-MM-YYYY')
--AND  
TRIM(S.SECID) IN (SELECT trim(SECID) FROM TR_EQU_AND_SEC_OUTSTANDING WHERE TRIM(TYPE)='Fixed Income Investments' AND TRIM(NETQTY) != 0 AND TRIM(NETQTY) IS NOT NULL
union all
select trim(secid) secid from secm where trim(PRODTYPE) in ('TB','SB')  and MDATE > to_date(get_param('EOD_DATE'),'dd-mm-yyyy')
union 
select trim(secid) from SPSH where INVTYPE='I')
--AND M.PRODTYPE IN ('F1','F2','FI','SB','TB','TL') 
--AND S.LSTMNTDATE >=TO_DATE('01-01-2014','DD-MM-YYYY')
;
COMMIT;
--update SECURITY_PRICES_O_TABLE set BID='100' , OFFER='100'  where trim(SECURITY) in ('NIG BD 12/20/2021','MARKAZ BD 12/26/2021');
--commit;
EXIT; 
