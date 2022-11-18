select c.communication3 as phone
		from terrasoft.contacts c 
	inner join billing.accounts a on a.person_id = c.person_id
	inner join billing.users u on u.account_id = a.account_id
	inner join billing.user_current_status ucs on ucs.core_user_id = u.core_user_id
  where c.communication3 is not null and ucs.status in (3, 4)