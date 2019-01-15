-- File Name		: C3PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table C3PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   C3DLMD,
   C3DLMM,
   C3DLMY,
   C3ILM,
   C3KCD,
   C3SAC,
   C3SUA,
   C3ULV,
   C3MIL
)
