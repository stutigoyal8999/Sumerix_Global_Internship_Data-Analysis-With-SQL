# Executive Report: Reporting Views

**Source query file:** `queries/views.sql`  
**Database:** Retail Store (SQLite), orders from 8 July 2025 to 18 October 2026  
**Amounts:** Indian rupees (INR)

This report shows how seven reusable views turn raw tables into a ready-made reporting layer. Each result below comes from querying a view instead of repeating joins and aggregations.

## Executive Summary

- Seven views (vw_OrderTotals, vw_CustomerSales, vw_ProductSales, vw_MonthlySales, vw_RegionalSales, vw_EmployeeSales, vw_TopCustomers) replace the repeated order-total calculation with one definition.
- The five largest orders are all between 65,000 and 66,200, and each includes a Laptop.
- The top 5 customers account for 557,700 of revenue, which is 62.4%.
- The ALTER VIEW workaround (drop and recreate) widens the high-value customer list from 3 customers (above 100,000) to 5 customers (above 50,000).

## Views Created

| View | Purpose |
| --- | --- |
| vw_OrderTotals | One row per order with the number of line items and the order total |
| vw_CustomerSales | Orders placed, total spent and first and last order date per customer, including customers with no orders |
| vw_ProductSales | Units sold and revenue per product, including products that never sold |
| vw_MonthlySales | Orders, revenue, average order value and customers per month |
| vw_RegionalSales | Orders and revenue by region and year |
| vw_EmployeeSales | Orders handled and total sales per employee |
| vw_TopCustomers | High-value customers (rebuilt with a different threshold in the ALTER VIEW demonstration) |

## Detailed Results

### 1. Using the views: the 5 largest orders

| Order ID | Customer ID | Employee ID | Order Date | Order Month | Line Items | Order Total |
| ---: | ---: | ---: | --- | --- | ---: | ---: |
| 15 | 15 | 3 | 2026-09-27 | 2026-09 | 2 | 66,200 |
| 1 | 1 | 2 | 2026-07-05 | 2026-07 | 2 | 65,800 |
| 26 | 2 | 5 | 2026-10-06 | 2026-10 | 1 | 65,000 |
| 31 | 7 | 3 | 2025-07-08 | 2025-07 | 1 | 65,000 |
| 44 | 2 | 3 | 2025-11-04 | 2025-11 | 1 | 65,000 |

*Top 5 orders by order total.*

**Finding:** Order 15 (66,200) is the largest, followed by Order 1 (65,800) and three orders of exactly 65,000. All five are Laptop purchases, two of them with a small accessory added.

### 2. Using the views: top 5 customers by spending

| Customer Name | Region | Orders Placed | Total Spent | Last Order Date |
| --- | --- | ---: | ---: | --- |
| Priya Singh | South | 4 | 160,500 | 2026-10-06 |
| Vikram Rao | South | 5 | 121,100 | 2026-10-18 |
| Rahul Sharma | North | 6 | 109,300 | 2026-10-12 |
| Karan Malhotra | North | 2 | 86,700 | 2026-09-27 |
| Arjun Mehta | West | 4 | 80,100 | 2026-10-10 |

*Top 5 customers by total spent.*

**Finding:** Priya Singh (160,500), Vikram Rao (121,100), Rahul Sharma (109,300), Karan Malhotra (86,700) and Arjun Mehta (80,100) together spent 557,700, which is 62.4% of revenue.

### 3. Using the views: top 5 products by revenue

| Product Name | Category Name | Units Sold | Revenue |
| --- | --- | ---: | ---: |
| Laptop | Electronics | 6 | 390,000 |
| Smartphone | Electronics | 7 | 175,000 |
| Tablet | Electronics | 6 | 108,000 |
| Microwave Oven | Home Appliances | 4 | 38,000 |
| Study Table | Furniture | 4 | 26,000 |

*Top 5 products by revenue.*

**Finding:** Laptop leads with 390,000 from 6 units. Three Electronics products (Laptop, Smartphone, Tablet) occupy the top three places.

### 4. Using the views: monthly sales report

