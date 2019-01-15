TRUNCATE TABLE EQUITY_PRICES_O_TABLE;
INSERT INTO EQUITY_PRICES_O_TABLE
SELECT
'' Response,
trim(S.SECID) Security,
case WHEN AUTO_OR_MANUAL_RESET='MANUAL' then trim(ISSUER_STRING) else trim(EXCHANGES_LIST) end EXCHANGE_AMC,
to_char(S.CLPRICE_8,'9999999990.99999999') PRICE,
TO_CHAR(S.LSTMNTDATE,'DD-Mon-YYYY') Base_Date
FROM (select * from SECP a where exists( select 1 from(
select br,secid,max(LSTMNTDATE) LSTMNTDATE from SECP group by br,secid) b where a.br = b.br and a.secid = b.secid and a.LSTMNTDATE = b.LSTMNTDATE)) S
inner join secm M on trim(S.secid)=trim(m.secid) --AND M.PRODTYPE NOT IN ('F1','F2','FI','SB','TB','TL')
LEFT JOIN CUST ON TRIM(CNO) = TRIM(ISSUER)
left join EQUITY_DEFN_O_TABLE on trim(name) = trim(S.SECID)
where TRIM(S.SECID) IN (SELECT TRIM(SECID) FROM TR_EQU_AND_SEC_OUTSTANDING WHERE TRIM(TYPE)='Investments' AND TRIM(NETQTY) != 0 AND TRIM(NETQTY) IS NOT NULL AND CASE WHEN TRIM(SECID)='ABK TREASURY' AND TRIM(PORT) !='TS' THEN 0 ELSE 1  END = 1)
--AND S.LSTMNTDATE >=TO_DATE('01-01-2017','DD-MM-YYYY')
;
COMMIT;
--update EQUITY_PRICES_O_TABLE set SECURITY='MUBADALA AAYAN2' where trim(security)='MUBADALA AAYAN CO 2';
--commit;
--update EQUITY_PRICES_O_TABLE set SECURITY=substr(SECURITY,1,15) where trim(security) !='MUBADALA AAYAN2';
--commit;
EXIT; 
