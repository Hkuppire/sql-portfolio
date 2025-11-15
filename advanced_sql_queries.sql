-- 1. Total sales per customer
SELECT 
    customer_id,
    SUM(order_amount) AS total_spent
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 2. Rank products by revenue using window functions
SELECT
    product_id,
    SUM(quantity * price) AS revenue,
    RANK() OVER (ORDER BY SUM(quantity * price) DESC) AS revenue_rank
FROM order_items
GROUP BY product_id;

-- 3. Monthly active users
WITH monthly_users AS (
    SELECT 
        user_id,
        DATE_TRUNC('month', activity_date) AS activity_month
    FROM user_activity
)
SELECT activity_month, COUNT(DISTINCT user_id) AS mau
FROM monthly_users
GROUP BY activity_month
ORDER BY activity_month;

-- 4. Products that never sold
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 5. Customer retention: first purchase vs repeat
WITH first_purchase AS (
    SELECT customer_id, MIN(order_date) AS first_date
    FROM orders
    GROUP BY customer_id
),
repeat_purchase AS (
    SELECT customer_id, COUNT(*) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT 
    f.customer_id,
    f.first_date,
    r.total_orders
FROM first_purchase f
JOIN repeat_purchase r ON f.customer_id = r.customer_id
ORDER BY total_orders DESC;
