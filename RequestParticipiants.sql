use ASUZD
select ac.id, RequestParticipiants.*
from RequestParticipiants
left join AuctionStages [AS] on RequestParticipiants.AuctionStageId = [AS].Id
left join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
left join PurchaseRequests PR on AC.RequestId = PR.Id
where Pr.Id = 22672

begin tran updateParticipiantsInfo

update RequestParticipiants
set IsWinner = 1, ParticipantRank = 1
where Id = 137555

update RequestParticipiants
set IsWinner = 0, ParticipantRank = 2
where id = 137554;

-- select id, Name, Kpp from RequestParticipiants where id = 134878

    select Rejected, RequestParticipiants.*
from RequestParticipiants
left join AuctionStages [AS] on RequestParticipiants.AuctionStageId = [AS].Id
left join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
left join PurchaseRequests PR on AC.RequestId = PR.Id
where Pr.Id = 22672

-- rollback tran
commit tran