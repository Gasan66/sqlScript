use ASUZD;

with last_active_usr as (
    select ordered_ch_logs.num,
           ordered_ch_logs.ModifiedBy,
           ordered_ch_logs.DateChanged
    from
                (select row_number() over (partition by cl.ModifiedBy order by cl.DateChanged desc ) 'num'
                      , cl.ModifiedBy
                      , cl.DateChanged
                from ASUZD.dbo.ChangeLogs cl
                where cl.ModifiedBy is not null) ordered_ch_logs
    where ordered_ch_logs.num = 1
)

select
        lau.DateChanged 'last_action',
       usr_asuzd.Id 'UsrAsuzdID',
       usr_asuzd.UserName 'UserName',
       usr_asuzd.Email 'Email_ASUZD',
       usr_ad.mail 'Email_AD',
       usr_asuzd.LastName + ' ' + usr_asuzd.FirstName + ' ' + usr_asuzd.MiddleName 'FIO_ASUZD',
       usr_ad.displayname 'FIO_AD'
--         count(*)
from ASUZD.dbo.AspNetUsers usr_asuzd
left join   [10.80.52.12].[ASUZD_dev].[dbo].[import_usr_from_ad] usr_ad on
            replace(usr_asuzd.LastName + usr_asuzd.FirstName + usr_asuzd.MiddleName, ' ','') = replace(usr_ad.displayname, ' ', '')
join        last_active_usr lau on usr_asuzd.Email = lau.ModifiedBy and (getdate() - lau.DateChanged < 90)
where usr_asuzd.Email not like 'import%'
  and usr_asuzd.Email not like '%suzd%'
  and usr_asuzd.Email not like '%mail.ru%'
  and usr_asuzd.Email not like '%@che.mrsk-ural.ru%'
  and usr_asuzd.Email != usr_ad.mail
  and usr_ad.mail is not NULL
  and usr_asuzd.Id != 'a08d2f13-8c0d-43a4-9e3b-46bc590ab43e' -- Рыбакова Татьяна Анатольевна
  and usr_asuzd.Id != '24ed83d1-dbcd-4b3f-95a2-3300f7fc43e2' -- Kalugina-TN@mrsk-ural.ru
--   and usr_asuzd.LastName + ' ' + usr_asuzd.FirstName + ' ' + usr_asuzd.MiddleName not in (N'Рыбакова Татьяна Анатольевна', N'Коротаев Дмитрий Олегович')
  and usr_asuzd.IsEnabled = 1

-- group by usr_asuzd.LastName + ' ' + usr_asuzd.FirstName + ' ' + usr_asuzd.MiddleName
-- order by FIO_ASUZD
