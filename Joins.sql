USE MetroAlt

/*
    1. Create a CROSS JOIN between employees and bus routes to show all possible combinations of routes and drivers (better use position to distinguish only drivers this involves a CROSS JOIN and an INNER JOIN. I will accept either)
*/

SELECT BusRouteKey AS [Bus Route], PositionKey as [Employee Driver]
FROM BusRoute 
CROSS JOIN EmployeePosition

/*
    2. List all the bus type details for each bus assigned to bus barn 3
*/

SELECT BusType.*, BusBarn.BusBarnKey 
FROM BusType
LEFT JOIN BusBarn
ON BusBarnKey='3'

/*
    3. What is the total cost of all the busses at bus barn 3
*/

SELECT format(SUM(BusTypePurchasePrice), '$ ####00.00') AS [Total], BusBarn.BusBarnKey 
FROM BusType
INNER JOIN BusBarn
ON BusBarnKey='3'
GROUP BY BusBarnKey

/*
    4. What is the total cost per type of bus at bus barn 3
*/

SELECT format(SUM(BusTypePurchasePrice), '$ ####00.00') AS [Total],BusTypeKey 
FROM BusType
INNER JOIN BusBarn
ON BusBarnKey='3'
GROUP BY BusTypeKey

/*
    5. List the last name, first name, email, position name and hourly pay for each employee
*/

SELECT EmployeeLastName,EmployeeFirstName,EmployeeEmail,PositionKey,EmployeeHourlyPayRate 
FROM Employee 
INNER JOIN EmployeePosition
on Employee.Employeekey=EmployeePosition.EmployeeKey

/*
    6. List the bus driver’s last name  the shift times, the bus number (key)  and the bus type for each bus on route 43
*/

SELECT EmployeeLastName,CONVERT(VARCHAR,BusDriverShiftStartTime,108) AS [Shift Start Time],
CONVERT(VARCHAR,BusDriverShiftStopTime,108) AS [Shift End Time],BusType.BusTypeKey,BusKey
FROM Bus
INNER JOIN BusType 
ON Bus.BusTypeKey = BusType.BusTypeKey 
CROSS JOIN Employee 
CROSS JOIN BusDriverShift 
CROSS JOIN BusRoute
WHERE BusRouteKey='43'

/*
    7. Return all the positions that no employee holds.
*/

SELECT PositionKey
FROM EmployeePosition
INNER JOIN Employee
ON EmployeePosition.EmployeeKey=Employee.EmployeeKey
WHERE EmployeePosition.EmployeeKey IS NULL

/*
    8. Get the employee key, first name, last name, position key for every driver (position key=1) who has never been assigned to a shift. (This is hard it involves an INNER JOIN of several tables and then an outer JOIN with BusscheduleAssignment.)
*/

SELECT Employee.EmployeeLastName, Employee.EmployeeFirstName,EmployeePosition.PositionKey
FROM Employee 
INNER JOIN EmployeePosition 
ON Employee.EmployeeKey = EmployeePosition.EmployeeKey 
FULL OUTER JOIN BusScheduleAssignment 
ON Employee.EmployeeKey = BusScheduleAssignment.EmployeeKey
WHERE BusScheduleAssignment.EmployeeKey IS NULL