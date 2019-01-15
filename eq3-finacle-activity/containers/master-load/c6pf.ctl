-- File Name		: C6PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table C6PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   C6ACD,
   C6ANN,
   C6DLMD,
   C6DLMM,
   C6DLMY,
   C6ILM,
   C6KCD,
   C6ULV,
   C6MIL
)
