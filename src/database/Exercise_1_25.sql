
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
-- 12 GROUP BY ROLLUP
From the following table write a query in SQL to find the sum of subtotal column. 
Group the sum on distinct salespersonid and customerid. 
Rolls up the results into subtotal and running total.
Return salespersonid, customerid and sum of subtotal column i.e. sum_subtotal.
*/
SELECT TOP 1000
	salespersonid = soh.SalesPersonID
	, customerid = soh.CustomerID
	, sum_subtotal = ROUND(SUM(soh.SubTotal), 2)
FROM Sales.SalesOrderHeader soh
GROUP BY ROLLUP(soh.SalesPersonID, soh.CustomerID)
ORDER BY soh.SalesPersonID DESC;

/*
-- 13 GROUP BY CUBE
From the following table write a query in SQL to find 
the sum of the quantity of all combination of group of distinct locationid and shelf column. 
Return locationid, shelf and sum of quantity as TotalQuantity.
*/
SELECT TOP 100
	locationid = LocationID
	, shelf = Shelf
	, totalquantity = SUM(Quantity)
FROM Production.ProductInventory
GROUP BY CUBE (LocationID, Shelf)
--ORDER BY Shelf, LocationID;

/*
-- 14 
From the following table write a query in SQL to find the sum of the quantity with subtotal for each locationid. 
Group the results for all combination of distinct locationid and shelf column. 
Rolls up the results into subtotal and running total. Return locationid, shelf and sum of quantity as TotalQuantity. 
*/
SELECT TOP 100
	locationid = LocationID
	, shelf = Shelf
	, totalquantity = SUM(Quantity)
FROM Production.ProductInventory
GROUP BY ROLLUP (LocationID, Shelf)
UNION ALL
SELECT TOP 100
	locationid = LocationID
	, shelf = Shelf
	, totalquantity = SUM(Quantity)
FROM Production.ProductInventory
GROUP BY CUBE (LocationID, Shelf)

/*
-- 15
From the following table write a query in SQL 
to find the total quantity for each locationid and calculate the grand-total for all locations.
Return locationid and total quantity. 
Group the results on locationid. 
*/
SELECT TOP 100
	locationid  = LocationID
	, total_quantity = SUM(Quantity)
FROM Production.ProductInventory
GROUP BY ROLLUP(LocationID)
--ORDER BY A_Column;

/*
-- 16
From the following table write a query in SQL to retrieve the number of employees for each City. 
Return city and number of employees. Sort the result in ascending order on city.
*/
SELECT TOP 20
	city = a.City
	, noofemployees = COUNT(bea.BusinessEntityID)
FROM Person.BusinessEntityAddress bea
INNER JOIN Person.Address a ON bea.AddressID = a.AddressID 
GROUP BY a.City
ORDER BY a.City;

/*
-- 17
From the following table write a query in SQL to retrieve the total sales for each year. 
Return the year part of order date and total due amount. Sort the result in ascending order on year part of order date. 
*/
SELECT TOP 10
	'Year' = YEAR(orderdate)
	, 'Order Amount' = ROUND(SUM(totaldue), 2)
FROM Sales.SalesOrderHeader
GROUP BY YEAR(orderdate)
ORDER BY YEAR(OrderDate);

/*
-- 18
From the following table write a query in SQL to retrieve the total sales for each year. 
Filter the result set for those orders where order year is on or before 2016. Return the year part of orderdate and total due amount. 
Sort the result in ascending order on year part of order date. 
*/
SELECT TOP 10
	'yearoforderdate' = YEAR(orderdate)
	, 'totaldueorder' = ROUND(SUM(totaldue), 2)
FROM Sales.SalesOrderHeader
GROUP BY YEAR(orderdate)
HAVING YEAR(orderdate) <= '2016'
ORDER BY YEAR(OrderDate);

/*
-- 19
From the following table write a query in SQL to find the contacts who are designated as a manager in various departments. 
Returns ContactTypeID, name.
Sort the result set in descending order.
*/
SELECT TOP 10
	contacttypeid = ContactTypeID
	, 'name' = Name
FROM Person.ContactType
WHERE 1=1
	AND Name LIKE '%Manager%'
