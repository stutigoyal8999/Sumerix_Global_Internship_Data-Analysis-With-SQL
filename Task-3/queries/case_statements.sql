-- CASE expressions (Task 3)
-- These queries use the views created in views.sql

-- 1. Customer segmentation (the PDF example, using the view)
SELECT CustomerName, TotalSpent,
       CASE
           WHEN TotalSpent >= 100000 THEN 'Premium'
           WHEN TotalSpent >= 50000 THEN 'Gold'
           WHEN TotalSpent >= 20000 THEN 'Silver'
           ELSE 'Regular'
       END AS CustomerCategory
FROM vw_CustomerSales
WHERE OrdersPlaced > 0
ORDER BY TotalSpent DESC
LIMIT 10;

-- 2. Segment summary: customers and revenue in each category
WITH Segments AS (
    SELECT CustomerName, TotalSpent,
           CASE
               WHEN TotalSpent >= 100000 THEN 'Premium'
               WHEN TotalSpent >= 50000 THEN 'Gold'
               WHEN TotalSpent >= 20000 THEN 'Silver'
               ELSE 'Regular'
           END AS CustomerCategory
    FROM vw_CustomerSales
    WHERE OrdersPlaced > 0
)
SELECT CustomerCategory,
       COUNT(*) AS Customers,
       SUM(TotalSpent) AS Revenue,
       ROUND(SUM(TotalSpent) * 100.0 / (SELECT SUM(TotalSpent) FROM Segments), 1) AS RevenueShare
FROM Segments
GROUP BY CustomerCategory
ORDER BY Revenue DESC;

-- 3. Revenue classification: orders grouped by size
SELECT CASE
           WHEN OrderTotal >= 50000 THEN 'Large order'
           WHEN OrderTotal >= 10000 THEN 'Medium order'
           ELSE 'Small order'
       END AS OrderSize,
       COUNT(*) AS Orders,
       SUM(OrderTotal) AS Revenue
FROM vw_OrderTotals
GROUP BY OrderSize
ORDER BY Revenue DESC;

-- 4. Business categories: products grouped into price bands
SELECT CASE
           WHEN Price >= 10000 THEN 'Premium'
           WHEN Price >= 2000 THEN 'Mid-range'
           ELSE 'Budget'
       END AS PriceBand,
       COUNT(*) AS Products,
       SUM(Revenue) AS Revenue
FROM vw_ProductSales
GROUP BY PriceBand
ORDER BY Revenue DESC;

-- 5. Product performance status based on revenue
SELECT ProductName, Revenue,
       CASE
           WHEN Revenue >= 100000 THEN 'Top performer'
           WHEN Revenue >= 20000 THEN 'Good performer'
           WHEN Revenue > 0 THEN 'Low performer'
           ELSE 'No sales'
       END AS PerformanceStatus
FROM vw_ProductSales
ORDER BY Revenue DESC
LIMIT 10;

-- 6. Stock status for inventory planning
SELECT ProductName, StockQuantity,
       CASE
           WHEN StockQuantity < 25 THEN 'Low stock'
           WHEN StockQuantity < 60 THEN 'Medium stock'
           ELSE 'High stock'
       END AS StockStatus
FROM Products
ORDER BY StockQuantity
LIMIT 8;

-- 7. Employee performance compared with the team average
SELECT EmployeeName, TotalSales,
       CASE
           WHEN TotalSales >= 1.5 * (SELECT AVG(TotalSales) FROM vw_EmployeeSales WHERE OrdersHandled > 0) THEN 'Outstanding'
           WHEN TotalSales >= (SELECT AVG(TotalSales) FROM vw_EmployeeSales WHERE OrdersHandled > 0) THEN 'Above average'
           WHEN TotalSales > 0 THEN 'Below average'
           ELSE 'No sales'
       END AS PerformanceStatus
FROM vw_EmployeeSales
ORDER BY TotalSales DESC;

-- 8. Revenue status against a monthly target of 100000
-- The database has no cost data, so this uses a revenue target instead of profit status
SELECT Month, Revenue,
       CASE
           WHEN Revenue >= 100000 THEN 'Target met'
           WHEN Revenue >= 75000 THEN 'Close to target'
           ELSE 'Below target'
       END AS TargetStatus
FROM vw_MonthlySales
ORDER BY Month;

-- 9. Customer activity status based on the days since the last order
SELECT CustomerName, LastOrderDate,
       CASE
           WHEN OrdersPlaced = 0 THEN 'Never ordered'
           WHEN julianday((SELECT MAX(OrderDate) FROM Orders)) - julianday(LastOrderDate) <= 30 THEN 'Active'
           WHEN julianday((SELECT MAX(OrderDate) FROM Orders)) - julianday(LastOrderDate) <= 90 THEN 'At risk'
           ELSE 'Inactive'
       END AS ActivityStatus
FROM vw_CustomerSales
ORDER BY LastOrderDate DESC
LIMIT 10;

-- 10. Activity summary: how many customers fall into each status
WITH Activity AS (
    SELECT CASE
               WHEN OrdersPlaced = 0 THEN 'Never ordered'
               WHEN julianday((SELECT MAX(OrderDate) FROM Orders)) - julianday(LastOrderDate) <= 30 THEN 'Active'
               WHEN julianday((SELECT MAX(OrderDate) FROM Orders)) - julianday(LastOrderDate) <= 90 THEN 'At risk'
               ELSE 'Inactive'
           END AS ActivityStatus
    FROM vw_CustomerSales
)
SELECT ActivityStatus, COUNT(*) AS Customers
FROM Activity
GROUP BY ActivityStatus
ORDER BY Customers DESC;