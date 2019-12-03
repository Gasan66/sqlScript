use ASUZD

begin tran revertTZApproval

declare @TzId bigint = 13366
declare @TzApprovalId bigint = 17277
declare @approvalRouteId bigint = 42326

-- revert request
update dbo.TechnicalProjects
	set [Status] = 2 -- Согласование
	WHERE Id = @TzId

-- revert approval
update dbo.TechnicalProjectApprovals
set IsCompleted = 0,
	CompleteTime = null,
	IsActive = 1
where id = @TzApprovalId

--revert route
update dbo.TechnicalProjectApprovalRoutes
set IsActive = 1,
	TimeOfDecided = null,
	Decision = null,
	[Message] = null
where id =@approvalRouteId

select id, Status from dbo.TechnicalProjects where id = @TzId
--select * from dbo.AuctionCycles where RequestId = @requestId
select id, IsCompleted, IsActive from dbo.TechnicalProjectApprovals where id = @TzApprovalId
select id, IsActive, TimeOfDecided, Decision, Message from dbo.TechnicalProjectApprovalRoutes where id = @approvalRouteId

-- temp
--select * from dbo.Status

rollback tran

-- commit tran