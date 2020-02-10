select count(*)
from ChangeLogs
where ModifiedBy is not NULL
and getdate() - DateChanged < 30

