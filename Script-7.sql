select *
		from public.armor_accounts aa
	where aa.account_number = '2000000075011';
	

select  aa.account_number,
                           ao.created_at,
                           ao.ended_at,
                           ao.state
                            from public.armor_accounts aa
                        left join armor_orders ao on ao.account_id = aa.id
                      where ao.created_at is not null and aa.account_number = '2000000075011';