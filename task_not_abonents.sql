with module as (select 	c3.id,
						c3.person_name,
						c3.communication3,
						c3.city,
						c3.street,
						c3.house,
						c3.flat,
						c3.update_date 
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
															   and contact_type_id != '47cbc6bb-d74e-4872-a488-75cc01122136' ) as df
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
							  and c3.communication3 is not null
							  and length (c3.communication3) = 11)
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
		   'contact_id' as source_type_id,
		   m.id::varchar as source_id,
		   m.update_date
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
				 left join terrasoft.contacts c2 on c2.id = t.contact_id) addr on addr.contact_id=m.id
  where m.city is not null or addr.city is not NULL
union
select null as contact_name,
                df.contact_id,
				df.phone,
	   			null as email,
				df.city,
				df.street,
				df.house,
				df.flat as flat,
				'terrasoft' as source,
				'task_id' as source_type_id,
				df.id as source_id,
				df.update_date 
	  from (select substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\-\w+)\s(�\M|��|���),') as city,
			       case
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��\M') is not null
			    		   then substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��\M')
			    	   when substring(replace(t.title, ',,', ',') from '\s\(\w+\s�-�\)\s��') is not null
			    		   then substring(replace(t.title, ',,', ',') from '(\w+|\w+\s\w+)\s\(\w+\s�-�\)')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s���') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s���'), ' ���')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��-��') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+|\w+\s\w+\s\w+\s\w+)\s��-��'), ' ��-��')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s���\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s���\M'), ' ���')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s������') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s������'), ' ������')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�-�') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�-�'), ' �-�')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�����') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�����'), ' �����')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��\M'), ' ��')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��-�') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��-�'), ' ��-�')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�\M'), ' �')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s���\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+|\w+\-\w+\s\w+\s\w+\s\w+?)\s���\M'), ' ���')
			       end as street,
			       substring(replace(t.title, ',,', ',') from '�\.\s(\w+|\w+\/\w+)') as house,
			       substring(replace(t.title, ',,', ',') from '\s��\.\s(\d+)|\s��\.(\d+)') as flat,
			       substring(t.title from '79\d\d\d\d\d\d\d\d\d') as phone,
			       t.update_date,
			       t.id,
			       t.contact_id,
			       rank () over (partition by substring(t.title from '79\d\d\d\d\d\d\d\d\d') order by t.update_date desc) as rank
				  from terrasoft.task t
			 where t."type" = '�������� �� ��������'
			   and t.contact_id is null
			   and t.account_id is null
			   and t.title like '%�������� �� �������%'
			   and t.title like '%6_____,%') df
left join terrasoft.contacts c on c.communication3 = df.phone
 where df.city is not null
   and df.street is not null
   and df.house is not null
   and c.person_id is null
   and df.rank = 1
   and length(df.flat) < 5
union
select distinct df.contact_id,
	  md5(df.phone()::text || clock_timestamp()::text)::uuid AS new_id,
      null as contact_name, 
	  df.phone, 
	  null as email, 
	  df.city, 
	  df.street, 
	  df.house, 
	  null as flat, 
	  'terrasoft' as source, 
	  'task_id' as source_type_id, 
	  df.id as source_id, 
	  df.update_date 
    from( 
      select t.title, 
         case  
         when t.type = '������ � �����' and t.title like '%������� ������ �� ����������� �� �������� �������� ������ �����������%' 
          then substring (t.title, position ('�����: ' in t.title) + 7, position ('�����:' in t.title) - position ('�����: ' in t.title) - 8) 
         end as city, 
         case  
         when t.type = '������ � �����' and t.title like '%������� ������ �� ����������� �� �������� �������� ������ �����������%' 
          then rtrim(substring(t.title, position ('�����: ' in t.title) + 7, position ('����� ����: ' in t.title) - position ('�����: ' in t.title) - 9), ' ��\n') 
         end as street, 
         case  
         when t.type = '������ � �����' and t.title like '%�����%' and t.title like '%��� ���������%'  
          then rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('���' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4))))  
         when t.type = '������ � �����' and t.title like '%�����%' and t.title not like '%��� ���������%'  
           then rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('��������' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4)))) 
         end as house, 
         case  
         when t.type = '������ � �����' and t.title like '%������� ������ �� ����������� �� �������� �������� ������ �����������%' 
          then substring (t.title, position ('�������: ' in t.title) + 10, position ('����: ' in t.title) - position ('�������: ' in t.title) - 14) 
         end as phone, 
         t.update_date, 
         rank () over (partition by substring (t.title, position ('�������: ' in t.title) + 10, position ('����: ' in t.title) - position ('�������: ' in t.title) - 14) order by t.update_date desc) as rank, 
         t.id,
         t.contact_id 
          from terrasoft.task t  
      where t.type = '������ � �����'  
        and t.title like '%������� ������ �� ����������� �� �������� �������� ������ �����������%'  
        and t.account_id is null  
        and t.core_user_id is null  
        and t.contact_id is null  
        and substring (t.title, position ('�����: ' in t.title) + 7, position ('�����:' in t.title) - position ('�����: ' in t.title) - 8) is not null 
        and substring (t.title, position ('�����: ' in t.title) + 7, position ('����� ����: ' in t.title) - position ('�����: ' in t.title) - 10) not like '' 
        and rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('���' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4)))) not like '') df 
        left join terrasoft.contacts c on c.communication3 = df.phone
        where c.person_id is null
        and rank = 1
        and length(df.street) < 51;
    
 select *
 		from terrasoft.task 
 	where contact_id is null;
 	

