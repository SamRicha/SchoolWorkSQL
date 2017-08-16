
USE MetroAlt

/*
    1. List the years in which Employees were hired, sort by year and then last name.
*/

SELECT YEAR(EmployeeHireDate) AS [Years Employees were Hired], EmployeeLastName FROM Employee
ORDER BY YEAR(EmployeeHireDate),EmployeeLastName

/*
    2. What is the difference in Months between the first Employee hired and the last one.
*/

SELECT datediff(month, MIN(EmployeeHireDate), MAX(EmployeeHireDate)) AS [Month Difference] FROM Employee

/*
    3. Output the Employee phone number so it looks like (206)555-1234.
*/

SELECT '('+substring(EmployeePhone,1,3)+')'+substring(EmployeePhone,4,3)+'-'+substring(EmployeePhone,7,len(EmployeePhone)) AS [Formatted Phone]
FROM Employee

/*
    4. Output the Employee hourly wage so it looks like $45.00 (EmployeePosition).
*/

SELECT format(EmployeehourlyPayRate, '$ ##.00') AS [Hourly Wage] FROM EmployeePosition

/*
    5. List only the Employees who were hired between 2013 and 2015.
*/

SELECT EmployeeHireDate, EmployeeFirstName, EmployeeLastName FROM Employee
WHERE YEAR(EmployeeHireDate) BETWEEN 2013 AND 2015

/*
    6. Output the position, the hourly wage and the hourly wage multiplied by 40 to see what a weekly wage might look like.
*/

SELECT EmployeeHourlyPayRate * 40 AS [Weekly Wage] FROM EmployeePosition

/*
    7. What is the highest hourly pay rate (EmployeePosition)?
*/

SELECT MAX(EmployeeHourlyPayRate) AS [Highest Hourly Pay Rate] FROM EmployeePosition

/*
    8. What is the lowest hourly pay rate?
*/

SELECT MIN(EmployeeHourlyPayRate) AS [Lowest Hourly Pay Rate] FROM EmployeePosition

/*
    9. What is the average hourly pay rate?
*/

SELECT format(AVG(EmployeeHourlyPayRate),'##.00') AS [Average Hourly Pay Rate] FROM EmployeePosition

/*
    10. What is the average pay rate by position?
*/

SELECT format(AVG(EmployeeHourlyPayRate),'##.00') AS [Average Hourly Pay Rate], PositionKey FROM EmployeePosition
GROUP BY PositionKey

/*
    11. Provide a count of how many Employees were hired each year and each month of the year.
*/

SELECT COUNT(DISTINCT EmployeeHireDate) AS [Amount Hired] FROM Employee 
GROUP BY month(EmployeeHireDate)

SELECT YEAR(EmployeeHireDate) AS [YEAR],COUNT(DISTINCT EmployeeHireDate) AS [Amount Hired] FROM Employee 
GROUP BY YEAR(EmployeeHireDate)


/*
    12. Do the query 11 again but with a case structure to output the months as words.
*/

SELECT COUNT(DISTINCT EmployeeHireDate) AS [Amount Hired], CASE month (EmployeeHireDate)
WHEN 1 THEN 'january'
WHEN 2 THEN 'february'
WHEN 3 THEN 'march'
WHEN 4 THEN 'april'
WHEN 5 THEN 'may'
WHEN 6 THEN 'june'
WHEN 7 THEN 'july'
WHEN 8 THEN 'august'
WHEN 9 THEN 'september'
WHEN 10 THEN 'october'
WHEN 11 THEN 'november'
WHEN 12 THEN 'december'
END AS [month]
FROM Employee
GROUP BY month(EmployeeHireDate)

/*
    13. Return which positions average more than $50 an hour.
*/

SELECT format(AVG(EmployeeHourlyPayRate),'##.00') AS [Average Hourly Pay Rate], PositionKey FROM EmployeePosition
GROUP BY PositionKey
HAVING AVG(EmployeeHourlyPayRate) > 50

/*
    14. List the total number of riders on Metroalt busses (RiderShip).
*/

SELECT COUNT(Riders) AS [Total Number of Riders] FROM Ridership

/*
    15. List all the tables in the metroAlt databases (system views).
*/

USE MetroAlt
SELECT * FROM sys.tables

/*
    16. List all the databases on server.
*/

SELECT Name FROM sys.databases

