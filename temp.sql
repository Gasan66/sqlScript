use ASUZD
begin tran changeLoin
    update AspNetUsers
    set UserName = Email
    from AspNetUsers usr
    join _log_change_logins log on usr.Email = log.new_login
    where usr.Email != 'Borisova-KI@rosseti-ural.ru'

    select email, UserName
    from AspNetUsers usr
    join _log_change_logins log on usr.Email = log.new_login
-- rollback tran
commit tran
select AspNetUsers.Id, anr.*
from AspNetUsers
join AspNetUserRoles ANUR on AspNetUsers.Id = ANUR.UserId
join AspNetRoles ANR on ANUR.RoleId = ANR.Id
where Email = 'Borisova-KI@rosseti-ural.ru'

select log.new_login, count(*)
from _log_change_logins log
group by log.new_login

