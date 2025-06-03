----------------------------
--LAG()
----------------------------
With SalayHistory as (
	SELECT  emp.BusinessEntityID as dept_id, emp.JobTitle, emp.Gender, emp.OrganizationLevel, emp.SalariedFlag
		, emp_pay.PayFrequency, emp_pay.Rate as per_hour_salary
	FROM HumanResources.Employee emp
		join HumanResources.EmployeePayHistory emp_pay on emp.BusinessEntityID = emp_pay.BusinessEntityID
)
SELECT  dept_id
	, JobTitle, Gender
	, per_hour_salary
	, LAG(per_hour_salary, 1, 0) over (partition by dept_id order by per_hour_salary DESC) as prev_rate
FROM SalayHistory;

-------------------------------
--SUM()
-------------------------------
With SalayHistory as (
	SELECT  emp.BusinessEntityID as dept_id, emp.JobTitle, emp.Gender, emp.OrganizationLevel, emp.SalariedFlag
		, emp_pay.PayFrequency, emp_pay.Rate as per_hour_salary
	FROM HumanResources.Employee emp
		join HumanResources.EmployeePayHistory emp_pay on emp.BusinessEntityID = emp_pay.BusinessEntityID
)
SELECT  dept_id
	, JobTitle, Gender
	, per_hour_salary
	, MAX(per_hour_salary) over (partition by dept_id order by per_hour_salary DESC) as max_dept_rate
FROM SalayHistory;

-------------------------------
--RANK()
-------------------------------
With SalayHistory as (
	SELECT  emp.BusinessEntityID as dept_id, emp.JobTitle, emp.Gender, emp.OrganizationLevel, emp.SalariedFlag
		, emp_pay.PayFrequency, emp_pay.Rate as per_hour_salary
	FROM HumanResources.Employee emp
		join HumanResources.EmployeePayHistory emp_pay on emp.BusinessEntityID = emp_pay.BusinessEntityID
)
SELECT  dept_id
	, JobTitle
	, RANK() over (partition by dept_id order by per_hour_salary DESC) as 'RANK'
	, per_hour_salary
	, Gender
FROM SalayHistory;


------------------------------
--Example of <function()> OVER (ORDER BY <Col> ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
--QA: Compute a 3-day moving sum, i.e., for each day, sum the sales from the current row and the 2 previous days.
------------------------------
SELECT SalesOrderID
	, OrderDate
	, SubTotal
	, SUM(SubTotal) OVER (ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_3_day_sum
FROM Sales.SalesOrderHeader soh
WHERE 1 = 1
	AND OrderDate BETWEEN '2011-05-31 00:00:00.000' AND '2011-08-17 00:00:00.000'
---
---
WITH Daily_SalseOrderHeader as (
	SELECT OrderDate, SUM(SubTotal) as daily_total
	FROM Sales.SalesOrderHeader
	GROUP BY OrderDate
)
SELECT OrderDate, daily_total
	, SUM(daily_total) OVER (ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_3_day_sum
FROM Daily_SalseOrderHeader
WHERE 1 = 1
	AND OrderDate BETWEEN '2011-05-31 00:00:00.000' AND '2011-08-17 00:00:00.000'
---
---
SELECT SalesOrderID, CustomerID
	, OrderDate
	, SUM(SubTotal) OVER (PARTITION BY CustomerID ORDER BY CustomerID, OrderDate) as running_total
FROM Sales.SalesOrderHeader soh
WHERE 1 = 1
	AND OrderDate BETWEEN '2011-05-31 00:00:00.000' AND '2011-08-17 00:00:00.000'
---
---


