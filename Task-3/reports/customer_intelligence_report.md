# Executive Report: Customer Intelligence and Sales Analytics

**Source query file:** `queries/analytical_reports.sql`  
**Database:** Retail Store (SQLite), orders from 8 July 2025 to 18 October 2026  
**Amounts:** Indian rupees (INR)

This is the main analytical report of the project. It combines views, CTEs, window functions and CASE logic to answer the business questions in the brief: who the top customers are, how sales are growing, which products and regions perform best or worst, and how customers should be segmented.

## Executive Summary

- Total revenue is 893,700 from 52 orders and 20 active customers, with an average order value of 17,186.54. Laptop is the top product and Priya Singh the top customer.
- Sales are accelerating. July to October 2026 revenue is 447,600 against 233,000 a year earlier (+92.1%), and every comparable month grew year over year.
- West (-86.1%) and Central (-17.0%) are the only regions with declining sales. South, North and East all more than tripled.
- Five VIP customers generate 62.4% of revenue, and the top five products generate 82.5%. Both are concentrated and worth protecting.

## Detailed Results

### 1. Executive KPI summary: one row with the headline numbers

| Total Revenue | Total Orders | Active Customers | Avg Order Value | Top Product | Top Customer |
| ---: | ---: | ---: | ---: | --- | --- |
| 893,700 | 52 | 20 | 17,186.54 | Laptop | Priya Singh |

**Finding:** Revenue is 893,700 from 52 orders placed by 20 customers (average order value 17,186.54). Laptop is the top product and Priya Singh the top customer.

### 2. Top 10 percent of customers by revenue (decile 1 of NTILE(10))

| Customer Name | Region | Total Spent | Share Of Revenue (%) |
| --- | --- | ---: | ---: |
| Priya Singh | South | 160,500 | 18.0 |
| Vikram Rao | South | 121,100 | 13.6 |

**Finding:** The top 10% of customers by revenue are Priya Singh (160,500) and Vikram Rao (121,100). They contribute 18.0% and 13.6%, a combined 31.5% of revenue.

### 3. Month-over-month growth using the previous calendar month

| Month | Revenue | Previous Month Revenue | Growth (%) |
| --- | ---: | ---: | ---: |
| 2025-07 | 92,000 | NULL | NULL |
| 2025-08 | 34,500 | 92,000 | -62.5 |
| 2025-09 | 56,800 | 34,500 | 64.6 |
| 2025-10 | 49,700 | 56,800 | -12.5 |
| 2025-11 | 90,900 | 49,700 | 82.9 |
| 2025-12 | 122,200 | 90,900 | 34.4 |
| 2026-07 | 100,800 | NULL | NULL |
| 2026-08 | 49,700 | 100,800 | -50.7 |
| 2026-09 | 144,600 | 49,700 | 190.9 |
| 2026-10 | 152,500 | 144,600 | 5.5 |

**Finding:** The sharpest fall is August 2025 (-62.5%) and the biggest rise is September 2026 (+190.9%). July 2025 and July 2026 show NULL because the previous calendar month has no data. October 2026 grew a further 5.5%.

### 4. Year-over-year growth: each month against the same month a year earlier

| Month | Revenue | Same Month Last Year | Last Year Revenue | YoY Growth (%) |
| --- | ---: | --- | ---: | ---: |
| 2026-07 | 100,800 | 2025-07 | 92,000 | 9.6 |
| 2026-08 | 49,700 | 2025-08 | 34,500 | 44.1 |
| 2026-09 | 144,600 | 2025-09 | 56,800 | 154.6 |
| 2026-10 | 152,500 | 2025-10 | 49,700 | 206.8 |

**Finding:** All four comparable months grew year over year, and growth accelerated from +9.6% in July to +206.8% in October 2026.

### 5. Year-over-year for the comparable period (July to October of each year)

| Sales Year | Orders | Revenue | Growth (%) |
| --- | ---: | ---: | ---: |
| 2025 | 13 | 233,000 | NULL |
| 2026 | 30 | 447,600 | 92.1 |

**Finding:** July to October revenue rose from 233,000 to 447,600 (+92.1%), while orders grew from 13 to 30.

### 6. Running revenue dashboard dataset: one row per month with every trend measure

