WITH AC_Status AS (
	SELECT Id [AuctionCycleId], [Status] FROM dbo.AuctionCycles WHERE [Status] <> 0
), PPRR_StatusFix AS (
SELECT
	 ROW_NUMBER() OVER (PARTITION BY PPRR.[RequestId] ORDER BY PPRR.[AuctionCycleId] DESC) AS [TradeAttemptDesc]
	,PPRR.[PurchaseRowIndexNumber]
	,PPRR.[PurchasePlanYear]
	,PPRR.[RequestId]
	,PPRR.[AuctionCycleId]
	,(CASE WHEN AC_Status.[Status] IS NULL THEN PPRR.[Status] ELSE AC_Status.[Status] END) AS [StatusId]
	,PPRR.[GroupName]
	,PPRR.[TZid]
	,PPRR.[CustomerSubdivisionName]
	,PPRR.[PurchaseNumber]
	,PPRR.[LotNumber]
	,PPRR.[Name]
	,PPRR.[PlannedSumByNotificationTax]
	,PPRR.[PriceTzTax]
	,PPRR.[ExpNumberOnGovKonProc]
	,PPRR.[ExpDateKonProc]
	,PPRR.[ExpEnvelopeOpeningTime]
	,PPRR.[NumberOfFinalProtocol]
	,PPRR.[DateSendFinalProtocolToProfileDepartmentChief]
	,PPRR.[WinnerName]
	,(CASE WHEN PPRR.[WinnerName] IS NOT NULL THEN PPRR.[PriceTax] ELSE NULL END) AS [WinnerStartingPriceTax]
	,(CASE WHEN PPRR.[WinnerName] IS NOT NULL THEN 100-((PPRR.[FinalSumTax] / NULLIF(PPRR.[PriceTax],0)) * 100) ELSE NULL END) AS [PriceReducingPercentage]
	,(CASE WHEN PPRR.[WinnerName] IS NOT NULL THEN PPRR.[FinalSumTax] ELSE NULL END) AS [FinalSumTax]
	,PPRR.[PurchaserFullName]
	,PPRR.[DateOfPassDocumentsForExamination]
	,PPRR.[UnitResponsibleForExamination]
	,PPRR.[DateReceipExpertOpinion]
	,PPRR.[SummingupTime]
	,PPRR.[CodeActivityName]
	,PPRR.[AdditionalPRAttributeDescription]
	,PPRR.ProtocolCZO
FROM [vc].[PurchasePlanRealizationReport] PPRR
LEFT JOIN AC_Status ON AC_Status.AuctionCycleId = PPRR.AuctionCycleId
WHERE PPRR.[PurchasePlanYear] = 2019 --@PlanYear
AND PPRR.[GroupName] = N'ОЛиМТО'
AND PPRR.[PurchaseRowIndexNumber] = 1

/*<debug>
AND PPRR.[RequestId] = 10861
</debug>*/

), ReviewStage as (
    select tprs.ReviewId as ReviewId,
           max(case
                   when tprs.TypeCode = N'Рассмотрение 1 частей заявок'
                       then tprs.Date end) as                                        N'Рассмотрение 1 частей заявок',
           max(case
                   when tprs.TypeCode = N'Рассмотрение 2 частей заявок'
                       then tprs.Date end) as                                        N'Рассмотрение 2 частей заявок',
           max(case when tprs.TypeCode = N'Подведение итогов' then tprs.Date end) as N'Подведение итогов'

    from TechnicalProjectReviewStages tprs
    group by tprs.ReviewId
), PPRR_FakeStatusAndSelectors AS (
SELECT
	 PPRR_StatusFix.*
	,(CASE WHEN ST.[Description] = N'На экспертизе' AND PPRR_StatusFix.[DateReceipExpertOpinion] IS NOT NULL THEN N'Техническая экспертиза получена'
		ELSE ST.[Description] END) AS [FancyDescription]
	,(CASE WHEN PPRR_StatusFix.TradeAttemptDesc = 1 THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END) AS [IsLastTadeAttempt]
	,(CASE WHEN (
						(PPRR_StatusFix.SummingupTime IS NULL)
					AND (PPRR_StatusFix.StatusId IN (--т.к. торги могут быть отменены и закупщик не поставит "Дата подведения итогов конкурентной процедуры"
														 120 --На торгах (ЭТП)
														,140 --Необходимо вскрыть конверты
														,150 --На экспертизе
														,160 --Дозапрос документов (ЭТП)
														,165 --Экспертиза после дозапроса
														,167 --Ожидание подписания протокола рассмотрения
														,170 --На переторжке (ЭТП)
														,175 --Рассмотрение после переторжки
														,177 --Ожидание подписания итогового протокола
						))
				)
		   THEN CAST(1 AS bit)
		   ELSE CAST(0 AS bit)
	 END) AS [IsActiveTrade]
    , rs.[Рассмотрение 1 частей заявок]
    , rs.[Рассмотрение 2 частей заявок]
    , rs.[Подведение итогов]
FROM PPRR_StatusFix
LEFT JOIN dbo.[Status] ST ON ST.Id = PPRR_StatusFix.StatusId
left join TechnicalProjectReviewStages tprs on tprs.ReviewId = PPRR_StatusFix.TZid
left join ReviewStage rs on rs.ReviewId = PPRR_StatusFix.TZid
)
SELECT * FROM PPRR_FakeStatusAndSelectors

