select distinct null as contact_name,
				df.phone,
	   			null as email,
				df.city,
				df.street,
				df.house,
				null as flat,
				'terrasoft' as source,
				max(df.id) as source_id,
				max(df.start_date) as create_date
	  from (
select substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\-\w+)\s(�\M|��|���),') as city,
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
       substring(t.title from '7\d{10}') as phone,
       t.start_date,
       t.id
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
group by df.phone, df.city, df.street, df.house