select Okato, PlannedDateOfCompletion, PlannedDateOfDelivery, ReasonPurchaseEP
from PurchaseRequests
where Id in (19764, 19765, 19766, 19941)

select *
from ChangeLogs
where PrimaryKeyValue in ('19764', '19765', '19766', '19941')
    and PropertyName in ('PlannedDateOfDelivery', 'PlannedDateOfCompletion', 'Okato')

set dateformat dmy

begin tran updateInfo

update PurchaseRequests
set Okato = '57000000000',
    PlannedDateOfCompletion = '01.10.2020 0:00:00',
    PlannedDateOfDelivery = '15.11.2019 0:00:00'
where id = 19941

select Okato, PlannedDateOfCompletion, PlannedDateOfDelivery, ReasonPurchaseEP
from PurchaseRequests
where Id = 19941

rollback tran