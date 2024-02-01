create database IBM;
use ibm;

select * from ibm;

#1- Find the average MonthlyIncome for each JobRole.

select jobrole,round(avg(monthlyincome),1) from ibm group by 1;


#2-Identify the employees who have worked in more than two companies and have a JobSatisfaction rating greater than 3.
select employeenumber,jobsatisfaction from ibm 
where numcompaniesworked >=2 and jobsatisfaction > 3;


#3-Determine the top 5 JobRoles with the highest average MonthlyIncome.
select jobrole,avg(monthlyincome) from ibm 
group by 1 order by 2 desc limit 5;


#4-Find the employees who have the highest and lowest JobSatisfaction in each Department.
with Employee_satisfaction as (
select department,jobsatisfaction,
rank() over(partition by department order by jobsatisfaction desc)js_high,
rank() over(partition by department order by jobsatisfaction asc)js_low
from ibm)


select department,jobsatisfaction from employee_satisfaction 
where js_high =1 or js_low=1
group by 1,2;


#5-Find the JobRoles with the highest and lowest average RelationshipSatisfaction.
WITH RankedJobRoles AS (
    SELECT
        JobRole,
        AVG(RelationshipSatisfaction) AS AvgRelationshipSatisfaction,
        RANK() OVER (ORDER BY AVG(RelationshipSatisfaction) DESC) AS RankHighest,
        RANK() OVER (ORDER BY AVG(RelationshipSatisfaction) ASC) AS RankLowest
    FROM
        ibm
    GROUP BY
        JobRole
)

-- JobRole with the highest average RelationshipSatisfaction
SELECT JobRole, AvgRelationshipSatisfaction
FROM RankedJobRoles
WHERE RankHighest = 1 or RankLowest = 1;


#6-Identify the employees with the highest MonthlyIncome in each MaritalStatus category.
with cte as 
(select employeenumber,maritalstatus,monthlyincome,
rank() over(partition by maritalstatus order by monthlyincome desc) as rank_highest
from ibm)

select maritalstatus,monthlyincome from cte where rank_highest = 1
group by 1,2;


#7 -List the JobRoles where the average HourlyRate is greater than the average HourlyRate of the entire company.

SELECT JobRole
FROM ibm
GROUP BY JobRole
HAVING AVG(HourlyRate) > (
    SELECT AVG(HourlyRate)
    FROM ibm
);


#8 -Calculate the cumulative sum of MonthlyIncome for each Department ordered by YearsAtCompany.

select department,yearsatcompany,
sum(monthlyincome) over (partition by department order by yearsatcompany) as sum_of_monthlyincome
from ibm;


#9-Identify the employees who have a higher MonthlyIncome than the average MonthlyIncome of employees in the same JobRole and Department.

SELECT Employeenumber, MonthlyIncome, JobRole, Department
FROM ibm
WHERE MonthlyIncome > (
    SELECT AVG(MonthlyIncome)
    FROM ibm AS subquery
    WHERE ibm.JobRole = subquery.JobRole
    AND ibm.Department = subquery.Department
);


#10 -Find the employees who have had a promotion in the last 2 years and have a PerformanceRating greater than 3.
select employeenumber,yearssincelastpromotion,PerformanceRating
from ibm
where yearssincelastpromotion > 2 and PerformanceRating > 3
order by 2 asc;



#11-List the JobRoles where the average DistanceFromHome is less than 10 and the average JobSatisfaction is greater than 2.

SELECT JobRole,DistanceFromHome,JobSatisfaction
FROM ibm
GROUP BY JobRole,2,3
HAVING AVG(DistanceFromHome) < 10 AND AVG(JobSatisfaction) > 2;


#12-Identify the employees with the highest and lowest TotalWorkingYears in each EducationField.
WITH RankedEmployees AS (
    SELECT
        EmployeeNUMBER,
        EducationField,
        TotalWorkingYears,
        RANK() OVER (PARTITION BY EducationField ORDER BY TotalWorkingYears DESC) AS Rank_Highest,
        RANK() OVER (PARTITION BY EducationField ORDER BY TotalWorkingYears ASC) AS Rank_Lowest
    FROM
        IBM
)
SELECT
    EmployeeNUMBER,
    EducationField,
    TotalWorkingYears
