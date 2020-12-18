-- менять rollback на commit только при полной уверенности.
-- после выполнения желательно сохранить все что было залогировано
use ASUZD

-- begin tran
	DECLARE @requestId bigint = 26796
    DECLARE @tzId bigint = 16325
	DECLARE @acId bigint = 33832
	DECLARE @asId nvarchar(max) = '0941EF62-096F-47B9-8259-65AF97E00D8C'
    -- логируем данные которые будут удалены/изменены
	select * from AuctionCycles where id = @acId
	select * from AuctionStages where id = @asId
	select * from RequestParticipiants where AuctionStageId = @asId
	select * from ExpertisesHist where AuctionStage_Id = @asId

    -- удаляем AS
	DELETE FROM [dbo].[AuctionStages] WHERE Id = @asId
	-- обновляем AC
	UPDATE dbo.AuctionCycles 
	SET [WerePpriceNegotiations] = 0
		,[WinnerSumOnPpriceNegotiationsNoTax] = 0
		,[WinnerSumOnPpriceNegotiationsTax] = 0
		,[WinnerDeadline] = NULL
		,[CountContractorsMspAtWinner] = 0
		,[TotalSumContractorsMspAtWinner] = 0
		,[SummingupTime] = '0001-01-01 00:00:00'
		,[FinalSumNoTax] = 0
		,[FinalSumTax] = 0
		,[NumberOfFinalProtocol] = NULL
		,[DateSendFinalProtocolToProfileDepartmentChief] = '0001-01-01 00:00:00'
		,[DateConclusionContract] = '0001-01-01 00:00:00'
		,[EndDateOfContract] = '0001-01-01 00:00:00'
		,[DateRequestForAdditionalAgreement] = '0001-01-01 00:00:00'
		,[DateReceiptResolutionProtocolCzoAddAgreement] = '0001-01-01 00:00:00'
		,[DateConclusionAdditionalAgreement] = '0001-01-01 00:00:00'
	where Id = @acId
	-- меняем статус заявки
	update dbo.PurchaseRequests
		SET 
			Stage = 4, -- ЭТП
			Status = 120 -- На торгах
		WHERE Id = @requestId

    update TechnicalProjects
        set
			Status = 7 -- На торгах
		WHERE Id = @tzId
		
rollback tran