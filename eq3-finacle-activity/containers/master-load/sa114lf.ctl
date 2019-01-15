-- File Name		: SA14LF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table SA14LF
fields terminated by x'09'
TRAILING NULLCOLS
(
   SAAB, 
   SAAN,
   SAAS,
   SAPOD,
   SABRNM,
   SAPBR,
   SAPSQ,
   SAVFR,
   SABRND,
   SADRF,
   SANEGP,
   SAAMA,
   SAAPP,
   SATCD,
   SACCY,
   SASRC,
   SAUC1,
   SAUC2,
   SANPE,
   SAYNAR,
   SADLS,
   SAYREC,
   SAPRVF,
   SAPRNP,
   SASIG,
   SASTN,
   SAYPTD,
   SAPTYP,
   SALSTN,
   SATFRS,
   SAABI,
   SATSTP,
   SAEVNK
)

