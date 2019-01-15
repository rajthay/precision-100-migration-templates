SELECT BR,
       DEALNO,
       PS,
       CCYTERMS,
       SEQ,
       BASEFARPD_8,
       BASEFARRATE_8,
       BASENEARPD_8,
       BASENEARRATE_8,
       BRPRCINDTE,
       CCY,
       CCYPRINAMT,
       CTRCCY,
       CTRPRINAMT,
       CCY,
       CCYAMT,
       CTRCCY,
       CTRAMT,
       CCYFARBAMT,
       CCYFARSPOTBAMT,
       CCYINTAMT,
       CCYBASIS,
       CCYINTRATE_8,
       CTRINTRATE_8,
       DEALDATE,
       VDATE,
       MDATE
  FROM FXIH
 WHERE     MDATE > '31 DEC 2016'
       AND INPUTDATE < '31 DEC 2016'
       AND BR = '51'
       AND REVDATE IS NULL;
