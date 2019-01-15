-- File Name		: MAP_CIF_MK3_BK.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

 load data
truncate into table MAP_CIF_MK3_BK
fields terminated by '|'
TRAILING NULLCOLS
(
  LEG_CUST_NUMBER,
  LEG_CUST_BRANCH,
  FIN_CIF_ID,
  FIN_SOL_ID,
  CIF_NAME,
  INDIVIDUAL,
  CIF_SEQ,
  GFCUS,
  GFCLC,
  GFCPNC,
  GFBRNM,
  IS_JOINT,
  DEL_FLG
  )