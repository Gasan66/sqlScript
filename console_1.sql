use ASUZD
select RequestParticipiants.*, pr.PublicationPlannedDate, pr.PlannedPurchaseMethodCode
from RequestParticipiants
left join AuctionStages [AS] on RequestParticipiants.AuctionStageId = [AS].Id
left join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
left join PurchaseRequests PR on AC.RequestId = PR.Id
where pr.PublicationPlannedDate between '2018-07-01' and '2019-06-30'
    and RequestParticipiants.Rejected = 1