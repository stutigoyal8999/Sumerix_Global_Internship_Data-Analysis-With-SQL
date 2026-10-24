-- JOIN queries 

-- 1. INNER JOIN: every order line with customer and product
SELECT o.OrderID, c.CustomerName, p.ProductName, od.Quantity
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
ORDER BY o.OrderID;

-- 2. LEFT JOIN: all customers, including those without orders
SELECT c.CustomerName, o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerName;

-- 3. LEFT JOIN + IS NULL: customers who never ordered
SELECT c.CustomerName, c.City
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- 4. LEFT JOIN: products that never sold
SELECT p.ProductName, p.Price
FROM Products p
LEFT JOIN Order_Details od ON p.ProductID = od.ProductID
WHERE od.OrderDetailID IS NULL;

-- 5. RIGHT JOIN: all products, with sales lines where they exist
SELECT p.ProductName, od.OrderID, od.Quantity
FROM Order_Details od
RIGHT JOIN Products p ON od.ProductID = p.ProductID
ORDER BY p.ProductName;

-- 6. FULL OUTER JOIN: all customers and all orders, matched or not
SELECT c.CustomerName, o.OrderID
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 7. SELF JOIN: each employee with their manager
SELECT e.EmployeeName AS Employee, e.JobTitle, m.EmployeeName AS Manager
FROM Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID;

-- 8. CROSS JOIN: every employee paired with every category
SELECT e.EmployeeName, cat.CategoryName
FROM Employees e
CROSS JOIN Categories cat;