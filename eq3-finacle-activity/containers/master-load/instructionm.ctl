-- File Name		: instructionm.ctl

-- File Created for	: Control file for upload the Quaestor instructionm table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 31-05-2015
-------------------------------------------------------------------
load data
truncate into table instructionm
fields terminated by '|'
TRAILING NULLCOLS
(
AcBrn, 
AcId,
AcNum,
AcSeq,
AcCur,
AcType,
SIType,
SISubType,
Reference,
Frequency,
Firstdate,
Nextdate,
Finaldate,
MinBal,
MaxBal,
Manual,
Narration,
Cancel,
AdviceReq,
Retain,
Hold,
HoldExpiry,
Brn,
Usr,
PostDt,
TNum,
LastStatus,
RetryLast,
Latest,
PrevDate
)

