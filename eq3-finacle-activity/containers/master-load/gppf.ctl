-- File Name		: GPPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table GPPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   GPP1R,
   GPP1D,
   GPILM,
   GPMIL,
   GPTMR
)

