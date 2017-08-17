/*
 Use metro Alt
 Add the following tables to metroAlt with the following columns and constraints
*/

USE MetroAlt

/*
    1. 
    BusService
    BusServiceKey int identity primary key
    BusServiceName variable character, required
    BusServiceDescription variable character
*/

CREATE TABLE BusService
(
BusServiceKey INT identity (1,1) NOT NULL,
BusServiceName VARCHAR(255) NOT NULL,
BusServiceDescription VARCHAR(255),
);

/*
    2.
    Maintenance
    MaintenanceKey int, an identity, primary key
    MainenanceDate Date, required
    Buskey int foreign key related to Bus, required
*/

CREATE TABLE Maintenance
(
MaintenanceKey INT identity (1,1) NOT NULL,
MaintenanceDate DATE NOT NULL,
BusKey INT NOT NULL,
);

/*
    3.
    MaintenanceDetail (we will use Alter table statements to add Keys to this table)
    MaintenanceDetailKey int identity 
    Maintenancekey int  required
    EmployeeKey int  required
    BusServiceKey int  required
    MaintenanceNotes  variable character
*/

CREATE TABLE MaintenanceDetail
(
MaintenanceDetailKey INT identity (1,1) NOT NULL,
MaintenanceKey INT NOT NULL,
EmployeeKey INT NOT NULL,
BusServiceKey INT NOT NULL,
MaintenanceNotes VARCHAR(255),
);

/*
    4.
    Use alter table to add a primary key constraint to Maintenance detail setting MaintenanceDetailKey as the primary key
*/

ALTER TABLE MaintenanceDetail
ADD CONSTRAINT PK_MaintenanceDetail PRIMARY KEY (MaintenanceDetailKey)

ALTER TABLE Maintenance
ADD CONSTRAINT PK_Maintenance PRIMARY KEY (MaintenanceKey)

ALTER TABLE BusService
ADD CONSTRAINT PK_BusService PRIMARY KEY (BusServiceKey)

/*
    5.
    Use alter table to set MaintenceKey as a foreign key
    Use alter table to set EmployeeKey as a foreign key
*/

ALTER TABLE MaintenanceDetail
ADD CONSTRAINT FK_Maintenance FOREIGN KEY (MaintenanceKey)
REFERENCES Maintenance(MaintenanceKey)

ALTER TABLE MaintenanceDetail
ADD CONSTRAINT FK_Employee FOREIGN KEY (EmployeeKey)
REFERENCES Employee(EmployeeKey)

/*
    6.
    Use alter table to set BusServiceKey as a foreign key
*/

ALTER TABLE MaintenanceDetail
ADD CONSTRAINT FK_BusService FOREIGN KEY (BusServiceKey)
REFERENCES BusService(BusServiceKey)


/*
    7.
    Add a column to BusType named BusTypeAccessible. Its data type should be bit 0 for no and 1 for yes.
*/

ALTER TABLE BusType
ADD BusTypeAccessible BIT

/*
    8.
    Use alter table to Add a constraint to email in the Employee table to make sure each email is unique
*/

ALTER TABLE Employee
ADD CONSTRAINT unique_email UNIQUE(EmployeeEmail)
