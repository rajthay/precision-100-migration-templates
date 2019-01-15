-- File Name		: MAP_OFF_ACC.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
--truncate into table MAP_OFF_ACC
append into table MAP_OFF_ACC
fields terminated by x'09'
TRAILING NULLCOLS
(
    LEG_ACC_NUM,
    FIN_ACC_NUM,     
    FIN_SOL_ID FILLER,
	CCY FILLER,
    FIN_SCHEME_CODE FILLER,
    FIN_SCHEME_TYPE FILLER,
    FIN_GL_SUB_HEAD FILLER,
	ACCOUNT_NAME,
    FIN_PLACE_HOLDER FILLER
  )