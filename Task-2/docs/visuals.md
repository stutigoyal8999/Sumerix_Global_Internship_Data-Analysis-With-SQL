# Visuals (Task 2)

## 1. Relational Database ER Diagram

```mermaid
erDiagram
    CATEGORIES ||--o{ PRODUCTS : "classifies"
    SUPPLIERS ||--o{ PRODUCTS : "supplies"
    CUSTOMERS ||--o{ ORDERS : "places"
    EMPLOYEES ||--o{ ORDERS : "handles"
    ORDERS ||--|{ ORDER_DETAILS : "contains"
    PRODUCTS ||--o{ ORDER_DETAILS : "appears in"
    EMPLOYEES ||--o{ EMPLOYEES : "manages"
```

## 2. SQL Join Types Comparison

Which rows each join returns, where A is the left table and B is the right table:

| Join | Rows only in A | Matching rows | Rows only in B |
|---|---|---|---|
| INNER JOIN | No | Yes | No |
| LEFT JOIN | Yes | Yes | No |
| RIGHT JOIN | No | Yes | Yes |
| FULL OUTER JOIN | Yes | Yes | Yes |

| Join | Behaviour | Example in this project |
|---|---|---|
| SELF JOIN | A table joined to itself | Each employee with their manager |
| CROSS JOIN | Every row paired with every row | Every employee with every category |

Choosing a join:

```mermaid
flowchart TD
    A{Which rows do you need?} -->|Only matching rows| B[INNER JOIN]
    A -->|All rows from the left table| C[LEFT JOIN]
    A -->|All rows from the right table| D[RIGHT JOIN]
    A -->|All rows from both tables| E[FULL OUTER JOIN]
    A -->|Table compared with itself| F[SELF JOIN]
    A -->|Every possible combination| G[CROSS JOIN]
```

## 3. Retail Database Schema Diagram

```mermaid
erDiagram
    CATEGORIES {
        INTEGER CategoryID PK
        VARCHAR CategoryName
        VARCHAR Description
    }
    SUPPLIERS {
        INTEGER SupplierID PK
        VARCHAR SupplierName
        VARCHAR Phone
        VARCHAR City
        VARCHAR Country
    }
    CUSTOMERS {
        INTEGER CustomerID PK
        VARCHAR CustomerName
        VARCHAR Email
        VARCHAR City
        VARCHAR Country
        VARCHAR Region
    }
    EMPLOYEES {
        INTEGER EmployeeID PK
        VARCHAR EmployeeName
        VARCHAR JobTitle
        DATE HireDate
        INTEGER ManagerID FK
    }
    PRODUCTS {
        INTEGER ProductID PK
        VARCHAR ProductName
        INTEGER CategoryID FK
        INTEGER SupplierID FK
        DECIMAL Price
        INTEGER StockQuantity
    }
    ORDERS {
        INTEGER OrderID PK
        INTEGER CustomerID FK
        INTEGER EmployeeID FK
        DATE OrderDate
    }
    ORDER_DETAILS {
        INTEGER OrderDetailID PK
        INTEGER OrderID FK
        INTEGER ProductID FK
        INTEGER Quantity
        DECIMAL UnitPrice
    }
    CATEGORIES ||--o{ PRODUCTS : "has"
    SUPPLIERS ||--o{ PRODUCTS : "supplies"
    CUSTOMERS ||--o{ ORDERS : "places"
    EMPLOYEES ||--o{ ORDERS : "handles"
    ORDERS ||--|{ ORDER_DETAILS : "contains"
    PRODUCTS ||--o{ ORDER_DETAILS : "sold in"
    EMPLOYEES ||--o{ EMPLOYEES : "manages"
```

## 4. Business Reporting Workflow

```mermaid
flowchart LR
    A[(retail_store.db)] --> B[SQL query<br/>JOIN, GROUP BY, HAVING]
    B --> C[Execute SQL<br/>in DB Browser]
    C --> D[Result table]
    D --> E[Business report<br/>sales, customers, products,<br/>regions, employees]
    E --> F[Management decisions]
```

## 5. Aggregate Function Flowchart

```mermaid
flowchart TD
    A[Rows from a table or join] --> B{What do you need?}
    B -->|How many rows| C["COUNT()"]
    B -->|Total of values| D["SUM()"]
    B -->|Average value| E["AVG()"]
    B -->|Smallest value| F["MIN()"]
    B -->|Largest value| G["MAX()"]
    C & D & E & F & G --> H{Calculate per group?}
    H -->|No| I[One value for the whole result]
    H -->|Yes| J[GROUP BY]
    J --> K{Filter the groups?}
    K -->|Yes| L[HAVING]
    K -->|No| M[Final report]
    L --> M
    I --> M
```

## 6. SQL Internship Progress Roadmap

```mermaid
flowchart TD
    T1["Task 1<br/>SQL fundamentals, DDL, DML, basic queries"]
    T2["Task 2<br/>Joins, aggregates, GROUP BY, HAVING, reports"]
    T3["Task 3<br/>Subqueries, views, CTEs, window functions"]
    T4["Task 4<br/>Database design, normalization, indexes, triggers"]
    T5["Task 5<br/>Performance, advanced reporting, case studies"]
    T6["Task 6<br/>Enterprise retail data warehouse capstone"]
    T1 --> T2 --> T3 --> T4 --> T5 --> T6
    classDef done fill:#c8e6c9,stroke:#2e7d32,color:#000
    class T1,T2 done
```

Green tasks are complete.