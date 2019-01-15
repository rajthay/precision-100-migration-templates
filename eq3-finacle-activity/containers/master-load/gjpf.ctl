-- File Name		: GJPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table GJPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   GJNST,
   GJNDS,
   GJCCY,
   GJABF,
   GJANF,
   GJASF,
   GJXM,
   GJDLM,
   GJBAL,
   GJOAN,
   GJEDI,
   GJXMR,
   GJNDSA,
   GJVST
)

