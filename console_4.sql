select *
from TemplateApprovalRoutes tar
-- left join AspNetUsers anu on anu.Id = tar.ApproverUserId
left join TemplateApprovals ta on tar.RequestApproval_Id = ta.Id
-- left join AspNetRoles ANR on tar.ApproverRoleId = anr.Id
where ta.Type like '%TZ%'