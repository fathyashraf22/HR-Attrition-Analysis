
----- Rename columns --- 

EXEC sp_rename 'Employee.Education', 'EducationLevelID', 'COLUMN';

EXEC sp_rename 'PerformanceRating.SelfRating','Self_RatingID','Column'

EXEC sp_rename 'PerformanceRating.ManagerRating','Manager_RatingID','Column'

EXEC sp_rename 'PerformanceRating.EnvironmentSatisfaction','Environment_SatisfactionID','Column'

EXEC sp_rename 'PerformanceRating.JobSatisfaction','Job_SatisfactionID','Column'

EXEC sp_rename 'PerformanceRating.RelationshipSatisfaction','Relationship_SatisfactionID','Column'
----------------------------------------------------------------------------------------------------
-- checking nulls  -- 
SELECT * 
FROM Employee 
WHERE [FirstName] is null or [LastName] is null or [Gender] is null or [Age]is null or [BusinessTravel] is null or [Department] is null or
	  [DistanceFromHome_KM] is null or [State] is null or [Ethnicity] is null or [EducationLevelID] is null or [EducationField] is null or
	  [JobRole]  is null or [MaritalStatus] is null or [Salary] is null or [StockOptionLevel] is null or [OverTime] is null or
	  [HireDate] is null or [Attrition] is null or [YearsAtCompany] is null or [YearsInMostRecentRole] is null or
	  [YearsSinceLastPromotion] is null or [YearsWithCurrManager] is null  
	  -------------------------------------------------------------------------------------------------------------------- 
 -- checking duplicated Rows 
 --- (employess)

SELECT EmployeeID, FirstName, LastName, Gender, Age, Department,Salary, StockOptionLevel, OverTime, HireDate, Attrition,
       YearsAtCompany, YearsInMostRecentRole, YearsSinceLastPromotion,YearsWithCurrManager, COUNT(*) AS DuplicateCount
FROM Employee
GROUP BY EmployeeID, FirstName, LastName, Gender, Age, Department,Salary, StockOptionLevel, OverTime,
         HireDate, Attrition, YearsAtCompany,YearsInMostRecentRole, YearsSinceLastPromotion,YearsWithCurrManager
HAVING COUNT(*) > 1;

--(performance rating)
SELECT PerformanceID, EmployeeID, ReviewDate,Environment_SatisfactionID ,Job_SatisfactionID,Relationship_SatisfactionID,
       TrainingOpportunitiesWithinYear, TrainingOpportunitiesTaken, WorkLifeBalance, Self_RatingID,
	   Manager_RatingID, COUNT(*) AS DuplicateCount
FROM PerformanceRating
GROUP BY PerformanceID, EmployeeID, ReviewDate, Environment_SatisfactionID ,Job_SatisfactionID, Relationship_SatisfactionID, 
         TrainingOpportunitiesWithinYear,TrainingOpportunitiesTaken, WorkLifeBalance, Self_RatingID, Manager_RatingID
HAVING COUNT(*) > 1;


 ---- adding [Employee_ID] fk--

 ALTER TABLE PerformanceRating
 ADD CONSTRAINT FK_employeeID
 FOREIGN KEY (EmployeeID)
 REFERENCES Employee(EmployeeID)

-- adding education levelID fk-- 

ALTER TABLE employee 
ADD CONSTRAINT fk_Employee
FOREIGN KEY (EducationlevelID)
REFERENCES EducationLevel(EducationlevelID)

-- adding [Environment_SatisfactionID] fk--

ALTER TABLE PerformanceRating
ADD CONSTRAINT fk_Environment_SatisfactionID
FOREIGN KEY (Environment_SatisfactionID)
REFERENCES RatingLevel(RatingID)

-- adding [JOB_SatisfactionID] fk--

ALTER TABLE PerformanceRating 
ADD CONSTRAINT FK_job_SatisfactionID
FOREIGN KEY (JOB_SatisfactionID)
REFERENCES RatingLevel(RatingID)

---- adding [Self_RatingID] fk--
ALTER TABLE performanceRating
ADD CONSTRAINT FK_Self_RatingID
FOREIGN KEY (Self_RatingID)
REFERENCES SatisfiedLevel(SatisfactionID)

 ---- adding [Manger_RatingID] fk--

ALTER TABLE performanceRating
ADD CONSTRAINT FK_Manger_RatingID
FOREIGN KEY (Self_RatingID)
REFERENCES SatisfiedLevel(SatisfactionID)


select * from EducationLevel
select * from Employee	
select * from RatingLevel	
select * from PerformanceRating
select * from SatisfiedLevel



SELECT distinct e.EmployeeID,[FirstName]+ ' ' + [FirstName] as[Full name] ,[Gender] ,[Age] ,[Department],
       [State] ,e.[EducationLevelID] ,[EducationField],[JobRole],[Salary],[Attrition],[YearsSinceLastPromotion],
	   [YearsAtCompany]+[YearsInMostRecentRole] as [Experince],[ReviewDate],[Environment_SatisfactionID] ,
	   [Job_SatisfactionID] , [Relationship_SatisfactionID],[Self_RatingID] , [Manager_RatingID],
       [RatingLevel] , [SatisfactionLevel] , [RatingID], [SatisfactionID],[PerformanceID],[HireDate],

CASE
    WHEN BusinessTravel='Frequent Traveller' and 
	DistanceFromHome_KM >=(select avg([DistanceFromHome_KM]) from Employee) 
	THEN Salary * 0.2
	Else 0   
	END as [Bonus Travel] ,
CASE 
    WHEN OverTime > 0 
	THEN Salary * 0.1
	Else 0 
	END AS [Bonus over Time]
FROM Employee e 
JOIN EducationLevel ED
ON e.EducationLevelID = ED.EducationLevelID
JOIN PerformanceRating PR
ON PR.EmployeeID =E.EmployeeID
JOIN RatingLevel R 
ON R.RatingID =PR.Self_RatingID
JOIN SatisfiedLevel S
ON S.SatisfactionID =Pr.Job_SatisfactionID



