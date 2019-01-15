-- File Name		: S7PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table S7PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   S7AB,
   S7AN,
   S7AS,
   S7SBTP,
   S7SMO,
   S7BAL1,
   S7BAL2,
   S7BAL3,
   S7BAL4,
   S7BAL5,
   S7BAL6,
   S7BAL7,
   S7BAL8,
   S7BAL9,
   S7BALA,
   S7BALB,
   S7BALC,
   S7BALM,
   S7BALL,
   S7ND01,
   S7ND02,
   S7ND03,
   S7ND04,
   S7ND05,
   S7ND06,
   S7ND07,
   S7ND08,
   S7ND09,
   S7ND10,
   S7ND11,
   S7ND12,
   S7NDTD,
   S7NDML
)

