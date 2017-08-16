use metroalt

create table BusService
(
BusServiceKey int identity (1,1) not null,
BusServiceName varchar(255) not null,
BusServiceDescription varchar(255),
);

create table Maintenance
(
MaintenanceKey int identity (1,1) not null,
MaintenanceDate date not null,
BusKey int not null,
);

create table MaintenanceDetail
(
MaintenanceDetailKey int identity (1,1) not null,
MaintenanceKey int not null,
EmployeeKey int not null,
BusServiceKey int not null,
MaintenanceNotes varchar(255),
);

alter table MaintenanceDetail
Add constraint PK_MaintenanceDetail primary key (MaintenanceDetailKey)

alter table Maintenance
Add constraint PK_Maintenance primary key (MaintenanceKey)

alter table BusService
Add constraint PK_BusService primary key (BusServiceKey)

alter table MaintenanceDetail
add constraint FK_Maintenance foreign key (MaintenanceKey)
references Maintenance(MaintenanceKey)

alter table MaintenanceDetail
add constraint FK_Employee foreign key (EmployeeKey)
references Employee(EmployeeKey)

alter table MaintenanceDetail
add constraint FK_BusService foreign key (BusServiceKey)
references BusService(BusServiceKey)

alter table BusType
add BusTypeAccessible bit

alter table Employee
add constraint unique_email unique(EmployeeEmail)
