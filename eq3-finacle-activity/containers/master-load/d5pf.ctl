-- File Name		: D5PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table D5PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   D5DRR,
   D5DTE,
   D5DRAR,
   D5DLM
)

