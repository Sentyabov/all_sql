--Целевые обращения				
select 	date(df.update_date),
		df.operator_name,
		df.departament ,
		df.direction ,
		df.phone  ,
		df.region ,
		df.terrasoft_number ,
		df.terrasoft_code ,
		df.contact_id,
		case df.base_company_id
        when 4043 then 'НСК'
        when 7343 then 'НЗК'
        when 63383 then 'АЛТ'
        when 69881 then 'КЕМ'
        when 236601 then 'КРС'
        when 20000105 then 'НРК'
        else 'КЦ'
        end as brunch_obr,
		case when inc.city is null then inc2.normal_city else inc.city end as city_obrachenia
					from (
									select update_date,
											rank() over (partition by terrasoft_number order by c.create_date ) as rank ,
											operator_name,
											departament ,
											direction,
											base_company_id,
									        phone ,
									        region ,
									        terrasoft_number ,
									        terrasoft_code,
									        contact_id
									        from terrasoft.calls c 
										where c.operator_name in ('Воробьева Анастасия Вениаминовна', 'Деменина Татьяна Валерьевна', 
																'Иконников Александр Николаевич', 'Кривошеев Игорь Анатольевич', 
																'Ласс Игорь ', 'Мисник Константин Вячеславович', 'Муравьёва Екатерина Анатольевна',
																'Павлова Юлия Владимировна', 'Тихонов Сергей Александрович', 'Мамонов Кирилл ')
															and (c.terrasoft_code like '%101 %' or c.terrasoft_code like '%101-3%' or c.terrasoft_code like '%106 %' or c.terrasoft_code like '%705ф%' 
																or c.terrasoft_code like '%722 %' or c.terrasoft_code like '%722-1%' or c.terrasoft_code like '%724 %' or c.terrasoft_code like '%724-1%' 
																or c.terrasoft_code like '%725 %' or c.terrasoft_code like '%725-1%'or c.terrasoft_code like '%726 %' or c.terrasoft_code like '%727 %' 
																or c.terrasoft_code like '%727-1%' or c.terrasoft_code like '%728 %' or c.terrasoft_code like '%728-1%' or c.terrasoft_code like '%729%' 
																or c.terrasoft_code like '%730 %' or c.terrasoft_code like '%730-1%' or c.terrasoft_code like '%731 %' or c.terrasoft_code like '%731-1%'
																or c.terrasoft_code like '%732 %' or c.terrasoft_code like '%732-1%' or c.terrasoft_code like '%738 %' or c.terrasoft_code like '%738-1%'
																or c.terrasoft_code like '%726-1%')
															and ((region like '%Реклам%' and region not like '%Рекламный номер (Норильск 2GIS)%' 
																and region not like '%ВЕБ%' and region not like '%Домофоны%') or region like '%Продавцы%'
																or region like '%TM Исходящий обзвон - callback tm%' or region like '%Перезвон потенциальному абоненту%'
																or region like '%Обзвон Информирование (перезвон)%' or region like '%Входящие звонки - очередь Новосибирск (Переводы)%')
															and terrasoft_number is not null
															and date(update_date)>='2021-04-01'
															and base_company_id is not null) as df 
						left join terrasoft.contacts c2 on c2.id = df.contact_id
						left join "static".influx_normal_city inc on inc.base_company_id = df.base_company_id and inc.city = rtrim (c2.city, ' г')
						left join "static".influx_normal_city inc2 on inc2.base_company_id = df.base_company_id and inc2.city is null
						where df.rank = 1 and (case when inc.city is null then inc2.normal_city else inc.city end) in ('Новокузнецк','Осинники','Прокопьевск','Междуреченск','Мыски','Калтан','Киселевск','Барнаул','Бийск',
						'Рубцовск','Заринск','Новоалтайск','Новосибирск','Бердск','Искитим','Обь','Игарка','Норильск','Кемерово','Ленинск-Кузнецкий','Березовский',
						'Юрга','Полысаево','Анжеро-Судженск','Белово','Грамотеино','Гурьевск','Инской','Топки','Красноярск','Лесосибирск','Зеленогорск','Назарово',
						'Ачинск','Минусинск','Дивногорск','Тартат','Заозерный','Абакан','Черногорск','Бородино');
						
					
