/*
  Create a new database with 5 file groups and one file in each group.
  Create a table partition for the table . Divide the partition on the BusRouteShiftAssignmentDate. Partition it by Year (2012, 2013, 2014, 2015),
  Create a table that has the same structure as BusRoutescheduleAssignment. Import the data from BusRoutShiftAssignment into the new Table.
  Create a query that only queries the 2013 partition.
*/

USE MASTER

GO
ALTER DATABASE MetroAlt
ADD FileGroup FG1
ALTER DATABASE MetroAlt
ADD FileGroup FG2
ALTER DATABASE MetroAlt
ADD FileGroup FG3
ALTER DATABASE MetroAlt
ADD FileGroup FG4
ALTER DATABASE MetroAlt
Add FileGroup FG5
GO

ALTER DATABASE MetroAlt
ADD File
(Name=FG1_dat, Filename='C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\MetroAlt_1.ndf', size=2mb)
TO FIleGroup FG1

ALTER DATABASE MetroAlt
ADD File
(Name=FG2_dat, Filename='C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\MetroAlt_2.ndf', size=2mb)
TO FIleGroup FG2

ALTER DATABASE MetroAlt
ADD File
(Name=FG3_dat, Filename='C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\MetroAlt_3.ndf', size=2mb)
TO FIleGroup FG3

ALTER DATABASE MetroAlt
ADD File
(Name=FG4_dat, Filename='C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\MetroAlt_4.ndf', size=2mb)
TO FIleGroup FG4

ALTER DATABASE MetroAlt
ADD File
(Name=FG5_dat, Filename='C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\MetroAlt_5.ndf', size=2mb)
TO FIleGroup FG5

USE MetroAlt

CREATE PARTITION FUNCTION fx_BusShift (INT)
AS
RANGE RIGHT
FOR VALUES ('2012','2013','2014','2015')

CREATE PARTITION scheme BusShiftScheme
AS PARTITION fx_BusShift
TO (FG1,FG2,FG3,FG4,FG5)
GO

CREATE TABLE BusScheduleAssignment
(
BusScheduleAssignmentKey INT NOT NULL,
BusDriverShiftKey INT NOT NULL,
EmployeeKey INT NOT NULL,
BusRouteKey INT NOT NULL, 
BusScheduleAssignmentDate INT, 
BusKey INT
)
ON BusShiftScheme (YEAR(BusRouteShiftAssignmentDate))

CREATE clustered INDEX ix_BusShift ON BusScheduleAssignment(BusRouteShiftAssignmentDate)

ALTER TABLE BusSchedule
ADD CONSTRAINT pk_BusScheduleAssignment PRIMARY KEY nonclustered (BusScheduleAssignmentkey,BusScheduleAssignmentdate)
ON BusShiftScheme(BusScheduleAssignmentdate)

INSERT INTO BusScheduleAssignment(BusScheduleAssignmentKey, BusDriverShiftKey, 
EmployeeKey, BusRouteKey, BusScheduleAssignmentDate, BusKey)
SELECT BusScheduleAssignmentKey, BusDriverShiftKey, EmployeeKey, BusRouteKey, 
BusScheduleAssignmentDate, BusKey
FROM MetroAlt.dbo.BusScheduleAssignment

SELECT * FROM BusScheduleAssignment
WHERE $partition.fx_busshift(BusScheduleAssignment)=2013
