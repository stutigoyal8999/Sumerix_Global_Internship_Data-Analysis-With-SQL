-- Ranking functions (Task 3)
-- These queries use the views created in views.sql

-- 1. ROW_NUMBER: customers numbered by total spending
SELECT ROW_NUMBER() OVER (ORDER BY TotalSpent DESC, CustomerName) AS SalesRank,
       CustomerName, Region, TotalSpent
FROM vw_CustomerSales
WHERE OrdersPlaced > 0
ORDER BY SalesRank
LIMIT 10;

-- 2. ROW_NUMBER, RANK and DENSE_RANK side by side: customers by number of orders
SELECT CustomerName, OrdersPlaced,
       ROW_NUMBER() OVER (ORDER BY OrdersPlaced DESC, CustomerName) AS RowNum,
       RANK() OVER (ORDER BY OrdersPlaced DESC) AS Rnk,
       DENSE_RANK() OVER (ORDER BY OrdersPlaced DESC) AS DenseRnk
FROM vw_CustomerSales
WHERE OrdersPlaced > 0
ORDER BY OrdersPlaced DESC, CustomerName
LIMIT 10;

-- 3. RANK: products ranked by revenue (the PDF example, using the view)
SELECT ProductName, Revenue,
       RANK() OVER (ORDER BY Revenue DESC) AS ProductRank
FROM vw_ProductSales
ORDER BY ProductRank
LIMIT 10;

-- 4. RANK and DENSE_RANK with ties: products ranked by units sold
SELECT ProductName, UnitsSold,
       RANK() OVER (ORDER BY UnitsSold DESC) AS Rnk,
       DENSE_RANK() OVER (ORDER BY UnitsSold DESC) AS DenseRnk
FROM vw_ProductSales
ORDER BY UnitsSold DESC, ProductName
LIMIT 10;

-- 5. ROW_NUMBER with PARTITION BY: the best 2 products in every category
WITH RankedProducts AS (
    SELECT CategoryName, ProductName, Revenue,
           ROW_NUMBER() OVER (PARTITION BY CategoryName ORDER BY Revenue DESC, ProductName) AS CategoryRank
    FROM vw_ProductSales
)
SELECT CategoryName, CategoryRank, ProductName, Revenue
FROM RankedProducts
WHERE CategoryRank <= 2
ORDER BY CategoryName, CategoryRank;

-- 6. NTILE(4): customers split into spending quartiles (1 = top 25 percent)
SELECT CustomerName, TotalSpent,
       NTILE(4) OVER (ORDER BY TotalSpent DESC) AS SpendingQuartile
FROM vw_CustomerSales
WHERE OrdersPlaced > 0
ORDER BY TotalSpent DESC;

-- 7. NTILE(3): products grouped into high, medium and low revenue thirds
SELECT ProductName, Revenue,
       NTILE(3) OVER (ORDER BY Revenue DESC) AS RevenueGroup
FROM vw_ProductSales
ORDER BY Revenue DESC;

-- 8. Sales ranking: months ranked by revenue
SELECT Month, Revenue,
       RANK() OVER (ORDER BY Revenue DESC) AS RevenueRank
FROM vw_MonthlySales
ORDER BY RevenueRank;

-- 9. Employee performance: employees ranked by sales within each year
SELECT strftime('%Y', ot.OrderDate) AS SalesYear,
       e.EmployeeName,
       SUM(ot.OrderTotal) AS Sales,
       RANK() OVER (
           PARTITION BY strftime('%Y', ot.OrderDate)
           ORDER BY SUM(ot.OrderTotal) DESC
       ) AS YearRank
FROM vw_OrderTotals ot
INNER JOIN Employees e ON ot.EmployeeID = e.EmployeeID
GROUP BY strftime('%Y', ot.OrderDate), e.EmployeeID, e.EmployeeName
ORDER BY SalesYear, YearRank;

-- 10. Regions ranked by revenue within each year
SELECT SalesYear, Region, Revenue,
       DENSE_RANK() OVER (PARTITION BY SalesYear ORDER BY Revenue DESC) AS RegionRank
FROM vw_RegionalSales
ORDER BY SalesYear, RegionRank;