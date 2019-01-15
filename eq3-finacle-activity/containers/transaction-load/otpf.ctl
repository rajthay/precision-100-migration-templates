-- File Name		: OTPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table otPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   OTBRNM,
   OTDLP,
   OTDLR,
   OTCCY,
   OTDLA,
   OTSDTE,
   OTMDT,
   OTDLA2,
   OTTDT,
   OTASC,
   OTCLT
)
