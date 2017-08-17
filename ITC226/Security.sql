
/*
For this assignment we are going to assess the security needs of MetroAlt and create a security plan.
First we want to assess who are the users and what the security needs are for the database. This should be a written document.
We will define schema for each of the users types (in 224 we will create views for each of the schema) 
Then we will create roles for each of the user types and assign permissions. Additionally we will assign the role permission on the schema.
Then we will create log ins for individual users and assign them to a role
Then we will test the roles by logging in as different users.


login  Authentication and Authorization
Login --server user mapped to the login and is for a database
Windows Authentication--Active directory
Sql Server Authentication--password username

Roles --Collections of Permissions
Schema -- ownership of a collection of objects

MetroAlt
Admin
Reviewers SELECT UPDATE DELETE INSERT DROP CREATE ALTER EXEC

Volunteers
Clients
General--public
Donors

What kinds of views would people have
Stored Procedures, How interact

Role
Schema
*/

-- schema

USE MetroAlt

GO
CREATE SCHEMA ClientSchema
GO

CREATE VIEW ClientSchema.vw_Employee
AS
SELECT * FROM Employee

GO
SELECT * FROM ClientSchema.vw_Employee
GO

CREATE proc ClientSchema.usp_Employee
@EmployeeKey INT
AS
SELECT PositionKey [Job],
EmployeeLastName [Last Name],
EmployeeFirstName [First Name],
EmployeeAddress [Address],
EmployeeCity [City],
EmployeeZipCode [ZipCode],
EmployeePhone [Phone]
FROM Employee gt
INNER JOIN EmployeePosition req
ON gt.EmployeeKey=req.EmployeeKey
WHERE gt.employeekey = @EmployeeKey

exec ClientSchema.usp_Employee 1

CREATE role ClientRole

GRANT SELECT, EXECUTE ON SCHEMA::ClientSchema TO ClientRole

CREATE Role GeneralUserRole
GRANT SELECT ON GrantType TO GeneralUserRole
GRANT SELECT ON vw_Employee TO GeneralUserRole
GRANT INSERT ON Employee TO GeneralUserRole

CREATE login Jody WITH PASSWORD='P@ssword1', 
default_database=MetroAlt

CREATE USER Jody FOR login jody WITH default_schema=ClientSchema
exec sp_AddRoleMember 'ClientRole','jody'
