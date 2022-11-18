select tt.created_date,
	   tt.end_date,
       tt.account_number,
       tt.categories,
       tt.reason,
       tt.status,
       tt.home1s,
       lh.point,
       trst.service_type_name[1]
		from master.ticket_ticket tt
	inner join master.ticket_reports_service_types trst on trst.ticket_id = tt.ticket_id
	left join master.location_houses lh on lh.code_1s = tt.home1s
	where tt.work_type = 'Сервисный выезд' and tt.account_number like '2%';

select distinct tt.status 
		from master.ticket_ticket tt;
	

select distinct tt.reason,
		count(tt.reason)
		from master.ticket_ticket tt
	group by tt.reason;
	

select *
		from master.ticket_ticket tt
	where tt.work_type = 'Сервисный выезд';
	
select distinct tt.categories
		from master.ticket_ticket tt
	where tt.work_type = 'Сервисный выезд';
	

with tv as (select distinct
                   ra.account_number,
				   ra.last_active_date,
				   rank() over(partition by ra.account_number order by last_active_date desc) as ord
				    from apps.readtv_accounts ra 
			 where ra.account_number like '2%'
			   and ra.last_active_date is not null)
select case t1.base_company_id
		   when 4043 then 'НСК'
		   when 7343 then 'НЗК'
		   when 63383 then 'АЛТ'
		   when 69881 then 'КЕМ'
		   when 236601 then 'КРС'
		   when 20000105 then 'НРК'
		end as branch,
	   t1.city,
       t1.account_id,
	   t1.account_number, 
       t1.core_user_id,
	   t1.real_start_date, 
	   t1.order_type,
	   t1.tariff_name,
	   case
       	  when t2.tariff_group_name like 'Пакет%' then 'Пакет' 
          when t1.tariff_name like 'Пакет%' then 'Пакет'
          else 'Моно'
        end as pack_checker,
       t1.tariff_price,
       t1.tariff_total_price,
       t1.service_item_id,
	   t1.service_type_name,
       t1.service_type_price,
       t1.web_user_login,
	   t1.auto_on,
	   t1.pfl_number,
       t1.pfl_create_date,
       t1.pfl_closing_date,
	   t1.sale_channel,
	   t1.supervisor,
	   t1.sale_agent,
	   case 
       	  when t1.project is null then 'Проект_Операционный' else t1.project
       	end as project,
	   t1.source,
       t1.logic,
       t.last_active_date
		from reports.influx_of_services t1
   left join billing.tariff_base_company_and_groups t2 on t1.base_company_id = t2.base_company_id and t1.tariff_id = t2.tariff_id
   left join tv t on t.account_number=t1.account_number and t.ord=1
 where real_start_date>=date_trunc('year',current_date) - interval '11 month' and t1.sale_agent like '%Иконников Александр Николаевич%' and t1.real_start_date >= '2022-08-23';
 


select * 
		from reports.influx_of_services ios 
	where ios.sale_agent like '%Воробьева Анастасия Вениаминовна%' and ios.real_start_date >= '2022-08-23';
	


select distinct on (pfl.account_number,pfls.service_name,pfl.pfl_number)			
		   		pfl.account_number,
		   		pfls.service_name,
		   		pfl.create_date,
			   	pfl.core_user_id,
			   	pfls.service_type_id,
			   	pfl.closing_date,
			   	pfl.pfl_number,	
			   	pfl.operation_type,
			   	pfl.sale_channel,
			   	pfl.supervisor,
			   	pfl.sale_agent
				from erp.document_sale_person_1s pfl
		  left join erp.document_sale_person_service_1s pfls on pfls.pfl_id=pfl.pfl_id 
		  where pfl.operation_type in ('Дополнительные услуги','ПФЛ (Услуги биллинга)','Возврат абонента','Переезд', 'Новый договор','Смена тарифа')
		  and pfl.closing_date is not null;

select *
		from erp.document_sale_person_1s dsps
	where dsps.account_number = '2000001005071'
	
