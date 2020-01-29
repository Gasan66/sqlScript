use ASUZD
select CustomerSubdivision
from PurchaseRequests
where id = 19523


SELECT *
FROM dbo.AspNetUsers AS USERS
LEFT JOIN dbo.AspNetUserRoles AS USERROLE ON USERROLE.UserId = USERS.Id
LEFT JOIN dbo.AspNetRoles AS ROLES ON ROLES.Id = USERROLE.RoleId
WHERE IsGroup = 1
AND ROLES.[Name] NOT LIKE N'%Согласование%' and USERS.Id = '6bca4d95-d5f9-4701-8906-a3a2234647de'


select *
from AspNetUsers usr
left join AspNetUserRoles ANUR on usr.Id = ANUR.UserId

select groups.Name, groups.FullName, roles.Name
from AspNetRoles groups
left join AspNetRoles roles on groups.RoleOfGroupId = roles.Id