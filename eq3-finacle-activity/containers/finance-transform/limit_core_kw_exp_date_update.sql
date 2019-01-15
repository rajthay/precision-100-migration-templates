

---MANUAL LIMIT EXPIRY DATE UPDATE 

truncate table limit_core_exp_date

insert into limit_core_exp_date
select a.limit_prefix,a.limit_suffix,b.EARLIEST_EXPIRY_DATE LIMIT_EXPIRY_DATE, b.EARLIEST_EXPIRY_DATE -1 LIMIT_REVIEW_DATE from LIMIT_CORE_INFY_TABLE a
inner join limit_core_exp_date_data b on trim(limit_prefix) = trim(CIF_NO);


insert into limit_core_exp_date
select distinct  a.limit_prefix,a.limit_suffix,c.LIMIT_EXPIRY_DATE,c.LIMIT_EXPIRY_DATE-1 from LIMIT_CORE_INFY_TABLE a
inner join CU9CORP_O_TABLE b on  trim(limit_prefix) = trim(ORGKEY)
inner join LIMIT_CORE_EXP_DATE_BANK_DATA c on trim(GROUPHOUSEHOLDCODE) = trim(GROUP_CODE);

insert into limit_core_exp_date
select distinct  a.limit_prefix,a.limit_suffix,c.LIMIT_EXPIRY_DATE,c.LIMIT_EXPIRY_DATE-1 from LIMIT_CORE_INFY_TABLE a
inner join CU9CORP_O_TABLE b on  trim(limit_prefix) = trim(GROUP_ID)
inner join LIMIT_CORE_EXP_DATE_BANK_DATA c on trim(GROUPHOUSEHOLDCODE) = trim(GROUP_CODE);

insert into limit_core_exp_date
select distinct a.limit_prefix,a.limit_suffix,b.LIMIT_EXPIRY_DATE ,b.LIMIT_EXPIRY_DATE-1 from LIMIT_CORE_INFY_TABLE a
inner join LIMIT_CORE_EXP_DATE_IBD_DATA b on trim(CUSTOMER) = trim(limit_prefix);


create index limit_indx1 on  LIMIT_CORE_INFY_TABLE(limit_prefix,limit_suffix);

create index limit_indx2 on  LIMIT_CORE_O_TABLE(limit_prefix,limit_suffix);

create index limit_indx3 on  limit_core_exp_date(limit_prefix,limit_suffix);

update LIMIT_CORE_INFY_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE)=(
select LIMIT_EXPIRY_DATE , LIMIT_REVIEW_DATE from(
select * from limit_core_exp_date
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (a.limit_prefix,a.limit_suffix) in(
select limit_prefix,limit_suffix from limit_core_exp_date
);

update LIMIT_CORE_O_TABLE a set (LIMIT_EXPIRY_DATE,LIMIT_REVIEW_DATE)=(
select to_char(LIMIT_EXPIRY_DATE,'dd-mm-yyyy') , to_char(LIMIT_REVIEW_DATE,'dd-mm-yyyy') from(
select * from limit_core_exp_date
) b where a.limit_prefix = b.limit_prefix and a.limit_suffix = b.limit_suffix
)
where (a.limit_prefix,a.limit_suffix) in(
select limit_prefix,limit_suffix from limit_core_exp_date
);


 
