use ASUZD
select *
from TechnicalProjectOrders
join Orders O on TechnicalProjectOrders.OrderId = O.Id
where TechnicalProjectId = 13556