select RequestParticipiants.*
from RequestParticipiants
left join AuctionStages [AS] on RequestParticipiants.AuctionStageId = [AS].Id
left join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
left join PurchaseRequests PR on AC.RequestId = PR.Id
where Pr.Id = 18806

begin tran updateParticipiantsInfo

update RequestParticipiants
set Kpp = 745301001
where Id = 123045

select id, Name, Kpp from RequestParticipiants where id = 123045

rollback tran