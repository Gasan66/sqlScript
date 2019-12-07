use ASUZD
select *
from ProtocolCzoes
join ProtocolCzoItems PCI on ProtocolCzoes.Id = PCI.Protocol_Id
join AuctionCycles AC on PCI.AuctionCycleId = AC.Id
join PurchaseRequests PR on AC.RequestId = PR.Id
where pr.Id = 19114


select *
from TechnicalProjects