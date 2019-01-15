-- File Name		: IYPF.ctl

-- File Created for	: Control file for upload the bankers cheque

-- Created By		: Prashant Maroli

-- Client		: ENBD

-- Created On		: 18-02-2012
-------------------------------------------------------------------

load data
CHARACTERSET WE8ISO8859P1
INFILE *
truncate into table IYPF
fields terminated by x'09'
TRAILING NULLCOLS
(
	IYDNO,
	IYNST,
	IYAB,
	IYAN,
	IYAS,
	IYBEN,
	IYISD,
	IYDCF,
	IYCDT,
	IYDRF,
	IYRDN,
	IYCLF,
	IYCLD,
	IYAMT,
	IYCCY,
	IYCAR,
	IYCAP,
	IYCCP,
	IYPYRF
)

