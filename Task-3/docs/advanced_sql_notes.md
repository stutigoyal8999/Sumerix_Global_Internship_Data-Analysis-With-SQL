# Advanced SQL Notes

Short reference notes for each topic in Task 3, with a pattern and the example used in this project.

## 1. Subqueries

A subquery is a query inside another query.

| Type | Returns | Example from this project |
| --- | --- | --- |
| Scalar | One value | Products priced above `(SELECT AVG(Price) FROM Products)` |
| Multi-row (IN, NOT IN) | A list | Customers whose `CustomerID IN (SELECT ... WHERE order total > 50000)` |
| EXISTS, NOT EXISTS | True or false | Customers with no orders: `NOT EXISTS (SELECT 1 FROM Orders ...)` |
| Correlated | Runs once per outer row | Products priced above the average of their own category |
| Nested | A subquery inside a subquery | Customers who spent more than the average customer |

```sql
SELECT ProductName, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);
```

Points to remember:
- NOT IN returns no rows if the list contains a NULL, so NOT EXISTS is safer.
- A correlated subquery references the outer table and re-runs for every row, so it is slower on large tables.
- SQLite has no ANY or ALL. `> ANY (list)` becomes `> (SELECT MIN(...))` and `> ALL (list)` becomes `> (SELECT MAX(...))`.

## 2. Common Table Expressions (CTEs)

A CTE is a named temporary result defined with WITH. It makes a long query read from top to bottom.

```sql
WITH CustomerTotals AS (
    SELECT CustomerID, SUM(OrderTotal) AS TotalSales
    FROM vw_OrderTotals
    GROUP BY CustomerID
)
SELECT * FROM CustomerTotals WHERE TotalSales > 100000;
```

- Several CTEs can be chained with commas, and a later CTE can use an earlier one.
- A **recursive CTE** has an anchor part, then `UNION ALL`, then a recursive part that references the CTE itself. It was used for the employee reporting hierarchy and for a month calendar that shows months without sales as zero.
- A CTE exists only for the one statement that follows it.

## 3. Views

A view is a saved SELECT that behaves like a table.

```sql
CREATE VIEW vw_OrderTotals AS
SELECT o.OrderID, o.CustomerID, SUM(od.Quantity * od.UnitPrice) AS OrderTotal
FROM Orders o
INNER JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.CustomerID;
```

- Views store the query, not the data, so they always show current results.
- Views can be built on other views (`vw_CustomerSales` uses `vw_OrderTotals`).
- Changing a view in SQLite: `DROP VIEW IF EXISTS name;` then `CREATE VIEW name AS ...`.
- Removing a view: `DROP VIEW name;`.
- Benefits: one definition of a business rule, simpler queries and a stable reporting layer.
- The Orders table has no total column, so `vw_OrderTotals` supplies the order total that the later queries need.

## 4. Window Functions

A window function calculates across a set of rows related to the current row without collapsing them into one row like GROUP BY.

```sql
function() OVER (
    PARTITION BY column      -- optional, restarts the calculation per group
    ORDER BY column          -- optional, sets the order inside the group
    ROWS BETWEEN ...         -- optional, sets the frame
)
```

| Function | Use |
| --- | --- |
| `SUM() OVER ()` | Grand total next to every row |
| `SUM() OVER (PARTITION BY ...)` | Group total next to every row |
| `SUM() OVER (ORDER BY ...)` | Running total |
| `AVG() OVER (ORDER BY ... ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)` | Three-row moving average |
| `LAG(col)` and `LEAD(col)` | Previous and next row value |
| `WINDOW w AS (...)` | Named window reused by several functions |

Points to remember:
- LAG and LEAD work on the previous or next **row**, not the previous calendar month. Calendar-aware growth needs a self-join on the previous month.
- With ORDER BY and no frame, the default frame runs from the first row to the current row.

## 5. Ranking Functions

| Function | Ties | Gaps after ties |
| --- | --- | --- |
| `ROW_NUMBER()` | Different numbers (needs a tiebreaker for repeatable results) | No |
| `RANK()` | Same rank | Yes (1, 1, 3) |
| `DENSE_RANK()` | Same rank | No (1, 1, 2) |
| `NTILE(n)` | Splits rows into n roughly equal groups | Not applicable |

Example from the project: customers by number of orders. Arjun Mehta and Priya Singh tie at 4 orders. They get ROW_NUMBER 3 and 4, but RANK 3 and 3, and the next customers get RANK 5 and DENSE_RANK 4.

Top N per group uses ROW_NUMBER with PARTITION BY inside a CTE, then filters `WHERE rank <= N`.

## 6. CASE Expressions

CASE adds if-then logic to SQL and is checked from top to bottom, so the first match wins.

```sql
CASE
    WHEN TotalSpent >= 100000 THEN 'Premium'
    WHEN TotalSpent >= 50000  THEN 'Gold'
    WHEN TotalSpent >= 20000  THEN 'Silver'
    ELSE 'Regular'
END AS CustomerCategory
```

- Put the most restrictive condition first.
- Always add an ELSE, otherwise unmatched rows return NULL.
- CASE can also sit inside an aggregate (`SUM(CASE WHEN year = '2025' THEN amount ELSE 0 END)`) to pivot values into columns.

## 7. SQLite Compatibility Summary

| Feature | Status in SQLite |
| --- | --- |
| Window functions | Supported from 3.25 |
| Named WINDOW clause | Supported from 3.28 |
| ANY and ALL | Not supported, use MIN and MAX |
| ALTER VIEW | Not supported, drop and recreate |
| TRUNCATE | Not supported, use DELETE |
| Recursive CTE | Supported |

## 8. Git Tracking

```powershell
git add .
git commit -m "Add Task 3 documentation"
git push
```