use ASUZD
select id, Status
from TechnicalProjects
where id = 13337 or id = 12543

begin tran UpdateTZ

    update TechnicalProjects
    set Status = 2
    where id = 13337

    select id, Status
    from TechnicalProjects
    where id = 13337 or id = 12543

rollback tran