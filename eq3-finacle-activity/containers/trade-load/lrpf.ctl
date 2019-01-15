-- File Name		: LRPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table LRPF
fields terminated by x'09'
TRAILING NULLCOLS
( 
   LRBRNM,
   LRDLP,
   LRDLR,
   LRDTE,
   LRTIM,
   LRDTES,
   LRIMG,
   LRNDT,
   LRMDT,
   LRCRA,
   LRCRAN,
   LRCRAL,
   LRNPY,
   LRRAT
)

