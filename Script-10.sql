select trs.update_date,
	   tt.master_number,
	   case
   		   when tt.base_company_id = 4043 then 'НСК'
   		   when tt.base_company_id = 7343 then 'НЗК'
   		   when tt.base_company_id = 63383 then 'АЛТ'
   		   when tt.base_company_id = 69881 then 'КЕМ'
   		   when tt.base_company_id = 236601 then 'КРС'
   		   when tt.base_company_id = 20000105 then 'НРК'
   	    end as branch,
   	    ud."name",
   	    sa.create_date is not null as install_fact
		from master.ticket_reports_services trs
	inner join master.ticket_ticket tt on tt.ticket_id = trs.ticket_id
	inner join master.scheduler_slots ss on ss.ticket_id = trs.ticket_id
	left join master.user_data ud on ud.user_id = ss.engineer_id
	left join billing.accounts a on a.account_number = tt.account_number
	inner join terrasoft.contacts c on c.person_id = a.person_id
	left join apps.sibseti_authlog sa on sa.phone_number = c.communication3 or sa.phone_number = c.communication2 or sa.phone_number = c.communication1
 where 'Установка "Мои СибСети"' in (select * from unnest(trs.service_name));


select final_table.*,
	   split_part(final_table.staff_unit_name, ' /', 1),
	   split_part(final_table.staff_unit_name, '/', 2),
	   case 
	   	when final_table.division_0 like '%Алтайский%' then 'АЛТ'
	   	when final_table.division_0 like '%Красноярский%' then 'КРС'
	   	when final_table.division_0 like '%Новокузнецкий%' then 'НЗК'
	   	when final_table.division_0 like '%Новосибирский%' then 'НСК'
	   	when final_table.division_0 like '%Кемеровский%' then 'КЕМ'
	   	when final_table.division_0 like '%Норильский%' then 'НРК'
	   	when final_table.division_0 is null then null 
	   	else 'КЦ'
	   end as branch
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
	 where final_table.row_column = 1;
	
select *,
	   row_number () over (partition by sphz.employee_id order by sphz.date) as row_id
		from erp.employee_zup ez
	left join erp.staff_personnel_history_zup sphz on sphz.employee_id = ez.employee_id
	left join erp.staff_of_positions_zup sopz on sopz.position_id = sphz.position_id
 

 	
select i.account_number,
		   row_number() over (partition by sa.phone_number order by i.create_date) as first_seller, 
		   row_number () over (partition by sphz.employee_id order by sphz.date desc) as row_id,
		   i.terrasoft_number,
		   i.create_date,
		   i.sale_agent,
		   case 
		   	when utfo.operator_login is null then sas.agent_login else utfo.operator_login
		   end as final_login,
		   sa.phone_number,
		   ez.employee_name,
		   ez.employee_id,
		   sphz.*,
		   sa.create_date::date as install_date
			from terrasoft.incidents i
		inner join billing.accounts a on a.account_number = i.account_number
		inner join terrasoft.contacts c on c.person_id = a.person_id
		left join terrasoft.users_terrasoft_from_oktell utfo on utfo.terrasoft_id = i.sale_agent_id
		left join erp.sale_agent_1s sas on sas.agent_billing_name = i.sale_agent
		left join erp.employee_zup ez on ez.employee_name like concat('%', left(i.sale_agent, length(i.sale_agent) - 1), '%')
		left join apps.sibseti_authlog sa on sa.phone_number = c.communication3 or sa.phone_number = c.communication2 or sa.phone_number = c.communication1
		inner join erp.staff_personnel_history_zup sphz on sphz.employee_id = ez.employee_id
	  where i.terrasoft_code like '%556%' and (sa.create_date::date = i.create_date::date or sa.create_date::date = i.create_date::date - interval '1 day');
	  
select  row_number () over (partition by ez.employee_id order by  sphz.date desc) as row_id,
      sphz.date,
        ud.name, 
      ud.login, 
      ud.user_id,
      ez.employee_id,
        sphz.date,
        ez.employee_name,
          sopz.staff_unit_name 
      from master.user_data ud
  left join erp.employee_zup ez on (case 
                    when ez.employee_name like 'ГПД'
                then right(ez.employee_name, 4)= ud.name 
                else ez.employee_name= ud.name
                end )
  left join erp.staff_personnel_history_zup sphz on sphz.employee_id = ez.employee_id 
  left join erp.staff_of_positions_zup sopz on sopz.staff_unit_id = sphz.staff_unit
            and sopz.division_id = sphz.division_id  
            and sopz.position_id != '00000000-0000-0000-0000-000000000000'
  where ez.employee_name is not null;
  
select *
		from erp.employee_zup ez 
	where ez.employee_name~*'Подкутин Максим Сергеевич'
 
select *,
	   row_number () over (partition by sphz.employee_id order by sphz.date desc) as row_id
		from erp.staff_personnel_history_zup sphz
	where sphz.employee_id = 'ce88f21c-5bc7-11ec-8453-00505681b69b'
 
 	
 select *
		from erp.staff_of_positions_zup sopz
	where sopz.staff_unit_id = '38769929-4c8a-11e9-843a-005056819dc4'

select ra.account_number,
	   count(ra.account_number)
		from apps.readtv_accounts ra
	group by ra.account_number, ra.ip
	having count(ra.account_number) > 1
	order by account_number desc
	
with closest_time as (select * from (select check_table.*,
							 row_number() over (partition by check_table.account_number order by check_table.min_check)
					  		from (select i2.account_number,
							 i2.sale_agent,
							 i2.create_date,
							 ra.create_date as install_date,
							 ra.create_date - i2.create_date as min_check
							from terrasoft.incidents i2 
								left join apps.readtv_accounts ra on ra.account_number = i2.account_number
								left join billing.accounts a on a.account_number = i2.account_number
								left join terrasoft.contacts c on c.person_id = a.person_id
							where ra.create_date is not null and i2.account_number like '2%') as check_table
							group by check_table.account_number, check_table.sale_agent, check_table.create_date, check_table.install_date, check_table.min_check) as final_table
							where final_table.row_number = 1 and interval '0 day' < final_table.min_check and final_table.min_check < interval '1 day'  
						)
select i.sale_agent,
	   i.create_date,
	   ra.create_date,
	   c.communication3 as phone_number,
	   ra.account_number
		from terrasoft.incidents i 
	inner join billing.accounts a on a.account_number = i.account_number
	inner join terrasoft.contacts c on c.person_id = a.person_id
	left join apps.readtv_accounts ra on ra.account_number = a.account_number
	where ra.account_number is not null and ra.account_number = '2000000211945';
	
	
select * from (select check_table.*,
							 row_number() over (partition by check_table.account_number order by check_table.time_check)
					  		from (select i.account_number,
								  		 c.communication3 as phone_number,
										 i.sale_agent,
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
										 i.create_date,
										 ra.create_date as install_date,
										 ra.create_date - i.create_date as time_check
										from terrasoft.incidents i 
											left join apps.readtv_accounts ra on ra.account_number = i.account_number
											left join billing.accounts a on a.account_number = i.account_number
											left join terrasoft.contacts c on c.person_id = a.person_id
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
										  where ra.create_date is not null and i.account_number like '2%' and i.sale_agent is not null) as check_table) as final_table
										where final_table.row_number = 1 and interval '0 day' < final_table.time_check and final_table.time_check < interval '1 day' and final_table.install_date > '2022-07-01'
										
										
										
										