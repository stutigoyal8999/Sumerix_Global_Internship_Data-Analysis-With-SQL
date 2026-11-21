# Visuals

The diagrams below use Mermaid, which renders on GitHub. In VS Code they show only with a Mermaid preview extension.

## 1. Advanced SQL Query Workflow

```mermaid
flowchart LR
    A["Raw tables<br/>Customers, Orders, Order_Details, Products"] --> B["Views<br/>vw_OrderTotals and others"]
    B --> C["CTEs<br/>readable steps"]
    C --> D["Window functions<br/>running totals, LAG, rankings"]
    D --> E["CASE logic<br/>business labels"]
    E --> F["Analytical reports<br/>KPIs, growth, segments"]
    F --> G["Executive reports<br/>markdown in the reports folder"]
```

## 2. CTE Execution Flow

The example is the average order value query (query 3 in `cte_queries.sql`).

```mermaid
flowchart TD
    A["WITH OrderTotals AS<br/>order total per order"] --> B["CustomerSummary AS<br/>orders, total spent, average per customer"]
    B --> C["Final SELECT<br/>join to Customers and sort by total spent"]
    C --> D["Result: top 5 customers with average order value"]
```

Each CTE can use the ones defined before it. The CTEs exist only while the final statement runs.

## 3. Window Functions: OVER, PARTITION BY and ORDER BY

```mermaid
flowchart TD
    A["SUM Revenue OVER PARTITION BY SalesYear ORDER BY Month"] --> B["PARTITION BY<br/>splits rows into groups: 2025 and 2026"]
    B --> C["ORDER BY<br/>sorts months inside each group"]
    C --> D["Frame<br/>first row of the group up to the current row"]
    D --> E["Result<br/>running total that restarts each year"]
```

Result from `window_functions.sql` (query 6):

| Year | Month | Revenue | Year to date |
| --- | --- | ---: | ---: |
| 2025 | 2025-07 | 92,000 | 92,000 |
| 2025 | 2025-08 | 34,500 | 126,500 |
| 2025 | 2025-12 | 122,200 | 446,100 |
| 2026 | 2026-07 | 100,800 | 100,800 |
| 2026 | 2026-10 | 152,500 | 447,600 |

The total restarts at 100,800 when the partition changes from 2025 to 2026.

## 4. Ranking Functions Comparison

Customers ordered by number of orders (from `ranking.sql`, query 2):

| Customer | Orders | ROW_NUMBER | RANK | DENSE_RANK |
| --- | ---: | ---: | ---: | ---: |
| Rahul Sharma | 6 | 1 | 1 | 1 |
| Vikram Rao | 5 | 2 | 2 | 2 |
| Arjun Mehta | 4 | 3 | 3 | 3 |
| Priya Singh | 4 | 4 | 3 | 3 |
| Pooja Reddy | 3 | 5 | 5 | 4 |
| Rohit Verma | 3 | 6 | 5 | 4 |
| Amit Kumar | 2 | 7 | 7 | 5 |

```mermaid
flowchart LR
    A["Tied values"] --> B["ROW_NUMBER<br/>always unique: 3, 4"]
    A --> C["RANK<br/>same rank, then a gap: 3, 3, 5"]
    A --> D["DENSE_RANK<br/>same rank, no gap: 3, 3, 4"]
    A --> E["NTILE n<br/>splits rows into n equal groups"]
```

NTILE(4) on customer spending gives five customers in each quartile. Quartile 1 holds everyone who spent 80,100 or more.

## 5. Customer Segmentation Flow Using CASE

The CASE expression is checked from top to bottom and the first match wins.

```mermaid
flowchart TD
    A["Customer total spent"] --> B{"100,000 or more?"}
    B -- Yes --> P["Premium: 3 customers"]
    B -- No --> C{"50,000 or more?"}
    C -- Yes --> G["Gold: 2 customers"]
    C -- No --> D{"20,000 or more?"}
    D -- Yes --> S["Silver: 9 customers"]
    D -- No --> R["Regular: 6 customers"]
```

## 6. SQL Internship Progress Roadmap

```mermaid
flowchart LR
    T1["Task 1<br/>Database creation and basic queries<br/>Done"] --> T2["Task 2<br/>Joins, aggregation, grouping<br/>Done"]
    T2 --> T3["Task 3<br/>Advanced SQL and analytical reporting<br/>Done"]
    T3 --> T4["Task 4<br/>Design, normalization, indexing, procedures, triggers, transactions<br/>Next"]
    T4 --> T5["Task 5<br/>Upcoming"]
    T5 --> T6["Task 6<br/>Upcoming"]
```