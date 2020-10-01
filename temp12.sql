use ASUZD
select pr.id, ac.id, aus.*
from AuctionStages aus
join AuctionCycles AC on AC.Id = aus.AuctionCycleId
join PurchaseRequests pr on AC.RequestId = pr.Id
join TechnicalProjectRequests TPR on AC.Id = TPR.AuctionCycleId
where tpr.TechnicalProjectId = 15036

with manyRebidding as
         (
             select tpr.TechnicalProjectId,
                    tp.Name,
                    ac.Id    as aucId,
                    aus.IsNeedRebidding,
                    count(*) as cnt
             from AuctionStages aus
                      join AuctionCycles AC on AC.Id = aus.AuctionCycleId
                      join TechnicalProjectRequests TPR on AC.Id = TPR.AuctionCycleId
                      join TechnicalProjects tp on TPR.TechnicalProjectId = tp.Id
             where
                 aus.DateStartRebidding between '2020-08-01' and '2020-08-30'
                or aus.DateStopRebidding between '2020-08-01' and '2020-08-30'
             group by tpr.TechnicalProjectId,
                      ac.Id,
                      aus.IsNeedRebidding,
                      tp.Name
             having count(aus.IsNeedRebidding) > 1
         )
select mr.TechnicalProjectId,
       mr.Name,
       aus.DateStartRebidding,
       aus.DateStopRebidding
from AuctionStages aus
join manyRebidding mr on aus.AuctionCycleId = mr.aucId
where aus.IsNeedRebidding = 1