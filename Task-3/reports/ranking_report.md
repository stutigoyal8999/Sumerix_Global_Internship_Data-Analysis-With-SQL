# Executive Report: Ranking Analysis

**Source query file:** `queries/ranking.sql`  
**Database:** Retail Store (SQLite), orders from 8 July 2025 to 18 October 2026  
**Amounts:** Indian rupees (INR)

This report ranks customers, products, months, employees and regions with ROW_NUMBER, RANK, DENSE_RANK and NTILE, and shows how each function treats ties.

## Executive Summary

- Priya Singh ranks first among customers (160,500). The top five customers each spent over 80,000, while the sixth spent 46,200, so the drop after fifth place is steep.
- Laptop, Smartphone and Tablet hold the top three revenue ranks. Gel Pen Set and Notebook Pack tie as the best-selling products by units (16 each).
- Sunita Rao ranks first among employees in both 2025 and 2026. Nisha Thakur rose from 62,400 to 113,700.
- South is ranked first in both years. West fell from second to fourth place.

## Detailed Results

### 1. ROW_NUMBER: customers numbered by total spending

| Sales Rank | Customer Name | Region | Total Spent |
| ---: | --- | --- | ---: |
| 1 | Priya Singh | South | 160,500 |
| 2 | Vikram Rao | South | 121,100 |
| 3 | Rahul Sharma | North | 109,300 |
| 4 | Karan Malhotra | North | 86,700 |
| 5 | Arjun Mehta | West | 80,100 |
| 6 | Rohit Verma | North | 46,200 |
| 7 | Pooja Reddy | South | 43,800 |
| 8 | Sanjay Patel | West | 33,500 |
| 9 | Divya Menon | South | 28,900 |
| 10 | Sneha Iyer | South | 27,200 |

*Top 10 customers.*

**Finding:** Priya Singh is number 1 with 160,500, followed by Vikram Rao (121,100) and Rahul Sharma (109,300).

### 2. ROW_NUMBER, RANK and DENSE_RANK side by side: customers by number of orders

| Customer Name | Orders Placed | Row Number | Rank | Dense Rank |
| --- | ---: | ---: | ---: | ---: |
| Rahul Sharma | 6 | 1 | 1 | 1 |
| Vikram Rao | 5 | 2 | 2 | 2 |
| Arjun Mehta | 4 | 3 | 3 | 3 |
| Priya Singh | 4 | 4 | 3 | 3 |
| Pooja Reddy | 3 | 5 | 5 | 4 |
| Rohit Verma | 3 | 6 | 5 | 4 |
| Amit Kumar | 2 | 7 | 7 | 5 |
| Ananya Bose | 2 | 8 | 7 | 5 |
| Anjali Nair | 2 | 9 | 7 | 5 |
| Deepak Yadav | 2 | 10 | 7 | 5 |

*Top 10 customers by order count.*

**Finding:** Arjun Mehta and Priya Singh tie at 4 orders. ROW_NUMBER gives them 3 and 4, while RANK and DENSE_RANK both give 3. The next customers (3 orders) get RANK 5 but DENSE_RANK 4, which shows the difference between the two.

### 3. RANK: products ranked by revenue (the PDF example, using the view)

| Product Name | Revenue | Product Rank |
| --- | ---: | ---: |
| Laptop | 390,000 | 1 |
| Smartphone | 175,000 | 2 |
| Tablet | 108,000 | 3 |
| Microwave Oven | 38,000 | 4 |
| Study Table | 26,000 | 5 |
| Smart Watch | 24,000 | 6 |
| Office Chair | 22,500 | 7 |
| Bluetooth Speaker | 20,000 | 8 |
| Headphones | 18,000 | 9 |
| Bookshelf | 16,400 | 10 |

*Top 10 products.*

**Finding:** Laptop is ranked 1 (390,000), then Smartphone (175,000) and Tablet (108,000). Electronics holds the top three places.

### 4. RANK and DENSE_RANK with ties: products ranked by units sold

| Product Name | Units Sold | Rank | Dense Rank |
| --- | ---: | ---: | ---: |
| Gel Pen Set | 16 | 1 | 1 |
| Notebook Pack | 16 | 1 | 1 |
| USB Cable | 11 | 3 | 2 |
| Headphones | 9 | 4 | 3 |
| Bluetooth Speaker | 8 | 5 | 4 |
| Electric Kettle | 8 | 5 | 4 |
| Desk Organizer | 7 | 7 | 5 |
| Mouse | 7 | 7 | 5 |
| Smartphone | 7 | 7 | 5 |
| Keyboard | 6 | 10 | 6 |

*Top 10 products by units sold.*

**Finding:** Gel Pen Set and Notebook Pack tie at 16 units and share rank 1. USB Cable is rank 3 with RANK but rank 2 with DENSE_RANK. There is also a three-way tie at rank 7 (Desk Organizer, Mouse, Smartphone).

### 5. ROW_NUMBER with PARTITION BY: the best 2 products in every category

| Category Name | Category Rank | Product Name | Revenue |
| --- | ---: | --- | ---: |
| Accessories | 1 | Headphones | 18,000 |
| Accessories | 2 | Keyboard | 7,300 |
| Electronics | 1 | Laptop | 390,000 |
| Electronics | 2 | Smartphone | 175,000 |
| Furniture | 1 | Study Table | 26,000 |
| Furniture | 2 | Office Chair | 22,500 |
| Home Appliances | 1 | Microwave Oven | 38,000 |
| Home Appliances | 2 | Mixer Grinder | 10,500 |
| Stationery | 1 | Notebook Pack | 4,800 |
| Stationery | 2 | Desk Organizer | 3,150 |

