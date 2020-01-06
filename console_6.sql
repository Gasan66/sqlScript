select *
from ProtocolCzoItems
left join ProtocolCzoes PC on ProtocolCzoItems.Protocol_Id = PC.Id
where Protocol_Id = 395