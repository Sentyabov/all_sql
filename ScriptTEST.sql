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
				df.update_date as update_date
	  from (select case
	  			   	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\-\w+)\sг\M,') is not null
	  			   	   	   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\-\w+)\sг\M,'), ' г')
	  			   	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\-\w+)\sрп\M,') is not null
	  			   	   	   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\-\w+)\sрп\M,'), ' рп')
	  			   	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\-\w+)\sпгт\M,') is not null
	  			   	   	   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\-\w+)\sпгт\M,'), ' пгт')
	  			   end as city,
			       case
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sул\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sул\M'), ' ул')
			    	   when substring(replace(t.title, ',,', ',') from '\s\(\w+\sр-н\)\sул') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '(\w+|\w+\s\w+)\s\(\w+\sр-н\)'), ' ул')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sмкр') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sмкр'), ' мкр')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sпр-кт') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+|\w+\s\w+\s\w+\s\w+)\sпр-кт'), ' пр-кт')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sпер\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sпер\M'), ' пер')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sпроезд') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sпроезд'), ' проезд')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sб-р') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sб-р'), ' б-р')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sтракт') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sтракт'), ' тракт')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sпл\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sпл\M'), ' пл')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sкв-л') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sкв-л'), ' кв-л')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sш\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sш\M'), ' ш')
			    	   when substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+)\sтер\M') is not null
			    		   then concat(substring(replace(t.title, ',,', ',') from '\s(\w+|\w+\s\w+|\w+\s\w+\s\w+|\w+[\-|\.]\w+|\w+\-\w+\s\w+|\w+\.\w+\.\w+|\w+\s\w+[\-|\.]\w+|\w+\s\w+\s\w+\s\w+|\w+\-\w+\s\w+\s\w+\s\w+?)\sтер\M'), ' тер')
			       end as street,
			       upper(substring(replace(t.title, ',,', ',') from 'д\.\s(\w+|\w+\/\w+)')) as house,
			       substring(replace(t.title, ',,', ',') from '\sкв\.\s(\d+)|\sкв\.(\d+)') as flat,
			       substring(t.title from '79\d\d\d\d\d\d\d\d\d') as phone,
			       t.update_date,
			       t.id,
			       rank () over (partition by substring(t.title from '79\d\d\d\d\d\d\d\d\d') order by t.update_date desc) as rank
				  from terrasoft.task t
			 where t."type" = 'Перезвон по продажам'
			   and t.contact_id is null
			   and t.account_id is null
			   and t.title like '%Перезвон по продаже%'
			   and t.title like '%6_____,%') df
left join terrasoft.contacts c on c.communication3 = df.phone
 where df.city is not null
   and df.street is not null
   and df.house is not null
   and c.person_id is null
   and df.rank = 1
   and length(df.flat) < 5