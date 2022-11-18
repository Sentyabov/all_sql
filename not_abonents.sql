truncate terrasoft.not_abonents;

drop table terrasoft.not_abonents;

create sequence terrasoft.not_abonents_id increment 1 start 1;

drop sequence terrasoft.not_abonents_id CASCADE;

CREATE TABLE terrasoft.not_abonents (
	id int8 NOT NULL DEFAULT nextval('terrasoft.not_abonents_id'::regclass),
	contact_name varchar(100) NULL,
	phone varchar(11) NOT NULL,
	email varchar(100) NULL,
	city varchar(50) NULL,
	street varchar(50) NULL,
	house varchar(20) NULL,
	flat varchar(20) NULL,
	"source" varchar(50) NULL,
	source_type_id varchar(50) NULL,
	source_id varchar(50) NULL,
	update_date date NULL,
	CONSTRAINT not_abonents_pkey PRIMARY KEY (id),
	unique(phone)
);

select *
		from terrasoft.not_abonents na
	where na.phone = '79231743216';
	
select distinct na.id,
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
	from terrasoft.not_abonents na
left join reports.installed_capacity ic on ic.city = split_part(na.city, ' ', 1) and ic.house_name = concat (na.street, ', д.', na.house);


with ts_phones as (select distinct case   
									 when left(ltrim(c.phone, '*'), 1) = '8' then concat('7', right(ltrim(c.phone, '*'), length(ltrim(c.phone, '*')) - 1))
								   else ltrim(c.phone, '*') end as phone
						  from terrasoft.incidents i
					inner join terrasoft.calls c on c.terrasoft_number = i.terrasoft_number and c.terrasoft_code = i.terrasoft_code and c.account_number is null
					 where i.terrasoft_code in ('727 Подключение ШПД+Телефония', '101-3 Потенциальный клиент ТТК', '705ф Заявка на подключение',
					'725 Подключение ШПД+КТВ', '732 Подключение ШПД+IPTV+Телефония', '729 Подключение ШПД(ADSL)', '722 Подключение ШПД+КТВ+Телефония',
					'724 Подключение ШПД(ADSL)+КТВ+Телефония', '728 Подключение ШПД(ADSL)+Телефония', '725-1 Подключение ШПД(ТТК)+КТВ',
					'730 Подключение ШПД+IPTV', '731 Подключение ШПД+IPTV+КТВ')
					   and i.account_id is null
					   and i.core_user_id is null
					   and i.account_number is null
					   and length(phone) = 11)
select tp.phone,
	   date(df.create_date),
	   df.utm_campaign as campaign_name,
	   df.utm_source as sources_ac_name,
	   case 
	    when df.utm_campaign like '%NSK%' or df.utm_campaign like '%nsk%' then 'Новосибирск'
	    when df.utm_campaign like '%Biysk%' then 'Бийск'
	    when df.utm_campaign like '%nvkz%' then 'Новокузнецк'
	    when df.utm_campaign like '%barnaul%' then 'Барнаул'
	    when df.city like '%barnaul%' then 'Барнаул'
	   	when df.city like '%krasnoyarsk%' then 'Красноярск'
	   	when df.city like '%iskitim%' then 'Искитим'
	   	when df.city like '%kemerovo%' then 'Кемерово'
	   	when df.city like '%berdsk%' then 'Бердск'
	   else df.city end as cities,
	    case  
	    when df.utm_campaign like '%NSK%' or df.utm_campaign like '%nsk%' then 'НСК'
	    when df.utm_campaign like '%Biysk%' then 'АЛТ'
	    when df.utm_campaign like '%nvkz%' then 'НЗК'
	    when df.utm_campaign like '%barnaul%' then 'АЛТ'
	   	when df.city like '%Новосибирск%' or  df.city like '%Бердск%' or  df.city like '%iskitim%' or  df.city like '%berdsk%' then 'НСК'
	   	when df.city like '%Норильск%' or df.city like '%Игарка%' then 'НРК'
	   	when df.city like '%Кемерово%' or df.city like '%Анжеро-Судженск%' or df.city like '%kemerovo%' then 'КЕМ'
	   	when df.city like '%Бийск%' or  df.city like '%Барнаул%' or  df.city like '%barnaul%' then 'АЛТ'
	   	when df.city like '%Красноярск%' or df.city like '%krasnoyarsk%' or df.city like '%Дивногорск%' or df.city like '%Ачинск%' then 'КРС'
	   	when df.city like '%Новокузнецк%' or df.city like '%Киселевск%' or df.city like '%Междуреченск%' or df.city like '%Прокопьевск%' then 'НЗК'
	   end as brunch,
       df.utm_term
	  from ts_phones tp
inner join (select bi.id_bitrix,
			      bi.active_time_begin,
			      bi.create_date,
			      bi.title,
			      bi.city,
			      bi.person_name,
			      regexp_replace(bi.phone_number, '[+() ]', '', 'g') as phone_number,
			      bi.landing_block,
			      bi.tariff_name,
			      bi.equipment,
			      bi.id_issue_211_ru,
			      bi.utm_campaign,
			      bi.utm_source,
			      bi.form_type,
			      bi.utm_content,
			      bi.utm_term
			     from bitrix.issue bi) df on df.phone_number = tp.phone
			     where df.utm_source like '%gis%' or df.utm_source like '%2%';
			  
select *
		from bitrix.issue i
	where i.utm_campaign like '%master%';