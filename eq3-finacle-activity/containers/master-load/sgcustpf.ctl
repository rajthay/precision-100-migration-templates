-- File Name		: SGCUSTPF.ctl

-- File Created for	: Control file for upload the SGCUSTPF 

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 05-01-2016
-------------------------------------------------------------------

load data
truncate into table SGCUSTPF
fields terminated by x'09'
TRAILING NULLCOLS
(
SGRUNPRD,
SGCPNC,
SGBRNM,
SGLMBL,
SGCUSCSG,
SGCUSPSG,
SGNOTLRT,
SGTLTCHD,
SGTLRCHR,
SGTLRCHB,
SGNOCCAT,
SGCCACHD,
SGCCACHR,
SGCCACHB,
SGNOICWT,
SGICWCHD,
SGICWCHR,
SGICWCHB,
SGSRVCHD,
SGSRVCHR,
SGSRVCHB,
SGNOSRVT,
SGTOTCHD,
SGTOTCHR,
SGTOTCHB,
SGRECSTS,
SGRECDT,
SGSALACFL,
SGNCUSFL,
SGSRCHGFL,
SGMPOD,
SGCASAFLG,
SGLOANFL,
SGCCDFL,
SGAVBALFL,
SGUPDFL,
SGMDLM,
SGMDCRT,
SGCOD,
SGC2R
)