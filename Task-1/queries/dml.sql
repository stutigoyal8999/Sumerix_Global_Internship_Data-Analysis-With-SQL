 --DML operations : UPDATE and DELETE

 --1. Update a customer's city
 UPDATE Customers
 SET City = 'Bengaluru'
 WHERE CustomerID = 2;

 --2. Update a product's price
 UPDATE Products
 SET Price = 1300
 WHERE ProductName = 'Keyboard';

 --3. Update stock after a restock
 UPDATE Products
 SET StockQuantity = StockQuantity + 50
 WHERE ProductID = 8;

 --4. Add and delete customers
 INSERT INTO Customers (CustomerName, Email, City, Country) VALUES
 ('Stuti Goyal', 'stuti.goyal@gmail.com', 'New Delhi', 'India'),
 ('Test Customer', 'test.customer@gmail.com', 'Delhi', 'India');

DELETE FROM Customers
WHERE Email = 'test.customer@gmail.com';

