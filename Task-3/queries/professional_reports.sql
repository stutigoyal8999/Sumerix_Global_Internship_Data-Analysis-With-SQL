-- Professional reporting (Task 3, Step 9)
-- One report per query, built on the views from views.sql

-- 1. Customer segmentation report: size, revenue and leader of every segment
WITH Segmented AS (
    SELECT CustomerName, Region, OrdersPlaced, TotalSpent,
           CASE
               WHEN TotalSpent >= 100000 THEN 'Premium'
               WHEN TotalSpent >= 50000 THEN 'Gold'
               WHEN TotalSpent >= 20000 THEN 'Silver'
               ELSE 'Regular'
           END AS Segment
    FROM vw_CustomerSales
    WHERE OrdersPlaced > 0
),
Leaders AS (
    SELECT Segment, CustomerName,
           ROW_NUMBER() OVER (PARTITION BY Segment ORDER BY TotalSpent DESC, CustomerName) AS SegmentRank
    FROM Segmented
)
SELECT s.Segment,
       COUNT(*) AS Customers,
       SUM(s.TotalSpent) AS Revenue,
       ROUND(SUM(s.TotalSpent) * 100.0 / SUM(SUM(s.TotalSpent)) OVER (), 1) AS RevenueShare,
       ROUND(AVG(s.TotalSpent), 0) AS AvgSpend,
       ROUND(AVG(s.OrdersPlaced), 1) AS AvgOrders,
       l.CustomerName AS TopCustomer
FROM Segmented s
INNER JOIN Leaders l ON s.Segment = l.Segment AND l.SegmentRank = 1
GROUP BY s.Segment, l.CustomerName
ORDER BY Revenue DESC;

-- 2. Revenue ranking report: customers ranked by revenue with cumulative share
SELECT RANK() OVER (ORDER BY TotalSpent DESC) AS RevenueRank,
       CustomerName, Region, OrdersPlaced, TotalSpent,
       ROUND(TotalSpent * 100.0 / SUM(TotalSpent) OVER (), 1) AS SharePercent,
       ROUND(SUM(TotalSpent) OVER (ORDER BY TotalSpent DESC, CustomerName) * 100.0 / SUM(TotalSpent) OVER (), 1) AS CumulativePercent
FROM vw_CustomerSales
WHERE OrdersPlaced > 0
ORDER BY RevenueRank, CustomerName
LIMIT 10;

-- 3. Product ranking report: overall rank, rank inside the category and performance status
SELECT RANK() OVER (ORDER BY Revenue DESC) AS OverallRank,
       ProductName, CategoryName, UnitsSold, Revenue,
       RANK() OVER (PARTITION BY CategoryName ORDER BY Revenue DESC) AS CategoryRank,
       ROUND(Revenue * 100.0 / SUM(Revenue) OVER (), 1) AS SharePercent,
       CASE
           WHEN Revenue >= 100000 THEN 'Top performer'
           WHEN Revenue >= 20000 THEN 'Good performer'
           WHEN Revenue > 0 THEN 'Low performer'
           ELSE 'No sales'
       END AS PerformanceStatus
FROM vw_ProductSales
ORDER BY OverallRank, ProductName
LIMIT 10;

-- 4. Monthly growth report: revenue with month-over-month and year-over-year change
WITH Monthly AS (
    SELECT Month, Orders, Revenue FROM vw_MonthlySales
)
SELECT m.Month, m.Orders, m.Revenue,
       ROUND((m.Revenue - p.Revenue) * 100.0 / p.Revenue, 1) AS MoMGrowthPercent,
       ROUND((m.Revenue - y.Revenue) * 100.0 / y.Revenue, 1) AS YoYGrowthPercent,
       SUM(m.Revenue) OVER (ORDER BY m.Month) AS RunningRevenue,
       CASE
           WHEN p.Revenue IS NULL THEN 'No previous month'
           WHEN m.Revenue > p.Revenue THEN 'Growth'
           WHEN m.Revenue < p.Revenue THEN 'Decline'
           ELSE 'Flat'
       END AS Trend
FROM Monthly m
LEFT JOIN Monthly p ON p.Month = strftime('%Y-%m', date(m.Month || '-01', '-1 month'))
LEFT JOIN Monthly y ON y.Month = strftime('%Y-%m', date(m.Month || '-01', '-1 year'))
ORDER BY m.Month;

-- 5. Regional performance report: size, rank and trend of every region
WITH RegionTotals AS (
    SELECT c.Region,
           COUNT(*) AS Orders,
           COUNT(DISTINCT ot.CustomerID) AS Customers,
           SUM(ot.OrderTotal) AS Revenue,
           SUM(CASE WHEN strftime('%Y', ot.OrderDate) = '2025'
                     AND CAST(strftime('%m', ot.OrderDate) AS INTEGER) BETWEEN 7 AND 10
                    THEN ot.OrderTotal ELSE 0 END) AS JulOct2025,
           SUM(CASE WHEN strftime('%Y', ot.OrderDate) = '2026' THEN ot.OrderTotal ELSE 0 END) AS JulOct2026
    FROM vw_OrderTotals ot
    INNER JOIN Customers c ON ot.CustomerID = c.CustomerID
    GROUP BY c.Region
)
SELECT RANK() OVER (ORDER BY Revenue DESC) AS RevenueRank,
       Region, Orders, Customers, Revenue,
       ROUND(Revenue * 100.0 / SUM(Revenue) OVER (), 1) AS SharePercent,
       ROUND(Revenue * 1.0 / Orders, 0) AS AvgOrderValue,
       JulOct2025, JulOct2026,
       ROUND((JulOct2026 - JulOct2025) * 100.0 / JulOct2025, 1) AS ChangePercent,
       CASE WHEN JulOct2026 < JulOct2025 THEN 'Declining' ELSE 'Growing' END AS Trend
FROM RegionTotals
ORDER BY RevenueRank;