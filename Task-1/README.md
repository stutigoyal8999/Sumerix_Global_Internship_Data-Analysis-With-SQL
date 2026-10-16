# Retail Store Database : SQL Fundamentals (Task 1)

Data Analysis with SQL Internship, Sumerix Global.
A relational retail sales database built in SQLite, covering DDL, DML and basic data retrieval.

## Tools
SQLite, DB Browser for SQLite, Visual Studio Code, Git and GitHub

## Database Design
Seven related tables : Categories, Suppliers, Customers, Employees, Products, Orders and Order_Details.
Primary keys, foreign keys and constraints (NOT NULL, UNIQUE, CHECK) are defined in 'database/schema.sql'.

## Project Structure
- 'database/' : 'retail_store.db', 'schema.sql', 'sample_data.sql'
- 'queries/' : 'ddl.sql', 'dml.sql', 'select_queries.sql'
- 'screenshots/' : query execution screenshots
- 'reports/' : business report outputs
- 'docs/' : schema documentation and notes

## How to run
1. Open 'database/retail_store.db' in DB Browser for SQLite.
2. Run 'database/schema.sql' to create the tables (skip this if the tables already exist).
3. Run 'database/sample_data.sql' once to load the data into the tables.
4. Run any query from the 'queries/' folder in the Execute SQL tab in DB browser.

## What is covered
- DDL : CREATE, ALTER, DROP, Constraints
- DML : INSERT, UPDATE, DELETE
- Retrieval : SELECT, WHERE, DISTINCT, ORDER BY, LIMIT, aliases
- Basic reports : low-stock products, top products by price, largest order lines

## Sample data
5 categories, 5 suppliers, 5 employees, 20 customers, 20 products, 20 orders, and 33 order details.

## Author
Stuti Goyal
