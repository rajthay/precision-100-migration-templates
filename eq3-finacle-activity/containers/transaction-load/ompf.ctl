-- File Name		: OMPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table OMPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   OMBRNM,
   OMDLP,
   OMDLR,
   OMDTE,
   OMMVT,
   OMMVTS,
   OMNS3,
   OMAPP,
   OMBDT,
   OMPRF,
   OMCCY,
   OMNST,
   OMNWP,
   OMNWR,
   OMCUS,
   OMCLC,
   OMDRF,
   OMABF,
   OMANF,
   OMASF,
   OMABD,
   OMAND,
   OMASD,
   OMREQF,
   OMPRVF,
   OMXM,
   OMXMS,
   OMARC,
   OMYNPG,
   OMYNAR,
   OMBMP,
   OMOCS,
   OMPRNR,
   OMNET,
   OMRQSF,
   OMPRSF
)
