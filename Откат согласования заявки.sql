begin tran revertRequestApproval

declare @requestId bigint = 18479
declare @requestApprovalId bigint = 29938
declare @approvalRouteId bigint = 132457

-- revert request
update dbo.PurchaseRequests
	set [Status] = 20 -- Согласование
	WHERE Id = @requestId

-- revert approval
update dbo.RequestApprovals
set IsCompleted = 0,
	CompletedTime = null,
	ApprovalResult = null,
	IsActive = 1
where id = @requestApprovalId

--revert route
update dbo.RequestApprovalRoutes
set IsActive = 1,
	TimeOfDecided = null,
	Decision = null,
	[Message] = null
where id =@approvalRouteId

select id, Status, stage from dbo.PurchaseRequests where id = @requestId
--select * from dbo.AuctionCycles where RequestId = @requestId
select id, IsCompleted, IsActive from dbo.RequestApprovals where id = @requestApprovalId
select id, IsActive, TimeOfDecided, Decision, Message from dbo.RequestApprovalRoutes where id = @approvalRouteId

-- temp
--select * from dbo.Status

rollback tran

--commit tran