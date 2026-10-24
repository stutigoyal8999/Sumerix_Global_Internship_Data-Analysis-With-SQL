-- GROUP BY reports 

-- 1. Customer-wise: orders per customer, including customers with none
SELECT c.CustomerName, COUNT(o.OrderID) AS OrdersPlaced
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY OrdersPlaced DESC;

-- 2. Product-wise: number of products per category
SELECT cat.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Categories cat
LEFT JOIN Products p ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryID, cat.CategoryName;

-- 3. Category-wise sales report
SELECT cat.CategoryName,
       SUM(od.Quantity) AS UnitsSold,
       SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM Order_Details od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
GROUP BY cat.CategoryID, cat.CategoryName
ORDER BY Revenue DESC;

-- 4. Department-wise: employees per job title
SELECT JobTitle, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY JobTitle;

-- 5. Employee-wise sales report
SELECT e.EmployeeName, e.JobTitle,
       COUNT(DISTINCT o.OrderID) AS OrdersHandled,
       SUM(od.Quantity * od.UnitPrice) AS SalesValue
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.EmployeeName, e.JobTitle
ORDER BY SalesValue DESC;

-- 6. Regional sales summary
SELECT c.Region,
       COUNT(DISTINCT o.OrderID) AS Orders,
       SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.Region
ORDER BY Revenue DESC;

-- 7. Monthly sales summary
SELECT strftime('%Y-%m', o.OrderDate) AS Month,
       COUNT(DISTINCT o.OrderID) AS Orders,
       SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM Orders o
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY strftime('%Y-%m', o.OrderDate)
ORDER BY Month;

-- 8. Grouping by two columns: revenue by month and category
SELECT strftime('%Y-%m', o.OrderDate) AS Month,
       cat.CategoryName,
       SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM Orders o
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
GROUP BY Month, cat.CategoryName
ORDER BY Month, Revenue DESC;