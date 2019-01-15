-- File Name		: JAPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table JAPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   JATDT,
   JACCY,
   JADTE,
   JAPRC,
   JABRR,
   JADRR,
   JARTM,
   JARAT,
   JADLM,
   JADLPP,
   JAPDTE,
   JAPMAR
)

