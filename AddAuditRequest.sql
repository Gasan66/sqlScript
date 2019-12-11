use ASUZD
begin tran createAuditItem

declare @requestId bigint = 19294
declare @date nvarchar(50) = '2019-12-11 20:40:14.143'
declare @userId nvarchar(50) = '865341a5-ee62-4814-8b29-8ca8d7bc5884'
declare @message nvarchar(max) = N'Изменил статус на "Торги не состоялись п. 7.5.4. (7.5.5. по стандарту 2018 г.)" по письму от Кайгородцева Анна Павловна Kaygorodceva-AP@rosseti-ural.ru'

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
