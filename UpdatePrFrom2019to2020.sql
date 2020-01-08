select distinct (pr.PlannedPurchaseYear)
-- into PurchaseRequest_2019_to_2020
from ProtocolCzoItems pci
left join PurchaseRequests pr on pci.NumberPurchase = pr.Id
where Protocol_Id = 395 or Protocol_Id = 386 or pr.Id in (
    22679,
22696,
22738,
22739,
22741,
22742,
22743,
22744,
22745,
22747,
22748,
22749,
22751,
22752,
22753,
22754,
22755,
22756,
22757,
22758,
22759,
22760,
22761,
22762,
22763,
22764,
22765,
22766,
22767,
22768,
22769,
22770,
22771,
22772,
22773,
22774,
22775,
22776,
22778,
22780
    )

-- drop table PurchaseRequest_2020


begin tran updPurPlanYear

    update PurchaseRequests
    set PurchasePlanYear = 2020
    where Id in (
        select pr2020.id
        from PurchaseRequest_2019_to_2020 pr2020
    )

    update ProtocolCzoItems
    set PurchasePlanYear = 2020
    where NumberPurchase in (
        select pr2020.id
        from PurchaseRequest_2019_to_2020 pr2020
        )

    select distinct (PurchasePlanYear), count(*)
    from ProtocolCzoItems
    where NumberPurchase in (
        select pr2020.id
        from PurchaseRequest_2019_to_2020 pr2020
        )
    group by PurchasePlanYear

rollback tran
-- commit tran

begin tran addAuditToRequest

--     insert into AuditItems
--     values (current_timestamp, '865341a5-ee62-4814-8b29-8ca8d7bc5884', N'Изменил PurchasePlanYear на 2020', 0, 1)

    select *
    from AuditItems
    where id = 702689

    insert into AuditItemRequests
    select 702689, id
    from PurchaseRequest_2019_to_2020

rollback tran
-- commit tran






select *
-- into ProtocolCzo_2019_to_2020
from ProtocolCzoes
where id in (395, 386, 391)

begin tran updProtocolCZOto2020

    update ProtocolCzoes
    set CreationTime = current_timestamp,
        ModifiedTime = current_timestamp,
        CompleteTime = current_timestamp,
        Status = 2,
        LoadedToOos = 1
    where id in (395)

    select *
    from ProtocolCzoes
    where id in (395, 391)

-- rollback tran
commit tran
