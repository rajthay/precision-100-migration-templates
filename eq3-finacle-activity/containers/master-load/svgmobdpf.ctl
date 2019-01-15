-- File Name		: SVGMOBDPF.ctl

-- File Created for	: Control file for upload the SVGMOBDPF 

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 05-01-2016
-------------------------------------------------------------------

load data
truncate into table SVGMOBDPF
fields terminated by x'09'
TRAILING NULLCOLS
(
SVGYYMM,
SVGCUS,
SVGDAB,
SVGDAN,
SVGDAS,
SVGDSDUE,
SVGDSREC,
SEGMRCST,
SEGMRCDT,
SEGMDLM,
SEGMDCRT
)