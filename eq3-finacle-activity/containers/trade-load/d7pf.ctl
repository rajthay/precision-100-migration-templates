-- File Name		: D7PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table D7PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   D7DLMD,
   D7DLMM,
   D7DLMY,
   D7ILM,
   D7MIL,
   D7ULV,
   D7SCR,
   D7SCW
)

