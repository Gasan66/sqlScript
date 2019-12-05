use ASUZD
with pprr as
    (
        SELECT
	        PPRR.[AuctionCycleId]
	    ,(CASE
		    WHEN [PriceTzNoTax] < [PriceNoTax]
		    THEN N'превышение начальной (максимальной) цены лота'
		    WHEN [RejectedReason] LIKE N'%ТОМ 2%'
			OR [RejectedReason] LIKE N'%ТОМ2%'
			OR [RejectedReason] LIKE N'%Тома  2%'
			OR [RejectedReason] LIKE N'%ТОМа 2%'
			OR [RejectedReason] LIKE N'%Техническ%задани%'
			OR [RejectedReason] LIKE N'% ТЗ %'
		    THEN N'не соответствие Участников/участника закупочных процедур техническому заданию'
		    ELSE N'не соответствие Участников закупочных процедур требованиям конкурсной документации'
	    END) AS [PurchaseUnsuccessReason]
        ,RequestId as req1
FROM [ASUZD].[vc].[PurchasePlanRealizationReport] AS PPRR
    ),
    UnsucessfullTrade as
        (
        SELECT DISTINCT [RequestId] FROM [ASUZD].[vc].[PurchasePlanRealizationReport]
        WHERE [PurchaseRowIndexNumber] = 1
        AND [PurchasePlanYear] = 2019 --@PurchasePlanYear
        AND [Description] LIKE N'%Торги не состоялись%'
        ),
     PivottedUnsuccessTrades as
         (
             select
             COUNT(*) AS [TradeTypeCounter]
	        ,'WeAllTheSameType!' AS [PartitionFlag]
	        ,[PurchaseUnsuccessReason]
             from pprr
             join UnsucessfullTrade on UnsucessfullTrade.RequestId = PPRR.req1
             group by PurchaseUnsuccessReason
         )

SELECT
	CAST(CAST([TotalPercent] AS decimal(5,2)) AS nvarchar(max)) + ' % - ' + [PurchaseUnsuccessReason] AS [PurchaseUnsuccessNotation]
	,*
FROM (
SELECT
	(CAST([TradeTypeCounter] AS decimal) / CAST([TotalTradeCounter] AS decimal))*100 AS [TotalPercent]
	,[TotalTradeCounter]
	,[TradeTypeCounter]
	,[PurchaseUnsuccessReason]
FROM (
SELECT
	SUM([TradeTypeCounter]) OVER (PARTITION BY [PartitionFlag]) AS [TotalTradeCounter]
	,*
FROM PivottedUnsuccessTrades
) AS UnsuccessTradesAnalyse
) AS UnsuccessTradesAnalyseWithNotation













-- SELECT DISTINCT
-- 	COUNT(*) AS [TradeTypeCounter]
-- 	,'WeAllTheSameType!' AS [PartitionFlag]
-- 	,[PurchaseUnsuccessReason]
-- FROM (
-- SELECT
-- 	PPRR.[AuctionCycleId]
-- 	,(CASE
-- 		WHEN [PriceTzNoTax] < [PriceNoTax]
-- 		THEN N'превышение начальной (максимальной) цены лота'
-- 		WHEN [RejectedReason] LIKE N'%ТОМ 2%'
-- 			OR [RejectedReason] LIKE N'%ТОМ2%'
-- 			OR [RejectedReason] LIKE N'%Тома  2%'
-- 			OR [RejectedReason] LIKE N'%ТОМа 2%'
-- 			OR [RejectedReason] LIKE N'%Техническ%задани%'
-- 			OR [RejectedReason] LIKE N'% ТЗ %'
-- 		THEN N'не соответствие Участников/участника закупочных процедур техническому заданию'
-- 		ELSE N'не соответствие Участников закупочных процедур требованиям конкурсной документации'
-- 	END) AS [PurchaseUnsuccessReason]
-- FROM [ASUZD].[vc].[PurchasePlanRealizationReport] AS PPRR
-- INNER JOIN (
-- SELECT DISTINCT [RequestId] FROM [ASUZD].[vc].[PurchasePlanRealizationReport]
-- WHERE [PurchaseRowIndexNumber] = 1
-- AND [PurchasePlanYear] = 2019 --@PurchasePlanYear
-- AND [Description] LIKE N'%Торги не состоялись%'
-- ) AS UnsucessfullTrade ON UnsucessfullTrade.RequestId = PPRR.RequestId
-- WHERE PPRR.PurchaseRowIndexNumber = 1
-- AND [PriceTzNoTax] IS NOT NULL
-- ) AS PivottedUnsuccessTrades
-- GROUP BY [PurchaseUnsuccessReason]
-- ) AS GroupdedUnsuccessTrades
-- ) AS UnsuccessTradesAnalyse
-- ) AS UnsuccessTradesAnalyseWithNotation
