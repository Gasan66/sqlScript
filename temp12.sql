use ASUZD
select * from (
select case when ac.Status = 0 then prSt.Description else acSt.Description end as 'Description',
           case when ac.Stage = 0 then pr.Stage else ac.Stage end as 'Stage',
           anu.LastName + ' ' + anu.FirstName + ' ' + anu.MiddleName as PurchaserFullName,
           tp.Id as TZid,
           pr.id as RequestId,
           pr.PurchasePlanYear as PurchasePlanYear,
           ano.Description as OrgName,
	       pr.Name as Name,
       	   tp.Name as TZName,
       	   tp.ExpEnvelopeOpeningTime as ExpEnvelopeOpeningTime,
           pr.PlannedPurchaseMethodCode
    from TechnicalProjects tp
    join TechnicalProjectRequests TPR on tp.Id = TPR.TechnicalProjectId
    join AuctionCycles AC on TPR.AuctionCycleId = AC.Id
    join PurchaseRequests PR on AC.RequestId = PR.Id
    join Status prSt on pr.Status = prSt.Id
    join Status acSt on ac.Status = acSt.Id
    join AspNetUsers ANU on TP.ExecutorId = ANU.Id
    join AspNetOrganizations ANO on ANU.OrganizationId = ANO.Id

where anu.LastName = N'Онуфрийчук'
and pr.PurchasePlanYear = 2020) t
where t.PlannedPurchaseMethodCode = N'ЗПэФ'