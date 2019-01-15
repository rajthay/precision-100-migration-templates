-- File Name		: C8PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table C8PF
fields terminated by x'09'
TRAILING NULLCOLS
(   D8DLMD,
   D8DLMM,
   D8DLMY,
   D8ILM,
   D8MIL,
   D8ULV,
   D8NANC,
   D8NAND
)

