/*<debug>
USE ASUZD
GO

DECLARE @PurchasePalnYear int = 2019
DECLARE @CustomerOrganisation nvarchar(100) = N'ОАО "МРСК Урала"'
</debug>*/

/****** Скрипт для получения данных отчета Plan "План закупки"   ******/


--     update PurchaseRequests
--     set PurchaseRequests.PurchasePlanYear = 2019
--     from ASUZD.dbo.ProtocolCzoes pc
--     left join ASUZD.dbo.ProtocolCzoItems pci on pc.Id = pci.Protocol_Id
--     left join ASUZD.dbo.AuctionCycles on pci.AuctionCycleId = AuctionCycles.Id
--     left join ASUZD.dbo.PurchaseRequests on AuctionCycles.RequestId = PurchaseRequests.Id
--     where pc.Id = 386

DECLARE @CustomerOrganisation nvarchar(100) = N'ОАО "МРСК Урала"'
;

WITH IPRData AS (
	SELECT	PRO.RequestId, PST.[Description], O.[Name], O.Code,
			O.StartYear, O.EndYear, O.EstimatedCostTax, O.CashBalanceTax
	FROM dbo.PurchaseRequestIprObjects PRO
	LEFT JOIN dbo.InvestPrograms P ON P.Id = PRO.InvestProgramId
	LEFT JOIN dbo.InvestProgramStatus PST ON PST.Id = P.StatusId
	LEFT JOIN dbo.IprObjects O ON (O.Code = PRO.IprObjectCode) AND (O.InvestProgramId = PRO.InvestProgramId)
), IPRDataInlineByField AS (
	SELECT IPR.RequestId
		,STUFF((
				SELECT
					'; ' + C.[Description]
				FROM IPRData AS C
				WHERE C.RequestId = IPR.RequestId
		FOR XML PATH('')),1,2,'') AS [ProjectStatus]
		,STUFF((
				SELECT
					'; ' + C.[Name]
				FROM IPRData AS C
				WHERE C.RequestId = IPR.RequestId
		FOR XML PATH('')),1,2,'') AS [ObjectName]
		,STUFF((
				SELECT
					'; ' + C.[Code]
				FROM IPRData AS C
				WHERE C.RequestId = IPR.RequestId
		FOR XML PATH('')),1,2,'') AS [ObjectCode]
		,STUFF((
				SELECT
					'; ' + CAST(C.[StartYear] AS nvarchar(6))
				FROM IPRData AS C
				WHERE C.RequestId = IPR.RequestId
		FOR XML PATH('')),1,2,'') AS [ObjectStartYear]
		,STUFF((
				SELECT
					'; ' + CAST(C.[EndYear] AS nvarchar(6))
				FROM IPRData AS C
				WHERE C.RequestId = IPR.RequestId
		FOR XML PATH('')),1,2,'') AS [ObjectEndYear]
		,STUFF((
				SELECT
					'; ' + CAST(C.[EstimatedCostTax]/1000000 AS nvarchar(20))
				FROM IPRData AS C
				WHERE C.RequestId = IPR.RequestId
		FOR XML PATH('')),1,2,'') AS [ObjectEstimatedCostTax]
		,STUFF((
				SELECT
					'; ' + CAST(C.[CashBalanceTax]/1000000 AS nvarchar(20))
				FROM IPRData AS C
				WHERE C.RequestId = IPR.RequestId
		FOR XML PATH('')),1,2,'') AS [ObjectCashBalanceTax]
/*
		,(SELECT
					SUM(C.EstimatedCostTax)
				FROM IPRData AS C
				WHERE C.RequestId = IPR.RequestId
				GROUP BY C.RequestId) AS [SumEstimatedCostTax]
		,(SELECT
					SUM(C.CashBalanceTax)
				FROM IPRData AS C
				WHERE C.RequestId = IPR.RequestId
				GROUP BY C.RequestId) AS [SumCashBalanceTax]
*/
	FROM IPRData IPR
	GROUP BY IPR.RequestId
), DistinctContractorsId AS (
	SELECT DISTINCT PurchaseRequestId FROM dbo.Contractors
), ContractorsInlineByField AS (
	SELECT DCI.PurchaseRequestId AS [RequestId]
		  ,(SELECT
						SUM(C.PriceNoTax)
					FROM dbo.Contractors AS C
					WHERE C.PurchaseRequestId = DCI.PurchaseRequestId
					GROUP BY C.PurchaseRequestId) AS [FinalSumNoTax]
		  ,(SELECT
						SUM(C.PriceTax)
					FROM dbo.Contractors AS C
					WHERE C.PurchaseRequestId = DCI.PurchaseRequestId
					GROUP BY C.PurchaseRequestId) AS [FinalSumTax]
		  ,STUFF((
					SELECT
						'; ' + CASE WHEN C.[Name] IS NULL THEN N'нет данных' ELSE C.[Name] END
					FROM dbo.Contractors AS C
					WHERE C.PurchaseRequestId = DCI.PurchaseRequestId
			FOR XML PATH('')),1,2,'') AS [ContractorName]
		   ,STUFF((
					SELECT
						'; ' + CASE WHEN C.[Inn] IS NULL THEN N'нет данных' ELSE C.[Inn] END
					FROM dbo.Contractors AS C
					WHERE C.PurchaseRequestId = DCI.PurchaseRequestId
			FOR XML PATH('')),1,2,'') AS [ContractorInn]
		   ,STUFF((
					SELECT
						'; ' + CASE WHEN C.[Kpp] IS NULL THEN N'нет данных' ELSE C.[Kpp] END
					FROM dbo.Contractors AS C
					WHERE C.PurchaseRequestId = DCI.PurchaseRequestId
			FOR XML PATH('')),1,2,'') AS [Kpp]
	FROM DistinctContractorsId AS DCI
), DistinctContractorHistsId AS (
	SELECT DISTINCT RequestHistoryId FROM dbo.ContractorHists
), ContractorHistsInLineByField AS (
	SELECT DCHI.RequestHistoryId
		  ,(SELECT
						SUM(CH.PriceNoTax)
					FROM dbo.ContractorHists AS CH
					WHERE CH.RequestHistoryId = DCHI.RequestHistoryId
					GROUP BY CH.RequestHistoryId) AS [PlannedSumByNotificationNotax]
		  ,(SELECT
						SUM(CH.PriceTax)
					FROM dbo.ContractorHists AS CH
					WHERE CH.RequestHistoryId = DCHI.RequestHistoryId
					GROUP BY CH.RequestHistoryId) AS [PlannedSumByNotificationTax]
		  ,STUFF((
					SELECT
						'; ' + CASE WHEN CH.[Name] IS NULL THEN N'нет данных' ELSE CH.[Name] END
					FROM dbo.ContractorHists AS CH
					WHERE CH.RequestHistoryId = DCHI.RequestHistoryId
			FOR XML PATH('')),1,2,'') AS [ContractorName]
		   ,STUFF((
					SELECT
						'; ' + CASE WHEN CH.[Inn] IS NULL THEN N'нет данных' ELSE CH.[Inn] END
					FROM dbo.ContractorHists AS CH
					WHERE CH.RequestHistoryId = DCHI.RequestHistoryId
			FOR XML PATH('')),1,2,'') AS [ContractorInn]
		   ,STUFF((
					SELECT
						'; ' + CASE WHEN CH.[Kpp] IS NULL THEN N'нет данных' ELSE CH.[Kpp] END
					FROM dbo.ContractorHists AS CH
					WHERE CH.RequestHistoryId = DCHI.RequestHistoryId
			FOR XML PATH('')),1,2,'') AS [Kpp]
	FROM DistinctContractorHistsId AS DCHI
), PR_RH_AC AS (
SELECT
	AC.AuctionCycleId
	,PR.[Id] AS [RequestId]
	,NULL AS [RequestHistoryId]
	,PR.[CodeActivityId]
	,PR.[CustomerOrganization]
	,PR.[CustomerSubdivision]
	,PR.[ProductTypeId]
	,PR.[Name]
	,PR.[OkvedId]
	,PR.[OkdpId]
	,PR.[ForSmallOrMiddle]
	,PR.[PurchaseCategory_Id]
	,PR.[IsInnovation]
	,PR.[PurchasePriceDocumentCode]
	,PR.[PlannedSumNotax]
	,PR.[PlannedSumWith30PercReductionNotax]
	,PR.[PlannedSumByNotificationNotax]
	,PR.[PlannedSumByNotificationTax]
	,PR.[PlannedPurchaseMethodCode]
	,PR.[CustomerOrganizer]
	,PR.[IsElectronicPurchase]
	,PR.[PublicationPlannedDate]
	,PR.[ExpDateKonProc]
	,PR.[SummingupTime]
	,Contr.[ContractorName]
	,Contr.[ContractorInn]
	,Contr.[Kpp]
	,PR.[MinRequirementsForPurchaseGoods]
	,PR.[Okeiguid]
	,PR.[Qty]
	,PR.[Okato]
	,PR.[PlannedDateOfContract]
	,PR.[PlannedDateOfDelivery]
	,PR.[PlannedDateOfCompletion]
	,PR.[PlannedPurchaseYear]
	,PR.[AdditionalInfo]
	,PR.[IprYear]
	,PR.[InvestProjectCode]
	,PR.[InvestProjectName]
	,PR.[DateApprovalConstructionDocuments]
	,PR.[DateEndProject]
	,PR.[CostProject]
	,PR.[Mba]
	,PR.[Kilometer]
	,PR.[ProcessConnection]
	,PR.[CustomerFunctionalBlock]
	,PR.[PurchasePlanYear]
	,PR.[ReasonPurchaseEP]
	,PR.[Note]
	,PR.[AdditionalPRAttributeId]
	,PR.[PurchasePlanId]
	,PR.[ProtocolNumber]
	,PR.[OwnerId]
	,FINR.[FinanceResources]
FROM [dbo].[PurchaseRequests] AS PR
LEFT JOIN (--AC для PR
			--последний AC для PR имеющих RH
			SELECT AC.RequestId, MAX(AC.Id) AS AuctionCycleId FROM [dbo].[AuctionCycles] AS AC
			INNER JOIN dbo.RequestHistories AS RH ON RH.RequestId = AC.RequestId
			GROUP BY AC.RequestId
			UNION ALL
			--последний AC в PC для PR не имеющих RH
			SELECT AC.RequestId, MAX(AC.Id) AS AuctionCycleId FROM dbo.ProtocolCzoItems AS PCi
			INNER JOIN dbo.AuctionCycles AS AC ON PCi.AuctionCycleId = AC.Id
			LEFT JOIN dbo.RequestHistories AS RH ON AC.RequestId = RH.RequestId
			WHERE RH.Id IS NULL
			GROUP BY AC.RequestId
			UNION ALL
			--последний AC не имеющий PC для PR не имеющих RH
			SELECT AC.RequestId, MAX(AC.Id) AS AuctionCycleId FROM dbo.AuctionCycles AS AC
			LEFT JOIN dbo.ProtocolCzoItems AS PCi ON PCi.AuctionCycleId = AC.Id
			LEFT JOIN dbo.RequestHistories AS RH ON RH.RequestId = AC.RequestId
			WHERE PCi.Id IS NULL AND RH.Id IS NULL
			GROUP BY AC.RequestId
		  ) AS AC ON AC.[RequestId] = PR.Id
LEFT JOIN [dbo].[v_RequestFinanceResources] AS FINR ON FINR.Id = PR.Id
LEFT JOIN ContractorsInlineByField AS Contr ON Contr.RequestId = PR.Id
UNION ALL
SELECT
	AC.AuctionCycleId
	,RH.[RequestId]
	,RH.Id
	,RH.[CodeActivityId]
	,RH.[CustomerOrganization]
	,RH.[CustomerSubdivision]
	,RH.[ProductTypeId]
	,RH.[Name]
	,RH.[OkvedId]
	,RH.[OkdpId]
	,RH.[ForSmallOrMiddle]
	,RH.[PurchaseCategory_Id]
	,RH.[IsInnovation]
	,RH.[PurchasePriceDocumentCode]
	,RH.[PlannedSumNotax]
	,RH.[PlannedSumWith30PercReductionNotax]
	,RH.[PlannedSumByNotificationNotax]
	,RH.[PlannedSumByNotificationTax]
	,RH.[PlannedPurchaseMethodCode]
	,RH.[CustomerOrganizer]
	,RH.[IsElectronicPurchase]
	,RH.[PublicationPlannedDate]
	,RH.[ExpDateKonProc]
	,RH.[SummingupTime]
	,ContrH.[ContractorName]
	,ContrH.[ContractorInn]
	,ContrH.[Kpp]
	,RH.[MinRequirementsForPurchaseGoods]
	,RH.[Okeiguid]
	,RH.[Qty]
	,RH.[Okato]
	,RH.[PlannedDateOfContract]
	,RH.[PlannedDateOfDelivery]
	,RH.[PlannedDateOfCompletion]
	,RH.[PlannedPurchaseYear]
	,RH.[AdditionalInfo]
	,RH.[IprYear]
	,RH.[InvestProjectCode]
	,RH.[InvestProjectName]
	,RH.[DateApprovalConstructionDocuments]
	,RH.[DateEndProject]
	,RH.[CostProject]
	,RH.[Mba]
	,RH.[Kilometer]
	,RH.[ProcessConnection]
	,RH.[CustomerFunctionalBlock]
	,RH.[PurchasePlanYear]
	,RH.[ReasonPurchaseEP]
	,RH.[Note]
	,RH.[AdditionalPRAttributeId]
	,RH.PurchasePlanId
	,RH.[ProtocolNumber]
	,PR.[OwnerId]
	,FINR.[FinanceResources]
FROM [dbo].[RequestHistories] AS RH
LEFT JOIN (--AC для RH
			SELECT Id AS [RequestHistoryId], AuctionCycleId FROM dbo.RequestHistories
		  ) AS AC ON AC.RequestHistoryId = RH.Id
LEFT JOIN [dbo].[v_RequestHistoryFinanceResource] AS FINR ON FINR.Id = RH.Id
LEFT JOIN dbo.PurchaseRequests AS PR ON PR.Id = RH.RequestId
LEFT JOIN ContractorHistsInLineByField AS ContrH ON ContrH.RequestHistoryId = RH.Id
), ShowingPR AS (
--показываемый PR для PR_RH_AC
SELECT PR.Id AS RequestId FROM dbo.PurchaseRequests AS PR
LEFT JOIN (--PR которые будут удалены протоколом ЦЗО
			SELECT AC.RequestId FROM dbo.ProtocolCzoItems AS PCi
			LEFT JOIN dbo.ProtocolCzoes AS PC ON PCi.Protocol_Id = PC.Id
			LEFT JOIN dbo.AuctionCycles AS AC ON PCi.AuctionCycleId = AC.Id
			WHERE PC.[Status] IN (1  --"На согласовании"
									,4  --"Согласовано"
									,2 --"Завершен"
			                     ,3)
				AND PCi.ItemType = 1  --"Исключение закупки из ПЗ"
				AND PCi.IsApproved = 1  --"Согласовано" = "Да"
			) AS RemovedByPC ON RemovedByPC.RequestId = PR.Id
WHERE PR.[Status] <> 210			 --Удалено
AND RemovedByPC.RequestId IS NULL
), ShowingRH AS (
--показываемый RH для PR_RH_AC и PC
--последний RH для PR
SELECT RH.RequestId,RH.Id AS RequestHistoryId FROM dbo.RequestHistories AS RH
INNER JOIN (--сортирую по AddedTime т.к. есть > 1 Version = 0 для RequestId
				SELECT RequestId,MAX(AddedTime) AS AddedTime FROM dbo.RequestHistories
				GROUP BY RequestId
			) AS LastRH ON RH.RequestId = LastRH.RequestId AND RH.AddedTime = LastRH.AddedTime
INNER JOIN (--PR в стадии "Корректировка"
			SELECT Id AS RequestId FROM dbo.PurchaseRequests
			WHERE [Stage] = 1  --"Корректировка"
			) AS Edited_PR ON Edited_PR.RequestId = RH.RequestId
LEFT JOIN (--PR в стадии "Корректировка" не включенные в PC
			SELECT Id AS RequestId FROM dbo.PurchaseRequests
			WHERE [Stage] = 1  --"Корректировка"
			AND [Status] <> 60 --"Ожидание подписания протокола ЦЗО"
			) AS Edited_PR_noPC ON Edited_PR_noPC.RequestId = RH.RequestId
LEFT JOIN (--PR в стадии "Корректировка" утвержденные в последнем PC
			SELECT AC.RequestId FROM dbo.ProtocolCzoItems AS PCi
			LEFT JOIN dbo.AuctionCycles AS AC ON PCi.AuctionCycleId = AC.Id
			INNER JOIN (--PR в стадии "Корректировка" включенные в PC
						SELECT Id AS RequestId FROM dbo.PurchaseRequests
						WHERE [Stage] = 1  --"Корректировка"
						AND [Status] = 60 --"Ожидание подписания протокола ЦЗО"
						) AS Edited_PR_hasPC ON Edited_PR_hasPC.RequestId = AC.RequestId
			INNER JOIN (--последний PC для PR
						SELECT AC.RequestId, MAX(PCi.Protocol_Id) AS Protocol_Id
						FROM dbo.ProtocolCzoItems AS PCi
						LEFT JOIN dbo.AuctionCycles AS AC ON PCi.AuctionCycleId = AC.Id
						GROUP BY AC.RequestId
						) AS LastPC_PR ON LastPC_PR.RequestId = AC.RequestId
										AND LastPC_PR.Protocol_Id = PCi.Protocol_Id
			LEFT JOIN dbo.ProtocolCzoes AS PC ON PCi.Protocol_Id = PC.Id
			WHERE PC.[Status] IN (1  --"На согласовании"
									,4  --"Согласовано"
									,2 --"Завершен"
			                        ,3)
				AND PCi.IsApproved = 1  --"Согласовано" = "Да"
			) AS Edited_PR_PCapproved ON Edited_PR_PCapproved.RequestId = RH.RequestId
WHERE Edited_PR_noPC.RequestId IS NOT NULL
OR Edited_PR_PCapproved.RequestId IS NULL
), ShowingPC AS (
--показываемый PC для PR_RH_AC
SELECT AC.RequestId, MAX(PCi.Protocol_Id) AS Protocol_Id
FROM [dbo].[ProtocolCzoItems] AS PCi
LEFT JOIN [dbo].[ProtocolCzoes] AS PC ON PCi.Protocol_Id = PC.Id
LEFT JOIN [dbo].[AuctionCycles] AS AC ON PCi.AuctionCycleId = AC.Id
WHERE PC.[Status] IN (1  --"На согласовании"
						,4  --"Согласовано"
						,2 --"Завершен"
                     , 3)
	AND PCi.IsApproved = 1  --"Согласовано" = "Да"
GROUP BY AC.RequestId
), ShowingAC AS (
--показываемый AC для PR_RH_AC
--последний AC согласованный в PC
SELECT AC.RequestId,MAX(AC.Id) AS AuctionCycleId FROM dbo.ProtocolCzoItems AS PCi
LEFT JOIN dbo.ProtocolCzoes AS PC ON PCi.Protocol_Id = PC.Id
LEFT JOIN dbo.AuctionCycles AS AC ON PCi.AuctionCycleId = AC.Id
WHERE PC.[Status] IN (1  --"На согласовании"
						,4  --"Согласовано"
						,2 --"Завершен"
                     ,3)
	AND PCi.IsApproved = 1  --"Согласовано" = "Да"
GROUP BY AC.RequestId
UNION ALL
SELECT ApprovedByImport.RequestId,ApprovedByImport.AuctionCycleId FROM
			(--первый AC для PR импортирвоанного в утвержденном состоянии
				SELECT AC.RequestId,MIN(AC.Id) AS AuctionCycleId FROM dbo.PurchaseRequests PR
				LEFT JOIN [dbo].[AuctionCycles] AS AC ON AC.RequestId = PR.Id
				WHERE (PR.IsImported = 1) AND (PR.SapId IS NULL OR PR.SapId = '') --выгрузки из сапа импортируются в неутвержденном состоянии
				GROUP BY AC.RequestId
			) AS ApprovedByImport
			LEFT JOIN (--PR согласованные в PC
						SELECT AC.RequestId FROM [dbo].[AuctionCycles] AS AC
						LEFT JOIN [dbo].[ProtocolCzoItems] AS PCi ON PCi.AuctionCycleId = AC.Id
						LEFT JOIN [dbo].[ProtocolCzoes] AS PC ON PC.Id = PCi.Protocol_Id
						WHERE PC.[Status] IN (1  --"На согласовании"
												,4  --"Согласовано"
												,2 --"Завершен"
						                     ,3 )
							AND PCi.IsApproved = 1  --"Согласовано" = "Да"
						GROUP BY AC.RequestId
						) AS ChangedByPC ON ChangedByPC.RequestId = ApprovedByImport.RequestId
			WHERE ChangedByPC.RequestId IS NULL
), LongTermPayments AS (
SELECT
	 LTP.AuctionCycleId
	,LTP.PaymentYear [CurrentYear]
	,LTP.PaymentSummWithTax [CurrentYearSummTax]
	,LTP_plus_1Y.PaymentYear [PlusOneYear]
	,LTP_plus_1Y.PaymentSummWithTax [PlusOneYearSummTax]
	,LTP_plus_2Y.PaymentYear [PlusTwoYear]
	,LTP_plus_2Y.PaymentSummWithTax [PlusTwoYearSummTax]
	,LTP_plus_3Y.PaymentYear [PlusThreeYear]
	,LTP_plus_3Y.PaymentSummWithTax [PlusThreeYearSummTax]
  FROM [dbo].[LongTermPurschasePayments] LTP
  LEFT JOIN [dbo].[LongTermPurschasePayments] AS LTP_plus_1Y ON LTP.AuctionCycleId = LTP_plus_1Y.AuctionCycleId AND LTP_plus_1Y.PaymentYear = LTP.PaymentYear + 1
  LEFT JOIN [dbo].[LongTermPurschasePayments] AS LTP_plus_2Y ON LTP.AuctionCycleId = LTP_plus_2Y.AuctionCycleId AND LTP_plus_2Y.PaymentYear = LTP.PaymentYear + 2
  LEFT JOIN [dbo].[LongTermPurschasePayments] AS LTP_plus_3Y ON LTP.AuctionCycleId = LTP_plus_3Y.AuctionCycleId AND LTP_plus_3Y.PaymentYear = LTP.PaymentYear + 3
  left join AuctionCycles AC on ltp.AuctionCycleId = AC.Id
  left join PurchaseRequests PR on AC.RequestId = PR.Id
  WHERE LTP.PaymentYear = 2020
), DepartmentFullName AS (
SELECT
	USERS.Id AS [UserId]
	,ROLES.FullName AS [GroupFullName]
FROM dbo.AspNetUsers AS USERS
LEFT JOIN dbo.AspNetUserRoles AS USERROLE ON USERROLE.UserId = USERS.Id
LEFT JOIN dbo.AspNetRoles AS ROLES ON ROLES.Id = USERROLE.RoleId
WHERE IsGroup = 1
AND ROLES.[Name] NOT LIKE N'%Согласование%'
), AdministrativeUnit AS (
SELECT Id, [Name] FROM dbo.Departments
WHERE [Type] = 2
AND [Name] LIKE N'ИА %'
), PR_protocol_395 as (
    select PurchaseRequests.Id
from ASUZD.dbo.ProtocolCzoes pc
left join ASUZD.dbo.ProtocolCzoItems pci on pc.Id = pci.Protocol_Id
left join ASUZD.dbo.AuctionCycles on pci.AuctionCycleId = AuctionCycles.Id
left join ASUZD.dbo.PurchaseRequests on AuctionCycles.RequestId = PurchaseRequests.Id
where pc.Id = 395
)

