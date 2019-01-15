-- File Name		: GKPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table GKPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   GKC1R,
   GKC1D,
   GKILM,
   GKMIL,
   GKTMR
)