| Month | Orders | Revenue | Avg Order Value | Customers |
| --- | ---: | ---: | ---: | ---: |
| 2025-07 | 2 | 92,000 | 46,000 | 2 |
| 2025-08 | 3 | 34,500 | 11,500 | 3 |
| 2025-09 | 4 | 56,800 | 14,200 | 4 |
| 2025-10 | 4 | 49,700 | 12,425 | 4 |
| 2025-11 | 4 | 90,900 | 22,725 | 4 |
| 2025-12 | 5 | 122,200 | 24,440 | 5 |
| 2026-07 | 4 | 100,800 | 25,200 | 4 |
| 2026-08 | 6 | 49,700 | 8,283.33 | 6 |
| 2026-09 | 9 | 144,600 | 16,066.67 | 9 |
| 2026-10 | 11 | 152,500 | 13,863.64 | 11 |

**Finding:** October 2026 has the highest revenue (152,500) and the most orders (11). August 2026 is the weakest month of 2026 (49,700) because its average order value fell to 8,283.33 despite 6 orders.

### 5. Using the views: regional sales by year

| Region | Sales Year | Orders | Revenue |
| --- | --- | ---: | ---: |
| South | 2025 | 7 | 204,100 |
| West | 2025 | 4 | 119,500 |
| North | 2025 | 5 | 82,700 |
| East | 2025 | 4 | 23,900 |
| Central | 2025 | 2 | 15,900 |
| South | 2026 | 12 | 195,750 |
| North | 2026 | 8 | 186,500 |
| East | 2026 | 4 | 35,550 |
| West | 2026 | 4 | 16,600 |
| Central | 2026 | 2 | 13,200 |

**Finding:** South is the largest region in both years (204,100 in 2025 and 195,750 in 2026). North grew from 82,700 to 186,500, while West fell from 119,500 to 16,600. The 2025 figures cover July to December and the 2026 figures July to October.

### 6. Using the views: employee sales ranking

| Employee Name | Job Title | Orders Handled | Total Sales |
| --- | --- | ---: | ---: |
| Sunita Rao | Sales Executive | 14 | 383,050 |
| Rajesh Khanna | Sales Executive | 17 | 246,200 |
| Nisha Thakur | Sales Associate | 11 | 176,100 |
| Vivek Anand | Cashier | 10 | 88,350 |
| Aarti Kapoor | Store Manager | 0 | 0 |

**Finding:** Sunita Rao leads with 383,050 from 14 orders. Rajesh Khanna handles the most orders (17) but sells less. Aarti Kapoor, the store manager, handles no orders.

### 7. Filtering a view like a table: customers who have never ordered

| Customer Name | City | Region |
| --- | --- | --- |
| Rina Kapoor | Delhi | North |

**Finding:** A view can be filtered like a table. Rina Kapoor is the only customer with zero orders.

### 8. Joining a view with a table: orders with the employee who handled them

| Order ID | Order Date | Employee Name | Order Total |
| ---: | --- | --- | ---: |
| 15 | 2026-09-27 | Sunita Rao | 66,200 |
| 1 | 2026-07-05 | Rajesh Khanna | 65,800 |
| 26 | 2026-10-06 | Nisha Thakur | 65,000 |
| 31 | 2025-07-08 | Sunita Rao | 65,000 |
| 44 | 2025-11-04 | Sunita Rao | 65,000 |

*Top 5 orders by order total.*

**Finding:** Joining a view to a table adds the employee name. Sunita Rao handled three of the five largest orders.

### 9. ALTER VIEW equivalent, version 1: customers above 100,000

| Customer Name | Region | Total Spent |
| --- | --- | ---: |
| Priya Singh | South | 160,500 |
| Vikram Rao | South | 121,100 |
| Rahul Sharma | North | 109,300 |

**Finding:** Three customers exceed 100,000: Priya Singh, Vikram Rao and Rahul Sharma.

### 10. ALTER VIEW equivalent, version 2: threshold lowered to 50,000

| Customer Name | Region | Total Spent |
| --- | --- | ---: |
| Priya Singh | South | 160,500 |
| Vikram Rao | South | 121,100 |
| Rahul Sharma | North | 109,300 |
| Karan Malhotra | North | 86,700 |
| Arjun Mehta | West | 80,100 |

**Finding:** After dropping and recreating the view with a lower threshold, Karan Malhotra and Arjun Mehta join the list, which grows to five customers.

### 11. DROP VIEW: the practice view before it is removed

| Product Name | Price |
| --- | ---: |
| USB Cable | 250 |
| Notebook Pack | 300 |
| Gel Pen Set | 150 |
| Desk Organizer | 450 |

**Finding:** The practice view lists the four products priced under 500 (Gel Pen Set, USB Cable, Notebook Pack, Desk Organizer). It is dropped right after this check.

