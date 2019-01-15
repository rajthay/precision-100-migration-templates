-- File Name		: dealpf.ctl

-- File Created for	: dealpf

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 12-04-2016
-------------------------------------------------------------------

load data
truncate into table dealpf
fields terminated by x'09'
TRAILING NULLCOLS
(
DLTYP,
DLREF,
DLBRNM,
DLBAB,
DLBAN,
DLBAS,
DLAB,
DLAN,
DLAS,
DLUSRA,
DLADT,
DLUSRM,
DLMDT,
DLLIEND,
DLRMK	
)