SELECT DISTINCT
	PR_RH_AC.RequestId
    , PR_RH_AC.PurchasePlanYear
	,PR_RH_AC.[Name] AS [LotName]
	,PR_RH_AC.Qty
	,PR_RH_AC.ForSmallOrMiddle
	,PCat.Code AS [PurchaseCategoryLiteral]
	,PR_RH_AC.IsInnovation
	,PR_RH_AC.FinanceResources
	,PR_RH_AC.PlannedPurchaseMethodCode
	,PR_RH_AC.CustomerOrganizer
	,PR_RH_AC.IsElectronicPurchase
	,PR_RH_AC.ReasonPurchaseEP
	,PR_RH_AC.ContractorName
	,PR_RH_AC.ContractorInn
	,PR_RH_AC.Kpp AS [ContractorKpp]
	,PR_RH_AC.[Name] AS [ContractSubject]
	,PR_RH_AC.PlannedPurchaseYear
	,PR_RH_AC.AdditionalInfo
	,PR_RH_AC.ProcessConnection AS [IPRProcessConnection]
	,PR_RH_AC.Note
	,PR_RH_AC.PlannedSumByNotificationNotax
	,PR_RH_AC.PlannedSumByNotificationTax
	,PR_RH_AC.PlannedSumNotax
	,PR_RH_AC.PlannedSumWith30PercReductionNotax
	,PR_RH_AC.IprYear
	,PR_RH_AC.DateApprovalConstructionDocuments
	,PR_RH_AC.Mba
	,PR_RH_AC.Kilometer
	,LTP.CurrentYear AS [LTPCurrentYear]
	,LTP.CurrentYearSummTax AS [LTPCurrentYearSummTax]
	,LTP.PlusOneYear AS [LTPPlusOneYear]
	,LTP.PlusOneYearSummTax AS [LTPPlusOneYearSummTax]
	,LTP.PlusTwoYear AS [LTPPlusTwoYear]
	,LTP.PlusTwoYearSummTax AS [LTPPlusTwoYearSummTax]
	,LTP.PlusThreeYear AS [LTPPlusThreeYear]
	,LTP.PlusThreeYearSummTax AS [LTPPlusThreeYearSummTax]
	,OKEI.code AS [OKEIcode]
	,OKEI.[name] AS [OKEIname]
	,OKATO.code AS [OKATOcode]
	,OKATO.[name] AS [OKATOname]
	,CA.[Name] AS [ActivityCode]
	,ORG.[Name] AS [CustomerOrganization]
	,PT.Code AS [ProductType]
	,OKVED2.code AS [OKVED2code]
	,OKDP2.code AS [OKDP2code]
	,PPD.[Name] AS [PurchasePriceDocument]
	,MINREQ.[Name] AS [MinRequirementsForPurchaseGoods]
	,APRA.[Description] AS [AdditionalPRAttrubute]
	,FB.[Name] [FunctionalBlockName]
	,IPR.ProjectStatus AS [IPRstatus]
	,CASE
		WHEN IPR.ObjectName IS NULL THEN PR_RH_AC.InvestProjectName
		ELSE IPR.ObjectName
	END AS [InvestProjectName]
	,CASE
		WHEN IPR.ObjectCode IS NULL THEN PR_RH_AC.InvestProjectCode
		ELSE IPR.ObjectCode
	END AS [InvestProjectCode]
	,IPR.ObjectStartYear AS [IPRStartProjectYear]
	,CASE
		WHEN IPR.ObjectEndYear IS NULL THEN CAST(YEAR(PR_RH_AC.DateEndProject) AS nvarchar(6))
		ELSE IPR.ObjectEndYear
	END AS [IPREndProjectYear]
	,CASE
		WHEN IPR.ObjectCashBalanceTax IS NULL THEN CAST(PR_RH_AC.CostProject AS nvarchar(20))
		ELSE IPR.ObjectCashBalanceTax
	END AS [IPRCostProject]
	,IPR.ObjectCashBalanceTax AS [IPRRestMoney]
	,CASE WHEN PR_RH_AC.DateEndProject <> '0001-01-01 00:00:00.0000000'
		THEN PR_RH_AC.DateEndProject END AS [IPRDateEndProject]
	,CASE WHEN PR_RH_AC.PublicationPlannedDate <> '0001-01-01 00:00:00.0000000'
		THEN PR_RH_AC.PublicationPlannedDate END AS [PublicationPlannedDate]
	,CASE WHEN PR_RH_AC.SummingupTime <> '0001-01-01 00:00:00.0000000'
		THEN PR_RH_AC.SummingupTime END AS [EndingTradePlannedDate]
	,CASE WHEN PR_RH_AC.PlannedDateOfContract <> '0001-01-01 00:00:00.0000000'
		THEN PR_RH_AC.PlannedDateOfContract END AS [PlannedDateOfContract]
	,CASE WHEN PR_RH_AC.PlannedDateOfDelivery <> '0001-01-01 00:00:00.0000000'
		THEN PR_RH_AC.PlannedDateOfDelivery END AS [PlannedDateOfDelivery]
	,CASE WHEN PR_RH_AC.PlannedDateOfCompletion <> '0001-01-01 00:00:00.0000000'
		THEN PR_RH_AC.PlannedDateOfCompletion END AS [PlannedDateOfCompletion]
	,CASE WHEN AU.Id IS NOT NULL
		THEN AU.[Name] + ' - ' + DEP.GroupFullName
		ELSE SUBD.[Name]
			END AS [CustomerSubdivision]
	,CASE WHEN PC.Id IS NULL
		THEN PP.[Name]
		ELSE CAST(PC.AdditionalNumber AS nvarchar) + N' от ' + CAST(CONVERT(VarChar(50), PC.CompleteTime, 104) AS nvarchar)
			END AS [ApprovingDocument]
	,CASE WHEN PC.Id IS NULL
		THEN PR_RH_AC.[ProtocolNumber]
		ELSE PCi.[NumberOos]
			END AS [NumberEIS]
