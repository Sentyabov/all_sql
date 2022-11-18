select cu.account_id,
                       cu.service_type, 
                       cu.id as core_user_id,
                       cu.service_sub_type,
                       cu.user_service_sub_type_id,
                       tch.new_tariff_id as tariff_id,
                       tch.new_tariff as tariff_name,
                       us.start_date,
                       u.id as web_user_id,
                       u.login as web_user_login,
                       u.name as web_user_name,
                       null as special_type,
                       null as service_type_id,
                       null as service_item_id,
                       null as service_type_name,
                       null as service_period
                        from (  select us_act.user_id,
                                       us_act.web_user_id,
                                       us_act.start_date
                                        from exchange.user_statuses_enddate us_act
                                 where us_act.status=3
                                   --and us_act.user_id>2500000 -- редактируемое поле (для оптимизации)
                                   and exists  (select us_new.*
                                                        from exchange.user_statuses_enddate us_new
                                                 where us_new.status=1
                                                   --and us_new.user_id>2500000 -- редактируемое поле (для оптимизации)
                                                   and us_new.user_id=us_act.user_id
                                                   and us_new.end_date=us_act.start_date)
                                                   and us_act.start_date>=(TRUNC(SYSDATE,'month') - INTERVAL '1' MONTH - INTERVAL '30' DAY)
                                                   and us_act.start_date<trunc(sysdate,'dd')
                                union all				   
                                select us_not_new.user_id,
                                       us_not_new.web_user_id,
                                       us_not_new.start_date
                                        from exchange.user_statuses_enddate us_not_new
                                   left join exchange.web_users_all u on u.type='Оператор' and u.id=us_not_new.web_user_id
                                  inner join (  select us_not_new.user_id,
                                                       min(us_not_new.start_date) as start_date
                                                        from exchange.user_statuses_enddate us_not_new
                                                 where exists  (select us_act.user_id
                                                                        from exchange.user_statuses_enddate us_act
                                                                 where us_act.status=3
                                                                   --and us_act.user_id>2500000 -- редактируемое поле (для оптимизации)
                                                                   and us_act.start_date>=(TRUNC(SYSDATE,'month') - INTERVAL '1' MONTH - INTERVAL '30' DAY)
                                                                   and us_act.start_date<trunc(sysdate,'dd')
                                                                   and us_act.user_id=us_not_new.user_id)
                                                   and not exists  (select us_new.user_id
                                                                            from exchange.user_statuses_enddate us_new
                                                                     where us_new.status=1
                                                                       --and us_new.user_id>2500000 -- редактируемое поле (для оптимизации)
                                                                       and us_new.user_id=us_not_new.user_id)
                                                  and us_not_new.status=3
                                                group by us_not_new.user_id
                                                having min(us_not_new.start_date)>=(TRUNC(SYSDATE,'month') - INTERVAL '1' MONTH - INTERVAL '30' DAY)
                                                   and min(us_not_new.start_date)<trunc(sysdate,'dd') ) us on us.user_id=us_not_new.user_id and us.start_date=us_not_new.start_date ) us
                  inner join exchange.core_users cu on cu.id=us.user_id
                  inner join exchange.tariff_changes_alltime tch on tch.user_id=us.user_id and tch.change_date<=us.start_date and (tch.end_date is null or tch.end_date>us.start_date)
                   left join exchange.web_users_all u on u.type='Оператор' and u.id=us.web_user_id
 
SELECT *
		FROM EXCHANGE.USER_STATUSES_ENDDATE use 
	WHERE USER_ID = 163;
	

WITH  ush_pdu AS (                                  
	 SELECT DISTINCT 
	 		ush_tmp.user_id,
	 		ush_tmp.service_id,
	       ush_tmp.service_item_id,
	       ush_tmp.service_status,
	       ush_tmp.install_date as start_date,
	       ush_tmp.end_date,
	       DENSE_RANK() over (partition by ush_tmp.service_item_id order by ush_tmp.service_item_status_id) as RANK,
	       DENSE_RANK() over (partition by ush_tmp.user_id, ush_tmp.SPECIAL_TYPE_ID order by ush_tmp.service_item_status_id) as SPECIAL_RANK,
	       ush_tmp.special_type_name,
           ush_tmp.service_name,
           ush_tmp.web_user_id
		from exchange.user_service_history ush_tmp
		INNER JOIN (
			SELECT 
					us.user_id, 
					us.START_DATE, 
					us.END_DATE
	            from exchange.user_statuses_enddate us
	         where us.status=3
	           and (us.end_date is null or us.end_date>(TRUNC(SYSDATE,'month') - INTERVAL '1' MONTH - INTERVAL '30' DAY))
	           and us.start_date<trunc(sysdate,'dd') 
        ) stop_cu ON stop_cu.user_id  = ush_tmp.user_id  AND (stop_cu.end_date is null or stop_cu.end_date>ush_tmp.install_date)
		WHERE ush_tmp.service_status=2
		AND ush_tmp.service_kind='периодическая'
		--AND ush_tmp.USER_ID in (100039107) 
		)  
 --ТУТ ОСНОВНАЯ ВСТАВКА  !!!
