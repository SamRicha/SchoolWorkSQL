USE MetroAlt


-- 1. Create a Schema called "ManagementSchema"


GO
CREATE SCHEMA ManagementSchema
GO

-- 2. Create a view owned by the schema that shows the annual ridership.

GO
CREATE VIEW ManagementSchema.AnnualRidership
AS
SELECT YEAR(BusScheduleAssignmentDate) AS [Year],SUM(Riders) AS [Riders]
FROM Ridership r
INNER JOIN BusScheduleAssignment b
ON r.BusScheduleAssigmentKey=b.BusScheduleAssignmentKey
GROUP BY YEAR(BusScheduleAssignmentDate)

-- Create a view owned by the schema that shows the employee information including their position and pay rate.

GO
CREATE VIEW ManagementSchema.EmployeeInfo
AS
SELECT e.EmployeeKey, EmployeeLastName, 
EmployeeFirstName, EmployeeAddress, EmployeeCity, 
EmployeeZipCode, EmployeePhone, EmployeeEmail, EmployeeHireDate,
PositionKey, EmployeeHourlyPayRate, EmployeePositionDateAssigned
FROM Employee e
INNER JOIN EmployeePosition ep
ON e.EmployeeKey=ep.EmployeeKey

-- 3. Create a role ManagementRole
GO
CREATE role
ManagementRole
GO

-- 4. Give the ManagementRole select permissions on the ManagementSchema and Exec permissions on the new employee stored procedure we created earlier.

GRANT SELECT ON SCHEMA::ManagementSchema TO ManagementRole
GRANT INSERT, UPDATE ON EmployeeProcedure TO ManagementRole

-- 5. Create a new login for one of the employees who holds the manager position.

CREATE login EmployeesLogin WITH PASSWORD = 'P@ssw0rd1', default_database=Community_Assist
CREATE USER EmployeesLogin FOR login EmployeesLogin


-- 6. Create a new user for that login.

CREATE login ManagementLogin WITH PASSWORD = 'P@ssw0rd1', default_database=MetroAlt
CREATE USER ManagementLogin FOR login ManagementLogin

-- 7. Add that user to the Role.

ALTER role ManagementRole ADD member ManagementLogin
ALTER USER ManagementLogin WITH default_schema=ManagementSchema

-- 8. Back up the database MetroAlt.

Backup DATABASE MetroAlt 
TO disk='C:\Backups\MetroAlt.bak'

