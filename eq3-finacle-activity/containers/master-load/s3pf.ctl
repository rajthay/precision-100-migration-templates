-- File Name		: S3PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table S3PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   S3AB,
   S3AN,
   S3AS,
   S3DTE,
   S3BAL,
   S3AMTP,
   S3CBAL
)