select *
		from orders.influx_of_services_billing iosb
	where iosb.real_start_date = '04.08.2022' and iosb.tariff_name like '%Пакет 500 руб%'
	
select *
		from erp.sale_agent_1s sas
	where sas.agent_name = 'Мамонов Кирилл'

select *
		from erp.document_sale_person_1s dsp
	left join erp.document_sale_person_service_1s dspss on dspss.pfl_id = dsp.pfl_id
	where dsp.account_number = '2000001005071'

select *
		from reports.influx_of_services
	where account_number = '2000000080393'

	
select distinct on (pfl.account_number,pfls.service_name,pfl.pfl_number)			
		   		pfl.account_number,
		   		pfls.service_name,
		   		pfl.create_date,
			   	pfl.core_user_id,
			   	pfls.service_type_id,
			   	pfl.closing_date,
			   	pfl.pfl_number,	
			   	pfl.operation_type,
			   	pfl.sale_channel,
			   	pfl.supervisor,
			   	pfl.sale_agent
				from erp.document_sale_person_1s pfl
		  left join erp.document_sale_person_service_1s pfls on pfls.pfl_id=pfl.pfl_id 
	where pfl.account_number = '2000000674723'
	
select *
		from erp.sale_agent_1s sas 
		
select *
		from erp.document_sale_person_1s dsps
	where dsps.account_number = '2000000674723'
		 
		 
