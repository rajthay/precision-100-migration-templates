-- File Name		: RLPF.ctl

-- File Created for	: Control file for upload of Joint narrative details 

-- Created By		: Prashant

-- Client		: ENBD

-- Created On		: 18-02-2012
-------------------------------------------------------------------

load data
truncate into table RLPF
fields terminated by x'09'
TRAILING NULLCOLS
(
	RLAB,
	RLAN,
	RLAS,
	RLPCUS,
	RLPCLC,
	RLNAR1,
	RLNAR2,
	RLNAR3,
	RLNAR4

)

