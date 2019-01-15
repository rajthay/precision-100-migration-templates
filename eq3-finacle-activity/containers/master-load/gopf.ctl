-- File Name		: GOPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table GOPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   GOC5R,
   GOC5D,
   GOILM,
   GOMIL,
   GOTMR
)

