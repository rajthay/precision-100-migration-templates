-- File Name		: G1PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table G1PF
--fields terminated by x'09'
TRAILING NULLCOLS
(
   G1CUS  position(1:6),
   G1CLC  position(7:9),
   G1CF01 position(10:84),
   G1CF02 position(85:159),
   G1CF03 position(160:234),
   G1CF04 position(235:309),
   G1CF05 position(310:384),
   G1CF06 position(385:459),
   G1CF07 position(460:534),
   G1CF08 position(535:609),
   G1CF09 position(610:684),
   G1CF10 position(685:759),
   G1CF11 position(760:834),
   G1CF12 position(835:909),
   G1CF13 position(910:984),
   G1CF14 position(985:1059),
   G1CF15 position(1060:1134),
   G1DLM position(1135:1141)
)

