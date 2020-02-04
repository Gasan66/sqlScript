begin tran updateStatus

select pr.Id,
       Status.Description as 'Status',
       Stages.Description as 'Stage', pr.Status, pr.Stage
from ASUZD.dbo.PurchaseRequests pr
left join ASUZD.dbo.Status on ASUZD.dbo.Status.id = pr.Status
left join ASUZD.dbo.Stages on ASUZD.dbo.Stages.id = pr.Stage
where pr.id = 22601 or pr.Id = 14354

update ASUZD.dbo.PurchaseRequests
set Status = 177, Stage = 4 --186 9
where ASUZD.dbo.PurchaseRequests.Id = 22601

select pr.Id,
       Status.Description as 'Status',
       Stages.Description as 'Stage', pr.Status, pr.Stage
from ASUZD.dbo.PurchaseRequests pr
left join ASUZD.dbo.Status on ASUZD.dbo.Status.id = pr.Status
left join ASUZD.dbo.Stages on ASUZD.dbo.Stages.id = pr.Stage
where pr.id = 22601 or pr.Id = 14354

-- rollback tran
commit tran