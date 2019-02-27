drop table o_essence_cif_validation;
create table o_essence_cif_validation;
select 'NAME_TOO_LONG' as t_name, count(1) row_num from cu1_o_table where length(cust_first_name) > 255
union
select 'MIDDLE_NAME_MISSING' as t_name, count(1) row_num from cu1_o_table where cust_middle_name is null;
