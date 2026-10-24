# Multi-Store Sales Analysis & Business Performance Reporting (Task 2)

Data Analysis with SQL Internship, Sumerix Global.
Advanced SQL on the retail database from Task 1: joins, aggregate functions, GROUP BY, HAVING, set operators and business reports.

## Tools
SQLite, DB Browser for SQLite, Visual Studio Code, Git and GitHub

## Database
`database/retail_store.db` is a copy of the Task 1 database with these additions (see `database/schema_updates.sql`):
- `Employees.ManagerID` for the self join
- `Customers.Region` (North, South, East, West, Central) for regional reports
- 10 extra orders, one customer without orders and one product without sales, so outer joins have something to show

Final data: 30 orders, 21 products, 5 employees, 5 suppliers, 5 categories.

## Project structure
- `database/`: `retail_store.db`, `schema_updates.sql`
- `queries/`: `joins.sql`, `aggregate_functions.sql`, `groupby.sql`, `having.sql`, `set_operators.sql`, `business_reports.sql`
- `screenshots/`: query execution screenshots
- `docs/`: `joins_notes.md`, `sql_best_practices.md`, `project_documentation.md`

## What is covered
- **Joins**: INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS
- **Aggregates**: COUNT, SUM, AVG, MIN, MAX, with revenue, order value, product performance and customer spending
- **GROUP BY**: customer, category, employee, region and monthly reports
- **HAVING**: top customers, high revenue products, strong regions and employees
- **Set operators**: UNION, UNION ALL, INTERSECT, EXCEPT
- **Business reports**: sales summary, customer, product, regional, employee, category, supplier and monthly dashboard reports

## How to run
1. Open `database/retail_store.db` in DB Browser for SQLite.
2. Go to the Execute SQL tab and open a file from `queries/`.
3. Click inside one query and press Shift + F5 to run it.

## Key results
- Total revenue: 447,600 across 30 orders (average order value 14,920)
- Best region: South (43.7% of revenue)
- Best product: Laptop (195,000)
- Best employee: Sunita Rao (155,350)
- Electronics contributes 77.9% of revenue

## Author
Stuti Goyal