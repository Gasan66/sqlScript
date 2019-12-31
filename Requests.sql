USE ASUZD

declare  @prID as int = 21615

select      pr.PlannedPurchaseMethodCode

    from PurchaseRequests pr
    left join AuctionCycles ac on pr.Id = ac.RequestId
    left join TechnicalProjectRequests tpr on tpr.AuctionCycleId = ac.Id
    left join TechnicalProjects tp on tpr.TechnicalProjectId = tp.Id
    left join Status s on s.Id = pr.Status
    left join LongTermPurschasePayments ltpp on ac.Id = ltpp.AuctionCycleId
    where pr.Id = @prID

begin tran updReqStatus

    update PurchaseRequests
    set
           PlannedPurchaseMethodCode = N'КэфМСП'
    where id in (21615,
                 21646,
                 21810,
                 21841)

    select      pr.PlannedPurchaseMethodCode

    from PurchaseRequests pr
    left join AuctionCycles ac on pr.Id = ac.RequestId
    left join TechnicalProjectRequests tpr on tpr.AuctionCycleId = ac.Id
    left join TechnicalProjects tp on tpr.TechnicalProjectId = tp.Id
    left join Status s on s.Id = pr.Status
    left join LongTermPurschasePayments ltpp on ac.Id = ltpp.AuctionCycleId
    where pr.Id in (21615,
                 21646,
                 21810,
                 21841)

rollback tran
-- commit tran