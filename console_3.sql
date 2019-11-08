use ASUZD

select id, Status, Stage
from PurchaseRequests
where id in (18659, 18679, 18782, 18846)

begin tran updateStatusStage

    update PurchaseRequests
    set Status = 177, Stage = 4
    where id in (18659, 18679, 18782, 18846)

    select id, Status, Stage
    from PurchaseRequests
    where id in (18659, 18679, 18782, 18846)

rollback tran
-- commit tran