
---------------------PART I-----------------------

CREATE DATABASE ADVANCE_SQL_EXAM
GO

--Create Emp and Job tables on Adv_SQL_FinalExam Database
CREATE TABLE Employee
(
	Emp_num int NOT NULL PRIMARY KEY,
	Emp_Fname char(20) NULL DEFAULT 'DF_UNKNOWN',
	Emp_Lname char(20) NOT NULL,
	Emp_JobClass char(3) NULL,
	HireDate Date NOT NULL
)
DROP TABLE JOB 

CREATE TABLE JOB
(
	 Job_Code INT NOT NULL PRIMARY KEY,
	 Job_Class char(30) NULL,
	 chg_Hour decimal NULL DEFAULT 15
 )

  --(Q2)--ADD COLUMN -- overtimeCharge dec (6,2) NOT NULL in to Job table

 
 ALTER TABLE JOB
 ADD OvertimeCharge decimal(6,2) NOT NULL

 --Q3--We decide to make the chg_hour column value be greater than 25 , change the column accordingly

		 UPDATE JOB 
		SET chg_Hour = 25
		WHERE chg_Hour = 15

--Q4. Add a default value of ‘NA’ for job_class column		ALTER TABLE JOB 		ADD DEFAULT 'NA'		FOR job_class--Q5. Change the nullablity of the Chg_Hour column to NOT NULL--FIRST we should bring all null to disappear by updating	UPDATE JOB 	SET chg_Hour=0 WHERE chg_Hour IS NULL--And we can alter target column into not null	ALTER TABLE JOB 	ALTER COLUMN chg_Hour DECIMAL NOT NULL-- Q6. Change the data type for Chg_Hour column to decimal data type with precision 12 and scale	ALTER TABLE JOB 	ALTER COLUMN chg_Hour DECIMAL(12,2) NOT NULL--- Q7. Drop the constraint placed on chg_hour column above (no. 4) 
	ALTER TABLE JOB     DROP constraint chg_Hour_default ---Q8. Remove the overtimeCharge column		ALTER TABLE JOB		DROP COLUMN OvertimeCharge---Q9.Remove the chg_hour column --//// its important to drop the constrant befor we drop	ALTER TABLE JOB	DROP COLUMN chg_hour---10. The business wants to make sure no employee hire date is set before Jan 1st, 2000. 
     --Make sure the database enforce such rule
	 --we should put a check constraint
	ALTER TABLE Employee	ADD CHECK (hiredate > before(01/01/2000)) 	go	 ---------------------------------	     ------------PART II----------------	-----------PART II Data Manipulation Commands:

----1.	Insert at least 10 rows into the EMP and JOB tables using stored procedure.
	
	/* stored procedure
	autor fitsum gebre
	description: this stored procedure inserts data into a table
	*/
	
	CREATE procedure spInsertdataIntoEmployees
	    @Emp_num int, 
	    @Emp_Fname char(20), 
	    @Emp_Lname char(20),
	    @Emp_JobClass char(3), 
	    @HireDate Date 
	AS
	BEGIN
	
	INSERT INTO Employee (Emp_num, Emp_Fname, Emp_Lname, Emp_JobClass, HireDate)
	SELECT @Emp_num, @Emp_Fname,@Emp_Lname,@Emp_JobClass, @HireDate
	END
	GO
	---EXECUTING DATA INSERT USING PROCEDURE

  EXEC spInsertdataIntoEmployees 1,'JOE','NAO','DMM','02/02/1999'
  EXEC spInsertdataIntoEmployees 2,'OLIVER','TECHNO','DML','02/02/1994'
  EXEC spInsertdataIntoEmployees 3,'KHAN','GOLIAD','DMM','02/02/1997'
  EXEC spInsertdataIntoEmployees 4,'NATHAN','RANDY','	MMM','02/02/1999'
  EXEC spInsertdataIntoEmployees 5,'AMEN','MENDO','DTT','02/02/1999'
  EXEC spInsertdataIntoEmployees 6,'MARRY','FULTAN','DMM','02/02/1998'
  EXEC spInsertdataIntoEmployees 7,'SITINA','BOLTON','DMM','02/02/1996'
  EXEC spInsertdataIntoEmployees 8,'MELODY','BRENDON','DML','02/02/1998'
  EXEC spInsertdataIntoEmployees 9,'ADAM','KALEB','DMM','02/02/1997'
  EXEC spInsertdataIntoEmployees 10,'GEDI','MINDY','DTT','02/02/1998'
  GO
  SELECT * FROM Employee
  GO

	/* Stored procedure
	Autor: fitsum gebre
	description: this is a stored procedure that inserts data into a table job
	*/

	CREATE PROC spInsertdataIntoJobs
		@Job_Code INT,
		@Job_Class char(30),
		@chg_Hour decimal(12,2)
	AS
	BEGIN
		INSERT INTO JOB (Job_Code,Job_Class,chg_Hour)
		Select @Job_Code,@Job_Class,@chg_Hour
	END
	GO
