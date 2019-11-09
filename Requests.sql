USE ASUZD
select tpr.*
from PurchaseRequests pr
left join AuctionCycles ac on pr.Id = ac.RequestId
left join TechnicalProjectRequests tpr on tpr.AuctionCycleId = ac.Id
left join TechnicalProjects tp on tpr.TechnicalProjectId = tp.Id
where tp.Id = 12601

update TechnicalProjectRequests
set Deadline = N'Начало работ– с момента заключения договора до 31.12.2020'
where TechnicalProjectId = 12601