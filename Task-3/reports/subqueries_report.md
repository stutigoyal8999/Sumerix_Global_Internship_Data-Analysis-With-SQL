# Executive Report: Subquery Analysis

**Source query file:** `queries/subqueries.sql`  
**Database:** Retail Store (SQLite), orders from 8 July 2025 to 18 October 2026  
**Amounts:** Indian rupees (INR)

This report uses subqueries (scalar, multi-row, correlated, nested, EXISTS and NOT EXISTS) to answer questions that need one query to feed another: which products are priced above average, which customers or products have never appeared in an order, and who outspends the typical customer.

## Executive Summary

- Five products (Laptop, Smartphone, Tablet, Microwave Oven, Bookshelf) are priced above the average product price of about 7,726.
- One product (Wireless Charger) has never been sold and one customer (Rina Kapoor) has never placed an order. Both are clear follow-up targets.
- Six customers spend more than the average customer, led by Priya Singh with 160,500.
- SQLite has no ANY or ALL operators. The MIN and MAX equivalents return the same rows and are shown in queries 11 and 12.

## Detailed Results

### 1. Scalar subquery: products priced above the average product price

| Product Name | Price |
| --- | ---: |
| Laptop | 65,000 |
| Smartphone | 25,000 |
| Tablet | 18,000 |
| Microwave Oven | 9,500 |
| Bookshelf | 8,200 |

**Finding:** Laptop (65,000), Smartphone (25,000), Tablet (18,000), Microwave Oven (9,500) and Bookshelf (8,200) are the only products above the average price of about 7,726.

### 2. Scalar subquery in SELECT: each product's price difference from the average

| Product Name | Price | Difference From Avg |
| --- | ---: | ---: |
| Laptop | 65,000 | 57,273.81 |
| Smartphone | 25,000 | 17,273.81 |
| Tablet | 18,000 | 10,273.81 |
| Microwave Oven | 9,500 | 1,773.81 |
| Bookshelf | 8,200 | 473.81 |

*Top 5 products by difference from the average price.*

**Finding:** Laptop is 57,273.81 above the average price, Smartphone 17,273.81 and Tablet 10,273.81. The price spread is driven almost entirely by the Laptop.

### 3. Multi-row subquery with IN: customers who placed an order worth more than 50000

| Customer Name | City |
| --- | --- |
| Arjun Mehta | Ahmedabad |
| Karan Malhotra | Chandigarh |
| Priya Singh | Bengaluru |
| Rahul Sharma | Delhi |
| Vikram Rao | Hyderabad |

**Finding:** Five customers (Arjun Mehta, Karan Malhotra, Priya Singh, Rahul Sharma, Vikram Rao) have placed at least one single order worth more than 50,000.

### 4. Multi-row subquery with IN: products sold in October 2026

| Product Name | Price |
| --- | ---: |
| Bluetooth Speaker | 2,500 |
| Desk Organizer | 450 |
| Electric Kettle | 1,100 |
| Gel Pen Set | 150 |
| Iron Box | 900 |
| Keyboard | 1,300 |
| Laptop | 65,000 |
| Microwave Oven | 9,500 |
| Mixer Grinder | 3,500 |
| Mouse | 800 |
| Notebook Pack | 300 |
| Office Chair | 7,500 |
| Smartphone | 25,000 |
| Study Table | 6,500 |
| Tablet | 18,000 |
| USB Cable | 250 |

**Finding:** 16 of the 21 products were sold in October 2026. Smart Watch, Laptop Bag, Headphones, Bookshelf and Wireless Charger had no sales that month.

### 5. NOT IN: products that have never been sold

| Product Name | Price |
| --- | ---: |
| Wireless Charger | 1,800 |

**Finding:** Wireless Charger (1,800) is the only product that has never been sold.

### 6. EXISTS: customers who placed at least one order in 2026

| Customer Name |
| --- |
| Amit Kumar |
| Ananya Bose |
| Anjali Nair |
| Arjun Mehta |
| Deepak Yadav |
| Divya Menon |
| Karan Malhotra |
| Kavita Joshi |
| Manish Tiwari |
| Meera Das |
| Neha Gupta |
| Pooja Reddy |
| Priya Singh |
| Rahul Sharma |
| Ritu Agarwal |
| Rohit Verma |
| Sanjay Patel |
| Sneha Iyer |
| Suresh Pillai |
| Vikram Rao |

**Finding:** All 20 customers who have ordered placed at least one order in 2026. The customer without any order (Rina Kapoor) is the only one missing.

### 7. NOT EXISTS: customers who have never placed an order

| Customer Name | City |
| --- | --- |
| Rina Kapoor | Delhi |

**Finding:** Rina Kapoor (Delhi) is the only customer who has never placed an order.

### 8. Correlated subquery: products priced above the average of their own category

| Product Name | Price |
| --- | ---: |
| Laptop | 65,000 |
| Smartphone | 25,000 |
| Microwave Oven | 9,500 |
| Bookshelf | 8,200 |
| Office Chair | 7,500 |
| Headphones | 2,000 |
| Wireless Charger | 1,800 |
| Laptop Bag | 1,500 |
| Keyboard | 1,300 |
| Desk Organizer | 450 |

**Finding:** Ten products are priced above the average of their own category. The list mixes premium items (Laptop, Smartphone, Microwave Oven) with the upper end of cheaper categories (Headphones, Desk Organizer).

### 9. Correlated subquery in SELECT: each customer's most recent order date

| Customer Name | Last Order Date |
| --- | --- |
| Vikram Rao | 2026-10-18 |
| Rohit Verma | 2026-10-15 |
| Rahul Sharma | 2026-10-12 |
| Arjun Mehta | 2026-10-10 |
| Ananya Bose | 2026-10-09 |

*The 5 most recent last-order dates.*

**Finding:** Vikram Rao ordered most recently (18 October 2026), followed by Rohit Verma (15 October) and Rahul Sharma (12 October).

### 10. Nested subquery: customers who spent more than the average customer

| Customer Name | Total Spent |
| --- | ---: |
| Priya Singh | 160,500 |
| Vikram Rao | 121,100 |
| Rahul Sharma | 109,300 |
| Karan Malhotra | 86,700 |
| Arjun Mehta | 80,100 |
| Rohit Verma | 46,200 |

**Finding:** Six customers spent more than the average customer. The top five each spent over 80,000, and the sixth, Rohit Verma, spent 46,200.

### 11. ANY equivalent: products outside Electronics that cost more than the cheapest Electronics product

| Product Name | Price |
| --- | ---: |
| Microwave Oven | 9,500 |
| Bookshelf | 8,200 |
| Office Chair | 7,500 |
| Study Table | 6,500 |
| Mixer Grinder | 3,500 |

**Finding:** The cheapest Electronics product is the Bluetooth Speaker (2,500). Five products from other categories cost more: Microwave Oven, Bookshelf, Office Chair, Study Table and Mixer Grinder.

### 12. ALL equivalent: non-Accessories products that cost more than every Accessories product

| Product Name | Price |
| --- | ---: |
| Laptop | 65,000 |
| Smartphone | 25,000 |
| Tablet | 18,000 |
| Microwave Oven | 9,500 |
| Bookshelf | 8,200 |
| Office Chair | 7,500 |
| Study Table | 6,500 |
| Smart Watch | 6,000 |
| Mixer Grinder | 3,500 |
| Bluetooth Speaker | 2,500 |

**Finding:** The most expensive Accessories product is Headphones (2,000). Ten products from other categories cost more, from Laptop (65,000) down to Bluetooth Speaker (2,500).

