use ASUZD
select *, ANU.LastName
from TechnicalProjectComissionMembers tpcm
left join ComissionMembers CM on ComissionMemberId = CM.Id
left join AspNetUsers ANU on CM.ApplicationUserId = ANU.Id
where TechnicalProjectId in (
13065
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
    ) and ComissionMemberId = 356

select *
from ComissionMembers
where ApplicationUserId = '4b086589-3853-4831-845a-b3f241660a94'


begin tran insertCommisionMember

insert into TechnicalProjectComissionMembers
values
(13087, 607),
(13093, 607),
(13096, 607),
(13100, 607),
(13103, 607),
(13104, 607),
(13108, 607),
(13117, 607),
(13070, 607),
(13074, 607),
(13110, 607),
(13078, 607),
(13111, 607),
(13116, 607),
(13083, 607),
(13293, 607),
(13294, 607),
(13297, 607),
(13299, 607),
(13300, 607),
(13307, 607),
(13252, 607),
(13254, 607),
(13257, 607),
(13260, 607),
(13264, 607),
(13271, 607),
(13272, 607),
(13274, 607),
(13139, 607),
(13140, 607),
(13137, 607),
(13135, 607),
(13125, 607),
(13210, 607),
(13211, 607),
(13213, 607),
(13217, 607),
(13219, 607),
(13220, 607),
(13229, 607),
(13230, 607),
(13234, 607),
(13235, 607),
(13193, 607),
(13197, 607),
(13198, 607),
(13200, 607),
(13202, 607),
(13203, 607),
(13204, 607),
(13206, 607),
(13208, 607),
(13055, 607),
(13133, 607),
(13180, 607),
(13191, 607),
(13184, 607),
(13187, 607),
(13188, 607),
(13189, 607),
(13190, 607),
(13162, 607),
(13163, 607),
(13165, 607),
(13166, 607),
(13167, 607),
(13168, 607),
(13170, 607),
(13171, 607),
(13172, 607),
(13173, 607),
(13174, 607),
(13246, 607),
(13237, 607),
(13244, 607),
(13282, 607),
(13241, 607),
(13242, 607),
(13192, 607),
(13256, 607),
(13281, 607),
(13258, 607),
(13245, 607),
(13215, 607),
(13261, 607),
(13295, 607),
(13265, 607),
(13214, 607),
(13248, 607),
(13212, 607),
(13263, 607),
(13102, 607),
(13259, 607),
(13285, 607),
(13283, 607),
(13146, 607),
(13145, 607),
(13149, 607)
select *
from TechnicalProjectComissionMembers
where TechnicalProjectId in (
13065
,13061
,13085
,13087
,13093
    )
rollback tran


select * into tempTechnicalProjectComissionMembers from TechnicalProjectComissionMembers;

begin tran deletecommisionmember356

    delete from TechnicalProjectComissionMembers
    where (ComissionMemberId = 356 and TechnicalProjectId = 13065) or
