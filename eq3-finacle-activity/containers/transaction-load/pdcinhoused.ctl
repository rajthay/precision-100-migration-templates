-- File Name		: pdcinhoused.ctl

-- File Created for	: Control file for upload the Quaestor pdcinhoused table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 13-01-2016
-------------------------------------------------------------------
load data
truncate into table pdcinhoused
fields terminated by '|'
TRAILING NULLCOLS
(
BATCHCODE,
SEQNUM,
DRACBRN,
DRACTYPE,
DRACSEQ,
DRACCUR,
DRACNUM,
DRACNAME,
CRACBRN,
CRACTYPE,
CRACSEQ,
CRACCUR,
CRACNUM,
CRACNAME,
CHQNUM,
CHQTYPE,
CHQAMT,
CHQDATE,
DEPOSITDT,
PREVDATE,
DELETED,
DRPOSTED,
CRPOSTED,
STATUS,
RSNCODE,
BATCHMOVEDTO,
ACID,
DRSTATUS,
LMDATE,
TXTREFNUM,
DRAVLFUNDS,
CRAVLFUNDS,
NARRATION
)

