-- File Name		: LSPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table LSPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   LSBRNM,
   LSDLP,
   LSDLR,
   LSDTE,
   LSMVT,
   LSMVTS,
   LSNS3,
   LSAMTD,
   LSAMTP,
   LSLSC,
   LSUP,
   LSBFP,
   LSPDTE,
   LSSDSC,
   LSUP1,
   LSNCAL
)
