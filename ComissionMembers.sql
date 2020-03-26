use ASUZD
select usr.LastName, usr.FirstName, usr.MiddleName, oldOrder.Position
from ComissionMembers mem
inner join (select * from ComissionMembers where Order_Id = 47) oldOrder on oldOrder.ApplicationUserId = mem.ApplicationUserId
left join AspNetUsers usr on mem.ApplicationUserId = usr.Id
where mem.Order_Id in (53)
order by usr.LastName

begin tran updatePosition

    update ComissionMembers
    set Position = oldOrder.Position, Role = oldOrder.Role
    from ComissionMembers mem
    inner join (select * from ComissionMembers where Order_Id = 47) oldOrder on oldOrder.ApplicationUserId = mem.ApplicationUserId
    left join AspNetUsers usr on mem.ApplicationUserId = usr.Id
    where mem.Order_Id in (53)

    select usr.LastName, usr.FirstName, usr.MiddleName, mem.Position, mem.Role
    from ComissionMembers mem
    left join AspNetUsers usr on mem.ApplicationUserId = usr.Id
    where Order_Id = 47

rollback tran

begin tran insertMembers

    insert into ComissionMembers
        select ApplicationUserId, Position, Role, 53
        from ComissionMembers
        where Order_id = 47

    select usr.FirstName + ' ' + usr.MiddleName + ' ' + usr.LastName , mem.*
    from ComissionMembers mem
    left join AspNetUsers usr on usr.Id = mem.ApplicationUserId
    where Order_Id = 53

-- rollback tran
commit tran
