-- File Name		: V4PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table V4PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   V4BRNM,
   V4DLP,
   V4DLR,
   V4DTE,
   V4TDT,
   V4AIM1,
   V4AIM2,
   V4AIM3,
   V4AIM4,
   V4IAM1,
   V4DTE2,
   V4YNMI,
   V4YNMA,
   V4PEN,
   V4FCI
)

