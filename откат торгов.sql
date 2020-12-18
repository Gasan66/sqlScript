-- ������ rollback �� commit ������ ��� ������ �����������.
-- ����� ���������� ���������� ��������� ��� ��� ���� ������������
use ASUZD

-- begin tran
	DECLARE @requestId bigint = 26796
    DECLARE @tzId bigint = 16325
	DECLARE @acId bigint = 33832
	DECLARE @asId nvarchar(max) = '0941EF62-096F-47B9-8259-65AF97E00D8C'
    -- �������� ������ ������� ����� �������/��������
	select * from AuctionCycles where id = @acId
	select * from AuctionStages where id = @asId
	select * from RequestParticipiants where AuctionStageId = @asId
	select * from ExpertisesHist where AuctionStage_Id = @asId

    -- ������� AS
	DELETE FROM [dbo].[AuctionStages] WHERE Id = @asId
	-- ��������� AC
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
	-- ������ ������ ������
	update dbo.PurchaseRequests
		SET 
			Stage = 4, -- ���
			Status = 120 -- �� ������
		WHERE Id = @requestId

    update TechnicalProjects
        set
			Status = 7 -- �� ������
		WHERE Id = @tzId
		
rollback tran