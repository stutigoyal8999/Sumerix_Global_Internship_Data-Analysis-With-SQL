  --Retail Store Schema (SQLite)
  PRAGMA foreign_keys = ON;

  CREATE TABLE Categories(
    CategoryID INTEGER PRIMARY KEY AUTOINCREMENT,
    CategoryName VARCHAR(50) NOT NULL UNIQUE,
    Description VARCHAR(200)
  );

  CREATE TABLE Suppliers(
    SupplierID INTEGER PRIMARY KEY AUTOINCREMENT,
    SupplierName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    City VARCHAR(50),
    Country VARCHAR(50)
  );

CREATE TABLE Customers(
    CustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    City VARCHAR(50),
    Country VARCHAR(50)
);

CREATE TABLE Employees(
    EmployeeID INTEGER PRIMARY KEY AUTOINCREMENT,
    EmployeeName VARCHAR(100) NOT NULL,
    JobTitle VARCHAR(50),
    HireDate DATE
);

CREATE TABLE Products(
    ProductID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INTEGER NOT NULL,
    SupplierID INTEGER NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    StockQuantity INTEGER DEFAULT 0,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Orders(
    OrderID INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerID INTEGER NOT NULL,
    EmployeeID INTEGER NOT NULL,
    OrderDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Order_Details(
    OrderDetailID INTEGER PRIMARY KEY AUTOINCREMENT,
    OrderID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    Quantity INTEGER NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

