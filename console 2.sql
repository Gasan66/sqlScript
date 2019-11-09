select usr.FirstName + ' ' + usr.MiddleName + ' ' + usr.LastName as FIO
        , anr.Name as Depart
        , Husr.FirstName + ' ' + Husr.MiddleName + ' ' + Husr.LastName as Head
from AspNetUsers usr
left join AspNetUserRoles ANUR on usr.Id = ANUR.UserId
left join AspNetRoles ANR on ANUR.RoleId = ANR.Id
left join AspNetUsers Husr on Husr.Id = anr.HeadId
where ANR.GroupRole = 'Customer'