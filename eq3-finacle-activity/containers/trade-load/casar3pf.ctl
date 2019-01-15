-- File Name		: CASAR3PF.ctl

-- File Created for	: Control file for upload the CASAR3PF 

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 04-01-2016
-------------------------------------------------------------------

load data
truncate into table CASAR3PF
fields terminated by x'09'
TRAILING NULLCOLS
(
CR3YYMM,
CR3TACB,
CR3TACN,
CR3TACS,
CR3TMNO,
CR3TSCW,
CR3TSTS,
CR3TIDT,
CR3TDLM,
CR3TTLM,
CR3TULM,
CR3TDCR,
CR3TTCR,
CR3TUCR,
CR3SALR,
CR3AVGB,
CR3PFLG,
CR3AIJ5,
CR3RMRK,
CR3DTSN
)