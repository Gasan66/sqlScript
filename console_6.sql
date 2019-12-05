use ASUZD
SELECT *
-- 	[RequestId],[Name],[PurchaseNumber],[LotNumber],[CustomerSubdivisionName],[PriceTzNoTax],[PriceTzTax],[ExpCountParticipiantsApplied],[TradeCounter]
FROM (
SELECT
	ROW_NUMBER() OVER (PARTITION BY PPRR.[RequestId] ORDER BY PPRR.[AuctionCycleId] DESC) AS [PurchaseRowIndexNumber]
	,PPRR.[RequestId]
	,PPRR.[AuctionCycleId]
	,PPRR.[Name]
	,PPRR.[PurchaseNumber]
	,PPRR.[LotNumber]
	,PPRR.[CustomerSubdivisionName]
	,PPRR.[PriceTzNoTax]
	,PPRR.[PriceTzTax]
	,PPRR.[ExpCountParticipiantsApplied]
	,COUNT(*) OVER (PARTITION BY PPRR.[RequestId]) AS [TradeCounter]
FROM [ASUZD].[vc].[PurchasePlanRealizationReport] AS PPRR
INNER JOIN (
SELECT DISTINCT [RequestId] FROM [ASUZD].[vc].[PurchasePlanRealizationReport]
WHERE [PurchaseRowIndexNumber] = 1
AND [PurchasePlanYear] = 2019 --@PurchasePlanYear
AND [Description] LIKE N'%Торги не состоялись%'
) AS UnsucessfullTrade ON UnsucessfullTrade.RequestId = PPRR.RequestId
WHERE PPRR.PurchaseRowIndexNumber = 1
AND [PriceTzNoTax] IS NOT NULL
) AS PivottedUnsuccessTrades
WHERE [PurchaseRowIndexNumber] = 1




with PPRR as
    (
    SELECT
	 ROW_NUMBER() OVER (PARTITION BY [RequestId] ORDER BY [AuctionCycleId] DESC) AS [PurchaseRowIndexNumber]
	,PurchasePlanRealizationReport.[RequestId]
	,[AuctionCycleId]
	,[Name]
	,[PurchaseNumber]
	,[LotNumber]
	,[CustomerSubdivisionName]
	,[PriceTzNoTax]
	,[PriceTzTax]
	,[ExpCountParticipiantsApplied]
	,COUNT(*) OVER (PARTITION BY [RequestId]) AS [TradeCounter]
    FROM [ASUZD].[vc].[PurchasePlanRealizationReport]
        ),

     UnsucessfullTrade as
         (
    SELECT DISTINCT [RequestId] as req1
    FROM [ASUZD].[vc].[PurchasePlanRealizationReport] pprr1
    WHERE [PurchaseRowIndexNumber] = 1
        AND [PurchasePlanYear] = 2019 --@PurchasePlanYear
        AND [Description] LIKE N'%Торги не состоялись%'
         )

SELECT *
--[RequestId],[Name],[PurchaseNumber],[LotNumber],[CustomerSubdivisionName],[PriceTzNoTax],[PriceTzTax],[ExpCountParticipiantsApplied],[TradeCounter]
FROM (
         select * --pprr.PurchaseRowIndexNumber
--          PPRR.[PurchaseRowIndexNumber]
-- 	    ,PPRR.[RequestId]
-- 	    ,PPRR.[AuctionCycleId]
-- 	    ,PPRR.[Name]
-- 	    ,PPRR.[PurchaseNumber]
-- 	    ,PPRR.[LotNumber]
-- 	    ,PPRR.[CustomerSubdivisionName]
-- 	    ,PPRR.[PriceTzNoTax]
-- 	    ,PPRR.[PriceTzTax]
-- 	    ,PPRR.[ExpCountParticipiantsApplied]
-- 	    ,PPRR.[TradeCounter]
         from PPRR
                  join UnsucessfullTrade on UnsucessfullTrade.req1 = pprr.RequestId
         where pprr.PurchaseRowIndexNumber = 1
           and PriceTzNoTax is not null
     ) AS PivottedUnsuccessTrades
WHERE PivottedUnsuccessTrades.PurchaseRowIndexNumber = 1



with PPRR as
    (
    SELECT
	 ROW_NUMBER() OVER (PARTITION BY [RequestId] ORDER BY [AuctionCycleId] DESC) AS [PurchaseRowIndexNumber]
	,PurchasePlanRealizationReport.[RequestId]
	,[AuctionCycleId]
	,[Name]
	,[PurchaseNumber]
	,[LotNumber]
	,[CustomerSubdivisionName]
	,[PriceTzNoTax]
	,[PriceTzTax]
	,[ExpCountParticipiantsApplied]
	,COUNT(*) OVER (PARTITION BY [RequestId]) AS [TradeCounter]
    FROM [ASUZD].[vc].[PurchasePlanRealizationReport]
        ),

     UnsucessfullTrade as
         (
    SELECT DISTINCT [RequestId] as req1
    FROM [ASUZD].[vc].[PurchasePlanRealizationReport] pprr1
    WHERE [PurchaseRowIndexNumber] = 1
        AND [PurchasePlanYear] = 2019 --@PurchasePlanYear
        AND [Description] LIKE N'%Торги не состоялись%'
         )

SELECT *
FROM (
         select *
         from PPRR
                  join UnsucessfullTrade on UnsucessfullTrade.req1 = pprr.RequestId
         where pprr.PurchaseRowIndexNumber = 1
           and PriceTzNoTax is not null
     ) AS PivottedUnsuccessTrades
WHERE PivottedUnsuccessTrades.PurchaseRowIndexNumber = 1