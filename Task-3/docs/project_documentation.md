# Project Documentation: Customer Intelligence and Sales Analytics Reporting System

## 1. Objective

Use advanced SQL to turn the Retail Store database into a reporting system that answers business questions about customers, products, regions and sales trends, as required by Task 3 of the Sumerix Global Data Analysis with SQL internship.

## 2. Dataset

The database from Tasks 1 and 2 has seven tables: Categories, Suppliers, Customers, Employees, Products, Orders and Order_Details. Task 2 added a Region column to Customers and a ManagerID column to Employees.

For Task 3, `database/history_data.sql` adds 22 orders (orders 31 to 52, July to December 2025) with matching order details. After this the database has:

| Measure | Value |
| --- | ---: |
| Orders | 52 |
| Customers | 21 (20 have ordered) |
| Products | 21 (20 have sold) |
| Total revenue | 893,700 INR |
| Order period | 8 July 2025 to 18 October 2026 |

## 3. Approach

1. **Setup:** add the history data and confirm the totals.
2. **Subqueries:** answer questions that need one query to feed another.
3. **CTEs:** restructure complex logic into readable steps, including recursive queries.
4. **Views:** create a reusable reporting layer so the order total is calculated in one place.
5. **Window functions:** add totals, running totals, moving averages and period comparisons.
6. **Ranking and CASE:** rank entities and convert numbers into business labels.
7. **Analytical reports:** combine all techniques into 15 reporting queries.
8. **Reports and documentation:** write an executive report for each query file and document the work.
9. **Professional reporting:** five executive reports (segmentation, revenue ranking, product ranking, monthly growth, regional performance) in `professional_reports.sql`.

## 4. Deliverables

| Deliverable | Location |
| --- | --- |
| Updated SQLite database | `database/` |
| Subquery, CTE, view and window function scripts | `queries/` |
| Ranking, CASE and analytical reporting scripts | `queries/` |
| Query execution screenshots | `screenshots/` |
| Executive reports | `reports/` |
| README and documentation | `README.md` and `docs/` |
| Visuals | `docs/visuals.md` |

## 5. Design Decisions

| Decision | Reason |
| --- | --- |
| Create `vw_OrderTotals` | The Orders table has no total column, so every later query reuses this view |
| Add 2025 history data | The original data covered only four months, which blocked year-over-year and regional trend analysis |
| Join to the previous calendar month for growth | LAG would compare July 2026 with December 2025 because the months in between have no data |
| Compare July to October only for regional decline | 2026 has only four months of data |
| Add tiebreakers to ROW_NUMBER | Tied values would otherwise be numbered in an arbitrary order |
| Replace profit status with revenue-target status | The database has no cost data |
| Use MIN and MAX in place of ANY and ALL | SQLite does not support ANY or ALL |
| Drop and recreate views | SQLite does not support ALTER VIEW |

## 6. Challenges and Solutions

| Challenge | Solution |
| --- | --- |
| "View already exists" error when re-running statements | Each view starts with `DROP VIEW IF EXISTS`, and the whole file is run once with Ctrl+Enter |
| Only the last result shows after Ctrl+Enter | Run each query on its own with Shift+F5 (Execute Current Line) |
| A semicolon inside a comment broke statement splitting | Comments contain no semicolons |
| Database file showed as modified in Git after SELECT-only work | DB Browser can rewrite the file on Write Changes or on close, so Write Changes is skipped after SELECT-only sessions and the totals are re-checked |
| `.db-journal` file appeared in the folder | It is a temporary file for unsaved changes and is excluded with `.gitignore` |

## 7. Results Summary

| Area | Result |
| --- | --- |
| Revenue | 893,700 from 52 orders, average order value 17,186.54 |
| Top customer | Priya Singh, 160,500 (18.0% of revenue) |
| Top product | Laptop, 390,000 (43.6% of revenue) |
| Concentration | Top 5 customers 62.4%, top 5 products 82.5% |
| Growth | July to October 2026 is 92.1% above the same period in 2025 |
| Declining regions | West (-86.1%) and Central (-17.0%) |
| Unsold product | Wireless Charger |
| Customer with no orders | Rina Kapoor |
| Low stock | Bookshelf, Study Table, Laptop, Office Chair, Microwave Oven |
| Customer activity | 14 Active, 5 At risk, 1 Inactive, 1 Never ordered |

## 8. Business Recommendations

- Protect the five VIP customers, since they generate 62.4% of revenue.
- Investigate the West region, where revenue fell 86.1% after a large order cluster in 2025 was not repeated.
- Restock the Laptop first, because it is the top seller and has only 15 units left.
- Run a win-back offer for the five At risk customers.
- Review Wireless Charger, which has had no sales.

## 9. Limitations

- The 2025 orders are sample data added for analysis, so growth figures show the method rather than real trading.
- 2026 covers only July to October.
- With 21 customers and 52 orders, percentages move a lot when one order changes.
- No cost data, so profitability cannot be analysed.

## 10. Skills Demonstrated

Subqueries, CTEs (including recursive), views, window functions, ranking functions, CASE logic, growth analysis, segmentation, ABC classification, SQLite compatibility handling, Git and GitHub, and executive reporting.

## 11. Next Task

Task 4 covers database design, normalization, indexing, query optimization, stored procedures, triggers and transactions.