--Целевые заявки, в таблице incidents нет колонок филиал, регион и город, поэтому филиал и регион берем из calls, а города присоединяем из сontacts
select i.terrasoft_number as terrasoft_number_zayavki,
		date (i.create_date) as create_date ,
		i.sale_agent ,
		i.master_status,
        i.terrasoft_code as terrasoft_code_zayavki,
		case c.base_company_id
						   when 4043 then 'НСК'
						   when 7343 then 'НЗК'
						   when 63383 then 'АЛТ'
						   when 69881 then 'КЕМ'
						   when 236601 then 'КРС'
						   when 20000105 then 'НРК'
				           else 'КЦ'
				        end as brunch_zayavki,
		c. city_zayavki,		        
        region as region_zayavki
		from terrasoft.incidents i
		left join (select distinct c.terrasoft_number,
						c.contact_id,
                        c.base_company_id,
                        c.region, 
                        case when inc.city is null then inc2.normal_city else inc.city end as city_zayavki
							from terrasoft.calls c
						left join terrasoft.contacts c2 on c2.id = c.contact_id
						left join "static".influx_normal_city inc on inc.base_company_id = c.base_company_id and inc.city = rtrim (c2.city, ' г')
						left join "static".influx_normal_city inc2 on inc2.base_company_id = c.base_company_id and inc2.city is null
					where c.operator_name in ('Воробьева Анастасия Вениаминовна', 'Деменина Татьяна Валерьевна', 
											'Иконников Александр Николаевич', 'Кривошеев Игорь Анатольевич', 
											'Ласс Игорь ', 'Мисник Константин Вячеславович', 'Муравьёва Екатерина Анатольевна',
											'Павлова Юлия Владимировна', 'Тихонов Сергей Александрович', 'Мамонов Кирилл ')
										and (c.terrasoft_code like '%101 %' or c.terrasoft_code like '%101-3%' or c.terrasoft_code like '%106 %' or c.terrasoft_code like '%705ф%' 
											or c.terrasoft_code like '%722 %' or c.terrasoft_code like '%722-1%' or c.terrasoft_code like '%724 %' or c.terrasoft_code like '%724-1%' 
											or c.terrasoft_code like '%725 %' or c.terrasoft_code like '%725-1%'or c.terrasoft_code like '%726 %' or c.terrasoft_code like '%727 %' 
											or c.terrasoft_code like '%727-1%' or c.terrasoft_code like '%728 %' or c.terrasoft_code like '%728-1%' or c.terrasoft_code like '%729%' 
											or c.terrasoft_code like '%730 %' or c.terrasoft_code like '%730-1%' or c.terrasoft_code like '%731 %' or c.terrasoft_code like '%731-1%'
											or c.terrasoft_code like '%732 %' or c.terrasoft_code like '%732-1%' or c.terrasoft_code like '%738 %' or c.terrasoft_code like '%738-1%'
											or c.terrasoft_code like '%726-1%')) c on c.terrasoft_number = i.terrasoft_number 
		where i.sale_agent  in ('Воробьева Анастасия Вениаминовна', 'Деменина Татьяна Валерьевна', 
							'Иконников Александр Николаевич', 'Кривошеев Игорь Анатольевич', 
							'Ласс Игорь ', 'Мисник Константин Вячеславович', 'Муравьёва Екатерина Анатольевна',
							'Павлова Юлия Владимировна', 'Тихонов Сергей Александрович', 'Мамонов Кирилл ')
							and (i.terrasoft_code like '%101 %' or i.terrasoft_code like '%101-3%' or i.terrasoft_code like '%106 %' or i.terrasoft_code like '%705ф%' 
								or i.terrasoft_code like '%722 %' or i.terrasoft_code like '%722-1%' or i.terrasoft_code like '%724 %' or i.terrasoft_code like '%724-1%' 
								or i.terrasoft_code like '%725 %' or i.terrasoft_code like '%725-1%'or i.terrasoft_code like '%726 %' or i.terrasoft_code like '%727 %' 
								or i.terrasoft_code like '%727-1%' or i.terrasoft_code like '%728 %' or i.terrasoft_code like '%728-1%' or i.terrasoft_code like '%729%' 
								or i.terrasoft_code like '%730 %' or i.terrasoft_code like '%730-1%' or i.terrasoft_code like '%731 %' or i.terrasoft_code like '%731-1%'
								or i.terrasoft_code like '%732 %' or i.terrasoft_code like '%732-1%' or i.terrasoft_code like '%738 %' or i.terrasoft_code like '%738-1%' 
								or i.terrasoft_code like '%726-1%')
							and master_status != 'Отправлен ПЭП' and master_status is not null
							and i.sale_channel in ('Контакт-центр', null) 
							and c.base_company_id is not null
                            and date (i.create_date)>='2021-04-01'
                            
                            
