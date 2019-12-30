use ASUZD
select *
from RequestFiles rf
join FileDatas FD on rf.Data_Id = FD.Id
where RequestId = 19428

select *
from ProtocolFiles pf
join FileDatas FD on pf.Data_Id = FD.Id
where ProtocolId = 452




begin tran updFile

--     insert into RequestFiles
--     values (19428, 5, 2, '2C625239-A727-EA11-A126-005056BD0BDE')

    update FileDatas
        set Name = N'Old_Протокол итоговый ЗПэфМСП 13205.pdf'
--         set Version = 1
    where id = '70EF16B5-8021-EA11-A126-005056BD0BDE';

    select *
    from RequestFiles rf
    join FileDatas FD on rf.Data_Id = FD.Id
    where RequestId = 19428

-- rollback tran
commit tran