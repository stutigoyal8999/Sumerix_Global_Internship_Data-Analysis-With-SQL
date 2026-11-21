# Task 3: Advanced SQL Programming and Analytical Reporting

**Internship:** Sumerix Global, Data Analysis with SQL  
**Mini project:** Customer Intelligence and Sales Analytics Reporting System  
**Tools:** SQLite, DB Browser for SQLite, VS Code, Git and GitHub

## Overview

This task builds on the Retail Store database from Tasks 1 and 2. It uses advanced SQL (subqueries, CTEs, views, window functions, ranking functions and CASE expressions) to turn order data into customer, product, regional and trend insights, and finishes with a set of analytical reports.

The database now holds 52 orders (July 2025 to October 2026) and total revenue of 893,700 INR. Orders from July to December 2025 were added in `database/history_data.sql` so that month-over-month, year-over-year and regional trend analysis is possible.

## Folder Structure

```text
Task-3/
├── database/
│   ├── (SQLite database file)
│   └── history_data.sql
├── queries/
│   ├── subqueries.sql
│   ├── cte_queries.sql
│   ├── views.sql
│   ├── window_functions.sql
│   ├── ranking.sql
│   ├── case_statements.sql
│   └── analytical_reports.sql
├── reports/
│   ├── subqueries_report.md
│   ├── cte_queries_report.md
│   ├── views_report.md
│   ├── window_functions_report.md
│   ├── ranking_report.md
│   ├── case_statements_report.md
│   └── customer_intelligence_report.md
├── screenshots/
├── docs/
│   ├── advanced_sql_notes.md
│   ├── analytical_sql.md
│   ├── project_documentation.md
│   └── visuals.md
├── .gitignore
└── README.md
```

## How to Run

1. Open the Task 3 database in DB Browser for SQLite.
2. Run `database/history_data.sql` once (Ctrl+Enter), then press Write Changes (Ctrl+S).
3. Run `queries/views.sql` once to create the views, then press Write Changes. Every other query file depends on these views.
4. Open any other query file and run one query at a time with Shift+F5 (Execute Current Line). Ctrl+Enter runs the whole file but shows only the last result.
5. Query files that only contain SELECT statements do not change the database, so there is no need to press Write Changes after them.

Quick check after step 2: 52 orders and revenue of 893,700. After step 3: 7 views.

## Query Files

| File | Topic | Queries |
| --- | --- | ---: |
| `subqueries.sql` | Scalar, multi-row, correlated and nested subqueries, EXISTS, NOT EXISTS, ANY and ALL equivalents | 12 |
| `cte_queries.sql` | Single and multiple CTEs, recursive hierarchy, recursive month calendar | 8 |
| `views.sql` | Seven reporting views, querying and joining views, ALTER VIEW workaround, DROP VIEW | 7 views plus 11 result queries |
| `window_functions.sql` | OVER, PARTITION BY, running totals, moving average, LAG, LEAD, named windows | 10 |
| `ranking.sql` | ROW_NUMBER, RANK, DENSE_RANK, NTILE, rankings by month, employee and region | 10 |
| `case_statements.sql` | Customer tiers, order sizes, price bands, performance, stock and activity status | 10 |
| `analytical_reports.sql` | KPIs, top 10 percent, growth, top and bottom N, segmentation, lifetime value, ABC classification | 15 |
| `professional_reports.sql` | Professional reports: customer segmentation, revenue ranking, product ranking, monthly growth, regional performance | 5 |

## Views

| View | Purpose |
| --- | --- |
| `vw_OrderTotals` | One row per order with line items and order total |
| `vw_CustomerSales` | Orders, total spent and first and last order date per customer |
| `vw_ProductSales` | Units sold and revenue per product |
| `vw_MonthlySales` | Orders, revenue, average order value and customers per month |
| `vw_RegionalSales` | Orders and revenue by region and year |
| `vw_EmployeeSales` | Orders handled and total sales per employee |
| `vw_TopCustomers` | High-value customers |

## Key Findings

- Total revenue is **893,700** from **52 orders** and **20 active customers**. Average order value is **17,186.54**.
- **Laptop** is the top product (43.6% of revenue). The top five products generate 82.5% of revenue.
- **Priya Singh** is the top customer (160,500). The five VIP customers generate 62.4% of revenue.
- July to October revenue grew **92.1%** year over year (233,000 to 447,600).
- **West** (-86.1%) and **Central** (-17.0%) are the only regions with declining sales.
- **Wireless Charger** has never been sold and **Rina Kapoor** has never ordered.
- Five products are on low stock, including the top-selling Laptop (15 units).

The full results are in the `reports` folder. The main report is `customer_intelligence_report.md`.

## SQLite Notes

- SQLite has no ANY or ALL operators, so they are written with MIN and MAX.
- SQLite has no ALTER VIEW, so a view is changed with DROP VIEW and CREATE VIEW.
- Window functions need SQLite 3.25 or later and the named WINDOW clause needs 3.28 or later.
- The database has no cost data, so the CASE task on profit status is implemented as a status against a monthly revenue target.

## Documentation

- [Advanced SQL notes](docs/advanced_sql_notes.md)
- [Analytical SQL notes](docs/analytical_sql.md)
- [Project documentation](docs/project_documentation.md)
- [Visuals](docs/visuals.md)