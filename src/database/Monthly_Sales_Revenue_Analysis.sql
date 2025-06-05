
SELECT TOP(10) *
FROM Sales.SalesOrderHeader;

SELECT TOP(10) *
FROM Sales.SalesOrderDetail;

SELECT TOP(10) * 
FROM Production.Product;

--------------------------------------------------------
--Top Product by Revenue for the month of June, 2011
--------------------------------------------------------

WITH Product_Sales AS (
	SELECT product.ProductID
		, product.Name
		, SUM(soHeader.SubTotal) as Revenue
	FROM Sales.SalesOrderHeader soHeader
	join Sales.SalesOrderDetail soDetail on soHeader.SalesOrderID = soDetail.SalesOrderID
	join Production.Product product on soDetail.ProductID = product.ProductID
	WHERE 1=1
		AND soHeader.OrderDate between '2011-06-01 00:00:00.000' AND '2011-06-30 00:00:00.000'
	GROUP BY product.ProductID, product.Name
)
SELECT 
	RANK() OVER (order by Revenue DESC) as Ranking
	, ProductID, Name, Revenue
FROM Product_Sales;

--------------------------------------------------------
--Top Product by Territory for the month of June, 2011
--------------------------------------------------------

WITH Product_Sales AS (
	SELECT soHeader.TerritoryID
		, product.ProductID
		, product.Name
		, SUM(soHeader.SubTotal) as Revenue
	FROM Sales.SalesOrderHeader soHeader
	join Sales.SalesOrderDetail soDetail on soHeader.SalesOrderID = soDetail.SalesOrderID
	join Production.Product product on soDetail.ProductID = product.ProductID
	WHERE 1=1
		AND soHeader.OrderDate between '2011-06-01 00:00:00.000' AND '2011-06-30 00:00:00.000'
	GROUP BY soHeader.TerritoryID, product.ProductID, product.Name
)
SELECT TerritoryID
	, ProductID, Name
	, Revenue
	, RANK() OVER (partition by TerritoryID order by Revenue DESC) as Ranking
FROM Product_Sales;

---------------------------------------------------------
--Show only the TOP product for each Territory
---------------------------------------------------------

WITH Product_Sales AS (
	SELECT soHeader.TerritoryID
		, product.ProductID
		, product.Name
		, SUM(soHeader.SubTotal) as Revenue
	FROM Sales.SalesOrderHeader soHeader
	join Sales.SalesOrderDetail soDetail on soHeader.SalesOrderID = soDetail.SalesOrderID
	join Production.Product product on soDetail.ProductID = product.ProductID
	WHERE 1=1
		AND soHeader.OrderDate between '2011-06-01 00:00:00.000' AND '2011-06-30 00:00:00.000'
	GROUP BY soHeader.TerritoryID, product.ProductID, product.Name
), 
Product_Sales_Top_By_Territory AS (
	SELECT TerritoryID
		, ProductID, Name
		, Revenue
		, RANK() OVER (partition by TerritoryID order by Revenue DESC) as Ranking
	FROM Product_Sales
)
SELECT * FROM Product_Sales_Top_By_Territory
	WHERE Ranking = 1;

------------------------------------------------------------

WITH Product_Sales AS (
	SELECT soHeader.TerritoryID
		, product.ProductID
		, product.Name
		, SUM(soHeader.SubTotal) as Revenue
	FROM Sales.SalesOrderHeader soHeader
	join Sales.SalesOrderDetail soDetail on soHeader.SalesOrderID = soDetail.SalesOrderID
	join Production.Product product on soDetail.ProductID = product.ProductID
	WHERE 1=1
		AND soHeader.OrderDate between '2011-06-01 00:00:00.000' AND '2011-06-30 00:00:00.000'
	GROUP BY soHeader.TerritoryID, product.ProductID, product.Name
), 
Product_Sales_Top_By_Territory AS (
	SELECT TerritoryID, ProductID, Name
		, Revenue
		, RANK() OVER (partition by TerritoryID order by Revenue DESC) as Ranking
	FROM Product_Sales
)
SELECT * FROM Product_Sales_Top_By_Territory
	WHERE Ranking between 1 and 2
	Order By Revenue DESC;

------------------------------------------------------------
--Top 5 customer by total spent
------------------------------------------------------------

WIth Customer_Total_Spent AS (
	SELECT TOP(5)
		CustomerID
		, sum(SubTotal) as total_spent
	FROM Sales.SalesOrderHeader
	WHERE Status = 5
	GROUP BY CustomerID
	ORDER BY total_spent DESC
)
SELECT c.CustomerID
	, c.AccountNumber
	, CONCAT(p.FirstName, ' ', p.LastName) as Name
	, ctp.total_spent as Total_Spent
FROM Customer_Total_Spent as ctp
JOIN Sales.Customer as c on ctp.CustomerID=c.CustomerID
JOIN Person.Person as p on c.PersonID=p.BusinessEntityID

--------------------------------------------------------
--TOP 5 product by qty
--------------------------------------------------------
-- Almost similar

--------------------------------------------------------
--How many customer have made more than one order?
--------------------------------------------------------
WITH Customer_Many_Order AS (
	SELECT CustomerID, COUNT(SalesOrderID) as Order_COUNT
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID
	HAVING COUNT(SalesOrderID) > 1
)
SELECT COUNT(*) FROM Customer_Many_Order;
-------------------------------------------------------

-------------------------------------------------------
--Month-over-Month (MoM) revenue growth
-------------------------------------------------------
WITH Orders_By_Month AS (
	SELECT 
		DATETRUNC(month, OrderDate) AS order_month
		, SubTotal
	FROM Sales.SalesOrderHeader
	WHERE OrderDate between '2011-01-01 00:00:00.000' and '2011-12-31 00:00:00.000'
),
Revenue_By_Month AS (
	SELECT 
		order_month as 'month'
		, SUM(SubTotal) as revenue
	FROM Orders_By_Month
	GROUP BY order_month
),
Month_By_Month AS (
	SELECT 
		month
		, revenue as curr_revenue
		, LAG(revenue, 1, 0) OVER (ORDER BY month) as prev_revenue
	FROM Revenue_By_Month
)
SELECT 
	month
	, curr_revenue
	, prev_revenue
	, ROUND(((curr_revenue - prev_revenue) * 100.0) / NULLIF(prev_revenue, 0), 2) AS MoM_Growth
FROM Month_By_Month;

---------------------------------------------------------
--SELECT 1/NULLIF(0, 0);
-- NULLIF(expression1, expression2)
-- Returns NULL IF (expression1 = expression2) ELSE expression1
---------------------------------------------------------
--SELECT MIN(DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)) as This_Month
-- returns as of '2025-06-01'
---------------------------------------------------------
--SELECT DATEDIFF(MONTH, '2025-01-01', '2025-06-01') as DIFF_IN_MONTH
-- returns 5
---------------------------------------------------------

