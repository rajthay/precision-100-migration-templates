drop table limit_org_exp_date_temp;


create table limit_org_exp_date_temp as 
select distinct LIMIT_PREFIX,LIMIT_SUFFIX,LIMIT_EXPIRY_DATE from LIMIT_CORE_TEMP_TABLE;


insert into limit_org_exp_date_temp
select * from (
SELECT LIMIT_PREFIX, 'RPBLG' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPBLC' LIMIT_SUFFIX,LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT  LIMIT_PREFIX, 'RPBLO' LIMIT_SUFFIX,LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPTLG' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPTLC' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPBNL' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPNSH' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'RPATL' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
UNION ALL
SELECT LIMIT_PREFIX, 'CUSTL' LIMIT_SUFFIX, LIMIT_EXPIRY_DATE FROM BANK_RISK_PART_DATA A
) where  (limit_prefix,limit_suffix) not in(select limit_prefix,limit_suffix from limit_org_exp_date_temp);
       

insert into limit_org_exp_date_temp
select TRIM(HHCNA)||'01' LIMIT_PREFIX,
'CNTRY' LIMIT_SUFFIX,
case when HH.HHLED!='0' then TO_CHAR(CONV_TO_VALID_DATE(get_date_fm_btrv(HH.HHLED),'yyyymmdd'),'DD-MM-YYYY') else null end LIMIT_EXPIRY_DATE
  FROM HHPF_MIG HH
       INNER JOIN HPPF_MIG HP
          ON trim(HPCNA) = trim(HHCNA) AND TRIM(HPCNA) IS NOT NULL AND TRIM(HPGRP) IS NULL
       LEFT JOIN C8PF C8 ON C8.C8CCY=HH.HHCCY 
 WHERE  trim(HHLC)='LG156' AND HHAMA <> 0 AND TRIM(HHCNA) IS NOT NULL AND TRIM(HHGRP) IS NULL and trim(HHCUS)  is null;
 


insert into limit_org_exp_date_temp
select a.limit_prefix,a.limit_suffix,b.LIMIT_EXPIRY_DATE from LIMIT_CORE_O_TABLE a
left join LIMIT_CORE_TEMP_TABLE b on b.limit_prefix||b.limit_suffix = a.parent_limit_prefix||a.parent_limit_suffix
 where (a.limit_prefix,a.limit_suffix) not in(select limit_prefix,limit_suffix from limit_org_exp_date_temp) and a.node_level='7' and regexp_like(a.limit_suffix,'[0-9]') ; 
 
 
 
  insert into limit_org_exp_date_temp
select a.limit_prefix,a.limit_suffix,to_char(max(to_date(a.LIMIT_EXPIRY_DATE,'dd-mm-yyyy')),'dd-mm-yyyy') LIMIT_EXPIRY_DATE from LIMIT_CORE_O_TABLE a
left join LIMIT_CORE_TEMP_TABLE b on b.limit_prefix = a.limit_prefix and b.limit_suffix='CUSTL'
 where (a.limit_prefix,a.limit_suffix) not in(select limit_prefix,limit_suffix from limit_org_exp_date_temp) and a.limit_suffix in('GROUP','ENTTY')
 group by a.limit_prefix,a.limit_suffix; 
 
 
 
insert into limit_org_exp_date_temp 
select a.limit_prefix,a.limit_suffix,a.LIMIT_EXPIRY_DATE from LIMIT_CORE_O_TABLE a
 where (a.limit_prefix,a.limit_suffix) not in(select limit_prefix,limit_suffix from limit_org_exp_date_temp) ;
 
 delete from limit_org_exp_date_temp  a where(a.limit_prefix,a.limit_suffix) not in (select a.limit_prefix,a.limit_suffix from limit_core_infy_table a);
 
 drop table limit_org_exp_date;
 
 create table limit_org_exp_date as select distinct * from limit_org_exp_date_temp;
  
