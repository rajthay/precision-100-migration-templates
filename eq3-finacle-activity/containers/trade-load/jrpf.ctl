-- File Name		: JRPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table JRPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   JRPRC,
   JRPRD,
   JRNUM,
   JRDDY,
   JRSEQ
)

