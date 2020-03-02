USE ASUZD
select *
from OrdersExcluded

begin tran updateOrdersExcluded

    update OrdersExcluded
    set ExcludedOrderId = 49
    where ExcludedOrderId = 39

    select *
    from OrdersExcluded
    where ExcludedOrderId = 49

rollback tran


select *
from TechnicalProjectOrders
-- join Orders O on TechnicalProjectOrders.OrderId = O.Id
where TechnicalProjectId = 14220

select *
from TechnicalProjectComissionMembers
join ComissionMembers CM on TechnicalProjectComissionMembers.ComissionMemberId = CM.Id
join Orders O on CM.Order_Id = O.Id
join AspNetUsers ANU on CM.ApplicationUserId = ANU.Id
where TechnicalProjectId = 14220


begin tran delOrderFromTZ
    delete
    from TechnicalProjectOrders
    where TechnicalProjectId = 14220 and OrderId = 45

    select *
    from TechnicalProjectOrders
    join Orders O on TechnicalProjectOrders.OrderId = O.Id
    where TechnicalProjectId = 14220

commit tran

