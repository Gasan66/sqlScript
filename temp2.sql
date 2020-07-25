use ASUZD

select *
from PurchaseRequests pr
where pr.Id = 23310

select * from AuctionCycles
where RequestId = 23310

select * from RequestHistories
where RequestId = 23310

select ac.Id, ac.RequestId, tp.Id, pr.PlannedPurchaseMethodCode, rh.PlannedPurchaseMethodCode
from TechnicalProjects tp
join TechnicalProjectRequests tpr on tp.Id = tpr.TechnicalProjectId
join AuctionCycles AC on tpr.AuctionCycleId = AC.Id
join PurchaseRequests PR on AC.RequestId = PR.Id
left join RequestHistories rh on rh.AuctionCycleId = ac.Id
where ac.RequestId = 23310
