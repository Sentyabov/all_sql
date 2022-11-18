select *
	from terrasoft.calls c 
	where c.region like '%2GIS%';
	
select id,
	   contact_name,
       phone,
       email,
       split_part(city, ' ', 1) as city,
       street,
       house,
       flat,
       source,
       source_type_id,
       source_id,
       update_date
	from all_rubbish.ne_abonents;
	
select cg.account_id,
  		 faa.pay_date as first_payment,
  		 current_timestamp as last_payment,
  		 case 
  		 	when faa.pay_date is null then 1
  		 	when extract(year from age(current_timestamp, faa.pay_date)) * 12 + extract(month from age(current_timestamp, faa.pay_date)) = 0 then 1
  		 	else extract(year from age(current_timestamp, faa.pay_date)) * 12 + extract(month from age(current_timestamp, faa.pay_date))
  		 end as months_between  
  		 from billing.charge_groups cg
  	left join billing.first_accrual_account faa on faa.account_id = cg.account_id
  	join billing.user_current_status ucs on ucs.core_user_id = cg.core_user_id 
  	where faa.pay_date < current_date and ucs.status in ('3', '4') and faa.pay_date > '2022-04-01'
  group by cg.account_id, faa.pay_date;
  
 select *
 		from bitrix.yandex_direct_ads yda 
 		where campaign_name = 'novosib_net_retargeting' and date <= '2022-03-31' and date >= '2022-02-01';
 		
 select *
 		from bitrix.yandex_direct_ads yda 
 		where campaign_name  = 'barnaul_brand_search'
 		and date <= '2022-05-31' and date >= '2022-05-01';
 		
truncate table bitrix.yandex_direct_ads;

with yd as (select yda.date,
				   case
					when yda.campaign_name = 'barnaul_obshie_search_master_campaig' then 'barnaul_obshie_master_campaign'
					when yda.campaign_name = 'biysk_obshie_search_master_campaig' then 'biysk_obshie_master_campaign'
					when yda.campaign_name = 'kemerovo_obshie_search_master_campaig' then 'kemer_obshie_master_campaign'
					when yda.campaign_name = 'krasnoyarsk_obshie_search_master_campaig' then 'krasn_obshie_master_campaign'
					when yda.campaign_name = 'novokuznetsk_obshie_search_master_campaig' then 'nvkz_obshie_master_campaign'
					when yda.campaign_name = 'novosib_obshie_search_master_campaig' then 'novosib_obshie_master_campaign'
				   else yda.campaign_name end,
				   yda.cities,
				   yda.sources_ac_name,
				   yda.impressions,
				   yda.clicks,
				   yda.cost_per_conversion,
				   yda.ctr / 100 as ctr,
				   yda.cost
				  from bitrix.yandex_direct_ads yda)
select yd.date,
	   yd.campaign_name,
	   array_to_string (yd.cities, ', ', null) as cities,
	   case  
	   	when array_to_string (yd.cities, ',', null) like '%Новосибирск%' or  array_to_string (yd.cities, ',', null) like '%Бердск%' then 'НСК'
	   	when array_to_string (yd.cities, ',', null) like '%Норильск%' or  array_to_string (yd.cities, ',', null) like '%Игарка%' then 'НРК'
	   	when array_to_string (yd.cities, ',', null) like '%Кемерово%' then 'КЕМ'
	   	when array_to_string (yd.cities, ',', null) like '%Бийск%' or  array_to_string (yd.cities, ',', null) like '%Барнаул%' then 'АЛТ'
	   	when array_to_string (yd.cities, ',', null) like '%Красноярск%' or  array_to_string (yd.cities, ',', null) like '%Дивногорск%' then 'КРС'
	   	when array_to_string (yd.cities, ',', null) like '%Новокузнецк%' or  array_to_string (yd.cities, ',', null) like '%Киселевск%' then 'НЗК'
	   end as brunch,
	   case
        when yd.sources_ac_name = 'None' then 'yandex.search'
        else yd.sources_ac_name
       end,
	   yd.impressions,
	   yd.clicks,
	   count(bi.id_bitrix) as leads,
	   yd.cost_per_conversion,
	   yd.ctr * 100 as ctr,
	   yd.cost
	  from yd
left join bitrix.issue bi on date(bi.create_date) = date(yd.date) and bi.utm_campaign = yd.campaign_name
group by yd.date, yd.campaign_name, yd.cities, yd.sources_ac_name, yd.impressions, yd.clicks, yd.cost_per_conversion, yd.ctr, yd.cost;


   with vk_ads as (select distinct van."date",
								van.campaigns_name as campaign_name,
								0 as cities,
								van.sources_ac_name,
								sum(van.impressions) as impressions,
								sum(van.clicks) as clicks,
								sum(van.spent) as cost
					  from bitrix.vk_ads_new van
				group by "date", campaigns_name, cities, sources_ac_name)
