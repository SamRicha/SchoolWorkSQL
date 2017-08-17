USE MetroAlt

/*
    1. Create a derived table that returns the position name as position and count of employees at that position. (I know that this can be done as a simple join, but do it in the format of a derived table. There still will be a join in the subquery portion). 
*/

SELECT PositionKey AS [Position], COUNT(EmployeeKey) AS [Count]
FROM  
(SELECT PositionKey,Employee.EmployeeKey
FROM Employee
INNER JOIN EmployeePosition
ON Employee.EmployeeKey=EmployeePosition.EmployeeKey) AS p
GROUP BY PositionKey

/*
    2. Create a derived table that returns a column HireYear and the count of employees who were hired that year. (Same comment as above).
*/

SELECT YEAR(Employeehiredate) AS [HireYear], COUNT(EmployeeKey) AS [Count]
FROM (SELECT Employeehiredate,Employee.EmployeeKey
FROM Employee
INNER JOIN EmployeePosition
ON Employee.EmployeeKey=EmployeePosition.EmployeeKey) AS p
GROUP BY YEAR(EmployeeHireDate)

/*
    3. Redo problem 1 as a Common Table Expression (CTE).
*/

GO
WITH Position AS  
(
SELECT PositionKey,Employee.EmployeeKey
FROM Employee
INNER JOIN EmployeePosition
ON Employee.EmployeeKey=EmployeePosition.EmployeeKey
)
SELECT PositionKey AS [Position], COUNT(EmployeeKey) AS [Count]
FROM Position
GROUP BY PositionKey
GO

/*
    4. Redo problem 2 as a CTE.
*/

GO
WITH Hire AS
(
SELECT YEAR(Employee.EmployeeHireDate) [Year],COUNT(Employee.EmployeeKey) AS [Count]
FROM Employee
GROUP BY YEAR(Employee.EmployeeHireDate)
)
SELECT [Year], [Count]
FROM Hire
GO

/*
    5. Create a CTE that takes a variable argument called @BusBarn and returns the count of busses grouped by the description of that bus type at a particular Bus barn. Set @BusBarn to 3.
*/

GO
DECLARE @BusBarn INT
SET @BusBarn= '3';
with BusBus AS
(
SELECT BusBarn.BusBarnKey, COUNT(BusType.BusTypeKey) AS [Count] 
FROM BusBarn 
INNER JOIN Bus 
ON BusBarn.BusBarnKey = Bus.BusBarnKey 
INNER JOIN Bustype 
ON Bus.BusTypekey = Bustype.BusTypeKey
GROUP BY BusBarn.BusBarnKey
)
SELECT BusBarnKey, [Count]
FROM BusBus
WHERE BusBarnKey = @BusBarn
GO

/*
    6. Create a View of Employees for Human Resources it should contain all the information in the Employee table plus their position and hourly pay rate
*/

GO
CREATE VIEW vw_HumanResources
AS SELECT Employee.*, PositionKey, EmployeeHourlyPayRate
FROM Employee
INNER JOIN EmployeePosition
ON Employee.EmployeeKey=EmployeePosition.EmployeeKey
GO

/*
    7. Alter the view in 6 to bind the schema.
*/

GO
ALTER VIEW vw_HumanResources WITH schemabinding
AS SELECT Employee.EmployeeKey,EmployeeLastName,EmployeeFirstName,EmployeeAddress,
EmployeeCity,EmployeeZipCode,EmployeePhone,
PositionKey, EmployeeHourlyPayRate,EmployeeEmail,EmployeeHireDate
FROM dbo.Employee
INNER JOIN dbo.EmployeePosition
ON Employee.EmployeeKey=EmployeePosition.EmployeeKey
GO

/*
    8. Create a view of the Bus Schedule assignment that returns the Shift times, The Employee first and last name, the bus route (key) and the Bus (key). Use the view to list the shifts for Neil Pangle in October of 2014
*/

GO
CREATE VIEW vw_Shift
AS SELECT Employee.Employeefirstname,Employee.EmployeeLastName,BusDriverShiftStartTime,
BusDriverShiftStopTime,BusScheduleAssignmentDate
FROM BusScheduleAssignment 
INNER JOIN Employee 
ON BusScheduleAssignment.EmployeeKey = Employee.EmployeeKey
INNER JOIN BusDriverShift 
ON BusScheduleAssignment.BusDriverShiftKey = BusDriverShift.BusDriverShiftKey
GO

SELECT * FROM vw_Shift
where EmployeeFirstName = 'neil'
and EmployeeLastName = 'pangle'
and MONTH(BusScheduleAssignmentDate)=10
and YEAR(BusScheduleAssignmentDate)=2014

/*
    9. Create a table valued function that takes a parameter of city and returns all the employees who live in that city
*/

GO
CREATE FUNCTION fx_EmployeeLive
(@EmployeeCity nvarchar(255))
RETURNS TABLE
AS
RETURN
SELECT EmployeeKey, EmployeeLastName [Last], EmployeeFirstName [First], EmployeeCity City
FROM Employee
Where EmployeeCity = @Employeecity
GO



