--tund 1 03.03.2025
--loome db
create database TARpe24SQL

-- db valimine 
use TARpe24SQL

-- db kustutamine
drop database TARpe24SQL

-- tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male')
insert into Gender (Id, Gender)
values (1, 'Female')
insert into Gender (Id, Gender)
values (3, 'Unknown')

-- vaatame tabeli sisu
select * from Gender

-- teeme tabeli Person
create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

--andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'c@c.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(7, 'Spiderman', 'spider@s.com', 2),
(9, NULL, NULL, 2)

--soovime vaadata Person tabeli andmeid
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

-- kui sisestad uue rea andmeid ja ei ele sisestanud GenderId alla väärtust,
-- siis see automaatselt sisestab sellele reale väärtuse 3 e nagu meil
-- on unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

--
insert into Person (Id, Name, Email)
values (11, 'Kalevipoeg', 'k@k.com')

-- piirangu kustutamine
alter table person
drop constraint DF_Persons_GenderId

-- lisame uue veeru
alter table Person
add Age nvarchar(10)

--lisame nr piirangu vanuse sisestamisel
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

--kustutame rea
delete from Person where Id = 11

select * from Person

--kuidas uuendada andmeid
update Person
set Age = 50
where Id = 4


alter table Person
add City nvarchar(50)

--k]ik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
--k]ik, kes ei ela Gothamis
select * from Person where City != 'Gotham'
--variant nr 2
select * from Person where City <> 'Gotham'

-- n'itab teatud vanusega inimesi
select * from Person where Age = 100 or Age = 35 or Age = 27
select * from Person where Age in (100, 35, 25)

-- n'itab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 22 and 50

-- wildcard e näitab kõik g-tähega linnad
select * from Person where City like 'g%'
-- k]ik emailid, kus on @-märk emailis
select * from Person where Email like '%@%'

--näitab kõiki, kellel ei ole @-märki emailis
select * from Person where Email not like '%@%'

--tund 2 07.03.2025

--näitab, kellel on emailis ees ja peale @-märki ainult üks täht
select * from Person where Email like '_@_.com'

--kõik, kellel on nimes täht W, A, S
select * from Person where Name like '[^WAS]%'
select * from Person

--kes elavad Gothamis ja New Yorkis
select * from Person where City = 'Gotham' or City = 'New York'

--- kõik, kes elavad Gothami ja New Yorki linnas ja on vanemad, kui 29
select * from Person where (City = 'Gotham' or City = 'New York') and Age >=30

--kuvab tähestikulises järjekorras inimesi ja võtab auseks nime
select * from Person order by Name
--sama päring, aga vastupidises järjestuses on nimed
select * from Person order by Name desc

-- võtab kolm esimest rida
select top 3 * from Person

--kolm esimest, aga tabeli järjestus on Age ja siis Name
select top 3 Age, Name from Person

--näitab esimesed 50% tabelis
select top 50 percent * from Person

--järjestab vanuse järgi isikud
select * from Person order by Age desc

-- muudab Age muutuja intiks ja näitab vanuselises järjestuses
select * from Person order by cast(Age as int)

--kõikide isikute koondvanus
select sum(cast(Age as int)) from Person

-- kuvab kõige nooremat isikut
select min(cast(Age as int)) from Person
-- kuvab kõige vanemat isikut
select max(cast(Age as int)) from Person

-- konkreetsetes linnades olevate isikute koondvanus
-- enne oli Age nvarchar, aga muudame selle int andmetüübiks
select City, sum(Age) as totalAge from Person group by City

-- kuidas saab koodiga muuta andmetüüpi ja selle pikkust
alter table Person
alter column Name nvarchar(25)

--kuvab esimeses reas välja toodud järjestuses ja kuvab Age TotalAge-ks
-- järjestab City-s olevate nimede järgi ja siis GenderId järgi
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId order by City

--näitab ridade arvu tabelis
select count(*) from Person
select * from Person

--näitab tulemust, et mitu inimest on genderId väärtusega 2 konkreetses linnas
-- arvutab vanuse kokku selles linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderId, City

--- loome, tabelid Employees ja Department

create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

--rida 208
-- 3tund
