-- File Name		: C2PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Aditya Kumar Sharma

-- Client		: ENBD

-- Created On		: 24-02-2016
-------------------------------------------------------------------

load data
truncate into table ctspf
fields terminated by x'09'
TRAILING NULLCOLS
(
CTSPAC,
CTSCAC,
CTSSDT,
CTSNDD,
CTSCYN,
CTSREC,
CTSRAC,
CTSLRD,
CTSPCD,
CTSSYN,
CTSATR,
CTS1MC,
CTS1MR,
CTS2MC,
CTS2MR,
CTS3MC,
CTS3MR,
CTSWCD,
CTSTAR,
CTSDOB,
CTSGEN,
CTSRYN,
CTSRDT,
CTSMUS,
CTSMIB,
CTSMCD,
CTSMCT,
CTSMRM,
CTSCUS,
CTSCIB,
CTSCCD,
CTSCCT,
CTSCRM,
CTSDUS,
CTSDIB,
CTSDCD,
CTSDCT,
CTSDRM,
CTSLYN,
CTSMDT,
CTSSTS
)
