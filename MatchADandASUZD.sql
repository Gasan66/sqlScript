SELECT *
FROM [10.80.52.12].[ASUZD_dev].[dbo].[import_usr_from_ad]

select usr_asuzd.Email, usr_ad.mail,
       usr_asuzd.LastName + ' ' + usr_asuzd.FirstName + ' ' + usr_asuzd.MiddleName,
       usr_ad.displayname
from ASUZD.dbo.AspNetUsers usr_asuzd
left join [10.80.52.12].[ASUZD_dev].[dbo].[import_usr_from_ad] usr_ad on (usr_asuzd.LastName + ' ' + usr_asuzd.FirstName + ' ' + usr_asuzd.MiddleName) = usr_ad.displayname