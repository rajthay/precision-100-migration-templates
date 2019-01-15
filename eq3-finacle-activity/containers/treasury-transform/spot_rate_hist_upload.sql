TRUNCATE TABLE SPOT_RATES_HIST_O_TABLE;
DECLARE 
V_SPOT_RATE_COL VARCHAR2(100);
V_SPOT_RATE_DATE VARCHAR2(100);
plsql_block VARCHAR2(4000);
V_no_of_days number;
CURSOR C1 IS SELECT ADD_MONTHS(TO_DATE('201601','YYYYMM'),ROWNUM-1) V_DATE FROM DUAL CONNECT BY ROWNUM< Months_between(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY'),TO_DATE('201601','YYYYMM'))+1;
BEGIN
 FOR l_RECORD IN C1  LOOP
    select to_char(last_day(l_RECORD.V_DATE),'dd') into V_no_of_days from dual;
    FOR I IN 1..V_no_of_days LOOP
        V_SPOT_RATE_COL := 'SPOTRATE'||I||'_8';
        V_SPOT_RATE_DATE := TO_CHAR(l_RECORD.V_DATE+i-1,'DD-Mon-YYYY');
        --DBMS_OUTPUT.PUT_LINE('V_SPOT_RATE_DATE-'||V_SPOT_RATE_DATE);
        --DBMS_OUTPUT.PUT_LINE('V_SPOT_RATE_COL-'||V_SPOT_RATE_COL);
        plsql_block :=  'INSERT INTO SPOT_RATES_HIST_O_TABLE 
        SELECT 
        '''' Response,
        CASE WHEN A.CCY IN (''AUD'',''EUR'',''GBP'',''NZD'') THEN A.CCY||''/USD'' ELSE ''USD/''||A.CCY END Currency_Pair,  
        CASE WHEN A.CCY IN (''AUD'',''EUR'',''GBP'',''NZD'') THEN TO_CHAR(A.CCY) ELSE ''USD'' END Currency_One,  
        CASE WHEN A.CCY IN (''AUD'',''EUR'',''GBP'',''NZD'') THEN ''USD'' ELSE TO_CHAR(A.CCY) END Currency_Two,
        CASE WHEN A.CCY IN (''JPY'') AND GET_PARAM(''BANK_ID'')=''51''  then  TO_CHAR(B.'||V_SPOT_RATE_COL||'*to_number(A.'||V_SPOT_RATE_COL||'),''999990.99999999'') WHEN A.CCY IN (''AUD'',''EUR'',''GBP'',''NZD'') THEN TO_CHAR(to_number(A.'||V_SPOT_RATE_COL||')/B.'||V_SPOT_RATE_COL||',''999990.99999999'') ELSE TO_CHAR(B.'||V_SPOT_RATE_COL||'/to_number(A.'||V_SPOT_RATE_COL||'),''999990.99999999'') END Bid,
        CASE WHEN A.CCY IN (''JPY'') AND GET_PARAM(''BANK_ID'')=''51''  then  TO_CHAR(B.'||V_SPOT_RATE_COL||'*to_number(A.'||V_SPOT_RATE_COL||'),''999990.99999999'') WHEN A.CCY IN (''AUD'',''EUR'',''GBP'',''NZD'') THEN TO_CHAR(to_number(A.'||V_SPOT_RATE_COL||')/B.'||V_SPOT_RATE_COL||',''999990.99999999'') ELSE TO_CHAR(B.'||V_SPOT_RATE_COL||'/to_number(A.'||V_SPOT_RATE_COL||'),''999990.99999999'') END Offer ,
        '''||(TO_CHAR(l_RECORD.V_DATE+i-1,'dd-Mon-yyyy'))||''' Base_Date
        FROM SRHR A
        LEFT JOIN SRHR B ON TRIM(B.CCY)=''USD'' AND TRIM(A.YRMONTH) = TRIM(B.YRMONTH)
        WHERE to_number(A.'||V_SPOT_RATE_COL||') <>0 and A.CCY NOT IN(''LOC'',''USD'',''NOK'',''TND'',''CNY'',''KRW'',''MYR'',''CYP'')
        AND A.YRMONTH='||(TO_CHAR(l_RECORD.V_DATE+i-1,'YYYYMM'));
        --DBMS_OUTPUT.PUT_LINE('plsql_block---'||plsql_block);
        EXECUTE IMMEDIATE plsql_block;
        commit;
    END LOOP;
   END LOOP;
   commit;
END;
exit;
 