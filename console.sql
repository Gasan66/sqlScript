use ASUZD
select *
from RequestFiles
join FileDatas FD on RequestFiles.Data_Id = FD.Id
where RequestId = 22601

begin tran addFile
    update FileDatas
    set Name = N'old_Аналитическая записка 20368_ЗПэфМСП _12719_3.pdf'
    where Id = '66083F7A-E914-EA11-93F6-005056BD0BDE'


    select *
    from RequestFiles
    join FileDatas FD on RequestFiles.Data_Id = FD.Id
    where RequestId = 22289
rollback tran
