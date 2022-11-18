select final_table.employee_name,
	   final_table.account_number,
	   final_table.phone_number,
	   split_part(final_table.staff_unit_name, ' /', 1) as function,
	   split_part(final_table.staff_unit_name, '/', 2) as department,
	   case 
	   	when final_table.division_0 like '%Алтайский%' then 'АЛТ'
	   	when final_table.division_0 like '%Красноярский%' then 'КРС'
	   	when final_table.division_0 like '%Новокузнецкий%' then 'НЗК'
	   	when final_table.division_0 like '%Новосибирский%' then 'НСК'
	   	when final_table.division_0 like '%Кемеровский%' then 'КЕМ'
	   	when final_table.division_0 like '%Норильский%' then 'НРК'
	   	when final_table.division_0 is null then null 
	   	else 'КЦ'
	   end as branch,
	   final_table.install_date,
	   '1' as master_mob
		from (select i.account_number,
					   row_number() over (partition by sa.phone_number order by i.create_date) as row_column,
					   i.terrasoft_number,
					   case 
				           when dsz5.lvl=0 then dsz5.division_name
				           else case
				                    when dsz4.lvl=0 then dsz4.division_name
				                    else case 
				                             when dsz3.lvl=0 then dsz3.division_name
				                             else case
				                                      when dsz2.lvl=0 then dsz2.division_name
				                                      else case
				                                               when dsz1.lvl=0 then dsz1.division_name
				                                            end
				                                   end
				                         end
				                end
				        end as division_0,
					   i.create_date,
					   i.sale_agent,
					   sa.phone_number,
					   sphz1.date,
					   ez.employee_name,
					   case 
					   	when sopz1.staff_unit_name is null then sopz2.staff_unit_name else sopz1.staff_unit_name 
					   end,
					   sa.create_date::date as install_date
						from terrasoft.incidents i
					inner join billing.accounts a on a.account_number = i.account_number
					inner join terrasoft.contacts c on c.person_id = a.person_id
					left join terrasoft.users_terrasoft_from_oktell utfo on utfo.terrasoft_id = i.sale_agent_id
					left join apps.sibseti_authlog sa on sa.phone_number = c.communication3 or sa.phone_number = c.communication2 or sa.phone_number = c.communication1
					left join erp.sale_agent_1s sas on sas.agent_billing_name = i.sale_agent
					left join erp.employee_zup ez on ez.employee_name like concat('%', left(i.sale_agent, length(i.sale_agent) - 1), '%') 
					left join (select * from (select *,
			 										row_number () over (partition by sphz.employee_id order by sphz.date desc) as row_id
			 												from erp.staff_personnel_history_zup sphz) as test
																where test.row_id = 1) as sphz1 on sphz1.employee_id = ez.employee_id
					left join (select * from (select *,
			 										row_number () over (partition by sphz.employee_id order by sphz.date desc) as row_id
			 												from erp.staff_personnel_history_zup sphz) as test
																where test.row_id = 2) as sphz2 on sphz2.employee_id = ez.employee_id
					left join erp.staff_of_positions_zup sopz1 on sopz1.staff_unit_id = sphz1.staff_unit
					left join erp.staff_of_positions_zup sopz2 on sopz2.staff_unit_id = sphz2.staff_unit
					left join erp.directory_subdivisions_zup dsz1 on sphz1.division_id = dsz1.division_id 
					   left join erp.directory_subdivisions_zup dsz2 on dsz1.parent_id = dsz2.division_id 
					   left join erp.directory_subdivisions_zup dsz3 on case when dsz2.division_name is not null then dsz2.parent_id = dsz3.division_id else dsz1.parent_id = dsz3.division_id end
					   left join erp.directory_subdivisions_zup dsz4 on case when dsz3.division_name is null then (case when dsz2.division_name is not null then dsz2.parent_id = dsz4.division_id else dsz1.parent_id = dsz4.division_id end) else dsz3.parent_id = dsz4.division_id end
					   left join erp.directory_subdivisions_zup dsz5 on case when dsz4.division_name is null then (case when dsz3.division_name is null then (case when dsz2.division_name is not null then dsz2.parent_id = dsz5.division_id else dsz1.parent_id = dsz5.division_id end) else dsz3.parent_id = dsz5.division_id end) else dsz4.parent_id = dsz5.division_id end
				  where i.terrasoft_code like '%556%' and (sa.create_date::date = i.create_date::date or sa.create_date::date = i.create_date::date + interval '1 day')) as final_table
	 where final_table.row_column = 1
