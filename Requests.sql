USE ASUZD

declare  @prID as int = 20623

begin tran updReqStatus

    update PurchaseRequests
    set
           Name = N'Оказание услуг по предоставлению кредитных ресурсов в форме возобновляемой кредитной линии для АО «ЕЭСК» с лимитом задолженности 500 000 000 рублей сроком на 36 месяцев',
           PlannedSumTax = 145500000,
           PlannedSumNotax = 145500000,
           PlannedSumByNotificationTax = 145500000,
           PlannedSumByNotificationNotax = 145500000
    where id = @prID

    select  pr.Name,
            pr.PlannedSumTax,
            pr.PlannedSumNotax,
            pr.PlannedSumByNotificationTax,
            pr.PlannedSumByNotificationNotax
    from PurchaseRequests pr
    left join AuctionCycles ac on pr.Id = ac.RequestId
    left join TechnicalProjectRequests tpr on tpr.AuctionCycleId = ac.Id
    left join TechnicalProjects tp on tpr.TechnicalProjectId = tp.Id
    left join Status s on s.Id = pr.Status
    where pr.Id = @prID

-- rollback tran
commit tran