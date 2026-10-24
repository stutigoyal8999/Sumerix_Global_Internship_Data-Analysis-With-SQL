-- Aggregate functions 

-- 1. COUNT: total products
SELECT COUNT(*) AS TotalProducts FROM Products;

-- 2. COUNT: total orders
SELECT COUNT(*) AS TotalOrders FROM Orders;

-- 3. AVG: average product price
SELECT ROUND(AVG(Price), 2) AS AvgProductPrice FROM Products;

-- 4. MAX and MIN: highest and lowest priced products
SELECT ProductName, Price FROM Products
WHERE Price = (SELECT MAX(Price) FROM Products)
   OR Price = (SELECT MIN(Price) FROM Products);

-- 5. SUM: total revenue
SELECT SUM(Quantity * UnitPrice) AS TotalRevenue
FROM Order_Details;

-- 6. Average order value (revenue divided by number of orders)
SELECT ROUND(SUM(Quantity * UnitPrice) * 1.0 / COUNT(DISTINCT OrderID), 2) AS AvgOrderValue
FROM Order_Details;

-- 7. Total units sold
SELECT SUM(Quantity) AS TotalUnitsSold FROM Order_Details;

-- 8. Several KPIs in one result
SELECT COUNT(DISTINCT o.OrderID) AS Orders,
       COUNT(DISTINCT o.CustomerID) AS ActiveCustomers,
       SUM(od.Quantity * od.UnitPrice) AS Revenue,
       MAX(od.Quantity * od.UnitPrice) AS LargestOrderLine
FROM Orders o
INNER JOIN Order_Details od ON o.OrderID = od.OrderID;

-- 9. Product performance: units sold and revenue per product
SELECT p.ProductName,
       SUM(od.Quantity) AS UnitsSold,
       SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM Products p
INNER JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Revenue DESC;

-- 10. Customer spending: orders placed and total spent per customer
SELECT c.CustomerName,
       COUNT(DISTINCT o.OrderID) AS OrdersPlaced,
       SUM(od.Quantity * od.UnitPrice) AS TotalSpent
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC;