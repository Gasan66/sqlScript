use ASUZD
select usr.LastName, usr.FirstName, usr.MiddleName, oldOrder.Position
from ComissionMembers mem
inner join (select * from ComissionMembers where Order_Id = 39) oldOrder on oldOrder.ApplicationUserId = mem.ApplicationUserId
left join AspNetUsers usr on mem.ApplicationUserId = usr.Id
where mem.Order_Id in (49)
order by usr.LastName

begin tran updatePosition

    update ComissionMembers
    set Position = oldOrder.Position, Role = oldOrder.Role
    from ComissionMembers mem
    inner join (select * from ComissionMembers where Order_Id = 41) oldOrder on oldOrder.ApplicationUserId = mem.ApplicationUserId
    left join AspNetUsers usr on mem.ApplicationUserId = usr.Id
    where mem.Order_Id in (47)

    select usr.LastName, usr.FirstName, usr.MiddleName, mem.Position, mem.Role
    from ComissionMembers mem
    left join AspNetUsers usr on mem.ApplicationUserId = usr.Id
    where Order_Id = 47

rollback tran

begin tran insertMembers

    insert into ComissionMembers
        select ApplicationUserId, Position, Role, 49
        from ComissionMembers
        where Order_id = 39

    select usr.FirstName + ' ' + usr.MiddleName + ' ' + usr.LastName , mem.*
    from ComissionMembers mem
    left join AspNetUsers usr on usr.Id = mem.ApplicationUserId
    where Order_Id = 49

rollback tran
