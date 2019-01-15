-- File Name		: clrbnkm.ctl

-- File Created for	: Control file for upload the Quaestor clrbnkm table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 10-02-2016
-------------------------------------------------------------------
load data
truncate into table clrbnkm
fields terminated by '|'
TRAILING NULLCOLS
(
CLRBNK,
DELETED ,
CLRBNKNAME ,
DEFERRED,
BNKCODE
)