SELECT 					
		cu.account_id,
       cu.service_type,
       cu.id as core_user_id,
       cu.service_sub_type,
       cu.user_service_sub_type_id,
       tch.new_tariff_id as tariff_id,
       tch.new_tariff as tariff_name,
       ush.start_date,
       u.id as web_user_id,
       u.login as web_user_login,
       u.name as web_user_name,
       ush.special_type_name as special_type,
       ush.service_id as service_type_id,
       ush.service_item_id,
       ush.service_name as service_type_name,
       null as service_period
	from	(SELECT ush_l.*
				FROM ush_pdu ush_l
				LEFT JOIN ush_pdu ush_r ON ush_r.USER_ID = ush_l.USER_ID
				AND months_between(ush_l.start_date,ush_r.end_date)>=6
				and
				(
					(ush_r.service_id = ush_l.service_id 
					AND ush_r.service_item_id = ush_l.service_item_id
				    AND ush_r.RANK +1 = ush_l.RANK
				    AND ush_r.special_type_name <> 'IPTV')
				    OR 
				    (ush_r.special_type_name = 'IPTV'
				    AND ush_l.special_type_name = 'IPTV'
				    AND ush_r.SPECIAL_RANK +1 = ush_l.SPECIAL_RANK
				    )
			    )
			  WHERE 
			 ((((ush_l.RANK > 1 AND ush_r.RANK IS NOT null) OR ush_l.RANK = 1) AND ush_l.special_type_name <> 'IPTV')
			  	OR 
			(((ush_l.SPECIAL_RANK > 1 AND ush_r.SPECIAL_RANK IS NOT null) OR ush_l.SPECIAL_RANK = 1) AND ush_l.special_type_name = 'IPTV'))  
			and ush_l.start_date>=(TRUNC(SYSDATE,'month') - INTERVAL '1' MONTH - INTERVAL '30' DAY)
			and ush_l.start_date<trunc(sysdate,'dd')
			  )   ush
    inner join exchange.core_users cu on cu.id=ush.user_id
    inner join exchange.tariff_changes_alltime tch on tch.user_id=ush.user_id and tch.service_type=3 and tch.change_date<=ush.START_DATE and (tch.end_date is null or tch.end_date>ush.START_DATE)
    left join exchange.web_users_all u on u.type='Оператор' and u.id=ush.web_user_id;
    
 SELECT DISTINCT 
	 		ush_tmp.user_id,
	 		ush_tmp.service_id,
	       ush_tmp.service_item_id,
	       ush_tmp.service_status,
	       ush_tmp.install_date as start_date,
	       ush_tmp.end_date,
	       DENSE_RANK() over (partition by ush_tmp.service_item_id order by ush_tmp.service_item_status_id) as RANK,
	       DENSE_RANK() over (partition by ush_tmp.user_id, ush_tmp.SPECIAL_TYPE_ID order by ush_tmp.service_item_status_id) as SPECIAL_RANK,
	       ush_tmp.special_type_name,
           ush_tmp.service_name,
           ush_tmp.web_user_id
		from exchange.user_service_history ush_tmp
		INNER JOIN (
			SELECT 
					us.user_id, 
					us.START_DATE, 
					us.END_DATE
	            from exchange.user_statuses_enddate us
	         where us.status=3
	           and (us.end_date is null or us.end_date>(TRUNC(SYSDATE,'month') - INTERVAL '1' MONTH - INTERVAL '30' DAY))
	           and us.start_date<trunc(sysdate,'dd') 
        ) stop_cu ON stop_cu.user_id  = ush_tmp.user_id  AND (stop_cu.end_date is null or stop_cu.end_date>ush_tmp.install_date)
		WHERE ush_tmp.service_status=2
		AND ush_tmp.service_kind='периодическая';
		
		
