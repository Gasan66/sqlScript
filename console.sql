use ASUZD

WITH LTPwithRH AS (
--PROBLEM: как вариант RH может быть временным буфером на случай отката текущей корректировки, но он не должен постоянно держать данные как происходит сейчас
SELECT AC.RequestId, '00000000-0000-0000-0000-000000000000' [RHid], LTP.PaymentYear, LTP.PaymentSummWithTax,
		PR.ForSmallOrMiddle
	FROM dbo.LongTermPurschasePayments LTP
	LEFT JOIN dbo.AuctionCycles AC ON AC.Id = LTP.AuctionCycleId
	LEFT JOIN dbo.PurchaseRequests PR ON PR.Id = AC.RequestId
	UNION ALL
	SELECT RH.RequestId [PRid], RH.Id [RHid], LTP.PaymentYear, LTP.PaymentSummWithTax,
		RH.ForSmallOrMiddle
	FROM dbo.LongTermPurchasePaymentHists LTP
	LEFT JOIN dbo.RequestHistories RH ON RH.Id = LTP.RequestHistoryId
), LTPinfo AS (--сведения о долгосрочных оплатах в строку с разделителями
--PROBLEM: LTP это свойство PR а не AC, я не правильно спроектировал
SELECT t.PRid, t.RHid
		, STUFF(( SELECT ';' + CAST(LTPwithRH.PaymentYear AS nvarchar(4)) + ':' + CAST(LTPwithRH.PaymentSummWithTax AS nvarchar(32))
				  FROM LTPwithRH
				  WHERE (LTPwithRH.PRid = t.PRid) AND (LTPwithRH.RHid = t.RHid)
				  FOR XML PATH(''), TYPE)
				  .value('.','NVARCHAR(MAX)'),1,1,'') AS LTPinfo
		, STUFF(( SELECT ';' + CAST(LTPwithRH.PaymentYear AS nvarchar(4)) + ':' +
					CASE
						WHEN LTPwithRH.ForSmallOrMiddle != 2 --если не OnlySmallOrMiddle то сумма оплат ноль за каждый период
							THEN '0.00'
						ELSE CAST(LTPwithRH.PaymentSummWithTax AS nvarchar(32))
					END
				  FROM LTPwithRH
				  WHERE (LTPwithRH.PRid = t.PRid) AND (LTPwithRH.RHid = t.RHid)
				  FOR XML PATH(''), TYPE)
				  .value('.','NVARCHAR(MAX)'),1,1,'') AS LTPinfoForMSP
	FROM LTPwithRH AS t
	GROUP BY t.PRid, t.RHid
), PRwithRH AS (
--PROBLEM: AC должен быть только для торгов, сейчас AC это не полный цикл планирования + сведения о торгах
SELECT RH.RequestId [PRid], RH.AddedTime, RH.[Name], RH.PlannedPurchaseMethodCode, RH.Id [RHid],
		RH.[IsImported], RH.[SapId], RH.PurchasePlanId, RH.ProtocolNumber,  RH.[Stage], RH.[Status], CAST(1 AS bit) [TreatAsHistory],
		RH.AuctionCycleId, RH.AddedTime [OrderSortTime],
		RH.OkvedId, RH.OkdpId, RH.MinRequirementsForPurchaseGoods, RH.Okeiguid, RH.Qty, RH.Okato, RH.PlannedSumByNotificationTax,
		RH.PublicationPlannedDate, RH.PlannedDateOfCompletion, RH.IsElectronicPurchase, RH.ForSmallOrMiddle,
		(SELECT OwnerOrganizationId FROM dbo.PurchaseRequests WHERE Id = RH.RequestId) [OwnerOrganizationId],
		CASE WHEN RH.PurchaseCategory_Id IS NULL THEN 0 ELSE RH.PurchaseCategory_Id END [PurchaseCategory_Id], RH.IsInnovation,
		RH.AdditionalInfo
	FROM dbo.RequestHistories RH
	UNION ALL
	SELECT PR.Id [PRid], PR.AddedTime , PR.[Name], PR.PlannedPurchaseMethodCode, '00000000-0000-0000-0000-000000000000' [RHid],
		PR.[IsImported], PR.[SapId], PR.PurchasePlanId, PR.ProtocolNumber, PR.[Stage], PR.[Status], CAST(0 AS bit) [TreatAsHistory],
		(SELECT Id FROM dbo.AuctionCycles WHERE (IsActive = 1) AND (RequestId = PR.Id)) [AuctionCycleId], GETDATE() [OrderSortTime],
		PR.OkvedId, PR.OkdpId, PR.MinRequirementsForPurchaseGoods, PR.Okeiguid, PR.Qty, PR.Okato, PR.PlannedSumByNotificationTax,
		PR.PublicationPlannedDate, PR.PlannedDateOfCompletion, PR.IsElectronicPurchase, PR.ForSmallOrMiddle,
		PR.OwnerOrganizationId,
		CASE WHEN PR.PurchaseCategory_Id IS NULL THEN 0 ELSE PR.PurchaseCategory_Id END [PurchaseCategory_Id], PR.IsInnovation,
		PR.AdditionalInfo
	FROM dbo.PurchaseRequests PR
), RequestData AS (
SELECT AC.Id [ACid], AC.IsActive [ACIsActive], AC.[Stage] [StageFromAC], AC.[Status] [StatusFromAC], PRRH.*
	FROM PRwithRH PRRH
	LEFT JOIN dbo.AuctionCycles AC ON PRRH.AuctionCycleId = AC.Id
), ApprovedByCZO_PCi AS (
SELECT PC.ModifiedTime [PCModifiedTime], PC.LoadedToOos, PC.[Status] [PCSatus], PCi.*
	FROM dbo.ProtocolCzoes PC
	LEFT JOIN dbo.ProtocolCzoItems PCi ON PC.Id = PCi.Protocol_Id
	WHERE PC.[Status] IN (4 /*Approved*/,2 /*Finished*/)
	AND ((PCi.IsApproved = 1)
		AND (PCi.ItemType != 4 /*ApprovalEP*/) --т.к. это внутренний процесс и не является изменением внешнего состояния плана
	)
), ApprovedStates AS (
--PROBLEM: проще смотреть на план закупок как на частный случай PC (признак добавить в него?), т.к. даже заявки собрать проще через АСУЗД протоколами ЦЗО чем импортом
SELECT PCi.Protocol_Id [PCid], PCi.PCSatus, PCi.Id [PCIid], PCi.PCModifiedTime,
	CASE --если протокола ЦЗО для заявки нет то брать ProtocolNumber из модели заявки
		WHEN PCi.Protocol_Id IS NULL THEN RequestData.ProtocolNumber
		ELSE PCi.NumberOos
	END [EISnumber],
	CASE --если протокола ЦЗО для заявки нет то это включение в план закупок из импорта
		WHEN PCi.Protocol_Id IS NULL THEN 0 /*RequestIncludeToPZ*/
		ELSE PCi.ItemType
	END [PCiItemTypeWithImport],
	CASE
		WHEN PCi.PCModifiedTime IS NULL THEN RequestData.AddedTime
		ELSE PCi.PCModifiedTime
	END [StateModifiedTime],
	CASE
		WHEN PCi.Protocol_Id IS NULL THEN CAST(1 AS bit) --если нет протокола ЦЗО значит выгружен при импорте
		ELSE PCi.LoadedToOos
	END [IsLoadedToOos],
	RequestData.* FROM RequestData
	LEFT JOIN ApprovedByCZO_PCi PCi ON PCi.AuctionCycleId = RequestData.ACid
	WHERE ((PCi.Protocol_Id IS NOT NULL)
	OR ((RequestData.IsImported = 1) AND ((RequestData.SapId IS NULL) OR (RequestData.SapId = '')) AND (PCi.Protocol_Id IS NULL))) --импорт в утвержденном состоянии
	AND (PurchasePlanId IS NOT NULL)
), EISnumberOccurenceCounted AS (--версия правки с точки зрения ЕИС это EISnumber внутри плана закупок, а не PRid и не ACid
--PROBLEM: секретарь ЦЗО нумерует [EISnumber] руками, это не правильно т.к. с точки зрения ЕИС это id
SELECT *, COUNT(*) OVER(PARTITION BY PRid, PurchasePlanId, EISnumber) [EISnumberCounter] FROM ApprovedStates
), ValidEISNumbers AS (
SELECT * FROM EISnumberOccurenceCounted
	WHERE ([EISnumber] IS NOT NULL) AND ([EISnumber] != '') AND ([EISnumber] != '0') --ЕИС не примет пустые номера и секретари ЦЗО просят не выгружать в ЕИС номера = 0
), LastEISStateModification AS (
SELECT PRid, MAX(StateModifiedTime) [LastStateModificationTime] FROM ValidEISNumbers
	GROUP BY PRid, PurchasePlanId, EISnumber
), NoStateVersionConflict AS (--убираем конфликт версий правок - в ЕИС должна быть переданна последняя версия правки для каждого [EISnumber]
SELECT VN.* FROM ValidEISNumbers VN
	INNER JOIN LastEISStateModification LM ON (LM.PRid = VN.PRid) AND (LM.LastStateModificationTime = VN.StateModifiedTime)
), NoConflictStatesWithModTime AS (
SELECT DISTINCT PRid, ACid, StateModifiedTime FROM NoStateVersionConflict
), NoConflictStatesWithModOrder AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY ACid ORDER BY StateModifiedTime DESC) [DescStateModificationOrder] FROM NoConflictStatesWithModTime
), NoConflictStatesWithOrderSortTime AS (
SELECT DISTINCT PRid, ACid, OrderSortTime FROM NoStateVersionConflict
), NoConflictStatesWithVersionOrder AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY ACid ORDER BY OrderSortTime DESC) [DescVersionOrder] FROM NoConflictStatesWithOrderSortTime
), NoPRRHversionConflict AS (--убираем конфликт версий PR и RH сопоставив очередность их добавления очередности возникновения правок
SELECT NSVC.*, MO.DescStateModificationOrder, SO.DescVersionOrder
	FROM NoStateVersionConflict NSVC
	LEFT JOIN NoConflictStatesWithModOrder MO ON (MO.ACid = NSVC.ACid) AND (MO.StateModifiedTime = NSVC.StateModifiedTime)
	LEFT JOIN NoConflictStatesWithVersionOrder SO ON (SO.ACid = NSVC.ACid) AND (SO.OrderSortTime = NSVC.OrderSortTime)
	WHERE (MO.DescStateModificationOrder = SO.DescVersionOrder)
), AddPositionStatusCode AS (
SELECT
		*,
		CASE --из инструкции в шаблоне --https://com.roseltorg.ru/docs/examples/purchase_plan_template2016.xls
			WHEN (([EISnumberCounter] = 1) AND (PCiItemTypeWithImport != 1 /*RequestExcludeFromPZ*/)) AND (IsLoadedToOos = 0) THEN N'N' --N : Новая
			WHEN (PCiItemTypeWithImport != 1 /*RequestExcludeFromPZ*/) AND (IsLoadedToOos = 1) THEN N'P' --P : Размещена
			WHEN (([EISnumberCounter] > 1) AND ((PCiItemTypeWithImport != 1 /*RequestExcludeFromPZ*/))) AND (IsLoadedToOos = 0) THEN N'C' --C : Изменена
			WHEN (PCiItemTypeWithImport = 1 /*RequestExcludeFromPZ*/) THEN N'A' --A : Аннулирована --удалена/будет удалена
			ELSE N'unexpected result' --чтобы ЕЭТП парсер ругнулся если что-то не обработано логикой выше
		END [PositionStatusCode]
	FROM NoPRRHversionConflict
), AddChangeNumericCodes AS (
SELECT
		*,
		--из инструкции в шаблоне --https://com.roseltorg.ru/docs/examples/purchase_plan_template2016.xls
		--1 - изменение потребности в товарах, работах, услугах, в том числе сроков их приобретения, способа осуществления закупки и срока исполнения договора
		CASE WHEN [PositionStatusCode] = N'C' THEN 1 END [ChangeExplanationCode],

		--1: Отказ от проведения закупки
		CASE WHEN [PositionStatusCode] = N'A' THEN 1 END [ExclusionExplanationCode]
	FROM AddPositionStatusCode
), PurchasePlan_EETP_toEIS as (
    SELECT NC.PRid,
           NC.PurchasePlanId,
           NC.PCid,
           NC.EISnumber                                                              [1_EISnumber],
           OKVED.[code]                                                              [2_OKVED2],
           OKDP.[code]                                                               [3_OKDP2],
           NC.[Name]                                                                 [4_ContractSubject],
           REQ.[Name]                                                                [5_MinRequirements],
           OKEI.[code]                                                               [6_OKEIcode],
           OKEI.[name]                                                               [7_OKEIname],
           NC.Qty                                                                    [8_Quantity],
           OKATO.code                                                                [9_OKATOcode],
           OKATO.[name]                                                              [10_OKATOname],
           NC.PlannedSumByNotificationTax                                            [11_PlannedSumByNotificationTax],
           NC.PublicationPlannedDate                                                 [12_PublicationPlannedDate],
           NC.PlannedDateOfCompletion                                                [13_PlannedDateOfCompletion],
           PM.[Code]                                                                 [14_PurchaseMethodCode],
           NC.IsElectronicPurchase                                                   [15_IsElectronicPurchase],
           PM.[NsiId]                                                                [16_PurchaseMethodId],
           'RUB'                                                                     [17_CurrencyCode],
           CASE WHEN NC.ForSmallOrMiddle = 2 /*OnlySmallOrMiddle*/ THEN 1 ELSE 0 END [18_ForSmallOrMiddle],
           PC.[Id]                                                                   [19_PurchaseCategoryId],
           1                                                                         [20_CurrencyRate],
           NC.StateModifiedTime                                                      [21_CurrencyRateDate],
           NC.PlannedSumByNotificationTax                                            [22_MaxRUBContractSumm],
           NC.IsInnovation                                                           [23_IsInnovation],
           NC.ChangeExplanationCode                                                  [24_ChangeExplanationCode],
           NC.AdditionalInfo                                                         [25_AdditionalInfo],
           NC.PositionStatusCode                                                     [26_PositionStatusCode],
           NC.ExclusionExplanationCode                                               [27_ExclusionExplanationCode],
           CASE WHEN LTP.PRid IS NULL THEN 0 ELSE 1 END                              [28_IsLTP],
           LTP.LTPinfo                                                               [29_LTPinfo],
           LTP.LTPinfoForMSP                                                         [30_LTPinfoForMSP],
           1                                                                         [31_IsCommonAddress]
    FROM AddChangeNumericCodes NC
             LEFT JOIN dbo.NsiOkved2Item OKVED ON OKVED.Id = NC.OkvedId
             LEFT JOIN dbo.NsiOkdp2Item OKDP ON OKDP.id = NC.OkdpId
             LEFT JOIN dbo.NsiRequirementsForPurchaseGoods REQ ON REQ.Code = NC.MinRequirementsForPurchaseGoods
             LEFT JOIN dbo.NsiOkeiItems OKEI ON OKEI.[guid] = NC.Okeiguid
             LEFT JOIN dbo.NsiOkatoItems OKATO On OKATO.code = NC.Okato
             LEFT JOIN dbo.PurchaseMethods PM
                       ON (PM.Code = NC.PlannedPurchaseMethodCode) AND (PM.OrganisationId = NC.OwnerOrganizationId)
             LEFT JOIN dbo.NsiPurchaseCategories PC ON PC.Id = NC.PurchaseCategory_Id
             LEFT JOIN LTPinfo LTP ON (LTP.PRid = NC.PRid) AND (LTP.RHid = NC.RHid)
    WHERE (NC.PCSatus = 4 /*Approved*/) --на ЕЭТП подгружается диффиренциальный состав данных
)