**Finding:** The best two products per category are Laptop and Smartphone (Electronics), Study Table and Office Chair (Furniture), Microwave Oven and Mixer Grinder (Home Appliances), Headphones and Keyboard (Accessories), Notebook Pack and Desk Organizer (Stationery).

### 6. NTILE(4): customers split into spending quartiles (1 = top 25 percent)

| Customer Name | Total Spent | Spending Quartile |
| --- | ---: | ---: |
| Priya Singh | 160,500 | 1 |
| Vikram Rao | 121,100 | 1 |
| Rahul Sharma | 109,300 | 1 |
| Karan Malhotra | 86,700 | 1 |
| Arjun Mehta | 80,100 | 1 |
| Rohit Verma | 46,200 | 2 |
| Pooja Reddy | 43,800 | 2 |
| Sanjay Patel | 33,500 | 2 |
| Divya Menon | 28,900 | 2 |
| Sneha Iyer | 27,200 | 2 |
| Neha Gupta | 27,000 | 3 |
| Meera Das | 25,200 | 3 |
| Kavita Joshi | 22,500 | 3 |
| Manish Tiwari | 21,200 | 3 |
| Ananya Bose | 19,500 | 3 |
| Anjali Nair | 15,500 | 4 |
| Ritu Agarwal | 10,750 | 4 |
| Deepak Yadav | 7,900 | 4 |
| Amit Kumar | 4,000 | 4 |
| Suresh Pillai | 2,850 | 4 |

**Finding:** The top quartile contains five customers who each spent 80,100 or more. The bottom quartile contains customers who spent 15,500 or less, from Anjali Nair down to Suresh Pillai (2,850).

### 7. NTILE(3): products grouped into high, medium and low revenue thirds

| Product Name | Revenue | Revenue Group |
| --- | ---: | ---: |
| Laptop | 390,000 | 1 |
| Smartphone | 175,000 | 1 |
| Tablet | 108,000 | 1 |
| Microwave Oven | 38,000 | 1 |
| Study Table | 26,000 | 1 |
| Smart Watch | 24,000 | 1 |
| Office Chair | 22,500 | 1 |
| Bluetooth Speaker | 20,000 | 2 |
| Headphones | 18,000 | 2 |
| Bookshelf | 16,400 | 2 |
| Mixer Grinder | 10,500 | 2 |
| Electric Kettle | 8,800 | 2 |
| Keyboard | 7,300 | 2 |
| Laptop Bag | 6,000 | 2 |
| Mouse | 5,600 | 3 |
| Notebook Pack | 4,800 | 3 |
| Iron Box | 4,500 | 3 |
| Desk Organizer | 3,150 | 3 |
| USB Cable | 2,750 | 3 |
| Gel Pen Set | 2,400 | 3 |
| Wireless Charger | 0 | 3 |

**Finding:** Seven products fall in each revenue third. The top third starts at Laptop (390,000) and ends at Office Chair (22,500). Wireless Charger, with no sales, sits in the bottom third.

### 8. Sales ranking: months ranked by revenue

| Month | Revenue | Revenue Rank |
| --- | ---: | ---: |
| 2026-10 | 152,500 | 1 |
| 2026-09 | 144,600 | 2 |
| 2025-12 | 122,200 | 3 |
| 2026-07 | 100,800 | 4 |
| 2025-07 | 92,000 | 5 |
| 2025-11 | 90,900 | 6 |
| 2025-09 | 56,800 | 7 |
| 2025-10 | 49,700 | 8 |
| 2026-08 | 49,700 | 8 |
| 2025-08 | 34,500 | 10 |

*Top 10 months.*

**Finding:** October 2026 (152,500) and September 2026 (144,600) are the best months. October 2025 and August 2026 tie at 49,700 with rank 8, so no month has rank 9.

### 9. Employee performance: employees ranked by sales within each year

| Sales Year | Employee Name | Sales | Year Rank |
| --- | --- | ---: | ---: |
| 2025 | Sunita Rao | 227,700 | 1 |
| 2025 | Rajesh Khanna | 111,700 | 2 |
| 2025 | Nisha Thakur | 62,400 | 3 |
| 2025 | Vivek Anand | 44,300 | 4 |
| 2026 | Sunita Rao | 155,350 | 1 |
| 2026 | Rajesh Khanna | 134,500 | 2 |
| 2026 | Nisha Thakur | 113,700 | 3 |
| 2026 | Vivek Anand | 44,050 | 4 |

**Finding:** Sunita Rao is first in both years (227,700 in 2025 and 155,350 in 2026). Nisha Thakur grew from 62,400 to 113,700, and Vivek Anand stays last at about 44,000 both years. 2026 covers four months only.

### 10. Regions ranked by revenue within each year

| Sales Year | Region | Revenue | Region Rank |
| --- | --- | ---: | ---: |
| 2025 | South | 204,100 | 1 |
| 2025 | West | 119,500 | 2 |
| 2025 | North | 82,700 | 3 |
| 2025 | East | 23,900 | 4 |
| 2025 | Central | 15,900 | 5 |
| 2026 | South | 195,750 | 1 |
| 2026 | North | 186,500 | 2 |
| 2026 | East | 35,550 | 3 |
| 2026 | West | 16,600 | 4 |
| 2026 | Central | 13,200 | 5 |

**Finding:** South is first in both years. North moved from third to second (82,700 to 186,500), East from fourth to third, and West dropped from second (119,500) to fourth (16,600).

