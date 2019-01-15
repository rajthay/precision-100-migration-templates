-- File Name		: D6PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table D6PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   D6BRR,
   D6BRAR,
   D6BRD,
   D6CCY,
   D6DLMD,
   D6DLMM,
   D6DLMY
)

