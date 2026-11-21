-- Window functions (Task 3)
-- These queries use the views created in views.sql

-- 1. OVER(): each order next to the grand total, with its share of all revenue
SELECT OrderID, OrderDate, OrderTotal,
       SUM(OrderTotal) OVER () AS GrandTotal,
       ROUND(OrderTotal * 100.0 / SUM(OrderTotal) OVER (), 2) AS SharePercent
FROM vw_OrderTotals
ORDER BY OrderTotal DESC
LIMIT 5;

-- 2. PARTITION BY category: each product's share of its category revenue
SELECT CategoryName, ProductName, Revenue,
       SUM(Revenue) OVER (PARTITION BY CategoryName) AS CategoryRevenue,
       ROUND(Revenue * 100.0 / SUM(Revenue) OVER (PARTITION BY CategoryName), 1) AS ShareOfCategory
FROM vw_ProductSales
WHERE Revenue > 0
ORDER BY CategoryName, Revenue DESC
LIMIT 10;

-- 3. PARTITION BY customer: every order with the customer's order count and total spending
SELECT c.CustomerName, ot.OrderID, ot.OrderDate, ot.OrderTotal,
       COUNT(*) OVER (PARTITION BY ot.CustomerID) AS CustomerOrders,
       SUM(ot.OrderTotal) OVER (PARTITION BY ot.CustomerID) AS CustomerTotal
FROM vw_OrderTotals ot
INNER JOIN Customers c ON ot.CustomerID = c.CustomerID
ORDER BY CustomerTotal DESC, c.CustomerName, ot.OrderDate
LIMIT 10;

-- 4. ORDER BY within OVER: running revenue across orders in date order
SELECT OrderID, OrderDate, OrderTotal,
       SUM(OrderTotal) OVER (
           ORDER BY OrderDate, OrderID
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS RunningRevenue
FROM vw_OrderTotals
ORDER BY OrderDate, OrderID
LIMIT 10;

-- 5. Running total by month
SELECT Month, Revenue,
       SUM(Revenue) OVER (ORDER BY Month) AS RunningRevenue
FROM vw_MonthlySales
ORDER BY Month;

-- 6. Running total restarting each year (PARTITION BY plus ORDER BY)
SELECT substr(Month, 1, 4) AS SalesYear, Month, Revenue,
       SUM(Revenue) OVER (
           PARTITION BY substr(Month, 1, 4)
           ORDER BY Month
       ) AS YearToDateRevenue
FROM vw_MonthlySales
ORDER BY Month;

-- 7. Moving average and rolling sum over the latest 3 recorded months
SELECT Month, Revenue,
       ROUND(AVG(Revenue) OVER (
           ORDER BY Month
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ), 2) AS MovingAvg3,
       SUM(Revenue) OVER (
           ORDER BY Month
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS RollingSum3
FROM vw_MonthlySales
ORDER BY Month;

-- 8. LAG: previous recorded month and the change in revenue
SELECT Month, Revenue,
       LAG(Revenue) OVER (ORDER BY Month) AS PreviousMonthRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY Month) AS Change
FROM vw_MonthlySales
ORDER BY Month;

-- 9. LEAD: next recorded month revenue
SELECT Month, Revenue,
       LEAD(Revenue) OVER (ORDER BY Month) AS NextMonthRevenue
FROM vw_MonthlySales
ORDER BY Month;

-- 10. Named window: one definition reused by several window functions
SELECT Month, Revenue,
       SUM(Revenue) OVER w AS RunningRevenue,
       ROUND(AVG(Revenue) OVER w, 2) AS RunningAverage,
       MAX(Revenue) OVER w AS HighestSoFar
FROM vw_MonthlySales
WINDOW w AS (ORDER BY Month)
ORDER BY Month;