-- File Name		: R0PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table R0PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   R0AB,
   R0AN,
   R0AS,
   R0BOT,
   R0FRC,
   R0SEQ,
   R0FRAB,
   R0FRAN,
   R0FRAS,
   R0RRT,
   R0EXF,
   R0FAM,
   R0INC,
   R0MIN,
   R0MAX,
   R0DEL
)
