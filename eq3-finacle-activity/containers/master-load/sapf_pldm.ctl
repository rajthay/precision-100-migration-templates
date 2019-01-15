-- File Name		: sapf_pldm.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 14-12-2014
-------------------------------------------------------------------

load data
truncate into table sapf_pldm
--append into table sapf_pldm
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
SAABI
)
