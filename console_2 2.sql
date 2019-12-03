use ASUZD
select pf.*
from ProtocolFiles pf
join FileDatas fd on pf.Data_Id = fd.Id
where ProtocolId = 427

select *
from RequestFiles
join FileDatas FD on RequestFiles.Data_Id = FD.Id
where RequestId = 22601

select *
from ProtocolCzoes
where Id = 427

select *
from TechnicalProjectFiles
join FileDatas FD on TechnicalProjectFiles.Data_Id = FD.Id
where TechnicalProject_Id = 13449


begin tran upd

update TechnicalProjectFiles
    set Version = 2
    where TechnicalProject_Id = 13449 and Data_Id = '665AD275-EA14-EA11-93F6-005056BD0BDE'


select *
from TechnicalProjectFiles
join FileDatas FD on TechnicalProjectFiles.Data_Id = FD.Id
where TechnicalProject_Id = 13449


rollback tran