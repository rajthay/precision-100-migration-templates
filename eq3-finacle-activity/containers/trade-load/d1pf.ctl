-- File Name		: D1PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table D1PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   D1XM,
   D1XMD,
   D1DLM,
   D1NSF,
   D1VBT,
   D1CBT,
   D1BCC,
   D1VXD,
   D1PRT,
   D1PYT,
   D1CCD,
   D1AM1,
   D1TN1,
   D1TN2,
   D1TN3,
   D1TN4,
   D1ASI,
   D1EXF,
   D1RRT,
   D1FIN,
   D1DSAN,
   D1LNST,
   D1DCCY,
   D1BCI,
   D1NBAL,
   D1AXIT,
   D1DI57,
   D1D57S,
   D1D57C,
   D1D57A,
   D1D57O,
   D1DE57,
   D1DI59,
   D1D59A,
   D1D59L,
   D1DI70,
   D1DXIT,
   D1CI57,
   D1C57S,
   D1C57C,
   D1C57A,
   D1C57O,
   D1CE57,
   D1CI59,
   D1C59A,
   D1C59L,
   D1CI70,
   D1CXIT
)

