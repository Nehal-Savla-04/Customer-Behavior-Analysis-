--Total Revenue by Gender
SELECT gender,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY gender;

--Customers Who Used Discount & Spent Above Average
WITH cte AS (
    SELECT AVG(purchase_amount) AS average_spend
    FROM customer
)
SELECT c.customer_id,
       c.purchase_amount
FROM customer c
CROSS JOIN cte
WHERE c.discount_applied = 'Yes'
  AND c.purchase_amount >= cte.average_spend;

-- Top 5 Products with Highest Average Review Rating
SELECT item_purchased , 
	ROUND(AVG(review_rating)::numeric,2) AS average_rating 
FROM customer 
GROUP BY item_purchased 
ORDER BY average_rating DESC
LIMIT 5;

--Average Purchase Comparison: Standard vs Express Shipping
SELECT shipping_type,
	ROUND(AVG(purchase_amount),2) AS average_purchase_value
FROM customer 
WHERE shipping_type IN ('Standard','Express')
GROUP BY shipping_type;

--Subscriber vs Non-Subscriber Revenue Comparison
SELECT subscription_status ,
	COUNT(customer_id) AS total_customers,
	ROUND(AVG(purchase_amount),2) AS average_purchase,
	SUM(purchase_amount) AS total_purchase
FROM customer
GROUP BY subscription_status;

--Top 5 Products with Highest Discount Usage Percentage
SELECT item_purchased,
	ROUND(
		SUM(CASE WHEN discount_applied='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2
	) AS discount_usage_percentage
FROM customer
GROUP BY item_purchased
ORDER BY discount_usage_percentage DESC
LIMIT 5;

--Customer Segmentation (New, Returning, Loyal)
WITH cte AS(
	SELECT customer_id,
			CASE 
				WHEN previous_purchases = 1 THEN 'New'
				WHEN previous_purchases BETWEEN 2 AND 9 THEN 'Repeat'
				ELSE 'Loyal'
			END AS customer_segment
	FROM customer
)
SELECT customer_segment,
		COUNT(*) AS total_customer
FROM cte 
GROUP BY customer_segment
ORDER BY total_customer DESC;


--Top 3 Most Purchased Products Within Each Category
WITH category_product_total AS(
	SELECT category,
			item_purchased,
			COUNT(*) AS total_orders
	FROM customer
	GROUP BY category,item_purchased
),
ranking_product AS(
	SELECT category,
			item_purchased,
			total_orders,
			DENSE_RANK() OVER (PARTITION BY category ORDER BY total_orders DESC) AS rnk
	FROM category_product_total
)

SELECT category,
		item_purchased,
		total_orders 
FROM ranking_product 
WHERE rnk<=3;

--Repeat buyers and subscription status
SELECT subscription_status,
		COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases>5
GROUP BY subscription_status;

--Revenue Contribution by Age Group
SELECT age_group,
		SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;