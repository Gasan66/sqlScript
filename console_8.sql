use ASUZD

select *
from RequestFiles
left join FileDatas on RequestFiles.Data_Id = FileDatas.Id
where RequestId = 19040

insert into RequestFiles (RequestId, Type, Version, Data_Id)
values (19934, 5, 1, '830CEE88-830C-EA11-93F6-005056BD0BDE')