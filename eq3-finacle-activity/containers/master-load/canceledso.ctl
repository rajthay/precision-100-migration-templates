-- File Name		: canceledso.ctl

-- File Created for	: canceledso

-- Created By		: Aditya Sharma

-- Client			: ENBD

-- Created On		: 20-04-2016
-------------------------------------------------------------------

load data
truncate into table si_cancled
fields terminated by x'09'
TRAILING NULLCOLS
(
BRANCH,
BASIC,
SUFFIX,
SI_REF_NO	
)