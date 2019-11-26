USE ASUZD
select  pr.Id
        ,anu.FirstName + ' ' + anu.MiddleName + ' ' + anu.LastName
        ,'ToDo Дата получения ТЗ для проведения процедуры торгов'
        ,pr.Status
        ,pr.Name
        ,pr.PlannedPurchaseMethodCode
        ,tp.Id
        ,pr.CustomerOrganizer
        ,tp.ExpEnvelopeOpeningTime
     ,  exp.Id
     , et.Description
     , ai.Time
     , ai.Message
     , case
         when ai.Message = N'Статус изменен: ''Черновик'' -> ''Новая''' then N'Отправлено'
         when ai.Message = N'Статус изменен: ''В работе'' -> ''Выполнена''' then N'Получено'
         else 'NULL'
       end as Status
     , pr.Status
from Expertises exp
left join AuditItemExpertises aud on exp.Id = aud.ExpertiseId
left join AuditItems AI on aud.ItemId = AI.Id
left join ExpertiseTypes ET on exp.Type = ET.Code
left join AuctionStages [AS] on exp.AuctionStage_Id = [AS].Id
left join AuctionCycles AC on [AS].AuctionCycleId = AC.Id
left join PurchaseRequests PR on AC.RequestId = PR.Id
left join TechnicalProjectRequests TPR on AC.Id = TPR.AuctionCycleId
left join TechnicalProjects TP on TPR.TechnicalProjectId = TP.Id
left join AspNetUsers ANU on TP.ExecutorId = ANU.Id

where pr.Id = 20509