ORDER BY Name DESC;

/*
-- 20
From the following tables write a query in SQL to make a list of contacts who are designated as 'Purchasing Manager'. 
Return BusinessEntityID, LastName, and FirstName columns. 
Sort the result set in ascending order of LastName, and FirstName.
*/
SELECT TOP 100
	businessentityid = bec.BusinessEntityID
	, lastname = p.LastName
	, firstname = p.FirstName
FROM Person.BusinessEntityContact bec
INNER JOIN Person.ContactType ct ON bec.ContactTypeID = ct.ContactTypeID
INNER JOIN Person.Person p ON bec.PersonID = p.BusinessEntityID
WHERE 1=1
	AND ct.Name = 'Purchasing Manager'
ORDER BY lastname, firstname;

-- alternative

SELECT TOP 100
	businessentityid = bec.BusinessEntityID
	, lastname = p.LastName
	, firstname = p.FirstName
FROM Person.BusinessEntityContact bec
INNER JOIN Person.Person p ON bec.PersonID = p.BusinessEntityID
WHERE 1=1
	AND bec.ContactTypeID = (SELECT ct.ContactTypeID FROM Person.ContactType ct WHERE ct.Name = 'Purchasing Manager')
ORDER BY lastname, firstname;

--SELECT * FROM Person.ContactType where Name = 'Purchasing Manager'
--SELECT * FROM Person.BusinessEntityContact 
--WHERE ContactTypeID = (SELECT ct.ContactTypeID FROM Person.ContactType ct WHERE ct.Name = 'Purchasing Manager')


/*
-- 21 Example Of OVER and WINDOW function
From the following tables write a query in SQL to retrieve the salesperson for each PostalCode who belongs to a territory and SalesYTD is not zero. 
Return row numbers of each group of PostalCode, last name, salesytd, postalcode column. 
Sort the salesytd of each postalcode group in descending order. 
Shorts the postalcode in ascending order.
*/
SELECT TOP 10
	'Row Number' = ROW_NUMBER() OVER (PARTITION BY adds.PostalCode ORDER BY sp.SalesYTD DESC)
	, lastname = p.LastName
	, salesytd = sp.SalesYTD 
	, postcode = adds.PostalCode
FROM Sales.SalesPerson sp
INNER JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
INNER JOIN Person.Address adds on sp.BusinessEntityID = adds.AddressID
WHERE 1=1
	AND sp.TerritoryID IS NOT NULL
	AND sp.SalesYTD <> 0
ORDER BY adds.PostalCode;

-- Alternative syntax

SELECT TOP 100
	'Row Number' = ROW_NUMBER() OVER win_finc
	, lastname = p.LastName
	, salesytd = sp.SalesYTD 
	, postcode = adds.PostalCode
FROM Sales.SalesPerson sp
	INNER JOIN Person.Person p 
		ON sp.BusinessEntityID = p.BusinessEntityID
	INNER JOIN Person.Address adds 
		ON sp.BusinessEntityID = adds.AddressID
WHERE 1=1
	AND sp.TerritoryID IS NOT NULL
	AND sp.SalesYTD <> 0
WINDOW win_finc AS (PARTITION BY adds.PostalCode ORDER BY sp.SalesYTD DESC)
ORDER BY adds.PostalCode;

/*Select TOP 10 * From Sales.SalesPerson;
Select TOP 10 * From Person.Person;
Select TOP 10 * From Person.Address;*/

/*SELECT SalesOrderID, ProductID, OrderQty
    ,SUM(OrderQty) OVER win AS Total
    ,AVG(OrderQty) OVER win AS "Avg"
    ,COUNT(OrderQty) OVER win AS "Count"
    ,MIN(OrderQty) OVER win AS "Min"
    ,MAX(OrderQty) OVER win AS "Max"
FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664)
WINDOW win AS (PARTITION BY SalesOrderID ORDER BY ProductID);*/

/*
-- 22
From the following table write a query in SQL to count the number of contacts for combination of each type and name. 
Filter the output for those who have 100 or more contacts. Return ContactTypeID and ContactTypeName and BusinessEntityContact. 
Sort the result set in descending order on number of contacts.
*/
SELECT TOP 100
	contacttypeid = ct.ContactTypeID
	, ctypename = ct.Name
	, nocontacts = COUNT(bec.BusinessEntityID)
