# Executive Report: Window Function Analysis

**Source query file:** `queries/window_functions.sql`  
**Database:** Retail Store (SQLite), orders from 8 July 2025 to 18 October 2026  
**Amounts:** Indian rupees (INR)

This report uses window functions (OVER, PARTITION BY, ORDER BY, running totals, moving averages, LAG, LEAD and a named window) to add totals, shares and trends to each row without collapsing the data.

## Executive Summary

- No single order exceeds 7.4% of total revenue of 893,700, so revenue does not depend on any one order.
- In four months, 2026 reached year-to-date revenue of 447,600, which already exceeds the 446,100 earned across all six recorded months of 2025.
- The latest three-month moving average (115,600) is the highest in the series.
- The largest monthly swing upward is +94,900 in September 2026, and the largest drop is -57,500 in August 2025.

## Detailed Results

### 1. OVER(): each order next to the grand total, with its share of all revenue

| Order ID | Order Date | Order Total | Grand Total | Share (%) |
| ---: | --- | ---: | ---: | ---: |
| 15 | 2026-09-27 | 66,200 | 893,700 | 7.41 |
| 1 | 2026-07-05 | 65,800 | 893,700 | 7.36 |
| 26 | 2026-10-06 | 65,000 | 893,700 | 7.27 |
| 31 | 2025-07-08 | 65,000 | 893,700 | 7.27 |
| 44 | 2025-11-04 | 65,000 | 893,700 | 7.27 |

*Top 5 orders by order total.*

**Finding:** Every order is shown next to the grand total of 893,700. The largest order (Order 15, 66,200) is 7.41% of revenue.

### 2. PARTITION BY category: each product's share of its category revenue

| Category Name | Product Name | Revenue | Category Revenue | Share Of Category (%) |
| --- | --- | ---: | ---: | ---: |
| Accessories | Headphones | 18,000 | 39,650 | 45.4 |
| Accessories | Keyboard | 7,300 | 39,650 | 18.4 |
| Accessories | Laptop Bag | 6,000 | 39,650 | 15.1 |
| Accessories | Mouse | 5,600 | 39,650 | 14.1 |
| Accessories | USB Cable | 2,750 | 39,650 | 6.9 |
| Electronics | Laptop | 390,000 | 717,000 | 54.4 |
| Electronics | Smartphone | 175,000 | 717,000 | 24.4 |
| Electronics | Tablet | 108,000 | 717,000 | 15.1 |
| Electronics | Smart Watch | 24,000 | 717,000 | 3.3 |
| Electronics | Bluetooth Speaker | 20,000 | 717,000 | 2.8 |

**Finding:** Laptop makes up 54.4% of Electronics revenue and Headphones 45.4% of Accessories revenue. The same numbers as the CTE report, produced without a separate summary step.

### 3. PARTITION BY customer: every order with the customer's order count and total spending

| Customer Name | Order ID | Order Date | Order Total | Customer Orders | Customer Total |
| --- | ---: | --- | ---: | ---: | ---: |
| Priya Singh | 44 | 2025-11-04 | 65,000 | 4 | 160,500 |
| Priya Singh | 2 | 2026-07-12 | 25,500 | 4 | 160,500 |
| Priya Singh | 22 | 2026-09-02 | 5,000 | 4 | 160,500 |
| Priya Singh | 26 | 2026-10-06 | 65,000 | 4 | 160,500 |
| Vikram Rao | 36 | 2025-09-04 | 25,000 | 5 | 121,100 |
| Vikram Rao | 49 | 2025-12-10 | 65,000 | 5 | 121,100 |
| Vikram Rao | 5 | 2026-08-02 | 5,700 | 5 | 121,100 |
| Vikram Rao | 24 | 2026-09-20 | 18,000 | 5 | 121,100 |
| Vikram Rao | 30 | 2026-10-18 | 7,400 | 5 | 121,100 |
| Rahul Sharma | 40 | 2025-10-06 | 25,800 | 6 | 109,300 |

*First 10 rows.*

**Finding:** Each order carries the customer's order count and lifetime total. Priya Singh has 4 orders totalling 160,500 and Vikram Rao has 5 orders totalling 121,100.

### 4. ORDER BY within OVER: running revenue across orders in date order

| Order ID | Order Date | Order Total | Running Revenue |
| ---: | --- | ---: | ---: |
| 31 | 2025-07-08 | 65,000 | 65,000 |
| 32 | 2025-07-20 | 27,000 | 92,000 |
| 33 | 2025-08-05 | 19,500 | 111,500 |
| 34 | 2025-08-18 | 13,000 | 124,500 |
| 35 | 2025-08-27 | 2,000 | 126,500 |
| 36 | 2025-09-04 | 25,000 | 151,500 |
| 37 | 2025-09-12 | 20,500 | 172,000 |
| 38 | 2025-09-21 | 8,400 | 180,400 |
| 39 | 2025-09-28 | 2,900 | 183,300 |
| 40 | 2025-10-06 | 25,800 | 209,100 |

*First 10 orders in date order.*

**Finding:** Running revenue passes 209,100 after the tenth order (6 October 2025). The running total grows with each order in date order.

### 5. Running total by month

