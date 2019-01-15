-- File Name		: SX20LFF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
CHARACTERSET WE8ISO8859P1
INFILE *
truncate into table SX20LF
fields terminated by x'09'
TRAILING NULLCOLS
(
SXCUS,
SXCLC,
SXPRIM,
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

