# SQL Notes (Task 1)

## Database basics
- **Database**: an organised collection of data.
- **DBMS**: software that stores and manages data, often as files.
- **RDBMS**: a DBMS that stores data in related tables and uses SQL (SQLite, MySQL, PostgreSQL).
- **Table**: rows (records) and columns (fields).

## Keys and relationships
- **Primary key**: uniquely identifies each row. It cannot be NULL or repeated.
- **Foreign key**: a column that points to a primary key in another table. It keeps the data consistent.
- **One-to-many**: one customer places many orders.
- **Many-to-many**: orders and products, connected through the Order_Details table.

## Constraints used
| Constraint | Purpose |
|---|---|
| PRIMARY KEY | Unique row identifier |
| FOREIGN KEY | Links two tables |
| NOT NULL | A value is required |
| UNIQUE | No duplicate values (e.g. email) |
| CHECK | Validates a value (e.g. price >= 0) |
| DEFAULT | Value used when none is given |

## SQL command groups
- **DDL** (structure): CREATE, ALTER, DROP
- **DML** (data): INSERT, UPDATE, DELETE
- **DQL** (retrieval): SELECT

## Syntax quick reference
```sql
INSERT INTO Table (col1, col2) VALUES (v1, v2);
UPDATE Table SET col1 = v1 WHERE condition;
DELETE FROM Table WHERE condition;
SELECT DISTINCT col FROM Table WHERE condition ORDER BY col DESC LIMIT 5;
SELECT col AS alias FROM Table;
```
Order of clauses: SELECT, FROM, WHERE, ORDER BY, LIMIT.

## SQLite specifics learned
- There is no CREATE DATABASE. Creating a `.db` file in DB Browser is the equivalent.
- There is no TRUNCATE. `DELETE FROM Table;` without WHERE does the same job.
- AUTOINCREMENT creates the hidden `sqlite_sequence` table, which is normal.
- Foreign keys are enforced only when `PRAGMA foreign_keys = ON;` is set.
- A `.db-journal` file appears while changes are unsaved. Write changes and it disappears.

## Practical lessons
- Always use WHERE with UPDATE and DELETE, or every row is affected.
- Insert parent tables (Categories, Suppliers, Customers) before child tables (Products, Orders).
- A parent row cannot be deleted while child rows still reference it.
- When several statements run together, DB Browser shows only the last result. Run one at a time.
- Keep DDL, DML and SELECT queries in separate script files.
- Test scripts before submitting, and commit to Git after each step.