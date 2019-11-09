begin tran updateStatus

select pr.Id,
       Status.Description as 'Status',
       Stages.Description as 'Stage', pr.Status, pr.Stage
from ASUZD.dbo.PurchaseRequests pr
left join ASUZD.dbo.Status on ASUZD.dbo.Status.id = pr.Status
left join ASUZD.dbo.Stages on ASUZD.dbo.Stages.id = pr.Stage
where pr.id = 18711 or pr.Id = 12456

update ASUZD.dbo.PurchaseRequests
set Status = 70
where ASUZD.dbo.PurchaseRequests.Id = 18711

select pr.Id,
       Status.Description as 'Status',
       Stages.Description as 'Stage', pr.Status, pr.Stage
from ASUZD.dbo.PurchaseRequests pr
left join ASUZD.dbo.Status on ASUZD.dbo.Status.id = pr.Status
left join ASUZD.dbo.Stages on ASUZD.dbo.Stages.id = pr.Stage
where pr.id = 18711 or pr.Id = 12456

rollback tran