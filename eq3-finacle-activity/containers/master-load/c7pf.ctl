-- File Name		: C7PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table C7PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   C7CNA,
   C7CNM,
   C7DLMD,
   C7DLMM,
   C7DLMY,
   C7ILM,
   C7KCD,
   C7RES,
   C7ULV,
   C7MDA,
   C7MIL,
   C7NS3,
   C7NS5,
   C7WTX,
   C7RDA,
   C7DFC,
   C7RFI,
   C7ILEN,
   C7SCL,
   C7SCP,
   C7UEAN,
   C7ANP,
   C7SWEU   
)