FROM Person.ContactType ct
	INNER JOIN Person.BusinessEntityContact bec 
		ON ct.ContactTypeID = bec.ContactTypeID
GROUP BY ct.ContactTypeID, ct.Name
HAVING COUNT(bec.BusinessEntityID) >= 100
ORDER BY nocontacts DESC;

/*
-- 23
From the following table write a query in SQL to retrieve the RateChangeDate, 
full name (first name, middle name and last name) and weekly salary (40 hours in a week) of employees. 
In the output the RateChangeDate should appears in date format. 
Sort the output in ascending order on NameInFull. 
*/
-- DateFormatCode 104 = DD.MM.YY
-- DateFormatCode 105 = DD-MM-YY
SELECT TOP 100
	fromdate = CONVERT(varchar, eph.RateChangeDate, 104) -- CAST(eh.RateChangeDate as VARCHAR(10))
	, nameinfull = CONCAT(p.LastName, ',', p.FirstName, ' ', p.MiddleName)
	, salaryinaweek = (eph.Rate * 40)
FROM Person.Person p
	INNER JOIN HumanResources.EmployeePayHistory eph
		ON p.BusinessEntityID = eph.BusinessEntityID
ORDER BY nameinfull;


/*
-- 24
From the following tables write a query in SQL to calculate and display the latest weekly salary of each employee.
Return RateChangeDate, full name (first name, middle name and last name) 
and weekly salary (40 hours in a week) of employees Sort the output in ascending order on NameInFull.
*/
SELECT TOP 100
	p.BusinessEntityID
	, fromdate = CONVERT(varchar, eph.RateChangeDate, 104)
	, nameinfull = CONCAT(p.LastName, ',', p.FirstName, ' ', p.MiddleName)
	, salaryinaweek = (eph.Rate * 40)
FROM Person.Person p
	INNER JOIN HumanResources.EmployeePayHistory eph
		ON p.BusinessEntityID = eph.BusinessEntityID
WHERE eph.RateChangeDate = (SELECT MAX(RateChangeDate) 
							FROM HumanResources.EmployeePayHistory 
							WHERE BusinessEntityID = eph.BusinessEntityID)
ORDER BY nameinfull;

-- Alternative with CTEs (Common Table Expression)

WITH MAX_RateChangeDate AS (
	SELECT BusinessEntityID As entityID, MAX(RateChangeDate) As max_rate_change_date
	FROM HumanResources.EmployeePayHistory 
	GROUP BY BusinessEntityID
)
SELECT TOP 100
	p.BusinessEntityID
	, fromdate = CONVERT(varchar, eph.RateChangeDate, 104)
	, nameinfull = CONCAT(p.LastName, ',', p.FirstName, ' ', p.MiddleName)
	, salaryinaweek = (eph.Rate * 40)
FROM Person.Person p
	INNER JOIN HumanResources.EmployeePayHistory eph
		ON p.BusinessEntityID = eph.BusinessEntityID
	INNER JOIN MAX_RateChangeDate max_rcd
		ON eph.BusinessEntityID = max_rcd.entityID
ORDER BY nameinfull;


/*
-- 25
From the following table write a query in SQL to find the sum, average, count, minimum, and maximum order quentity 
for those orders whose id are 43659 and 43664. 
Return SalesOrderID, ProductID, OrderQty, sum, average, count, max, and min order quantity. 
*/
SELECT TOP 100
	SalesOrderID
	, ProductID
	, OrderQty
	, 'Total Quantity' = SUM(OrderQty) OVER win_func
	, 'Avg Quantity' = AVG(OrderQty) OVER win_func
	, 'No of Orders' = COUNT(OrderQty) OVER win_func
	, 'Min Quantity' = MIN(OrderQty) OVER win_func
	, 'Max Quantity' = MAX(OrderQty) OVER win_func
FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN (43659, 43664)
WINDOW win_func AS (PARTITION BY SalesOrderID);

-- END OF LINE --