| Month | Revenue | Running Revenue |
| --- | ---: | ---: |
| 2025-07 | 92,000 | 92,000 |
| 2025-08 | 34,500 | 126,500 |
| 2025-09 | 56,800 | 183,300 |
| 2025-10 | 49,700 | 233,000 |
| 2025-11 | 90,900 | 323,900 |
| 2025-12 | 122,200 | 446,100 |
| 2026-07 | 100,800 | 546,900 |
| 2026-08 | 49,700 | 596,600 |
| 2026-09 | 144,600 | 741,200 |
| 2026-10 | 152,500 | 893,700 |

**Finding:** Cumulative revenue reaches 446,100 at the end of 2025 and 893,700 in October 2026.

### 6. Running total restarting each year (PARTITION BY plus ORDER BY)

| Sales Year | Month | Revenue | Year To Date Revenue |
| --- | --- | ---: | ---: |
| 2025 | 2025-07 | 92,000 | 92,000 |
| 2025 | 2025-08 | 34,500 | 126,500 |
| 2025 | 2025-09 | 56,800 | 183,300 |
| 2025 | 2025-10 | 49,700 | 233,000 |
| 2025 | 2025-11 | 90,900 | 323,900 |
| 2025 | 2025-12 | 122,200 | 446,100 |
| 2026 | 2026-07 | 100,800 | 100,800 |
| 2026 | 2026-08 | 49,700 | 150,500 |
| 2026 | 2026-09 | 144,600 | 295,100 |
| 2026 | 2026-10 | 152,500 | 447,600 |

**Finding:** The running total restarts each year. 2025 ends at 446,100 after six months, while 2026 reaches 447,600 after only four.

### 7. Moving average and rolling sum over the latest 3 recorded months

| Month | Revenue | Moving Avg (3 Months) | Rolling Sum (3 Months) |
| --- | ---: | ---: | ---: |
| 2025-07 | 92,000 | 92,000 | 92,000 |
| 2025-08 | 34,500 | 63,250 | 126,500 |
| 2025-09 | 56,800 | 61,100 | 183,300 |
| 2025-10 | 49,700 | 47,000 | 141,000 |
| 2025-11 | 90,900 | 65,800 | 197,400 |
| 2025-12 | 122,200 | 87,600 | 262,800 |
| 2026-07 | 100,800 | 104,633.33 | 313,900 |
| 2026-08 | 49,700 | 90,900 | 272,700 |
| 2026-09 | 144,600 | 98,366.67 | 295,100 |
| 2026-10 | 152,500 | 115,600 | 346,800 |

**Finding:** The latest three-month average is 115,600 (August to October 2026), the highest in the series. Because January to June 2026 has no data, the July 2026 average includes October to December 2025.

### 8. LAG: previous recorded month and the change in revenue

| Month | Revenue | Previous Month Revenue | Change |
| --- | ---: | ---: | ---: |
| 2025-07 | 92,000 | NULL | NULL |
| 2025-08 | 34,500 | 92,000 | -57,500 |
| 2025-09 | 56,800 | 34,500 | 22,300 |
| 2025-10 | 49,700 | 56,800 | -7,100 |
| 2025-11 | 90,900 | 49,700 | 41,200 |
| 2025-12 | 122,200 | 90,900 | 31,300 |
| 2026-07 | 100,800 | 122,200 | -21,400 |
| 2026-08 | 49,700 | 100,800 | -51,100 |
| 2026-09 | 144,600 | 49,700 | 94,900 |
| 2026-10 | 152,500 | 144,600 | 7,900 |

**Finding:** August 2025 shows the biggest fall (-57,500) and September 2026 the biggest rise (+94,900). July 2026 compares with December 2025, the previous recorded month.

### 9. LEAD: next recorded month revenue

| Month | Revenue | Next Month Revenue |
| --- | ---: | ---: |
| 2025-07 | 92,000 | 34,500 |
| 2025-08 | 34,500 | 56,800 |
| 2025-09 | 56,800 | 49,700 |
| 2025-10 | 49,700 | 90,900 |
| 2025-11 | 90,900 | 122,200 |
| 2025-12 | 122,200 | 100,800 |
| 2026-07 | 100,800 | 49,700 |
| 2026-08 | 49,700 | 144,600 |
| 2026-09 | 144,600 | 152,500 |
| 2026-10 | 152,500 | NULL |

**Finding:** Each month shows the next recorded month's revenue. October 2026, the last month, has no next month, so its value is NULL.

### 10. Named window: one definition reused by several window functions

| Month | Revenue | Running Revenue | Running Average | Highest So Far |
| --- | ---: | ---: | ---: | ---: |
| 2025-07 | 92,000 | 92,000 | 92,000 | 92,000 |
| 2025-08 | 34,500 | 126,500 | 63,250 | 92,000 |
| 2025-09 | 56,800 | 183,300 | 61,100 | 92,000 |
| 2025-10 | 49,700 | 233,000 | 58,250 | 92,000 |
| 2025-11 | 90,900 | 323,900 | 64,780 | 92,000 |
| 2025-12 | 122,200 | 446,100 | 74,350 | 122,200 |
| 2026-07 | 100,800 | 546,900 | 78,128.57 | 122,200 |
| 2026-08 | 49,700 | 596,600 | 74,575 | 122,200 |
| 2026-09 | 144,600 | 741,200 | 82,355.56 | 144,600 |
| 2026-10 | 152,500 | 893,700 | 89,370 | 152,500 |

**Finding:** The highest monthly revenue so far moves from 92,000 to 122,200 in December 2025, then to 144,600 and 152,500 in September and October 2026. The running average ends at 89,370.

