-- File Name		: V3PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table V3PF
fields terminated by x'09'
TRAILING NULLCOLS
(  
   V3BRNM,
   V3DLP,
   V3DLR,
   V3DTE,
   V3BAL,
   V3AMTP,
   V3SBAL
)

