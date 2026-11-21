-- Common Table Expressions (Task 3)

-- 1. Single CTE: customers with total sales above 100000
WITH CustomerSales AS (
    SELECT o.CustomerID,
           SUM(od.Quantity * od.UnitPrice) AS TotalSales
    FROM Orders o
    INNER JOIN Order_Details od ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
)
SELECT c.CustomerName, cs.TotalSales
FROM CustomerSales cs
INNER JOIN Customers c ON cs.CustomerID = c.CustomerID
WHERE cs.TotalSales > 100000
ORDER BY cs.TotalSales DESC;

-- 2. Single CTE: months where revenue was above the monthly average
WITH MonthlySales AS (
    SELECT strftime('%Y-%m', o.OrderDate) AS Month,
           SUM(od.Quantity * od.UnitPrice) AS Revenue
    FROM Orders o
    INNER JOIN Order_Details od ON o.OrderID = od.OrderID
    GROUP BY strftime('%Y-%m', o.OrderDate)
)
SELECT Month, Revenue
FROM MonthlySales
WHERE Revenue > (SELECT AVG(Revenue) FROM MonthlySales)
ORDER BY Revenue DESC;

-- 3. Multiple CTEs: average order value per customer
WITH OrderTotals AS (
    SELECT o.OrderID, o.CustomerID,
           SUM(od.Quantity * od.UnitPrice) AS OrderTotal
    FROM Orders o
    INNER JOIN Order_Details od ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.CustomerID
),
CustomerSummary AS (
    SELECT CustomerID,
           COUNT(*) AS OrdersPlaced,
           SUM(OrderTotal) AS TotalSpent,
           ROUND(AVG(OrderTotal), 2) AS AvgOrderValue
    FROM OrderTotals
    GROUP BY CustomerID
)
SELECT c.CustomerName, cs.OrdersPlaced, cs.TotalSpent, cs.AvgOrderValue
FROM CustomerSummary cs
INNER JOIN Customers c ON cs.CustomerID = c.CustomerID
ORDER BY cs.TotalSpent DESC
LIMIT 5;

-- 4. Multiple CTEs: each product's share of its category revenue
WITH ProductRevenue AS (
    SELECT p.ProductID, p.ProductName, p.CategoryID,
           SUM(od.Quantity * od.UnitPrice) AS Revenue
    FROM Products p
    INNER JOIN Order_Details od ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName, p.CategoryID
),
CategoryRevenue AS (
    SELECT CategoryID, SUM(Revenue) AS CategoryTotal
    FROM ProductRevenue
    GROUP BY CategoryID
)
SELECT cat.CategoryName, pr.ProductName, pr.Revenue,
       ROUND(pr.Revenue * 100.0 / cr.CategoryTotal, 1) AS SharePercent
FROM ProductRevenue pr
INNER JOIN CategoryRevenue cr ON pr.CategoryID = cr.CategoryID
INNER JOIN Categories cat ON pr.CategoryID = cat.CategoryID
ORDER BY cat.CategoryName, pr.Revenue DESC
LIMIT 10;

-- 5. Modular query: each employee's sales compared with the team average
WITH EmployeeSales AS (
    SELECT e.EmployeeID, e.EmployeeName,
           SUM(od.Quantity * od.UnitPrice) AS TotalSales
    FROM Employees e
    INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
    INNER JOIN Order_Details od ON o.OrderID = od.OrderID
    GROUP BY e.EmployeeID, e.EmployeeName
),
TeamAverage AS (
    SELECT AVG(TotalSales) AS AvgSales FROM EmployeeSales
)
SELECT es.EmployeeName, es.TotalSales,
       ROUND(ta.AvgSales, 2) AS TeamAverage,
       CASE WHEN es.TotalSales > ta.AvgSales THEN 'Above average' ELSE 'Below average' END AS Performance
FROM EmployeeSales es
CROSS JOIN TeamAverage ta
ORDER BY es.TotalSales DESC;

-- 6. Readability: the nested subquery from subqueries.sql rewritten with CTEs
WITH CustomerTotals AS (
    SELECT o.CustomerID,
           SUM(od.Quantity * od.UnitPrice) AS TotalSpent
    FROM Orders o
    INNER JOIN Order_Details od ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
)
SELECT c.CustomerName, ct.TotalSpent
FROM CustomerTotals ct
INNER JOIN Customers c ON ct.CustomerID = c.CustomerID
WHERE ct.TotalSpent > (SELECT AVG(TotalSpent) FROM CustomerTotals)
ORDER BY ct.TotalSpent DESC;

-- 7. Recursive CTE: employee reporting hierarchy
WITH RECURSIVE OrgChart AS (
    SELECT EmployeeID, EmployeeName, JobTitle, ManagerID,
           1 AS Level,
           EmployeeName AS ReportingPath
    FROM Employees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.EmployeeName, e.JobTitle, e.ManagerID,
           oc.Level + 1,
           oc.ReportingPath || ' > ' || e.EmployeeName
    FROM Employees e
    INNER JOIN OrgChart oc ON e.ManagerID = oc.EmployeeID
)
SELECT Level, EmployeeName, JobTitle, ReportingPath
FROM OrgChart
ORDER BY Level, EmployeeName;

-- 8. Recursive CTE: month calendar so that months without sales show as zero
WITH RECURSIVE Months(MonthStart) AS (
    SELECT '2025-07-01'
    UNION ALL
    SELECT date(MonthStart, '+1 month')
    FROM Months
    WHERE MonthStart < '2026-10-01'
)
SELECT strftime('%Y-%m', m.MonthStart) AS Month,
       COALESCE(SUM(od.Quantity * od.UnitPrice), 0) AS Revenue
FROM Months m
LEFT JOIN Orders o ON strftime('%Y-%m', o.OrderDate) = strftime('%Y-%m', m.MonthStart)
LEFT JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY m.MonthStart
ORDER BY m.MonthStart;