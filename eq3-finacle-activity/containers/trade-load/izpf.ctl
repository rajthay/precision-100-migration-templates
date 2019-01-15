-- File Name		: IZPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table IZPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   IZBRNM,
   IZDLP,
   IZDLR,
   IZDTES,
   IZBAL,
   IZMDTR,
   IZMDT,
   IZAMTR,
   IZCRA,
   IZCRAN,
   IZCRAL,
   IZNPY,
   IZDIF,
   IZNDT,
   IZRAT,
   IZAPR,
   IZDLS,
   IZUSR,
   IZIFQ,
   IZLDT,
   IZRFRQ,
   IZAPP,
   IZFAMT,
   IZNPYR,
   IZYMAT,
   IZYCPI,
   IZYCRL,
   IZDAMT,
   IZSCCY,
   IZAB,
   IZAN,
   IZAS
)

