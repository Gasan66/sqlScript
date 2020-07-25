use ASUZD
select pci.*
from PurchaseRequests pr
join AuctionCycles ac on pr.Id = ac.RequestId
join ProtocolCzoItems pci on ac.Id = pci.AuctionCycleId
where pci.Protocol_Id in (489, 487)

begin tran changeMethod

    update PurchaseRequests
    set PlannedPurchaseMethodCode = N'ЗЦ КПОэф'
    where id = 23868

    select PlannedPurchaseMethodCode
    from PurchaseRequests
    where id = 23868

-- rollback tran
commit tran