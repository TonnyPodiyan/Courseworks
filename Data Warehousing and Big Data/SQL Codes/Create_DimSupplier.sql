CREATE TABLE DimSupplier (
    Supplier_ID int IDENTITY(1,1) PRIMARY KEY,
	Supplier_Name varchar(100),
    Phone_no bigint,
    Email varchar(100),
    PostCode varchar(100)
  )

Select * from DimSupplier
Drop Table DimSupplier
  
ALTER TABLE DimSupplier
ALTER COLUMN Phone_no bigint;
