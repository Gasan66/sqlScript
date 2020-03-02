use ASUZD;

begin tran changeEmails

    update AspNetUsers
    set Email = comp.Email_AD, UserName = comp.Email_AD
    from AspNetUsers usr
    join _compare_ASUZD_and_AD comp on usr.Id = comp.UsrAsuzdID
    where comp.Email_AD not in (select distinct usr1.UserName from AspNetUsers usr1)
    and usr.IsEnabled = 1
    and usr.Id != '9FC22CCC-B198-4603-AD20-1A04F2E3E3F7' --Юровская Татьяна Михайловна
    and usr.Id != 'f22772d5-f408-46a1-9a5c-1851e5ea2c3a' --Юровская Татьяна Михайловна
    and usr.Id != '423eeb40-2d18-4c57-8078-59e78eaf93ec' --Щелконогов Денис Владимирович
    and usr.Id != '6b25c5e4-d379-44ff-b364-a956e5f7907c' ----Щелконогов Денис Владимирович


    select usr.Email, usr.UserName
    from AspNetUsers usr
    join _compare_ASUZD_and_AD comp on usr.Id = comp.UsrAsuzdID

commit tran

