-- File Name		: S4PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table S4PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   S4AB,
   S4AN,
   S4AS,
   S4DTE,
   S4NEGP,
   S4AIM1,
   S4AIM2,
   S4AIM3,
   S4AIM4,
   S4IAM1,
   S4DTE2,
   S4YNMI,
   S4CUC,
   S4FCI,
   S4NAI1,
   S4NAPI,
   S4CRP,
   S4PFW,
   S4CAP
)

