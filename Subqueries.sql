use MetroAlt

/*
    1. This involves joining tables, then using a subquery. Return the employee key, last name and first name, position name and hourly rate for those employees receiving the maximum pay rate.
*/

SELECT Employee.EmployeeKey, EmployeeLastName, EmployeeFirstName, PositionKey 
FROM Employee
INNER JOIN EmployeePosition
on Employee.EmployeeKey=EmployeePosition.EmployeeKey 
WHERE EmployeeHourlyPayRate = (SELECT MAX(EmployeeHourlyPayRate) FROM EmployeePosition)

/*
    2. Use only subqueries to do this. Return the key, last name and first name of every employee who has the position name “manager.”
*/

SELECT EmployeeKey,EmployeeFirstName,EmployeeLastName 
FROM Employee
WHERE Employee.EmployeeKey IN 
(SELECT PositionKey FROM EmployeePosition
WHERE PositionKey IN
(SELECT PositionKey FROM position
WHERE positionname = 'Manager'))

 /*
    3. This is very difficult. It combines regular aggregate functions, a scalar function, a cast, subqueries and a join. But it produces a useful result. The results should look like this: User Ridership totals for the numbers.
    
    The Total  is the grand total for all the years. The Percent is Annual Total / Grand Total * 100
 */
  
SELECT YEAR(BusScheduleAssignmentDate) AS [Year],
SUM(riders) AS [Annual Total],
AVG(riders) AS [Annual Average],
(SELECT SUM(Riders) FROM Ridership) AS [Total],
SUM(riders) * 100 / (SELECT SUM(riders) FROM ridership) AS [Percentage]
FROM Ridership r
INNER JOIN BusScheduleAssignment bsa
ON r.BusScheduleAssigmentKey=bsa.BusScheduleAssignmentKey
GROUP BY YEAR(BusScheduleAssignmentDate)

/*
    4. Create a new table called EmployeeZ. It should have the following structure:
    EmployeeKey int,
    EmployeeLastName nvarchar(255),
    EmployeeFirstName nvarchar(255),
    EmployeeEmail Nvarchar(255)
    
    Use an insert with a subquery to copy all the employees from the employee table whose last name starts with “Z.”
*/

CREATE TABLE EmployeeZ
(
EmployeeKey INT NOT NULL,
EmployeeLastName nvarchar(255),
EmployeeFirstName nvarchar(255),
EmployeeEmail Nvarchar(255),
PRIMARY KEY (EmployeeKey)
)

INSERT INTO EmployeeZ 
SELECT EmployeeKey, EmployeeLastName ,EmployeeFirstName,EmployeeEmail
FROM Employee
WHERE EmployeeLastName IN 
(SELECT EmployeeLastName 
FROM Employee
WHERE EmployeeLastName LIKE 'Z%')

SELECT EmployeeLastName FROM Employee

/*
    5. This is a correlated subquery. Return the position key, the employee key and the hourly pay rate for those employees who are receiving the highest pay in their positions. Order it by position key.
*/

SELECT EmployeePosition.PositionKey,EmployeePosition.EmployeeKey,EmployeeHourlyPayRate
FROM EmployeePosition
WHERE EmployeeHourlyPayRate > 
(SELECT AVG(EmployeeHourlyPayRate) 
FROM EmployeePosition
WHERE EmployeePosition.EmployeeKey=EmployeePosition.EmployeeKey)
ORDER BY PositionKey 