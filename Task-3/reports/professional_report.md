# Executive Report: Professional Reporting

**Source query file:** `queries/professional_reports.sql`  
**Database:** Retail Store (SQLite), orders from 8 July 2025 to 18 October 2026  
**Amounts:** Indian rupees (INR)

This report covers the five reports required in Step 9 of the brief: customer segmentation, revenue ranking, product ranking, monthly growth and regional performance. Each one combines views, CTEs, window functions and CASE logic in a single query.

## Executive Summary

- Premium and Gold customers (5 of 20) generate 62.4% of revenue. Premium customers alone average 130,300 each.
- The top 5 customers account for 62.4% of revenue and the top 10 for 82.5%.
- Laptop, Smartphone and Tablet hold the top three product ranks. Laptop alone is 43.6% of revenue.
- Revenue grew in every month of July to October 2026 compared with the same month in 2025. October 2026 is the best month (152,500, +206.8% year over year).
- South (44.7%) and North (30.1%) produce 74.8% of revenue. West and Central are the declining regions.

## Detailed Results

### 1. Customer segmentation report: size, revenue and leader of every segment

| Segment | Customers | Revenue | Revenue Share (%) | Avg Spend | Avg Orders | Top Customer |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| Premium | 3 | 390,900 | 43.7 | 130,300 | 5.0 | Priya Singh |
| Silver | 9 | 275,500 | 30.8 | 30,611 | 2.2 | Rohit Verma |
| Gold | 2 | 166,800 | 18.7 | 83,400 | 3.0 | Karan Malhotra |
| Regular | 6 | 60,500 | 6.8 | 10,083 | 1.8 | Ananya Bose |

**Finding:** Premium: 3 customers, 390,900 (43.7%). Silver is the largest group with 9 customers and 275,500 (30.8%). Gold: 2 customers, 166,800 (18.7%). Regular: 6 customers, 60,500 (6.8%). Priya Singh leads Premium, Rohit Verma leads Silver, Karan Malhotra leads Gold and Ananya Bose leads Regular.

### 2. Revenue ranking report: customers ranked by revenue with cumulative share

| Revenue Rank | Customer Name | Region | Orders Placed | Total Spent | Share (%) | Cumulative (%) |
| ---: | --- | --- | ---: | ---: | ---: | ---: |
| 1 | Priya Singh | South | 4 | 160,500 | 18.0 | 18.0 |
| 2 | Vikram Rao | South | 5 | 121,100 | 13.6 | 31.5 |
| 3 | Rahul Sharma | North | 6 | 109,300 | 12.2 | 43.7 |
| 4 | Karan Malhotra | North | 2 | 86,700 | 9.7 | 53.4 |
| 5 | Arjun Mehta | West | 4 | 80,100 | 9.0 | 62.4 |
| 6 | Rohit Verma | North | 3 | 46,200 | 5.2 | 67.6 |
| 7 | Pooja Reddy | South | 3 | 43,800 | 4.9 | 72.5 |
| 8 | Sanjay Patel | West | 2 | 33,500 | 3.7 | 76.2 |
| 9 | Divya Menon | South | 2 | 28,900 | 3.2 | 79.5 |
| 10 | Sneha Iyer | South | 2 | 27,200 | 3.0 | 82.5 |

*Top 10 customers by revenue.*

**Finding:** Priya Singh ranks first with 18.0% of revenue. Cumulative share reaches 62.4% at the fifth customer and 82.5% at the tenth, so a small group carries most of the revenue.

### 3. Product ranking report: overall rank, rank inside the category and performance status

