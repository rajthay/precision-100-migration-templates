TRUNCATE TABLE FORWARD_RATES_O_TABLE;
INSERT INTO FORWARD_RATES_O_TABLE
SELECT ''Response,
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END Currency_Pair,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN TO_CHAR(A.CCY) ELSE 'USD' END Currency_One,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 'USD' ELSE TO_CHAR(A.CCY) END Currency_Two,
    'TOM' NominaL,
    CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE1_8) <> 0 THEN (to_number(B.RATE1_8)*to_number(A.RATE1_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE1_8) <> 0 THEN (to_number(A.RATE1_8)/to_number(B.RATE1_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE1_8) <> 0 THEN to_number(B.RATE1_8)/to_number(A.RATE1_8)-to_number(C.BID) ELSE 0 END 
     END Bid,
     CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE1_8) <> 0 THEN (to_number(B.RATE1_8)*to_number(A.RATE1_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE1_8) <> 0 THEN (to_number(A.RATE1_8)/to_number(B.RATE1_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE1_8) <> 0 THEN (B.RATE1_8/to_number(A.RATE1_8))-to_number(C.BID) ELSE 0 END 
     END Offer,
    TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY'),'DD-Mon-YYYY') Base_Date
 FROM REVP A
 LEFT JOIN REVP B ON B.CCY='USD'
 LEFT JOIN SPOT_RATES_O_TABLE C ON C.CURRENCY_PAIR = CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END
 WHERE A.CCY NOT IN('LOC','USD','NOK','TND','CNY','KRW','MYR','CYP')
UNION ALL
 SELECT 
    ''Response,
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END Currency_Pair,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN TO_CHAR(A.CCY) ELSE 'USD' END Currency_One,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 'USD' ELSE TO_CHAR(A.CCY) END Currency_Two,
    '1W' NominaL,
    CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE2_8) <> 0 THEN (to_number(B.RATE2_8)*to_number(A.RATE2_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE2_8) <> 0 THEN (to_number(A.RATE2_8)/to_number(B.RATE2_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE2_8) <> 0 THEN to_number(B.RATE2_8)/to_number(A.RATE2_8)-to_number(C.BID) ELSE 0 END 
     END Bid,
     CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE2_8) <> 0 THEN (to_number(B.RATE2_8)*to_number(A.RATE2_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE2_8) <> 0 THEN (to_number(A.RATE2_8)/to_number(B.RATE2_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE2_8) <> 0 THEN (B.RATE2_8/to_number(A.RATE2_8))-to_number(C.BID) ELSE 0 END 
     END Offer,
    TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY'),'DD-Mon-YYYY') Base_Date
 FROM REVP A
 LEFT JOIN REVP B ON B.CCY='USD'
 LEFT JOIN SPOT_RATES_O_TABLE C ON C.CURRENCY_PAIR = CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END
 WHERE A.CCY NOT IN('LOC','USD','NOK','TND','CNY','KRW','MYR','CYP')
UNION ALL
SELECT 
    ''Response,
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END Currency_Pair,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN TO_CHAR(A.CCY) ELSE 'USD' END Currency_One,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 'USD' ELSE TO_CHAR(A.CCY) END Currency_Two,
    '1M' NominaL,
    CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE3_8) <> 0 THEN (to_number(B.RATE3_8)*to_number(A.RATE3_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE3_8) <> 0 THEN (to_number(A.RATE3_8)/to_number(B.RATE3_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE3_8) <> 0 THEN to_number(B.RATE3_8)/to_number(A.RATE3_8)-to_number(C.BID) ELSE 0 END 
     END Bid,
     CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE3_8) <> 0 THEN (to_number(B.RATE3_8)*to_number(A.RATE3_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE3_8) <> 0 THEN (to_number(A.RATE3_8)/to_number(B.RATE3_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE3_8) <> 0 THEN (B.RATE3_8/to_number(A.RATE3_8))-to_number(C.BID) ELSE 0 END 
     END Offer,
    TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY'),'DD-Mon-YYYY') Base_Date
 FROM REVP A
 LEFT JOIN REVP B ON B.CCY='USD'
 LEFT JOIN SPOT_RATES_O_TABLE C ON C.CURRENCY_PAIR = CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END
 WHERE A.CCY NOT IN('LOC','USD','NOK','TND','CNY','KRW','MYR','CYP')
UNION ALL  
  SELECT 
    ''Response,
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END Currency_Pair,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN TO_CHAR(A.CCY) ELSE 'USD' END Currency_One,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 'USD' ELSE TO_CHAR(A.CCY) END Currency_Two,
    '2M' NominaL,
    CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE4_8) <> 0 THEN (to_number(B.RATE4_8)*to_number(A.RATE4_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE4_8) <> 0 THEN (to_number(A.RATE4_8)/to_number(B.RATE4_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE4_8) <> 0 THEN to_number(B.RATE4_8)/to_number(A.RATE4_8)-to_number(C.BID) ELSE 0 END 
     END Bid,
     CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE4_8) <> 0 THEN (to_number(B.RATE4_8)*to_number(A.RATE4_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE4_8) <> 0 THEN (to_number(A.RATE4_8)/to_number(B.RATE4_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE4_8) <> 0 THEN (B.RATE4_8/to_number(A.RATE4_8))-to_number(C.BID) ELSE 0 END 
     END Offer,
    TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY'),'DD-Mon-YYYY') Base_Date
 FROM REVP A
 LEFT JOIN REVP B ON B.CCY='USD'
 LEFT JOIN SPOT_RATES_O_TABLE C ON C.CURRENCY_PAIR = CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END
 WHERE A.CCY NOT IN('LOC','USD','NOK','TND','CNY','KRW','MYR','CYP')
 UNION ALL
 SELECT 
    ''Response,
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END Currency_Pair,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN TO_CHAR(A.CCY) ELSE 'USD' END Currency_One,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 'USD' ELSE TO_CHAR(A.CCY) END Currency_Two,
    '3M' NominaL,
    CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE5_8) <> 0 THEN (to_number(B.RATE5_8)*to_number(A.RATE5_8))-to_number(C.BID) ELSE 0 END  WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE5_8) <> 0 THEN (to_number(A.RATE5_8)/to_number(B.RATE5_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE5_8) <> 0 THEN to_number(B.RATE5_8)/to_number(A.RATE5_8)-to_number(C.BID) ELSE 0 END 
     END Bid,
     CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE5_8) <> 0 THEN (to_number(B.RATE5_8)*to_number(A.RATE5_8))-to_number(C.BID) ELSE 0 END  WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE5_8) <> 0 THEN (to_number(A.RATE5_8)/to_number(B.RATE5_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE5_8) <> 0 THEN (B.RATE5_8/to_number(A.RATE5_8))-to_number(C.BID) ELSE 0 END 
     END Offer,
    TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY'),'DD-Mon-YYYY') Base_Date
 FROM REVP A
 LEFT JOIN REVP B ON B.CCY='USD'
 LEFT JOIN SPOT_RATES_O_TABLE C ON C.CURRENCY_PAIR = CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END
 WHERE A.CCY NOT IN('LOC','USD','NOK','TND','CNY','KRW','MYR','CYP')
 UNION ALL
 SELECT 
    ''Response,
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END Currency_Pair,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN TO_CHAR(A.CCY) ELSE 'USD' END Currency_One,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 'USD' ELSE TO_CHAR(A.CCY) END Currency_Two,
    '6M' NominaL,
    CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE6_8) <> 0 THEN (to_number(B.RATE6_8)*to_number(A.RATE6_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE6_8) <> 0 THEN (to_number(A.RATE6_8)/to_number(B.RATE6_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE6_8) <> 0 THEN to_number(B.RATE6_8)/to_number(A.RATE6_8)-to_number(C.BID) ELSE 0 END 
     END Bid,
     CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE6_8) <> 0 THEN (to_number(B.RATE6_8)*to_number(A.RATE6_8))-to_number(C.BID) ELSE 0 END  WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE6_8) <> 0 THEN (to_number(A.RATE6_8)/to_number(B.RATE6_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE6_8) <> 0 THEN (B.RATE6_8/to_number(A.RATE6_8))-to_number(C.BID) ELSE 0 END 
     END Offer,
    TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY'),'DD-Mon-YYYY') Base_Date
 FROM REVP A
 LEFT JOIN REVP B ON B.CCY='USD'
 LEFT JOIN SPOT_RATES_O_TABLE C ON C.CURRENCY_PAIR = CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END
 WHERE A.CCY NOT IN('LOC','USD','NOK','TND','CNY','KRW','MYR','CYP')
 UNION ALL
 SELECT 
    ''Response,
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END Currency_Pair,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN TO_CHAR(A.CCY) ELSE 'USD' END Currency_One,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 'USD' ELSE TO_CHAR(A.CCY) END Currency_Two,
    '9M' NominaL,
    CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE7_8) <> 0 THEN (to_number(B.RATE7_8)*to_number(A.RATE7_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE7_8) <> 0 THEN (to_number(A.RATE7_8)/to_number(B.RATE7_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE7_8) <> 0 THEN to_number(B.RATE7_8)/to_number(A.RATE7_8)-to_number(C.BID) ELSE 0 END 
     END Bid,
     CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE7_8) <> 0 THEN (to_number(B.RATE7_8)*to_number(A.RATE7_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE7_8) <> 0 THEN (to_number(A.RATE7_8)/to_number(B.RATE7_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE7_8) <> 0 THEN (B.RATE7_8/to_number(A.RATE7_8))-to_number(C.BID) ELSE 0 END 
     END Offer,
    TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY'),'DD-Mon-YYYY') Base_Date
 FROM REVP A
 LEFT JOIN REVP B ON B.CCY='USD'
 LEFT JOIN SPOT_RATES_O_TABLE C ON C.CURRENCY_PAIR = CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END
 WHERE A.CCY NOT IN('LOC','USD','NOK','TND','CNY','KRW','MYR','CYP')
 UNION ALL
 SELECT 
    ''Response,
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END Currency_Pair,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN TO_CHAR(A.CCY) ELSE 'USD' END Currency_One,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 'USD' ELSE TO_CHAR(A.CCY) END Currency_Two,
    '1Y' NominaL,
    CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE8_8) <> 0 THEN (to_number(B.RATE8_8)*to_number(A.RATE8_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE8_8) <> 0 THEN (to_number(A.RATE8_8)/to_number(B.RATE8_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE8_8) <> 0 THEN to_number(B.RATE8_8)/to_number(A.RATE8_8)-to_number(C.BID) ELSE 0 END 
     END Bid,
     CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE8_8) <> 0 THEN (to_number(B.RATE8_8)*to_number(A.RATE8_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE8_8) <> 0 THEN (to_number(A.RATE8_8)/to_number(B.RATE8_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE8_8) <> 0 THEN (B.RATE8_8/to_number(A.RATE8_8))-to_number(C.BID) ELSE 0 END 
     END Offer,
    TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY'),'DD-Mon-YYYY') Base_Date
 FROM REVP A
 LEFT JOIN REVP B ON B.CCY='USD'
 LEFT JOIN SPOT_RATES_O_TABLE C ON C.CURRENCY_PAIR = CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END
 WHERE A.CCY NOT IN('LOC','USD','NOK','TND','CNY','KRW','MYR','CYP')
 UNION ALL
 SELECT 
    ''Response,
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END Currency_Pair,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN TO_CHAR(A.CCY) ELSE 'USD' END Currency_One,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 'USD' ELSE TO_CHAR(A.CCY) END Currency_Two,
    '2Y' NominaL,
    CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE9_8) <> 0 THEN (to_number(B.RATE9_8)*to_number(A.RATE9_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE9_8) <> 0 THEN (to_number(A.RATE9_8)/to_number(B.RATE9_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE9_8) <> 0 THEN to_number(B.RATE9_8)/to_number(A.RATE9_8)-to_number(C.BID) ELSE 0 END 
     END Bid,
     CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE9_8) <> 0 THEN (to_number(B.RATE9_8)*to_number(A.RATE9_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE9_8) <> 0 THEN (to_number(A.RATE9_8)/to_number(B.RATE9_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE9_8) <> 0 THEN (B.RATE9_8/to_number(A.RATE9_8))-to_number(C.BID) ELSE 0 END 
     END Offer,
    TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY'),'DD-Mon-YYYY') Base_Date
 FROM REVP A
 LEFT JOIN REVP B ON B.CCY='USD'
 LEFT JOIN SPOT_RATES_O_TABLE C ON C.CURRENCY_PAIR = CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END
 WHERE A.CCY NOT IN('LOC','USD','NOK','TND','CNY','KRW','MYR','CYP')
 UNION ALL
 SELECT 
    ''Response,
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END Currency_Pair,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN TO_CHAR(A.CCY) ELSE 'USD' END Currency_One,  
    CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 'USD' ELSE TO_CHAR(A.CCY) END Currency_Two,
    '3Y' NominaL,
    CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE10_8) <> 0 THEN (to_number(B.RATE10_8)*to_number(A.RATE10_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE10_8) <> 0 THEN (to_number(A.RATE10_8)/to_number(B.RATE10_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE10_8) <> 0 THEN to_number(B.RATE10_8)/to_number(A.RATE10_8)-to_number(C.BID) ELSE 0 END 
     END Bid,
     CASE WHEN A.CCY IN ('JPY') AND GET_PARAM('BANK_ID')='51'  then  CASE WHEN to_number(A.RATE10_8) <> 0 THEN (to_number(B.RATE10_8)*to_number(A.RATE10_8))-to_number(C.BID) ELSE 0 END WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN 
            CASE WHEN to_number(B.RATE10_8) <> 0 THEN (to_number(A.RATE10_8)/to_number(B.RATE10_8))-to_number(C.BID) ELSE 0 END  
         ELSE
            CASE WHEN to_number(A.RATE10_8) <> 0 THEN (B.RATE10_8/to_number(A.RATE10_8))-to_number(C.BID) ELSE 0 END 
     END Offer,
    TO_CHAR(TO_DATE(GET_PARAM('EOD_DATE'),'DD-MM-YYYY'),'DD-Mon-YYYY') Base_Date
 FROM REVP A
 LEFT JOIN REVP B ON B.CCY='USD'
 LEFT JOIN SPOT_RATES_O_TABLE C ON C.CURRENCY_PAIR = CASE WHEN A.CCY IN ('AUD','EUR','GBP','NZD') THEN A.CCY||'/USD' ELSE 'USD/'||A.CCY END
 WHERE A.CCY NOT IN('LOC','USD','NOK','TND','CNY','KRW','MYR','CYP');
 update FORWARD_RATES_O_TABLE set BID = to_char(BID,'999999990.99999999'),OFFER = to_char(OFFER,'999999990.99999999');
COMMIT;
EXIT; 
