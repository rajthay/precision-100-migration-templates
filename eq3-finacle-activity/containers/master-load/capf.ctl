-- File Name		: CAPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table CAPF
fields terminated by x'09'
TRAILING NULLCOLS
(
CABAD1,
CABAD2,
CABAD3,
CABAD4,
CABBN,
CABRN,
CADLM,
CAFCR,
CAFDR,
CATLY,
CATPH,
CABRNM,
CABRSC,
CABRAC,
CABRAT,
CABCSC,
CABCAC,
CABCAT,
CAOUT1,
CAOUT2,
CAOUT3,
CAOUT4,
CABAD5,
CASWB,
CARLFI,
CACNAS,
CASWL,
CASWBR,
CASORT

)
