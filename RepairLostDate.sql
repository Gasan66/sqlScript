-- create table with bad request
select id
into #badreq
from PurchaseRequests
where Id in (12733,
14342,
14353,
14354,
14471,
17315,
18301,
18420,
19114,
19118,
19119,
19120,
19121,
19129,
19130,
19131,
19132,
19133,
19134,
19135,
19136,
19148,
19153,
19156,
19160,
19164,
19204,
19205,
19207,
19208,
19209,
19211,
19219,
19222,
19226,
19227,
19228,
19287,
19350,
19369,
19370,
19371,
19403,
19406,
19407,
19408,
19420,
19427,
19453,
19469,
19476,
19478,
19764,
19765,
19766,
19941,
19979,
19985,
19992,
20071,
20078,
20087,
20262,
20266,
20288,
20307,
20387,
20409,
20751,
20898,
20901)
and PlannedPurchaseMethodCode != N'ЕП'

select *
from #badreq

-- create table with true data

create table #goodData
(
RequestId nvarchar(max),
Okato nvarchar(max),
PlannedDateOfDelivery nvarchar(max),
PlannedDateOfCompletion nvarchar(max),
)

insert into #goodData (RequestId, Okato)
select PrimaryKeyValue,
       case when PropertyName = 'Okato' then NewValue else '' end as 'Okato'
from ChangeLogs chl1
inner join (select min(id) as minId from ChangeLogs group by PrimaryKeyValue, PropertyName) chl2 on chl1.Id = chl2.minId
where PrimaryKeyValue in (select cast(id as nvarchar) from #badreq) and PropertyName = 'Okato'

update #goodData
set PlannedDateOfDelivery = tmp1.PlannedDateOfDelivery
from #goodData gd
left join (
select PrimaryKeyValue,
       case when PropertyName = 'PlannedDateOfDelivery' then NewValue else '' end as 'PlannedDateOfDelivery'
from ChangeLogs chl1
inner join (select min(id) as minId from ChangeLogs group by PrimaryKeyValue, PropertyName) chl2 on chl1.Id = chl2.minId
where PrimaryKeyValue in (select cast(id as nvarchar) from #badreq) and PropertyName = 'PlannedDateOfDelivery') tmp1 on tmp1.PrimaryKeyValue = gd.RequestId

update #goodData
set PlannedDateOfCompletion = tmp1.PlannedDateOfCompletion
from #goodData gd
left join (
select PrimaryKeyValue,
       case when PropertyName = 'PlannedDateOfCompletion' then NewValue else '' end as 'PlannedDateOfCompletion'
from ChangeLogs chl1
inner join (select min(id) as minId from ChangeLogs group by PrimaryKeyValue, PropertyName) chl2 on chl1.Id = chl2.minId
where PrimaryKeyValue in (select cast(id as nvarchar) from #badreq) and PropertyName = 'PlannedDateOfCompletion') tmp1 on tmp1.PrimaryKeyValue = gd.RequestId

-- update #goodData
-- set ReasonPurchaseEP = tmp1.ReasonPurchaseEP
-- from #goodData gd
-- left join (
-- select PrimaryKeyValue,
--        case when PropertyName = 'ReasonPurchaseEP' then NewValue else '' end as 'ReasonPurchaseEP'
-- from ChangeLogs chl1
-- inner join (select min(id) as minId from ChangeLogs group by PrimaryKeyValue, PropertyName) chl2 on chl1.Id = chl2.minId
-- where PrimaryKeyValue in (select cast(id as nvarchar) from #badreq) and PropertyName = 'ReasonPurchaseEP') tmp1 on tmp1.PrimaryKeyValue = gd.RequestId

begin tran updateLostData

    update PurchaseRequests
        set Okato = gd.Okato, PlannedDateOfDelivery = cast(gd.PlannedDateOfDelivery as datetime2), PlannedDateOfCompletion = cast(gd.PlannedDateOfCompletion as datetime2)
        from PurchaseRequests pr
        inner join #goodData gd on pr.Id = gd.RequestId

    select id, Okato, PlannedDateOfDelivery, PlannedDateOfCompletion
        from PurchaseRequests
        where id in (select id from #badreq)
rollback tran

drop table #goodData
drop table #badreq
