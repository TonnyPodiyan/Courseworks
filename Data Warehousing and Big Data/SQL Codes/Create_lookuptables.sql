use[Staging Area]

create table datekeylookup(
[date] datetime not null,
datekey datetime primary key not null)

create table productkeylookup(
sku varchar(100) primary key not null,
productname varchar(100) not null)

create table supplierkeylookup(
suppliername varchar(100) primary key not null,
supplierid int not null)

create table warehousekeylookup(
warehouseoutletid varchar(50) not null,
warehousekey int primary key not null ) 

drop table datekeylookup
drop table [dbo].[Productkeylookup]
drop table [dbo].[supplierkeylookup]
drop table [dbo].[warehousekeylookup]

use [ABC_Warehouse]

select * from dbo.DimWarehouse
