-- Analytical reports (Task 3)
-- These queries use the views created in views.sql

-- 1. Executive KPI summary: one row with the headline numbers
SELECT (SELECT SUM(OrderTotal) FROM vw_OrderTotals) AS TotalRevenue,
       (SELECT COUNT(*) FROM vw_OrderTotals) AS TotalOrders,
       (SELECT COUNT(*) FROM vw_CustomerSales WHERE OrdersPlaced > 0) AS ActiveCustomers,
       (SELECT ROUND(AVG(OrderTotal), 2) FROM vw_OrderTotals) AS AvgOrderValue,
       (SELECT ProductName FROM vw_ProductSales ORDER BY Revenue DESC LIMIT 1) AS TopProduct,
       (SELECT CustomerName FROM vw_CustomerSales ORDER BY TotalSpent DESC LIMIT 1) AS TopCustomer;

-- 2. Top 10 percent of customers by revenue (decile 1 of NTILE(10))
WITH CustomerDeciles AS (
    SELECT CustomerName, Region, TotalSpent,
           NTILE(10) OVER (ORDER BY TotalSpent DESC) AS Decile
    FROM vw_CustomerSales
    WHERE OrdersPlaced > 0
)
SELECT CustomerName, Region, TotalSpent,
       ROUND(TotalSpent * 100.0 / (SELECT SUM(TotalSpent) FROM CustomerDeciles), 1) AS ShareOfRevenue
FROM CustomerDeciles
WHERE Decile = 1
ORDER BY TotalSpent DESC;

-- 3. Month-over-month growth using the previous calendar month
-- A month with no sales in the month before it shows NULL growth
WITH Monthly AS (
    SELECT Month, Revenue FROM vw_MonthlySales
)
SELECT m.Month, m.Revenue,
       p.Revenue AS PreviousMonthRevenue,
       ROUND((m.Revenue - p.Revenue) * 100.0 / p.Revenue, 1) AS GrowthPercent
FROM Monthly m
LEFT JOIN Monthly p ON p.Month = strftime('%Y-%m', date(m.Month || '-01', '-1 month'))
ORDER BY m.Month;

-- 4. Year-over-year growth: each month against the same month a year earlier
WITH Monthly AS (
    SELECT Month, Revenue FROM vw_MonthlySales
)
SELECT m.Month, m.Revenue,
       p.Month AS SameMonthLastYear,
       p.Revenue AS LastYearRevenue,
       ROUND((m.Revenue - p.Revenue) * 100.0 / p.Revenue, 1) AS YoYGrowthPercent
FROM Monthly m
INNER JOIN Monthly p ON p.Month = strftime('%Y-%m', date(m.Month || '-01', '-1 year'))
ORDER BY m.Month;

-- 5. Year-over-year for the comparable period (July to October of each year)
SELECT strftime('%Y', OrderDate) AS SalesYear,
       COUNT(*) AS Orders,
       SUM(OrderTotal) AS Revenue,
       ROUND(SUM(OrderTotal) * 100.0 / LAG(SUM(OrderTotal)) OVER (ORDER BY strftime('%Y', OrderDate)) - 100, 1) AS GrowthPercent
FROM vw_OrderTotals
WHERE CAST(strftime('%m', OrderDate) AS INTEGER) BETWEEN 7 AND 10
GROUP BY strftime('%Y', OrderDate)
ORDER BY SalesYear;

