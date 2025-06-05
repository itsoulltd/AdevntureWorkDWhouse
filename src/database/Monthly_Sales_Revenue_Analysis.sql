
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