--Фактический приток                           
select date (real_start_date) as start_date,
							base_company_id,
					        city,
					      	count (account_number) as fakt_pritok
							from reports.influx_of_services
					where order_type = 'ШПД' and sale_channel = 'Контакт-центр'
group by start_date , city, base_company_id


--Плановые значения (12863 строки)
	select iosp.month,
		case iosp.base_company_id
		   when 4043 then 'НСК'
		   when 7343 then 'НЗК'
		   when 63383 then 'АЛТ'
		   when 69881 then 'КЕМ'
		   when 236601 then 'КРС'
		   when 20000105 then 'НРК'
           else 'КЦ'
        end as brunch ,
		iosp.city ,
		sum(iosp.value) as plan_pritok, 
		sum(iosp.value)/(0.8) as plan_obr,
		sum(iosp.value)/(0.8)/(0.85) as plan_zayavki
		from "static".influx_of_services_plan_day iosp
where  iosp.order_type  = 'ШПД' 
	and iosp.sale_channel = 'Контакт-центр' 
	and iosp.city not in ('Железногорск', 'Заозерный', 'Зозерный', 'Салаир') 
	and iosp.project in ('Проект_FVNO', 'Проект_Операционный', 'Проект_Новостройки', 'Проект_Цифровой домофон')
group by iosp.month, iosp.base_company_id, iosp.city

					
					
                            
                            
--Сводим все в одну таблицу, джойним все запросы к плановым значениям
with faktich_pritok as (select date (real_start_date) as start_date,
								base_company_id,
						        city,
						      	count (account_number) as fakt_pritok
								from reports.influx_of_services
						 where order_type = 'ШПД' and sale_channel = 'Контакт-центр'
						 group by start_date , city, base_company_id),
