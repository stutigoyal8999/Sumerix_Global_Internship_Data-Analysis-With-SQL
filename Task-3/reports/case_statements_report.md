# Executive Report: Segmentation and Status Classification with CASE

**Source query file:** `queries/case_statements.sql`  
**Database:** Retail Store (SQLite), orders from 8 July 2025 to 18 October 2026  
**Amounts:** Indian rupees (INR)

This report uses CASE expressions to turn numbers into business labels: customer tiers, order sizes, price bands, performance status, stock status, revenue targets and customer activity.

## Executive Summary

- Five customers in the Premium and Gold tiers generate 62.4% of revenue (43.7% Premium and 18.7% Gold).
- Six large orders (50,000 or more) account for 392,000 of revenue, which is 43.9%.
- Five products are on low stock (under 25 units), including the best-selling Laptop with 15 units.
- Four of the ten recorded months met the 100,000 revenue target, including the last two months. 14 of 20 ordering customers are Active, 5 are At risk and 1 is Inactive.

## Detailed Results

### 1. Customer segmentation (the PDF example, using the view)

| Customer Name | Total Spent | Customer Category |
| --- | ---: | --- |
| Priya Singh | 160,500 | Premium |
| Vikram Rao | 121,100 | Premium |
| Rahul Sharma | 109,300 | Premium |
| Karan Malhotra | 86,700 | Gold |
| Arjun Mehta | 80,100 | Gold |
| Rohit Verma | 46,200 | Silver |
| Pooja Reddy | 43,800 | Silver |
| Sanjay Patel | 33,500 | Silver |
| Divya Menon | 28,900 | Silver |
| Sneha Iyer | 27,200 | Silver |

*Top 10 customers.*

**Finding:** Priya Singh, Vikram Rao and Rahul Sharma are Premium (100,000 or more). Karan Malhotra and Arjun Mehta are Gold (50,000 or more), and the next customers are Silver.

### 2. Segment summary: customers and revenue in each category

| Customer Category | Customers | Revenue | Revenue Share (%) |
| --- | ---: | ---: | ---: |
| Premium | 3 | 390,900 | 43.7 |
| Silver | 9 | 275,500 | 30.8 |
| Gold | 2 | 166,800 | 18.7 |
| Regular | 6 | 60,500 | 6.8 |

**Finding:** Premium: 3 customers, 390,900 (43.7%). Silver: 9 customers, 275,500 (30.8%). Gold: 2 customers, 166,800 (18.7%). Regular: 6 customers, 60,500 (6.8%).

### 3. Revenue classification: orders grouped by size

| Order Size | Orders | Revenue |
| --- | ---: | ---: |
| Large order | 6 | 392,000 |
| Medium order | 16 | 334,000 |
| Small order | 30 | 167,700 |

**Finding:** 30 small orders (under 10,000) bring in 167,700 and 6 large orders (50,000 or more) bring in 392,000. Revenue depends on a few large purchases.

### 4. Business categories: products grouped into price bands

| Price Band | Products | Revenue |
| --- | ---: | ---: |
| Premium | 3 | 673,000 |
| Mid-range | 8 | 175,400 |
| Budget | 10 | 45,300 |

**Finding:** Three Premium products (10,000 and above) earn 673,000, which is 75.3% of revenue. The ten Budget products (under 2,000) earn only 45,300.

### 5. Product performance status based on revenue

| Product Name | Revenue | Performance Status |
| --- | ---: | --- |
| Laptop | 390,000 | Top performer |
| Smartphone | 175,000 | Top performer |
| Tablet | 108,000 | Top performer |
| Microwave Oven | 38,000 | Good performer |
| Study Table | 26,000 | Good performer |
| Smart Watch | 24,000 | Good performer |
| Office Chair | 22,500 | Good performer |
| Bluetooth Speaker | 20,000 | Good performer |
| Headphones | 18,000 | Low performer |
| Bookshelf | 16,400 | Low performer |

*Top 10 products by revenue.*

**Finding:** Laptop, Smartphone and Tablet are Top performers (100,000 or more). Five more products are Good performers (20,000 or more), and Headphones and Bookshelf are Low performers.

### 6. Stock status for inventory planning

| Product Name | Stock Quantity | Stock Status |
| --- | ---: | --- |
| Bookshelf | 10 | Low stock |
| Study Table | 12 | Low stock |
| Laptop | 15 | Low stock |
| Office Chair | 18 | Low stock |
| Microwave Oven | 20 | Low stock |
| Tablet | 25 | Medium stock |
| Smart Watch | 30 | Medium stock |
| Mixer Grinder | 35 | Medium stock |

*The 8 products with the lowest stock.*

**Finding:** Five products are on Low stock (under 25 units): Bookshelf (10), Study Table (12), Laptop (15), Office Chair (18) and Microwave Oven (20). Laptop is the top seller, so restocking it is the priority.

### 7. Employee performance compared with the team average

| Employee Name | Total Sales | Performance Status |
| --- | ---: | --- |
| Sunita Rao | 383,050 | Outstanding |
| Rajesh Khanna | 246,200 | Above average |
| Nisha Thakur | 176,100 | Below average |
| Vivek Anand | 88,350 | Below average |
| Aarti Kapoor | 0 | No sales |

**Finding:** Sunita Rao is Outstanding (at least 1.5 times the team average). Rajesh Khanna is Above average, Nisha Thakur and Vivek Anand are Below average, and Aarti Kapoor has no sales.

### 8. Revenue status against a monthly target of 100,000 (no cost data, so no profit status)

| Month | Revenue | Target Status |
| --- | ---: | --- |
| 2025-07 | 92,000 | Close to target |
| 2025-08 | 34,500 | Below target |
| 2025-09 | 56,800 | Below target |
| 2025-10 | 49,700 | Below target |
| 2025-11 | 90,900 | Close to target |
| 2025-12 | 122,200 | Target met |
| 2026-07 | 100,800 | Target met |
| 2026-08 | 49,700 | Below target |
| 2026-09 | 144,600 | Target met |
| 2026-10 | 152,500 | Target met |

**Finding:** Four months met the target (December 2025, July, September and October 2026), two were close (July and November 2025) and four were below (August to October 2025 and August 2026).

### 9. Customer activity status based on the days since the last order

| Customer Name | Last Order Date | Activity Status |
| --- | --- | --- |
| Vikram Rao | 2026-10-18 | Active |
| Rohit Verma | 2026-10-15 | Active |
| Rahul Sharma | 2026-10-12 | Active |
| Arjun Mehta | 2026-10-10 | Active |
| Ananya Bose | 2026-10-09 | Active |
| Suresh Pillai | 2026-10-07 | Active |
| Priya Singh | 2026-10-06 | Active |
| Meera Das | 2026-10-05 | Active |
| Deepak Yadav | 2026-10-03 | Active |
| Pooja Reddy | 2026-10-02 | Active |

*The 10 customers who ordered most recently.*

**Finding:** All ten of the most recent customers are Active, because Active means an order within 30 days of the latest order date in the database (18 October 2026).

### 10. Activity summary: how many customers fall into each status

| Activity Status | Customers |
| --- | ---: |
| Active | 14 |
| At risk | 5 |
| Never ordered | 1 |
| Inactive | 1 |

**Finding:** 14 customers are Active, 5 are At risk, 1 (Amit Kumar) is Inactive and 1 (Rina Kapoor) has never ordered. At risk customers (Neha Gupta, Sneha Iyer, Kavita Joshi, Anjali Nair, Sanjay Patel) are the natural targets for a win-back offer.

