use ASUZD
select Email
from AspNetUsers
where substring(Email,charindex('@', Email),len(Email)) not in (
    '@asuzd.ru',
    '@bk.ru',
    '@excel.com',
    '@mail.ru',
    '@suzd.ru'
    )