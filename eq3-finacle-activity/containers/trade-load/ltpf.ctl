-- File Name		: LTPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table LTPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   LTBRNM,
   LTDLP,
   LTDLR,
   LTDTE,
   LTMVT,
   LTMVTS,
   LTNS3,
   LTDTEM,
   LTMVTM,
   LTNS3M,
   LTAMT,
   LTYCA,
   LTYPRP,
   LTOAMT,
   LTNS3P,
   LTPNS3,
   LTDTEP,
   LTNS3W,
   LTEPA,
   LTPAMT
)