select  distinct af.contact_name,
		af.phone,
		af.email,
		af.city,
		af.street,
		af.house,
		af.flat,
		af.source,
		af.source_type_id,
		af.source_id,
		af.update_date
		from (with module as (select 	c3.id,
						c3.person_name,
						c3.communication3,
						c3.city,
						c3.street,
						c3.house,
						c3.flat,
						c3.update_date 
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
															   and contact_type_id != '47cbc6bb-d74e-4872-a488-75cc01122136') as df
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
							  and c3.communication3 is not null
							  and length (c3.communication3) = 11)
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
		   'contact_id' as source_type_id,
		   m.id::varchar as source_id,
		   m.update_date
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
				 left join terrasoft.contacts c2 on c2.id = t.contact_id) addr on addr.contact_id=m.id
  where m.city is not null or addr.city is not NULL
union
select null as contact_name,
				df.phone,
	   			null as email,
				df.city,
				df.street,
				df.house,
				df.flat as flat,
				'terrasoft' as source,
				'task_id' as source_type_id,
				df.id as source_id,
				df.update_date 
	  from (select substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\-\w+)\s(�\M|��|���),') as city,
			       case
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��\M') is not null
			    		   then substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��\M')
			    	   when substring(replace(t.title, ',,', ',') from '\s\(\w+\s�-�\)\s��') is not null
			    		   then substring(replace(t.title, ',,', ',') from '(\w+|\w+\s\w+)\s\(\w+\s�-�\)')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s���') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s���'), ' ���')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��-��') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+|\w+\s\w+\s\w+\s\w+)\s��-��'), ' ��-��')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s���\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s���\M'), ' ���')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s������') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s������'), ' ������')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�-�') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�-�'), ' �-�')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�����') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�����'), ' �����')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��\M'), ' ��')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��-�') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s��-�'), ' ��-�')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s�\M'), ' �')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\s���\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+|\w+\-\w+\s\w+\s\w+\s\w+?)\s���\M'), ' ���')
			       end as street,
			       substring(replace(t.title, ',,', ',') from '�\.\s(\w+|\w+\/\w+)') as house,
			       substring(replace(t.title, ',,', ',') from '\s��\.\s(\d+)|\s��\.(\d+)') as flat,
			       substring(t.title from '79\d\d\d\d\d\d\d\d\d') as phone,
			       t.update_date,
			       t.id,
			       rank () over (partition by substring(t.title from '79\d\d\d\d\d\d\d\d\d') order by t.update_date desc) as rank
				  from terrasoft.task t
			 where t."type" = '�������� �� ��������'
			   and t.contact_id is null
			   and t.account_id is null
			   and t.title like '%�������� �� �������%'
			   and t.title like '%6_____,%') df
left join terrasoft.contacts c on c.communication3 = df.phone
 where df.city is not null
   and df.street is not null
   and df.house is not null
   and c.person_id is null
   and df.rank = 1
   and length(df.flat) < 5
union
select distinct null as contact_name, 
	  df.phone, 
	  null as email, 
	  df.city, 
	  df.street, 
	  df.house, 
	  null as flat, 
	  'terrasoft' as source, 
	  'task_id' as source_type_id, 
	  df.id as source_id, 
	  df.update_date 
    from( 
      select t.title, 
         case  
         when t.type = '������ � �����' and t.title like '%������� ������ �� ����������� �� �������� �������� ������ �����������%' 
          then substring (t.title, position ('�����: ' in t.title) + 7, position ('�����:' in t.title) - position ('�����: ' in t.title) - 8) 
         end as city, 
         case  
         when t.type = '������ � �����' and t.title like '%������� ������ �� ����������� �� �������� �������� ������ �����������%' 
          then rtrim(substring(t.title, position ('�����: ' in t.title) + 7, position ('����� ����: ' in t.title) - position ('�����: ' in t.title) - 9), ' ��\n') 
         end as street, 
         case  
         when t.type = '������ � �����' and t.title like '%�����%' and t.title like '%��� ���������%'  
          then rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('���' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4))))  
         when t.type = '������ � �����' and t.title like '%�����%' and t.title not like '%��� ���������%'  
           then rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('��������' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4)))) 
         end as house, 
         case  
         when t.type = '������ � �����' and t.title like '%������� ������ �� ����������� �� �������� �������� ������ �����������%' 
          then substring (t.title, position ('�������: ' in t.title) + 10, position ('����: ' in t.title) - position ('�������: ' in t.title) - 14) 
         end as phone, 
         t.update_date, 
         rank () over (partition by substring (t.title, position ('�������: ' in t.title) + 10, position ('����: ' in t.title) - position ('�������: ' in t.title) - 14) order by t.update_date desc) as rank, 
         t.id 
          from terrasoft.task t  
      where t.type = '������ � �����'  
        and t.title like '%������� ������ �� ����������� �� �������� �������� ������ �����������%'  
        and t.account_id is null  
        and t.core_user_id is null  
        and t.contact_id is null  
        and substring (t.title, position ('�����: ' in t.title) + 7, position ('�����:' in t.title) - position ('�����: ' in t.title) - 8) is not null 
        and substring (t.title, position ('�����: ' in t.title) + 7, position ('����� ����: ' in t.title) - position ('�����: ' in t.title) - 10) not like '' 
        and rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('���' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4)))) not like '') df 
        left join terrasoft.contacts c on c.communication3 = df.phone
        where c.person_id is null
        and rank = 1
        and length(df.street) < 51) as af;