(ComissionMemberId = 356 and TechnicalProjectId = 13061) or
(ComissionMemberId = 356 and TechnicalProjectId = 13085) or
(ComissionMemberId = 356 and TechnicalProjectId = 13087) or
(ComissionMemberId = 356 and TechnicalProjectId = 13093) or
(ComissionMemberId = 356 and TechnicalProjectId = 13096) or
(ComissionMemberId = 356 and TechnicalProjectId = 13100) or
(ComissionMemberId = 356 and TechnicalProjectId = 13103) or
(ComissionMemberId = 356 and TechnicalProjectId = 13104) or
(ComissionMemberId = 356 and TechnicalProjectId = 13108) or
(ComissionMemberId = 356 and TechnicalProjectId = 13117) or
(ComissionMemberId = 356 and TechnicalProjectId = 13070) or
(ComissionMemberId = 356 and TechnicalProjectId = 13074) or
(ComissionMemberId = 356 and TechnicalProjectId = 13110) or
(ComissionMemberId = 356 and TechnicalProjectId = 13078) or
(ComissionMemberId = 356 and TechnicalProjectId = 13111) or
(ComissionMemberId = 356 and TechnicalProjectId = 13116) or
(ComissionMemberId = 356 and TechnicalProjectId = 13083) or
(ComissionMemberId = 356 and TechnicalProjectId = 13293) or
(ComissionMemberId = 356 and TechnicalProjectId = 13294) or
(ComissionMemberId = 356 and TechnicalProjectId = 13297) or
(ComissionMemberId = 356 and TechnicalProjectId = 13299) or
(ComissionMemberId = 356 and TechnicalProjectId = 13300) or
(ComissionMemberId = 356 and TechnicalProjectId = 13307) or
(ComissionMemberId = 356 and TechnicalProjectId = 13252) or
(ComissionMemberId = 356 and TechnicalProjectId = 13254) or
(ComissionMemberId = 356 and TechnicalProjectId = 13257) or
(ComissionMemberId = 356 and TechnicalProjectId = 13260) or
(ComissionMemberId = 356 and TechnicalProjectId = 13264) or
(ComissionMemberId = 356 and TechnicalProjectId = 13271) or
(ComissionMemberId = 356 and TechnicalProjectId = 13272) or
(ComissionMemberId = 356 and TechnicalProjectId = 13274) or
(ComissionMemberId = 356 and TechnicalProjectId = 13139) or
(ComissionMemberId = 356 and TechnicalProjectId = 13140) or
(ComissionMemberId = 356 and TechnicalProjectId = 13137) or
(ComissionMemberId = 356 and TechnicalProjectId = 13135) or
(ComissionMemberId = 356 and TechnicalProjectId = 13125) or
(ComissionMemberId = 356 and TechnicalProjectId = 13210) or
(ComissionMemberId = 356 and TechnicalProjectId = 13211) or
(ComissionMemberId = 356 and TechnicalProjectId = 13213) or
(ComissionMemberId = 356 and TechnicalProjectId = 13217) or
(ComissionMemberId = 356 and TechnicalProjectId = 13219) or
(ComissionMemberId = 356 and TechnicalProjectId = 13220) or
(ComissionMemberId = 356 and TechnicalProjectId = 13229) or
(ComissionMemberId = 356 and TechnicalProjectId = 13230) or
(ComissionMemberId = 356 and TechnicalProjectId = 13234) or
(ComissionMemberId = 356 and TechnicalProjectId = 13235) or
(ComissionMemberId = 356 and TechnicalProjectId = 13193) or
(ComissionMemberId = 356 and TechnicalProjectId = 13197) or
(ComissionMemberId = 356 and TechnicalProjectId = 13198) or
(ComissionMemberId = 356 and TechnicalProjectId = 13200) or
(ComissionMemberId = 356 and TechnicalProjectId = 13202) or
(ComissionMemberId = 356 and TechnicalProjectId = 13203) or
(ComissionMemberId = 356 and TechnicalProjectId = 13204) or
(ComissionMemberId = 356 and TechnicalProjectId = 13206) or
(ComissionMemberId = 356 and TechnicalProjectId = 13208) or
(ComissionMemberId = 356 and TechnicalProjectId = 13055) or
(ComissionMemberId = 356 and TechnicalProjectId = 13133) or
(ComissionMemberId = 356 and TechnicalProjectId = 13180) or
(ComissionMemberId = 356 and TechnicalProjectId = 13191) or
(ComissionMemberId = 356 and TechnicalProjectId = 13184) or
(ComissionMemberId = 356 and TechnicalProjectId = 13187) or
(ComissionMemberId = 356 and TechnicalProjectId = 13188) or
(ComissionMemberId = 356 and TechnicalProjectId = 13189) or
(ComissionMemberId = 356 and TechnicalProjectId = 13190) or
(ComissionMemberId = 356 and TechnicalProjectId = 13162) or
(ComissionMemberId = 356 and TechnicalProjectId = 13163) or
(ComissionMemberId = 356 and TechnicalProjectId = 13165) or
(ComissionMemberId = 356 and TechnicalProjectId = 13166) or
(ComissionMemberId = 356 and TechnicalProjectId = 13167) or
(ComissionMemberId = 356 and TechnicalProjectId = 13168) or
(ComissionMemberId = 356 and TechnicalProjectId = 13170) or
(ComissionMemberId = 356 and TechnicalProjectId = 13171) or
(ComissionMemberId = 356 and TechnicalProjectId = 13172) or
(ComissionMemberId = 356 and TechnicalProjectId = 13173) or
(ComissionMemberId = 356 and TechnicalProjectId = 13174) or
(ComissionMemberId = 356 and TechnicalProjectId = 13246) or
(ComissionMemberId = 356 and TechnicalProjectId = 13237) or
(ComissionMemberId = 356 and TechnicalProjectId = 13244) or
(ComissionMemberId = 356 and TechnicalProjectId = 13282) or
(ComissionMemberId = 356 and TechnicalProjectId = 13241) or
(ComissionMemberId = 356 and TechnicalProjectId = 13242) or
(ComissionMemberId = 356 and TechnicalProjectId = 13192) or
(ComissionMemberId = 356 and TechnicalProjectId = 13256) or
(ComissionMemberId = 356 and TechnicalProjectId = 13281) or
(ComissionMemberId = 356 and TechnicalProjectId = 13258) or
(ComissionMemberId = 356 and TechnicalProjectId = 13245) or
(ComissionMemberId = 356 and TechnicalProjectId = 13215) or
(ComissionMemberId = 356 and TechnicalProjectId = 13261) or
(ComissionMemberId = 356 and TechnicalProjectId = 13295) or
(ComissionMemberId = 356 and TechnicalProjectId = 13265) or
(ComissionMemberId = 356 and TechnicalProjectId = 13214) or
(ComissionMemberId = 356 and TechnicalProjectId = 13248) or
(ComissionMemberId = 356 and TechnicalProjectId = 13212) or
(ComissionMemberId = 356 and TechnicalProjectId = 13263) or
(ComissionMemberId = 356 and TechnicalProjectId = 13102) or
(ComissionMemberId = 356 and TechnicalProjectId = 13259) or
(ComissionMemberId = 356 and TechnicalProjectId = 13285) or
(ComissionMemberId = 356 and TechnicalProjectId = 13283) or
(ComissionMemberId = 356 and TechnicalProjectId = 13146) or
(ComissionMemberId = 356 and TechnicalProjectId = 13145) or
(ComissionMemberId = 356 and TechnicalProjectId = 13149)

    select distinct ANU.LastName
from TechnicalProjectComissionMembers tpcm
left join ComissionMembers CM on ComissionMemberId = CM.Id
left join AspNetUsers ANU on CM.ApplicationUserId = ANU.Id
where TechnicalProjectId in (
13065
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

    rollback tran