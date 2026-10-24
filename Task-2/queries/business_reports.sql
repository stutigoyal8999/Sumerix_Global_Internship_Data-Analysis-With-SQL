-- Business reports 

-- 1. Sales summary: overall KPIs
SELECT COUNT(DISTINCT o.OrderID) AS TotalOrders,
       COUNT(DISTINCT o.CustomerID) AS ActiveCustomers,
       SUM(od.Quantity) AS UnitsSold,
       SUM(od.Quantity * od.UnitPrice) AS TotalRevenue,
       ROUND(SUM(od.Quantity * od.UnitPrice) * 1.0 / COUNT(DISTINCT o.OrderID), 2) AS AvgOrderValue
FROM Orders o
INNER JOIN Order_Details od ON o.OrderID = od.OrderID;

-- 2. Which products generate the highest revenue? (top 5)
SELECT p.ProductName, SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM Products p
INNER JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Revenue DESC
LIMIT 5;

-- 3. Which customers place the most orders? (top 5)
SELECT c.CustomerName, COUNT(o.OrderID) AS OrdersPlaced
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY OrdersPlaced DESC, c.CustomerName
LIMIT 5;

-- 4. Which regions perform best? Revenue and share of total
SELECT c.Region,
       COUNT(DISTINCT o.OrderID) AS Orders,
       SUM(od.Quantity * od.UnitPrice) AS Revenue,
       ROUND(SUM(od.Quantity * od.UnitPrice) * 100.0 /
             (SELECT SUM(Quantity * UnitPrice) FROM Order_Details), 1) AS SharePercent
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.Region
ORDER BY Revenue DESC;

-- 5. What is the average monthly sales value?
SELECT COUNT(DISTINCT strftime('%Y-%m', o.OrderDate)) AS MonthsCovered,
       ROUND(SUM(od.Quantity * od.UnitPrice) * 1.0 /
             COUNT(DISTINCT strftime('%Y-%m', o.OrderDate)), 2) AS AvgMonthlySales
FROM Orders o
INNER JOIN Order_Details od ON o.OrderID = od.OrderID;

-- 6. Which employees achieve the highest sales?
SELECT e.EmployeeName, e.JobTitle,
       COUNT(DISTINCT o.OrderID) AS OrdersHandled,
       SUM(od.Quantity * od.UnitPrice) AS SalesValue
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.EmployeeName, e.JobTitle
ORDER BY SalesValue DESC;

-- 7. Which categories contribute most to revenue?
SELECT cat.CategoryName,
       SUM(od.Quantity * od.UnitPrice) AS Revenue,
       ROUND(SUM(od.Quantity * od.UnitPrice) * 100.0 /
             (SELECT SUM(Quantity * UnitPrice) FROM Order_Details), 1) AS SharePercent
FROM Categories cat
INNER JOIN Products p ON cat.CategoryID = p.CategoryID
INNER JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY cat.CategoryID, cat.CategoryName
ORDER BY Revenue DESC;

-- 8. Monthly sales dashboard dataset
SELECT strftime('%Y-%m', o.OrderDate) AS Month,
       COUNT(DISTINCT o.OrderID) AS Orders,
       SUM(od.Quantity * od.UnitPrice) AS Revenue,
       ROUND(SUM(od.Quantity * od.UnitPrice) * 1.0 / COUNT(DISTINCT o.OrderID), 2) AS AvgOrderValue,
       COUNT(DISTINCT o.CustomerID) AS Customers
FROM Orders o
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY strftime('%Y-%m', o.OrderDate)
ORDER BY Month;

-- 9. Customer sales report (every customer, including those with no orders)
SELECT c.CustomerName, c.Region,
       COUNT(DISTINCT o.OrderID) AS OrdersPlaced,
       COALESCE(SUM(od.Quantity * od.UnitPrice), 0) AS TotalSpent,
       MAX(o.OrderDate) AS LastOrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName, c.Region
ORDER BY TotalSpent DESC;

-- 10. Product performance report (every product, including unsold ones)
SELECT p.ProductName, cat.CategoryName,
       COALESCE(SUM(od.Quantity), 0) AS UnitsSold,
       COALESCE(SUM(od.Quantity * od.UnitPrice), 0) AS Revenue
FROM Products p
INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
LEFT JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, cat.CategoryName
ORDER BY Revenue DESC;

-- 11. Supplier contribution analysis
SELECT s.SupplierName,
       COUNT(DISTINCT p.ProductID) AS ProductsSupplied,
       COALESCE(SUM(od.Quantity * od.UnitPrice), 0) AS Revenue
FROM Suppliers s
INNER JOIN Products p ON s.SupplierID = p.SupplierID
LEFT JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY Revenue DESC;