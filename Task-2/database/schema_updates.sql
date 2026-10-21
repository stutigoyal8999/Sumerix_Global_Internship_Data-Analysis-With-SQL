-- Task 2 database updates

-- 1. Manager link for SELF JOIN
ALTER TABLE Employees ADD COLUMN ManagerID INTEGER REFERENCES Employees(EmployeeID);
UPDATE Employees SET ManagerID = 1 WHERE EmployeeID IN (2, 3);
UPDATE Employees SET ManagerID = 2 WHERE EmployeeID IN (4, 5);

-- 2. New customer without orders, new product without sales
INSERT INTO Customers (CustomerName, Email, City, Country)
VALUES ('Rina Kapoor', 'rina.kapoor@example.com', 'Delhi', 'India');

INSERT INTO Products (ProductName, CategoryID, SupplierID, Price, StockQuantity)
VALUES ('Wireless Charger', 2, 2, 1800, 40);

-- 3. Region for regional reports
ALTER TABLE Customers ADD COLUMN Region VARCHAR(20);
UPDATE Customers SET Region = CASE
    WHEN City IN ('Delhi', 'New Delhi', 'Chandigarh', 'Lucknow', 'Jaipur') THEN 'North'
    WHEN City IN ('Mumbai', 'Pune', 'Ahmedabad', 'Surat') THEN 'West'
    WHEN City IN ('Bengaluru', 'Hyderabad', 'Chennai', 'Kochi', 'Thiruvananthapuram', 'Coimbatore') THEN 'South'
    WHEN City IN ('Kolkata', 'Patna', 'Guwahati') THEN 'East'
    WHEN City IN ('Bhopal', 'Indore') THEN 'Central'
    ELSE 'Other'
END;

-- 4. Repeat orders across months
INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate) VALUES
(21, 1, 3, '2026-08-15'), (22, 2, 2, '2026-09-02'),
(23, 1, 2, '2026-09-14'), (24, 5, 4, '2026-09-20'),
(25, 12, 3, '2026-10-02'), (26, 2, 5, '2026-10-06'),
(27, 7, 2, '2026-10-10'), (28, 1, 3, '2026-10-12'),
(29, 9, 5, '2026-10-15'), (30, 5, 2, '2026-10-18');

INSERT INTO Order_Details (OrderID, ProductID, Quantity, UnitPrice) VALUES
(21, 5, 1, 6000), (21, 10, 1, 2000),
(22, 4, 2, 2500),
(23, 9, 1, 1500), (23, 7, 1, 800),
(24, 3, 1, 18000),
(25, 18, 1, 7500), (25, 17, 2, 450),
(26, 1, 1, 65000),
(27, 13, 2, 1100), (27, 14, 1, 900),
(28, 6, 1, 1300), (28, 16, 6, 150),
(29, 2, 1, 25000),
(30, 19, 1, 6500), (30, 15, 3, 300);