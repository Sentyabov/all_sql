select ia.filial,
	   ia.ip_address,
	   iacg.channel_name,
	   icg.genre,
	   sum(ia.count_connections) as cumulate_connections
		from iptv_cache.iptv_activities ia
	left join iptv_cache.iptv_activities_channel_group iacg on iacg.id = ia.channel_group_id
	left join iptv_cache.iptv_channels_genres icg on icg.channel_address = iacg.channel_ip
	left join iptv_cache.test t on t.channel_ip = iacg.channel_ip
	where ia.start_date = '2022-06-01'
  group by ia.filial, ia.ip_address, iacg.channel_name, icg.genre;
  
 
 select ia.filial,
	   ia.ip_address,
	   icg.genre, 
	   sum(ia.count_connections)
		from iptv_cache.iptv_activities ia
	left join iptv_cache.iptv_activities_channel_group iacg on iacg.id = ia.channel_group_id
	left join iptv_cache.iptv_channels_genres icg on icg.channel_address = iacg.channel_ip
	left join iptv_cache.test t on t.channel_ip = iacg.channel_ip
	where ia.start_date = '2022-06-01'
  group by ia.filial, ia.ip_address, icg.genre;
  
 
 select concat(split_part(replace(replace(replace(replace(replace(ios.service_type_name, 'Приставка ', ''), 'Аренда приставки', ''), 'Цифровой ресивер', ''), 'Комплект ', ''), 'Аренда б/у приставки', ''), ' ', 2)
 		, ' ', split_part(replace(replace(replace(replace(replace(ios.service_type_name, 'Приставка ', ''), 'Аренда приставки', ''), 'Цифровой ресивер', ''), 'Комплект ', ''), 'Аренда б/у приставки', ''), ' ', 3)) as model,
 		ios.service_type_name, 
 		replace(replace(replace(replace(replace(ios.service_type_name, 'Приставка', ''), 'Аренда приставки', ''), 'Цифровой ресивер', ''), 'Комплект', ''), 'Аренда б/у приставки', ''),
 		ios.order_type,
 		'Приставка' as equipment,
 		case 
 			when ios.order_type like '%аренда%' then true else false
 		end as rent,
 		case 
 			when ios.order_type like '%продажа%' and ios.service_type_name not like '%Рассрочка%' then true else false
 		end as sale,
 		case 
 			when ios.order_type like '%продажа%' and ios.service_type_name like '%Рассрочка%' then true else false
 		end as installment_plan
 		from reports.influx_of_services ios 
 	where ios.order_type like '%Оборудование, приставка%' and (ios.service_type_name not like '%пульт%' or ios.service_type_name not like '%Пульт%') and (ios.service_type_name like '%Eltex%' or ios.service_type_name like '%HI BOX%'
 	or ios.service_type_name like '%Эфир HD%' or ios.service_type_name like '%NAG%');
 	
 select count(distinct ia.ip_address)
 		from iptv_cache.iptv_activities ia 
 		
 select distinct on(pv.vk_id) pv.*
 		from static.parsing_vk pv 
 	where pv.logic_union = 'группы на парсинг микрорайоны';
 	
 
 select *
 		from apps.sibseti_authlog sa 
 	where sa.phone_number = '79134524403'
 	
 select distinct on (account_number) *
 		from apps.readtv_accounts ra;
 		
select resource as source,
	   pnps.create_date,
	   pnps.score,
	   pnps.account_number,
	   bac.base_company_id,
	   null as source_name,
	   null as task_name,
	   pnps.comment
		from orders.net_promoter_score_passport pnps
   left join billing.accounts bac on bac.account_number=pnps.account_number;
   
  
select 'IVR' as source,
	   onps.create_date,
	   onps.score,
	   onps.account_number,
	   bac.base_company_id,
	   onps.source_name,
	   onps.task_name,
	   null as comment
		from oktell.net_promoter_score_oktell onps
   left join billing.accounts bac on bac.account_number=onps.account_number;
   
   
 select 'IPTV' as source,
	   tnps.create_date,
	   tnps.score,
	   tnps.account_number,
	   bac.base_company_id,
	   null as source_name,
	   null as task_name,
	   null as comment
		from orders.net_promoter_score_tvoffer tnps
   left join billing.accounts bac on bac.account_number=tnps.account_number;
   
  
  
  select create_date,
	   score,
	   sourcename,
	   task_name,
	   account_number,
	   base_company_id,
	   case when account_number like '1%' or task_name like '%B2B%' then 'company' else 'person' end as client_type
		from oktell.customer_satisfaction_index;
		
	
insert into zip_services.qlik_genesis_passwords values 
()