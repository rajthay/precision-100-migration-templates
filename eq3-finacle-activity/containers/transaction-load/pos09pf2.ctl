-- File Name		: pos09pf2.ctl

-- File Created for	: Control file for upload the POS Lien

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 17-11-2015
-------------------------------------------------------------------

load data
truncate into table pos09pf2
fields terminated by x'09'
TRAILING NULLCOLS
(
PS9BAD,
PS9BAC,
PS9BRF,
PS9BAM,
PS9BDT,
PS9BEX,
PS9BNA,
PS9BAO,
PS9BFL,
PS9BEP,
PS92DL,
PS9BDE
)