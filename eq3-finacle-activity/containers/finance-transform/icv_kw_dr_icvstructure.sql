
--SELECT * FROM TIER_ENTRY ORDER BY TIER_CODE,S5CCY,ORDERBY (THIS IS THE SPOOL QUERY)
drop table d9pf_d4pf_d5pf_merge_dr;
create table d9pf_d4pf_d5pf_merge_dr as select * from vw_d9pf_d4pf_d5pf_merge_dr;
drop table lht_dr; 
create table lht_dr
as
select leg_acc_num,s5ccy,d9trc,
0 begin_amt,
d9tlv0/power(10,c8ced) end_amt, b1 base_rate , d1 diff_rate, 1 slab_level
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv0/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv1/power(10,c8ced), b2 base_rate , d2 diff_rate, 2
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv0 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv1/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv2/power(10,c8ced), b2 base_rate , d2 diff_rate, 3
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv1 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv2/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv3/power(10,c8ced), b3 base_rate , d3 diff_rate, 4
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv2 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv3/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv4/power(10,c8ced), b4 base_rate , d4 diff_rate, 5
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv3 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv4/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv5/power(10,c8ced), b5 base_rate , d5 diff_rate, 6
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv4 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv5/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv6/power(10,c8ced), b6 base_rate , d6 diff_rate, 7
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv5 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv6/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv7/power(10,c8ced), b7 base_rate , d7 diff_rate, 8
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv6 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv7/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv8/power(10,c8ced), b8 base_rate , d8 diff_rate, 9
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv7 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv8/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv9/power(10,c8ced), b9 base_rate , d9 diff_rate, 10
 from d9pf_d4pf_d5pf_merge_dr
 inner join c8pf on c8ccy = s5ccy
where d9tlv8 <>  999999999999999;

truncate table tier_entry;
DECLARE
   CURSOR c1
   IS
--select distinct a0090,a1010,a6000,a0230, eff_date from tier;
select distinct s5ccy,d9trc from lht_dr where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%';
   todo       NUMBER;
   BEGIN
      todo := 1;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry
            values 
            (
            l_record.d9trc||'_D',
            'ICVI'||l_record.d9trc||'_D'||l_record.s5ccy||'01-01-1900'||'31-12-2099'||
            lpad('ZEROB',5,' ')||
            lpad(' ',85,' ')||
            '01-01-1900'||
            'N'
           ,1,l_record.s5ccy,0
            );
         todo := todo +1;
            COMMIT;
   END LOOP;
   COMMIT;
END;
/
DECLARE
   CURSOR c1
   IS
    select DISTINCT d9trc||'_D' INT_TIER_TBL_CODE_MIG, 'D' ,'IVS'||'D'||' '||lpad(to_number(begin_amt),17,' ')||
    lpad(to_number(end_amt),17,' ') ||to_char(base_rate,'fm90.000000')||to_char(diff_rate,'fm90.000000')||
    ' ' || lpad('0.000000',8,' ') ||
    ' ' || lpad('0.000000',8,' ') ||
    ' ' || lpad('0.000000',8,' ') ||
    ' ' || lpad('0.000000',8,' ') ||
    case 
    when end_amt = 999999999999.99 
    or end_amt = 999999999999.999
    or end_amt = 999999999999999 then 'Y'
    else 'N' end t_r,
    100 seq,S5CCY,SLAB_LEVEL
   from lht_dr
   where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%' 
    order by INT_TIER_TBL_CODE_MIG;
   todo       NUMBER;
   BEGIN
      todo := 100000;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry
            values 
     (
        l_record.INT_TIER_TBL_CODE_MIG,l_record.t_r,todo,l_record.S5CCY,l_record.SLAB_LEVEL
     );
    -- insert into manage_rates values (l_record.CR_TIER_BASE_S1,l_record.INT_TIER_TBL_CODE_MIG);
         todo := todo +1;
            COMMIT;
   END LOOP;
   COMMIT;
END;
/
  
