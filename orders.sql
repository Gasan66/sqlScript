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