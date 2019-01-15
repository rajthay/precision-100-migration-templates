-- File Name		: stopchqm.ctl

-- File Created for	: Control file for upload the Quaestor stopchqm table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 31-05-2015
-------------------------------------------------------------------
load data
truncate into table stopchqm
fields terminated by '|'
TRAILING NULLCOLS
(
RefNo,
Brn,
AcId,
ChqNumFrom,
ChqNumTo,
Amount,
InputDt,
Narration,
Beneficiary,
ChqDt,
ChqBkType
)

