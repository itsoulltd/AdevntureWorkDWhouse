
With SalayHistory as (
	SELECT  emp.BusinessEntityID as id, emp.JobTitle, emp.Gender, emp.OrganizationLevel, emp.SalariedFlag
		, emp_pay.PayFrequency, emp_pay.Rate as per_hour_salary
	FROM HumanResources.Employee emp
		join HumanResources.EmployeePayHistory emp_pay on emp.BusinessEntityID = emp_pay.BusinessEntityID
)
SELECT  id
	, JobTitle, Gender
	, per_hour_salary
	, LAG(per_hour_salary, 1, 0) over (partition by id order by per_hour_salary DESC) as prev_rate
FROM SalayHistory;


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


