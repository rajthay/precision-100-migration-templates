-- File Name		: PRFTPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 10-08-2015
-------------------------------------------------------------------

load data
truncate into table PRFTPF
fields terminated by x'09'
TRAILING NULLCOLS
(
ADB,
ADN,
ADS,
GRP,
ACC,
PRD,
CUR,
DLB,
DLT,
DLR,
DLA,
DLBKN,
DLSDA,
DLSDAMT,
DLD,
DLSDT,
DLEDT,
MA1,
MA2,
MA3,
ME1,
ME2,
ME3,
MR1,
MR2,
MR3,
WAVPR,
WAV,
WAVBCUR,
ALPY,
PRF,
PRFBCUR,
WAVPRS,
WAVS,
WAVBCURS,
ALPYS,
PRFS,
PRFBCURS,
PRA,
PPD,
PPDS
)
