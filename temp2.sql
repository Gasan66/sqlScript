select CreatorUserId, *
from PurchaseRequests pr
join AspNetUsers usr on usr.Id = pr.OwnerId
where pr.Id = 23035 or pr.Id = 23210