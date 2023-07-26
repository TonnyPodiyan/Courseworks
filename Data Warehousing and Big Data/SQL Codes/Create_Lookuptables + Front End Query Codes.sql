use[Staging Area];
create table datekeylookup(
[date] datetime not null,
datekey int primary key not null);

create table productkeylookup(
sku varchar(50) primary key not null,
productname nvarchar(100) not null);

create table supplierkeylookup(
supplierid tinyint primary key not null,
suppliername nvarchar(50)) ;

create table warehousekeylookup(
warehouseoutletid varchar(50) not null,
warehousekey int primary key not null ) ;

Select * from supplierkeylookup

select * from [dbo].[Sampleofproductscomplied]

use ABC_Warehouse
select * from [dbo].[factstockcheck]

use [ABC_Warehouse]

--A daily stock levels of all products for the last month.-V1
 SELECT dd.date,
		fsc.inventoryid,
       fsc.sku,
	   ds.suppliername,
       fsc.currentstocklevel
  FROM [dbo].[factstockcheck] AS fsc
INNER JOIN [dbo].[dimsupplier] AS ds ON ds.supplierid = fsc.supplierid
INNER JOIN [dbo].[dimdate] AS dd ON dd.datekey = fsc.datekey
ORDER BY date DESC;

--A daily stock levels of all products for the last month.-V2
SELECT fsc.sku,
       ds.suppliername,
       MAX(CASE WHEN dd.date = '2015-10-17' THEN fsc.currentstocklevel END) AS '2015-10-17',
       MAX(CASE WHEN dd.date = '2015-10-18' THEN fsc.currentstocklevel END) AS '2015-10-18',
       MAX(CASE WHEN dd.date = '2015-10-19' THEN fsc.currentstocklevel END) AS '2015-10-19'
FROM [dbo].[factstockcheck] AS fsc
INNER JOIN [dbo].[dimsupplier] AS ds ON ds.supplierid = fsc.supplierid
INNER JOIN [dbo].[dimdate] AS dd ON dd.datekey = fsc.datekey
GROUP BY fsc.sku, ds.suppliername;

--A weekly report of all products with minimum stock levels(Less than 10).
SELECT fsc.sku,
       dp.productname AS product_name,
       MIN(fsc.currentstocklevel) AS min_stock_level,
       dd.week,
       dd.year
FROM [dbo].[factstockcheck] AS fsc
INNER JOIN [dbo].[dimdate] AS dd ON dd.datekey = fsc.datekey
INNER JOIN [dbo].[dimproduct] AS dp ON dp.sku = fsc.sku
GROUP BY fsc.sku, dp.productname, dd.week, dd.year
HAVING MIN(fsc.currentstocklevel) < 10
ORDER BY min_stock_level asc ;

--Stock Level on Weekly Basis
SELECT fsc.sku,
       dp.productname AS product_name,
       MAX(CASE WHEN dd.week = 42 THEN fsc.currentstocklevel END) AS week_42,
       MAX(CASE WHEN dd.week = 43 THEN fsc.currentstocklevel END) AS week_43
       --MAX(CASE WHEN dd.week = 44 THEN fsc.currentstocklevel END) AS week_44,
       --MAX(CASE WHEN dd.week = 45 THEN fsc.currentstocklevel END) AS week_45
FROM [dbo].[factstockcheck] AS fsc
INNER JOIN [dbo].[dimdate] AS dd ON dd.datekey = fsc.datekey
INNER JOIN [dbo].[dimproduct] AS dp ON dp.sku = fsc.sku
GROUP BY fsc.sku, dp.productname
--HAVING MAX(fsc.currentstocklevel) < 10
ORDER BY MAX(fsc.currentstocklevel) asc;




--Analysing stock levels by brand or product type or supplier

SELECT dp.brand, SUM(fsc.currentstocklevel) AS total_stock
FROM [dbo].[factstockcheck] AS fsc
INNER JOIN [dbo].[dimproduct] AS dp ON dp.sku = fsc.sku
GROUP BY dp.brand;

SELECT dp.producttype, SUM(fsc.currentstocklevel) AS total_stock
FROM [dbo].[factstockcheck] AS fsc
INNER JOIN [dbo].[dimproduct] AS dp ON dp.sku = fsc.sku
GROUP BY dp.producttype;

SELECT ds.suppliername, SUM(fsc.currentstocklevel) AS total_stock
FROM [dbo].[factstockcheck] AS fsc
INNER JOIN [dbo].[dimsupplier] AS ds ON ds.supplierid = fsc.supplierid
GROUP BY ds.suppliername;








