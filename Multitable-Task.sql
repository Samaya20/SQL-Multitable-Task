-- Database yaradilmasi
USE master
CREATE DATABASE AcademyDB

-- ==============================================================
-- Curator table yaradilmasi
CREATE TABLE Curators (
  Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [Name] nvarchar(max) NOT NULL,
  Surname nvarchar(max) NOT NULL
);

INSERT INTO Curators ([Name], Surname)
VALUES 
('John', 'Doe'),
('Emma', 'Smith'),
('Michael', 'Johnson'),
('Sophia', 'Williams'),
('Daniel', 'Brown');


-- ==============================================================
-- Faculties table yaradilmasi
CREATE TABLE Faculties (
  Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
  Financing money NOT NULL CHECK (Financing >= 0) DEFAULT 0,
  [Name] nvarchar(100) NOT NULL UNIQUE
);

INSERT INTO Faculties (Financing, [Name])
VALUES 
(15000.00, 'Engineering'),
(20000.00, 'Medicine'),
(18000.00, 'Business'),
(22000.00, 'Arts'),
(19000.00, 'Science');

-- ==============================================================
-- Departments table yaradilmasi
CREATE TABLE Departments (
  Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
  Financing money NOT NULL CHECK (Financing >= 0) DEFAULT 0,
  [Name] nvarchar(100) NOT NULL UNIQUE,
  FacultyId int NOT NULL FOREIGN KEY REFERENCES Faculties(Id)
);

INSERT INTO Departments (Financing, [Name], FacultyId)
VALUES 
(8000.00, 'Computer Science', 1),
(7500.00, 'Mechanical Engineering', 1),
(9000.00, 'Biology', 5),
(8200.00, 'Economics', 3),
(7800.00, 'English Literature', 4);


-- ==============================================================
-- Groups table yaradilmasi
CREATE TABLE Groups (
  Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [Name] nvarchar(10) NOT NULL UNIQUE,
  Year int NOT NULL CHECK (Year BETWEEN 1 AND 5),
  DepartmentId int NOT NULL FOREIGN KEY REFERENCES Departments(Id)
);

INSERT INTO Groups ([Name], Year, DepartmentId)
VALUES 
('CS101', 1, 1),
('ME201', 2, 2),
('BIO301', 3, 3),
('ECO401', 4, 4),
('ENG501', 5, 5);

-- ==============================================================
-- GroupsCurators table yaradilmasi
CREATE TABLE GroupsCurators (
  Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
  CuratorId int NOT NULL FOREIGN KEY REFERENCES Curators(Id),
  GroupId int NOT NULL FOREIGN KEY REFERENCES Groups(Id)
);

INSERT INTO GroupsCurators (CuratorId, GroupId)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- ==============================================================
-- Subjects table yaradilmasi
CREATE TABLE Subjects (
  Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [Name] nvarchar(100) NOT NULL UNIQUE
);

INSERT INTO Subjects ([Name])
VALUES 
('Mathematics'),
('Chemistry'),
('History'),
('Economics'),
('Literature');

-- ==============================================================
-- Teachers table yaradilmasi
CREATE TABLE Teachers (
  Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [Name] nvarchar(max) NOT NULL,
  Salary money NOT NULL CHECK (Salary > 0),
  Surname nvarchar(max) NOT NULL
);

INSERT INTO Teachers ([Name], Salary, Surname)
VALUES 
('Alice', 50000.00, 'Johnson'),
('David', 48000.00, 'Anderson'),
('Olivia', 52000.00, 'Martinez'),
('James', 49000.00, 'Garcia'),
('Ava', 51000.00, 'Miller');

-- ==============================================================
-- Lectures table yaradilmasi
CREATE TABLE Lectures (
  Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
  LectureRoom nvarchar(max) NOT NULL,
  SubjectId int NOT NULL FOREIGN KEY REFERENCES Subjects(Id),
  TeacherId int NOT NULL FOREIGN KEY REFERENCES Teachers(Id)
);

INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId)
VALUES 
('Room A101', 1, 1),
('Room B202', 2, 2),
('Room C303', 3, 3),
('Room D404', 4, 4),
('Room E505', 5, 5);

-- ==============================================================
-- GroupsLectures table yaradilmasi
CREATE TABLE GroupsLectures (
  Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
  GroupId int NOT NULL FOREIGN KEY REFERENCES Groups(Id),
  LectureId int NOT NULL FOREIGN KEY REFERENCES Lectures(Id)
);

INSERT INTO GroupsLectures (GroupId, LectureId)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);




-- ========== Queriesss =========== -------

