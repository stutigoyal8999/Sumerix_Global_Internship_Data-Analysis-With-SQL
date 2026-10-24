-- Set operators 

-- 1. UNION: merge customer lists from the North and South regions
SELECT CustomerName, Region FROM Customers WHERE Region = 'North'
UNION
SELECT CustomerName, Region FROM Customers WHERE Region = 'South'
ORDER BY Region, CustomerName;

-- 2. UNION: electronics products or products priced above 5000 (duplicates removed)
SELECT ProductName FROM Products WHERE CategoryID = 1
UNION
SELECT ProductName FROM Products WHERE Price > 5000;

-- 3. UNION ALL: same lists, but duplicates are kept
SELECT ProductName FROM Products WHERE CategoryID = 1
UNION ALL
SELECT ProductName FROM Products WHERE Price > 5000;

-- 4. UNION: customers who are big spenders or frequent buyers
SELECT c.CustomerName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(od.Quantity * od.UnitPrice) > 50000
UNION
SELECT c.CustomerName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) >= 3
ORDER BY CustomerName;

-- 5. INTERSECT: customers who are both big spenders and frequent buyers
SELECT c.CustomerName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(od.Quantity * od.UnitPrice) > 50000
INTERSECT
SELECT c.CustomerName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) >= 3
ORDER BY CustomerName;

-- 6. EXCEPT: big spenders who are not frequent buyers
SELECT c.CustomerName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(od.Quantity * od.UnitPrice) > 50000
EXCEPT
SELECT c.CustomerName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) >= 3
ORDER BY CustomerName;

-- 7. EXCEPT: customers who have never placed an order
SELECT CustomerName FROM Customers
EXCEPT
SELECT c.CustomerName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 8. EXCEPT: products that have never been sold
SELECT ProductName FROM Products
EXCEPT
SELECT p.ProductName
FROM Products p
INNER JOIN Order_Details od ON p.ProductID = od.ProductID;