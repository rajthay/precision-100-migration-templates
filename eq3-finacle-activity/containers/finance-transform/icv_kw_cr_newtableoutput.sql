
--select * from tier_entry_cr_new ORDER BY INT_TIER_TBL_CODE_MIG,S5CCY,seq (THIS IS THE SPOOL QUERY)

drop table d9pf_d4pf_d5pf_merge_cr;
create table d9pf_d4pf_d5pf_merge_cr as select * from vw_d9pf_d4pf_d5pf_merge_cr;
drop table lht_cr; 
create table lht_cr
as
select leg_acc_num,s5ccy,d9trc,
0 begin_amt,
d9tlv0/power(10,c8ced) end_amt, b1 base_rate , d1 diff_rate, 1 slab_level
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv0/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv1/power(10,c8ced), b2 base_rate , d2 diff_rate, 2
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv0 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv1/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv2/power(10,c8ced), b2 base_rate , d2 diff_rate, 3
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv1 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv2/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv3/power(10,c8ced), b3 base_rate , d3 diff_rate, 4
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv2 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv3/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv4/power(10,c8ced), b4 base_rate , d4 diff_rate, 5
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv3 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv4/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv5/power(10,c8ced), b5 base_rate , d5 diff_rate, 6
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv4 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv5/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv6/power(10,c8ced), b6 base_rate , d6 diff_rate, 7
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv5 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv6/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv7/power(10,c8ced), b7 base_rate , d7 diff_rate, 8
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv6 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv7/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv8/power(10,c8ced), b8 base_rate , d8 diff_rate, 9
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv7 <>  999999999999999
union
select leg_acc_num,s5ccy,d9trc,
(d9tlv8/power(10,c8ced)) + (1/power(10,c8ced)) begin_amt,
d9tlv9/power(10,c8ced), b9 base_rate , d9 diff_rate, 10
 from d9pf_d4pf_d5pf_merge_cr
 inner join c8pf on c8ccy = s5ccy
where d9tlv8 <>  999999999999999;

truncate table tier_entry_cr;
truncate table tier_entry_cr_new;
DECLARE
   CURSOR c1
   IS
--select distinct a0090,a1010,a6000,a0230, eff_date from tier;
select distinct s5ccy,d9trc from lht_cr where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%' ;
   todo       NUMBER;
   BEGIN
      todo := 1;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry_cr
            values 
            (
            l_record.d9trc||'_C',
            'ICVI'||l_record.d9trc||'_C'||l_record.s5ccy||'01-01-1900'||'31-12-2099'||
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
    select DISTINCT 
    trim(d9trc)||'C' INT_TIER_TBL_CODE_MIG,
    'C' D_C_ind ,
    lpad(to_number(begin_amt),17,' ') begin_amt,
    lpad(to_number(end_amt),17,' ') end_amt,
    to_char(base_rate,'fm90.000000')base_rate,
    to_char(diff_rate,'fm90.000000') diff_rate,
    case 
    when end_amt = 999999999999.99 
    or end_amt = 999999999999.999
    or end_amt = 999999999999999 then 'Y'
    else 'N' end end_slab_ind,
    100 seq,
    S5CCY,
    SLAB_LEVEL
   from lht_cr
   where d9trc not like 'A%' and d9trc not like 'B%'  and d9trc not like 'C%' 
   order by INT_TIER_TBL_CODE_MIG;
   todo       NUMBER;
   BEGIN
      todo := 100000;
   FOR l_record IN c1
   LOOP
         INSERT INTO tier_entry_cr_new
            values 
     (
        l_record.INT_TIER_TBL_CODE_MIG,
        l_record.D_C_ind,
        l_record.begin_amt,
        l_record.end_amt,
        l_record.base_rate,
        l_record.diff_rate,
        l_record.seq,
        todo,
        l_record.S5CCY,
        l_record.SLAB_LEVEL
     );
    -- insert into manage_rates values (l_record.CR_TIER_BASE_S1,l_record.INT_TIER_TBL_CODE_MIG);
         todo := todo +1;
            COMMIT;
   END LOOP;
   COMMIT;
END;
/
 
