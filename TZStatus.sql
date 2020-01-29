use ASUZD
select id, Status
from TechnicalProjects
where id = 13551

begin tran UpdateTZ

    update TechnicalProjects
    set Status = 7
    where id = 13551

    select id, Status
    from TechnicalProjects
    where id = 13551

-- rollback tran
commit tran


select 'Status', id, Description
from Status
union
select 'Stage', id, Description
from Stages