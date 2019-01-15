-- File Name		: MAP_SCHEME_INTEREST.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table MAP_SCHEME_INTEREST
fields terminated by x'09'
TRAILING NULLCOLS
(
    SCHM_CODE,
    SCHM_DESC,
    SCHM_TYPE,
    INT_COLL_FLG,
    INT_PAID_FLG,
    INT_FREQ_TYPE_CR,
    INT_FREQ_WEEK_NUM_CR,
    INT_FREQ_WEEK_DAY_CR,
    INT_FREQ_START_DD_CR,
    INT_FREQ_HLDY_STAT_CR,
    INT_FREQ_TYPE_DR,
    INT_FREQ_WEEK_NUM_DR,
    INT_FREQ_WEEK_DAY_DR,
    INT_FREQ_START_DD_DR,
    INT_FREQ_HLDY_STAT_DR
  )