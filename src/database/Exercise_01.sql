
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

/*
-- 5
From the following table write a query in SQL to return all rows from the 
salesorderheader table in Adventureworks database and calculate the percentage of tax 
on the subtotal have decided. Return salesorderid, customerid, orderdate, subtotal, percentage of tax column. 
Arranged the result set in ascending order on subtotal.
-- -- --
Formula: Percentage (%) = ((Percentage_Of_Something * 100) / Out_Of_Something)
-- -- -- 
*/ 
SELECT TOP 10
	subtotal = ROUND(soh.SubTotal, 2)
	,tax_percent = ROUND(soh.TaxAmt * 100 / soh.SubTotal, 2)
FROM Sales.SalesOrderHeader soh
ORDER BY soh.SubTotal DESC;

/*
-- 6
 From the following table write a query in SQL to create a list of unique jobtitles in the employee table in Adventureworks database. 
 Return jobtitle column and arranged the resultset in ascending order. 
*/
SELECT DISTINCT -- TOP 10
	jobtitle = e.JobTitle
FROM HumanResources.Employee e
ORDER BY jobtitle;

/*
-- 7
From the following table write a query in SQL to calculate the total freight paid by each customer. 
Return customerid and total freight. Sort the output in ascending order on customerid. 
*/
SELECT TOP 10
	customerid = soh.CustomerID
	, total_paid_freight = ROUND(SUM(soh.Freight), 2)
FROM Sales.SalesOrderHeader soh
GROUP BY soh.CustomerID
ORDER BY soh.CustomerID;

/*
-- 8
From the following table write a query in SQL to find the average and the sum of the subtotal for every customer. 
Return customerid, average and sum of the subtotal. 
Grouped the result on customerid and salespersonid. 
Sort the result on customerid column in descending order.
*/
SELECT TOP 10
	customerid = soh.CustomerID
	, sales_person_id = soh.SalesPersonID
	, avg_subtotal = ROUND(AVG(soh.SubTotal), 2)
	, total_subtotal = ROUND(SUM(soh.SubTotal), 2)
FROM Sales.SalesOrderHeader soh
GROUP BY soh.CustomerID, soh.SalesPersonID
ORDER BY soh.CustomerID DESC;

/*
-- 9 From the following table write a query in SQL to retrieve total quantity of each productid 
which are in shelf of 'A' or 'C' or 'H'. Filter the results for sum quantity is more than 500. 
Return productid and sum of the quantity. 
Sort the results according to the productid in ascending order.
*/
SELECT TOP 10
	productid = proivt.ProductID
	, total_quantity = SUM(proivt.Quantity)
FROM Production.ProductInventory proivt
WHERE 1 = 1
	AND proivt.Shelf IN ('A', 'C', 'H') 
GROUP BY proivt.ProductID
HAVING SUM(proivt.Quantity) > 500
ORDER BY proivt.ProductID;

-- Alternative with dynamic var example--
DECLARE @thrash_hold Int = 500
DECLARE @shelf_items table (id char)
INSERT @shelf_items(id) values ('A'), ('C'), ('H') 

SELECT TOP 10
	productid = proivt.ProductID
	, total_quantity = SUM(proivt.Quantity)
FROM Production.ProductInventory proivt
WHERE 1 = 1 
	AND proivt.Shelf IN (SELECT id from @shelf_items) 
GROUP BY proivt.ProductID
HAVING SUM(proivt.Quantity) > @thrash_hold
ORDER BY proivt.ProductID;
-- -- --

/*
-- 10
From the following table write a query in SQL to find the total quentity for a group of locationid multiplied by 10. 
*/
SELECT TOP 20
	total_quantity = SUM(proinv.Quantity)
FROM Production.ProductInventory proinv
GROUP BY proinv.LocationID * 10;
--ORDER BY proinv.LocationID;

/*
-- 11
From the following tables write a query in SQL to find the persons whose last name starts with letter 'L'. 
Return BusinessEntityID, FirstName, LastName, and PhoneNumber. 
Sort the result on lastname and firstname.
*/
SELECT TOP 20
	businessentityid = per.BusinessEntityID
	, firstname = per.FirstName
	, lastname = per.LastName
	, person_phone = perphn.PhoneNumber
FROM Person.Person per
INNER JOIN Person.PersonPhone perphn
ON per.BusinessEntityID = perphn.BusinessEntityID
WHERE 1 = 1
	AND per.LastName like 'L%'
ORDER BY per.LastName, per.FirstName;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;

/*
-- 7
*/
SELECT TOP 10
	*
FROM A_Table
ORDER BY A_Column;