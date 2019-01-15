-- File Name		: SVPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan.B	

-- Client			: ENBD

-- Created On		: 28-06-2015
-------------------------------------------------------------------

load data
CHARACTERSET WE8ISO8859P1
INFILE *
truncate into table svpf
--append into table svpf
fields terminated by x'09'
TRAILING NULLCOLS
(
SVSEQ,
SVCSA,
SVNA1,
SVNA2,
SVNA3,
SVNA4,
SVNA5,
SVPZIP,
SVLNM,
SVPHN,
SVFAX,
SVDLM,
SVTLX,
SVC08,
SVSWB,
SVCNAS,
SVSWL,
SVSWBR,
SVXM,
SVPCB,
SVNSR,
SVSPC,
SVSPS,
SVPMR,
SVRMR,
SVSMR,
SVFXC,
SVFXM,
SVMMC,
SVMMM,
SVMMI,
SVCDR,
SVCCR,
SVYTRI,
SVYRET,
SVYPLA,
SVYOPI,
SVYDRC,
SVYNET,
SVYRI1,
SVYRI2,
SVYRI3,
SVYRI4,
SVBTM,
SVCTM,
SVNRM
)