select tpar.*, usr.*
from TechnicalProjects tp
left join technicalprojectapprovals tpa on tp.Id = tpa.TechnicalProject_Id
left join TechnicalProjectApprovalRoutes tpar on tpa.Id = tpar.TechnicalProjectApproval_Id
left join AspNetUsers usr on usr.Id = tpar.ApproverUserId
where tp.id = 12385