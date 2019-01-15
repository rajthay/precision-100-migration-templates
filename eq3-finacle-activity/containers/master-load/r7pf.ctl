-- File Name		: R7PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table R7PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   R7AB,
   R7AN,
   R7AS,
   R7BOT,
   R7FRQ,
   R7MIN,
   R7MAX,
   R7FAD,
   R7FLD,
   R7LPR,
   R7NPR,
   R7HED,
   R7BOH,
   R7RET,
   R7CON,
   R7SRC,
   R7UC1,
   R7UC2,
   R7FDRF,
   R7FNR1,
   R7FNR2,
   R7FNR3,
   R7FNR4,
   R7RDRF,
   R7RNR1,
   R7RNR2,
   R7RNR3,
   R7RNR4,
   R7DEL,
   R7DLM
)

