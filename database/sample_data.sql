--Sample data

INSERT INTO Categories (CategoryName, Description) VALUES
('Electronics', 'Phones, laptops and gadgets'),
('Accessories', 'Computer and mobile accessories'),
('Home Appliances', 'Kitchen and home appliances'),
('Stationery', 'Office and school supplies'),
('Furniture', 'Home and office furniture');

INSERT INTO Suppliers (SupplierName, Phone, City, Country) VALUES
('TechSource India', '9810011111', 'Delhi', 'India'),
('Gadget Hub', '9820022222', 'Mumbai', 'India'),
('HomeEase Traders', '9830033333', 'Pune', 'India'),
('PaperWorld Supplies', '9840044444', 'Chennai', 'India'),
('UrbanWood Furniture', '9850055555', 'Jaipur', 'India');

INSERT INTO Employees (EmployeeName, JobTitle, HireDate) VALUES
('Aarti Kapoor', 'Store Manager', '2020-03-15'),
('Rajesh Khanna', 'Sales Executive', '2021-06-01'),
('Sunita Rao', 'Sales Executive', '2021-09-20'),
('Vivek Anand', 'Cashier', '2022-01-10'),
('Nisha Thakur', 'Sales Associate', '2023-04-05');

INSERT INTO Customers (CustomerName, Email, City, Country) VALUES
('Rahul Sharma', 'rahul.sharma@gmail.com', 'Delhi', 'India'),
('Priya Singh', 'priya.singh@gmail.com', 'Mumbai', 'India'),
('Amit Kumar', 'amit.kumar@gmail.com', 'Patna', 'India'),
('Neha Gupta', 'neha.gupta@gmail.com', 'Jaipur', 'India'),
('Vikram Rao', 'vikram.rao@gmail.com', 'Hyderabad', 'India'),
('Sneha Iyer', 'sneha.iyer@gmail.com', 'Chennai', 'India'),
('Arjun Mehta', 'arjun.mehta@gmail.com', 'Ahmedabad', 'India'),
('Kavita Joshi', 'kavita.joshi@gmail.com', 'Pune', 'India'),
('Rohit Verma', 'rohit.verma@gmail.com', 'Lucknow', 'India'),
('Anjali Nair', 'anjali.nair@gmail.com', 'Kochi', 'India'),
('Sanjay Patel', 'sanjay.patel@gmail.com', 'Surat', 'India'),
('Pooja Reddy', 'pooja.reddy@gmail.com', 'Bengaluru', 'India'),
('Manish Tiwari', 'manish.tiwari@gmail.com', 'Bhopal', 'India'),
('Divya Menon', 'divya.menon@gmail.com', 'Thiruvananthapuram', 'India'),
('Karan Malhotra', 'karan.malhotra@gmail.com', 'Chandigarh', 'India'),
('Ritu Agarwal', 'ritu.agarwal@gmail.com', 'Kolkata', 'India'),
('Deepak Yadav', 'deepak.yadav@gmail.com', 'Indore', 'India'),
('Meera Das', 'meera.das@gmail.com', 'Guwahati', 'India'),
('Suresh Pillai', 'suresh.pillai@gmail.com', 'Coimbatore', 'India'),
('Ananya Bose', 'ananya.bose@gmail.com', 'Kolkata', 'India');

INSERT INTO Products (ProductName, CategoryID, SupplierID, Price, StockQuantity) VALUES
('Laptop', 1, 1, 65000, 15),
('Smartphone', 1, 2, 25000, 40),
('Tablet', 1, 1, 18000, 25),
('Bluetooth Speaker', 1, 2, 2500, 60),
('Smart Watch', 1, 2, 6000, 30),
('Keyboard', 2, 1, 1200, 80),
('Mouse', 2, 1, 800, 100),
('USB Cable', 2, 2, 250, 200),
('Laptop Bag', 2, 2, 1500, 50),
('Headphones', 2, 2, 2000, 70),
('Mixer Grinder', 3, 3, 3500, 35),
('Microwave Oven', 3, 3, 9500, 20),
('Electric Kettle', 3, 3, 1100, 55),
('Iron Box', 3, 3, 900, 45),
('Notebook Pack', 4, 4, 300, 150),
('Gel Pen Set', 4, 4, 150, 200),
('Desk Organizer', 4, 4, 450, 60),
('Office Chair', 5, 5, 7500, 18),
('Study Table', 5, 5, 6500, 12),
('Bookshelf', 5, 5, 8200, 10);

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate) VALUES
(1, 2 , '2026-07-05'),
(2, 3, '2026-07-12'),
(3, 2, '2026-07-19'),
(4, 5, '2026-07-25'),
(5, 3, '2026-08-02'),
(6, 2, '2026-08-09'),
(7, 4, '2026-08-14'),
(8, 5, '2026-08-21'),
(9, 3, '2026-08-28'),
(10, 2, '2026-09-03'),
(11, 4, '2026-09-08'),
(12, 3, '2026-09-13'),
(13, 5, '2026-09-18'),
(14, 2, '2026-09-22'),
(15, 3, '2026-09-27'),
(16, 4, '2026-10-01'),
(17, 5, '2026-10-03'),
(18, 2, '2026-10-05'),
(19, 3, '2026-10-07'),
(20, 4, '2026-10-09');

INSERT INTO Order_Details (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 65000), (1, 7, 1, 800),
(2, 2, 1, 25000), (2, 8, 2, 250),
(3, 6, 1, 1200), (3, 7, 1, 800),
(4, 18, 1, 7500),
(5, 11, 1, 3500), (5, 13, 2, 1100),
(6, 3, 1, 18000), (6, 9, 1, 1500),
(7, 10, 2, 2000), 
(8, 15, 5, 300), (8, 16, 10, 150),
(9, 12, 1, 9500),
(10, 5, 1, 6000), (10, 4, 1, 2500),
(11, 19, 1, 6500),
(12, 2, 1, 25000), (12, 10, 1, 2000),
(13, 20, 1, 8200),
(14, 14, 2, 900), (14, 13, 1, 1100),
(15, 1, 1, 65000), (15, 6, 1, 1200),
(16, 17, 3, 450), (16, 15, 4, 300),
(17, 4, 2, 2500),
(18, 3, 1, 18000),
(19, 8, 5, 250), (19, 7, 2, 800),
(20, 12, 1, 9500), (20, 11, 1, 3500);
