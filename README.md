# Customer Behaviour Analysis | Python + PostgreSQL + Power BI

An end-to-end data analytics project analyzing customer purchase behavior to understand spending patterns, product preferences, customer segments, subscription behavior, and category-level revenue using **Python, PostgreSQL, and Power BI**.

---

## 📌 Project Objective

To analyze customer shopping behavior and generate actionable business insights by performing data cleaning, SQL-based analysis, and interactive dashboard visualization.

---

## 🛠️ Tools & Technologies

- **Python** – Data cleaning and feature engineering
- **PostgreSQL** – SQL-based business analysis
- **Power BI** – Interactive dashboard and data visualization
- **SQLAlchemy** – Database connectivity

---

## 🐍 Data Cleaning & Transformation

The dataset was cleaned and prepared using Python:

- Handling missing values
- Standardizing column names
- Converting relevant fields into appropriate data types
- Creating age-group categories
- Preparing purchase-frequency information for analysis
- Removing unnecessary or redundant columns
- Loading the cleaned dataset into PostgreSQL

This ensured clean, structured, and analysis-ready data.

---

## 🗄️ SQL Analysis

---

**🔹 Total Revenue by Gender**
```sql 
SELECT gender,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY gender;
```
---
🔹 Customers Who Used Discount & Spent Above Average
```sql WITH cte AS (
    SELECT AVG(purchase_amount) AS average_spend
    FROM customer
)
SELECT c.customer_id,
       c.purchase_amount
FROM customer c, cte
WHERE c.discount_applied = 'Yes'
  AND c.purchase_amount >= cte.average_spend;
```
---
🔹 Top 5 Products with Highest Average Review Rating
```sql SELECT item_purchased,
       ROUND(AVG(review_rating)::numeric, 2) AS average_product_rating
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;
```
---
🔹 Average Purchase Comparison: Standard vs Express Shipping
```sql SELECT shipping_type,
       ROUND(AVG(purchase_amount), 2) AS average_spend
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;
```
---
🔹 Subscriber vs Non-Subscriber Revenue Comparison
```sql SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC;
```
---
🔹 Top 5 Products with Highest Discount Usage Percentage
```sql SELECT item_purchased,
       ROUND(
           SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0
           / COUNT(*), 2
       ) AS discount_percentage
FROM customer
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5;
```
---
🔹 Customer Segmentation (New, Returning, Loyal)
```sql WITH customer_type AS (
    SELECT customer_id,
           CASE
             WHEN previous_purchases = 1 THEN 'New'
             WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
             ELSE 'Loyal'
           END AS customer_segment
    FROM customer
)
SELECT customer_segment,
       COUNT(*) AS total_customers
FROM customer_type
GROUP BY customer_segment;
```
---
🔹 Top 3 Most Purchased Products Within Each Category
```sql WITH cte AS (
    SELECT category,
           item_purchased,
           COUNT(*) AS cnt
    FROM customer
    GROUP BY category, item_purchased
)
SELECT category,
       item_purchased,
       cnt
FROM (
    SELECT category,
           item_purchased,
           cnt,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY cnt DESC) AS rnk
    FROM cte
) ranked
WHERE rnk <= 3;
```
---
🔹 Repeat Buyers & Subscription Status
```sql SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;
```
---
🔹 Revenue Contribution by Age Group
```sql SELECT age_group,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;
```
---

## 📊 Power BI Dashboard

An interactive Power BI dashboard was created to provide a consolidated view of customer behavior.

### Key Performance Indicators

- **Total Customers:** 3.9K
- **Average Purchase Amount:** $59.76
- **Average Rating:** 3.75 / 5

### Dashboard Visualizations

- Revenue by Category
- Customer Distribution by Subscription Status
- Customer Distribution by Size
- Number of Customers by Age Group
- Number of Customers by Customer Segment

### Interactive Filters

- Age Group
- Gender
- Subscription Status
- Shipping Type

The dashboard allows users to explore customer behavior across different demographic and purchasing dimensions.

---

## 🔍 Key Insights

- **Clothing** generates the highest revenue among the product categories.
- **73% of customers are non-subscribers**, while subscribers represent 27% of the customer base.
- **Medium (M)** is the most common customer-selected size in the dataset.
- **Senior Citizens** represent the largest customer age group.
- The customer base contains a substantial proportion of **loyal customers** based on previous purchase frequency.
- Customer purchasing behavior can be further compared across subscription status, age group, gender, shipping type, and product category.
