# Database Design
Documenting the database schema

## Tables 
- **Categories** : CategoryID (PK), CategoryName, Description
- **Suppliers** : SupplierID (PK), SupplierName, Phone, City, Country
- **Customers** : CustomerID (PK), CustomerName, Email, City, Country
- **Employees** : EmployeeID (PK), EmployeeName, JobTitle, HireDate
- **Products** : ProductID (PK), ProductName, CategoryID (FK), SupplierID (FK), Price, StockQuantity
- **Orders** : OrderID (PK), CustomerID (FK), EmployeeID (FK), OrderDate
- **Order_Details** : OrderDetailID (PK), OrderID (FK), ProductID (FK), Quantity, UnitPrice

## Relationships
- One category has many products.
- One supplier has many products.
- One customerplaces many orders.
- One employee handles many orders.
- Orders and products are many-to-many, linked through Order_Details.

## Constraints
NOT NULL on names and dates, UNIQUE on category name and customer email, CHECK on price (not negative) and order quantity (positive).