-- SQL Views (Task 3)
-- Every view starts with DROP VIEW IF EXISTS, so the file can be re-run safely.

-- View 1: order totals (one row per order, replaces a TotalAmount column)
DROP VIEW IF EXISTS vw_OrderTotals;
CREATE VIEW vw_OrderTotals AS
SELECT o.OrderID,
       o.CustomerID,
       o.EmployeeID,
       o.OrderDate,
       strftime('%Y-%m', o.OrderDate) AS OrderMonth,
       COUNT(od.OrderDetailID) AS LineItems,
       SUM(od.Quantity * od.UnitPrice) AS OrderTotal
FROM Orders o
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.CustomerID, o.EmployeeID, o.OrderDate;

-- View 2: customer sales summary (includes customers with no orders)
DROP VIEW IF EXISTS vw_CustomerSales;
CREATE VIEW vw_CustomerSales AS
SELECT c.CustomerID,
       c.CustomerName,
       c.City,
       c.Region,
       COUNT(ot.OrderID) AS OrdersPlaced,
       COALESCE(SUM(ot.OrderTotal), 0) AS TotalSpent,
       MIN(ot.OrderDate) AS FirstOrderDate,
       MAX(ot.OrderDate) AS LastOrderDate
FROM Customers c
LEFT JOIN vw_OrderTotals ot ON c.CustomerID = ot.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.City, c.Region;

-- View 3: product sales (includes products that never sold)
DROP VIEW IF EXISTS vw_ProductSales;
CREATE VIEW vw_ProductSales AS
SELECT p.ProductID,
       p.ProductName,
       cat.CategoryName,
       p.Price,
       COALESCE(SUM(od.Quantity), 0) AS UnitsSold,
       COALESCE(SUM(od.Quantity * od.UnitPrice), 0) AS Revenue
FROM Products p
INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
LEFT JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, cat.CategoryName, p.Price;

-- View 4: monthly sales (built on top of vw_OrderTotals)
DROP VIEW IF EXISTS vw_MonthlySales;
CREATE VIEW vw_MonthlySales AS
SELECT OrderMonth AS Month,
       COUNT(*) AS Orders,
       SUM(OrderTotal) AS Revenue,
       ROUND(AVG(OrderTotal), 2) AS AvgOrderValue,
       COUNT(DISTINCT CustomerID) AS Customers
FROM vw_OrderTotals
GROUP BY OrderMonth;

-- View 5: regional sales by year
DROP VIEW IF EXISTS vw_RegionalSales;
CREATE VIEW vw_RegionalSales AS
SELECT c.Region,
       strftime('%Y', ot.OrderDate) AS SalesYear,
       COUNT(*) AS Orders,
       SUM(ot.OrderTotal) AS Revenue
FROM vw_OrderTotals ot
INNER JOIN Customers c ON ot.CustomerID = c.CustomerID
GROUP BY c.Region, strftime('%Y', ot.OrderDate);

-- View 6: employee sales
DROP VIEW IF EXISTS vw_EmployeeSales;
CREATE VIEW vw_EmployeeSales AS
SELECT e.EmployeeID,
       e.EmployeeName,
       e.JobTitle,
       COUNT(ot.OrderID) AS OrdersHandled,
       COALESCE(SUM(ot.OrderTotal), 0) AS TotalSales
FROM Employees e
LEFT JOIN vw_OrderTotals ot ON e.EmployeeID = ot.EmployeeID
GROUP BY e.EmployeeID, e.EmployeeName, e.JobTitle;

-- Using the views: the 5 largest orders
SELECT * FROM vw_OrderTotals ORDER BY OrderTotal DESC LIMIT 5;

-- Using the views: top 5 customers by spending
SELECT CustomerName, Region, OrdersPlaced, TotalSpent, LastOrderDate
FROM vw_CustomerSales
ORDER BY TotalSpent DESC
LIMIT 5;

-- Using the views: top 5 products by revenue
SELECT ProductName, CategoryName, UnitsSold, Revenue
FROM vw_ProductSales
ORDER BY Revenue DESC
LIMIT 5;

-- Using the views: monthly sales report
SELECT * FROM vw_MonthlySales ORDER BY Month;

-- Using the views: regional sales by year
SELECT * FROM vw_RegionalSales ORDER BY SalesYear, Revenue DESC;

-- Using the views: employee sales ranking
SELECT EmployeeName, JobTitle, OrdersHandled, TotalSales
FROM vw_EmployeeSales
ORDER BY TotalSales DESC;

-- Filtering a view like a table: customers who have never ordered
SELECT CustomerName, City, Region
FROM vw_CustomerSales
WHERE OrdersPlaced = 0;

-- Joining a view with a table: the largest orders with the employee who handled them
SELECT ot.OrderID, ot.OrderDate, e.EmployeeName, ot.OrderTotal
FROM vw_OrderTotals ot
INNER JOIN Employees e ON ot.EmployeeID = e.EmployeeID
ORDER BY ot.OrderTotal DESC
LIMIT 5;

-- ALTER VIEW equivalent: SQLite has no ALTER VIEW, so drop and recreate it
-- Version 1: customers above 100000
DROP VIEW IF EXISTS vw_TopCustomers;
CREATE VIEW vw_TopCustomers AS
SELECT CustomerName, Region, TotalSpent
FROM vw_CustomerSales
WHERE TotalSpent > 100000;

SELECT * FROM vw_TopCustomers ORDER BY TotalSpent DESC;

-- Version 2: threshold lowered to 50000
DROP VIEW IF EXISTS vw_TopCustomers;
CREATE VIEW vw_TopCustomers AS
SELECT CustomerName, Region, TotalSpent
FROM vw_CustomerSales
WHERE TotalSpent > 50000;

SELECT * FROM vw_TopCustomers ORDER BY TotalSpent DESC;

-- DROP VIEW: create a practice view, then remove it
DROP VIEW IF EXISTS vw_Practice;
CREATE VIEW vw_Practice AS
SELECT ProductName, Price
FROM Products
WHERE Price < 500;

SELECT * FROM vw_Practice;

DROP VIEW vw_Practice;