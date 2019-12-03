use ASUZD
select exp.*
from Expertises exp
-- left join AuditItemExpertises aud on exp.Id = aud.ExpertiseId
-- left join AuditItems AI on aud.ItemId = AI.Id
-- left join ExpertiseTypes ET on exp.Type = ET.Code
-- left join AuctionStages [AS] on exp.AuctionStage_Id = [AS].Id
-- left join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
-- left join PurchaseRequests PR on AC.RequestId = PR.Id
where exp.AuctionStage_Id = '50FD7682-4CEB-4FCA-86D9-008C4CBC690A'

select distinct Expertises.Type
from Expertises;

with
    ExpertisesFirstPart as(
        select *
        from Expertises
        where Type = 'FirstPart'
    ),
    ExpertisesSecondPart as(
        select *
        from Expertises
        where Type = 'SecondPart'
    ),
    ExpertisesPriceOffer as(
        select *
        from Expertises
        where Type = 'PriceOffer'
    )

select      efp.Id
        ,esp.Id
        ,epo.id
        ,case
            when efp.AuctionStage_Id is not null then efp.AuctionStage_Id
            when esp.AuctionStage_Id is not null then esp.AuctionStage_Id
         else epo.AuctionStage_Id
        end as 'AuctionStage_Id'
        ,efp.TimeAdd
        ,efp.TimeFinish
        ,esp.TimeAdd
        ,esp.TimeFinish
        ,epo.TimeAdd
        ,epo.TimeFinish
from  ExpertisesFirstPart efp
full outer join ExpertisesSecondPart esp on efp.AuctionStage_Id = esp.AuctionStage_Id
full outer join ExpertisesPriceOffer epo on efp.AuctionStage_Id = epo.AuctionStage_Id
order by 4


select pr.Id as 'номер лота'
     ,ac.Id as 'номер цикла'
--      ,exp.Type
     ,[as].Id as 'номер стадии'
     ,anu.LastName as 'фамилия закупщика'
     ,N'ToDo Дата получения ТЗ для проведения процедуры торгов'
     ,stat.Description as 'статус лота'
     ,pr.Name as 'предмет закупки'
     ,pr.PlannedPurchaseMethodCode as 'метод закупки'
     ,tp.Id as 'номер ТЗ'
     ,pr.CustomerOrganizer as 'организация'
     ,tp.ExpEnvelopeOpeningTime as 'дата вскрытия'
--        ,exp.Id
        ,max(case
            when exp.Type = 'FirstPart' then exp.TimeAdd
         end) as 'начало первых частей'
        ,max(case
            when exp.Type = 'FirstPart' then exp.TimeFinish
         end) as 'конец первых частей'
        ,max(case
            when exp.Type = 'SecondPart' then exp.TimeAdd
         end) as 'начало вторых частей'
        ,max(case
            when exp.Type = 'SecondPart' then exp.TimeFinish
         end) as 'конец вторых частей'
        ,max(case
            when exp.Type = 'PriceOffer' then exp.TimeAdd
         end) as 'начало ценового предложения'
        ,max(case
            when exp.Type = 'PriceOffer' then exp.TimeFinish
         end) as 'конец ценового предложения'
from Expertises exp
join AuctionStages [AS] on exp.AuctionStage_Id = [AS].Id
join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
join PurchaseRequests PR on AC.RequestId = PR.Id
join Status stat on stat.Id = pr.Status
join TechnicalProjectRequests TPR on AC.Id = TPR.AuctionCycleId
join TechnicalProjects TP on TPR.TechnicalProjectId = TP.Id
join AspNetUsers ANU on TP.ExecutorId = ANU.Id
where exp.Type in ('FirstPart', 'SecondPart', 'PriceOffer') and exp.AssignedGroupId <> 'abeff4d0-1b43-46b8-a09e-c09fc61d0854'
and exp.Status = 'Accepted' and exp.AssignedGroupId != '248bed81-4007-4348-a87e-8cee7394861e'
group by pr.Id, ac.Id, [as].Id, ANU.LastName, stat.Description, pr.Name, pr.PlannedPurchaseMethodCode, tp.Id, pr.CustomerOrganizer, tp.ExpEnvelopeOpeningTime
-- and pr.Id = 16802

select pr.Id, ac.Id, exp.Type, Count(*)
from Expertises exp
join AuctionStages [AS] on exp.AuctionStage_Id = [AS].Id
join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
join PurchaseRequests PR on AC.RequestId = PR.Id
where exp.Type in ('FirstPart', 'SecondPart', 'PriceOffer') and exp.AssignedGroupId != 'abeff4d0-1b43-46b8-a09e-c09fc61d0854'
and exp.Status = 'Accepted' and exp.AssignedGroupId != '248bed81-4007-4348-a87e-8cee7394861e'
group by pr.Id, ac.Id, exp.Type having count(*) > 1