union all
select final_table.engineer_name,
		final_table.account_number,
		final_table.phone_number,
		split_part(final_table.department, ' /', 1) as function,
	   split_part(final_table.department, '/', 2) as department,
	   case 
	   	when final_table.division_0 like '%Алтайский%' then 'АЛТ'
	   	when final_table.division_0 like '%Красноярский%' then 'КРС'
	   	when final_table.division_0 like '%Новокузнецкий%' then 'НЗК'
	   	when final_table.division_0 like '%Новосибирский%' then 'НСК'
	   	when final_table.division_0 like '%Кемеровский%' then 'КЕМ'
	   	when final_table.division_0 like '%Норильский%' then 'НРК'
	   	when final_table.division_0 is null then null 
	   	else 'КЦ'
	   end as branch,
	   final_table.install_date,
	   final_table.master_mob
		from(with mt as (select distinct on (tt.master_number)
				   tt.master_number,
				   tt.account_number,
				   tt.work_type,
				   tt.created_date,
				   trs.service_name,
				   ud.name as engeneer_id,
				   tsh.created_date as status_date
					from master.ticket_statuses_history tsh 
			  inner join master.ticket_ticket tt on tt.ticket_id=tsh.ticket_id and tt.created_date>=current_date - interval '2 year' and tt.account_number like'20%'
			  inner join master.user_data ud on ud.user_id=tsh.user_id
			   left join master.ticket_reports_services trs on trs.ticket_id=tt.ticket_id 
			 where tsh.status='awaiting_report'
			order by tt.master_number, tt.account_number, tt.work_type, tt.created_date, trs.service_name, ud.name, tsh.created_date desc),
	mob as (select sa.phone_number,
				   sa.create_date,
				   c.person_id
					from apps.sibseti_authlog sa 
			   left join terrasoft.contacts c on c.communication3=sa.phone_number)
select distinct on (a.account_number) a.account_number,
       mt.work_type,
       mt.engeneer_id as engineer_name,
       case 
		when sopz1.staff_unit_name is null then sopz2.staff_unit_name else sopz1.staff_unit_name 
	   end as department,
	   case 
				           when dsz5.lvl=0 then dsz5.division_name
				           else case
				                    when dsz4.lvl=0 then dsz4.division_name
				                    else case 
				                             when dsz3.lvl=0 then dsz3.division_name
				                             else case
				                                      when dsz2.lvl=0 then dsz2.division_name
				                                      else case
				                                               when dsz1.lvl=0 then dsz1.division_name
				                                            end
				                                   end
				                         end
				                end
	   end as division_0,
       mt.status_date,
       mob.phone_number,
       mob.create_date as install_date,
       case when mob.create_date::date = mt.status_date::date or mob.create_date::date + interval '1 day' = mt.status_date::date then 1 else 0 end as master_mob
        from billing.accounts a
   left join mt on mt.account_number=a.account_number
   left join mob on mob.person_id=a.person_id
   left join erp.employee_zup ez on ez.employee_name like concat('%', left(mt.engeneer_id, length(mt.engeneer_id) - 1), '%') 
					left join (select * from (select *,
			 										row_number () over (partition by sphz.employee_id order by sphz.date desc) as row_id
			 												from erp.staff_personnel_history_zup sphz) as test
																where test.row_id = 1) as sphz1 on sphz1.employee_id = ez.employee_id
					left join (select * from (select *,
			 										row_number () over (partition by sphz.employee_id order by sphz.date desc) as row_id
			 												from erp.staff_personnel_history_zup sphz) as test
																where test.row_id = 2) as sphz2 on sphz2.employee_id = ez.employee_id
	left join erp.staff_of_positions_zup sopz1 on sopz1.staff_unit_id = sphz1.staff_unit
	left join erp.staff_of_positions_zup sopz2 on sopz2.staff_unit_id = sphz2.staff_unit
	left join erp.directory_subdivisions_zup dsz1 on sphz1.division_id = dsz1.division_id 
	left join erp.directory_subdivisions_zup dsz2 on dsz1.parent_id = dsz2.division_id 
	left join erp.directory_subdivisions_zup dsz3 on case when dsz2.division_name is not null then dsz2.parent_id = dsz3.division_id else dsz1.parent_id = dsz3.division_id end
	left join erp.directory_subdivisions_zup dsz4 on case when dsz3.division_name is null then (case when dsz2.division_name is not null then dsz2.parent_id = dsz4.division_id else dsz1.parent_id = dsz4.division_id end) else dsz3.parent_id = dsz4.division_id end
	left join erp.directory_subdivisions_zup dsz5 on case when dsz4.division_name is null then (case when dsz3.division_name is null then (case when dsz2.division_name is not null then dsz2.parent_id = dsz5.division_id else dsz1.parent_id = dsz5.division_id end) else dsz3.parent_id = dsz5.division_id end) else dsz4.parent_id = dsz5.division_id end
 where a.company_id is null and mt.status_date > '2022-03-11'
   and (mt.account_number is not null or mob.person_id is not null) and (mob.create_date::date = mt.status_date::date or mob.create_date::date + interval '1 day' = mt.status_date::date)) as final_table;

 