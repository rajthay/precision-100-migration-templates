-- File Name		: D4PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table D4PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   D4BRR,
   D4DTE,
   D4BRAR,
   D4DLM,
   D4CCY,
   D4TERM,
   D4RIU
)

