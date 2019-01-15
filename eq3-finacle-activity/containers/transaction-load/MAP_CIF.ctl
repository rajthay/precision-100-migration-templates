-- File Name		: MAP_CIF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

 load data
truncate into table MAP_CIF
fields terminated by x'09'
TRAILING NULLCOLS
(
    LEG_CUST_NUMBER,
    LEG_CUST_BRANCH,
    DEDUPE_CUST_ID,
    FIN_CIF_ID,
    FIN_SOL_ID,
    CIF_NAME
  )