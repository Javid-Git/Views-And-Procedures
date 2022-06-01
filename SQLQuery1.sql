create database ViewsAndProcSql

use ViewsAndProcSql

use master

drop database ViewsAndProcSql

drop table Books
drop table Authors

-- Create Books Table and Added info

create table Books(
Id int primary key identity, 
Name nvarchar(99) check(len(Name) between 5 and 100), 
PageCount int check(PageCount > 10),
AuthorId int constraint FK_author_id foreign key references Authors(Id)
)

insert into Books (Name, PageCount, AuthorId)
values
('War and Peace', 660, 1),
('Anna Karenina', 658, 1),
('Requiem', 345, 2),
('Poem without a Hero', 764, 2),
('Three Sisters', 106, 3),
('The Cherry Orchard', 356, 3),
('The Government Inspector', 592, 4),
('The Diary of a Madman', 589, 4),
('The Stone Guest', 349, 5),
('Eugene Onegin', 288, 5),
('Father and Sons', 160, 6),
('First Love', 291, 6)

-- Create Authors Table and Added info

create table Authors(
Id int constraint PK_authors_id primary key identity,
Name nvarchar(25),
SurName nvarchar(25)
)

insert into Authors(Name, SurName)
Values
('Lev','Tolstoy'),
('Anna','Akhmatova'),
('Anton','Chekhov'),
('Nikolai','Gogol'),
('Alexander','Pushkin'),
('Ivan','Turgenev')

--Created View

Create view usv_BookInfo_AuthorFullName
as
select b.Id 'Id', b.Name 'BookName', b.PageCount 'PageCount', (a.Name+' '+a.SurName) 'FullName' from Authors a
join Books b on b.AuthorId = a.Id

--Search by Book Name and Author Name procedure

Create procedure usp_BookInfo_AuthorFullName_By_AuthorName_And_By_BookName @name nvarchar(40)
as
begin
	select * from usv_BookInfo_AuthorFullName
	where FullName = @name or BookName = @name
end

exec usp_BookInfo_AuthorFullName_By_AuthorName_And_By_BookName 'War and Peace'

--Update Author procedure

create procedure usp_Update_Authors_table @oldname nvarchar(25), @oldsurname nvarchar(25), @newname nvarchar(25), @newsurname nvarchar(25)
as
begin
	update Authors 
	set Name = @newname, SurName = @newsurname
	where Name = @oldname and SurName = @oldsurname
end

exec usp_Update_Authors_table 'Lev', 'Tolstoy', 'Cavid', 'Alizada'

--Insert Author procedure

create procedure usp_Insert_Authors_table @newname nvarchar(25), @newsurname nvarchar(25)
as
begin
	insert into Authors (Name, SurName)
	Values
	(@newname, @newsurname)
end

exec usp_Insert_Authors_table 'Vladimir', 'Putin'

--Delete Author procedure

create procedure usp_Delete_Authors_table @name nvarchar(25), @surname nvarchar(25)
as
begin
	delete from Authors
	where Name = @name and SurName = @surname
end

exec usp_Delete_Authors_table 'Cavid', 'Alizada'

--AuthodId FullName BooksCount MaxPageCount view

create view usv_AuthodId_FullName_BooksCount_MaxPageCount
as
select a.Id 'Author Id', (a.Name+' '+a.SurName) 'FullName', count(*) 'BooksCount', max(b.PageCount) 'MaxPageCount' from Authors a
join Books b on a.Id = b.AuthorId
group by a.Name, a.SurName, a.Id