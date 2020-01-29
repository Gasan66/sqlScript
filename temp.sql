select top 10 *
from AuctionStages
join AuctionCycles AC on AuctionStages.AuctionCycleId = AC.Id
join PurchaseRequests PR on AC.RequestId = PR.Id
where pr.Id = 20577

begin tran updAucSt
update AuctionStages
set IsNeedExpertise = 1
where Id = '118F389C-9D49-4734-BB0A-8C4FFCDF2C4F'
 select top 10 *
from AuctionStages
join AuctionCycles AC on AuctionStages.AuctionCycleId = AC.Id
join PurchaseRequests PR on AC.RequestId = PR.Id
where pr.Id = 20577
rollback tran


select top 10 ac.*
from AuctionCycles ac
join PurchaseRequests PR on ac.RequestId = PR.Id
where pr.Id = 22672


begin tran updAucCyc
    update AuctionCycles set FinalSumNoTax = 4474219.25, FinalSumTax = 5369063.10
    where id = 28828  ;

    select FinalSumTax, FinalSumNoTax
    from AuctionCycles
    where Id = 28828
rollback tran