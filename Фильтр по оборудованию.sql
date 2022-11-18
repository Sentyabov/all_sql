select df.account_number,
	   case 
		   when df.split like '%Tp-Link-WR850N%' then 'TP-Link-WR850N'
		   when df.split like '%TP-Link Archer C5%' then 'TP-Link Archer C5'
		   when df.split like '%Tp-Link TL-WR841N%' then 'TP-Link TL-WR841N'
		   when df.split like '%Tp-Link Archer с20%' then 'TP-Link Archer C20'
		   when df.split like '%Tp-Link Archer C20%' then 'TP-Link Archer C20'
		   when df.split like '%TP-Link RE200%' then 'TP-Link RE200'
		   when df.split like '%Tp-Link Archer С20%' then 'TP-Link Archer C20'
		   when df.split like '%Tp-Link Archer c20%' then 'TP-Link Archer C20'
			else split
	   end as model,
	   case 
		   when df.service_type_name like '%Рассрочка%' or df.service_type_name like '%рассрочка%'
		   then 1 else 0
	   end as installment_plan,
	   df.service_type_name
		from (select ios.account_number,
					case
						when ios.service_type_name like '%Wi-Fi%' and ios.service_type_name like '%руб%' and ios.service_type_name like '%D-link%'
						and (position('руб' in ios.service_type_name) - position('Wi-Fi' in ios.service_type_name)) > 0
						then concat(split_part(substring(service_type_name from position('Wi-Fi' in service_type_name) 
							for position('руб' in ios.service_type_name) - position('Wi-Fi' in ios.service_type_name)), ' ', 3), ' ', 
							split_part(substring(service_type_name from position('Wi-Fi' in service_type_name) 
							for position('руб' in ios.service_type_name) - position('Wi-Fi' in ios.service_type_name)), ' ', 4)) 
						when ios.service_type_name like '%Wi-Fi%' and ios.service_type_name like '%руб%' and (ios.service_type_name like '%Tp-link%' or 
						ios.service_type_name like '%Tp-Link%' or ios.service_type_name like '%TP-Link%' or ios.service_type_name like '%TP-LINK%') and 
						(position('руб' in ios.service_type_name) - position('Wi-Fi' in ios.service_type_name)) > 0
						then concat(split_part(substring(service_type_name from position('Wi-Fi' in service_type_name) 
							for position('руб' in ios.service_type_name) - position('Wi-Fi' in ios.service_type_name)), ' ', 3), ' ', 
							split_part(substring(service_type_name from position('Wi-Fi' in service_type_name) 
							for position('руб' in ios.service_type_name) - position('Wi-Fi' in ios.service_type_name)), ' ', 4), ' ',
							split_part(substring(service_type_name from position('Wi-Fi' in service_type_name) 
							for position('руб' in ios.service_type_name) - position('Wi-Fi' in ios.service_type_name)), ' ', 5)) 
						else null
					end as split,
					ios.service_type_name 
					from reports.influx_of_services ios 
				where ios.order_type like '%Оборудование, роутер, продажа%') as df;

select service_type_name
		from reports.influx_of_services ios 
	where ios.order_type like '%Оборудование, роутер, продажа%';
	
select ia.*,
	   iac.channel_name
		from es_iptv_cache.iptv_activities ia
	left join es_iptv_cache.iptv_activities_channel iac on iac.id = ia.channel_id
	where ia.ip_address = '10.104.196.140';

select *
		from es_iptv_cache.iptv_activities_channel iac
		left join es_iptv_cache.test t on lower(replace(replace(replace(t.channel_name, '_', ' '), '-', ' '), ' ', '')) = lower(replace(replace(replace(iac.channel_name, '_', ' '), '-', ' '), ' ', ''));
	
select *
		from es_iptv_cache.iptv_activities_channel iac 
	where iac.channel_name like '%Nat%';

select distinct on (channel_ip) channel_ip
		from es_iptv_cache.test t; 

select ia.channel_id,
	   iac.channel_name,
		count(ia.channel_id)
		from es_iptv_cache.iptv_activities ia
		left join es_iptv_cache.iptv_activities_channel iac on iac.id = ia.channel_id 
	group by ia.channel_id; 