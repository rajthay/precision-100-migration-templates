-- File Name		: D9PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table D9PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   D9TRC,
   D9DTE,
   D9TLV0,
   D9TLV1,
   D9TLV2,
   D9TLV3,
   D9TLV4,
   D9TLV5,
   D9TLV6,
   D9TLV7,
   D9TLV8,
   D9TLV9,
   D9TBR0,
   D9TBR1,
   D9TBR2,
   D9TBR3,
   D9TBR4,
   D9TBR5,
   D9TBR6,
   D9TBR7,
   D9TBR8,
   D9TBR9,
   D9TDR0,
   D9TDR1,
   D9TDR2,
   D9TDR3,
   D9TDR4,
   D9TDR5,
   D9TDR6,
   D9TDR7,
   D9TDR8,
   D9TDR9,
   D9DLM
)

