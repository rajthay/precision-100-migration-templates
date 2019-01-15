-- File Name		: R4PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
CHARACTERSET WE8ISO8859P1
INFILE *
truncate into table R4PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   R4COD,
   R4TYP,
   R4AB,
   R4AN,
   R4AS,
   R4SRL,
   R4AMT,
   R4REF,
   R4PAY,
   R4NAR,
   R4STY,
   R4EFF,
   R4MAT,
   R4AUT,
   R4CHCD,
   R4CHAM,
   R4FSN,
   R4LSR,
   UHIND,
   R4CCY
)

