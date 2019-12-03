use ASUZD
select pr.id as 'requestId',
       ra.Id as 'requestApprovalId',
       RequestApprovalRoutes.Id as 'approvalRouteId',
       RequestApprovalRoutes.TimeOfDecided, ANU.*
from RequestApprovalRoutes
left join RequestApprovals RA on RequestApprovalRoutes.RequestApproval_Id = RA.Id
left join PurchaseRequests PR on RA.PurchaseRequest_Id = PR.Id
left join AspNetUsers ANU on RequestApprovalRoutes.ApproverUserId = ANU.Id
where PR.Id = 21229

-- update RequestApprovalRoutes
-- set ApproverUserId = 'B349DB1C-24F7-4CE1-826B-27F1B1A8AF60'
-- where Id = '113876'