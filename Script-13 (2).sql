select t.title, 
         case  
         when t.type = 'Отзвон с сайта' and t.title like '%Оставил заявку на подключение на странице проверки адреса подключения%' and substring (t.title, position ('Город: ' in t.title) + 7, position ('Улица:' in t.title) - position ('Город: ' in t.title) - 8) like '%Кольцово%'
          then concat(substring (t.title, position ('Город: ' in t.title) + 7, position ('Улица:' in t.title) - position ('Город: ' in t.title) - 8), 'рп') 
          when t.type = 'Отзвон с сайта' and t.title like '%Оставил заявку на подключение на странице проверки адреса подключения%' and substring (t.title, position ('Город: ' in t.title) + 7, position ('Улица:' in t.title) - position ('Город: ' in t.title) - 8) not like 'Кольцово'
          then concat(substring (t.title, position ('Город: ' in t.title) + 7, position ('Улица:' in t.title) - position ('Город: ' in t.title) - 8),  'г')
         end as city, 
         case  
         when t.type = 'Отзвон с сайта' and t.title like '%Оставил заявку на подключение на странице проверки адреса подключения%' 
          then substring(t.title, position ('Улица: ' in t.title) + 7, position ('Номер дома: ' in t.title) - position ('Улица: ' in t.title) - 9) 
         end as street, 
         case  
         when t.type = 'Отзвон с сайта' and t.title like '%Улица%' and t.title like '%Дом подключен%'  
          then upper(rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('Дом' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4)))))  
         when t.type = 'Отзвон с сайта' and t.title like '%Улица%' and t.title not like '%Дом подключен%'  
           then upper(rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('Промокод' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4))))) 
         end as house, 
         case  
         when t.type = 'Отзвон с сайта' and t.title like '%Оставил заявку на подключение на странице проверки адреса подключения%' 
          then substring (t.title, position ('Телефон: ' in t.title) + 10, position ('Дата: ' in t.title) - position ('Телефон: ' in t.title) - 14) 
         end as phone, 
         t.update_date, 
         rank () over (partition by substring (t.title, position ('Телефон: ' in t.title) + 10, position ('Дата: ' in t.title) - position ('Телефон: ' in t.title) - 14) order by t.update_date desc) as rank, 
         t.id 
          from terrasoft.task t  
      where t.type = 'Отзвон с сайта'  
        and t.title like '%Оставил заявку на подключение на странице проверки адреса подключения%'  
        and t.account_id is null  
        and t.core_user_id is null  
        and t.contact_id is null  
        and substring (t.title, position ('Город: ' in t.title) + 7, position ('Улица:' in t.title) - position ('Город: ' in t.title) - 8) is not null 
        and substring (t.title, position ('Улица: ' in t.title) + 7, position ('Номер дома: ' in t.title) - position ('Улица: ' in t.title) - 10) not like '' 
        and rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('Дом' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4)))) not like ''