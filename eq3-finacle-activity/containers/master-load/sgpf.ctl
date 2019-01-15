-- File Name		: SGPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table SGPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   SGPOD,
   SGBRNM,
   SGPBR,
   SGPSQ,
   SGNR1,
   SGNR2,
   SGNR3,
   SGNR4,
   SGOCCY,
   SGOAMA
)