insert into reports.influx_of_services
with 
	pflt1 as (
					select distinct on (pfl.account_number,pfls.service_name,pfl.pfl_number)			
		   		pfl.account_number,
		   		pfls.service_name,
		   		pfl.create_date,
			   	pfl.core_user_id,
			   	pfls.service_type_id,
			   	pfl.closing_date,
			   	pfl.pfl_number,	
			   	pfl.operation_type,
			   	pfl.sale_channel,
			   	pfl.supervisor,
			   	pfl.sale_agent
				from erp.document_sale_person_1s pfl
		  left join erp.document_sale_person_service_1s pfls on pfls.pfl_id=pfl.pfl_id 
		  where pfl.operation_type in ('Дополнительные услуги','ПФЛ (Услуги биллинга)','Возврат абонента','Переезд', 'Новый договор','Смена тарифа')
		  and pfl.closing_date is not null	
	),
	iosbPFL as (
select 
		distinct
       ac.base_company_id,
       case
           when nc.normal_city is null then nnc.normal_city else nc.normal_city
        end as city,
       ac.person_id,
       ac.account_id,
       --ac.account_number,
      -- iosb.core_user_id,
       real_start_date,
       case 
           when iosb.service_type=3 and iosb.service_type_id is null then 'ШПД'
           when iosb.service_type=4 and iosb.service_type_id is null then 'Телефония'
           when iosb.service_type=10 and iosb.service_type_id is null then 'КТВ'
           when iosb.service_type=14 and iosb.service_type_id is null and ((iosb.service_sub_type=22 and iosb.billing='sibset') or (iosb.service_sub_type=21 and iosb.billing='norcom')) then 'Домофон'
           when iosb.service_type=14 and iosb.service_type_id is null and ((iosb.service_sub_type=41 and iosb.billing='sibset') or (iosb.service_sub_type=22 and iosb.billing='norcom')) then 'Умный домофон'
           when iosb.service_type=14 and iosb.service_type_id is null and iosb.service_sub_type=81 then 'Видеонаблюдение'  
           when iosb.service_type=14 and iosb.service_type_id is null then 'Мультисервисы'
           when iosb.service_type=5 and iosb.special_type = 'Оборудование, домофон' and iosb.service_type_name ~ '(Ключ)|( ключ)' then 'Абонентское оборудование ключи (ДМФН)'
           when iosb.service_type=5 and iosb.special_type = 'Оборудование, домофон' and iosb.service_type_name ~* 'трубка' then 'Абонентское оборудование трубка (ДМФН)'
           when iosb.service_type=5 and iosb.special_type like 'Оборудование%' and iosb.service_period=1 then concat(iosb.special_type,', ', 'аренда')
           when iosb.service_type=5 and iosb.special_type like 'Оборудование%' and iosb.service_period=0 then concat(iosb.special_type,', ', 'продажа')
           when iosb.service_type_name in ('amedia_premium', 'AMEDIA_PREMIUM_2016','IPTV_Eng','IPTV_Tatar','MOOD_MOVIE_2016','MOOD_MOVIE_0','NASH_FUTBOL_2016','nash_futbol','match_football_tv', 'match_football_tv_2016', 'IPTV_KINO' ) then 'Микропакеты'
           when iosb.special_type is null then 'Прочее'
           else iosb.special_type 
       end order_type,
       iosb.web_user_login,
       iosb.tariff_id,
       iosb.tariff_name,
       tp.pricelist_sum as tariff_price,
       tp.total_price as tariff_total_price,
       iosb.service_type_id as iosb_service_type_id,
       iosb.service_item_id,
       iosb.service_type_name,
       sp.price as service_type_price,
       iosb.auto_on,
        pj.general_group_name as project,
        'influx' as source,
        null as logic, 
        --Служебные поля, не трогать!:
		ac.account_number as acnu,
		iosb.core_user_id as cu,
		iosb.account_id as ac,
		tc.start_date as tariff_start_date,
		ag.sale_channel as ag_sale_channel,
		ag.agent_name,
		pflt1.pfl_number,
		pflt1.operation_type,
		pflt1.create_date,
		pflt1.closing_date,
		pflt1.sale_channel as sale_channel_lgc1,
		pflt1.supervisor as supervisor_lgc1,
		pflt1.sale_agent as sale_agent_lgc1,
		rank () over(partition by iosb.*  order by  abs(EXTRACT(EPOCH from (pflt1.create_date - iosb.real_start_date))),random()) as rank_lgc1
      from orders.influx_of_services_billing iosb
      inner join billing.accounts ac on ac.account_id=iosb.account_id and ac.person_id is not null
      and  iosb.real_start_date >= CURRENT_DATE - interval '56 day' -- 1 месяц + 15 
     -- and ac.account_number = '2000000991863'
       left join erp.sale_agent_1s ag on ag.agent_login=iosb.web_user_login
       left join billing.addresses pa on pa.person_id=ac.person_id
       left join billing.user_addresses ua on ua.core_user_id=iosb.core_user_id
       left join static.influx_normal_city nc on nc.base_company_id=ac.base_company_id and nc.city=case when ua.city is null then (case when pa.city like '% г' then rtrim(pa.city, ' г') else pa.city end) else (case when ua.city like '% г' then rtrim(ua.city, ' г') else ua.city end) end
       left join static.influx_normal_city nnc on nnc.base_company_id=ac.base_company_id and nnc.city is null
       left join (  select uggl.billing,
                           u.account_id,
                           uggl.core_user_id,
                           ugg.general_group_name   	
                            from billing.user_general_group_links uggl
                      inner join billing.general_groups ugg on ugg.general_group_id=uggl.general_group_id and ugg.billing=uggl.billing and ugg.parent_general_group_id in (1681,10000081)
                      inner join billing.users u on u.core_user_id=uggl.core_user_id and u.billing=uggl.billing) pj on pj.account_id=iosb.account_id and pj.billing=iosb.billing
       left join billing.tariff_prices tp on tp.billing=iosb.billing and tp.tariff_id=iosb.tariff_id
       left join billing.service_prices sp on sp.billing=iosb.billing and sp.tariff_id=iosb.tariff_id and sp.service_type_id=iosb.service_type_id
       left join (
			select pfls.service_name,array_agg(pfls.service_type_id) as service_type_id
				from	(select pfls.service_name, pfls.service_type_id
							from erp.document_sale_person_service_1s pfls
							group by pfls.service_name, pfls.service_type_id) as pfls
			group by pfls.service_name
       ) as tpfl on 
       				(	tpfl.service_name in ('ШПД') 
		  			and iosb.service_type=3 
		  			and iosb.service_type_id is null
					)
					or
					(
					tpfl.service_name in ('ДУ ТСЖ', 'ДУ') 
		  			and iosb.service_type=14 
		  			and iosb.service_type_id is null 
		  			and ((iosb.service_sub_type=41 and iosb.billing='sibset') or (iosb.service_sub_type=22 and iosb.billing='norcom')) 
					)
					or
					(
					tpfl.service_name in ('ДЖ') 
		  			and iosb.service_type=14 
		  			and iosb.service_type_id is null 
		  			and ((iosb.service_sub_type=22 and iosb.billing='sibset') or (iosb.service_sub_type=21 and iosb.billing='norcom')) 
					)
					or
					(
					tpfl.service_name in ('КТВ') 
		  			and iosb.service_type=10 
		  			and iosb.service_type_id is null 
					)
					or
					(
					tpfl.service_name in ('ГТС') 
		  			and iosb.service_type=4 
		  			and iosb.service_type_id is null
					)
					or
					(
					tpfl.service_name in ('IPTV') 
		  			and (iosb.service_type_id = any (tpfl.service_type_id)  or iosb.special_type = 'IPTV')
					)
					or
					(
					tpfl.service_name in ('Wi-Fi роутер аренда','TV приставка аренда','TV приставка аренда', 'Wi-Fi роутер', 'TV приставка', 'Доп. оборудование','Доп. услуга ШПД') 
		  			and  iosb.service_type_id = any (tpfl.service_type_id) 
		  			and case when tpfl.service_name = 'Доп. оборудование' and iosb.service_type_id = 14986 then false else true end
		  			--or (iosb.service_type_name like '%оутер%' and iosb.service_type_name like '%ренда%')
		  			--or exists  (select * from types_pfl where tpfl.service_name = types_pfl.service_name and iosb.service_type_id = types_pfl.service_type_id) --Неточность из-за неверно оформленых ПФЛ
					)
      left join (
			SELECT DISTINCT on (core_user_id) 
			core_user_id,
			start_date,
			new_tariff_id
				FROM datalake.billing.tariff_changes
				ORDER BY core_user_id, start_date desc 
				 ) tc on tc.core_user_id = iosb.core_user_id and tc.new_tariff_id = iosb.tariff_id 
       --PFL logic 1 Максимально точный результат, поиск наименьшей разници во времени в течении 31 дня
       left join pflt1 on pflt1.account_number = ac.account_number 
	  	and (iosb.core_user_id = pflt1.core_user_id or iosb.core_user_id is null or pflt1.core_user_id = 0)
	  	--and (date(pflt1.create_date) IN (date(iosb.start_date), date(iosb.real_start_date), tc.start_date)) --Проверить
	  	and ((date(pflt1.create_date) between (date(iosb.real_start_date) - interval '15 day') and (date(iosb.real_start_date) + interval '15 day'))
	  		or(date(pflt1.closing_date) between (date(iosb.real_start_date) - interval '3 day') and (date(iosb.real_start_date) + interval '3 day'))
	  		)--в течении 31 дня со дня начала ПФЛ и 7 дней со дня закрытия
	  	and (	
					tpfl.service_name = pflt1.service_name
					or
					pflt1.service_name is null --НЕТОЧНОСТЬ из-за некоректных данных PFL, таких ПФЛ около 3.5%!
			)
		) 
	--ТУТ ОСНОВНАЯ ВСТАВКА
		select 	iosbg.base_company_id,
				iosbg.city,
				iosbg.person_id,
				iosbg.account_id,
				iosbg.acnu as account_number,
				iosbg.cu as core_user_id,
				iosbg.real_start_date,
				iosbg.order_type,
				iosbg.web_user_login,
				iosbg.tariff_id,
				iosbg.tariff_name,
				iosbg.tariff_price,
				iosbg.tariff_total_price,
				iosbg.iosb_service_type_id as service_type_id,
				iosbg.service_item_id,
				iosbg.service_type_name,
				iosbg.service_type_price,
				iosbg.auto_on,
				case
					when iosbg.pfl_number is not null then iosbg.pfl_number
					when iosbg.pfl_number_lgc2 is not null then iosbg.pfl_number_lgc2
				end as pfl_number,
				case
					when iosbg.create_date is not null then iosbg.create_date
					when iosbg.create_date_lgc2 is not null then iosbg.create_date_lgc2
				end as create_date,
				case
					when iosbg.closing_date is not null then iosbg.closing_date
					when iosbg.closing_date_lgc2 is not null then iosbg.closing_date_lgc2
				end as closing_date,
				case
					when iosbg.pfl_number is not null then iosbg.sale_channel_lgc1
					when iosbg.pfl_number_lgc2 is not null then iosbg.sale_channel_lgc2
					else ag_sale_channel
				end as sale_channel,
				case
					when iosbg.pfl_number is not null then iosbg.supervisor_lgc1
					when iosbg.pfl_number_lgc2 is not null then iosbg.supervisor_lgc2
				end as supervisor,
				case
					when iosbg.pfl_number is not null then iosbg.sale_agent_lgc1
					when iosbg.pfl_number_lgc2 is not null then iosbg.sale_agent_lgc2
					else iosbg.agent_name
				end as sale_agent,
				iosbg.project,
				iosbg.source,
				iosbg.logic
				from(
				--Логика 2
				select iosbg.*,
							iosbg_for_pfl.pfl_number as pfl_number_lgc2,
							iosbg_for_pfl.operation_type as operation_type_lgc2,
							iosbg_for_pfl.create_date as create_date_lgc2,
							iosbg_for_pfl.closing_date as closing_date_lgc2,
							iosbg_for_pfl.sale_channel_lgc1 as sale_channel_lgc2,
							iosbg_for_pfl.supervisor_lgc1 as supervisor_lgc2,
							iosbg_for_pfl.sale_agent_lgc1 as sale_agent_lgc2,
							iosbg.acnu as acnu2,
					rank () over(partition by iosbg.*  order by  abs(EXTRACT(EPOCH from (iosbg_for_pfl.create_date - iosbg.real_start_date))), random()) as rank_lgc2
					from(select 	distinct
					*
					from iosbPFL iosbg
					--where iosbg.real_start_date >= (CURRENT_DATE - interval '25 day') and iosbg.real_start_date <CURRENT_DATE
					where iosbg.rank_lgc1 = 1) as iosbg
					left join iosbPFL iosbg_for_pfl on iosbg_for_pfl.ac = iosbg.ac
					and iosbg.create_date is null and iosbg_for_pfl.create_date is not null 
					and iosbg_for_pfl.rank_lgc1 = 1
					and 
						(
						date(iosbg.real_start_date) between (date(iosbg_for_pfl.real_start_date) - interval '1 day') and (date(iosbg_for_pfl.real_start_date) + interval '1 day')
						or date(iosbg.real_start_date) between (date(iosbg_for_pfl.create_date) - interval '1 day') and (date(iosbg_for_pfl.create_date) + interval '1 day')
						or
							(
								iosbg_for_pfl.operation_type = 'Новый договор' 
								and (
									(date(iosbg.tariff_start_date) in ( date(iosbg_for_pfl.real_start_date), date(iosbg_for_pfl.create_date)) and iosbg.tariff_start_date between (iosbg.real_start_date - interval '10 day') and (iosbg.real_start_date + interval '10 day' ) )
									or (date(iosbg_for_pfl.tariff_start_date) in ( date(iosbg.real_start_date), date(iosbg.tariff_start_date)) and iosbg_for_pfl.tariff_start_date between (iosbg.real_start_date - interval '10 day') and (iosbg.real_start_date + interval '10 day') )
									)
							)
						)
					) as iosbg
					where iosbg.rank_lgc2 = 1       
       				and  iosbg.real_start_date >= (CURRENT_DATE - interval '1 month') and iosbg.real_start_date <CURRENT_DATE