--EXECUTING DATA INSERT USING PROCEDURE

EXEC spInsertdataIntoJobs '1', 'department of technology','80.00'

EXEC spInsertdataIntoJobs '2','department of IT','120.00'

EXEC spInsertdataIntoJobs '3','department of technology','95.00'

EXEC spInsertdataIntoJobs '4','department of networking','110.00'

EXEC spInsertdataIntoJobs '5','department of IT','105.00'

EXEC spInsertdataIntoJobs '6','department of networking','70.00'

EXEC spInsertdataIntoJobs '7','department of technology','100.30'

EXEC spInsertdataIntoJobs '8','department of technology','90.00'

EXEC spInsertdataIntoJobs '9','department of technology','112.10'

EXEC spInsertdataIntoJobs '10','department of networking','87.03'

SELECT * from JOB
GO
--2. Write a stored procedure that updates the first and last name of a employee given emp_id
--the following code creates a stored procedure that is called 
--to update employee name

CREATE PROCEDURE spUpdate_Employee
	@Emp_num int,
	@Emp_FName char(20),
	@Emp_LName char(20)
AS
Update Employee
set  
     Emp_FName = @Emp_FName,
     Emp_LName = @Emp_LName
where Emp_num = @Emp_num

Go
Exec spUpdate_Employee 1, 'fits','sacku'

SELECT * from Employee

--Q3. Write a t-sql script to increase the chg_hours by 10% for all employees

 SELECT chg_Hour + (chg_Hour * 0.1) As IncChgHor from JOB 
 go
 
--Q4. Write a stored procedure that deletes a duplicate record of an employee, 
--if that exists. (test it by inserting a duplicate record) 


CREATE PROC spDeleteDuplicates
	@Emp_num int,
	@Emp_FName char(20),
	@Emp_LName char(20),
	@Emp_JobClass char(3),
	@HireDate Date

AS
SET NOCOUNT ON
BEGIN

WITH New_empTable AS
 (
  SELECT RN = ROW_NUMBER() OVER (PARTITION BY Emp_num ORDER BY Emp_num )
          ,Emp_FName 
		 ,Emp_LName
		 ,Emp_JobClass
		 ,HireDate
  FROM   Employee
)
DELETE FROM New_empTable WHERE RN > 1;
END
GO
----inserting a duplicate data

Insert into Employee ([Emp_num],[Emp_Fname],[Emp_Lname],[Emp_JobClass],[HireDate])
VALUES( 12, 'NATHAN','RANDY', 'MM','02/02/1999')

	declare @Emp_num int
	declare @Emp_FName char(20)
	declare @Emp_LName char(20)
	declare @Emp_JobClass char(3)
	declare @HireDate Date
EXEC spDeleteDuplicates Emp_num,Emp_Fname,Emp_Lname,Emp_JobClass, HireDate

select * from Employee 

----------------------------------------------------------------------PART III---------------------		