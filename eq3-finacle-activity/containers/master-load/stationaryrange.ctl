-- File Name		: stationaryrange.ctl

-- File Created for	: Control file for upload the Quaestor stationaryrange table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 14-07-2015
-------------------------------------------------------------------
load data
truncate into table StationaryRange
fields terminated by '|'
TRAILING NULLCOLS
(
Brn,
Usr,
StationaryType,
CurrentFrom,
CurrentTo,
NextFrom,
NextTo,
PrevFrom,
PrevTo,
LastIssued,
Deleted,
StatSubType,
Till
)

