-- File Name		: cms01pf1.ctl

-- File Created for	: Control file for upload the Debit Card details

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 21-06-2015
-------------------------------------------------------------------

load data
truncate into table cms01pf1
fields terminated by x'09'
TRAILING NULLCOLS
(
   cm1acod,
   cm1akey,
   cm1adta,
   filler
)
