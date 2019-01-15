-- File Name		: H4PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table H4PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   H4BRNM,
   H4LNP,
   H4DLR,
   H4PDT,
   H4PPP,
   H4IPP,
   H4CPI,
   H4YADJ,
   H4NS3P,
   H4AIM2,
   H4LSDT,
   H4PNS3,
   H4ADTE
)

