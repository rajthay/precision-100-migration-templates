-- File Name		: RJPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table RJPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   RJCUS,
   RJCLC,
   RJRCUS,
   RJRCLC,
   RJREL,
   RJNAR1,
   RJNAR2,
   RJNAR3,
   RJNAR4,
   RJPEC,
   RJGAMT,
   RJCCY,
   RJCMR,
   RJXDT,
   RJBRNM,
   RJDLP,
   RJDLR,
   RJAB,
   RJAN,
   RJAS,
   RJCRM,
   RJDLM,
   RJDTE
)

