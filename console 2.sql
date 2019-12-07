use ASUZD
select *
from LongTermPurschasePayments
join AuctionCycles AC on LongTermPurschasePayments.AuctionCycleId = AC.Id
join PurchaseRequests PR on AC.RequestId = PR.Id
where pr.Id = 18479

begin tran updPaymentSummWithTax

update LongTermPurschasePayments
set PaymentSummWithTax = 562277743.51 - 83507606.73
where Id = 14558

select PaymentSummWithTax, 83507606.73 + 478770136.78
from LongTermPurschasePayments
join AuctionCycles AC on LongTermPurschasePayments.AuctionCycleId = AC.Id
join PurchaseRequests PR on AC.RequestId = PR.Id
where pr.Id = 18479

rollback tran