-- Task 1. Print all possible pairs of lines of teachers and groups.

SELECT Teachers.[Name] AS TeacherName, Groups.[Name] AS GroupName
FROM Teachers, Groups;

-- ##############################################################

-- Task 2. Print names of faculties, where financing fund of departments exceeds financing fund of the faculty.

SELECT f.[Name]
FROM Faculties f
JOIN Departments d ON f.Id = d.FacultyId
GROUP BY f.[Name], f.Financing
HAVING SUM(d.Financing) > f.Financing;

-- #############################################################

-- Task 3. Print names of the group curators and groups names they are supervising.

SELECT Curators.[Name] AS CuratorName, Curators.Surname AS CuratorSurname, Groups.[Name] AS GroupName
FROM Curators
INNER JOIN GroupsCurators ON Curators.Id = GroupsCurators.CuratorId
INNER JOIN Groups ON GroupsCurators.GroupId = Groups.Id;

-- ############################################################

--Task 4. Print names of the teachers who deliver lectures in the group "P107".

SELECT Teachers.[Name], Teachers.Surname
FROM Teachers
INNER JOIN Lectures ON Teachers.Id = Lectures.TeacherId
INNER JOIN GroupsLectures ON Lectures.Id = GroupsLectures.LectureId
INNER JOIN Groups ON GroupsLectures.GroupId = Groups.Id
WHERE Groups.[Name] = 'P107';

-- ############################################################

--Task 5. Print names of the teachers and names of the faculties where they are lecturing.

SELECT Teachers.[Name] AS TeacherName, Teachers.Surname AS TeacherSurname, Faculties.[Name] AS FacultyName
FROM Teachers
INNER JOIN Lectures ON Teachers.Id = Lectures.TeacherId
INNER JOIN Subjects ON Lectures.SubjectId = Subjects.Id
INNER JOIN Departments ON Subjects.Id = Departments.Id
INNER JOIN Faculties ON Departments.FacultyId = Faculties.Id;

-- ############################################################

--Task 6. Print names of the departments and names of the groups that relate to them.

SELECT Departments.[Name] AS DepartmentName, Groups.[Name] AS GroupName
FROM Departments
INNER JOIN Groups ON Departments.Id = Groups.DepartmentId;

-- ############################################################

--Task 7. Print names of the subjects that the teacher "Samantha Adams" teaches.

SELECT Subjects.[Name] AS SubjectName
FROM Teachers
INNER JOIN Lectures ON Teachers.Id = Lectures.TeacherId
INNER JOIN Subjects ON Lectures.SubjectId = Subjects.Id
WHERE Teachers.[Name] = 'Samantha' AND Teachers.Surname = 'Adams';

-- ############################################################

--Task 8. Print names of the departments where "Database Theory" is taught.

SELECT Departments.[Name] AS DepartmentName
FROM Departments
INNER JOIN Subjects ON Departments.Id = Subjects.Id
WHERE Subjects.[Name] = 'Database Theory';

-- ############################################################

--Task 9. Print names of the groups that belong to the "Computer Science" faculty.

SELECT Groups.[Name] AS GroupName
FROM Groups
INNER JOIN Departments ON Groups.DepartmentId = Departments.Id
INNER JOIN Faculties ON Departments.FacultyId = Faculties.Id
WHERE Faculties.[Name] = 'Engineering' AND Departments.[Name] = 'Computer Science';

-- ############################################################

--Task 10. Print names of the 5th year groups, as well as names of the faculties to which they relate.

SELECT Groups.[Name] AS GroupName, Faculties.[Name] AS FacultyName
FROM Groups
INNER JOIN Departments ON Groups.DepartmentId = Departments.Id
INNER JOIN Faculties ON Departments.FacultyId = Faculties.Id
WHERE Groups.[Year] = 5;

-- ############################################################

--Task 11. Print full names of the teachers and lectures they deliver (names of subjects and groups), 
-- and select only those lectures that are delivered in the classroom "B103".

SELECT Teachers.[Name] AS TeacherName, Teachers.Surname AS TeacherSurname, 
Subjects.[Name] AS SubjectName, Groups.[Name] AS GroupName
FROM Teachers
INNER JOIN Lectures ON Teachers.Id = Lectures.TeacherId
INNER JOIN Subjects ON Lectures.SubjectId = Subjects.Id
INNER JOIN GroupsLectures ON Lectures.Id = GroupsLectures.LectureId
INNER JOIN Groups ON GroupsLectures.GroupId = Groups.Id
WHERE Lectures.LectureRoom = 'B103';


