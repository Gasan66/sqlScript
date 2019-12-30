use ASUZD
select ac.id, RequestParticipiants.*
from RequestParticipiants
left join AuctionStages [AS] on RequestParticipiants.AuctionStageId = [AS].Id
left join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
left join PurchaseRequests PR on AC.RequestId = PR.Id
where Pr.Id = 19428

begin tran updateParticipiantsInfo

update RequestParticipiants
set Rejected = 0
where Id = 134878


select id, Name, Kpp from RequestParticipiants where id = 134878

    select Rejected, RequestParticipiants.*
from RequestParticipiants
left join AuctionStages [AS] on RequestParticipiants.AuctionStageId = [AS].Id
left join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
left join PurchaseRequests PR on AC.RequestId = PR.Id
where Pr.Id = 19428

rollback tran
-- commit tran