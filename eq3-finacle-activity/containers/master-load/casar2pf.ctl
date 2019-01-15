-- File Name		: CASAR2PF.ctl

-- File Created for	: Control file for upload the CASAR2PF Dubai bank Account number

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 04-01-2016
-------------------------------------------------------------------

load data
truncate into table CASAR2PF
fields terminated by x'09'
TRAILING NULLCOLS
(
CR2YYMM,
CR2TACB,
CR2TACN,
CR2TACS,
CR2TMNO,
CR2TSCW,
CR2TSTS,
CR2TIDT,
CR2TDLM,
CR2TTLM,
CR2TULM,
CR2TDCR,
CR2TTCR,
CR2TUCR,
CR2AOD,
CR2SALR,
CR2HGCR,
CR2AVGB,
CR2PFLG,
CR2AIJ5,
CR2RMRK,
CR2DTSN
)