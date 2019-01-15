-- File Name		: MAP_ACC_OFFICER.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table MAP_ACC_OFFICER
fields terminated by x'09'
TRAILING NULLCOLS
(
    EMP_NAME,
    LEG_USER,
    LEG_ACC_OFFICER_CODE,
    FIN_SOL_ID,
    FIN_USER_ID
  )
  