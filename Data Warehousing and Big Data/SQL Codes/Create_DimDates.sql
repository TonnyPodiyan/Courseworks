-- declare variables to hold the start and end date
DECLARE @StartDate datetime
DECLARE @EndDate datetime

--- assign values to the start date and end date we 
-- want our reports to cover (this should also take
-- into account any future reporting needs)
SET @StartDate = '2014-01-03'
SET @EndDate = '2018-12-31' 

IF EXISTS (SELECT * 
			FROM sysobjects 
			WHERE type = 'U' 
			AND ID = OBJECT_ID('[dbo].[dimDates]') )
BEGIN
	DROP TABLE [dbo].[DimDates]
	PRINT 'Table dropped'
END
CREATE TABLE dbo.DimDates (
 DateKey int NOT NULL IDENTITY(1, 1),
 [Date] datetime NOT NULL,
 [Year] int NOT NULL, 
 [Month] int NOT NULL,
 [MonthName] varchar(10) NOT NULL,
 [Week] int NOT NULL,
 [Day] int NOT NULL,
 [QuarterNumber] int NOT NULL,
 CONSTRAINT PK_dimDates PRIMARY KEY CLUSTERED (DateKey)
)


-- using a while loop increment from the start date 
-- to the end date
DECLARE @LoopDate datetime
SET @LoopDate = @StartDate

WHILE @LoopDate <= @EndDate
BEGIN
 -- add a record into the date dimension table for this date
INSERT INTO DimDates VALUES (
  @LoopDate,
  Year(@LoopDate),
  Month(@LoopDate), 
  DATENAME(MM,@LoopDate), 
  DATEPART(WK,@LoopDate),  
  Day(@LoopDate), 
  CASE WHEN Month(@LoopDate) IN (1, 2, 3) THEN 1
   WHEN Month(@LoopDate) IN (4, 5, 6) THEN 2
   WHEN Month(@LoopDate) IN (7, 8, 9) THEN 3
   WHEN Month(@LoopDate) IN (10, 11, 12) THEN 4
  END 
   
 )  
 
 -- increment the LoopDate by 1 day before
 -- we start the loop again
 SET @LoopDate = DateAdd(d, 1, @LoopDate)

END
