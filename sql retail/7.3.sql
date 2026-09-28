-- ===========================================================
--  PRODUCT INTELLIGENCE
-- ===========================================================

-- ===========================================================
-- QUERY 1 : PRODUCT MOMENTUM SCORE
-- Business Question:
-- Which products are gaining sales momentum month-over-month?
-- ===========================================================

WITH monthly_sales AS
(
SELECT

product_id,

DATE_FORMAT(order_purchase_timestamp,'%Y-%m') sales_month,

SUM(payment_value) revenue

FROM fact_sales_fe

GROUP BY product_id,sales_month
),

growth AS
(
SELECT

product_id,

sales_month,

revenue,

LAG(revenue)
OVER(
PARTITION BY product_id
ORDER BY sales_month
) previous_month

FROM monthly_sales
)

SELECT

product_id,

sales_month,

revenue,

previous_month,

ROUND(
(revenue-previous_month)*100/previous_month,
2
) growth_percentage

FROM growth

WHERE previous_month IS NOT NULL

ORDER BY growth_percentage DESC;



-- ===========================================================
-- QUERY 2 : PRODUCT LIFE CYCLE CLASSIFICATION
-- Business Question:
-- Identify whether products are New, Growing,
-- Mature or Declining.
-- ===========================================================

WITH product_sales AS
(
SELECT

product_id,

COUNT(DISTINCT order_id) total_orders,

SUM(payment_value) revenue

FROM fact_sales_fe

GROUP BY product_id
)

SELECT

product_id,

total_orders,

revenue,

CASE

WHEN total_orders<=10 THEN 'New'

WHEN total_orders<=50 THEN 'Growing'

WHEN total_orders<=150 THEN 'Mature'

ELSE 'Established'

END product_stage

FROM product_sales

ORDER BY revenue DESC;





-- ===========================================================
-- QUERY 3 : PRODUCT REVENUE EFFICIENCY
-- Business Question:
-- Revenue generated per order.
-- ===========================================================

SELECT

product_id,

SUM(payment_value) revenue,

COUNT(DISTINCT order_id) orders,

ROUND(

SUM(payment_value)

/

COUNT(DISTINCT order_id),

2

) revenue_per_order

FROM fact_sales_fe

GROUP BY product_id

ORDER BY revenue_per_order DESC;





-- ===========================================================
-- QUERY 4 : PRODUCT CONCENTRATION (PARETO)
-- Business Question:
-- What percentage of revenue comes from
-- the Top 20% products?
-- ===========================================================

WITH product_revenue AS
(
SELECT

product_id,

SUM(payment_value) revenue

FROM fact_sales_fe

GROUP BY product_id
),

ranked AS
(
SELECT

*,

SUM(revenue)
OVER() total_revenue,

SUM(revenue)
OVER(
ORDER BY revenue DESC
) cumulative_revenue,

ROW_NUMBER()
OVER(
ORDER BY revenue DESC
) rn,

COUNT(*)
OVER() total_products

FROM product_revenue
)

SELECT

product_id,

revenue,

ROUND(

cumulative_revenue*100

/

total_revenue,

2

) cumulative_percentage

FROM ranked

WHERE rn<=CEIL(total_products*0.20);



-- ===========================================================
-- QUERY 5 : PRODUCT DEMAND VOLATILITY
-- Business Question:
-- Which products experience the most
-- unstable monthly demand?
-- ===========================================================

WITH monthly_orders AS
(
SELECT

product_id,

DATE_FORMAT(order_purchase_timestamp,'%Y-%m') sales_month,

COUNT(*) demand

FROM fact_sales_fe

GROUP BY product_id,sales_month
)

SELECT

product_id,

AVG(demand) average_demand,

STDDEV(demand) demand_std,

ROUND(

STDDEV(demand)

/AVG(demand),

2

) coefficient_of_variation

FROM monthly_orders

GROUP BY product_id

ORDER BY coefficient_of_variation DESC;


-- ===========================================================
-- QUERY 6 : PRODUCT CATEGORY DEPENDENCY
-- Business Question:
-- Which products contribute the highest percentage
-- of revenue within their category?
-- ===========================================================

WITH product_sales AS
(
SELECT

product_category_name_english,

product_id,

SUM(payment_value) revenue

FROM fact_sales_fe

GROUP BY

product_category_name_english,

product_id
),

category_sales AS
(
SELECT

product_category_name_english,

SUM(revenue) category_revenue

FROM product_sales

GROUP BY product_category_name_english
)

SELECT

p.product_id,

p.product_category_name_english,

p.revenue,

ROUND(

p.revenue*100

/

c.category_revenue,

2

) category_share

FROM product_sales p

JOIN category_sales c

ON p.product_category_name_english=c.product_category_name_english

ORDER BY category_share DESC;