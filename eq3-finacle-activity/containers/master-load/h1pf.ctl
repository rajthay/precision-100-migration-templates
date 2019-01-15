-- File Name		: H1PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table H1PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   H1BRNM,
   H1LNP,
   H1DLR,
   H1LSC,
   H1LDC,
   H1MAN,
   H1SDSC,
   H1CDOP,
   H1USR
)

