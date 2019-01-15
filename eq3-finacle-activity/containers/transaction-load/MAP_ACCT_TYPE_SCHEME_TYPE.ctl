-- File Name		: MAP_ACCT_TYPE_SCHEME_TYPE.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table MAP_ACCT_TYPE_SCHEME_TYPE
fields terminated by x'09'
TRAILING NULLCOLS
(
    LEG_ACCT_TYPE,
    LEG_DEAL_TYPE,
    LEG_ACCT_DESC,
    FIN_SCH_TYPE,
    FIN_SCH_CODE,
    FIN_GL_SUBHEAD,
    FIN_SCHEME_CODE_DESC,
    IS_VALID,
    CCY
  )
  
