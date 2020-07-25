use ASUZD

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
				    and RequestId = 20846

					/*<for debugging>
					AND SQ1.[RequestId] = 13368
					</for debugging>*/

				) AS SQ2