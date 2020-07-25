SELECT     PRO.RequestId, PST.[Description], O.[Name], O.Code, O.StartYear, O.EndYear, O.EstimatedCostTax, O.CashBalanceTax
FROM         dbo.PurchaseRequestIprObjects PRO LEFT JOIN
                      dbo.InvestPrograms P ON P.Id = PRO.InvestProgramId LEFT JOIN
                      dbo.InvestProgramStatus PST ON PST.Id = P.StatusId LEFT JOIN
                      dbo.IprObjects O ON (O.Code = PRO.IprObjectCode) AND (O.InvestProgramId = PRO.InvestProgramId)), IPRDataInlineByField AS
    (SELECT     IPR.RequestId, STUFF
                                 ((SELECT     '; ' + C.[Description]
                                     FROM         IPRData AS C
                                     WHERE     C.RequestId = IPR.RequestId FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS [ProjectStatus], STUFF
                                 ((SELECT     '; ' + C.[Name]
                                     FROM         IPRData AS C
                                     WHERE     C.RequestId = IPR.RequestId FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS [ObjectName], STUFF
                                 ((SELECT     '; ' + C.[Code]
                                     FROM         IPRData AS C
                                     WHERE     C.RequestId = IPR.RequestId FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS [ObjectCode], STUFF
                                 ((SELECT     '; ' + CAST(C.[StartYear] AS nvarchar(6))
                                     FROM         IPRData AS C
                                     WHERE     C.RequestId = IPR.RequestId FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS [ObjectStartYear], STUFF
                                 ((SELECT     '; ' + CAST(C.[EndYear] AS nvarchar(6))
                                     FROM         IPRData AS C
                                     WHERE     C.RequestId = IPR.RequestId FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS [ObjectEndYear], STUFF
                                 ((SELECT     '; ' + CAST(C.[EstimatedCostTax] / 1000 AS nvarchar(20))
                                     FROM         IPRData AS C
                                     WHERE     C.RequestId = IPR.RequestId FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS [ObjectEstimatedCostTaxInThousand],
                             STUFF
                                 ((SELECT     '; ' + CAST(C.[CashBalanceTax] / 1000 AS nvarchar(20))
                                     FROM         IPRData AS C
                                     WHERE     C.RequestId = IPR.RequestId FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
                             AS [ObjectCashBalanceTaxInThousand]
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
*/ FROM
                              IPRData IPR
      GROUP BY IPR.RequestId), DistinctContractorsId AS
    (SELECT DISTINCT PurchaseRequestId
      FROM          dbo.Contractors), ContractorsInlineByField AS
    (SELECT     DCI.PurchaseRequestId AS [RequestId],
                                 (SELECT     SUM(C.PriceNoTax)
                                   FROM          dbo.Contractors AS C
                                   WHERE      C.PurchaseRequestId = DCI.PurchaseRequestId
                                   GROUP BY C.PurchaseRequestId) AS [FinalSumNoTax],
                                 (SELECT     SUM(C.PriceTax)
                                   FROM          dbo.Contractors AS C
                                   WHERE      C.PurchaseRequestId = DCI.PurchaseRequestId
                                   GROUP BY C.PurchaseRequestId) AS [FinalSumTax], STUFF
                                 ((SELECT     '; ' + CASE WHEN C.[Name] IS NULL THEN N'нет данных' ELSE C.[Name] END
                                     FROM         dbo.Contractors AS C
                                     WHERE     C.PurchaseRequestId = DCI.PurchaseRequestId FOR XML PATH('')), 1, 2, '') AS [ContractorName], STUFF
                                 ((SELECT     '; ' + CASE WHEN C.[Inn] IS NULL THEN N'нет данных' ELSE C.[Inn] END
                                     FROM         dbo.Contractors AS C
                                     WHERE     C.PurchaseRequestId = DCI.PurchaseRequestId FOR XML PATH('')), 1, 2, '') AS [ContractorInn], STUFF
                                 ((SELECT     '; ' + CASE WHEN C.[Kpp] IS NULL THEN N'нет данных' ELSE C.[Kpp] END
                                     FROM         dbo.Contractors AS C
                                     WHERE     C.PurchaseRequestId = DCI.PurchaseRequestId FOR XML PATH('')), 1, 2, '') AS [Kpp]
      FROM          DistinctContractorsId AS DCI), DistinctContractorHistsId AS
    (SELECT DISTINCT RequestHistoryId
      FROM          dbo.ContractorHists), ContractorHistsInLineByField AS
    (SELECT     DCHI.RequestHistoryId,
                                 (SELECT     SUM(CH.PriceNoTax)
                                   FROM          dbo.ContractorHists AS CH
                                   WHERE      CH.RequestHistoryId = DCHI.RequestHistoryId
                                   GROUP BY CH.RequestHistoryId) AS [PlannedSumByNotificationNotax],
                                 (SELECT     SUM(CH.PriceTax)
                                   FROM          dbo.ContractorHists AS CH
                                   WHERE      CH.RequestHistoryId = DCHI.RequestHistoryId
                                   GROUP BY CH.RequestHistoryId) AS [PlannedSumByNotificationTax], STUFF
                                 ((SELECT     '; ' + CASE WHEN CH.[Name] IS NULL THEN N'нет данных' ELSE CH.[Name] END
                                     FROM         dbo.ContractorHists AS CH
                                     WHERE     CH.RequestHistoryId = DCHI.RequestHistoryId FOR XML PATH('')), 1, 2, '') AS [ContractorName], STUFF
                                 ((SELECT     '; ' + CASE WHEN CH.[Inn] IS NULL THEN N'нет данных' ELSE CH.[Inn] END
                                     FROM         dbo.ContractorHists AS CH
                                     WHERE     CH.RequestHistoryId = DCHI.RequestHistoryId FOR XML PATH('')), 1, 2, '') AS [ContractorInn], STUFF
                                 ((SELECT     '; ' + CASE WHEN CH.[Kpp] IS NULL THEN N'нет данных' ELSE CH.[Kpp] END
                                     FROM         dbo.ContractorHists AS CH
                                     WHERE     CH.RequestHistoryId = DCHI.RequestHistoryId FOR XML PATH('')), 1, 2, '') AS [Kpp]
      FROM          DistinctContractorHistsId AS DCHI)
    SELECT     ROW_NUMBER() OVER (PARTITION BY CorrectedReport.[RequestId], [AuctionCycleId]
     ORDER BY [AuctionCycleId] ASC, CorrectedReport.[IsWinner] DESC) AS PurchaseRowIndexNumber, CorrectedReport.[RequestId], CorrectedReport.[AuctionCycleId],
CorrectedReport.[PurchasePlanYear], CorrectedReport.[PurchaseCreatorFullName], CorrectedReport.[PurchaserFullName], CorrectedReport.[TZCreatorFullName],
CorrectedReport.[ApprovedTime], CorrectedReport.[Status], CorrectedReport.[Description], (CASE WHEN CorrectedReport.[Description] LIKE N'%Торги не состоялись%' THEN CAST(1 AS bit)
 ELSE CAST(0 AS bit) END) AS [IsUnsuccessfulTrade]/*Закупка не состоялась*/ ,
(CASE WHEN CorrectedReport.[Description] LIKE N'%Торги не состоялись%' THEN CorrectedReport.SummingupTime ELSE NULL END)
AS [UnsuccessfulTradeEndingDate]/*Дата признания несостоявшейся*/ ,
(CASE CorrectedReport.[Description] WHEN N'Торги не состоялись п. 7.5.4. (7.5.5. по стандарту 2018 г.)' THEN CorrectedReport.[Description] WHEN N'Торги не состоялись п. 7.5.7. (7.5.8. по стандарту 2018 г.)'
 THEN CorrectedReport.[Description] ELSE NULL END) AS [ReasonOfUnsuccessfulTrade]/*Причина признания несостоявшейся*/ , CorrectedReport.[Stage], CorrectedReport.[StageDescription],
CorrectedReport.[ProtocolNumber]/*Номер позиции плана*/ , CorrectedReport.[Name], CorrectedReport.[PurchaseNumber], CorrectedReport.[LotNumber],
CorrectedReport.[FinanceResources], CorrectedReport.[ProductTypeName], CorrectedReport.[FancyProductTypeName], CorrectedReport.[CustomerOrganizer],
CorrectedReport.[CustomerOrganizationName]/*Организация заказчик*/ , CorrectedReport.[CustomerSubdivisionName], CorrectedReport.[CustomerFunctionalBlockName],
CorrectedReport.[PlannedSumByNotificationTax], CorrectedReport.[PlannedSumByNotificationNotax], CorrectedReport.[PlannedSumWith30PercReductionNotax],
CorrectedReport.[PlannedSumWith30PercReductionTax], CorrectedReport.[PriceTzNoTax], CorrectedReport.[PriceTzTax], CorrectedReport.IsSinglePrice,
CorrectedReport.[TechnicalProjectRequestOrder]/*Порядковый номер лота в извещении*/ , CorrectedReport.[PlannedPurchaseMethodCode],
CorrectedReport.[FancyPlannedPurchaseMethodCode],
(CASE WHEN [Description] = N'Торги не состоялись п. 7.5.4. (7.5.5. по стандарту 2018 г.)' THEN [FancyPlannedPurchaseMethodCode] + N' ЕП' WHEN [Description] = N'Торги не состоялись п. 7.5.7. (7.5.8. по стандарту 2018 г.)'
 THEN [FancyPlannedPurchaseMethodCode] + N' ЕП' ELSE [FancyPlannedPurchaseMethodCode] END) AS [Fancy2PlannedPurchaseMethodCode], CorrectedReport.[TZid],
CorrectedReport.[TZName], CorrectedReport.[OKVED2CODE], CorrectedReport.[OKDP2CODE], CorrectedReport.[ProtocolCZO], CorrectedReport.[PublicationPlannedDate],
CorrectedReport.[ExpDateKonProc], CorrectedReport.[IsElectronicPurchase], CorrectedReport.[ForSmallOrMiddle], CorrectedReport.[ExpNumberKonProc],
CorrectedReport.[ETPName], CorrectedReport.[ETPUrl], CorrectedReport.[ExpNumberOnGovKonProc]/*Номер извещения в ЕИС*/ , CorrectedReport.[ExpEnvelopeOpeningTime],
CorrectedReport.[ExpCountParticipiantsRecievedDocs], CorrectedReport.[ExpCountParticipiantsApplied], CorrectedReport.[ParticipantName], CorrectedReport.[PriceNoTax],
CorrectedReport.[PriceTax], CorrectedReport.[Inn], CorrectedReport.[Kpp]/*КПП участника*/ , CorrectedReport.[IsSmpExtended], CorrectedReport.[Rejected],
CorrectedReport.[ParticipantAddress], CorrectedReport.[ParticipantBetDateTime], CorrectedReport.[IsRejected], CorrectedReport.[RejectedReason], CorrectedReport.[IsWinner],
CorrectedReport.[DateOfPassDocumentsForExamination], CorrectedReport.[UnitResponsibleForExamination], CorrectedReport.[DateReceipExpertOpinion],
    (SELECT     TOP 1 COUNT(*) OVER (PARTITION BY [AuctionCycleId]) AS ExpertiseAmount
      FROM          [dbo].[AuctionStages]
      WHERE      IsNeedExpertise = 1 AND [AuctionCycleId] = CorrectedReport.[AuctionCycleId]) AS [ExpertiseAmount], CorrectedReport.[DateReceiptOfDocumentsUponReRequest],
    (SELECT     TOP 1 COUNT(*) OVER (PARTITION BY [AuctionCycleId]) AS ReRequestAmount
      FROM          [dbo].[AuctionStages]
      WHERE      IsNeedReRequest = 1 AND [AuctionCycleId] = CorrectedReport.[AuctionCycleId]) AS [ReRequestAmount], CorrectedReport.[DateStartRebidding],
CorrectedReport.[DateStopRebidding], CorrectedReport.[RebiddingAmount], CorrectedReport.[FancyRebiddingAmount], CorrectedReport.[SumAfterRebiddingNoTax],
CorrectedReport.[SumAfterRebiddingTax], CorrectedReport.[FinalSumNoTax], CorrectedReport.[FinalSumTax], CorrectedReport.[WinnerName],
CorrectedReport.[CountContractorsMspAtWinner], CorrectedReport.[TotalSumContractorsMspAtWinner], CorrectedReport.[PlannedSummingupTime],
CorrectedReport.[SummingupTime], CorrectedReport.[NumberOfFinalProtocol], CorrectedReport.[DateSendFinalProtocolToProfileDepartmentChief],
CorrectedReport.[CodeActivityName], CorrectedReport.[CodeActivityFancyName], CorrectedReport.[PurchaseCategory_Id], CorrectedReport.[PurchaseCategoryName],
CorrectedReport.[FancyPurchaseCategory_Id], CorrectedReport.[FancyIsInnovation], CorrectedReport.[PurchasePriceDocumentName], CorrectedReport.[PlannedSumNotax],
CorrectedReport.[IsNotInASUZD_1], CorrectedReport.[IsNotInASUZD_2], CorrectedReport.[IsNotInASUZD_3], CorrectedReport.[IsNotInASUZD_4],
CorrectedReport.[IsNotInASUZD_5], CorrectedReport.[IsNotInASUZD_6], CorrectedReport.[IsNotInASUZD_7], CorrectedReport.[ReasonPurchaseEP],
CorrectedReport.[DocumentDate], CorrectedReport.[DocumentNumber], CorrectedReport.[NameOfOrgan], CorrectedReport.[PlannedDateOfContract],
CorrectedReport.[PlannedDateOfDelivery], CorrectedReport.[AdditionalInfo], CorrectedReport.[Note], CorrectedReport.[GroupName], CorrectedReport.[PR_ApprovedByCZODate],
CorrectedReport.[DatePurchaseWasIncludedAtPlan], CorrectedReport.[FancyIsInIpr]/*<ИПР>*/ , IPR.ProjectStatus[InvestProjectStatus],
CASE WHEN (CorrectedReport.[InvestProjectName] IS NULL) OR
(CorrectedReport.[InvestProjectName] = '') THEN IPR.ObjectName ELSE CorrectedReport.[InvestProjectName] END AS [InvestProjectName], CorrectedReport.[IsNotInASUZD_8],
CASE WHEN (CorrectedReport.[FancyDateEndProject] IS NULL) THEN IPR.ObjectEndYear ELSE CONVERT(varchar, CorrectedReport.[FancyDateEndProject], 104)
END AS [FancyDateEndProject], CorrectedReport.[FancyMba], CorrectedReport.[FancyKilometer], CASE WHEN CorrectedReport.[FancyIprYear] IS NULL
THEN IPR.ObjectStartYear ELSE CAST(CorrectedReport.[FancyIprYear] AS nvarchar(20)) END AS [FancyIprYear], CASE WHEN CorrectedReport.[FancyInvestProjectCode] IS NULL
THEN IPR.ObjectCode ELSE CorrectedReport.[FancyInvestProjectCode] END AS [FancyInvestProjectCode], CorrectedReport.[FancyDateApprovalConstructionDocuments],
CASE WHEN (CorrectedReport.[FancyCostProject] IS NULL) OR
(CorrectedReport.[FancyCostProject] = 0.00) THEN IPR.ObjectCashBalanceTaxInThousand ELSE CAST(CorrectedReport.[FancyCostProject] AS nvarchar(20))
END AS [FancyCostProject]/*</ИПР>*/ , CorrectedReport.[FancyMegaWatt], CorrectedReport.[IsProcessConnection]/*Технологическое присоединение (Да/Нет)*/ ,
CorrectedReport.[IsPrivilegedProcessConnection], CorrectedReport.[ExpWerePpriceNegotiations], CorrectedReport.[WerePpriceNegotiations],
CorrectedReport.[ExpWinnerSumOnPpriceNegotiationsNoTax], CorrectedReport.[ExpWinnerSumOnPpriceNegotiationsTax], CorrectedReport.[PR_SendToApprovalTime],
CorrectedReport.[PR_ApprovedBySecretaryCZOTime], CorrectedReport.[TP_SendToApprovalTime], CorrectedReport.[TP_ApprovedTime],
CorrectedReport.[PurchaseMinReqCode], CorrectedReport.[PurchaseMinReqName], CorrectedReport.[OKEIcode], CorrectedReport.[OKEIsymbol], CorrectedReport.[OKEIname],
CorrectedReport.[Qty], CorrectedReport.[OKATOcode], CorrectedReport.[OKATOname], CorrectedReport.[PlannedDateOfCompletion], CorrectedReport.[PlannedPurchaseYear],
CorrectedReport.[PurchaseMethodCodeOnEIS], CorrectedReport.[AdditionalPRAttributeDescription]
FROM         (SELECT     RawReport.[RequestId], [AuctionCycleId], PurchasePlanYear/*,[AuctionStageId]*/ , PurchaseCreatorFullName, PurchaserFullName, TZCreatorFullName,
                                              [ApprovedTime], RawReport.[Status], (CASE WHEN (RawReport.[Status] = 185) OR
                                              (RawReport.[Status] = 180 AND ExpCountParticipiantsApplied = 1) THEN N'Торги не состоялись п. 7.5.4. (7.5.5. по стандарту 2018 г.)' WHEN (RawReport.[Status] = 186) OR
                                              (RawReport.[Status] = 180 AND CountParticipiantsRejected = ExpCountParticipiantsApplied - 1)
                                              THEN N'Торги не состоялись п. 7.5.7. (7.5.8. по стандарту 2018 г.)' ELSE ST.[Description] END) AS [Description], RawReport.[Stage],
                                              STG.[Description] AS [StageDescription], ProtocolNumber, RawReport.[Name], PurchaseNumber, LotNumber, FinanceResources, [ProductTypeName],
                                              [FancyProductTypeName], [CustomerOrganizer], [CustomerOrganizationName], [CustomerSubdivisionName], [CustomerFunctionalBlockName],
                                              PlannedSumByNotificationTax, RawReport.PlannedSumByNotificationNotax, [PlannedSumWith30PercReductionNotax],
                                              [PlannedSumWith30PercReductionTax], PriceTzNoTax, PriceTzTax, RawReport.IsSinglePrice, [TechnicalProjectRequestOrder],
                                              PlannedPurchaseMethodCode/*по факту теперь не может отличаться от плана	*/ , [TZid], [TZName], OKVED2CODE, OKDP2CODE, ProtocolCZO,
                                              PublicationPlannedDate, [ExpDateKonProc], IsElectronicPurchase, ForSmallOrMiddle, ExpNumberKonProc, ETPName, ETPUrl, ExpNumberOnGovKonProc,
                                              ExpEnvelopeOpeningTime, ExpCountParticipiantsRecievedDocs, ExpCountParticipiantsApplied/*,CountParticipiantsRejected*/ ,
                                              (CASE WHEN [PlannedPurchaseMethodCode] IN (N'ЕП', N'ЗПП') THEN SoleSupplier.ContractorName ELSE ParticipantName END) AS ParticipantName,
                                              (CASE WHEN [PlannedPurchaseMethodCode] IN (N'ЕП', N'ЗПП') THEN SoleSupplier.FinalSumNoTax ELSE PriceNoTax END) PriceNoTax,
                                              (CASE WHEN [PlannedPurchaseMethodCode] IN (N'ЕП', N'ЗПП') THEN SoleSupplier.FinalSumTax ELSE RawReport.PriceTax END) AS PriceTax,
                                              (CASE WHEN [PlannedPurchaseMethodCode] IN (N'ЕП', N'ЗПП') THEN SoleSupplier.ContractorInn ELSE Inn END) AS Inn,
                                              (CASE WHEN [PlannedPurchaseMethodCode] IN (N'ЕП', N'ЗПП') THEN SoleSupplier.Kpp ELSE RawReport.Kpp END) AS Kpp, IsSmpExtended, Rejected,
                                              [ParticipantAddress], [ParticipantBetDateTime], [IsRejected], [RejectedReason], [IsWinner], DateOfPassDocumentsForExamination,
                                              UnitResponsibleForExamination, DateReceipExpertOpinion, DateReceiptOfDocumentsUponReRequest, DateStartRebidding, DateStopRebidding,
                                              RebiddingAmount, FancyRebiddingAmount, SumAfterRebiddingNoTax, SumAfterRebiddingTax, (CASE WHEN [PlannedPurchaseMethodCode] IN (N'ЕП', N'ЗПП')
                                              THEN SoleSupplier.FinalSumNoTax ELSE RawReport.FinalSumNoTax END) AS FinalSumNoTax, (CASE WHEN [PlannedPurchaseMethodCode] IN (N'ЕП',
                                              N'ЗПП') THEN SoleSupplier.FinalSumTax ELSE RawReport.FinalSumTax END) AS FinalSumTax, (CASE WHEN [PlannedPurchaseMethodCode] IN (N'ЕП', N'ЗПП')
                                              THEN SoleSupplier.ContractorName ELSE WinnerName END) AS WinnerName, CountContractorsMspAtWinner, TotalSumContractorsMspAtWinner,
                                              [PlannedSummingupTime], [SummingupTime], NumberOfFinalProtocol,
                                              DateSendFinalProtocolToProfileDepartmentChief/*Наименование участника с которым заключается договор по п. 7.5.8.Стандарта --детект по косвенным признакам*/ , [CodeActivityName],
                                              [CodeActivityFancyName] = (CASE WHEN [CodeActivityCode] = 1 THEN N'новое строительство' WHEN [CodeActivityCode] = 2 THEN N'реконструкция и техперевооружение' WHEN [CodeActivityCode]
                                               = 3 THEN N'энергоремонтное (ремонтное) производство, техническое обслуживание' WHEN [CodeActivityCode] = 4 THEN N'ИТ-Закупки' WHEN [CodeActivityCode] = 5 THEN N'НИОКР' WHEN [CodeActivityCode]
                                               = 6 THEN N'Консультационные услуги' ELSE N'Прочие закупки' END), [PurchaseCategory_Id], [PurchaseCategoryName], [FancyPurchaseCategory_Id], [FancyIsInnovation],
                                              [PurchasePriceDocumentName], [PlannedSumNotax], [FancyPlannedPurchaseMethodCode],
                                              N'информацию предоставляет ПО' AS [IsNotInASUZD_1]/*N'Объем обязательств (по финансированию), приходящийся на текущий год по итогам закупки, тыс. руб. без НДС'*/ ,
                                              N'информацию предоставляет ПО' AS [IsNotInASUZD_2]/*N'Субподрядные договоры, заключенные победителем (ЕКУ, ЕИ) закупки с СМП - Кол-во договоров, шт.'*/ ,
                                              N'информацию предоставляет ПО' AS [IsNotInASUZD_3]/*N'Субподрядные договоры, заключенные победителем (ЕКУ, ЕИ) закупки с СМП - Общая сумма, тыс. руб. без НДС'*/ ,
                                              N'информацию предоставляет ПО' AS [IsNotInASUZD_4]/*N'Дата заключения договора (чч.мм.гггг) - Факт'*/ ,
                                              N'информацию предоставляет ПО' AS [IsNotInASUZD_5]/*N'Дата начала поставки товара, выполнения работ, оказания услуг по договору (чч.мм.гггг)'*/ ,
                                              N'информацию предоставляет ПО' AS [IsNotInASUZD_6]/*N'Дата исполнения поставщиком (подрядчиком, исполнителем) обязательств по договору (чч.мм.гггг)'*/ ,
                                              N'информацию предоставляет ПО' AS [IsNotInASUZD_7]/*N'Причины невыполнения сроков'*/ , N'информацию предоставляет ПО' AS [IsNotInASUZD_8]/*N'Данные из ИПР - Наименование объекта генерации/ программы развития'*/ ,
                                              [ReasonPurchaseEP], DocumentDate, DocumentNumber, NameOfOrgan, [PlannedDateOfContract], [PlannedDateOfDelivery], RawReport.[Note],
                                              RawReport.[AdditionalInfo], [GroupName], [PR_ApprovedByCZODate], [DatePurchaseWasIncludedAtPlan], RawReport.[FancyIsInIpr],
                                              RawReport.[FancyIprYear], RawReport.[FancyInvestProjectCode], RawReport.[InvestProjectName], RawReport.[FancyDateApprovalConstructionDocuments],
                                              RawReport.[FancyDateEndProject], RawReport.[FancyCostProject], RawReport.[FancyMegaWatt], RawReport.[FancyMba], RawReport.[FancyKilometer],
                                              RawReport.[IsProcessConnection], RawReport.[IsPrivilegedProcessConnection], RawReport.[ExpWerePpriceNegotiations],
                                              RawReport.WerePpriceNegotiations, RawReport.[ExpWinnerSumOnPpriceNegotiationsNoTax], RawReport.[ExpWinnerSumOnPpriceNegotiationsTax],
                                              RawReport.[PurchaseMinReqCode], RawReport.[PurchaseMinReqName], RawReport.[OKEIcode], RawReport.[OKEIsymbol], RawReport.[OKEIname],
                                              RawReport.[Qty], RawReport.[OKATOcode], RawReport.[OKATOname], RawReport.[PlannedDateOfCompletion], RawReport.[PlannedPurchaseYear],
                                              RawReport.[PurchaseMethodCodeOnEIS], RawReport.[AdditionalPRAttributeDescription], PRAfirst.CreationTime AS [PR_SendToApprovalTime],
                                              PRAlast.CompletedTime AS [PR_ApprovedBySecretaryCZOTime], TPAfirst.CreationTime AS [TP_SendToApprovalTime],
                                              TPAlast.CompleteTime AS [TP_ApprovedTime]
                       FROM          (SELECT     UPR.[RequestId], UPR.PurchasePlanYear, UPR.AuctionCycleId, UPR.[Name], UPR.[PlannedSumWith30PercReductionNotax],
                                                                      UPR.[PlannedSumWith30PercReductionTax], UPR.[CustomerOrganization] AS [CustomerOrganizationName],
                                                                      UPR.CustomerSubdivision AS [CustomerSubdivisionName], UPR.CustomerFunctionalBlock AS [CustomerFunctionalBlockName],
                                                                      UPR.[PlannedSumNotax], UPR.SummingupTime AS [PlannedSummingupTime], UPR.[ReasonPurchaseEP], UPR.[PlannedDateOfContract],
                                                                      UPR.[PlannedDateOfDelivery], UPR.[AdditionalInfo], UPR.[Note], UPR.[ExpWerePpriceNegotiations], AC.WerePpriceNegotiations,
                                                                      UPR.[ExpWinnerSumOnPpriceNegotiationsNoTax], UPR.[ExpWinnerSumOnPpriceNegotiationsTax],
                                                                      (CASE WHEN UPR.IsInIpr = 1 THEN N'Да' ELSE N'Нет' END) AS [FancyIsInIpr], (CASE WHEN UPR.IsInIpr = 1 THEN UPR.[IprYear] END)
                                                                      AS [FancyIprYear], (CASE WHEN UPR.IsInIpr = 1 THEN UPR.[InvestProjectCode] END) AS [FancyInvestProjectCode], UPR.[InvestProjectName],
                                                                      (CASE WHEN UPR.IsInIpr = 1 THEN (CASE WHEN UPR.[IsNeedConstructionDocuments] = 1 THEN N'Не требуется' WHEN UPR.[IsApprovedConstructionDocuments]
                                                                       = 1 THEN N'Не утверждена' ELSE UPR.[DateApprovalConstructionDocuments] END) END) AS [FancyDateApprovalConstructionDocuments],
                                                                      (CASE WHEN UPR.IsInIpr = 1 THEN CASE WHEN UPR.DateEndProject > '0001-01-01 00:00:00.0000000' THEN UPR.DateEndProject END END)
                                                                      AS [FancyDateEndProject], (CASE WHEN UPR.IsInIpr = 1 THEN UPR.[CostProject] END) AS [FancyCostProject],
                                                                      (CASE WHEN UPR.IsInIpr = 1 THEN CASE WHEN UPR.[MegaWatt] > 0 THEN UPR.[MegaWatt] END END) AS [FancyMegaWatt],
                                                                      (CASE WHEN UPR.IsInIpr = 1 THEN CASE WHEN UPR.Mba > 0 THEN UPR.Mba END END) AS [FancyMba],
                                                                      (CASE WHEN UPR.IsInIpr = 1 THEN CASE WHEN UPR.Kilometer > 0 THEN UPR.Kilometer END END) AS [FancyKilometer],
                                                                      (CASE WHEN UPR.ProcessConnection = 1 THEN N'Да' ELSE N'Нет' END) AS [IsProcessConnection],
                                                                      (CASE WHEN UPR.[PrivilegedProcessConnection] = 1 THEN N'Да' ELSE N'Нет' END) AS [IsPrivilegedProcessConnection],
                                                                      Groups.[Name] AS [GroupName], GCZO.DocumentDate, GCZO.DocumentNumber, GCZO.NameOfOrgan,
                                                                      PPD.[Name] AS [PurchasePriceDocumentName], (CASE WHEN UPR.[IsImported] = 0 THEN (N'ВЗ ' + UPR.PlannedPurchaseMethodCode)
                                                                      ELSE UPR.PlannedPurchaseMethodCode END) AS [FancyPlannedPurchaseMethodCode],
                                                                      (CASE WHEN UPR.[IsInnovation] = 0 THEN N'Нет' ELSE N'Да' END) AS [FancyIsInnovation], UPR.PurchaseCategory_Id,
                                                                      PCategory.[Name] AS [PurchaseCategoryName],
                                                                      (CASE WHEN UPR.PurchaseCategory_Id = 0 THEN N'0' WHEN UPR.PurchaseCategory_Id = 1 THEN N'а' WHEN UPR.PurchaseCategory_Id = 2 THEN
                                                                       N'б' WHEN UPR.PurchaseCategory_Id = 3 THEN N'в' WHEN UPR.PurchaseCategory_Id = 4 THEN N'г' WHEN UPR.PurchaseCategory_Id = 5 THEN
                                                                       N'д' WHEN UPR.PurchaseCategory_Id = 6 THEN N'е' WHEN UPR.PurchaseCategory_Id = 7 THEN N'ж' WHEN UPR.PurchaseCategory_Id = 8 THEN
                                                                       N'з' WHEN UPR.PurchaseCategory_Id = 9 THEN N'и' WHEN UPR.PurchaseCategory_Id = 10 THEN N'к' WHEN UPR.PurchaseCategory_Id = 11 THEN
                                                                       N'л' WHEN UPR.PurchaseCategory_Id = 12 THEN N'м' WHEN UPR.PurchaseCategory_Id = 13 THEN N'н' WHEN UPR.PurchaseCategory_Id = 14 THEN
                                                                       N'о' WHEN UPR.PurchaseCategory_Id = 15 THEN N'п' WHEN UPR.PurchaseCategory_Id = 16 THEN N'р' WHEN UPR.PurchaseCategory_Id = 17 THEN
                                                                       N'с' WHEN UPR.PurchaseCategory_Id = 18 THEN N'т' WHEN UPR.PurchaseCategory_Id = 19 THEN N'у' WHEN UPR.PurchaseCategory_Id = 20 THEN
                                                                       N'ф' WHEN UPR.PurchaseCategory_Id = 21 THEN N'х' WHEN UPR.PurchaseCategory_Id = 22 THEN N'ц' WHEN UPR.PurchaseCategory_Id = 23 THEN
                                                                       N'ч' WHEN UPR.PurchaseCategory_Id = 24 THEN N'ш' WHEN UPR.PurchaseCategory_Id = 25 THEN N'щ' WHEN UPR.PurchaseCategory_Id = 26 THEN
                                                                       N'э' WHEN UPR.PurchaseCategory_Id = 27 THEN N'ю' ELSE N'не удалось определить' END) AS [FancyPurchaseCategory_Id],
                                                                      (CASE WHEN (NOT EXISTS
                                                                          (SELECT     TOP 1 *
                                                                            FROM          [dbo].[RequestHistories]
                                                                            WHERE      [RequestId] = UPR.[RequestId])) AND (NOT EXISTS
                                                                          (SELECT     TOP 1 *
                                                                            FROM          dbo.PurchaseRequests AS ONtrade
                                                                            WHERE      ONtrade.Stage IN (4/*N'Работа с ЭТП'*/ , 6/*N'Одобрение заключения договора с ЕП'*/ , 7/*N'Одобрено заключение договора с ЕП'*/ , 8/*N'Отказ заключения договора с ЕП'*/ ) AND
                                                                                                   Id = UPR.RequestId)) AND
                                                                          (SELECT     COUNT(*)
                                                                            FROM          [dbo].[AuctionCycles] AS AC
                                                                            WHERE      AC.[RequestId] = UPR.[RequestId]) > 1 AND
                                                                          (SELECT     COUNT(*)
                                                                            FROM          [dbo].[AuctionCycles] AS AC
                                                                            WHERE      AC.[RequestId] = UPR.[RequestId] AND AC.IsActive = 1 AND AC.CompletedTime = '0001-01-01 00:00:00.0000000') = 1 AND
                                                                          (SELECT     COUNT(*)
                                                                            FROM          [dbo].[AuctionCycles] AS AC
                                                                            WHERE      AC.[RequestId] = UPR.[RequestId] AND NOT AC.SummingupTime = '0001-01-01 00:00:00.0000000') > 0 THEN
                                                                          (SELECT     [Status]
                                                                            FROM          [dbo].[PurchaseRequests] AS PR
                                                                            WHERE      PR.Id = UPR.[RequestId]) /*N'Нужно брать Status из предыдущего аукционного цикла'*/ WHEN (UPR.[Status] = - 1) THEN
                                                                          (SELECT     [Status]
                                                                            FROM          dbo.PurchaseRequests
                                                                            WHERE      Id = UPR.[RequestId]) ELSE UPR.[Status] /*N'Status менять не нужно'*/ END) AS [Status], UPR.[Stage], UPR.[Qty],
                                                                      UPR.[PlannedDateOfCompletion], UPR.[PlannedPurchaseYear], MinReq.[Code] AS [PurchaseMinReqCode],
                                                                      MinReq.[Name] AS [PurchaseMinReqName], OKEI.[code] AS [OKEIcode], OKEI.[symbol] AS [OKEIsymbol], OKEI.[name] AS [OKEIname],
                                                                      OKATO.code AS [OKATOcode], OKATO.[name] AS [OKATOname], PurMethod.[NsiId] AS [PurchaseMethodCodeOnEIS],
                                                                      PrTYPE.[Code] AS [ProductTypeName], LEFT(PrTYPE.[Code], PATINDEX('%[ ]-[^0-9.-]%', PrTYPE.[Code])) AS [FancyProductTypeName],
                                                                      AST.Id AS [AuctionStageId], (Groups.LastName + ' ' + Groups.FirstName + ' ' + Groups.MiddleName) AS PurchaseCreatorFullName,
                                                                      (Purchaser.LastName + ' ' + Purchaser.FirstName + ' ' + Purchaser.MiddleName) AS PurchaserFullName,
                                                                      (TZCreator.LastName + ' ' + TZCreator.FirstName + ' ' + TZCreator.MiddleName) AS TZCreatorFullName,
                                                                      TZ.[ApprovedTime]/*основание для продления сроков - нет в АСУЗД	*/ , ProtocolNumber, PurchaseNumber, LotNumber,
                                                                      FinanceResources, CustomerOrganizer, PlannedSumByNotificationTax, PlannedSumByNotificationNotax, TZR.PriceTzNoTax, TZR.PriceTzTax,
                                                                      TZR.[Order] AS [TechnicalProjectRequestOrder], PlannedPurchaseMethodCode/*по факту теперь не может отличаться от плана							*/ ,
                                                                      UPR.[OwnerOrganizationId], TZ.Id AS [TZid], TZ.[Name] AS [TZName], TZ.IsSinglePrice, OKVED.code AS OKVED2CODE,
                                                                      OKDP.code AS OKDP2CODE, '(id-' + CAST(ProtocolCzoId AS nvarchar) + ') ' + N'Протокол согласования ЦЗО' + REPLACE(N' №' + PCZO.AdditionalNumber, N'№№',
                                                                      N'№') + N' от ' + CONVERT(nvarchar, PCZO.[CompleteTime], 104) AS ProtocolCZO, (CASE WHEN PCZO.Id IS NULL
                                                                      THEN UPR.AddedTime ELSE PCZO.[CompleteTime] END) AS [PR_ApprovedByCZODate],
                                                                      (CASE WHEN PCZO.[LoadedToOos] = 1 THEN PCZO.[ModifiedTime] WHEN UPR.RequestId IN
                                                                          (SELECT DISTINCT [WasInBeginningYearPlan]
                                                                            FROM          [vc].[PRidConditionsMatrix]
                                                                            WHERE      NOT [WasInBeginningYearPlan] IS NULL) THEN UPR.[AddedTime] END) AS [DatePurchaseWasIncludedAtPlan],
                                                                      PublicationPlannedDate, (CASE WHEN NOT TZ.[ExpDateKonProc] = '0001-01-01 00:00:00.0000000' THEN TZ.[ExpDateKonProc] END)
                                                                      AS [ExpDateKonProc], (CASE WHEN IsElectronicPurchase = 1 THEN N'Электронная' ELSE N'Неэлектронная' END) AS IsElectronicPurchase,
                                                                      (CASE WHEN ForSmallOrMiddle = 1 THEN N'В закупочной процедуре могут участвовать любые участники' WHEN ForSmallOrMiddle = 2 THEN N'Только субъекты малого и среднего предпринимательства'
                                                                       WHEN ForSmallOrMiddle = 3 THEN N'Требование о привлечении к исполнению договора субподрядчиков из числа субъектов малого и среднего предпринимальства' ELSE N'Данные отсутсвуют' END)
                                                                      AS ForSmallOrMiddle, TZ.ExpNumberKonProc, ETP.[Name] AS ETPName, ETP.[Url] AS ETPUrl, TZ.ExpNumberOnGovKonProc,
                                                                      (CASE WHEN NOT TZ.ExpEnvelopeOpeningTime = '0001-01-01 00:00:00.0000000' THEN TZ.ExpEnvelopeOpeningTime END)
                                                                      AS [ExpEnvelopeOpeningTime], TZ.ExpCountParticipiantsRecievedDocs, AST.ExpCountParticipiantsApplied,
                                                                      PRejected.CountParticipiantsRejected, RP.[Name] AS ParticipantName, RP.PriceNoTax, RP.PriceTax, RP.Inn, RP.Kpp, RP.IsSmpExtended,
                                                                      (CASE WHEN RP.Rejected = 1 THEN RP.[Name] END) AS Rejected, RP.[Address] AS [ParticipantAddress],
                                                                      RP.[BetDateTime] AS [ParticipantBetDateTime], RP.Rejected AS [IsRejected], RP.RejectedReason, RP.IsWinner,
                                                                      (CASE WHEN NOT Expertise.DateOfPassDocumentsForExamination = '0001-01-01 00:00:00.0000000' THEN Expertise.DateOfPassDocumentsForExamination
                                                                       END) AS DateOfPassDocumentsForExamination, Expertise.UnitResponsibleForExamination,
                                                                      (CASE WHEN NOT Expertise.DateReceipExpertOpinion = '0001-01-01 00:00:00.0000000' THEN Expertise.DateReceipExpertOpinion END)
                                                                      AS DateReceipExpertOpinion,
                                                                      (CASE WHEN NOT LastReRequest.DateReceiptOfDocumentsUponReRequest = '0001-01-01 00:00:00.0000000' THEN LastReRequest.DateReceiptOfDocumentsUponReRequest
                                                                       END) AS DateReceiptOfDocumentsUponReRequest,
                                                                      (CASE WHEN NOT LastRebidding.DateStartRebidding = '0001-01-01 00:00:00.0000000' THEN LastRebidding.DateStartRebidding END)
                                                                      AS DateStartRebidding,
                                                                      (CASE WHEN NOT LastRebidding.DateStopRebidding = '0001-01-01 00:00:00.0000000' THEN LastRebidding.DateStopRebidding END)
                                                                      AS DateStopRebidding, LastRebidding.RebiddingAmount, (CASE WHEN LastRebidding.RebiddingAmount IS NULL
                                                                      THEN '' ELSE RebiddingTypeStatistic.FancyRebiddingStatistics END) AS FancyRebiddingAmount,
                                                                      (CASE WHEN NOT RP.SumAfterRebiddingNoTax = 0 THEN RP.SumAfterRebiddingNoTax END) AS SumAfterRebiddingNoTax,
                                                                      (CASE WHEN NOT RP.SumAfterRebiddingTax = 0 THEN RP.SumAfterRebiddingTax END) AS SumAfterRebiddingTax,
                                                                      (CASE WHEN NOT AC.FinalSumNoTax = 0 THEN AC.FinalSumNoTax END) AS FinalSumNoTax,
                                                                      (CASE WHEN NOT AC.FinalSumTax = 0 THEN AC.FinalSumTax END) AS FinalSumTax, (CASE WHEN RP.IsWinner = 1 THEN RP.[Name] END)
                                                                      AS WinnerName, AC.CountContractorsMspAtWinner, AC.TotalSumContractorsMspAtWinner,
                                                                      (CASE WHEN NOT AC.SummingupTime = '0001-01-01 00:00:00.0000000' THEN AC.SummingupTime END) AS SummingupTime,
                                                                      AC.NumberOfFinalProtocol,
                                                                      (CASE WHEN NOT AC.DateSendFinalProtocolToProfileDepartmentChief = '0001-01-01 00:00:00.0000000' THEN AC.DateSendFinalProtocolToProfileDepartmentChief
                                                                       END)
                                                                      AS DateSendFinalProtocolToProfileDepartmentChief/*Наименование участника с которым заключается договор по п. 7.5.8.Стандарта --детект по косвенным признакам		*/ ,
                                                                       CA.[Name] AS CodeActivityName, CA.[Code] AS [CodeActivityCode], APRA.[Description] AS [AdditionalPRAttributeDescription]
                                               FROM          (SELECT     [ItemType], [ProtocolCzoId], [RequestId], (CASE /*for patch status detection failure*/ WHEN RequestId IN
                                                                                                  (SELECT     RequestId
                                                                                                    FROM          [dbo].[AuctionCycles] AS AC FULL OUTER JOIN
                                                                                                                               (SELECT     AuctionCycleId
                                                                                                                                 FROM          (SELECT     *
                                                                                                                                                         FROM          [vc].[CZOPR_Data]) AS SQ0
                                                                                                                                 WHERE      NOT AuctionCycleId IS NULL) AS ACCorrection ON ACCorrection.AuctionCycleId = AC.Id
                                                                                                    WHERE      ACCorrection.AuctionCycleId IS NULL OR
                                                                                                                           AC.Id IS NULL)
                                                                                              THEN (CASE WHEN VersionPriority2 > 1 THEN 190 ELSE
                                                                                                  (/* because AuctionCycles dont write actual Status in it, only last when user pushed the button Repeat Trade*/ SELECT [Status]
                                                                                                    FROM          [dbo].[PurchaseRequests]
                                                                                                    WHERE      [Id] = RequestId) END) ELSE [Status] END) AS [Status], SQ2.[Stage], [AuctionCycleId], [PurchaseNumber], [LotNumber],
                                                                                              [ProtocolNumber], [Name], [OkvedId], [OkdpId], [PlannedSumByNotificationNotax], [PlannedSumByNotificationTax],
                                                                                              [PlannedSumWith30PercReductionNotax], [PlannedSumWith30PercReductionTax], [TaxPercent], [IsApproved], [Actions],
                                                                                              [CustomerOrganization], [CustomerSubdivision], [CustomerFunctionalBlock], [CustomerOrganizer], [FinanceResources],
                                                                                              [PlannedPurchaseMethodCode], SQ2.[OwnerOrganizationId], [IsElectronicPurchase], [PublicationPlannedDate],
                                                                                              [PlannedDateOfContract], [PlannedDateOfDelivery], [PlannedDateOfCompletion], [SummingupTime], [ForSmallOrMiddle],
                                                                                              [AdditionalInfo], [ReasonPurchaseEP], [ContractorName], [CodeActivityId], [CodeActivityCode], [IsInIpr], [ProcessConnection],
                                                                                              [PurchaseMethodName], [PurchasePlanYear], [ProductTypeId], [PurchaseCategory_Id], [IsInnovation], [PurchasePriceDocumentCode],
                                                                                              [PlannedSumNotax], [IsImported], [InvestProjectName], [DateEndProject], [Mba], [Kilometer], [Note], [CreatorUserId], [AddedTime],
                                                                                              [IprYear], [InvestProjectCode], [DateApprovalConstructionDocuments], [IsApprovedConstructionDocuments],
                                                                                              [IsNeedConstructionDocuments], [CostProject], [MegaWatt], [PrivilegedProcessConnection], [ExpWerePpriceNegotiations],
                                                                                              [ExpWinnerSumOnPpriceNegotiationsNoTax], [ExpWinnerSumOnPpriceNegotiationsTax], SQ2.[MinRequirementsForPurchaseGoods],
                                                                                              SQ2.[Okeiguid], SQ2.[Qty], SQ2.[Okato], SQ2.[PlannedPurchaseYear], SQ2.[AdditionalPRAttributeId]
                                                                       FROM          (SELECT     ROW_NUMBER() OVER (PARTITION BY [RequestId]
                                                                                               ORDER BY [AuctionCycleId] DESC) AS VersionPriority2, *
                                                                       FROM          (SELECT     ROW_NUMBER() OVER (PARTITION BY [RequestId], [AuctionCycleId]
                                                                                               ORDER BY [ProtocolCzoId] DESC) AS VersionPriority1, *
                                                                       FROM          (SELECT     [ItemType], [ProtocolCzoId], [RequestId], [Status], [Stage], [AuctionCycleId], [PurchaseNumber], [LotNumber],
                                                                                                                      [ProtocolNumber], [Name], [OkvedId], [OkdpId], [PlannedSumByNotificationNotax], [PlannedSumByNotificationTax],
                                                                                                                      [PlannedSumWith30PercReductionNotax], [PlannedSumWith30PercReductionTax], [TaxPercent], [IsApproved], [Actions],
                                                                                                                      [CustomerOrganization], [CustomerSubdivision], [CustomerFunctionalBlock], [CustomerOrganizer], [FinanceResources],
                                                                                                                      [PlannedPurchaseMethodCode], [OwnerOrganizationId], [IsElectronicPurchase], [PublicationPlannedDate],
                                                                                                                      [PlannedDateOfContract], [PlannedDateOfDelivery], [PlannedDateOfCompletion], [SummingupTime], [ForSmallOrMiddle],
                                                                                                                      [AdditionalInfo], [ReasonPurchaseEP], [ContractorName], [CodeActivityId], [CodeActivityCode], [IsInIpr],
                                                                                                                      [ProcessConnection], [PurchaseMethodName], [PurchasePlanYear], [ProductTypeId], [PurchaseCategory_Id],
                                                                                                                      [IsInnovation], [PurchasePriceDocumentCode], [PlannedSumNotax], [IsImported], [InvestProjectName], [DateEndProject],
                                                                                                                      [Mba], [Kilometer], [Note], [CreatorUserId], [AddedTime], [IprYear], [InvestProjectCode],
                                                                                                                      [DateApprovalConstructionDocuments], [IsApprovedConstructionDocuments], [IsNeedConstructionDocuments],
                                                                                                                      [CostProject], [MegaWatt], [PrivilegedProcessConnection], [ExpWerePpriceNegotiations],
                                                                                                                      [ExpWinnerSumOnPpriceNegotiationsNoTax], [ExpWinnerSumOnPpriceNegotiationsTax],
                                                                                                                      [MinRequirementsForPurchaseGoods], [Okeiguid], [Qty], [Okato], [PlannedPurchaseYear], [AdditionalPRAttributeId]
                                                                                               FROM          [vc].[CZOPR_Data]
                                                                                               /*<for debugging>
							WHERE [RequestId] = 13368
							</for debugging>*/ UNION
                                                                                               /*add losing purchase which trade more than one time at the same CZO protocol (mostly before EIS rebuild itself, when it's possible)*/ SELECT
                                                                                                                      [ItemType], [ProtocolCzoId], B.[RequestId], B.[Status], B.[Stage], B.Id AS [AuctionCycleId], [PurchaseNumber], [LotNumber],
                                                                                                                     [ProtocolNumber], [Name], [OkvedId], [OkdpId], [PlannedSumByNotificationNotax], [PlannedSumByNotificationTax],
                                                                                                                     [PlannedSumWith30PercReductionNotax], [PlannedSumWith30PercReductionTax], [TaxPercent], [IsApproved], [Actions],
                                                                                                                     [CustomerOrganization], [CustomerSubdivision], [CustomerFunctionalBlock], [CustomerOrganizer], [FinanceResources],
                                                                                                                     [PlannedPurchaseMethodCode], [OwnerOrganizationId], [IsElectronicPurchase], [PublicationPlannedDate],
                                                                                                                     [PlannedDateOfContract], [PlannedDateOfDelivery], [PlannedDateOfCompletion], B.[SummingupTime], [ForSmallOrMiddle],
                                                                                                                     [AdditionalInfo], [ReasonPurchaseEP], [ContractorName], [CodeActivityId], [CodeActivityCode], [IsInIpr],
                                                                                                                     [ProcessConnection], [PurchaseMethodName], [PurchasePlanYear], [ProductTypeId], [PurchaseCategory_Id],
                                                                                                                     [IsInnovation], [PurchasePriceDocumentCode], [PlannedSumNotax], [IsImported], [InvestProjectName], [DateEndProject],
                                                                                                                     [Mba], [Kilometer], [Note], [CreatorUserId], A.[AddedTime], A.[IprYear], A.[InvestProjectCode],
                                                                                                                     A.[DateApprovalConstructionDocuments], A.[IsApprovedConstructionDocuments], A.[IsNeedConstructionDocuments],
                                                                                                                     A.[CostProject], A.[MegaWatt], A.[PrivilegedProcessConnection], A.[ExpWerePpriceNegotiations],
                                                                                                                     A.[ExpWinnerSumOnPpriceNegotiationsNoTax], A.[ExpWinnerSumOnPpriceNegotiationsTax],
                                                                                                                     A.[MinRequirementsForPurchaseGoods], A.[Okeiguid], A.[Qty], A.[Okato], A.[PlannedPurchaseYear],
                                                                                                                     A.[AdditionalPRAttributeId]
                                                                                               FROM         [vc].[CZOPR_Data] AS A INNER JOIN
                                                                                                                         (SELECT     *
                                                                                                                           FROM          [dbo].[AuctionCycles] AS AC FULL OUTER JOIN
                                                                                                                                                      (SELECT     AuctionCycleId
                                                                                                                                                        FROM          (SELECT     *
                                                                                                                                                                                FROM          [vc].[CZOPR_Data]) AS SQ0
                                                                                                                                                        WHERE      NOT AuctionCycleId IS NULL) AS ACCorrection ON ACCorrection.AuctionCycleId = AC.Id
                                                                                                                           WHERE      ACCorrection.AuctionCycleId IS NULL OR
                                                                                                                                                  AC.Id IS NULL) AS B ON
                                                                                                                     B.RequestId = A.RequestId/*<for debugging>
							WHERE A.[RequestId] = 13368
							</for debugging>*/ )
                                                                                              AS SQ0/*<for debugging>
						WHERE SQ0.[RequestId] = 13368
						</for debugging>*/ ) AS SQ1
                                               WHERE      VersionPriority1 = 1/*<for debugging>
					AND SQ1.[RequestId] = 13368
					</for debugging>*/ )
                                              AS SQ2/*<for debugging>
				WHERE SQ2.[RequestId] = 13368
				</for debugging>*/ ) AS UPR /* for UnitedPurchaseRequests	*/ LEFT JOIN
                          (SELECT     R.Name, R.FullName, R.HeadName, U.FirstName, U.MiddleName, U.LastName, U.UserName, UR.*
                            FROM          dbo.AspNetRoles AS R INNER JOIN
                                                   dbo.AspNetUserRoles AS UR ON R.Id = UR.RoleId INNER JOIN
                                                   dbo.AspNetUsers AS U ON UR.UserId = U.Id
                            WHERE      R.[IsGroup] = 1 AND R.[GroupRole] = 'Customer') AS Groups ON Groups.UserName = UPR.[CreatorUserId] LEFT JOIN
                      [dbo].[AuctionCycles] AS AC ON AC.Id = UPR.[AuctionCycleId] LEFT JOIN
                      [dbo].[NsiPurchaseCategories] AS PCategory ON PCategory.Id = UPR.PurchaseCategory_Id LEFT JOIN
                      dbo.NsiOkved2Item AS OKVED ON OKVED.Id = UPR.OkvedId LEFT JOIN
                      dbo.NsiOkdp2Item AS OKDP ON OKDP.id = UPR.OkdpId LEFT JOIN
                      [dbo].[NsiCodeActivities] AS CA ON CA.Id = UPR.CodeActivityId LEFT JOIN
                      [dbo].[ProtocolCzoes] AS PCZO ON PCZO.Id = UPR.ProtocolCzoId LEFT JOIN
                      [dbo].[TechnicalProjectRequests] AS TZR ON TZR.AuctionCycleId = UPR.[AuctionCycleId] LEFT JOIN
                      [dbo].[TechnicalProjects] AS TZ ON TZ.Id = TZR.TechnicalProjectId LEFT JOIN
                      [dbo].[NsiEtps] AS ETP ON ETP.Code = TZ.EtpCode LEFT JOIN
                      [dbo].[AspNetUsers] AS Purchaser ON Purchaser.Id = TZ.ExecutorId LEFT JOIN
                      [dbo].[AspNetUsers] AS TZCreator ON TZCreator.Id = TZ.[UserId] LEFT JOIN
                      [dbo].[v_AuctionCycleLastStage] AS AST ON AST.[AuctionCycleId] = UPR.[AuctionCycleId] LEFT JOIN
                      [dbo].[RequestParticipiants] AS RP ON RP.[AuctionStageId] = AST.Id LEFT JOIN
                      [dbo].[NsiProductTypes] AS PrTYPE ON PrTYPE.Id = UPR.ProductTypeId LEFT JOIN
                      [dbo].[NsiPurchasePriceDocuments] AS PPD ON PPD.Code = UPR.PurchasePriceDocumentCode LEFT JOIN
                      [dbo].[NsiRequirementsForPurchaseGoods] AS MinReq ON MinReq.Code = UPR.[MinRequirementsForPurchaseGoods] LEFT JOIN
                      [dbo].[NsiOkeiItems] AS OKEI ON OKEI.[guid] = UPR.[Okeiguid] LEFT JOIN
                      [dbo].[NsiOkatoItems] AS OKATO ON OKATO.code = UPR.[Okato] LEFT JOIN
                      [dbo].[PurchaseMethods] AS PurMethod ON (PurMethod.[Code] = UPR.[PlannedPurchaseMethodCode]) AND (PurMethod.OrganisationId = UPR.[OwnerOrganizationId])
                      LEFT JOIN
                      [vc].[guesCZOPr] AS GCZO ON GCZO.PurchaseID = UPR.RequestId LEFT JOIN
                          (SELECT     [AuctionStageId], COUNT(NULLIF ([Rejected], 0)) AS CountParticipiantsRejected
                            FROM          [dbo].[RequestParticipiants]
                            GROUP BY [AuctionStageId]) AS PRejected ON PRejected.AuctionStageId = AST.Id LEFT JOIN
                          (SELECT DISTINCT
                                                   TechExpertise.[AuctionCycleId], TechExpertise.[DateOfPassDocumentsForExamination], [UnitResponsibleForExamination],
                                                   [DateReceipExpertOpinion]
                            FROM          [dbo].[AuctionStages] AS TechExpertise INNER JOIN
                                                       (SELECT     [AuctionCycleId], MAX([DateOfPassDocumentsForExamination]) AS [DateOfPassDocumentsForExamination]
                                                         FROM          [dbo].[AuctionStages]
                                                         WHERE      [IsNeedExpertise] = 1
                                                         GROUP BY [AuctionCycleId]) AS LastTechExpertise ON LastTechExpertise.AuctionCycleId = TechExpertise.AuctionCycleId AND
                                                   LastTechExpertise.[DateOfPassDocumentsForExamination] = TechExpertise.DateOfPassDocumentsForExamination) AS Expertise ON
                      Expertise.AuctionCycleId = UPR.[AuctionCycleId] LEFT JOIN
                          (SELECT     [AuctionCycleId], MAX([DateReceiptOfDocumentsUponReRequest]) AS DateReceiptOfDocumentsUponReRequest
                            FROM          [dbo].[AuctionStages]
                            WHERE      [IsNeedReRequest] = 1
                            GROUP BY [AuctionCycleId]) AS LastReRequest ON LastReRequest.AuctionCycleId = UPR.AuctionCycleId LEFT JOIN
                          (SELECT     [AuctionCycleId], MAX([DateStartRebidding]) AS DateStartRebidding, MAX([DateStopRebidding]) AS DateStopRebidding, COUNT([IsNeedRebidding])
                                                   AS RebiddingAmount
                            FROM          [dbo].[AuctionStages]
                            WHERE      [IsNeedRebidding] = 1
                            GROUP BY [AuctionCycleId]) AS LastRebidding ON LastRebidding.AuctionCycleId = UPR.AuctionCycleId LEFT JOIN
                          (SELECT     *, CAST(ExtramuralAmount AS nvarchar(40)) + N'з' + '|' + CAST(IntramuralAmount AS nvarchar(40)) + N'о' AS [FancyRebiddingStatistics]
                            FROM          (SELECT     CASE WHEN Extramural.AuctionCycleId IS NULL THEN Intramural.AuctionCycleId ELSE Extramural.AuctionCycleId END AS [AuctionCycleId],
                                                                           CASE WHEN Extramural.ExtramuralAmount IS NULL THEN 0 ELSE Extramural.ExtramuralAmount END AS [ExtramuralAmount],
                                                                           CASE WHEN Intramural.IntramuralAmount IS NULL THEN 0 ELSE Intramural.IntramuralAmount END AS [IntramuralAmount]
                                                    FROM          (SELECT     AuctionCycleId, COUNT(*) AS [ExtramuralAmount]
                                                                            FROM          dbo.AuctionStages
                                                                            WHERE      IsNeedRebidding = 1 AND RebiddingType = 'Extramural'
                                                                            GROUP BY AuctionCycleId) AS Extramural FULL OUTER JOIN
                                                                               (SELECT     *
                                                                                 FROM          (SELECT     AuctionCycleId, COUNT(*) AS [IntramuralAmount]
                                                                                                         FROM          dbo.AuctionStages
                                                                                                         WHERE      IsNeedRebidding = 1 AND RebiddingType = 'Intramural'
                                                                                                         GROUP BY AuctionCycleId) AS Intramural) AS Intramural ON Extramural.AuctionCycleId = Intramural.AuctionCycleId)
                                                   AS RebiddingTypeStatistic) AS RebiddingTypeStatistic ON RebiddingTypeStatistic.AuctionCycleId = UPR.AuctionCycleId LEFT JOIN
                      dbo.AdditionalPRAttributes AS APRA ON APRA.Id = UPR.[AdditionalPRAttributeId]/*<for debugging>
		WHERE UPR.[RequestId] = 15866
		</for debugging>*/ )
AS RawReport LEFT JOIN
ContractorsInlineByField AS SoleSupplier ON SoleSupplier.RequestId = RawReport.RequestId LEFT JOIN
[dbo].[Status] AS ST ON ST.Id = RawReport.[Status] LEFT JOIN
[dbo].[Stages] AS STG ON STG.Id = RawReport.[Stage] LEFT JOIN
    (SELECT     ROW_NUMBER() OVER (PARTITION BY [PurchaseRequest_Id]
      ORDER BY CreationTime ASC) AS [CreationTimeASCOrder], *
FROM         [dbo].[RequestApprovals]) AS PRAfirst ON PRAfirst.PurchaseRequest_Id = RawReport.RequestId AND PRAfirst.[CreationTimeASCOrder] = 1 LEFT JOIN
    (SELECT     ROW_NUMBER() OVER (PARTITION BY [PurchaseRequest_Id]
      ORDER BY CreationTime DESC) AS [CreationTimeDESCOrder], *
FROM         [dbo].[RequestApprovals]) AS PRAlast ON PRAlast.PurchaseRequest_Id = RawReport.RequestId AND PRAlast.[CreationTimeDESCOrder] = 1 LEFT JOIN
    (SELECT     ROW_NUMBER() OVER (PARTITION BY [TechnicalProject_Id]
      ORDER BY [CreationTime] ASC) AS CreationTimeASCOrder, *
FROM         [dbo].[TechnicalProjectApprovals]) AS TPAfirst ON TPAfirst.TechnicalProject_Id = RawReport.TZid AND TPAfirst.CreationTimeASCOrder = 1 LEFT JOIN
[dbo].[TechnicalProjectApprovals] AS TPAlast ON TPAlast.TechnicalProject_Id = RawReport.TZid AND TPAlast.[IsCompleted] = 1 AND
(NOT TPAlast.[CompleteTime] IS NULL)/*<debug>
	WHERE RawReport.RequestId = 15866
	</debug>*/ ) AS CorrectedReport LEFT JOIN
IPRDataInlineByField IPR ON IPR.RequestId = CorrectedReport.RequestId