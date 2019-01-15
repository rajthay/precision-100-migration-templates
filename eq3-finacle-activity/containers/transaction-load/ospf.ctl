-- File Name		: OSPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table osPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   OSBRNM,
   OSDLP,
   OSDLR,
   OSCUS,
   OSCLC,
   OSCTRD,
   OSBKC,
   OSAMAB,
   OSACO,
   OSSRC,
   OSUC1,
   OSUC2,
   OSBDT,
   OSDDE,
   OSDLM,
   OSDAST,
   OSUSID,
   OSAPP,
   OSCONR,
   OSCONP,
   OSAPPL,
   OSCANR,
   OSYSSI,
   OSAUO,
   OSARC,
   OSMAIN,
   OSBFT,
   OSBCR1,
   OSBCR2,
   OSBCCY,
   OSBCR3,
   OSBFCY,
   OSBCX1,
   OSBCX2,
   OSBCX3,
   OSODLN,
   OSCOSR,
   OSCOSP,
   OSDOS,
   OSPAB,
   OSPCHD
)