| Month | Orders | Revenue | Running Revenue | Cumulative (%) | Moving Avg (3 Months) | MoM Growth (%) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 2025-07 | 2 | 92,000 | 92,000 | 10.3 | 92,000 | NULL |
| 2025-08 | 3 | 34,500 | 126,500 | 14.2 | 63,250 | -62.5 |
| 2025-09 | 4 | 56,800 | 183,300 | 20.5 | 61,100 | 64.6 |
| 2025-10 | 4 | 49,700 | 233,000 | 26.1 | 47,000 | -12.5 |
| 2025-11 | 4 | 90,900 | 323,900 | 36.2 | 65,800 | 82.9 |
| 2025-12 | 5 | 122,200 | 446,100 | 49.9 | 87,600 | 34.4 |
| 2026-07 | 4 | 100,800 | 546,900 | 61.2 | 104,633.33 | NULL |
| 2026-08 | 6 | 49,700 | 596,600 | 66.8 | 90,900 | -50.7 |
| 2026-09 | 9 | 144,600 | 741,200 | 82.9 | 98,366.67 | 190.9 |
| 2026-10 | 11 | 152,500 | 893,700 | 100.0 | 115,600 | 5.5 |

**Finding:** This dataset feeds a dashboard. Running revenue reaches 893,700 by October 2026, the second half of 2025 contributes 49.9% of it, and the three-month average ends at 115,600.

### 7. Top-N: the 5 best products with cumulative share of revenue

| Product Name | Category Name | Revenue | Share (%) | Cumulative (%) |
| --- | --- | ---: | ---: | ---: |
| Laptop | Electronics | 390,000 | 43.6 | 43.6 |
| Smartphone | Electronics | 175,000 | 19.6 | 63.2 |
| Tablet | Electronics | 108,000 | 12.1 | 75.3 |
| Microwave Oven | Home Appliances | 38,000 | 4.3 | 79.6 |
| Study Table | Furniture | 26,000 | 2.9 | 82.5 |

**Finding:** The top 5 products generate 82.5% of revenue. Laptop alone is 43.6% and Laptop plus Smartphone is 63.2%.

### 8. Top-N per group: the best customer in every region

| Region | Customer Name | Total Spent |
| --- | --- | ---: |
| South | Priya Singh | 160,500 |
| North | Rahul Sharma | 109,300 |
| West | Arjun Mehta | 80,100 |
| East | Meera Das | 25,200 |
| Central | Manish Tiwari | 21,200 |

**Finding:** The best customer in each region is Priya Singh (South, 160,500), Rahul Sharma (North, 109,300), Arjun Mehta (West, 80,100), Meera Das (East, 25,200) and Manish Tiwari (Central, 21,200).

### 9. Bottom-N: the 5 weakest products that still sold, see query 10 for products that never sold

| Product Name | Category Name | Units Sold | Revenue |
| --- | --- | ---: | ---: |
| Gel Pen Set | Stationery | 16 | 2,400 |
| USB Cable | Accessories | 11 | 2,750 |
| Desk Organizer | Stationery | 7 | 3,150 |
| Iron Box | Home Appliances | 5 | 4,500 |
| Notebook Pack | Stationery | 16 | 4,800 |

**Finding:** Gel Pen Set has the lowest revenue (2,400) even though it is tied for the most units sold (16). Low-price items sell in volume but add little revenue.

### 10. Bottom-N: products with no sales at all

| Product Name | Category Name | Price | Status |
| --- | --- | ---: | --- |
| Wireless Charger | Accessories | 1,800 | No sales recorded |

**Finding:** Wireless Charger (Accessories, 1,800) has no sales at all. It is a candidate for promotion or removal from the range.

### 11. Products that consistently rank among the top 5 in monthly revenue

| Product Name | Months In Top 5 | Months Tracked |
| --- | ---: | ---: |
| Smartphone | 7 | 10 |
| Laptop | 6 | 10 |
| Tablet | 6 | 10 |
| Headphones | 4 | 10 |
| Microwave Oven | 4 | 10 |
| Bluetooth Speaker | 3 | 10 |
| Office Chair | 3 | 10 |
| Smart Watch | 3 | 10 |

*Top 8 products by months in the monthly top 5.*

**Finding:** Smartphone ranks in the monthly top 5 in 7 of 10 months, Laptop and Tablet in 6, and Headphones and Microwave Oven in 4. These are the most consistent performers.

### 12. Regions with declining sales: July to October 2026 against July to October 2025

| Region | Sales 2025 | Sales 2026 | Change | Change (%) | Trend |
| --- | ---: | ---: | ---: | ---: | --- |
| West | 119,500 | 16,600 | -102,900 | -86.1 | Declining |
| Central | 15,900 | 13,200 | -2,700 | -17.0 | Declining |
| East | 10,200 | 35,550 | 25,350 | 248.5 | Growing |
| North | 46,300 | 186,500 | 140,200 | 302.8 | Growing |
| South | 41,100 | 195,750 | 154,650 | 376.3 | Growing |

