use ASUZD

SELECT
			UPR.[RequestId]
			,UPR.PurchasePlanYear
			,UPR.AuctionCycleId
			,UPR.[Name]
			,UPR.[PlannedSumWith30PercReductionNotax]
			,UPR.[PlannedSumWith30PercReductionTax]
			,UPR.[CustomerOrganization] AS [CustomerOrganizationName]
			,UPR.CustomerSubdivision AS [CustomerSubdivisionName]
			,UPR.CustomerFunctionalBlock AS [CustomerFunctionalBlockName]
			,UPR.[PlannedSumNotax]
			,UPR.SummingupTime AS [PlannedSummingupTime]
			,UPR.[ReasonPurchaseEP]
			,UPR.[PlannedDateOfContract]
			,UPR.[PlannedDateOfDelivery]
			,UPR.[AdditionalInfo]
			,UPR.[Note]
			,UPR.[ExpWerePpriceNegotiations]
			,AC.WerePpriceNegotiations
			,UPR.[ExpWinnerSumOnPpriceNegotiationsNoTax]
			,UPR.[ExpWinnerSumOnPpriceNegotiationsTax]
			,(CASE WHEN UPR.IsInIpr = 1 THEN N'Да' ELSE N'Нет' END) AS [FancyIsInIpr]
			,(CASE
				WHEN UPR.IsInIpr = 1
					THEN UPR.[IprYear]
			END) AS [FancyIprYear]
			,(CASE
				WHEN UPR.IsInIpr = 1
					THEN UPR.[InvestProjectCode]
			END) AS [FancyInvestProjectCode]
			,UPR.[InvestProjectName]

			,(CASE
				WHEN UPR.IsInIpr = 1
					THEN
						(CASE
							WHEN UPR.[IsNeedConstructionDocuments] = 1
								THEN N'Не требуется'
							WHEN UPR.[IsApprovedConstructionDocuments] = 1
								THEN N'Не утверждена'
							ELSE UPR.[DateApprovalConstructionDocuments]
						END)
			END) AS [FancyDateApprovalConstructionDocuments]
			,(CASE
				WHEN UPR.IsInIpr = 1
					THEN
						CASE
							WHEN UPR.DateEndProject > '0001-01-01 00:00:00.0000000'
								THEN UPR.DateEndProject
						END
			END) AS [FancyDateEndProject]
			,(CASE
				WHEN UPR.IsInIpr = 1
					THEN UPR.[CostProject]
			END) AS [FancyCostProject]
			,(CASE
				WHEN UPR.IsInIpr = 1
					THEN
						CASE
						WHEN UPR.[MegaWatt] > 0
							THEN UPR.[MegaWatt]
						END
			END) AS [FancyMegaWatt]
			,(CASE
				WHEN UPR.IsInIpr = 1
				THEN
					CASE
					WHEN UPR.Mba > 0
						THEN UPR.Mba
					END
			END) AS [FancyMba]
			,(CASE
				WHEN UPR.IsInIpr = 1
				THEN
					CASE
					WHEN UPR.Kilometer > 0
						THEN UPR.Kilometer
					END
			END) AS [FancyKilometer]
			,(CASE WHEN UPR.ProcessConnection = 1 THEN N'Да' ELSE N'Нет' END) AS [IsProcessConnection]
			,(CASE WHEN UPR.[PrivilegedProcessConnection] = 1 THEN N'Да' ELSE N'Нет' END) AS [IsPrivilegedProcessConnection]
			,Groups.[Name] AS [GroupName]
			,GCZO.DocumentDate
			,GCZO.DocumentNumber
			,GCZO.NameOfOrgan
			,PPD.[Name] AS [PurchasePriceDocumentName]
			,(CASE
				WHEN UPR.[IsImported] = 0
					THEN (N'ВЗ ' + UPR.PlannedPurchaseMethodCode)
				ELSE UPR.PlannedPurchaseMethodCode
			END) AS [FancyPlannedPurchaseMethodCode]
			,(CASE
				WHEN UPR.[IsInnovation] = 0
					THEN N'Нет'
				ELSE N'Да'
			END) AS [FancyIsInnovation]
			,UPR.PurchaseCategory_Id
			,PCategory.[Name] AS [PurchaseCategoryName]
			,(CASE
				WHEN UPR.PurchaseCategory_Id = 0
					THEN N'0'
				WHEN UPR.PurchaseCategory_Id = 1
					THEN N'а'
				WHEN UPR.PurchaseCategory_Id = 2
					THEN N'б'
				WHEN UPR.PurchaseCategory_Id = 3
					THEN N'в'
				WHEN UPR.PurchaseCategory_Id = 4
					THEN N'г'
				WHEN UPR.PurchaseCategory_Id = 5
					THEN N'д'
				WHEN UPR.PurchaseCategory_Id = 6
					THEN N'е'
				WHEN UPR.PurchaseCategory_Id = 7
					THEN N'ж'
				WHEN UPR.PurchaseCategory_Id = 8
					THEN N'з'
				WHEN UPR.PurchaseCategory_Id = 9
					THEN N'и'
				WHEN UPR.PurchaseCategory_Id = 10
					THEN N'к'
				WHEN UPR.PurchaseCategory_Id = 11
					THEN N'л'
				WHEN UPR.PurchaseCategory_Id = 12
					THEN N'м'
				WHEN UPR.PurchaseCategory_Id = 13
					THEN N'н'
				WHEN UPR.PurchaseCategory_Id = 14
					THEN N'о'
				WHEN UPR.PurchaseCategory_Id = 15
					THEN N'п'
				WHEN UPR.PurchaseCategory_Id = 16
					THEN N'р'
				WHEN UPR.PurchaseCategory_Id = 17
					THEN N'с'
				WHEN UPR.PurchaseCategory_Id = 18
					THEN N'т'
				WHEN UPR.PurchaseCategory_Id = 19
					THEN N'у'
				WHEN UPR.PurchaseCategory_Id = 20
					THEN N'ф'
				WHEN UPR.PurchaseCategory_Id = 21
					THEN N'х'
				WHEN UPR.PurchaseCategory_Id = 22
					THEN N'ц'
				WHEN UPR.PurchaseCategory_Id = 23
					THEN N'ч'
				WHEN UPR.PurchaseCategory_Id = 24
					THEN N'ш'
				WHEN UPR.PurchaseCategory_Id = 25
					THEN N'щ'
				WHEN UPR.PurchaseCategory_Id = 26
					THEN N'э'
				WHEN UPR.PurchaseCategory_Id = 27
					THEN N'ю'
				ELSE N'не удалось определить'
			END) AS [FancyPurchaseCategory_Id]
			,(CASE WHEN (
							NOT EXISTS (
											SELECT TOP 1 *
											FROM [dbo].[RequestHistories]
											WHERE [RequestId] = UPR.[RequestId]
									   )
						)
						AND (
								NOT EXISTS (
											SELECT TOP 1 *
											FROM dbo.PurchaseRequests AS ONtrade
											WHERE ONtrade.Stage IN (
																	 4 --N'Работа с ЭТП'
																	,6 --N'Одобрение заключения договора с ЕП'
																	,7 --N'Одобрено заключение договора с ЕП'
																	,8 --N'Отказ заключения договора с ЕП'
																	)
											AND Id = UPR.RequestId
										   )
							)
						AND (SELECT COUNT(*) FROM [dbo].[AuctionCycles] AS AC WHERE AC.[RequestId] = UPR.[RequestId]) > 1
						AND (SELECT COUNT(*) FROM [dbo].[AuctionCycles] AS AC WHERE AC.[RequestId] = UPR.[RequestId] AND AC.IsActive = 1 AND AC.CompletedTime = '0001-01-01 00:00:00.0000000') = 1
						AND (SELECT COUNT(*) FROM [dbo].[AuctionCycles] AS AC WHERE AC.[RequestId] = UPR.[RequestId] AND NOT AC.SummingupTime = '0001-01-01 00:00:00.0000000') > 0
				THEN (SELECT TOP 1 [Status] FROM [dbo].[PurchaseRequests] AS PR WHERE PR.Id = UPR.[RequestId]) --N'Нужно брать Status из предыдущего аукционного цикла'
				WHEN (UPR.[Status] = -1) THEN (SELECT [Status] FROM dbo.PurchaseRequests WHERE Id = UPR.[RequestId])
				ELSE UPR.[Status] --N'Status менять не нужно'
			END) AS [Status]
			,UPR.[Stage]
			,UPR.[Qty]
			,UPR.[PlannedDateOfCompletion]
			,UPR.[PlannedPurchaseYear]
			,MinReq.[Code] AS [PurchaseMinReqCode]
			,MinReq.[Name] AS [PurchaseMinReqName]
			,OKEI.[code] AS [OKEIcode]
			,OKEI.[symbol] AS [OKEIsymbol]
			,OKEI.[name] AS [OKEIname]
			,OKATO.code AS [OKATOcode]
			,OKATO.[name] AS [OKATOname]
			,PurMethod.[NsiId] AS [PurchaseMethodCodeOnEIS]
			,PrTYPE.[Code] AS [ProductTypeName]
			,LEFT(PrTYPE.[Code], PATINDEX('%[ ]-[^0-9.-]%', PrTYPE.[Code])) AS [FancyProductTypeName]
			,AST.Id AS [AuctionStageId]
			,(Groups.LastName + ' ' + Groups.FirstName + ' ' + Groups.MiddleName) AS PurchaseCreatorFullName
			,(Purchaser.LastName + ' ' + Purchaser.FirstName + ' ' + Purchaser.MiddleName) AS PurchaserFullName
			,(TZCreator.LastName + ' ' + TZCreator.FirstName + ' ' + TZCreator.MiddleName) AS TZCreatorFullName
			,TZ.[ApprovedTime]
			--основание для продления сроков - нет в АСУЗД
			,ProtocolNumber
			,PurchaseNumber
			,LotNumber
			,FinanceResources
			,CustomerOrganizer
			,PlannedSumByNotificationTax
			,PlannedSumByNotificationNotax
			,TZR.PriceTzNoTax
			,TZR.PriceTzTax
			,TZR.[Order] AS [TechnicalProjectRequestOrder]
			,PlannedPurchaseMethodCode --по факту теперь не может отличаться от плана
			,UPR.[OwnerOrganizationId]
			,TZ.Id AS [TZid]
			,TZ.[Name] AS [TZName]
			,TZ.IsSinglePrice
			,OKVED.code AS OKVED2CODE
			,OKDP.code AS OKDP2CODE
			,'(id-' + CAST(ProtocolCzoId AS nvarchar) + ') ' + N'Протокол согласования ЦЗО' + REPLACE ( N' №' + PCZO.AdditionalNumber , N'№№' , N'№' ) + N' от ' + CONVERT(nvarchar,PCZO.[CompleteTime],104) AS ProtocolCZO
			,(CASE
				WHEN PCZO.Id IS NULL
					THEN UPR.AddedTime
				ELSE PCZO.[CompleteTime]
			END) AS [PR_ApprovedByCZODate]
			,(CASE
				WHEN PCZO.[LoadedToOos] = 1
					THEN PCZO.[ModifiedTime]
				WHEN UPR.RequestId IN	(
											SELECT DISTINCT
												  [WasInBeginningYearPlan]
											FROM [vc].[PRidConditionsMatrix]
											WHERE NOT [WasInBeginningYearPlan] IS NULL
										)
					THEN UPR.[AddedTime]
			END) AS [DatePurchaseWasIncludedAtPlan]
			,PublicationPlannedDate
			,(CASE WHEN NOT TZ.[ExpDateKonProc]	= '0001-01-01 00:00:00.0000000' THEN TZ.[ExpDateKonProc] END) AS [ExpDateKonProc]
			,(CASE WHEN IsElectronicPurchase = 1 THEN N'Электронная' ELSE N'Неэлектронная' END) AS IsElectronicPurchase
			,(CASE
				WHEN ForSmallOrMiddle=1 THEN N'В закупочной процедуре могут участвовать любые участники'
				WHEN ForSmallOrMiddle=2 THEN N'Только субъекты малого и среднего предпринимательства'
				WHEN ForSmallOrMiddle=3 THEN N'Требование о привлечении к исполнению договора субподрядчиков из числа субъектов малого и среднего предпринимальства'
				ELSE N'Данные отсутсвуют'
			END) AS ForSmallOrMiddle
			,TZ.ExpNumberKonProc
			,ETP.[Name] AS ETPName
			,ETP.[Url] AS ETPUrl
			,TZ.ExpNumberOnGovKonProc
			,(CASE WHEN NOT TZ.ExpEnvelopeOpeningTime = '0001-01-01 00:00:00.0000000' THEN TZ.ExpEnvelopeOpeningTime END) AS [ExpEnvelopeOpeningTime]
			,TZ.ExpCountParticipiantsRecievedDocs
			,AST.ExpCountParticipiantsApplied
			,PRejected.CountParticipiantsRejected
			,RP.[Name] AS ParticipantName
			,RP.PriceNoTax
			,RP.PriceTax
			,RP.Inn
			,RP.Kpp
			,RP.IsSmpExtended
			,(CASE WHEN RP.Rejected = 1 THEN RP.[Name] END) AS Rejected
			,RP.[Address] AS [ParticipantAddress]
			,RP.[BetDateTime] AS [ParticipantBetDateTime]
			,RP.Rejected AS [IsRejected]
			,RP.RejectedReason
			,RP.IsWinner
			,(CASE WHEN NOT Expertise.DateOfPassDocumentsForExamination = '0001-01-01 00:00:00.0000000' THEN Expertise.DateOfPassDocumentsForExamination END) AS DateOfPassDocumentsForExamination
			,Expertise.UnitResponsibleForExamination
			,(CASE WHEN NOT Expertise.DateReceipExpertOpinion = '0001-01-01 00:00:00.0000000' THEN Expertise.DateReceipExpertOpinion END) AS DateReceipExpertOpinion
			,(CASE WHEN NOT LastReRequest.DateReceiptOfDocumentsUponReRequest = '0001-01-01 00:00:00.0000000' THEN LastReRequest.DateReceiptOfDocumentsUponReRequest END) AS DateReceiptOfDocumentsUponReRequest
			,(CASE WHEN NOT LastRebidding.DateStartRebidding = '0001-01-01 00:00:00.0000000' THEN LastRebidding.DateStartRebidding END) AS DateStartRebidding
			,(CASE WHEN NOT LastRebidding.DateStopRebidding = '0001-01-01 00:00:00.0000000' THEN LastRebidding.DateStopRebidding END) AS DateStopRebidding
			,LastRebidding.RebiddingAmount
			,(CASE WHEN LastRebidding.RebiddingAmount IS NULL
						THEN ''
				   ELSE RebiddingTypeStatistic.FancyRebiddingStatistics
			END) AS FancyRebiddingAmount

			,(CASE WHEN NOT RP.SumAfterRebiddingNoTax = 0 THEN RP.SumAfterRebiddingNoTax END) AS SumAfterRebiddingNoTax
			,(CASE WHEN NOT RP.SumAfterRebiddingTax = 0 THEN RP.SumAfterRebiddingTax END) AS SumAfterRebiddingTax
			,(CASE WHEN NOT AC.FinalSumNoTax = 0 THEN AC.FinalSumNoTax END) AS FinalSumNoTax
			,(CASE WHEN NOT AC.FinalSumTax = 0 THEN AC.FinalSumTax END) AS FinalSumTax
			,(CASE WHEN RP.IsWinner = 1 THEN RP.[Name] END) AS WinnerName
			,AC.CountContractorsMspAtWinner
			,AC.TotalSumContractorsMspAtWinner
			,(CASE WHEN NOT AC.SummingupTime = '0001-01-01 00:00:00.0000000' THEN AC.SummingupTime END) AS SummingupTime
			,AC.NumberOfFinalProtocol
			,(CASE WHEN NOT AC.DateSendFinalProtocolToProfileDepartmentChief = '0001-01-01 00:00:00.0000000' THEN AC.DateSendFinalProtocolToProfileDepartmentChief END) AS DateSendFinalProtocolToProfileDepartmentChief
			--Примечание --нет в АСУЗД
			--Причина несостоявщейся процедуры --(CASE WHEN THEN END)
			--Наименование участника с которым заключается договор по п. 7.5.8.Стандарта --детект по косвенным признакам
			,CA.[Name] AS CodeActivityName
			,CA.[Code] AS [CodeActivityCode]
			,APRA.[Description] AS [AdditionalPRAttributeDescription]
		FROM (
				SELECT
					[ItemType]
					,[ProtocolCzoId]
					,[RequestId]
					,(CASE --for patch status detection failure
						WHEN RequestId IN (
											SELECT
												RequestId
											FROM [dbo].[AuctionCycles] AS AC
											FULL OUTER JOIN (
															SELECT
																AuctionCycleId
															FROM
															(
																SELECT
																	*
																FROM [vc].[CZOPR_Data]
															) AS SQ0
															WHERE NOT AuctionCycleId IS NULL
														) AS ACCorrection ON ACCorrection.AuctionCycleId = AC.Id
														WHERE ACCorrection.AuctionCycleId IS NULL
														OR AC.Id IS NULL
											)
							THEN
								(CASE
									WHEN VersionPriority2 > 1
										THEN 190
									ELSE ( -- because AuctionCycles dont write actual Status in it, only last when user pushed the button Repeat Trade
											SELECT
												[Status]
											FROM [dbo].[PurchaseRequests]
											WHERE [Id] = RequestId
										 )
								END)
						ELSE [Status]
					END) AS [Status]
					,SQ2.[Stage]
					,[AuctionCycleId]
					,[PurchaseNumber]
					,[LotNumber]
					,[ProtocolNumber]
					,[Name]
					,[OkvedId]
					,[OkdpId]
					,[PlannedSumByNotificationNotax]
					,[PlannedSumByNotificationTax]
					,[PlannedSumWith30PercReductionNotax]
					,[PlannedSumWith30PercReductionTax]
					,[TaxPercent]
					,[IsApproved]
					,[Actions]
					,[CustomerOrganization]
					,[CustomerSubdivision]
					,[CustomerFunctionalBlock]
					,[CustomerOrganizer]
					,[FinanceResources]
					,[PlannedPurchaseMethodCode]
					,SQ2.[OwnerOrganizationId]
					,[IsElectronicPurchase]
					,[PublicationPlannedDate]
					,[PlannedDateOfContract]
					,[PlannedDateOfDelivery]
					,[PlannedDateOfCompletion]
					,[SummingupTime]
					,[ForSmallOrMiddle]
					,[AdditionalInfo]
					,[ReasonPurchaseEP]
					,[ContractorName]
					,[CodeActivityId]
					,[CodeActivityCode]
					,[IsInIpr]
					,[ProcessConnection]
					,[PurchaseMethodName]
					,[PurchasePlanYear]
					,[ProductTypeId]
					,[PurchaseCategory_Id]
					,[IsInnovation]
					,[PurchasePriceDocumentCode]
					,[PlannedSumNotax]
					,[IsImported]
					,[InvestProjectName]
					,[DateEndProject]
					,[Mba]
					,[Kilometer]
					,[Note]
					,[CreatorUserId]
					,[AddedTime]
					,[IprYear]
					,[InvestProjectCode]
					,[DateApprovalConstructionDocuments]
					,[IsApprovedConstructionDocuments]
					,[IsNeedConstructionDocuments]
					,[CostProject]
					,[MegaWatt]
					,[PrivilegedProcessConnection]
					,[ExpWerePpriceNegotiations]
					,[ExpWinnerSumOnPpriceNegotiationsNoTax]
					,[ExpWinnerSumOnPpriceNegotiationsTax]
					,SQ2.[MinRequirementsForPurchaseGoods]
					,SQ2.[Okeiguid]
					,SQ2.[Qty]
					,SQ2.[Okato]
					,SQ2.[PlannedPurchaseYear]
					,SQ2.[AdditionalPRAttributeId]
				FROM
				(
					SELECT
						ROW_NUMBER() OVER (PARTITION BY [RequestId] ORDER BY [AuctionCycleId] DESC) AS VersionPriority2
						,*
					FROM
					(
						SELECT
							ROW_NUMBER() OVER (PARTITION BY [RequestId], [AuctionCycleId] ORDER BY [ProtocolCzoId] DESC) AS VersionPriority1
							,*
						FROM
						(
							SELECT
								[ItemType]
								,[ProtocolCzoId]
								,[RequestId]
								,[Status]
								,[Stage]
								,[AuctionCycleId]
								,[PurchaseNumber]
								,[LotNumber]
								,[ProtocolNumber]
								,[Name]
								,[OkvedId]
								,[OkdpId]
								,[PlannedSumByNotificationNotax]
								,[PlannedSumByNotificationTax]
								,[PlannedSumWith30PercReductionNotax]
								,[PlannedSumWith30PercReductionTax]
								,[TaxPercent]
								,[IsApproved]
								,[Actions]
								,[CustomerOrganization]
								,[CustomerSubdivision]
								,[CustomerFunctionalBlock]
								,[CustomerOrganizer]
								,[FinanceResources]
								,[PlannedPurchaseMethodCode]
								,[OwnerOrganizationId]
								,[IsElectronicPurchase]
								,[PublicationPlannedDate]
								,[PlannedDateOfContract]
								,[PlannedDateOfDelivery]
								,[PlannedDateOfCompletion]
								,[SummingupTime]
								,[ForSmallOrMiddle]
								,[AdditionalInfo]
								,[ReasonPurchaseEP]
								,[ContractorName]
								,[CodeActivityId]
								,[CodeActivityCode]
								,[IsInIpr]
								,[ProcessConnection]
								,[PurchaseMethodName]
								,[PurchasePlanYear]
								,[ProductTypeId]
								,[PurchaseCategory_Id]
								,[IsInnovation]
								,[PurchasePriceDocumentCode]
								,[PlannedSumNotax]
								,[IsImported]
								,[InvestProjectName]
								,[DateEndProject]
								,[Mba]
								,[Kilometer]
								,[Note]
								,[CreatorUserId]
								,[AddedTime]
								,[IprYear]
								,[InvestProjectCode]
								,[DateApprovalConstructionDocuments]
								,[IsApprovedConstructionDocuments]
								,[IsNeedConstructionDocuments]
								,[CostProject]
								,[MegaWatt]
								,[PrivilegedProcessConnection]
								,[ExpWerePpriceNegotiations]
								,[ExpWinnerSumOnPpriceNegotiationsNoTax]
								,[ExpWinnerSumOnPpriceNegotiationsTax]
								,[MinRequirementsForPurchaseGoods]
								,[Okeiguid]
								,[Qty]
								,[Okato]
								,[PlannedPurchaseYear]
								,[AdditionalPRAttributeId]
							FROM [vc].[CZOPR_Data]

							/*<for debugging>
							WHERE [RequestId] = 13368
							</for debugging>*/

							UNION

							--add losing purchase which trade more than one time at the same CZO protocol (mostly before EIS rebuild itself, when it's possible)
							SELECT
								[ItemType]
								,[ProtocolCzoId]
								,B.[RequestId]
								,B.[Status]
								,B.[Stage]
								,B.Id AS [AuctionCycleId]
								,[PurchaseNumber]
								,[LotNumber]
								,[ProtocolNumber]
								,[Name]
								,[OkvedId]
								,[OkdpId]
								,[PlannedSumByNotificationNotax]
								,[PlannedSumByNotificationTax]
								,[PlannedSumWith30PercReductionNotax]
								,[PlannedSumWith30PercReductionTax]
								,[TaxPercent]
								,[IsApproved]
								,[Actions]
								,[CustomerOrganization]
								,[CustomerSubdivision]
								,[CustomerFunctionalBlock]
								,[CustomerOrganizer]
								,[FinanceResources]
								,[PlannedPurchaseMethodCode]
								,[OwnerOrganizationId]
								,[IsElectronicPurchase]
								,[PublicationPlannedDate]
								,[PlannedDateOfContract]
								,[PlannedDateOfDelivery]
								,[PlannedDateOfCompletion]
								,B.[SummingupTime]
								,[ForSmallOrMiddle]
								,[AdditionalInfo]
								,[ReasonPurchaseEP]
								,[ContractorName]
								,[CodeActivityId]
								,[CodeActivityCode]
								,[IsInIpr]
								,[ProcessConnection]
								,[PurchaseMethodName]
								,[PurchasePlanYear]
								,[ProductTypeId]
								,[PurchaseCategory_Id]
								,[IsInnovation]
								,[PurchasePriceDocumentCode]
								,[PlannedSumNotax]
								,[IsImported]
								,[InvestProjectName]
								,[DateEndProject]
								,[Mba]
								,[Kilometer]
								,[Note]
								,[CreatorUserId]
								,A.[AddedTime]
								,A.[IprYear]
								,A.[InvestProjectCode]
								,A.[DateApprovalConstructionDocuments]
								,A.[IsApprovedConstructionDocuments]
								,A.[IsNeedConstructionDocuments]
								,A.[CostProject]
								,A.[MegaWatt]
								,A.[PrivilegedProcessConnection]
								,A.[ExpWerePpriceNegotiations]
								,A.[ExpWinnerSumOnPpriceNegotiationsNoTax]
								,A.[ExpWinnerSumOnPpriceNegotiationsTax]
								,A.[MinRequirementsForPurchaseGoods]
								,A.[Okeiguid]
								,A.[Qty]
								,A.[Okato]
								,A.[PlannedPurchaseYear]
								,A.[AdditionalPRAttributeId]
							FROM [vc].[CZOPR_Data] AS A
							INNER JOIN	(
											SELECT
												*
											FROM [dbo].[AuctionCycles] AS AC
											FULL OUTER JOIN (
															SELECT
																AuctionCycleId
															FROM
															(
																SELECT
																	*
																FROM [vc].[CZOPR_Data]
															) AS SQ0
															WHERE NOT AuctionCycleId IS NULL
														) AS ACCorrection ON ACCorrection.AuctionCycleId = AC.Id
														WHERE ACCorrection.AuctionCycleId IS NULL
														OR AC.Id IS NULL
										) AS B ON B.RequestId = A.RequestId

							/*<for debugging>
							WHERE A.[RequestId] = 13368
							</for debugging>*/

						) AS SQ0

						/*<for debugging>
						WHERE SQ0.[RequestId] = 13368
						</for debugging>*/

					) AS SQ1
					WHERE VersionPriority1 = 1

					/*<for debugging>
					AND SQ1.[RequestId] = 13368
					</for debugging>*/

				) AS SQ2

				/*<for debugging>
				WHERE SQ2.[RequestId] = 13368
				</for debugging>*/

			 ) AS UPR -- for UnitedPurchaseRequests
		LEFT JOIN	(
						SELECT
							R.Name
							,R.FullName
							,R.HeadName
							,U.FirstName
							,U.MiddleName
							,U.LastName
							,U.UserName
							,UR.*
						FROM dbo.AspNetRoles AS R
						INNER JOIN dbo.AspNetUserRoles AS UR ON R.Id = UR.RoleId
						INNER JOIN dbo.AspNetUsers AS U ON UR.UserId = U.Id
						WHERE R.[IsGroup] = 1
						AND R.[GroupRole] = 'Customer'
					) AS Groups ON Groups.UserName = UPR.[CreatorUserId]
		LEFT JOIN [dbo].[AuctionCycles] AS AC ON AC.Id = UPR.[AuctionCycleId]
		LEFT JOIN [dbo].[NsiPurchaseCategories] AS PCategory ON PCategory.Id = UPR.PurchaseCategory_Id
		LEFT JOIN dbo.NsiOkved2Item AS OKVED ON OKVED.Id = UPR.OkvedId
		LEFT JOIN dbo.NsiOkdp2Item AS OKDP ON OKDP.id = UPR.OkdpId
		LEFT JOIN [dbo].[NsiCodeActivities] AS CA ON CA.Id = UPR.CodeActivityId
		LEFT JOIN [dbo].[ProtocolCzoes] AS PCZO ON PCZO.Id = UPR.ProtocolCzoId
		LEFT JOIN [dbo].[TechnicalProjectRequests] AS TZR ON TZR.AuctionCycleId = UPR.[AuctionCycleId]
		LEFT JOIN [dbo].[TechnicalProjects] AS TZ ON TZ.Id = TZR.TechnicalProjectId
		LEFT JOIN [dbo].[NsiEtps] AS ETP ON ETP.Code = TZ.EtpCode
		LEFT JOIN [dbo].[AspNetUsers] AS Purchaser ON Purchaser.Id = TZ.ExecutorId
		LEFT JOIN [dbo].[AspNetUsers] AS TZCreator ON TZCreator.Id = TZ.[UserId]
		LEFT JOIN [dbo].[v_AuctionCycleLastStage] AS AST ON AST.[AuctionCycleId] = UPR.[AuctionCycleId]
		LEFT JOIN [dbo].[RequestParticipiants] AS RP ON RP.[AuctionStageId] = AST.Id
		LEFT JOIN [dbo].[NsiProductTypes] AS PrTYPE ON PrTYPE.Id = UPR.ProductTypeId
		LEFT JOIN [dbo].[NsiPurchasePriceDocuments] AS PPD ON PPD.Code = UPR.PurchasePriceDocumentCode
		LEFT JOIN [dbo].[NsiRequirementsForPurchaseGoods] AS MinReq ON MinReq.Code = UPR.[MinRequirementsForPurchaseGoods]
		LEFT JOIN [dbo].[NsiOkeiItems] AS OKEI ON OKEI.[guid] = UPR.[Okeiguid]
		LEFT JOIN [dbo].[NsiOkatoItems] AS OKATO ON OKATO.code = UPR.[Okato]
		LEFT JOIN [dbo].[PurchaseMethods] AS PurMethod ON (PurMethod.[Code] = UPR.[PlannedPurchaseMethodCode]) AND (PurMethod.OrganisationId = UPR.[OwnerOrganizationId])
		LEFT JOIN [vc].[guesCZOPr] AS GCZO ON GCZO.PurchaseID = UPR.RequestId
		LEFT JOIN	(
						SELECT
							[AuctionStageId]
							,COUNT(NULLIF([Rejected],0)) AS CountParticipiantsRejected
						FROM [dbo].[RequestParticipiants]
						GROUP BY [AuctionStageId]
					) AS PRejected ON PRejected.AuctionStageId = AST.Id
		LEFT JOIN	(
						SELECT DISTINCT
							TechExpertise.[AuctionCycleId]
							,TechExpertise.[DateOfPassDocumentsForExamination]
							,[UnitResponsibleForExamination]
							,[DateReceipExpertOpinion]
						FROM [dbo].[AuctionStages] AS TechExpertise
						INNER JOIN (
							SELECT [AuctionCycleId] ,MAX([DateOfPassDocumentsForExamination]
							)
						AS [DateOfPassDocumentsForExamination]
						FROM [dbo].[AuctionStages]
						WHERE [IsNeedExpertise] = 1
						GROUP BY [AuctionCycleId]) AS LastTechExpertise ON LastTechExpertise.AuctionCycleId = TechExpertise.AuctionCycleId AND LastTechExpertise.[DateOfPassDocumentsForExamination] = TechExpertise.DateOfPassDocumentsForExamination
					) AS Expertise ON Expertise.AuctionCycleId = UPR.[AuctionCycleId]
		LEFT JOIN	(
						SELECT [AuctionCycleId] ,MAX([DateReceiptOfDocumentsUponReRequest]) AS DateReceiptOfDocumentsUponReRequest
						FROM [dbo].[AuctionStages]
						WHERE [IsNeedReRequest] = 1
						GROUP BY [AuctionCycleId]
					) AS LastReRequest ON LastReRequest.AuctionCycleId = UPR.AuctionCycleId
		LEFT JOIN	(
						SELECT
							[AuctionCycleId]
							,MAX([DateStartRebidding]) AS DateStartRebidding
							,MAX([DateStopRebidding]) AS DateStopRebidding
							,COUNT([IsNeedRebidding]) AS RebiddingAmount
						FROM [dbo].[AuctionStages]
						WHERE [IsNeedRebidding] = 1
						GROUP BY [AuctionCycleId]
					) AS LastRebidding ON LastRebidding.AuctionCycleId = UPR.AuctionCycleId
		LEFT JOIN	(
						SELECT
							*
							,CAST(ExtramuralAmount AS nvarchar(40)) + N'з'
							+ '|' + CAST(IntramuralAmount AS nvarchar(40)) + N'о' AS [FancyRebiddingStatistics]
						FROM
						(
						SELECT
							CASE WHEN Extramural.AuctionCycleId IS NULL THEN Intramural.AuctionCycleId
								ELSE Extramural.AuctionCycleId
							END AS [AuctionCycleId]
							,CASE WHEN Extramural.ExtramuralAmount IS NULL THEN 0
								ELSE Extramural.ExtramuralAmount
							END AS [ExtramuralAmount]
							,CASE WHEN Intramural.IntramuralAmount IS NULL THEN 0
								ELSE Intramural.IntramuralAmount
							END AS [IntramuralAmount]
						FROM
						(
							SELECT AuctionCycleId, COUNT(*) AS [ExtramuralAmount]
							FROM dbo.AuctionStages
							WHERE IsNeedRebidding = 1 AND RebiddingType = 'Extramural'
							GROUP BY AuctionCycleId
						) AS Extramural
						FULL OUTER JOIN (
						SELECT * FROM
						(
							SELECT AuctionCycleId, COUNT(*) AS [IntramuralAmount]
							FROM dbo.AuctionStages
							WHERE IsNeedRebidding = 1 AND RebiddingType = 'Intramural'
							GROUP BY AuctionCycleId
						) AS Intramural
						) AS Intramural ON Extramural.AuctionCycleId = Intramural.AuctionCycleId
						) AS RebiddingTypeStatistic
					) AS RebiddingTypeStatistic ON RebiddingTypeStatistic.AuctionCycleId = UPR.AuctionCycleId
		LEFT JOIN	dbo.AdditionalPRAttributes AS APRA ON APRA.Id = UPR.[AdditionalPRAttributeId]

        where AC.RequestId = 20846