FROM
PR_RH_AC
LEFT JOIN [dbo].[ProtocolCzoItems] AS PCi ON PR_RH_AC.AuctionCycleId = PCi.AuctionCycleId
LEFT JOIN [dbo].[ProtocolCzoes] AS PC ON PC.Id = PCi.Protocol_Id AND PC.[Status] IN (1  --"На согласовании"
																					,4  --"Согласовано"
																					,2 --"Завершен"
                                                                                    ,3)
																AND PCi.IsApproved = 1  --"Согласовано" = "Да"
LEFT JOIN ShowingPR ON PR_RH_AC.RequestId = ShowingPR.RequestId
LEFT JOIN ShowingRH ON ShowingRH.RequestId = PR_RH_AC.RequestId
LEFT JOIN ShowingPC ON PR_RH_AC.RequestId = ShowingPC.RequestId
LEFT JOIN ShowingAC ON PR_RH_AC.RequestId = ShowingAC.RequestId
LEFT JOIN dbo.Departments AS ORG ON PR_RH_AC.CustomerOrganization = ORG.Id
LEFT JOIN dbo.Departments AS SUBD ON PR_RH_AC.CustomerSubdivision = SUBD.Id
LEFT JOIN dbo.NsiCodeActivities AS CA ON PR_RH_AC.CodeActivityId = CA.Id
LEFT JOIN dbo.NsiProductTypes AS PT ON PR_RH_AC.ProductTypeId = PT.Id
LEFT JOIN dbo.NsiOkved2Item AS OKVED2 ON PR_RH_AC.OkvedId = OKVED2.Id
LEFT JOIN dbo.NsiOkdp2Item AS OKDP2 ON PR_RH_AC.OkdpId = OKDP2.id
LEFT JOIN dbo.NsiPurchasePriceDocuments AS PPD ON PR_RH_AC.PurchasePriceDocumentCode = PPD.Code
LEFT JOIN LongTermPayments AS LTP ON PR_RH_AC.AuctionCycleId = LTP.AuctionCycleId
LEFT JOIN dbo.NsiRequirementsForPurchaseGoods AS MINREQ ON PR_RH_AC.MinRequirementsForPurchaseGoods = MINREQ.Code
LEFT JOIN dbo.NsiOkeiItems AS OKEI ON PR_RH_AC.Okeiguid = OKEI.[guid]
LEFT JOIN dbo.NsiOkatoItems AS OKATO ON PR_RH_AC.Okato = OKATO.code
LEFT JOIN dbo.AdditionalPRAttributes AS APRA ON PR_RH_AC.AdditionalPRAttributeId = APRA.Id
LEFT JOIN AdministrativeUnit AS AU ON AU.Id = PR_RH_AC.CustomerSubdivision
LEFT JOIN DepartmentFullName AS DEP ON DEP.UserId = PR_RH_AC.OwnerId
LEFT JOIN dbo.NsiPurchaseCategories AS PCat ON PCat.Id = PR_RH_AC.PurchaseCategory_Id
LEFT JOIN dbo.PurchasePlans AS PP ON PP.Id = PR_RH_AC.PurchasePlanId --(SELECT * FROM dbo.PurchasePlans)
LEFT JOIN dbo.Departments AS FB ON FB.Id = PR_RH_AC.CustomerFunctionalBlock
LEFT JOIN IPRDataInlineByField IPR ON IPR.RequestId = PR_RH_AC.RequestId
inner join PR_protocol_395 on PR_RH_AC.RequestId = PR_protocol_395.Id
WHERE ORG.[Name] = N'ОАО "МРСК Урала"'




AND (
				ShowingPR.RequestId = PR_RH_AC.RequestId
	  AND (		ShowingAC.AuctionCycleId = PR_RH_AC.AuctionCycleId )

	  AND (
				ShowingRH.RequestHistoryId = PR_RH_AC.RequestHistoryId
			OR (ShowingRH.RequestHistoryId IS NULL AND PR_RH_AC.RequestHistoryId IS NULL)
		  )

	  AND (
				ShowingPC.Protocol_Id = PC.Id
			OR (ShowingPC.Protocol_Id IS NULL AND PC.Id IS NULL)
		  )

	  --OR (ShowingPR.RequestId = ? AND ShowingRH.RequestHistoryId = ? AND ShowingAC.Id = ? AND ShowingPC.Protocol_Id = ?)
	)

/*<debug>
AND PR_RH_AC.RequestId = 13628
</debug>*/

