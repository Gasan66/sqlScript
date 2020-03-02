select *
from TechnicalProjectOrders
-- join Orders O on TechnicalProjectOrders.OrderId = O.Id
where TechnicalProjectId = 14220

select *
from TechnicalProjectComissionMembers
join ComissionMembers CM on TechnicalProjectComissionMembers.ComissionMemberId = CM.Id
join Orders O on CM.Order_Id = O.Id
join AspNetUsers ANU on CM.ApplicationUserId = ANU.Id
where TechnicalProjectId = 14220


