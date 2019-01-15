-- File Name		: NBCMASTPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 15-12-2014
-------------------------------------------------------------------

load data
truncate into table NBCMASTPF
fields terminated by x'09'
TRAILING NULLCOLS
(
NBCAB,
NBCAN,
NBCAS,
NBCACN,
NBCADD,
NBCAMT,
NBCCUR,
NBCSON,
NBCSOS,
NBCSOE,
NBCFRQ,
NBCNDU,
NBCRDD,
NBCLRD,
NBCSUS,
NBCSDT,
NBCUDT,
NBCNOF,
NBCCMP,
NBCCAN,
NBCCDT,
NBCCRU,
NBCCRD,
NBCCRT,
NBCAPR,
NBCLAU,
NBCLAD,
NBCLAT,
NBCLMU,
NBCLMD,
NBCLMT
)
