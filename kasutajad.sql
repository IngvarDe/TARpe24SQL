--1. Loo uus andmebaas nimega HarjutusDB.
create database HarjutusDB
go

use HarjutusDB
go
--2. Loo tabel Tootajad veergudega ID, Nimi, Amet, Palk.
create table Tootajad
(
Id int identity primary key,
Name nvarchar(100),
Profession nvarchar(100),
Salary decimal (10,2)
)
-- sisestasin andmed
INSERT INTO Tootajad (Name, Profession, Salary) VALUES
('Mari Maasikas', 'Raamatupidaja', 1800.00),
('Jüri Juurikas', 'Arendaja', 2500.00),
('Kati Kask', 'Sekretär', 1300.00);
--3. Loo järgmised login’id ja kasutajad:
-- ArendajaLogin → ArendajaUser
-- RaamatupidajaLogin → RaamatupidajaUser
-- AdminLogin → AdminUser
create login ArendajaLogin with password = 'ArendajaUser'
create login RaamatupidajaLogin with password = 'Raamat123!'
create login AdminLogin with password = 'Admin123!'

create user ArendajaUser for login ArendajaLogin;
create user RaamatupidajaUser for login RaamatupidajaLogin;
create user AdminUser for login AdminLogin;
---7. Anna ArendajaUser’ile ainult SELECT-õgus tabelile Tootajad.
grant select on dbo.Tootajad to ArendajaUser
---8. Anna RaamatupidajaUser’ile SELECT ja UPDATE õigused tabelile Tootajad.
grant select, update on dbo.Tootajad to RaamatupidajaUser
---9. Lisa AdminUser rolli db_owner, et tal oleks täielikud õigused.
exec sp_addrolemember 'db_owner', 'AdminUser'

select * from Tootajad
---10. Loo roll Vaatajad, anna sellele SELECT-õigus ja lisa sinna ArendajaUser.
create role Vaatajad
grant select on dbo.Tootajad to Vaatajad
exec sp_addrolemember 'Vaatajad', 'ArendajaUser'

--11. Keela RaamatupidajaUser’ile andmete kustutamine tabelist Tootajad.
deny delete on dbo.Tootajad to RaamatupidajaUser
---12. Loo uus kasutaja TestUser, kellel on ainult 
---SELECT-õigus (kasuta contained user’i põhimõtet).
create user TestUser with password = 'Test123!'
alter database HarjutusDB set containment = partial
--The sp_configure value 'contained database authentication'
--must be set to 1 in order to alter a contained database.  
--You may need to use RECONFIGURE to set the value_in_use.
sp_configure 'contained database authentication', 1
go
reconfigure
go
--proovin uuesti
alter database HarjutusDB set containment = partial
create user TestUser with password = 'Test123!'
grant select on dbo.Tootajad to TestUser
--13. Kontrolli õigusi, logides sisse erinevate kasutajatega 
--ja proovides teha SELECT, UPDATE ja DELETE käske.
