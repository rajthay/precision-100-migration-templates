-- File Name		: T9PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table T9PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   T9LNP,
   T9LSC,
   T9LSD,
   T9NDO,
   T9PRDE,
   T9WDOC,
   T9IDOC,
   T9PDTE,
   T9DLM,
   T9MINA,
   T9ONUS,
   T9MONA,
   T9OFUS,
   T9MIMP,
   T9PIF,
   T9IIF,
   T9CIF,
   T9MOMP,
   T9IDTE
)

