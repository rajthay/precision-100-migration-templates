-- File Name		: C2PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table C2PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   C2DLMD,
   C2DLMM,
   C2DLMY,
   C2ILM,
   C2KCD,
   C2RCD,
   C2RNM,
   C2ULV,
   C2ACO,
   C2MIL
)
