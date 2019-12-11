USE ASUZD
select s.Description, pr.*
from PurchaseRequests pr
left join AuctionCycles ac on pr.Id = ac.RequestId
left join TechnicalProjectRequests tpr on tpr.AuctionCycleId = ac.Id
left join TechnicalProjects tp on tpr.TechnicalProjectId = tp.Id
left join Status s on s.Id = pr.Status
where pr.Id = 19114 or pr.Id = 13538

begin tran updReqStatus

update PurchaseRequests
set Status = 186
where id = 19114

select s.Description, pr.*
from PurchaseRequests pr
left join AuctionCycles ac on pr.Id = ac.RequestId
left join TechnicalProjectRequests tpr on tpr.AuctionCycleId = ac.Id
left join TechnicalProjects tp on tpr.TechnicalProjectId = tp.Id
left join Status s on s.Id = pr.Status
where pr.Id = 20404 or pr.Id = 13538

rollback tran