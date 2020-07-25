use ASUZD
select id, Status
from TechnicalProjects
where id = 14861

begin tran UpdateTZ

    update TechnicalProjects
    set Status = 8
    where id = 14861

    select id, Status
    from TechnicalProjects
    where id = 14861

-- rollback tran
commit tran


select 'Status', id, Description
from Status
union
select 'Stage', id, Description
from Stages