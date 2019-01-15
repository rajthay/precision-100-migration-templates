-- File Name		: SMCUSTPF.ctl

-- File Created for	: Control file for upload the SMCUSTPF 

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 05-01-2016
-------------------------------------------------------------------

load data
truncate into table SMCUSTPF
fields terminated by x'09'
TRAILING NULLCOLS
(
SMRUNPRD,
SMCPNC,
SMBRNM,
SMLMBL,
SMLMTAMT,
SMCUSCSG,
SMCUSPSG,
SMNOTLRT,
SMTLTCHD,
SMTLRCHR,
SMTLRCHB,
SMNOCCAT,
SMCCACHD,
SMCCACHR,
SMCCACHB,
SMNOICWT,
SMICWCHD,
SMICWCHR,
SMICWCHB,
SMSRVCHD,
SMSRVCHR,
SMSRVCHB,
SMNOSRVT,
SMTOTCHD,
SMTOTCHR,
SMTOTCHB,
SMRECSTS,
SMRECDT,
SMSALACFL,
SMNCUSFL,
SMSRCHGFL,
SMMPOD,
SMCASAFLG,
SMLOANFL,
SMCCDFL,
SMAVBALFL,
SMUPDFL,
SMMDLM,
SMMDCRT,
SMCOD,
SMC2R
)