-- File Name		: HXPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table HXPF
fields terminated by x'09'
TRAILING NULLCOLS
(
  HXDLP,
  HXDLR,
  HXDBNM,
  HXAB,
  HXAN,
  HXAS,
  HXCMR,
  HXCCY,
  HXCCY2,
  HXCLR,
  HXCDLP,
  HXCDLR,
  HXCDBN,
  HXCAB,
  HXCAN,
  HXCAS,
  HXASP,
  HXASR,
  HXMAX,
  HXAAMT,
  HXTOTA,
  HXRTP,
  HXDDYN,
  HXSEQ,
  HXDCMR
)

