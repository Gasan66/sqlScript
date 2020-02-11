with last_active_usr as (
    select ordered_ch_logs.num,
           ordered_ch_logs.ModifiedBy,
           ordered_ch_logs.DateChanged
    from
                (select row_number() over (partition by cl.ModifiedBy order by cl.DateChanged desc ) 'num'
                      , cl.ModifiedBy
                      , cl.DateChanged
                from ChangeLogs cl
                where cl.ModifiedBy is not null) ordered_ch_logs
    where ordered_ch_logs.num = 1
) select *
from last_active_usr

