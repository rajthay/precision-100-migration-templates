-- File Name		: HYPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table HYPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   HYCUS,
   HYCLC,
   HYDLP,
   HYDLR,
   HYDBNM,
   HYAB,
   HYAN,
   HYAS,
   HYCLP,
   HYCLR,
   HYCCM,
   HYCNA,
   HYCLO,
   HYDPC,
   HYCPI,
   HYCXD,
   HYLRD,
   HYFRQ,
   HYNRD,
   HYNOU,
   HYUNP,
   HYCCY,
   HYCLV,
   HYSVM,
   HYMCV,
   HYBKV,
   HYTOTA,
   HYISV,
   HYIXD,
   HYNR1,
   HYNR2,
   HYNR3,
   HYNR4,
   HYDLM
)

