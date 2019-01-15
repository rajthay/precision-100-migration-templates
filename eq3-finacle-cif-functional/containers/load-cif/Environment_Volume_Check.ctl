
-- File Name		: Environment_Volume_Check.ctl

-- File Created for	: Control file for upload the Source Mster DaTa

-- Created By		: Aditya

-- Client			: ABK

-- Created On		: 15-01-2018
-------------------------------------------------------------------

load data
CHARACTERSET WE8ISO8859P1
INFILE *
truncate into table Environment_Volume_Check
fields terminated by ','
TRAILING NULLCOLS
(
   Mock,
   file_name,
   expected_count
) 