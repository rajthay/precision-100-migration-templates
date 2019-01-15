-- File Name		: SUPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table SUPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   SUAB,
   SUAN,
   SUAS,
   SUSBTP,
   SUSMO,
   SUBP01,
   SUBP02,
   SUBP03,
   SUBP04,
   SUBP05,
   SUBP06,
   SUBP07,
   SUBP08,
   SUBP09,
   SUBP10,
   SUBP11,
   SUBP12,
   SUBPTD,
   SUBPML,
   SUNPE1,
   SUNPE2,
   SUNPE3,
   SUNPE4,
   SUNPE5,
   SUNPE6,
   SUNPE7,
   SUNPE8,
   SUNPE9,
   SUNPEA,
   SUNPEB,
   SUNPEC,
   SUNPEM,
   SUNPEL
)

