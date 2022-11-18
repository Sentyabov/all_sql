with sphz as (select distinct on (staf.staff_unit) *
		              from (select *
                                    from (select pfz.staff_unit_id as staff_unit ,
                                                 pfz.division_id,
                                                 pfz."month" as start_date
                                                  from erp.plan_fot_zup pfz) as plan
                            union all 
                            select *
                                    from (select distinct on (employee_id)
                                                 sphz.staff_unit,
                                                 sphz.division_id,
                                                 sphz.date as start_date
                                                  from erp.staff_personnel_history_zup sphz
                                          order by employee_id, sphz.date desc) as fact) staf
               where staf.start_date >=date_trunc('year',current_date) - interval '1 year'
                 and staf.start_date <date_trunc('year',current_date) + interval '1 year')
select doz.organization_name,
	   case 
           when dsz5.lvl=0 then dsz5.division_name
           else case
                    when dsz4.lvl=0 then dsz4.division_name
                    else case 
                             when dsz3.lvl=0 then dsz3.division_name
                             else case
                                      when dsz2.lvl=0 then dsz2.division_name
                                      else case
                                               when dsz1.lvl=0 then dsz1.division_name
                                            end
                                   end
                         end
                end
        end as division_0,
       case 
           when dsz5.lvl=1 then dsz5.division_name
           else case
                    when dsz4.lvl=1 then dsz4.division_name
                    else case 
                             when dsz3.lvl=1 then dsz3.division_name
                             else case
                                      when dsz2.lvl=1 then dsz2.division_name
                                      else case
                                               when dsz1.lvl=1 then dsz1.division_name
                                            end
                                   end
                         end
                end
        end as division_1,
       case 
           when dsz5.lvl=2 then dsz5.division_name
           else case
                    when dsz4.lvl=2 then dsz4.division_name
                    else case 
                             when dsz3.lvl=2 then dsz3.division_name
                             else case
                                      when dsz2.lvl=2 then dsz2.division_name
                                      else case
                                               when dsz1.lvl=2 then dsz1.division_name
                                            end
                                   end
                         end
                end
        end as division_2,
       case 
           when dsz5.lvl=3 then dsz5.division_name
           else case
                    when dsz4.lvl=3 then dsz4.division_name
                    else case 
                             when dsz3.lvl=3 then dsz3.division_name
                             else case
                                      when dsz2.lvl=3 then dsz2.division_name
                                      else case
                                               when dsz1.lvl=3 then dsz1.division_name
                                            end
                                   end
                         end
                end
        end as division_3,
       case 
           when dsz5.lvl=4 then dsz5.division_name
           else case
                    when dsz4.lvl=4 then dsz4.division_name
                    else case 
                             when dsz3.lvl=4 then dsz3.division_name
                             else case
                                      when dsz2.lvl=4 then dsz2.division_name
                                      else case
                                               when dsz1.lvl=4 then dsz1.division_name
                                            end
                                   end
                         end
                end
        end as division_4,
        sphz.division_id,
	   spcz.category_name,
	   spz.name as product_name,
	   sphz.staff_unit,
       sopz.staff_unit_name
		from sphz
  left join erp.staff_of_positions_zup sopz on sopz.staff_unit_id=sphz.staff_unit -- позиция в формате должность/отдел
  left join erp.staff_product_of_position_zup spopz on spopz.staff_unit_id=sphz.staff_unit -- продукт и позиция
  left join erp.staff_product_zup spz on spz.id=spopz.product_id -- наименование продукта
  left join erp.staff_post_category_zup spcz on spcz.category_id=sopz.post_category_id -- категория должности
  --inner
   left join erp.directory_subdivisions_zup dsz1 on sphz.division_id = dsz1.division_id 
   left join erp.directory_subdivisions_zup dsz2 on dsz1.parent_id = dsz2.division_id 
   left join erp.directory_subdivisions_zup dsz3 on case when dsz2.division_name is not null then dsz2.parent_id = dsz3.division_id else dsz1.parent_id = dsz3.division_id end
   left join erp.directory_subdivisions_zup dsz4 on case when dsz3.division_name is null then (case when dsz2.division_name is not null then dsz2.parent_id = dsz4.division_id else dsz1.parent_id = dsz4.division_id end) else dsz3.parent_id = dsz4.division_id end
   left join erp.directory_subdivisions_zup dsz5 on case when dsz4.division_name is null then (case when dsz3.division_name is null then (case when dsz2.division_name is not null then dsz2.parent_id = dsz5.division_id else dsz1.parent_id = dsz5.division_id end) else dsz3.parent_id = dsz5.division_id end) else dsz4.parent_id = dsz5.division_id end
   left join erp.directory_organizations_zup doz on doz.organization_id=case when dsz5.lvl=0 then dsz5.owner_id else case when dsz4.lvl=0 then dsz4.owner_id else case when dsz3.lvl=0 then dsz3.owner_id else case when dsz2.lvl=0 then dsz2.owner_id else case when dsz1.lvl=0 then dsz1.owner_id end end end end end