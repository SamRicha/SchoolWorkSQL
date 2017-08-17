/*
    1. Create a temp table to show how many stops each route has. the table should have fields for the route number and the number of stops. Insert into it from BusRouteStops and then select from the temp table.
*/

CREATE TABLE #BusStopCount
(
RouteKey INT,
RouteAmount INT
)
INSERT INTO #BusStopCount(RouteKey,RouteAmount) 
SELECT BusRouteKey,SUM(BusRouteStopKey) AS [Bus Stop Amount]
FROM BusRouteStops
GROUP BY BusRouteKey
ORDER BY BusRouteKey

/*
    2.Do the same but using a global temp table.
*/

CREATE TABLE ##GlobalBusStopCount
(
RouteKey INT,
RouteAmount INT
)
INSERT INTO ##GlobalBusStopCount(RouteKey,RouteAmount) 
SELECT BusRouteKey,SUM(BusRouteStopKey) AS [Bus Stop Amount]
FROM BusRouteStops
GROUP BY BusRouteKey

/*
    3.CREATE a function to CREATE an Employee email address. Every Employee Email follows the pattern of "firstName.lastName@metroalt.com"
*/

CREATE FUNCTION fx_Email
(@FirstName nvarchar(255),
@LastName nvarchar(255))
RETURNS nvarchar(255)
AS
BEGIN
DECLARE @Email nvarchar(255)
SET @Email=@FirstName +'.'+ @LastName +'@metroalt.com'
RETURN @Email
END
GO

SELECT dbo.fx_Email(Employee.EmployeeFirstName,Employee.EmployeeLastName) AS Email
FROM Employee

/*
    4.CREATE a function to determine a two week pay check of an individual Employee.
*/

GO
CREATE FUNCTION fx_TwoWeek
(@PayRate INT
)
RETURNS INT
AS BEGIN
DECLARE @TwoWeekTotal INT
SET @TwoWeekTotal= @PayRate * 40 * 2
RETURN @TwoWeekTotal
END
GO

SELECT Employee.Employeekey,dbo.fx_TwoWeek(EmployeeHourlyPayRate) AS [Two week pay]
FROM Employee
INNER JOIN EmployeePosition
ON EmployeePosition.EmployeeKey=Employee.EmployeeKey

/*
    5.CREATE a function to determine a hourly rate for a new Employee. Take difference between top and bottom pay for the new Employees position (say driver) and then subtract the difference from the maximum pay. (and yes this is very arbitrary).
*/

GO
ALTER FUNCTION fx_PayEstimate
(@Pay money
)
RETURNS money
AS 
BEGIN
DECLARE @PayRate money
SET @PayRate=  MAX(@Pay) - (MAX(@Pay) - MIN(@Pay))
RETURN @PayRate
END
GO


