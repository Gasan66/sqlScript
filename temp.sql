WITH CTE_UnloadedToEIS_PR AS
(
SELECT NotLoadedByPC.RequestId FROM
(
	SELECT NotLoadedToOos.RequestId FROM
	(SELECT DISTINCT AC.RequestId FROM dbo.ProtocolCzoItems AS PCi
	LEFT JOIN dbo.AuctionCycles AS AC ON AC.Id = PCi.AuctionCycleId
	LEFT JOIN dbo.ProtocolCzoes AS PC ON PC.Id = PCi.Protocol_Id
	WHERE PC.LoadedToOos = 0) AS NotLoadedToOos
	LEFT JOIN (
				SELECT DISTINCT AC.RequestId FROM dbo.ProtocolCzoItems AS PCi
				LEFT JOIN dbo.AuctionCycles AS AC ON AC.Id = PCi.AuctionCycleId
				LEFT JOIN dbo.ProtocolCzoes AS PC ON PC.Id = PCi.Protocol_Id
				WHERE PC.LoadedToOos = 1
			  ) AS LoadedToOos ON NotLoadedToOos.RequestId = LoadedToOos.RequestId
			  WHERE LoadedToOos.RequestId IS NULL
) AS NotLoadedByPC
LEFT JOIN (
			--первый AC для PR импортирвоанного в утвержденном состоянии
			SELECT AC.RequestId FROM [dbo].[AuditItems] AS AI
			LEFT JOIN [dbo].[AuditItemRequests] AS AIR ON AIR.ItemId = AI.Id
			LEFT JOIN [dbo].[PurchaseRequests] AS PR ON PR.Id = AIR.PurchaseRequestId
			LEFT JOIN [dbo].[AuctionCycles] AS AC ON AC.RequestId = PR.Id
			WHERE AI.[Message] LIKE N'Импортировано %'
				AND (PR.SapId IS NULL OR PR.SapId = '') --выгрузки из сапа импортируются в неутвержденном состоянии
			GROUP BY AC.RequestId
		  ) AS LoadedByImport ON LoadedByImport.RequestId = NotLoadedByPC.RequestId
		  WHERE LoadedByImport.RequestId IS NULL
)
, CTE_PublishedTP AS
(
SELECT DISTINCT AC.RequestId FROM dbo.TechnicalProjects AS TP
LEFT JOIN dbo.TechnicalProjectRequests AS TPR ON TPR.TechnicalProjectId = TP.Id
LEFT JOIN dbo.AuctionCycles AS AC ON AC.Id = TPR.AuctionCycleId
WHERE TP.ExpEnvelopeOpeningTime <> '0001-01-01 00:00:00.0000000'
)
SELECT distinct
	   PR.Id
      ,PR.Name
      ,PR.ProtocolCzoId
      ,PC.CompleteTime
      ,PR.OwnerId
--       ,PCI.NumberOos
	  ,Stages.[Description] AS [Stage]
	  ,[Status].[Description] AS [Status]
	  ,PR.PlannedPurchaseMethodCode
	  ,PR.PlannedSumByNotificationNotax
	  ,PR.PlannedSumByNotificationTax	  
	  ,Organisation.[Name] AS OrganisationName
	  ,PP.[Year] AS PlanYear
FROM dbo.PurchaseRequests AS PR
LEFT JOIN dbo.Departments AS Organisation ON Organisation.Id = PR.CustomerOrganization
LEFT JOIN dbo.PurchasePlans AS PP ON PR.PurchasePlanId = PP.Id
LEFT JOIN dbo.Stages ON PR.Stage = Stages.Id
LEFT JOIN dbo.[Status] ON PR.[Status] = [Status].Id
LEFT JOIN CTE_UnloadedToEIS_PR ON CTE_UnloadedToEIS_PR.RequestId = PR.Id
LEFT JOIN CTE_PublishedTP ON CTE_PublishedTP.RequestId = PR.Id
LEFT JOIN ProtocolCzoes PC on PR.ProtocolCzoId = PC.Id
-- LEFT JOIN ProtocolCzoItems PCI on PC.Id = PCI.Protocol_Id
-- LEFT JOIN AspNetUsers anu on
WHERE (CTE_UnloadedToEIS_PR.RequestId IS NULL) AND (CTE_PublishedTP.RequestId IS NULL)
AND [Status].Id BETWEEN 10 AND 180
AND Stages.Id BETWEEN 1 AND 5