select vka."date",
	   vka.campaign_name,
	   case 
	   	when vka.campaign_name like '%Новосибирск%' or vka.campaign_name like '%Нск%' then 'Новосибирск'
	   	when vka.campaign_name like '%Красноярск%' then 'Красноярск'
	   	when vka.campaign_name like '%Норильск%' or vka.campaign_name like '%НОРКОМ%' or vka.campaign_name like '%норком%' then 'Норильск'
	   	when vka.campaign_name like '%Бийск%' then 'Бийск'
	   	when vka.campaign_name like '%Барнаул%' then 'Барнаул'
	   	when vka.campaign_name like '%Новокузнецк%' or vka.campaign_name like '%Нвкз%' or vka.campaign_name like '%НВКЗ%' then 'Новокузнецк'
	   	when vka.campaign_name like '%Кемерово%' then 'Кемерово'
	   	when vka.campaign_name like '%Игарка%' then 'Игарка'
	   	when vka.campaign_name like '%Анжеро-Судженск, Белово, Топки%' then 'Анжеро-Судженск, Белово, Топки'
	   	when vka.campaign_name like '%Ачинск, Зеленогорск, Минусинс, Назарово%' then 'Ачинск, Зеленогорск, Минусинс, Назарово'
	   	when vka.campaign_name like '%Алтай%' then 'Алтай'
	   	when vka.campaign_name like '%Дивногорск%' then 'Дивногорск'
	   	when vka.campaign_name like '%Киселевск%' then 'Киселевск'
	   	when vka.campaign_name like '%гор Лен-Куз., Берез., Юрга%' then 'Ленинск-Кузнецкий, Березовcкий, Юрга'
	   	when vka.campaign_name like '%Прокопьевск%' then 'Прокопьевск'
	   	when vka.campaign_name like '%Гор. Грамот. и Инской%' then 'Грамотеино, Инской'
	   end as cities,
	   case 
	   	when vka.campaign_name like '%Новосибирск%' or vka.campaign_name like '%Нск%' then 'НСК'
	   	when vka.campaign_name like '%Красноярск%' or vka.campaign_name like '%Ачинск, Зеленогорск, Минусинс, Назарово%' or vka.campaign_name like '%Дивногорск%' then 'КРС'
	   	when vka.campaign_name like '%Норильск%' or vka.campaign_name like '%НОРКОМ%' or vka.campaign_name like '%норком%' or vka.campaign_name like '%Игарка%' then 'НРК'
	   	when vka.campaign_name like '%Бийск%' or vka.campaign_name like '%Барнаул%'  or vka.campaign_name like '%Алтай%' then 'АЛТ'
	   	when vka.campaign_name like '%Новокузнецк%' or vka.campaign_name like '%Нвкз%' or vka.campaign_name like '%НВКЗ%' or vka.campaign_name like '%Прокопьевск%'  or vka.campaign_name like '%Киселевск%' then 'НЗК'
	    when vka.campaign_name like '%Кемерово%'  or vka.campaign_name like '%гор Лен-Куз., Берез., Юрга%' or vka.campaign_name like '%Гор. Грамот. и Инской%' or vka.campaign_name like '%Анжеро-Судженск, Белово, Топки%' then 'КЕМ'
	    end as brunch,
	   	vka.sources_ac_name,
	   vka.impressions,
	   vka.clicks,
	   count(bi.id_bitrix) as leads,
	   case 
	    when vka.clicks = 0 or vka.cost = 0 then 0
	    else round(vka.cost / vka.clicks, 2) 
	   end as cost_per_conversion,
	   case 
	    when vka.clicks = 0 or vka.impressions = 0 then 0
	    else vka.clicks / vka.impressions
	   end as ctr,
	   vka.cost
	  from vk_ads vka
left join bitrix.issue bi on date(bi.create_date) = date(vka.date) and bi.utm_campaign = vka.campaign_name
group by vka."date", vka.campaign_name, vka.cities, vka.sources_ac_name, vka.impressions, vka.clicks, vka.cost;


select ios.service_type_name, 
    from reports.influx_of_services ios 
  where order_type like '%роутер, продажа%' and service_type_name like '%Рассрочка%'
  left join terrasoft.contacts c on c.person_id = ios.person_id;
  
select na.id,
	   na.contact_name,
       na.phone,
       na.email,
       split_part(na.city, ' ', 1) as city_neab,
       na.street,
       na.house,
       na.flat,
       na.source,
       na.source_type_id,
       na.source_id,
       na.update_date,
       text(ic.code_1s) as code_1s
	from all_rubbish.ne_abonents na
left join reports.installed_capacity ic on ic.city = split_part(na.city, ' ', 1) and ic.house_name = concat (na.street, ', д.', na.house)
union all
select distinct tb.id,
				  tb.full_name as contact_name,
  				  tb.phone_number as phone,
  				  tb.email,
                  null as city_neab,
                  null as street,
                  null as house,
                  null as flat,
			  	  tb.source,
			  	  tb.source_type_id,
			  	  tb.source_id,
                  tb.update_date,
                  null as code_1s
			  from (select df.id,
					  	   df.full_name,
			  				case
					  			when df.phone_number like '8%'
					  				then regexp_replace(df.phone_number, '^8\.*', '7')
					  			when length(df.phone_number) = 1
					  				then null
			  					else df.phone_number
			  		 		end as phone_number,
			  		 		df.email,
			  		 		df.source,
			  		 		df.source_type_id,
			  		 		df.source_id, 
                            df.update_date
					  	from (select ac.id,
					  				 ac.full_name,
					  				case 
							  		 when ac.phone_number like '%whats%' or length(ac.phone_number) > 11 or length(ac.phone_number) <= 9
								  		then null 
								  	 when length(ac.phone_number) = 10 and ac.phone_number like '9%'
								  		then concat('7', ac.phone_number)
							  		 else ac.phone_number 
					  				end as phone_number,
					  				null as email,
					  				'amo_crm' as source,
					  				'amo_crm_id' as source_type_id,
					  				ac.id_amo as source_id,
					  				ac.updated_at as update_date
					  			from other_crm.amo_crm ac
					  				where not exists (select c.communication3 from terrasoft.contacts c
					  				where c.communication3 = ac.phone_number) and ac.phone_number is not null) as df
					  		where df.phone_number is not null) as tb
				  	where tb.phone_number is not null and tb.phone_number not like 'лий%' and extract(year from tb.update_date) != '1968';