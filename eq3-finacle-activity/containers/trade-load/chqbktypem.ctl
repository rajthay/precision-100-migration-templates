-- File Name		: chqbktypem.ctl

-- File Created for	: Control file for upload the Quaestor chqbktypem table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 14-07-2015
-------------------------------------------------------------------
load data
truncate into table chqbktypem
fields terminated by '|'
TRAILING NULLCOLS
(
CHQBKTYPE,
CHKBKTYPENAME,
CUR,
PERSONALISED,
LEAVES,
CODE,
STALEDAYS,
DELETED,
GENERATEDUNIQUE
)

