-- File Name		: JEPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table JEPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   JEBRNM,
   JEDLP,
   JEDLR,
   JEDTE,
   JEMVT,
   JEMVTS,
   JENS3,
   JEBRNT,
   JEDLPT,
   JEDLRT,
   JEPRC,
   JENRD,
   JEROL,
   JEPRR,
   JERRP,
   JEPRS,
   JEDLM,
   JEINSR,
   JETCD,
   JEBON,
   JEBOW
)

