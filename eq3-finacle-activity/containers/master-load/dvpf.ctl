-- File Name		: DVPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table DVPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   DVABC,
   DVANC,
   DVASC,
   DVCBTC,
   DVDREQ,
   DVSOUR,
   DVSPI1,
   DVSPI2,
   DVSPI3,
   DVSPI4,
   DVCHAR,
   DVTAXD,
   DVREOR,
   DVSEQ,
   DVCHCD
 )

