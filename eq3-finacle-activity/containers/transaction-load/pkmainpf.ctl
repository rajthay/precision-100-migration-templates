-- File Name		: pkmainpf.ctl

-- File Created for	: pkmainpf

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 13-04-2016
-------------------------------------------------------------------

load data
truncate into table pkmainpf
fields terminated by x'09'
TRAILING NULLCOLS
(
MGMREQNUM,
MGMBRNREQ,
MGMSLNUM,
MGMCUSNUM,
MGMCUSCLC,
MGMAB,
MGMAN,
MGMAS,
MGMCRDNUM,
MGMCRDLMT,
MGMCRDEXPD,
MGMPCCRDT,
MGMPCCRTM,
MGMPCCRUSR,
MGMCSACDT,
MGMCSACTM,
MGMASCSUSR,
MGMCUSTFLG,
MGMACCFLG,
MGMP5CODFL,
MGMCRDFLG,
MGMOVRSTS,
MGMASGCUS	
)
