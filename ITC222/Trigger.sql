/*
    Create a trigger to fire when an employee is assigned to a second shift in a day. Have it write to an overtime table. the Trigger should create the overtime table if it doesn't exist. Add an employee for two shifts to test the trigger.

    events insert update and delete
*/

USE MetroAlt

GO
ALTER TRIGGER tr_OverTime ON BusScheduleAssignment
instead of INSERT
AS

-- DECLARE variables

DECLARE @EmployeeKey INT
DECLARE @BusScheduleAssignmentDate DATE
DECLARE @BusScheduleAssignmentDateMade DATE

-- assign values from inserted and 

SELECT @EmployeeKey = EmployeeKey FROM Inserted
SELECT @BusScheduleAssignmentDateMade= BusScheduleAssignmentDate 
FROM inserted WHERE EmployeeKey = @EmployeeKey 
SELECT @BusScheduleAssignmentDate= BusScheduleAssignmentDate 
FROM BusScheduleAssignment WHERE EmployeeKey = @EmployeeKey

IF @BusScheduleAssignmentDate != @BusScheduleAssignmentDateMade
BEGIN
INSERT INTO BusScheduleAssignment(BusDriverShiftKey, EmployeeKey, BusRouteKey, BusScheduleAssignmentDate, BusKey)
SELECT BusDriverShiftKey, EmployeeKey, BusRouteKey, BusScheduleAssignmentDate, BusKey
FROM inserted
END
ELSE
BEGIN
IF NOT EXISTS
  (SELECT name FROM sys.Tables WHERE name ='Overtime')
  BEGIN
  CREATE TABLE Overtime
  ( 
  BusDriverShiftKey INT, 
  EmployeeKey INT, 
  BusRouteKey INT, 
  BusScheduleAssignmentDate DATE, 
  BusKey INT
  )

  END
  INSERT INTO Overtime(BusDriverShiftKey, 
  EmployeeKey, 
  BusRouteKey, 
  BusScheduleAssignmentDate, 
  BusKey)
 SELECT BusDriverShiftKey, 
  EmployeeKey, 
  BusRouteKey, 
  BusScheduleAssignmentDate, 
  BusKey
  FROM Inserted

END
GO
BEGIN tran
INSERT INTO BusScheduleAssignment(
  BusDriverShiftKey,
  EmployeeKey, 
  BusRouteKey, 
  BusScheduleAssignmentDate, 
  BusKey)
VALUES (1, 1, 1,'2012-01-02',1)
COMMIT tran
ROLLBACK tran
SELECT * FROM BusScheduleAssignment
SELECT * FROM Overtime


