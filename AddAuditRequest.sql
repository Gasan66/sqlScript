use ASUZD
begin tran createAuditItem

<<<<<<< HEAD
declare @requestId bigint = 20290
declare @date nvarchar(50) = '2019-12-05 22:10:14.143'
declare @userId nvarchar(50) = '865341a5-ee62-4814-8b29-8ca8d7bc5884'
declare @message nvarchar(max) = N'Отменил согласование Дьячук Марины Геннадьевны по письму от Дьячук Марина Геннадьевна Tyukhtina-MG@rosseti-ural.ru'
=======
declare @requestId bigint = 19439
declare @date nvarchar(50) = '2019-12-06 09:10:14.143'
declare @userId nvarchar(50) = '865341a5-ee62-4814-8b29-8ca8d7bc5884'
declare @message nvarchar(max) = N'Добавил файл "Соглашение преддоговорных переговоров ЗПэфМСП 12833"'
>>>>>>> 6a5bf56e7224db4c64f8c1d64c2435cede8996b5

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


-- rollback tran

commit tran
