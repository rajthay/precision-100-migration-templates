-- File Name		: OWPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table OWPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   OWBRNM,
   OWDLP,
   OWDLR,
   OWDTE,
   OWMVT,
   OWMVTS,
   OWNS3,
   OWSD1,
   OWSD2,
   OWSD3,
   OWSD4,
   OWCC1,
   OWAM1,
   OWCC2,
   OWAM2,
   OWCC3,
   OWAM3,
   OWSRC,
   OWUC1,
   OWUC2,
   OWOANC,
   OWYINS,
   OWCUSC,
   OWCLCC,
   OWSWB,
   OWCNAS,
   OWSWL,
   OWSWR,
   OWIN1,
   OWIN2,
   OWIN3,
   OWNDA
)

