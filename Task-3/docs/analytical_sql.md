# Analytical SQL

This document explains the analytical techniques in `queries/analytical_reports.sql` and the business question each one answers.

## What Analytical SQL Means

Analytical SQL goes beyond retrieving rows. It measures change over time, compares groups, ranks and segments entities, and produces datasets that feed dashboards. In this project it combines views (clean building blocks), CTEs (readable steps), window functions (running and comparative calculations) and CASE (business labels).

## Business Questions and Queries

| Business question | Query | Main technique |
| --- | --- | --- |
| What are the headline numbers? | 1 | Scalar subqueries over views |
| Which customers are in the top 10 percent? | 2 | `NTILE(10)` in a CTE |
| What is the monthly sales growth? | 3 and 6 | Self-join on the previous calendar month |
| How does each month compare with a year earlier? | 4 and 5 | Self-join on the same month last year, `LAG` over years |
| Which products are the top and bottom performers? | 7, 9, 10 | `ORDER BY` with `LIMIT`, cumulative share |
| Who is the best customer in each region? | 8 | `ROW_NUMBER` with `PARTITION BY` |
| Which products consistently rank among the top performers? | 11 | `RANK` per month, then count |
| Which regions are declining? | 12 | Conditional aggregation with CASE |
| How should customers be segmented? | 13 | `NTILE(4)` plus CASE |
| What is a customer's lifetime value and ordering rhythm? | 14 | Date arithmetic with `julianday` |
| Which products matter most to revenue? | 15 | ABC classification with cumulative percent |

## Techniques

### Growth Calculations

```text
Growth % = (current period - previous period) * 100.0 / previous period
```

- **Month over month (MoM)** compares each month with the month before it.
- **Year over year (YoY)** compares each month with the same month a year earlier, which removes seasonality.
- Query 3 joins each month to the previous **calendar** month, so a month whose previous month has no data shows NULL growth. `LAG` would compare July 2026 with December 2025, which is not a true month-over-month change.
- Query 5 compares July to October of both years, because 2026 has data only for those four months. A full-year comparison would make every region look like it declined.

### Top N, Bottom N and Cumulative Share

- Top N: `ORDER BY Revenue DESC LIMIT N`.
- Top N per group: `ROW_NUMBER() OVER (PARTITION BY group ORDER BY value DESC)` in a CTE, then `WHERE rank = 1`.
- Cumulative share: `SUM(Revenue) OVER (ORDER BY Revenue DESC) * 100.0 / SUM(Revenue) OVER ()`.
- Bottom N is split into products that still sold (query 9) and products with no sales (query 10), because the second group has zero revenue.

### Segmentation

Customer segments in query 13 combine spending and frequency:

| Segment | Rule | Customers | Revenue |
| --- | --- | ---: | ---: |
| VIP | Top spending quartile | 5 | 557,700 |
| Loyal | Not VIP, 3 or more orders | 2 | 90,000 |
| Growing | Not VIP or Loyal, spent 20,000 or more | 7 | 185,500 |
| Occasional | Everything else | 6 | 60,500 |

The CASE rules are checked in order, so a VIP customer is never re-labelled as Loyal.

### ABC Classification

Products are sorted by revenue and labelled by cumulative share of total revenue.

| Class | Cumulative revenue | Meaning |
| --- | --- | --- |
| A | Up to 70% | Core products to protect and keep in stock |
| B | 70% to 90% | Supporting products |
| C | Above 90% | Tail products to review |

### Customer Lifetime Analysis

- Lifespan = last order date minus first order date, in days (`julianday`).
- Average days between orders = lifespan / (orders - 1), shown only for customers with more than one order.
- Average order value = total spent / orders placed.

## Data Coverage and Assumptions

- Revenue is `Quantity * UnitPrice` summed over order lines, since the Orders table has no total column.
- The database covers July to December 2025 and July to October 2026. There are no orders for January to June 2026, so growth queries handle the gap explicitly.
- The 2025 orders were added for Task 3 to make trend analysis possible. They are sample data.
- There is no cost data, so profit analysis is replaced with revenue-target analysis.
- All amounts are in Indian rupees.

## Reading the Results

The results are written up in `reports/customer_intelligence_report.md`. The main conclusions:

- Revenue is concentrated: five customers generate 62.4% and five products 82.5%.
- Growth is strong: July to October 2026 revenue is 92.1% above the same months in 2025.
- West is the one region that needs attention (-86.1%).
- Wireless Charger has no sales and should be reviewed.