-- 6. Running revenue dashboard dataset: one row per month with every trend measure
WITH Monthly AS (
    SELECT Month, Orders, Revenue FROM vw_MonthlySales
)
SELECT m.Month, m.Orders, m.Revenue,
       SUM(m.Revenue) OVER (ORDER BY m.Month) AS RunningRevenue,
       ROUND(SUM(m.Revenue) OVER (ORDER BY m.Month) * 100.0 / SUM(m.Revenue) OVER (), 1) AS CumulativePercent,
       ROUND(AVG(m.Revenue) OVER (ORDER BY m.Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS MovingAvg3,
       ROUND((m.Revenue - p.Revenue) * 100.0 / p.Revenue, 1) AS MoMGrowthPercent
FROM Monthly m
LEFT JOIN Monthly p ON p.Month = strftime('%Y-%m', date(m.Month || '-01', '-1 month'))
ORDER BY m.Month;

-- 7. Top-N: the 5 best products with cumulative share of revenue
SELECT ProductName, CategoryName, Revenue,
       ROUND(Revenue * 100.0 / SUM(Revenue) OVER (), 1) AS SharePercent,
       ROUND(SUM(Revenue) OVER (ORDER BY Revenue DESC) * 100.0 / SUM(Revenue) OVER (), 1) AS CumulativePercent
FROM vw_ProductSales
ORDER BY Revenue DESC
LIMIT 5;

-- 8. Top-N per group: the best customer in every region
WITH RegionCustomers AS (
    SELECT Region, CustomerName, TotalSpent,
           ROW_NUMBER() OVER (PARTITION BY Region ORDER BY TotalSpent DESC, CustomerName) AS RegionRank
    FROM vw_CustomerSales
    WHERE OrdersPlaced > 0
)
SELECT Region, CustomerName, TotalSpent
FROM RegionCustomers
WHERE RegionRank = 1
ORDER BY TotalSpent DESC;

-- 9. Bottom-N: the 5 weakest products that still sold
SELECT ProductName, CategoryName, UnitsSold, Revenue
FROM vw_ProductSales
WHERE Revenue > 0
ORDER BY Revenue ASC, ProductName
LIMIT 5;

-- 10. Bottom-N: products with no sales at all
SELECT ProductName, CategoryName, Price, 'No sales recorded' AS Status
FROM vw_ProductSales
WHERE UnitsSold = 0;

-- 11. Products that consistently rank among the top 5 in monthly revenue
WITH ProductMonth AS (
    SELECT p.ProductName, ot.OrderMonth AS Month,
           SUM(od.Quantity * od.UnitPrice) AS Revenue
    FROM Order_Details od
    INNER JOIN vw_OrderTotals ot ON od.OrderID = ot.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY p.ProductName, ot.OrderMonth
),
Ranked AS (
    SELECT ProductName, Month, Revenue,
           RANK() OVER (PARTITION BY Month ORDER BY Revenue DESC) AS MonthlyRank
    FROM ProductMonth
)
SELECT ProductName,
       COUNT(*) AS MonthsInTop5,
       (SELECT COUNT(DISTINCT Month) FROM ProductMonth) AS MonthsTracked
FROM Ranked
WHERE MonthlyRank <= 5
GROUP BY ProductName
ORDER BY MonthsInTop5 DESC, ProductName
LIMIT 8;

-- 12. Regions with declining sales: July to October 2026 against July to October 2025
WITH RegionPeriod AS (
    SELECT c.Region,
           SUM(CASE WHEN strftime('%Y', ot.OrderDate) = '2025' THEN ot.OrderTotal ELSE 0 END) AS Sales2025,
           SUM(CASE WHEN strftime('%Y', ot.OrderDate) = '2026' THEN ot.OrderTotal ELSE 0 END) AS Sales2026
    FROM vw_OrderTotals ot
    INNER JOIN Customers c ON ot.CustomerID = c.CustomerID
    WHERE CAST(strftime('%m', ot.OrderDate) AS INTEGER) BETWEEN 7 AND 10
    GROUP BY c.Region
)
SELECT Region, Sales2025, Sales2026,
       Sales2026 - Sales2025 AS Change,
       ROUND((Sales2026 - Sales2025) * 100.0 / Sales2025, 1) AS ChangePercent,
       CASE WHEN Sales2026 < Sales2025 THEN 'Declining' ELSE 'Growing' END AS Trend
FROM RegionPeriod
ORDER BY ChangePercent;

-- 13. Customer segmentation based on spending and frequency
WITH Scored AS (
    SELECT CustomerName, OrdersPlaced, TotalSpent,
           NTILE(4) OVER (ORDER BY TotalSpent DESC) AS SpendQuartile
    FROM vw_CustomerSales
    WHERE OrdersPlaced > 0
),
Segmented AS (
    SELECT CustomerName, OrdersPlaced, TotalSpent,
           CASE
               WHEN SpendQuartile = 1 THEN 'VIP'
               WHEN OrdersPlaced >= 3 THEN 'Loyal'
               WHEN TotalSpent >= 20000 THEN 'Growing'
               ELSE 'Occasional'
           END AS Segment
    FROM Scored
)
SELECT Segment,
       COUNT(*) AS Customers,
       SUM(TotalSpent) AS Revenue,
       ROUND(AVG(TotalSpent), 0) AS AvgSpend,
       ROUND(AVG(OrdersPlaced), 1) AS AvgOrders
FROM Segmented
GROUP BY Segment
ORDER BY Revenue DESC;

-- 14. Customer lifetime analysis: value, lifespan and ordering rhythm
SELECT CustomerName, OrdersPlaced, TotalSpent AS LifetimeValue,
       FirstOrderDate, LastOrderDate,
       CAST(julianday(LastOrderDate) - julianday(FirstOrderDate) AS INTEGER) AS LifespanDays,
       ROUND(TotalSpent * 1.0 / OrdersPlaced, 0) AS AvgOrderValue,
       CASE WHEN OrdersPlaced > 1
            THEN CAST((julianday(LastOrderDate) - julianday(FirstOrderDate)) / (OrdersPlaced - 1) AS INTEGER)
       END AS AvgDaysBetweenOrders
FROM vw_CustomerSales
WHERE OrdersPlaced > 0
ORDER BY TotalSpent DESC
LIMIT 10;

-- 15. Product performance analysis with ABC classification by cumulative revenue
WITH ProductShare AS (
    SELECT ProductName, CategoryName, UnitsSold, Revenue,
           ROUND(Revenue * 100.0 / SUM(Revenue) OVER (), 1) AS SharePercent,
           SUM(Revenue) OVER (ORDER BY Revenue DESC, ProductName) * 100.0 / SUM(Revenue) OVER () AS CumulativePercent
    FROM vw_ProductSales
    WHERE Revenue > 0
)
SELECT ProductName, CategoryName, UnitsSold, Revenue, SharePercent,
       ROUND(CumulativePercent, 1) AS CumulativePercent,
       CASE
           WHEN CumulativePercent <= 70 THEN 'A: core products'
           WHEN CumulativePercent <= 90 THEN 'B: supporting products'
           ELSE 'C: tail products'
       END AS ABCClass
FROM ProductShare
ORDER BY Revenue DESC
LIMIT 12;