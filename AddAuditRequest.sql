use ASUZD
begin tran createAuditItem

declare @requestId bigint = 18479
declare @date nvarchar(50) = '2019-12-04 11:10:14.143'
declare @userId nvarchar(50) = '865341a5-ee62-4814-8b29-8ca8d7bc5884'
declare @message nvarchar(max) = N'Изменил значение PaymentSummWithTax на 478770136.78 для имключения ошибки "Согласование не запущено. Сумма долгосрочных оплат не совпадает с указанной ценой лота по извещению/уведомлению." по заявке Инцидент "(Наряд) IT-219749" ссылка https://10.81.35.30/sd/operator/#uuid:serviceCall$57201090'

insert into AuditItems
values (@date,
        @userId,
        @message,
        0,
        1)

insert into AuditItemRequests
select id, @requestId
from AuditItems
where Time = @date and UserId = @userId


select * from AuditItemRequests
left join AuditItems AI on AuditItemRequests.ItemId = AI.Id
where PurchaseRequestId = @requestId and ItemId in (select id
                                                                                    from AuditItems
                                                                                    where Time = @date and UserId = @userId)


rollback tran

-- commit tran
