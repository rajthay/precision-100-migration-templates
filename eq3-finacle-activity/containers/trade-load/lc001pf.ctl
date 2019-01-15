-- File Name		: lc001pf.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Aditya Sharma

-- Client			: ENBD

-- Created On		: 05-06-2016
-------------------------------------------------------------------

load data
truncate into table lc001pf
fields terminated by x'09'
TRAILING NULLCOLS
(
   LCREFN,
LCBRNM,
LCCUST,
LCCNAM,
LCLTYP,
LCLKNO,
LCDEPO,
LCDEPA,
LCCUJ1,
LCCUJ2,
LCCUJ3,
LCCUJ4,
LCCUJ5,
LCCUJ6,
LCSTDT,
LCENDT,
LCCREN,
LCLSTS,
LCLFRZ,
LCLFRN,
LCLFDT,
LCLPUR,
LCLRMK,
LCLRAC,
LCLRFQ,
LCLRAM,
LCLRDD,
LCLRLC,
LCLTRA,
LCLPMO,
LCUIBR,
LCUFUS,
LCUFCD,
LCUFCT,
LCMUSR,
LCMIBR,
LCMMCD,
LCMMCT,
LCMRMK,
LCCUSR,
LCCIBR,
LCCMCD,
LCCMCT,
LCCRMK,
LCCSTS
)
