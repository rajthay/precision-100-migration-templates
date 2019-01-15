-- File Name		: H5PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table H5PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   H5BRNM,
   H5LNP,
   H5DLR,
   H5CDT,
   H5UPP,
   H5UIP,
   H5CPI,
   H5PYNG,
   H5IYNG,
   H5TPP,
   H5TIP,
   H5PRTT,
   H5IRTT,
   H5EDTE,
   H5UIP1,
   H5UPP1
)