SELECT
  vc.PurchasePlan_EETP_toEIS.PRid
  ,vc.PurchasePlan_EETP_toEIS.PurchasePlanId
  ,vc.PurchasePlan_EETP_toEIS.PCid
  ,vc.PurchasePlan_EETP_toEIS.[1_EISnumber]
  ,vc.PurchasePlan_EETP_toEIS.[2_OKVED2]
  ,vc.PurchasePlan_EETP_toEIS.[3_OKDP2]
  ,vc.PurchasePlan_EETP_toEIS.[4_ContractSubject]
  ,vc.PurchasePlan_EETP_toEIS.[5_MinRequirements]
  ,vc.PurchasePlan_EETP_toEIS.[6_OKEIcode]
  ,vc.PurchasePlan_EETP_toEIS.[7_OKEIname]
  ,vc.PurchasePlan_EETP_toEIS.[8_Quantity]
  ,vc.PurchasePlan_EETP_toEIS.[9_OKATOcode]
  ,vc.PurchasePlan_EETP_toEIS.[10_OKATOname]
  ,vc.PurchasePlan_EETP_toEIS.[11_PlannedSumByNotificationTax]
  ,vc.PurchasePlan_EETP_toEIS.[12_PublicationPlannedDate]
  ,vc.PurchasePlan_EETP_toEIS.[13_PlannedDateOfCompletion]
  ,vc.PurchasePlan_EETP_toEIS.[14_PurchaseMethodCode]
  ,vc.PurchasePlan_EETP_toEIS.[15_IsElectronicPurchase]
  ,vc.PurchasePlan_EETP_toEIS.[16_PurchaseMethodId]
  ,vc.PurchasePlan_EETP_toEIS.[17_CurrencyCode]
  ,vc.PurchasePlan_EETP_toEIS.[18_ForSmallOrMiddle]
  ,vc.PurchasePlan_EETP_toEIS.[19_PurchaseCategoryId]
  ,vc.PurchasePlan_EETP_toEIS.[20_CurrencyRate]
  ,vc.PurchasePlan_EETP_toEIS.[21_CurrencyRateDate]
  ,vc.PurchasePlan_EETP_toEIS.[22_MaxRUBContractSumm]
  ,vc.PurchasePlan_EETP_toEIS.[23_IsInnovation]
  ,vc.PurchasePlan_EETP_toEIS.[24_ChangeExplanationCode]
  ,vc.PurchasePlan_EETP_toEIS.[25_AdditionalInfo]
  ,vc.PurchasePlan_EETP_toEIS.[26_PositionStatusCode]
  ,vc.PurchasePlan_EETP_toEIS.[27_ExclusionExplanationCode]
  ,vc.PurchasePlan_EETP_toEIS.[28_IsLTP]
  ,vc.PurchasePlan_EETP_toEIS.[29_LTPinfo]
  ,vc.PurchasePlan_EETP_toEIS.[30_LTPinfoForMSP]
  ,vc.PurchasePlan_EETP_toEIS.[31_IsCommonAddress]
FROM
  PurchasePlan_EETP_toEIS