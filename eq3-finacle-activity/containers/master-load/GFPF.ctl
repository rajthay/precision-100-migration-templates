-- File Name		: GFPF.ctl

-- File Created for	: Control file for upload the Customer information Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
CHARACTERSET WE8ISO8859P1
INFILE *
truncate into table GFPF
--append into table GFPF
fields terminated by x'09'
TRAILING NULLCOLS
(
GFCUS,
GFCLC,
GFCUN,
GFCPNC,
GFDAS,
GFC1R,
GFC2R,
GFC3R,
GFC4R,
GFC5R,
GFP1R,
GFP2R,
GFP3R,
GFP4R,
GFP5R,
GFCTP,
GFCUB,
GFCUC,
GFCUD,
GFCUZ,
GFSAC,
GFACO,
GFCRF,
GFLNM,
GFCA2,
GFCNAP,
GFCNAR,
GFCNAL,
GFCOD,
GFDCC,
GFDLM,
GFITRT,
GFBRNM,
GFCRB1,
GFCRB2,
GFADJ,
GFERCP,
GFERCC,
GFDRC,
GFGRPS,
GFCUNA,
GFDASA,
GFCUNM,
GFCNAI,
GFGRP,
GFMTB,
GFETX,
GFYFON,
GFDFRQ,
GFFON,
GFFOL,
GFDEL

)