--SELECT queries : retrieval, filtering and sorting

--1. All customers
SELECT * FROM Customers;

--2. Specific columns with aliases
SELECT ProductName AS Product, Price AS "Price (INR)"
FROM Products;

--3. WHERE : prodcuts costing more than 5000
SELECT ProductName, Price
FROM Products
WHERE Price > 5000;

--4. WHERE with AND : electronics under 30000
SELECT ProductName, Price
FROM Products
WHERE CategoryID = 1 AND Price < 30000;

--5. DISTINCT : unique customer cities
SELECT DISTINCT City
FROM Customers;

--6. ORDER BY : customers alphabetically
SELECT CustomerName, City
FROM Customers
ORDER BY CustomerName ASC;

--7. ORDER BY + LIMIT : 5 most expensive products
SELECT ProductName, Price
FROM Products
ORDER BY Price DESC
LIMIT 5;

--8. LIKE : customers whose name starts with A
SELECT CustomerName, City
FROM Customers
WHERE CustomerName LIKE 'A%';

--9. Low stock products (report)
SELECT ProductName, StockQuantity
FROM Products
WHERE StockQuantity < 25
ORDER BY StockQuantity; 

--10. Basic sales report : 10 largest  order lines by value
SELECT OrderID, ProductID, Quantity, UnitPrice, Quantity*UnitPrice AS LineTotal
FROM Order_Details
ORDER BY LineTotal DESC
LIMIT 10;