faktich_obrashenia as (select 	df.date,
								df.base_company_id,
								df.city,
								count (terrasoft_number) as fakt_obr
								from (
										select date (c.update_date),
												rank() over (partition by terrasoft_number order by c.create_date ) as rank ,
												c.base_company_id,
												case when inc.city is null then inc2.normal_city else inc.city end as city,
												c.terrasoft_number  
											    from terrasoft.calls c 
										    left join terrasoft.contacts c2 on c2.id = c.contact_id
											left join "static".influx_normal_city inc on inc.base_company_id = c.base_company_id and inc.city = rtrim (c2.city, ' г')
											left join "static".influx_normal_city inc2 on inc2.base_company_id = c.base_company_id and inc2.city is null
										where c.operator_name in ('Воробьева Анастасия Вениаминовна', 'Деменина Татьяна Валерьевна', 
																'Иконников Александр Николаевич', 'Кривошеев Игорь Анатольевич', 
																'Ласс Игорь ', 'Мисник Константин Вячеславович', 'Муравьёва Екатерина Анатольевна',
																'Павлова Юлия Владимировна', 'Тихонов Сергей Александрович', 'Мамонов Кирилл ')
															and (c.terrasoft_code like '%101 %' or c.terrasoft_code like '%101-3%' or c.terrasoft_code like '%106 %' or c.terrasoft_code like '%705ф%' 
																or c.terrasoft_code like '%722 %' or c.terrasoft_code like '%722-1%' or c.terrasoft_code like '%724 %' or c.terrasoft_code like '%724-1%' 
																or c.terrasoft_code like '%725 %' or c.terrasoft_code like '%725-1%'or c.terrasoft_code like '%726 %' or c.terrasoft_code like '%727 %' 
																or c.terrasoft_code like '%727-1%' or c.terrasoft_code like '%728 %' or c.terrasoft_code like '%728-1%' or c.terrasoft_code like '%729%' 
																or c.terrasoft_code like '%730 %' or c.terrasoft_code like '%730-1%' or c.terrasoft_code like '%731 %' or c.terrasoft_code like '%731-1%'
																or c.terrasoft_code like '%732 %' or c.terrasoft_code like '%732-1%' or c.terrasoft_code like '%738 %' or c.terrasoft_code like '%738-1%'
																or c.terrasoft_code like '%726-1%')
															and ((region like '%Реклам%' and region not like '%Рекламный номер (Норильск 2GIS)%' 
																and region not like '%ВЕБ%' and region not like '%Домофоны%') or region like '%Продавцы%'
																or region like '%TM Исходящий обзвон - callback tm%' or region like '%Перезвон потенциальному абоненту%'
																or region like '%Обзвон Информирование (перезвон)%' or region like '%Входящие звонки - очередь Новосибирск (Переводы)%')
															and terrasoft_number is not null
															and date(c.update_date)>='2021-04-01'
															and c.base_company_id is not null) as df
							where df.rank = 1 and df.city in ('Новокузнецк','Осинники','Прокопьевск','Междуреченск','Мыски','Калтан','Киселевск','Барнаул','Бийск',
								'Рубцовск','Заринск','Новоалтайск','Новосибирск','Бердск','Искитим','Обь','Игарка','Норильск','Кемерово','Ленинск-Кузнецкий','Березовский',
								'Юрга','Полысаево','Анжеро-Судженск','Белово','Грамотеино','Гурьевск','Инской','Топки','Красноярск','Лесосибирск','Зеленогорск','Назарово',
								'Ачинск','Минусинск','Дивногорск','Тартат','Заозерный','Абакан','Черногорск','Бородино')	
							group by df.date, df.base_company_id , df.city),
