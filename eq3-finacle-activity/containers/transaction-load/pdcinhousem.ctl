-- File Name		: pdcinhousem.ctl

-- File Created for	: Control file for upload the Quaestor pdcinhousem table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 13-01-2016
-------------------------------------------------------------------
load data
truncate into table pdcinhousem
fields terminated by '|'
TRAILING NULLCOLS
(
BATCHCODE,
TBRN,
CREATEDT,
TOTALAMT,
POSTED,
SODEOD
)

