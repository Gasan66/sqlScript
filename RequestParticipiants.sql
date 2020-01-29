use ASUZD
select ac.id, RequestParticipiants.*
from RequestParticipiants
left join AuctionStages [AS] on RequestParticipiants.AuctionStageId = [AS].Id
left join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
left join PurchaseRequests PR on AC.RequestId = PR.Id
where Pr.Id = 22672

begin tran updateParticipiantsInfo

update RequestParticipiants
set PriceNoTax = 4474219.25, PriceTax = 5369063.10
where Id = 137555


select id, Name, Kpp from RequestParticipiants where id = 134878

    select Rejected, RequestParticipiants.*
from RequestParticipiants
left join AuctionStages [AS] on RequestParticipiants.AuctionStageId = [AS].Id
left join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
left join PurchaseRequests PR on AC.RequestId = PR.Id
where Pr.Id = 22672

rollback tran
-- commit tran