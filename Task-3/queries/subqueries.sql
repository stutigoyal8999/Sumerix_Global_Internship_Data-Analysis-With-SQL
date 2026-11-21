-- Subqueries and correlated queries (Task 3)

-- 1. Scalar subquery: products priced above the average product price
SELECT ProductName, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)
ORDER BY Price DESC;

-- 2. Scalar subquery in SELECT: each product's price difference from the average
SELECT ProductName, Price,
       ROUND(Price - (SELECT AVG(Price) FROM Products), 2) AS DifferenceFromAvg
FROM Products
ORDER BY DifferenceFromAvg DESC
LIMIT 5;

-- 3. Multi-row subquery with IN: customers who placed an order worth more than 50000
SELECT CustomerName, City
FROM Customers
WHERE CustomerID IN (
    SELECT o.CustomerID
    FROM Orders o
    INNER JOIN Order_Details od ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.CustomerID
    HAVING SUM(od.Quantity * od.UnitPrice) > 50000
)
ORDER BY CustomerName;

-- 4. Multi-row subquery with IN: products sold in October 2026
SELECT ProductName, Price
FROM Products
WHERE ProductID IN (
    SELECT od.ProductID
    FROM Order_Details od
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    WHERE strftime('%Y-%m', o.OrderDate) = '2026-10'
)
ORDER BY ProductName;

-- 5. NOT IN: products that have never been sold
SELECT ProductName, Price
FROM Products
WHERE ProductID NOT IN (SELECT ProductID FROM Order_Details);

-- 6. EXISTS: customers who placed at least one order in 2026
SELECT c.CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
      AND strftime('%Y', o.OrderDate) = '2026'
)
ORDER BY c.CustomerName;

-- 7. NOT EXISTS: customers who have never placed an order
SELECT c.CustomerName, c.City
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
);

-- 8. Correlated subquery: products priced above the average of their own category
SELECT p.ProductName, p.Price
FROM Products p
WHERE p.Price > (
    SELECT AVG(p2.Price)
    FROM Products p2
    WHERE p2.CategoryID = p.CategoryID
)
ORDER BY p.Price DESC;

-- 9. Correlated subquery in SELECT: each customer's most recent order date
SELECT c.CustomerName,
       (SELECT MAX(o.OrderDate)
        FROM Orders o
        WHERE o.CustomerID = c.CustomerID) AS LastOrderDate
FROM Customers c
ORDER BY LastOrderDate DESC
LIMIT 5;

-- 10. Nested subquery: customers who spent more than the average customer
SELECT c.CustomerName, SUM(od.Quantity * od.UnitPrice) AS TotalSpent
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(od.Quantity * od.UnitPrice) > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT SUM(od2.Quantity * od2.UnitPrice) AS CustomerTotal
        FROM Orders o2
        INNER JOIN Order_Details od2 ON o2.OrderID = od2.OrderID
        GROUP BY o2.CustomerID
    ) AS t
)
ORDER BY TotalSpent DESC;

-- 11. ANY equivalent: products outside Electronics that cost more than the cheapest Electronics product
-- SQLite has no ANY operator, so "> ANY (subquery)" is written as "> (SELECT MIN(...))"
SELECT ProductName, Price
FROM Products
WHERE CategoryID <> 1
  AND Price > (SELECT MIN(Price) FROM Products WHERE CategoryID = 1)
ORDER BY Price DESC;

-- 12. ALL equivalent: non-Accessories products that cost more than every Accessories product
-- SQLite has no ALL operator, so "> ALL (subquery)" is written as "> (SELECT MAX(...))"
SELECT ProductName, Price
FROM Products
WHERE CategoryID <> 2
  AND Price > (SELECT MAX(Price) FROM Products WHERE CategoryID = 2)
ORDER BY Price DESC;