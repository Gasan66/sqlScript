use ASUZD
select *
from AspNetUsers
-- where AspNetUsers.LastName like N'катков'
where (LastName like N'шостак%' or Email = 'gasan@mail.ru')

update AspNetUsers
    set PasswordHash = 'ALm+THBzpf+0ZWc1Cb1slR8P2iJAazUVkCZU6gH4UG5AYBQKgeAnXn6ynAzS4EiI6w=='
    where Email = 'Lebedkina-AN@rosseti-ural.ru'

update AspNetUsers
set IsEnabled = 1
where Id = 'ef123c97-9a5e-467e-8452-d5c2dafc7a39'


--AMHuRLBCBvCzaP68YJq9TGnPhMtgC6NhLGYVN14ojUKn9ER2PLxDPHQxnZtSEQvMsg==
--Lozhkarev-AD@rosseti-ural.ru APVZwjl3CeY8UZE7IRs9H326051oqXOp0wHqKI9ELgCnTlqazqc4PPLir0YmKnjKwg==
--Knyazeva-OA@mrsk-ural.ru ANMJkjfces8NXI3dGmOURZ4Md1Licpz1bZLTajIZd6HgfEcEyZ1BNSjQkIfdin/tYA==
--u0041863@che.mrsk-ural.ru AN4yzMRQIkxaK2RbIVJxyhelzAUa53W0dYFWxmZ/JZ/FlL9953t6f4BMupmrPyekxA==
--Kaygorodceva-AP@rosseti-ural.ru ABm92Ck/Donse2jsFX1P+Ol6qsC58GHX/tNXnSuO6ZP8ZGUqAx4cX47Ikq/OsAub4A==
--Lebedkina-AN@rosseti-ural.ru ALm+THBzpf+0ZWc1Cb1slR8P2iJAazUVkCZU6gH4UG5AYBQKgeAnXn6ynAzS4EiI6w==