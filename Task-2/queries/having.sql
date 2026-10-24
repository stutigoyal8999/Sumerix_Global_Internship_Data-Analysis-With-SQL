-- HAVING clause
-- WHERE filters rows before grouping, HAVING filters groups after aggregation.

-- 1. Top customers: total spending above 50000
SELECT c.CustomerName, SUM(od.Quantity * od.UnitPrice) AS TotalSpent
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(od.Quantity * od.UnitPrice) > 50000
ORDER BY TotalSpent DESC;

-- 2. Repeat customers: placed at least 2 orders
SELECT c.CustomerName, COUNT(o.OrderID) AS OrdersPlaced
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) >= 2
ORDER BY OrdersPlaced DESC;

-- 3. High revenue products: revenue above 20000
SELECT p.ProductName, SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM Products p
INNER JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(od.Quantity * od.UnitPrice) > 20000
ORDER BY Revenue DESC;

-- 4. Categories contributing more than 30000
SELECT cat.CategoryName, SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM Categories cat
INNER JOIN Products p ON cat.CategoryID = p.CategoryID
INNER JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY cat.CategoryID, cat.CategoryName
HAVING SUM(od.Quantity * od.UnitPrice) > 30000
ORDER BY Revenue DESC;

-- 5. High performing regions: revenue above 100000
SELECT c.Region, SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.Region
HAVING SUM(od.Quantity * od.UnitPrice) > 100000
ORDER BY Revenue DESC;

-- 6. High performing employees: sales above 100000
SELECT e.EmployeeName, SUM(od.Quantity * od.UnitPrice) AS SalesValue
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.EmployeeName
HAVING SUM(od.Quantity * od.UnitPrice) > 100000
ORDER BY SalesValue DESC;

-- 7. WHERE and HAVING together: North region customers who spent over 30000
SELECT c.CustomerName, SUM(od.Quantity * od.UnitPrice) AS TotalSpent
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
WHERE c.Region = 'North'
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(od.Quantity * od.UnitPrice) > 30000
ORDER BY TotalSpent DESC;