select cu.account_id,
                       cu.service_type,
                       cu.id as core_user_id,
                       cu.service_sub_type,
                       cu.user_service_sub_type_id,
                       tch.new_tariff_id as tariff_id,
                       tch.new_tariff as tariff_name,
                       ush.install_date as start_date,
                       u.id as web_user_id,
                       u.login as web_user_login,
                       u.name as web_user_name,
                       ush.special_type_name as special_type,
                       ush.service_id as service_type_id,
                       ush.service_item_id,
                       ush.service_name as service_type_name,
                       null as service_period
                        from exchange.user_service_history ush
                  inner join exchange.core_users cu on cu.id=ush.user_id
                  inner join exchange.tariff_changes_alltime tch on tch.user_id=ush.user_id and tch.service_type=3 and tch.change_date<=ush.install_date and (tch.end_date is null or tch.end_date>ush.install_date)
                   left join exchange.web_users_all u on u.type='Оператор' and u.id=ush.web_user_id
                 where service_kind='разовая'
                   and install_date>=(TRUNC(SYSDATE,'month') - INTERVAL '1' MONTH - INTERVAL '30' DAY)
                   and install_date<trunc(sysdate,'dd');
                   
                  
                  
select ars.account_id,
                       5 as service_type,
                       null as core_user_id,
                       null as service_sub_type,
                       null as user_service_sub_type_id,
                       1000000857 as tariff_id,
                       null as tariff_name,
                       ars.service_item_status_start_date as start_date,
                       u.id as web_user_id,
                       u.login as web_user_login,
                       u.name as web_user_name,
                       ars.special_type_name as special_type,
                       ars.service_id as service_type_id,
                       ars.service_item_id,
                       ars.service_name as service_type_name,
                       1 as service_period
                        from exchange.account_recurrent_services ars
                   left join   (select ars_r.account_id,
                                       ars_r.service_id,
                                       ars_r.service_item_id,
                                       ars_r.service_item_status,
                                       ars_r.service_item_status_start_date as start_date,
                                       ars_r.service_item_status_end_date,
                                       rank() over (partition by ars_r.service_item_id order by ars_r.service_item_status_id desc) as rank
                                        from exchange.account_recurrent_services ars_r
                                 where ars_r.service_item_id in (select service_item_id
                                                                         from exchange.account_recurrent_services 
                                                                  where service_item_status=2
                                                                    and service_item_status_start_date>=(TRUNC(SYSDATE,'month') - INTERVAL '1' MONTH - INTERVAL '30' DAY)
                                                                    and service_item_status_start_date<trunc(sysdate,'dd')) ) ars_p on ars_p.account_id=ars.account_id and ars_p.service_item_id=ars.service_item_id and ars_p.rank=2
                   left join exchange.web_users_all u on u.type='Оператор' and u.id=ars.web_user_id
                 where ars.service_item_status=2
                   and ars.service_item_status_start_date>=(TRUNC(SYSDATE,'month') - INTERVAL '1' MONTH - INTERVAL '30' DAY)
                   and ars.service_item_status_start_date<trunc(sysdate,'dd')
                   and ( (ars_p.start_date is null
                          or (ars_p.service_item_status=ars.service_item_status and ars_p.start_date=ars.service_item_status_start_date))
                          or (ars_p.service_item_status<>ars.service_item_status and months_between(ars.service_item_status_start_date,ars_p.start_date)>=6) );
                         
                         
                         
select ans.account_id,
                       5 as service_type,
                       null as core_user_id,
                       null as service_sub_type,
                       null as user_service_sub_type_id,
                       1000000857 as tariff_id,
                       null as tariff_name,
                       ans.start_date,
                       ans.web_user_id,
                       u.login as web_user_login,
                       u.name as web_user_name,
                       ans.service_special_type_name as special_type,
                       ans.service_type_id as service_type_id,
                       ans.service_id as service_item_id,
                       ans.service_type as service_type_name,
                       0 as service_period
                        from exchange.nonrecurrent_services ans
                   left join exchange.web_users_all u on u.type='Оператор' and u.id=ans.web_user_id
                 where ans.start_date>=(TRUNC(SYSDATE,'month') - INTERVAL '1' MONTH - INTERVAL '30' DAY)
                   and ans.start_date<trunc(sysdate,'dd')
                          
select sp.tariff_id,
		      sp.service_type_id,
		     'Pack' as auto_on
                       from exchange.service_pricelists sp
			    where sp.auto_on=1
				  and sp.start_date<=sysdate and (sp.end_date is null or sp.end_date>sysdate)
				  
				  
select id as tariff_id,
                      service_type as service_type_tariff
                       from exchange.tariffs