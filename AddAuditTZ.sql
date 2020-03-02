use ASUZD
begin tran createAuditItem

    declare @TZ bigint = 14220
    declare @date nvarchar(50) = current_timestamp
    declare @userId nvarchar(50) = '865341a5-ee62-4814-8b29-8ca8d7bc5884'
    declare @message nvarchar(max) = N'Удалил приказ 457 и добавил 466'

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


-- rollback tran
commit tran
