-- File Name		: C4PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table C4PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   C4CTD,
   C4CTP,
   C4DLMD,
   C4DLMM,
   C4DLMY,
   C4ILM,
   C4KCD,
   C4ULV,
   C4MIL,
   C4CBQ,
   C4CIGR,
   C4IND,
   C4YLCH,
   C4YTRI,
   C4YRET,
   C4YPLA,
   C4YOPI,
   C4YDRC,
   C4YNET,
   C4YRI1,
   C4YRI2,
   C4YRI3,
   C4YRI4,
   C4CS
)
