TRUNCATE TABLE FX_OTC_O_TABLE;

INSERT INTO FX_OTC_O_TABLE
SELECT '' Response,
       '' Product,
       '' Identifier,
       '' Counterparty,
       '' BUY_SELL,
       '' CALL_PUT,
       '' Currency_Pair,
       '' LEFT_NEAR_VAL,
       '' Contract_Rate,
       '' RIGHT_NEAR_VAL,
       '' Option_Style,
       '' Expiry_Date,
       '' Expiry_Time,
       '' Delivery_Date,
       '' Settlement_Delay,
       '' Premium_Quote,
       '' Premium_Currency,
       '' Premium_Rate,
       '' Premium_Due_Date,
       '' Reval_Method,
       '' Strategy_Type,
       '' Settlement_Method,
       '' OTC_Reset_Method,
       '' TRADING_BOOK,
       '' SPOT_TRD_BOOK,
       '' FWD_TRD_BOOK,
       '' ENTITY_NAME,
       '' DEPT_NAME,
       '' SUBTYPE,
       '' HOLDING_ENTITY_NAME,
       '' HOLDING_DEPT_NAME,
       '' SPOT_HOLDING_SUBTYPE,
       '' FWD_HOLDING_SUBTYPE
  FROM DUAL;
  COMMIT;
  EXIT; 
