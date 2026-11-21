# Executive Report: CTE Analysis

**Source query file:** `queries/cte_queries.sql`  
**Database:** Retail Store (SQLite), orders from 8 July 2025 to 18 October 2026  
**Amounts:** Indian rupees (INR)

This report uses Common Table Expressions to break larger questions into readable steps, from single CTEs to multi-step pipelines and two recursive CTEs (a reporting hierarchy and a month calendar).

## Executive Summary

- Three customers (Priya Singh, Vikram Rao, Rahul Sharma) each exceed 100,000 and together generate 390,900, which is 43.7% of revenue.
- Six of the ten recorded months beat the monthly average of 89,370. October 2026 is the strongest at 152,500.
- Sunita Rao leads the sales team with 383,050 against a team average of 223,425.
- The recursive calendar exposes six months (January to June 2026) with zero revenue that a plain GROUP BY would hide.

## Detailed Results

### 1. Single CTE: customers with total sales above 100000

| Customer Name | Total Sales |
| --- | ---: |
| Priya Singh | 160,500 |
| Vikram Rao | 121,100 |
| Rahul Sharma | 109,300 |

**Finding:** Priya Singh (160,500), Vikram Rao (121,100) and Rahul Sharma (109,300) are the only customers above 100,000, with 390,900 combined.

### 2. Single CTE: months where revenue was above the monthly average

| Month | Revenue |
| --- | ---: |
| 2026-10 | 152,500 |
| 2026-09 | 144,600 |
| 2025-12 | 122,200 |
| 2026-07 | 100,800 |
| 2025-07 | 92,000 |
| 2025-11 | 90,900 |

**Finding:** Six months beat the monthly average of 89,370. October 2026 (152,500) and September 2026 (144,600) lead, followed by December 2025 (122,200).

### 3. Multiple CTEs: average order value per customer

| Customer Name | Orders Placed | Total Spent | Avg Order Value |
| --- | ---: | ---: | ---: |
| Priya Singh | 4 | 160,500 | 40,125 |
| Vikram Rao | 5 | 121,100 | 24,220 |
| Rahul Sharma | 6 | 109,300 | 18,216.67 |
| Karan Malhotra | 2 | 86,700 | 43,350 |
| Arjun Mehta | 4 | 80,100 | 20,025 |

*Top 5 customers by total spent.*

**Finding:** Karan Malhotra has the highest average order value (43,350) from only 2 orders, ahead of Priya Singh (40,125). Rahul Sharma places the most orders (6) at a much lower average of 18,216.67.

### 4. Multiple CTEs: each product's share of its category revenue

| Category Name | Product Name | Revenue | Share (%) |
| --- | --- | ---: | ---: |
| Accessories | Headphones | 18,000 | 45.4 |
| Accessories | Keyboard | 7,300 | 18.4 |
| Accessories | Laptop Bag | 6,000 | 15.1 |
| Accessories | Mouse | 5,600 | 14.1 |
| Accessories | USB Cable | 2,750 | 6.9 |
| Electronics | Laptop | 390,000 | 54.4 |
| Electronics | Smartphone | 175,000 | 24.4 |
| Electronics | Tablet | 108,000 | 15.1 |
| Electronics | Smart Watch | 24,000 | 3.3 |
| Electronics | Bluetooth Speaker | 20,000 | 2.8 |

*First 10 rows, covering Accessories and Electronics.*

**Finding:** Laptop produces 54.4% of Electronics revenue and Headphones 45.4% of Accessories revenue. Each category depends heavily on one product.

### 5. Modular query: each employee's sales compared with the team average

| Employee Name | Total Sales | Team Average | Performance |
| --- | ---: | ---: | --- |
| Sunita Rao | 383,050 | 223,425 | Above average |
| Rajesh Khanna | 246,200 | 223,425 | Above average |
| Nisha Thakur | 176,100 | 223,425 | Below average |
| Vivek Anand | 88,350 | 223,425 | Below average |

**Finding:** Sunita Rao (383,050) and Rajesh Khanna (246,200) are above the team average of 223,425. Nisha Thakur (176,100) and Vivek Anand (88,350) are below it. The store manager is excluded because she handles no orders.

### 6. Readability: the nested subquery from subqueries.sql rewritten with CTEs

| Customer Name | Total Spent |
| --- | ---: |
| Priya Singh | 160,500 |
| Vikram Rao | 121,100 |
| Rahul Sharma | 109,300 |
| Karan Malhotra | 86,700 |
| Arjun Mehta | 80,100 |
| Rohit Verma | 46,200 |

**Finding:** The result is identical to the nested subquery in subqueries.sql (six customers above the average), but the CTE version reads top to bottom and is easier to maintain.

### 7. Recursive CTE: employee reporting hierarchy

| Level | Employee Name | Job Title | Reporting Path |
| ---: | --- | --- | --- |
| 1 | Aarti Kapoor | Store Manager | Aarti Kapoor |
| 2 | Rajesh Khanna | Sales Executive | Aarti Kapoor > Rajesh Khanna |
| 2 | Sunita Rao | Sales Executive | Aarti Kapoor > Sunita Rao |
| 3 | Nisha Thakur | Sales Associate | Aarti Kapoor > Rajesh Khanna > Nisha Thakur |
| 3 | Vivek Anand | Cashier | Aarti Kapoor > Rajesh Khanna > Vivek Anand |

**Finding:** The hierarchy has three levels. Aarti Kapoor manages Rajesh Khanna and Sunita Rao, and Rajesh Khanna manages Nisha Thakur and Vivek Anand.

### 8. Recursive CTE: month calendar so that months without sales show as zero

| Month | Revenue |
| --- | ---: |
| 2025-07 | 92,000 |
| 2025-08 | 34,500 |
| 2025-09 | 56,800 |
| 2025-10 | 49,700 |
| 2025-11 | 90,900 |
| 2025-12 | 122,200 |
| 2026-01 | 0 |
| 2026-02 | 0 |
| 2026-03 | 0 |
| 2026-04 | 0 |
| 2026-05 | 0 |
| 2026-06 | 0 |
| 2026-07 | 100,800 |
| 2026-08 | 49,700 |
| 2026-09 | 144,600 |
| 2026-10 | 152,500 |

**Finding:** The calendar covers 16 months. January to June 2026 appear with zero revenue because no orders were recorded, which keeps trend charts honest.