faktich_zayavki as (select 	date (i.create_date) as create_date ,
					        c.base_company_id,
							c.city,
							count (i.terrasoft_number) as fakt_zayavki
							from terrasoft.incidents i
							left join (select distinct c.terrasoft_number,
											c.contact_id,
					                        c.base_company_id,
					                        case when inc.city is null then inc2.normal_city else inc.city end as city
												from terrasoft.calls c
										left join terrasoft.contacts c2 on c2.id = c.contact_id
										left join "static".influx_normal_city inc on inc.base_company_id = c.base_company_id and inc.city = rtrim (c2.city, ' г')
										left join "static".influx_normal_city inc2 on inc2.base_company_id = c.base_company_id and inc2.city is null
										where c.operator_name in ('Воробьева Анастасия Вениаминовна', 'Деменина Татьяна Валерьевна', 
																'Иконников Александр Николаевич', 'Кривошеев Игорь Анатольевич', 
																'Ласс Игорь ', 'Мисник Константин Вячеславович', 'Муравьёва Екатерина Анатольевна',
																'Павлова Юлия Владимировна', 'Тихонов Сергей Александрович', 'Мамонов Кирилл ')
															and (c.terrasoft_code like '%101 %' or c.terrasoft_code like '%101-3%' or c.terrasoft_code like '%106 %' or c.terrasoft_code like '%705ф%' 
																or c.terrasoft_code like '%722 %' or c.terrasoft_code like '%722-1%' or c.terrasoft_code like '%724 %' or c.terrasoft_code like '%724-1%' 
																or c.terrasoft_code like '%725 %' or c.terrasoft_code like '%725-1%'or c.terrasoft_code like '%726 %' or c.terrasoft_code like '%727 %' 
																or c.terrasoft_code like '%727-1%' or c.terrasoft_code like '%728 %' or c.terrasoft_code like '%728-1%' or c.terrasoft_code like '%729%' 
																or c.terrasoft_code like '%730 %' or c.terrasoft_code like '%730-1%' or c.terrasoft_code like '%731 %' or c.terrasoft_code like '%731-1%'
																or c.terrasoft_code like '%732 %' or c.terrasoft_code like '%732-1%' or c.terrasoft_code like '%738 %' or c.terrasoft_code like '%738-1%'
																or c.terrasoft_code like '%726-1%')) c on c.terrasoft_number = i.terrasoft_number 
					 where i.sale_agent  in ('Воробьева Анастасия Вениаминовна', 'Деменина Татьяна Валерьевна', 
												'Иконников Александр Николаевич', 'Кривошеев Игорь Анатольевич', 
												'Ласс Игорь ', 'Мисник Константин Вячеславович', 'Муравьёва Екатерина Анатольевна',
												'Павлова Юлия Владимировна', 'Тихонов Сергей Александрович', 'Мамонов Кирилл ')
										and (i.terrasoft_code like '%101 %' or i.terrasoft_code like '%101-3%' or i.terrasoft_code like '%106 %' or i.terrasoft_code like '%705ф%' 
											or i.terrasoft_code like '%722 %' or i.terrasoft_code like '%722-1%' or i.terrasoft_code like '%724 %' or i.terrasoft_code like '%724-1%' 
											or i.terrasoft_code like '%725 %' or i.terrasoft_code like '%725-1%'or i.terrasoft_code like '%726 %' or i.terrasoft_code like '%727 %' 
											or i.terrasoft_code like '%727-1%' or i.terrasoft_code like '%728 %' or i.terrasoft_code like '%728-1%' or i.terrasoft_code like '%729%' 
											or i.terrasoft_code like '%730 %' or i.terrasoft_code like '%730-1%' or i.terrasoft_code like '%731 %' or i.terrasoft_code like '%731-1%'
											or i.terrasoft_code like '%732 %' or i.terrasoft_code like '%732-1%' or i.terrasoft_code like '%738 %' or i.terrasoft_code like '%738-1%' 
											or i.terrasoft_code like '%726-1%')
										and master_status != 'Отправлен ПЭП'
										and i.sale_channel in ('Контакт-центр', null) 
										and c.base_company_id is not null
			                            and date (i.create_date)>='2021-04-01'
					 group by date (i.create_date), c.base_company_id, c.city)							
select iospd.month,
		case iospd.base_company_id
		   when 4043 then 'НСК'
		   when 7343 then 'НЗК'
		   when 63383 then 'АЛТ'
		   when 69881 then 'КЕМ'
		   when 236601 then 'КРС'
		   when 20000105 then 'НРК'
           else 'КЦ'
        end as brunch ,
		iospd.city ,
		sum(iospd.value) as plan_pritok, 
		case when fp.fakt_pritok is null then 0 else fp.fakt_pritok end as fakt_pritok,
		sum(iospd.value)/(0.8) as plan_obr,
		case when fo.fakt_obr is null then 0 else fo.fakt_obr end as fakt_obra,
		sum(iospd.value)/(0.8)/(0.85) as plan_zayavki,
		case when fz.fakt_zayavki  is null then 0 else fz.fakt_zayavki  end as fakt_zayavki 
		from "static".influx_of_services_plan_day iospd
left join faktich_pritok fp on fp.start_date = iospd."month" and fp.base_company_id = iospd.base_company_id and fp.city = iospd.city
left join faktich_obrashenia fo on fo.date = iospd."month" and fo.base_company_id = iospd.base_company_id and fo.city = iospd.city
left join faktich_zayavki fz on fz.create_date = iospd."month" and fz.base_company_id = iospd.base_company_id and fz.city = iospd.city
where  iospd.order_type  = 'ШПД' 
	and iospd.sale_channel = 'Контакт-центр' 
	and iospd.city not in ('Железногорск', 'Заозерный', 'Зозерный', 'Салаир') 
	and iospd.project in ('Проект_FVNO', 'Проект_Операционный', 'Проект_Новостройки', 'Проект_Цифровой домофон')
group by iospd.month, iospd.base_company_id, iospd.city, fp.fakt_pritok, fo.fakt_obr, fz.fakt_zayavki  














