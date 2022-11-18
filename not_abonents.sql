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
left join reports.installed_capacity ic on ic.city = split_part(na.city, ' ', 1) and ic.house_name = concat (na.street, ', �.', na.house);


with ts_phones as (select distinct case   
									 when left(ltrim(c.phone, '*'), 1) = '8' then concat('7', right(ltrim(c.phone, '*'), length(ltrim(c.phone, '*')) - 1))
								   else ltrim(c.phone, '*') end as phone
						  from terrasoft.incidents i
					inner join terrasoft.calls c on c.terrasoft_number = i.terrasoft_number and c.terrasoft_code = i.terrasoft_code and c.account_number is null
					 where i.terrasoft_code in ('727 ����������� ���+���������', '101-3 ������������� ������ ���', '705� ������ �� �����������',
					'725 ����������� ���+���', '732 ����������� ���+IPTV+���������', '729 ����������� ���(ADSL)', '722 ����������� ���+���+���������',
					'724 ����������� ���(ADSL)+���+���������', '728 ����������� ���(ADSL)+���������', '725-1 ����������� ���(���)+���',
					'730 ����������� ���+IPTV', '731 ����������� ���+IPTV+���')
					   and i.account_id is null
					   and i.core_user_id is null
					   and i.account_number is null
					   and length(phone) = 11)
select tp.phone,
	   date(df.create_date),
	   df.utm_campaign as campaign_name,
	   df.utm_source as sources_ac_name,
	   case 
	    when df.utm_campaign like '%NSK%' or df.utm_campaign like '%nsk%' then '�����������'
	    when df.utm_campaign like '%Biysk%' then '�����'
	    when df.utm_campaign like '%nvkz%' then '�����������'
	    when df.utm_campaign like '%barnaul%' then '�������'
	    when df.city like '%barnaul%' then '�������'
	   	when df.city like '%krasnoyarsk%' then '����������'
	   	when df.city like '%iskitim%' then '�������'
	   	when df.city like '%kemerovo%' then '��������'
	   	when df.city like '%berdsk%' then '������'
	   else df.city end as cities,
	    case  
	    when df.utm_campaign like '%NSK%' or df.utm_campaign like '%nsk%' then '���'
	    when df.utm_campaign like '%Biysk%' then '���'
	    when df.utm_campaign like '%nvkz%' then '���'
	    when df.utm_campaign like '%barnaul%' then '���'
	   	when df.city like '%�����������%' or  df.city like '%������%' or  df.city like '%iskitim%' or  df.city like '%berdsk%' then '���'
	   	when df.city like '%��������%' or df.city like '%������%' then '���'
	   	when df.city like '%��������%' or df.city like '%������-��������%' or df.city like '%kemerovo%' then '���'
	   	when df.city like '%�����%' or  df.city like '%�������%' or  df.city like '%barnaul%' then '���'
	   	when df.city like '%����������%' or df.city like '%krasnoyarsk%' or df.city like '%����������%' or df.city like '%������%' then '���'
	   	when df.city like '%�����������%' or df.city like '%���������%' or df.city like '%������������%' or df.city like '%�����������%' then '���'
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