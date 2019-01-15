-- File Name		: JUPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table JUPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   JUBBN,
   JUBNO,
   JUSFX,
   JUHNO,
   JUSDTE,
   JUHED,
   JUHAMT,
   JUACO,
   JUHRC,
   JUHDD1,
   JUHDD2,
   JUHDD3,
   JUHDD4,
   JUINP,
   JUDLM,
   JUBRNM,
   JUDLP,
   JUDLR,
   JUSHLD
)

