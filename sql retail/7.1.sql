
SET SQL_SAFE_UPDATES = 1;
set global local_infile=1;
use retail;
select* from fact_sales_fe;


-- 1.

WITH product_rev AS (
SELECT
product_id,
SUM(payment_value) revenue
FROM fact_sales_fe
GROUP BY product_id
),

ranked AS
(
SELECT *,
SUM(revenue) OVER() total_rev,
SUM(revenue) OVER(
ORDER BY revenue DESC
) cumulative_rev,
ROW_NUMBER() OVER(
ORDER BY revenue DESC
) rn,
COUNT(*) OVER() total_products
FROM product_rev
)

SELECT
product_id,
revenue,cumulative_rev,total_rev,
ROUND(cumulative_rev*100/(total_rev),2) cumulative_pct
FROM ranked
WHERE rn<=CEIL(total_products*0.20);



-- 2. 

WITH product_rev AS
(
SELECT
product_id,
SUM(payment_value) revenue
FROM fact_sales_fe
GROUP BY product_id
)

SELECT
MAX(revenue),
AVG(revenue),
STDDEV(revenue),
ROUND(MAX(revenue)/AVG(revenue),2) concentration_index
FROM product_rev;


-- 3. 



WITH product_sales AS
(
SELECT
product_category_name_english,
product_id,
SUM(payment_value) revenue
FROM fact_sales_fe
GROUP BY product_category_name_english,product_id
),

category_avg AS
(
SELECT
product_category_name_english,
AVG(revenue) avg_rev
FROM product_sales
GROUP BY product_category_name_english
)

SELECT
p.product_id,
p.product_category_name_english,
p.revenue,
c.avg_rev,
ROUND(
(p.revenue-c.avg_rev)/c.avg_rev*100,
2
) pct_above_category
FROM product_sales p
JOIN category_avg c
ON p.product_category_name_english=c.product_category_name_english
ORDER BY pct_above_category DESC;



-- 4. 
WITH monthly_sales AS
(
SELECT
product_id,
DATE_FORMAT(order_purchase_timestamp,'%Y-%m') month,
SUM(payment_value) revenue
FROM fact_sales_fe
GROUP BY product_id,month
)

SELECT
product_id,
AVG(revenue) avg_rev,
STDDEV(revenue) volatility,
ROUND(
STDDEV(revenue)/AVG(revenue),
2
) cv
FROM monthly_sales
GROUP BY product_id
ORDER BY cv;

-- 5. 


SELECT
seller_id,

SUM(payment_value) revenue,

AVG(delivery_days) avg_delivery,

AVG(review_score) avg_review,

ROUND(
SUM(payment_value)
/AVG(delivery_days),
2
) efficiency_score

FROM fact_sales_fe
GROUP BY seller_id

ORDER BY efficiency_score DESC;


-- 6. 


SELECT
seller_id,

round(SUM(payment_value),2) revenue,


round(avg(delivery_delay),2) avg_delay

FROM fact_sales_fe

WHERE delivery_delay>0

GROUP BY seller_id

ORDER BY revenue DESC;


-- 7.


WITH customer_stats AS
(
SELECT

customer_unique_id,

COUNT(DISTINCT order_id) orders,

SUM(payment_value) spend,

AVG(payment_value) avg_order,
dense_rank()over(order by SUM(payment_value)desc) rnk
FROM fact_sales_fe

GROUP BY customer_unique_id
)

SELECT *

FROM customer_stats

ORDER BY spend DESC;


-- 8. 


WITH customer_rev AS
(
SELECT
customer_unique_id,
SUM(payment_value) revenue
FROM fact_sales_fe
GROUP BY customer_unique_id
)

SELECT

ROUND(
SUM(revenue),
2
)

FROM

(
SELECT *

FROM customer_rev

ORDER BY revenue DESC

LIMIT 5
) as xx;


SELECT

f.product_id,

SUM(f.payment_value) revenue,

k.annual_demand_value,

ROUND(

SUM(f.payment_value)

/k.annual_demand_value,

2

) opportunity_index

FROM fact_sales_fe f

JOIN inventory_kpi k

USING(product_id)

GROUP BY
f.product_id,
k.annual_demand_value

ORDER BY opportunity_index DESC;

























