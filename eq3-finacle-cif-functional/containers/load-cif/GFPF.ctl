
-- File Name		: GFPF.ctl

-- File Created for	: Control file for upload the Customer information Mster DaTa

-- Created By		: Kumaresan.B

-- Client			: ABK

-- Created On		: 18-04-2016
-------------------------------------------------------------------

load data
CHARACTERSET WE8ISO8859P1
INFILE *
truncate into table GFPF
fields terminated by ','
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
GFDEL,
GFSTMP,
GFCREF,
GFOATP,
GFOCCL,
GFHDD,
GFDDED,
GFRDDH,
GFYTRI,
GFYRET,
GFYPLA,
GFYOPI,
GFYNET,
GFYRI1,
GFYRI2,
GFYRI3,
GFYRI4,
GFPCUS,
GFPCLC,
GFCS,
GFCFRQ,
GFFCYC,
GFCSSA,
GFPSTM,
GFNSTM,
GFSTN,
GFOCID
) 
