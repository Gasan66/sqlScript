use ASUZD
begin tran createAuditItem

    declare @TZ bigint = 12813
    declare @date nvarchar(50) = '2019-11-06 22:35:14.143'
    declare @userId nvarchar(50) = '865341a5-ee62-4814-8b29-8ca8d7bc5884'
    declare @message nvarchar(max) = N'Удаление из ТЗ приказа № 483 по письму от Левина Мария Сергеевна Zurlova-MS@rosseti-ural.ru'

    insert into AuditItems
    values (@date,
            @userId,
            @message,
            0,
            1)

    insert into AuditItemTzs
    select id, @TZ
    from AuditItems
    where Time = @date and UserId = @userId


    select * from AuditItemTzs
    left join AuditItems AI on AuditItemTzs.ItemId = AI.Id
    where TechnicalProjectId = @TZ and ItemId in (select id
                                                        from AuditItems
                                                        where Time = @date and UserId = @userId)


rollback tran

-- commit tran
