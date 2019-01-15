-- File Name		: CTPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table CTPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   CTBTR,
   CTDCI,
   CTDDB,
   CTDFA,
   CTDLM,
   CTDVL,
   CTDVO,
   CTPCA,
   CTPEA,
   CTPIA,
   CTPMA,
   CTPTA,
   CTPTN,
   CTRVT,
   CTSTR,
   CTSUD,
   CTTAP,
   CTTCA,
   CTTCC,
   CTTCD,
   CTTCN,
   CTTCM,
   CTTC1,
   CTTC2,
   CTTC3,
   CTTC4,
   CTCTC,
   CTMID,
   CTTCDR,
   CTCFN,
   CTCFK,
   CTVXD,
   CTTCE,
   CTSWC
)
