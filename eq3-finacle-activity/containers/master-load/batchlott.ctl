-- File Name		: batchlott.ctl

-- File Created for	: Control file for upload the Quaestor batchlott table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 14-07-2015
-------------------------------------------------------------------
load data
truncate into table batchlott
fields terminated by '|'
TRAILING NULLCOLS
(
BATCHCODE,
LOTNUM,
NOOFINSTS,
NOOFINSTSENTERED,
MODE1,
TOTALAMT,
ACBRN,
ACID,
ACNUM,
ACTYPE,
ACCUR,
ACNAME,
ACSEQ,
STATUS
)

