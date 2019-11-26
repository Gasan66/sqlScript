use ASUZD
select tpo.*, pr.Id
from TechnicalProjects tp
left join TechnicalProjectOrders TPO on tp.Id = TPO.TechnicalProjectId
left join Orders Ord on TPO.OrderId = Ord.Id
left join TechnicalProjectRequests TPR on tp.Id = TPR.TechnicalProjectId
left join AuctionCycles ac on ac.Id = tpr.AuctionCycleId
left join PurchaseRequests PR on ac.RequestId = PR.Id
where pr.Status not in (140
                        ,150
                        ,160
                        ,165
                        ,167
                        ,170
                        ,175
                        ,177
                        ,180
                        ,185
                        ,186
                        ,190
                        ,200
                        ,210
) and Ord.Number = '246'

select distinct (TechnicalProjects.Status)
from TechnicalProjects
where Id = 7262

begin tran UpdateTPO

    update TechnicalProjectOrders
    set OrderId = 51
    from TechnicalProjects tp
    left join TechnicalProjectOrders TPO on tp.Id = TPO.TechnicalProjectId
    left join Orders Ord on TPO.OrderId = Ord.Id
    left join TechnicalProjectRequests TPR on tp.Id = TPR.TechnicalProjectId
    left join AuctionCycles ac on ac.Id = tpr.AuctionCycleId
    left join PurchaseRequests PR on ac.RequestId = PR.Id
    where pr.Status not in (140
                            ,150
                            ,160
                            ,165
                            ,167
                            ,170
                            ,175
                            ,177
                            ,180
                            ,185
                            ,186
                            ,190
                            ,200
                            ,210
    ) and Ord.Number = '246'

    select tpo.*
    from TechnicalProjects tp
    left join TechnicalProjectOrders TPO on tp.Id = TPO.TechnicalProjectId
    left join Orders Ord on TPO.OrderId = Ord.Id
    where tpo.TechnicalProjectId in (13065
,13061
,13085
,13087
,13093
,13096
,13100
,13103
,13104
,13108
,13117
,13070
,13074
,13110
,13078
,13111
,13116
,13083
,13293
,13294
,13297
,13299
,13300
,13307
,13252
,13254
,13257
,13260
,13264
,13271
,13272
,13274
,13139
,13140
,13137
,13135
,13125
,13210
,13211
,13213
,13217
,13219
,13220
,13229
,13230
,13234
,13235
,13193
,13197
,13198
,13200
,13202
,13203
,13204
,13206
,13208
,13055
,13133
,13180
,13191
,13184
,13187
,13188
,13189
,13190
,13162
,13163
,13165
,13166
,13167
,13168
,13170
,13171
,13172
,13173
,13174
,13246
,13237
,13244
,13282
,13241
,13242
,13192
,13256
,13281
,13258
,13245
,13215
,13261
,13295
,13265
,13214
,13248
,13212
,13263
,13102
,13259
,13285
,13283
,13146
,13145
,13149
                                    )
    and Ord.Number = '510'

rollback tran