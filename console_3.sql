use ASUZD

select PurchaserFullName
        , sum(case when Description = N'Согласование ТЗ' then 1 end) as N'Согласование ТЗ'
        , sum(case when Description = N'Отказ согласования ТЗ' then 1 end) as N'Отказ согласования ТЗ'
        , sum(case when Description = N'На торгах (ЭТП)' then 1 end) as N'На торгах (ЭТП)'
from vc.PurchasePlanRealizationReport
where PurchasePlanYear = 2019
group by PurchaserFullName

select *
from PurchaseRequests
where Id = 22065

select t.LastName,
       sum(case when t.Description = N'Согласование ТЗ' then 1 else 0 end) as N'Согласование ТЗ',
       sum(case when t.Description = N'Отказ согласования ТЗ' then 1 else 0 end) as N'Отказ согласования ТЗ',
       sum(case when t.Description = N'На торгах (ЭТП)' then 1 else 0 end) as N'На торгах (ЭТП)',
       sum(case when t.Description = N'Необходимо вскрыть конверты' then 1 else 0 end) as N'Необходимо вскрыть конверты',
       sum(case when t.Description = N'На экспертизе' then 1 else 0 end) as N'На экспертизе',
       sum(case when t.Description = N'Ожидание подписания протокола рассмотрения' then 1 else 0 end) as N'Ожидание подписания протокола рассмотрения',
       sum(case when t.Description = N'На переторжке (ЭТП)' then 1 else 0 end) as N'На переторжке (ЭТП)',
       sum(case when t.Description = N'Рассмотрение после переторжки' then 1 else 0 end) as N'Рассмотрение после переторжки',
       sum(case when t.Description = N'Ожидание подписания итогового протокола' then 1 else 0 end) as N'Ожидание подписания итогового протокола',
       sum(case when t.Description = N'Торги отменены' then 1 else 0 end) as N'Торги отменены',
       sum(case when t.Description = N'Торги не состоялись' then 1 else 0 end) as N'Торги не состоялись',
       sum(case when t.Description = N'Торги не состоялись п. 7.5.4. (7.5.5. по стандарту 2018 г.)' then 1 else 0 end) as N'Торги не состоялись п. 7.5.4. (7.5.5. по стандарту 2018 г.)',
       sum(case when t.Description = N'Торги не состоялись п. 7.5.7. (7.5.8. по стандарту 2018 г.)' then 1 else 0 end) as N'Торги не состоялись п. 7.5.7. (7.5.8. по стандарту 2018 г.)',
       sum(case when t.Description = N'Торги состоялись' then 1 else 0 end) as N'Торги состоялись'
from(
select row_number() over (partition by pr.Id order by ac.Id desc) as Number,
       anu.LastName,
       Status.Description,
       pr.*
from PurchaseRequests pr
join AuctionCycles ac on pr.Id = ac.RequestId
join TechnicalProjectRequests tpr on ac.Id = tpr.AuctionCycleId
join TechnicalProjects TP on tpr.TechnicalProjectId = TP.Id
join AspNetUsers ANU on TP.ExecutorId = ANU.Id
join Status on pr.Status = Status.Id) as t
where Number = 1 and t.PurchasePlanYear = '2019'
group by t.LastName
order by t.LastName

select *
from Status