select t.title, 
         case  
         when t.type = '������ � �����' and t.title like '%������� ������ �� ����������� �� �������� �������� ������ �����������%' and substring (t.title, position ('�����: ' in t.title) + 7, position ('�����:' in t.title) - position ('�����: ' in t.title) - 8) like '%��������%'
          then concat(substring (t.title, position ('�����: ' in t.title) + 7, position ('�����:' in t.title) - position ('�����: ' in t.title) - 8), '��') 
          when t.type = '������ � �����' and t.title like '%������� ������ �� ����������� �� �������� �������� ������ �����������%' and substring (t.title, position ('�����: ' in t.title) + 7, position ('�����:' in t.title) - position ('�����: ' in t.title) - 8) not like '��������'
          then concat(substring (t.title, position ('�����: ' in t.title) + 7, position ('�����:' in t.title) - position ('�����: ' in t.title) - 8),  '�')
         end as city, 
         case  
         when t.type = '������ � �����' and t.title like '%������� ������ �� ����������� �� �������� �������� ������ �����������%' 
          then substring(t.title, position ('�����: ' in t.title) + 7, position ('����� ����: ' in t.title) - position ('�����: ' in t.title) - 9) 
         end as street, 
         case  
         when t.type = '������ � �����' and t.title like '%�����%' and t.title like '%��� ���������%'  
          then upper(rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('���' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4)))))  
         when t.type = '������ � �����' and t.title like '%�����%' and t.title not like '%��� ���������%'  
           then upper(rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('��������' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4))))) 
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
        and rtrim (split_part (t.title, ': ', 4), substring(split_part (t.title, ': ', 4), position('���' in split_part (t.title, ': ', 4)), char_length(split_part (t.title, ': ', 4)))) not like ''