**Finding:** West fell 86.1% (119,500 to 16,600) and Central fell 17.0% (15,900 to 13,200). East (+248.5%), North (+302.8%) and South (+376.3%) are growing strongly. West needs attention first.

### 13. Customer segmentation based on spending and frequency

| Segment | Customers | Revenue | Avg Spend | Avg Orders |
| --- | ---: | ---: | ---: | ---: |
| VIP | 5 | 557,700 | 111,540 | 4.20 |
| Growing | 7 | 185,500 | 26,500 | 2 |
| Loyal | 2 | 90,000 | 45,000 | 3 |
| Occasional | 6 | 60,500 | 10,083 | 1.80 |

**Finding:** VIP: 5 customers, 557,700 revenue. Growing: 7 customers, 185,500. Loyal: 2 customers, 90,000. Occasional: 6 customers, 60,500. VIP customers average 111,540 each.

### 14. Customer lifetime analysis: value, lifespan and ordering rhythm

| Customer Name | Orders Placed | Lifetime Value | First Order Date | Last Order Date | Lifespan Days | Avg Order Value | Avg Days Between Orders |
| --- | ---: | ---: | --- | --- | ---: | ---: | ---: |
| Priya Singh | 4 | 160,500 | 2025-11-04 | 2026-10-06 | 336 | 40,125 | 112 |
| Vikram Rao | 5 | 121,100 | 2025-09-04 | 2026-10-18 | 409 | 24,220 | 102 |
| Rahul Sharma | 6 | 109,300 | 2025-10-06 | 2026-10-12 | 371 | 18,217 | 74 |
| Karan Malhotra | 2 | 86,700 | 2025-09-12 | 2026-09-27 | 380 | 43,350 | 380 |
| Arjun Mehta | 4 | 80,100 | 2025-07-08 | 2026-10-10 | 459 | 20,025 | 153 |
| Rohit Verma | 3 | 46,200 | 2025-11-11 | 2026-10-15 | 338 | 15,400 | 169 |
| Pooja Reddy | 3 | 43,800 | 2025-09-21 | 2026-10-02 | 376 | 14,600 | 188 |
| Sanjay Patel | 2 | 33,500 | 2025-07-20 | 2026-09-08 | 415 | 16,750 | 415 |
| Divya Menon | 2 | 28,900 | 2025-12-17 | 2026-09-22 | 279 | 14,450 | 279 |
| Sneha Iyer | 2 | 27,200 | 2025-10-15 | 2026-08-09 | 298 | 13,600 | 298 |

*Top 10 customers by lifetime value.*

**Finding:** Priya Singh has the highest lifetime value (160,500) over 336 days with about 112 days between orders. Arjun Mehta has the longest relationship (459 days). Karan Malhotra and Sanjay Patel ordered twice, far apart (380 and 415 days).

### 15. Product performance analysis with ABC classification by cumulative revenue

| Product Name | Category Name | Units Sold | Revenue | Share (%) | Cumulative (%) | ABC Class |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| Laptop | Electronics | 6 | 390,000 | 43.6 | 43.6 | A: core products |
| Smartphone | Electronics | 7 | 175,000 | 19.6 | 63.2 | A: core products |
| Tablet | Electronics | 6 | 108,000 | 12.1 | 75.3 | B: supporting products |
| Microwave Oven | Home Appliances | 4 | 38,000 | 4.3 | 79.6 | B: supporting products |
| Study Table | Furniture | 4 | 26,000 | 2.9 | 82.5 | B: supporting products |
| Smart Watch | Electronics | 4 | 24,000 | 2.7 | 85.2 | B: supporting products |
| Office Chair | Furniture | 3 | 22,500 | 2.5 | 87.7 | B: supporting products |
| Bluetooth Speaker | Electronics | 8 | 20,000 | 2.2 | 89.9 | B: supporting products |
| Headphones | Accessories | 9 | 18,000 | 2.0 | 91.9 | C: tail products |
| Bookshelf | Furniture | 2 | 16,400 | 1.8 | 93.8 | C: tail products |
| Mixer Grinder | Home Appliances | 3 | 10,500 | 1.2 | 94.9 | C: tail products |
| Electric Kettle | Home Appliances | 8 | 8,800 | 1.0 | 95.9 | C: tail products |

*First 12 products that sold.*

**Finding:** Laptop and Smartphone are class A (core products, 63.2% of revenue). Tablet through Bluetooth Speaker are class B, and the tail (class C) starts at Headphones, where cumulative revenue passes 90%.

