select *
from TechnicalProjectApprovalRoutes tpar
left join TechnicalProjectApprovals TPA on tpar.TechnicalProjectApproval_Id = TPA.Id
left join TechnicalProjects TP on TPA.TechnicalProject_Id = TP.Id
left join AspNetUsers usr on usr.Id = tpar.ApproverUserId
where tp.Id = 11859


--       tpa.Description = N'Согласование технического задания > 5 млн' and tpar.IsActive = 1 and ApproverRole = 'Chief of DLiMTO'