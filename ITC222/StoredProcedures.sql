USE MetroAlt

/*
    1. Create a stored procedure to enter a new employee, position and pay rate which uses the functions to create an email address and the one to determine initial pay. Also make sure that the employee does not already exist. Use the stored procedure to add a new employee.
*/

GO
CREATE PROCEDURE usp_Employee
@EmployeeLastName nvarchar(255), 
@EmployeeFirstName nvarchar(255), 
@EmployeeAddress nvarchar(255),
@EmployeeCity nvarchar(255) = 'Seattle',
@EmployeeZipCode nchar(9),
@EmployeePhone nchar(10),
@EmployeeHireDate nvarchar(255),
@PositionKey INT,
@EmployeePositionDateAssigned DATE
AS 
DECLARE @EmployeeEmail nvarchar(255)
SET @EmployeeEmail = dbo.fx_Email(@EmployeeLastName,@EmployeeFirstName) 

DECLARE @EmployeeHourlyPayRate DECIMAL(5,2)
SET @EmployeeHourlyPayRate = dbo.fx_PayEstimate(@PositionKey)
INSERT INTO Employee(
EmployeeLastName, 
EmployeeFirstName, 
EmployeeAddress,
EmployeeCity,
EmployeeZipCode,
EmployeePhone,
EmployeeEmail,
EmployeeHireDate)
Values(
@EmployeeLastName, 
@EmployeeFirstName, 
@EmployeeAddress,
@EmployeeCity,
@EmployeeZipCode,
@EmployeePhone,
@EmployeeEmail,
getdate())

INSERT INTO EmployeePosition(
PositionKey,
EmployeeHourlyPayRate,
EmployeePositionDateAssigned
)
VALUES(
@PositionKey,
@EmployeeHourlyPayRate,
getdate())


exec usp_Employee
@EmployeeLastName ='jackson', 
@EmployeeFirstName ='joses', 
@EmployeeAddress ='1864 mathews st',
@EmployeeZipCode ='98124',
@EmployeePhone ='2095678432',
@PositionKey ='4'

GO

/*
    2. Create a stored procedure that allows an employee to edit their own information name, address, city, zip, not email etc.  The employee key should be one of its parameters. Use the procedure to alter one of the employees information. Add error trapping to catch any errors.
*/

GO
CREATE PROCEDURE usp_EmployeeEdit
@EmployeeKey INT,
@EmployeeLastName nvarchar(255), 
@EmployeeFirstName nvarchar(255), 
@EmployeeAddress nvarchar(255),
@EmployeeCity nvarchar(255),
@EmployeeZipCode nchar(9)


AS BEGIN
UPDATE Employee SET
	EmployeeLastName = @EmployeeLastName,
	EmployeeFirstName = @EmployeeFirstName, 
	EmployeeAddress = @EmployeeAddress,
	EmployeeCity = @EmployeeCity,
	EmployeeZipCode = @EmployeeZipCode
WHERE
	EmployeeKey = @EmployeeKey
END

BEGIN try
BEGIN tran
exec usp_EmployeeEdit
@EmployeeKey = '2',
@EmployeeLastName ='thomas', 
@EmployeeFirstName = 'jones', 
@EmployeeAddress = '1780 s 113th st',
@EmployeeCity = 'seattle',
@EmployeeZipCode = '97890'
COMMIT tran
END try
GO

