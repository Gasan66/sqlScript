select getdate()
from LongTermPurschasePayments
left join AuctionCycles AC on LongTermPurschasePayments.AuctionCycleId = AC.Id
left join PurchaseRequests PR on AC.RequestId = PR.Id
where pr.id = 21073

begin tran updLongTermPurschasePayments

    update LongTermPurschasePayments
    set PaymentSummWithTax = 57748630
    where id = 19559

    update LongTermPurschasePayments
    set PaymentSummWithTax = 145500000
    where id = 19560

    update LongTermPurschasePayments
    set PaymentSummWithTax = 145500000
    where id = 19561

    update LongTermPurschasePayments
    set PaymentSummWithTax = 87751370
    where id = 19562

    select *
    from LongTermPurschasePayments
    left join AuctionCycles AC on LongTermPurschasePayments.AuctionCycleId = AC.Id
    left join PurchaseRequests PR on AC.RequestId = PR.Id
    where pr.id = 21073

-- rollback tran
commit tran