FROM
    RankedEmployees
WHERE
    Rank_Highest = 1 OR Rank_Lowest = 1;

#13- Retrieve all columns for employees with "Attrition" equal to 'Yes'.
select * from ibm where attrition = "yes";


#14- Display the unique values in the "BusinessTravel" column.
select distinct(businesstravel) from ibm;


#15- Count the number of employees for each "Department."
select department,count(*) as emp_count from ibm group by department;


#16- Find the average "DailyRate" for all employees.
select avg(dailyrate)avg_daily_rate from ibm;


#17- Show the highest "MonthlyIncome" for each "Department."
select department,max(monthlyincome)max_monthly_income from ibm group by department;


#18- Get the distinct "EducationField" values in alphabetical order.
select distinct(educationfield)education_field from ibm
order by 1 asc;

#19- Calculate the total number of employees in the dataset.
select count(*)employee_count from ibm;

#20- Display employees with "DistanceFromHome" greater than 10.
select * from ibm where distancefromhome > 10;


#21- Find the minimum "HourlyRate" for each "JobRole."
select jobrole,min(hourlyrate)min_hourly_rate from ibm group by 1;

#22- Count the number of employees for each "MaritalStatus.
select maritalstatus,count(maritalstatus) from ibm group by 1;


#23- Retrieve employees with "MonthlyIncome" above the average.
select employeenumber,monthlyincome from ibm where monthlyincome > 
(select avg(monthlyincome) from ibm)
order by 2 asc;

#24- Display the "NumCompaniesWorked" for employees with "Attrition" as 'No.'
select employeenumber,numcompaniesworked from ibm where attrition = "no";


#25- Get the sum of "PercentSalaryHike" for each "JobSatisfaction" level.
select jobsatisfaction,sum(percentsalaryhike)total_percen_thike from ibm group by 1
order by 1;


#26- Find the average "TotalWorkingYears" for each "Education" level.
select education,avg(totalworkingyears)avg_total_working_years from ibm group by 1 order by 1;


#27- Count the number of employees in each "Gender."
select gender, count(employeenumber) from ibm group by 1;


#28- Retrieve employees with "OverTime" as 'Yes' and "BusinessTravel" as 'Travel_Frequently.'
select employeenumber from ibm where overtime="yes" and BusinessTravel = "Travel_Frequently";


#29- Calculate the total "MonthlyIncome" for each "MaritalStatus" and "Gender" combination.
select gender,maritalstatus,sum(monthlyincome)total_monthly_income_combined from ibm group by 1,2;


#30- Display the "PerformanceRating" for employees with "JobInvolvement" greater than 3.
select employeenumber,performancerating from ibm where jobinvolvement >3;


#31- Find the maximum "YearsAtCompany" for each "JobRole."
select jobrole,max(yearsatcompany) from ibm group by jobrole;


#32- Count the number of employees for each "WorkLifeBalance" level.
select worklifebalance,count(employeenumber)count_of_employees from ibm group by 1;


#33- Retrieve employees with "YearsSinceLastPromotion" greater than 5.
select employeenumber,YearsSinceLastPromotion from ibm where YearsSinceLastPromotion > 5;


#34- Display the average "DailyRate" for employees with "Education" greater than 2.
select round(avg(dailyrate),1)avg_daily_rate from ibm where education > 2;


#35- Find the "EmployeeNumber" for employees with the highest "MonthlyIncome."
select employeenumber,max(monthlyincome) from ibm group by 1 order by 2 desc limit 1;


#36- Calculate the total "HourlyRate" for employees with "Attrition" as 'Yes.'
select sum(hourlyrate)total_hourly_rate from ibm where attrition = "yes";


#37- Retrieve employees with "YearsInCurrentRole" less than 2 and "JobSatisfaction" less than 3.
select employeenumber,yearsincurrentrole,jobsatisfaction from ibm 
where YearsInCurrentRole < 2 and JobSatisfaction < 3;


#38- Count the number of employees for each unique "JobRole."
select distinct(jobrole),count(employeenumber)no_of_employees from ibm group by 1;


#39- Display employees with "DistanceFromHome" less than or equal to 5 or greater than 20
select employeenumber,distancefromhome from ibm where distancefromhome <=5 or distancefromhome >20;

