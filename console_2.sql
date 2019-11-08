use ASUZD

select PurchaseRequests.Id
from ASUZD.dbo.ProtocolCzoes pc
left join ASUZD.dbo.ProtocolCzoItems pci on pc.Id = pci.Protocol_Id
left join ASUZD.dbo.AuctionCycles on pci.AuctionCycleId = AuctionCycles.Id
left join ASUZD.dbo.PurchaseRequests on AuctionCycles.RequestId = PurchaseRequests.Id
where pc.Id = 395

select *
from LongTermPurschasePayments ltpp
left join AuctionCycles AC on ltpp.AuctionCycleId = AC.Id
left join PurchaseRequests PR on AC.RequestId = PR.Id
where pr.Id = 16840

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
  WHERE LTP.PaymentYear = 2020 and pr.Id = 16840