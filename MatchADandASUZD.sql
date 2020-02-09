SELECT *
FROM [10.80.52.12].[ASUZD_dev].[dbo].[import_usr_from_ad]

select usr_asuzd.Email 'Email ASUZD',
       usr_ad.mail 'Email AD',
       usr_asuzd.LastName + ' ' + usr_asuzd.FirstName + ' ' + usr_asuzd.MiddleName 'FIO ASUZD',
--        replace(usr_asuzd.LastName + usr_asuzd.FirstName + usr_asuzd.MiddleName, ' ',''),
       usr_ad.displayname 'FIO AD'
--        replace(usr_ad.displayname, ' ', '')

from ASUZD.dbo.AspNetUsers usr_asuzd
left join [10.80.52.12].[ASUZD_dev].[dbo].[import_usr_from_ad] usr_ad on
    replace(usr_asuzd.LastName + usr_asuzd.FirstName + usr_asuzd.MiddleName, ' ','') = replace(usr_ad.displayname, ' ', '')
where usr_asuzd.Email not like 'import%'
  and usr_asuzd.Email not like '%suzd%'
  and usr_asuzd.Email not like '%mail.ru%'
  and usr_asuzd.Email not like '%@che.mrsk-ural.ru%'
order by usr_ad.mail