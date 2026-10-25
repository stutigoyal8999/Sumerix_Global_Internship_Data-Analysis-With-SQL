# Project Documentation (Task 2)

## Business problem
A retail organisation needs SQL reports to monitor sales performance, customer behaviour, employee productivity and regional results.

## Data model
Seven related tables: Categories, Suppliers, Customers, Employees, Products, Orders and Order_Details.
- Categories and Suppliers each have many Products.
- Customers and Employees each have many Orders.
- Orders and Products are linked many-to-many through Order_Details.
- Employees link to themselves through ManagerID.
- Customers carry a Region for regional analysis.

## Work completed
1. Prepared the database with `schema_updates.sql`.
2. Joins: all six join types in `joins.sql`.
3. Aggregates: revenue, order value, product performance and customer spending in `aggregate_functions.sql`.
4. Grouping: customer, category, employee, region and monthly reports in `groupby.sql`.
5. Filtering groups: `having.sql`.
6. Combining results: UNION, UNION ALL, INTERSECT and EXCEPT in `set_operators.sql`.
7. Executive reports in `business_reports.sql`.

## Executive findings
- Total revenue is 447,600 from 30 orders, an average order value of 14,920.
- Average monthly sales are 111,900 over four months. October is the strongest month.
- The South region leads with 43.7% of revenue, followed by the North with 41.7%.
- Electronics accounts for 77.9% of revenue, led by the Laptop at 195,000.
- Sunita Rao is the top employee with 155,350 in sales.
- One customer has never ordered and one product has never sold.

## Outcome
A connected relational database and a reusable set of reporting queries, ready for subqueries, views and window functions in Task 3.

## Visuals
ER diagram, join types comparison, schema diagram, reporting workflow, aggregate function flowchart and internship roadmap: see [visuals.md](visuals.md).
