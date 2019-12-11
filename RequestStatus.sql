begin tran updateStatus

select pr.Id,
       Status.Description as 'Status',
       Stages.Description as 'Stage', pr.Status, pr.Stage
from ASUZD.dbo.PurchaseRequests pr
left join ASUZD.dbo.Status on ASUZD.dbo.Status.id = pr.Status
left join ASUZD.dbo.Stages on ASUZD.dbo.Stages.id = pr.Stage
where pr.id = 19294 or pr.Id = 12811

update ASUZD.dbo.PurchaseRequests
set Status = 185, Stage = 5
where ASUZD.dbo.PurchaseRequests.Id = 19294

select pr.Id,
       Status.Description as 'Status',
       Stages.Description as 'Stage', pr.Status, pr.Stage
from ASUZD.dbo.PurchaseRequests pr
left join ASUZD.dbo.Status on ASUZD.dbo.Status.id = pr.Status
left join ASUZD.dbo.Stages on ASUZD.dbo.Stages.id = pr.Stage
where pr.id = 19294 or pr.Id = 12811

rollback tran
-- commit tran