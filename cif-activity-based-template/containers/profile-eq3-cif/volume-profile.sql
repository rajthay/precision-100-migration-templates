drop table o_row_count;
create table o_row_count as
select'GFPF' as t_name, count(1) row_num from gfpf
union
select 'SCPF' as t_name, count(1) row_num from gfpf;
