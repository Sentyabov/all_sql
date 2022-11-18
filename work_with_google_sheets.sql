select count(vk_id)
		from (select distinct on(pv.vk_id) pv.vk_id
					from "static".parsing_vk pv) as b

create table terrasoft.contacts_mssql(
	phone varchar(11) NOT NULL,
	contactid uuid NULL
)

insert into terrasoft.contacts_mssql select * from all_rubbish.contacts_mssql; 

truncate terrasoft.contacts_mssql;

CREATE TABLE all_rubbish.vk_test (
	sources_ac_name varchar(250) NULL,
	ads_name varchar(250) NULL,
	campaigns_name varchar(250) NULL,
	"date" timestamp NULL,
	spent numeric(10, 2) NULL,
	impressions numeric(10, 2) NULL,
	clicks numeric(10, 2) NULL,
	ctr numeric(10, 2) null,
	utm_campaign varchar(50) null
);

drop table all_rubbish.vk_test;

truncate table all_rubbish.vk_test;

CREATE TABLE bitrix.vk_ads_new (
	sources_ac_name varchar(250) NULL,
	ads_name varchar(250) NULL,
	campaigns_name varchar(250) NULL,
	"date" timestamp NULL,
	spent numeric(10, 2) NULL,
	impressions numeric(10, 2) NULL,
	clicks numeric(10, 2) NULL,
	ctr numeric(10, 2) NULL,
	utm_campaign varchar(50) NULL
);