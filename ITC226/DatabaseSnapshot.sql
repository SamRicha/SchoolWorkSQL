/*
    Create a snapshot of MetroAlt.

    Now in the actual database add a record to Employee and update one existing record (in employee). Run a query on Employee in the Snapshot.

*/

USE MASTER

CREATE DATABASE MetroAlt_Snapshot
ON 
(name='MetroAlt', 
Filename='C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\MetroAlt_snapshot.ds')
AS
SNAPSHOT of MetroAlt

USE MetroAlt_Snapshot

SELECT * FROM Employee

USE MetroAlt
UPDATE Employee
SET EmployeeFirstName ='jason'
WHERE EmployeeKey=1

USE MASTER
Restore DATABASE MetroAlt
FROM Database_snapshot = 'MetroAlt_Snapshot'
