/*
    1. Create a Union between Person and PersonAddress in Community assist and Employee in MetroAlt. You will need to fully qualify the tables in the CommunityAssist part of the query:

    CommunityAssist.dbo.Person etc.
*/
USE Community_Assist
SELECT PersonFirstName,PersonLastName,PersonAddressCity
FROM Person p
INNER JOIN PersonAddress pa
ON p.PersonKey=pa.PersonKey
UNION
SELECT EmployeeFirstName,EmployeeLastName,EmployeeCity
FROM MetroAlt.dbo.Employee

/*
    2. Do an intersect between the PersonAddress and Employee that returns the cities that are in both.
*/

USE Community_Assist
SELECT DISTINCT PersonAddressCity FROM PersonAddress
INNER JOIN MetroAlt.dbo.Employee
ON EmployeeCity = PersonAddress.PersonAddressCity

/*
    3. Do an except between PersonAddress and Employee that returns the cities that are not in both.
*/

SELECT DISTINCT PersonAddressCity FROM PersonAddress
except
SELECT DISTINCT EmployeeCity FROM MetroAlt.dbo.Employee

/*
    4. For this we will use the Data Tables we made in CreateTables.sql file. Insert the following services into BusService: General Maintenance, Brake service, hydraulic maintenance, and Mechanical Repair. You can add descriptions if you like. Next add entries into the Maintenance table for busses 12 and 24. You can use today’s date. For the details on 12 add General Maintenance and Brake Service, for 24 just General Maintenance. You can use employees 60 and 69 they are both mechanics.
*/

USE MetroAlt
BEGIN tran
INSERT INTO BusService(BusServiceName,BusServiceDescription)
VALUES ('General Maintenance','Maintain'), ('Brake Service','Brake'),('Hydraulic Maintenance','Hydrolic'),
('Mechanical Repair','Repair')
SELECT * FROM BusService


INSERT INTO Maintenance(MaintenanceDate,BusKey)
VALUES (getdate(),'12'), (getdate(),'24')



INSERT INTO MaintenanceDetail(MaintenanceKey,EmployeeKey,BusServiceKey,MaintenanceNotes)
VALUES ('1','60','1','General Maintenance and Brake Service'), ('2','1','69','2','General Maintenance')
ROLLBACK tran
COMMIT tran

/*
    5. Create a table that has the same structure as Employee, name it Drivers. Use the Select form of an insert to copy all the employees whose position is driver (1) into the new table.
*/

CREATE TABLE Drivers
(
DriverKey INT NOT NULL PRIMARY KEY,
DriverLastName VARCHAR(255),
DriverFirstName VARCHAR(255),
DriverAddressAddress VARCHAR(255) NOT NULL,
DriverCity VARCHAR(255) NOT NULL,
DriverZipCode nchar(10) NOT NULL,
DriverPhone VARCHAR(255),
DriverEmail VARCHAR(255) NOT NULL,
DriverHireDate DATE NOT NULL
)
INSERT INTO Drivers
SELECT * FROM Employee
INNER JOIN EmployeePosition
ON Employee.EmployeeKey=EmployeePosition.EmployeeKey
WHERE PositionKey='1'

/*
    6. Edit the record for Bob Carpenter (Key 3) so that his first name is Robert and is City is Bellevue
*/

BEGIN tran
UPDATE Employee
SET EmployeeFirstName='Robert',
EmployeeCity='Bellevue'
WHERE EmployeeKey='3'
ROLLBACK tran
COMMIT tran

/*
    7. Give everyone a 3% Cost of Living raise.
*/

BEGIN tran
UPDATE EmployeePosition
SET EmployeeHourlyPayRate = EmployeeHourlyPayRate * 1.03
ROLLBACK tran
COMMIT tran

/*
    8. Delete the position Detailer
*/

BEGIN tran
DELETE FROM Position
WHERE PositionName='Detailer'
ROLLBACK tran
COMMIT tran



