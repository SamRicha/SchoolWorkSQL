
USE MetroAlt

/*
    Alter the table MaintenanceDetail. Drop the column MaintenanceNotes.

    Create a new xml schema collection called "MaintenanceNoteSchemaCollection" using the following schema:
    
    <?xml version="1.0" encoding="utf-8"?>
    <xs:schema attributeFormDefault="unqualified" 
               elementFormDefault="qualified" 
               targetNamespace="http://www.metroalt.com/maintenancenote" 
               xmlns:xs="http://www.w3.org/2001/XMLSchema">
      <xs:element name="maintenancenote">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="title" />
            <xs:element name="note">
              <xs:complexType>
                <xs:sequence>
                  <xs:element maxOccurs="unbounded" name="p" />
                </xs:sequence>
              </xs:complexType>
            </xs:element>
            <xs:element name="followup" />
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    </xs:schema>
*/
CREATE xml SCHEMA collection MaintenanceNotesSchema
AS
'<?xml version="1.0" encoding="utf-8"?>
<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" targetNamespace="http://www.metroalt.com/MaintenanceNotes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="MaintenanceNotes">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="comments">
          <xs:complexType>
            <xs:sequence>
              <xs:element maxOccurs="unbounded" name="comment" type="xs:string" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="actions">
          <xs:complexType>
            <xs:sequence>
              <xs:element maxOccurs="unbounded" name="action" type="xs:string" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'

/*
    Now alter the table MaintenanceDetail. Add the column MaintenanceNotes as XML using the Schema "MaintenanceNoteSchemaCollection".
*/

ALTER TABLE MaintenanceDetail
DROP COLUMN MaintenanceNotes

ALTER TABLE MaintenanceDetail
ADD MaintenanceNotes xml (MaintenanceNotesSchema)

INSERT INTO Maintenance(MaintenanceDate, BusKey)
VALUES(getdate(),2)

/*
    the xml file looks as follows:
    
    <?xml version="1.0" encoding="utf-8"?>
    <maintenancenote xmlns="http://www.metroalt.com/maintenancenote">
      <title>Wear and Tear on Hydralic units</title>
    <note>
      <p>The hydralic units are showing signs of stress</p>
      <p>I recommend the replacement of the units</p>
    </note>
      <followup>Schedule replacement for June 2016</followup>
    </maintenancenote>
    
    Insert a record using the xml above and then add two more records. You can invent the values.

    Set up an xquery that searches for one of the titles
*/
INSERT INTO MaintenanceDetail(MaintenanceKey, EmployeeKey, BusServiceKey, maintenancenotes)
VALUES(ident_current('Maintenance'),69,2,
'<?xml version="1.0" encoding="utf-8"?>
<MaintenanceNotes xmlns="http://www.metroalt.com/MaintenanceNotes">
  <comments>
    <comment>Headlight out</comment>
  </comments>
  <actions>
    <action>replaced headlight</action>
  </actions>
</MaintenanceNotes>')

INSERT INTO Maintenance(MaintenanceDate, BusKey)
VALUES(getdate(),3)

INSERT INTO MaintenanceDetail(MaintenanceKey, EmployeeKey, BusServiceKey, maintenancenotes)
VALUES(ident_current('Maintenance'),69,3,
'<?xml version="1.0" encoding="utf-8"?>
<MaintenanceNotes xmlns="http://www.metroalt.com/MaintenanceNotes">
  <comments>
    <comment>Bus stinks</comment>
	<comment>broke back seat</comment>
  </comments>
  <actions>
    <action>have bus cleaned and interior repaired</action>
  </actions>
</MaintenanceNotes>')

SELECT * FROM MaintenanceDetail

SELECT top 10 EmployeeLastName,EmployeeFirstName, EmployeeEmail FROM Employee
FOR xml raw

SELECT top 10 EmployeeLastName,EmployeeFirstName, EmployeeEmail FROM Employee
FOR xml raw('employee'), elements, root('employees')

SELECT top 10 EmployeeLastName,EmployeeFirstName, EmployeeEmail, 
PositionName,EmployeeHourlyPayRate
FROM Employee
INNER JOIN EmployeePosition
ON Employee.EmployeeKey=EmployeePosition.EmployeeKey
INNER JOIN Position
ON Position.PositionKey=EmployeePosition.PositionKey
FOR xml auto, elements, root('employees')

SELECT MaintenanceKey, EmployeeKey, BusServiceKey, MaintenanceNotes.query('declare namespace mn="http://www.metroalt.com/MaintenanceNotes";
//mn:MaintenanceNotes/mn:comments/*') AS comments FROM MaintenanceDetail


