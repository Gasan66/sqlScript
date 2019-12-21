use ASUZD
select *
from TechnicalProjectOrders
where TechnicalProjectId = 13760

select *
from TechnicalProjectComissionMembers
where TechnicalProjectId = 13760

select *
from ComissionMembers
where Order_Id = 49


begin tran changeOrder
    update TechnicalProjectOrders
    set OrderId = 49
    where TechnicalProjectId = 13760 and OrderId = 51;

    delete
    from TechnicalProjectComissionMembers
    where TechnicalProjectId = 13760 and ComissionMemberId in (
        603,
        604,
        605,
        606,
        607
        )

    insert into TechnicalProjectComissionMembers
    values  (13760, 583),
            (13760, 584),
            (13760, 585),
            (13760, 587),
            (13760, 588),
            (13760, 589),
            (13760, 590),
            (13760, 591),
            (13760, 592)

    select *
    from TechnicalProjectOrders
    where TechnicalProjectId = 13760
    union
    select *
    from TechnicalProjectComissionMembers
    where TechnicalProjectId = 13760

rollback tran
-- commit tran