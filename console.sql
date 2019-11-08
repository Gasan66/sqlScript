use ASUZD
select id, Status, Stage
from PurchaseRequests
where id in (18518, 18597, 18627, 20634)

select *
from PurchaseMethods
where Code in (N'КэфМСП', N'ЗПэфМСП')

begin tran updatePurchaseMethods

    update PurchaseRequests
    set PlannedPurchaseMethodCode = N'КэфМСП'
    where id = 14407

    update PurchaseRequests
    set PlannedPurchaseMethodCode = N'ЗПэфМСП'
    where id = 15756

    select id, PlannedPurchaseMethodCode, OwnerOrganizationId
    from PurchaseRequests
    where id in (14407, 15756)

rollback tran