--test
select 	date (i.create_date) as create_date ,
        c.base_company_id,
		c.city_zayavki,
		count (i.terrasoft_number) 
		from terrasoft.incidents i
		left join (select distinct c.terrasoft_number,
						c.contact_id,
                        c.base_company_id,
                        case when inc.city is null then inc2.normal_city else inc.city end as city_zayavki
							from terrasoft.calls c
					left join terrasoft.contacts c2 on c2.id = c.contact_id
					left join "static".influx_normal_city inc on inc.base_company_id = c.base_company_id and inc.city = rtrim (c2.city, ' г')
					left join "static".influx_normal_city inc2 on inc2.base_company_id = c.base_company_id and inc2.city is null
					where c.operator_name in ('Воробьева Анастасия Вениаминовна', 'Деменина Татьяна Валерьевна', 
											'Иконников Александр Николаевич', 'Кривошеев Игорь Анатольевич', 
											'Ласс Игорь ', 'Мисник Константин Вячеславович', 'Муравьёва Екатерина Анатольевна',
											'Павлова Юлия Владимировна', 'Тихонов Сергей Александрович', 'Мамонов Кирилл ')
										and (c.terrasoft_code like '%101 %' or c.terrasoft_code like '%101-3%' or c.terrasoft_code like '%106 %' or c.terrasoft_code like '%705ф%' 
											or c.terrasoft_code like '%722 %' or c.terrasoft_code like '%722-1%' or c.terrasoft_code like '%724 %' or c.terrasoft_code like '%724-1%' 
											or c.terrasoft_code like '%725 %' or c.terrasoft_code like '%725-1%'or c.terrasoft_code like '%726 %' or c.terrasoft_code like '%727 %' 
											or c.terrasoft_code like '%727-1%' or c.terrasoft_code like '%728 %' or c.terrasoft_code like '%728-1%' or c.terrasoft_code like '%729%' 
											or c.terrasoft_code like '%730 %' or c.terrasoft_code like '%730-1%' or c.terrasoft_code like '%731 %' or c.terrasoft_code like '%731-1%'
											or c.terrasoft_code like '%732 %' or c.terrasoft_code like '%732-1%' or c.terrasoft_code like '%738 %' or c.terrasoft_code like '%738-1%'
											or c.terrasoft_code like '%726-1%')) c on c.terrasoft_number = i.terrasoft_number 
where i.sale_agent  in ('Воробьева Анастасия Вениаминовна', 'Деменина Татьяна Валерьевна', 
							'Иконников Александр Николаевич', 'Кривошеев Игорь Анатольевич', 
							'Ласс Игорь ', 'Мисник Константин Вячеславович', 'Муравьёва Екатерина Анатольевна',
							'Павлова Юлия Владимировна', 'Тихонов Сергей Александрович', 'Мамонов Кирилл ')
							and (i.terrasoft_code like '%101 %' or i.terrasoft_code like '%101-3%' or i.terrasoft_code like '%106 %' or i.terrasoft_code like '%705ф%' 
								or i.terrasoft_code like '%722 %' or i.terrasoft_code like '%722-1%' or i.terrasoft_code like '%724 %' or i.terrasoft_code like '%724-1%' 
								or i.terrasoft_code like '%725 %' or i.terrasoft_code like '%725-1%'or i.terrasoft_code like '%726 %' or i.terrasoft_code like '%727 %' 
								or i.terrasoft_code like '%727-1%' or i.terrasoft_code like '%728 %' or i.terrasoft_code like '%728-1%' or i.terrasoft_code like '%729%' 
								or i.terrasoft_code like '%730 %' or i.terrasoft_code like '%730-1%' or i.terrasoft_code like '%731 %' or i.terrasoft_code like '%731-1%'
								or i.terrasoft_code like '%732 %' or i.terrasoft_code like '%732-1%' or i.terrasoft_code like '%738 %' or i.terrasoft_code like '%738-1%' 
								or i.terrasoft_code like '%726-1%')
							and master_status != 'Отправлен ПЭП'
							and i.sale_channel in ('Контакт-центр', null) 
							and c.base_company_id is not null
                            and date (i.create_date)>='2021-04-01'
group by date (i.create_date), 	c.base_company_id, c.city_zayavki
		
		
		
		
		
		
		
		
		