use ASUZD
select *
from RequestFiles rf
join FileDatas FD on rf.Data_Id = FD.Id
where RequestId = 22601

select *
from ProtocolFiles pf
join FileDatas FD on pf.Data_Id = FD.Id
where ProtocolId = 452

select *
from ProtocolFiles pf
join FileDatas FD on pf.Data_Id = FD.Id
where pf.ProtocolId = 465




begin tran updFile

    insert into ProtocolFiles
    values (462, 2, 0, 'D940DA4B-5947-EA11-9E59-005056BD0BDE')

--     update FileDatas
--         set Name = N'Old_Протокол итоговый ЗПэфМСП 13205.pdf'
-- --         set Version = 1
--     where id = '70EF16B5-8021-EA11-A126-005056BD0BDE';

    select *
    from ProtocolFiles pf
    join FileDatas FD on pf.Data_Id = FD.Id
    where pf.ProtocolId = 462

-- rollback tran
commit tran