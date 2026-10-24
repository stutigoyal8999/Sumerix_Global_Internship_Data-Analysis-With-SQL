# Joins Notes

A join combines rows from two tables using a matching column, usually a foreign key matched to a primary key.

| Join | Returns | Example in this project |
|---|---|---|
| INNER JOIN | Only rows that match in both tables | Orders with their customers |
| LEFT JOIN | All rows from the left table plus matches | All customers, even those with no orders |
| RIGHT JOIN | All rows from the right table plus matches | All products, even those never sold |
| FULL OUTER JOIN | All rows from both tables | All customers and all orders, matched or not |
| SELF JOIN | A table joined to itself | Each employee with their manager |
| CROSS JOIN | Every combination of rows | Every employee paired with every category |

## Finding missing matches
A LEFT JOIN followed by `WHERE right_table.key IS NULL` finds rows with no match:
- Customers who never ordered: Rina Kapoor
- Products that never sold: Wireless Charger

## Notes
- Always join on the correct key columns, and use table aliases in multi-table queries.
- Many-to-many relationships need a link table: orders and products connect through Order_Details.
- RIGHT and FULL OUTER JOIN need SQLite 3.39 or later. On older versions, swap the table order with a LEFT JOIN, or combine two LEFT JOINs with UNION.
- NULL values do not match each other in a join condition.