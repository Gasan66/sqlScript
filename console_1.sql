use ASUZD

select pr.Status as prSt,
        ac.Status as acSt,
        tp.Status,
        stpr.Description,
        stac.Description,
       pr.Id,
       ac.*


from PurchaseRequests pr
join AuctionCycles ac on pr.Id = ac.RequestId
join TechnicalProjectRequests tpr on ac.Id = tpr.AuctionCycleId
join TechnicalProjects tp on tpr.TechnicalProjectId = tp.Id
join Status stpr on stpr.Id = pr.Status
join Status stac on stac.Id = ac.Status
where tp.id in (14251, 14396, 14559)

select pr.id, pr.Status, ac.*
from AuctionCycles ac
join PurchaseRequests pr on ac.RequestId = pr.Id
where pr.Status = 200
order by pr.Id