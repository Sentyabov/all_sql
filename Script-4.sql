   
    
with module as (select 	c3.id,
						c3.person_name,
						c3.communication3,
						c3.city,
						c3.street,
						c3.house,
						c3.flat,
						c3.create_date 
					from terrasoft.contacts c3
				 where exists 
				 			(select * from (select df.id,
											 		df. person_name ,
											 		df.create_date,
													case 
														when df.phone1 like '+79%' and (char_length(ltrim (df.phone1, '+')) =15 or char_length(ltrim (df.phone1, '+')) =14 or char_length(ltrim (df.phone1, '+')) =13)
															then concat (split_part (ltrim (df.phone1, '+'), '-', 1), 
															     concat (split_part (ltrim (df.phone1, '+'), '-', 2),
															     concat (split_part (ltrim (df.phone1, '+'), '-', 3),
															     concat (split_part (ltrim (df.phone1, '+'), '-', 4),split_part (ltrim (df.phone1, '+'), '-', 5) ))))
														when df.phone1 like '+7_9%' and (char_length(ltrim (df.phone1, '+')) =15 or char_length(ltrim (df.phone1, '+')) =14 or char_length(ltrim (df.phone1, '+')) =13)
															then concat (split_part (ltrim (df.phone1, '+'), '-', 1), 
															     concat (split_part (ltrim (df.phone1, '+'), '-', 2),
															     concat (split_part (ltrim (df.phone1, '+'), '-', 3),
															     concat (split_part (ltrim (df.phone1, '+'), '-', 4),split_part (ltrim (df.phone1, '+'), '-', 5) ))))
														when df.phone1 like '8%' and (char_length(replace (substring(df.phone1, 1), '8', '7' )) =15 or char_length(replace (substring(df.phone1, 1), '8', '7' )) =14 or char_length(replace (substring(df.phone1, 1), '8', '7' )) =13)
															then concat (split_part (replace (substring(df.phone1, 1), '8', '7' ), '-', 1), 
																 concat (split_part (replace (substring(df.phone1, 1), '8', '7' ), '-', 2),
																 concat (split_part (replace (substring(df.phone1, 1), '8', '7' ), '-', 3),
																 concat (split_part (replace (substring(df.phone1, 1), '8', '7' ), '-', 4),split_part (replace (substring(df.phone1, 1), '8', '7' ), '-', 5) ))))
														when df.phone1 like '9%' and char_length(concat ('7', df.phone1)) =15 or char_length(concat ('7', df.phone1)) =14 or char_length(concat ('7', df.phone1)) =13 
															then concat (split_part (concat ('7', df.phone1), '-', 1), 
														     	 concat (split_part (concat ('7', df.phone1), '-', 2),
														     	 concat (split_part (concat ('7', df.phone1), '-', 3),
														     	 concat (split_part (concat ('7', df.phone1), '-', 4),split_part (concat ('7', df.phone1), '-', 5) ))))
														when df.phone1 like '+79%' and char_length(ltrim (df.phone1, '+')) >16 
															then btrim (ltrim (df.phone1, '+'), '��������������������������������- /\.,�����Ũ��������������������������()')
														when df.phone1 like '+7_9%' and char_length(ltrim (df.phone1, '+')) >16 
															then btrim (ltrim (df.phone1, '+'), '��������������������������������- /\.,�����Ũ��������������������������()')
														when df.phone1 like '8%' and char_length(replace (substring(df.phone1, 1), '8', '7' )) >16 
															then btrim (replace (substring(df.phone1, 1), '8', '7' ), '��������������������������������- /\.,�����Ũ��������������������������()')
														when df.phone1 like '9%' and char_length(concat ('7', df.phone1)) >16 
															then btrim (concat ('7', df.phone1), '��������������������������������- /\.,�����Ũ��������������������������()')
														when df.phone1 like '8%' then replace (substring(df.phone1, 1), '8', '7' )
														else df.phone1 
													end as phone
													from (
															select c. id, 
																	c.create_date,
																	case 
																		when person_name like'%1%' then null
																		when person_name like'%2%' then null 
																		when person_name like'%3%' then null
																		when person_name like'%4%' then null 
																		when person_name like'%5%' then null 
																		when person_name like'%6%' then null 
																		when person_name like'%7%' then null 
																		when person_name like'%8%' then null
																		when person_name like'%9%' then null 
																		else person_name
																	end as person_name,
																	case 
																		when communication3 is null
																		and (communication1 like '9%' or communication1 like '8_9%'
																			or communication1 like '89%' or communication1 like '79%'
																			or communication1 like '+79%' or communication1 like '+7_9%' )
																			then communication1
																		when communication3 is null
																		and (communication2 like '9%' or communication2 like '8_9%'
																			or communication2 like '89%' or communication2 like '79%'
																			or communication2 like '+79%' or communication2 like '+7_9%' )
																			then communication2
																		else communication3
																	end as phone1
															       from terrasoft.contacts c 
															 where person_id is NULL 
															   and contact_type_id != '47cbc6bb-d74e-4872-a488-75cc01122136' 
															   and create_date >= '2020-01-01') as df
															  where df.phone1 is not null
															   	and df.phone1 != ' '
															    and df.person_name not like '%���������%'
															    and df.person_name not like '%���������%'
															    and df.person_name not like '%���%'
															    and df.person_name not like '%��%'
															    and df.person_name not like '%���%'
															    and df.person_name not like '%���%'
															    and df.person_name not like '%������������%'
															    and df.person_name not like '%������������%'
															    and df.person_name not like '%����%'
															    and df.person_name not like '%�� ����%'
															    and df.person_name not like '%����������� ������� ���������%'
															    and char_length(df.person_name)>4) as ms
							where ms.phone = c3.communication3)
							  and c3.person_id is null
							  and c3.communication3 is not null)
	select m.person_name as contact_name,
		   m.communication3 as phone,
		   null as email,
		   case
		   when m.city is null then addr.city
		   else rtrim (m.city, ' �') 
		   end as city,
		   case
		   when m.street is null then rtrim (addr.street, '��')
		   else rtrim (m.street , '��')
		   end as street,
		   case
		   when m.house is null then addr.home
		   else m.house 
		   end as house,
		   case
		   when m.flat is null then addr.flat
		   else m.flat 
		   end as flat,
		   'terrasoft' as source,
		   m.id as source_id,
		   m.create_date 
		from module m
 left join (select distinct t.contact_id,
						case 
							when c2.city is not null and c2.street is not null and c2.house is not null then rtrim (c2.city, ' �')
							when t.type = '������ � �����' and t.title like '%�����%' 
								then substring (rtrim (split_part (t.title, ': ', 2), '�����') for position (' ' in rtrim (split_part (t.title, ': ', 2), '�����')) - 1)
							when t."type" = '������ �������' 
				  				then substring(substring(t.title from position('�����' in t.title) + 7) for position('�������' in substring(t.title from position('�����' in t.title) + 7)) - 4)
							else null
						end as city,
						case 
							when c2.city is not null and c2.street is not null and c2.house is not null then c2.street
							when t.type = '������ � �����' and t.title like '%�����%' 
								then substring (rtrim (split_part (t.title, ': ', 3), '����� ����') for char_length(rtrim (split_part (t.title, ': ', 3), '����� ����')) -3)
							when t."type" = '������ �������' 
				     			then substring(substring(t.title from position('�����' in t.title) + 6) for position(',' in substring(t.title from position('�����' in t.title) + 6)) - 1)
							else null
						end as street,
						case 
							when c2.city is not null and c2.street is not null and c2.house is not null then c2.house
							when t.type = '������ � �����' and t.title like '%�����%' and t.title like '%��� ���������%' 
								then rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('���' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4)))) 
							when t.type = '������ � �����' and t.title like '%�����%' and t.title not like '%��� ���������%' 
								then rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('��������' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4))))
							when t."type" = '������ �������' 
				     			then substring(substring(t.title from position(',' in t.title) + 2) for position(',' in substring(t.title from position(',' in t.title) + 2)) - 1)
							else null
						end as home,
						case 
							when c2.city is not null and c2.street is not null and c2.house is not null and c2.flat is not null then c2.flat
				     		when t."type" = '������ �������' 
				     			then substring(substring(t.title from position(' �. ' in t.title) + 4) for position('-' in substring(t.title from position(' �. ' in t.title) + 4)) - 1) 
				    		else null
				    	end as flat
						from terrasoft.task t
				 left join terrasoft.contacts c2 on c2.id = t.contact_id
				 where t.start_date>='2020-01-01') addr on addr.contact_id=m.id
  where m.city is not null or addr.city is not null
    
