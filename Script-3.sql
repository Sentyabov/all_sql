select distinct df.phone,
		df.contactid,
		df.person_id,
		df.city,
		df.street,
		df.house,
		df.flat,
		df.account_id,
		df.core_user_id
		from(select distinct cm.phone,
					   cm.contactid,
					   c.person_id,
					   c.city,
					   c.street,
					   c.house,
					   c.flat,
					   a.account_id,
					   u.core_user_id,
					   case 
					   	when ucs.status in ('3', '4') then true else false
					   end as status
						from all_rubbish.contacts_mssql cm
					left join terrasoft.contacts c on c.id = cm.contactid 
					left join billing.accounts a on a.person_id = c.person_id
					left join billing.users u on u.account_id = a.account_id
					left join billing.user_current_status ucs on ucs.core_user_id = u.core_user_id
				  where cm.contactid is not null
				  union 
				  select distinct cm.phone,
					   cm.contactid,
					   c.person_id,
					   c.city,
					   c.street,
					   c.house,
					   c.flat,
					   a.account_id,
					   u.core_user_id,
					   case 
					   	when ucs.status in ('3', '4') then true else false
					   end as status
						from all_rubbish.contacts_mssql cm
					left join terrasoft.contacts c on c.id = cm.contactid 
					left join billing.accounts a on a.person_id = c.person_id
					left join billing.users u on u.account_id = a.account_id
					left join billing.user_current_status ucs on ucs.core_user_id = u.core_user_id
  				where cm.contactid is null) as df
  			where df.status is false;
  
 with m as (select c.id,
 				   c.person_id, 
 				   a.account_id,
 				   ucs.core_user_id,
	   				case 
	   					when ucs.status in ('3', '4') then true else false
	   				end as status
 					from terrasoft.contacts c
 					left join billing.accounts a on a.person_id = c.person_id
 					left join billing.users u on u.account_id = a.account_id
					left join billing.user_current_status ucs on ucs.core_user_id = u.core_user_id)
select distinct cm.phone,
		cm.contactid,
		m.person_id,
		m.core_user_id,
		m.status
			from all_rubbish.contacts_mssql cm
		left join m on m.id = cm.contactid;