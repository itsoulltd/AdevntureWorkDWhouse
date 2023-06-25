
-- Connect to AdventureWorks2022 Database
USE AdventureWorks2022;

-- 1.
SELECT TOP 10 *
FROM HumanResources.Employee e;

-- 2. Default Order is ASC
SELECT TOP 10 * 
FROM Person.Person p 
ORDER BY p.LastName;

-- 3.
SELECT TOP 10 
	firstname = p.FirstName
	, lastname = p.LastName
	, employee_id = p.BusinessEntityID
FROM Person.Person p
ORDER BY lastname;

-- 4.
SELECT TOP 10 
	productid = prdt.ProductID
	, productnumber = prdt.ProductNumber
	, productname = prdt.Name
FROM Production.Product prdt
WHERE prdt.SellStartDate IS NOT NULL
ORDER BY productname;

-- 5
/*
From the following table write a query in SQL to return all rows from the 
salesorderheader table in Adventureworks database and calculate the percentage of tax 
on the subtotal have decided. Return salesorderid, customerid, orderdate, subtotal, percentage of tax column. 
Arranged the result set in ascending order on subtotal.
-- -- --
Formula: Percentage (%) = ((Percentage_Of_Something * 100) / Out_Of_Something)
-- -- -- 
*/ 
SELECT TOP 10
	subtotal = soh.SubTotal
	,tax_percent = soh.TaxAmt * 100 / soh.SubTotal
FROM Sales.SalesOrderHeader soh
ORDER BY soh.SubTotal DESC;