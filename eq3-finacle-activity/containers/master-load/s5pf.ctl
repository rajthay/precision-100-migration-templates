-- File Name		: S5PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table S5PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   S5AB,
   S5AN,
   S5AS,
   S5CCY,
   S5ACT,
   S5II50,
   S5DTEF,
   S5DTEH,
   S5II13,
   S5II22,
   S5II23,
   S5II27,
   S5STM,
   S5STNL,
   S5II30,
   S5II34,
   S5IIF3,
   S5BAL,
   S5CRD1,
   S5CRD2,
   S5IDBD,
   S5IFQD,
   S5LCDD,
   S5NCDD,
   S5RFQD,
   S5LRED,
   S5NRDD,
   S5AIMD,
   S5AM1D,
   S5AM2D,
   S5IM1D,
   S5IM2D,
   S5IM3D,
   S5IIMD,
   S5IM4D,
   S5IM5D,
   S5AM4D,
   S5PRVD,
   S5PL1D,
   S5PL2D,
   S5BRRD,
   S5DRRD,
   S5TRCD,
   S5RATD,
   S5RTMD,
   S5PEGD,
   S5II53,
   S5IID0,
   S5IIH0,
   S5BLV,
   S5CRC1,
   S5CRC2,
   S5IDBC,
   S5IFQC,
   S5LCDC,
   S5NCDC,
   S5RFQC,
   S5LREC,
   S5NRDC,
   S5AIMC,
   S5AM1C,
   S5AM2C,
   S5IM1C,
   S5IM2C,
   S5IM3C,
   S5IIMC,
   S5IM4C,
   S5IM5C,
   S5AM4C,
   S5PRVC,
   S5PL1C,
   S5PL2C,
   S5BRRC,
   S5DRRC,
   S5TRCC,
   S5RATC,
   S5RTMC,
   S5PEGC,
   S5YFWD,
   S5ODL,
   S5PDR,
   S5IIA4,
   S5PEN,
   S5DLM,
   S5CTYP,
   S5DTEB,
   S5CBAL,
   S5OBR,
   S5ODR,
   S5APRD,
   S5APRC,
   S5DAPR,
   S5CAPR,
   S5IIFD,
   S5IBFD,
   S5VAFD,
   S5DINA,
   S5DONA,
   S5NAID,
   S5NIID,
   S5NA1D,
   S5NI2D,
   S5NI3D,
   S5NA4D,
   S5IFQB,
   S5NCDB,
   S5AODL,
   S5DODL,
   S5POOL,
   S5FM2C,
   S5FM2D,
   S5BM2C,
   S5BM2D,
   S5RCAL,
   S5SCC,
   S5EXC,
   S5RCCY,
   S5IM6D,
   S5IM7D,
   S5IM8D,
   S5IM9D,
   S5IM6C,
   S5IM7C,
   S5IM8C,
   S5IM9C,
   S5NI6D,
   S5NI7D,
   S5NI9D,
   S5BM6D,
   S5FM6D,
   S5BM9D,
   S5FM9D,
   S5BM6C,
   S5FM6C,
   S5BM9C,
   S5FM9C
)