| Overall Rank | Product Name | Category Name | Units Sold | Revenue | Category Rank | Share (%) | Performance Status |
| ---: | --- | --- | ---: | ---: | ---: | ---: | --- |
| 1 | Laptop | Electronics | 6 | 390,000 | 1 | 43.6 | Top performer |
| 2 | Smartphone | Electronics | 7 | 175,000 | 2 | 19.6 | Top performer |
| 3 | Tablet | Electronics | 6 | 108,000 | 3 | 12.1 | Top performer |
| 4 | Microwave Oven | Home Appliances | 4 | 38,000 | 1 | 4.3 | Good performer |
| 5 | Study Table | Furniture | 4 | 26,000 | 1 | 2.9 | Good performer |
| 6 | Smart Watch | Electronics | 4 | 24,000 | 4 | 2.7 | Good performer |
| 7 | Office Chair | Furniture | 3 | 22,500 | 2 | 2.5 | Good performer |
| 8 | Bluetooth Speaker | Electronics | 8 | 20,000 | 5 | 2.2 | Good performer |
| 9 | Headphones | Accessories | 9 | 18,000 | 1 | 2.0 | Low performer |
| 10 | Bookshelf | Furniture | 2 | 16,400 | 3 | 1.8 | Low performer |

*Top 10 products by revenue.*

**Finding:** Laptop (390,000), Smartphone (175,000) and Tablet (108,000) are the top three. The leaders of the other categories are Microwave Oven (Home Appliances), Study Table (Furniture) and Headphones (Accessories). Three products are Top performers and five are Good performers.

### 4. Monthly growth report: revenue with month-over-month and year-over-year change

| Month | Orders | Revenue | MoM Growth (%) | YoY Growth (%) | Running Revenue | Trend |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| 2025-07 | 2 | 92,000 | NULL | NULL | 92,000 | No previous month |
| 2025-08 | 3 | 34,500 | -62.5 | NULL | 126,500 | Decline |
| 2025-09 | 4 | 56,800 | 64.6 | NULL | 183,300 | Growth |
| 2025-10 | 4 | 49,700 | -12.5 | NULL | 233,000 | Decline |
| 2025-11 | 4 | 90,900 | 82.9 | NULL | 323,900 | Growth |
| 2025-12 | 5 | 122,200 | 34.4 | NULL | 446,100 | Growth |
| 2026-07 | 4 | 100,800 | NULL | 9.6 | 546,900 | No previous month |
| 2026-08 | 6 | 49,700 | -50.7 | 44.1 | 596,600 | Decline |
| 2026-09 | 9 | 144,600 | 190.9 | 154.6 | 741,200 | Growth |
| 2026-10 | 11 | 152,500 | 5.5 | 206.8 | 893,700 | Growth |

**Finding:** October 2026 grew 5.5% on September and 206.8% on October 2025. August 2026 is the only 2026 month that fell month over month (-50.7%), yet it is still 44.1% above August 2025. July 2025 and July 2026 have no previous month, so their month-over-month change is empty.

### 5. Regional performance report: size, rank and trend of every region

| Revenue Rank | Region | Orders | Customers | Revenue | Share (%) | Avg Order Value | Jul Oct 2025 | Jul Oct 2026 | Change (%) | Trend |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| 1 | South | 19 | 7 | 399,850 | 44.7 | 21,045 | 41,100 | 195,750 | 376.3 | Growing |
| 2 | North | 13 | 4 | 269,200 | 30.1 | 20,708 | 46,300 | 186,500 | 302.8 | Growing |
| 3 | West | 8 | 3 | 136,100 | 15.2 | 17,013 | 119,500 | 16,600 | -86.1 | Declining |
| 4 | East | 8 | 4 | 59,450 | 6.7 | 7,431 | 10,200 | 35,550 | 248.5 | Growing |
| 5 | Central | 4 | 2 | 29,100 | 3.3 | 7,275 | 15,900 | 13,200 | -17.0 | Declining |

**Finding:** South is first (399,850, 44.7%) with the highest average order value (21,045), followed by North (269,200, 30.1%). West is third overall but its July to October revenue fell 86.1%, and Central fell 17.0%. East, North and South all more than tripled.