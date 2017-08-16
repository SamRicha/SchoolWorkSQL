/*
    1. Create a temp table to show how many stops each route has. the table should have fields for the route number and the number of stops. Insert into it from BusRouteStops and then select from the temp table.
*/

CREATE table #busstopcount
(
routekey int,
routeamount int
)
insert into #busstopcount(routekey,routeamount) 
select BusRouteKey,sum(BusRouteStopKey) as [Bus Stop Amount]
from busroutestops
group by BusRouteKey
order by BusRouteKey

/*
    2.Do the same but using a global temp table.
*/

CREATE table ##globalbusstopcount
(
routekey int,
routeamount int
)
insert into ##globalbusstopcount(routekey,routeamount) 
select BusRouteKey,sum(BusRouteStopKey) as [Bus Stop Amount]
from busroutestops
group by BusRouteKey

/*
    3.CREATE a function to CREATE an employee email address. Every employee Email follows the pattern of "firstName.lastName@metroalt.com"
*/

CREATE function fx_email
(@firstname nvarchar(255),
@lastname nvarchar(255))
returns nvarchar(255)
As
Begin
Declare @email nvarchar(255)
Set @email=@firstname +'.'+ @lastname +'@metroalt.com'
return @email
End
go

select dbo.fx_email(employee.employeefirstname,employee.employeelastname) as email
from employee

/*
    4.CREATE a function to determine a two week pay check of an individual employee.
*/

go
CREATE function fx_TwoWeek
(@payrate int
)
returns int
as begin
declare @twoweektotal int
set @twoweektotal= @payrate * 40 * 2
return @twoweektotal
end
go

select employee.employeekey,dbo.fx_twoweek(employeehourlypayrate) as [Two week pay]
from employee
inner join employeeposition
on employeeposition.employeekey=employee.employeekey

/*
    5.CREATE a function to determine a hourly rate for a new employee. Take difference between top and bottom pay for the new employees position (say driver) and then subtract the difference from the maximum pay. (and yes this is very arbitrary).
*/

go
alter function fx_payestimate
(@pay money
)
returns money
as 
begin
declare @payrate money
set @payrate=  max(@pay) - (max(@pay) - min(@pay))
return @payrate
end
go


