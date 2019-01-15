-- File Name		: S8PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table S8PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   S8AB,
   S8AN,
   S8AS,
   S8AM1D,
   S8IM1D,
   S8IM2D,
   S8IM3D,
   S8IIMD,
   S8NAID,
   S8NA1D,
   S8NIID,
   S8NI2D,
   S8NI3D,
   S8NA4D,
   S8NI6D,
   S8NI7D,
   S8NI9D,
   S8IM6D,
   S8IM7D
)

