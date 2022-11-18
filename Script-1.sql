select *
    from location_address_accesses_daytime laad
 where address_access_id='b8a65b99-f05f-4c9f-bdad-6454dc7d6d63'; 


with a1 as (select laad.time_from, laad.time_to, laad.address_access_id from location_address_accesses_daytime laad 
			where laad.day_week = 0),
 	 a2 as (select laad.time_from, laad.time_to, laad.address_access_id from location_address_accesses_daytime laad 
 	 		where laad.day_week = 1),
 	 a3 as (select laad.time_from, laad.time_to, laad.address_access_id from location_address_accesses_daytime laad 
			where laad.day_week = 2),
 	 a4 as (select laad.time_from, laad.time_to, laad.address_access_id from location_address_accesses_daytime laad 
 	 		where laad.day_week = 3),
 	 a5 as (select laad.time_from, laad.time_to, laad.address_access_id from location_address_accesses_daytime laad 
			where laad.day_week = 4),
 	 a6 as (select laad.time_from, laad.time_to, laad.address_access_id from location_address_accesses_daytime laad 
 	 		where laad.day_week = 5),
 	 a7 as (select laad.time_from, laad.time_to, laad.address_access_id from location_address_accesses_daytime laad 
			where laad.day_week = 6)
select laa.name,
     laa.address,
     laa.email,
     laa.is_send_email,
     laa.phone,
     laa.is_call_before_day,
     laa.call_in_hour,
     laa.call_time_from,
     laa.call_time_to, 
     a1.time_from::time as monday_from,
     a1.time_to::time as monday_to,
     a2.time_from::time as tuesday_from,
     a2.time_to::time as tuesday_to,
     a3.time_from::time as wednesday_from,
     a3.time_to::time as wednesday_to,
     a4.time_from::time as thursday_from,
     a4.time_to::time as thursday_to,
     a5.time_from::time as friday_from,
     a5.time_to::time as friday_to,
     a6.time_from::time as saturday_from,
     a6.time_to::time as saturday_to,
     a7.time_from::time as sunday_from,
     a7.time_to::time as sunday_to
    from location_address_accesses laa
    left join a1 on a1.address_access_id = laa.id
 	left join a2 on a2.address_access_id = laa.id
 	left join a3 on a3.address_access_id = laa.id
 	left join a4 on a4.address_access_id = laa.id
 	left join a5 on a5.address_access_id = laa.id
 	left join a6 on a6.address_access_id = laa.id
 	left join a7 on a7.address_access_id = laa.id;
 	
 
with a1 as (select laad.address_access_id, string_agg(to_char(laad.time_from::time,'hh24:mi:ss')||' - '||to_char(laad.time_to::time,'hh24:mi:ss'),'; ') as interval_time from location_address_accesses_daytime laad  where laad.day_week = 0 group by 1),
     a2 as (select laad.address_access_id, string_agg(to_char(laad.time_from::time,'hh24:mi:ss')||' - '||to_char(laad.time_to::time,'hh24:mi:ss'),'; ') as interval_time from location_address_accesses_daytime laad  where laad.day_week = 1 group by 1),
     a3 as (select laad.address_access_id, string_agg(to_char(laad.time_from::time,'hh24:mi:ss')||' - '||to_char(laad.time_to::time,'hh24:mi:ss'),'; ') as interval_time from location_address_accesses_daytime laad  where laad.day_week = 2 group by 1),
     a4 as (select laad.address_access_id, string_agg(to_char(laad.time_from::time,'hh24:mi:ss')||' - '||to_char(laad.time_to::time,'hh24:mi:ss'),'; ') as interval_time from location_address_accesses_daytime laad  where laad.day_week = 3 group by 1),
     a5 as (select laad.address_access_id, string_agg(to_char(laad.time_from::time,'hh24:mi:ss')||' - '||to_char(laad.time_to::time,'hh24:mi:ss'),'; ') as interval_time from location_address_accesses_daytime laad  where laad.day_week = 4 group by 1),
     a6 as (select laad.address_access_id, string_agg(to_char(laad.time_from::time,'hh24:mi:ss')||' - '||to_char(laad.time_to::time,'hh24:mi:ss'),'; ') as interval_time from location_address_accesses_daytime laad  where laad.day_week = 5 group by 1),
     a7 as (select laad.address_access_id, string_agg(to_char(laad.time_from::time,'hh24:mi:ss')||' - '||to_char(laad.time_to::time,'hh24:mi:ss'),'; ') as interval_time from location_address_accesses_daytime laad  where laad.day_week = 6 group by 1)
select laa.id,
       laa.name,   
       laa.address,
       laa.email,
       laa.is_send_email,
       laa.phone,
       laa.is_call_before_day,
       laa.call_in_hour,
       laa.call_time_from,
       laa.call_time_to, 
       a1.interval_time as monday_from,
       a2.interval_time as tuesday_from,
       a3.interval_time as wednesday_from,
       a4.interval_time as thursday_from,
       a5.interval_time as friday_from,
       a6.interval_time as saturday_from,
       a7.interval_time as sunday_from
        from location_address_accesses laa
   left join a1 on a1.address_access_id = laa.id
   left join a2 on a2.address_access_id = laa.id
   left join a3 on a3.address_access_id = laa.id
   left join a4 on a4.address_access_id = laa.id
   left join a5 on a5.address_access_id = laa.id
   left join a6 on a6.address_access_id = laa.id
   left join a7 on a7.address_access_id = laa.id;
   
select laad.address_access_id, string_agg(laad.time_from::time||' - '||laad.time_to::time,', ') as interval_time from location_address_accesses_daytime laad  where laad.day_week = 0 group by 1;


select laad.address_access_id,
	   string_agg(to_char(laad.time_from::time,'hh24:mi:ss')' - '||to_char(laad.time_to::time,'hh24:mi:ss'),', ') as test
from location_address_accesses_daytime laad
  where laad.day_week = 6
  
 select *
 		from location_address_accesses_daytime laad 
 	where laad.address_access_id = 'd3d71cd7-7be8-4c5d-a08c-3c427aac984e';
  