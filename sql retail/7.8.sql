-- ===========================================================
-- PHASE 7.10 – EXECUTIVE / DECISION INTELLIGENCE
-- TOP 5 QUERIES
-- ===========================================================



-- ===========================================================
-- QUERY 1 : PRODUCT ACTION MATRIX
-- Business Question:
-- Which products require immediate management attention?
--
-- Combines:
--   Demand + inventory position + sales activity
-- ===========================================================

WITH product_metrics AS
(
    SELECT

        product_id,

        AVG(avg_monthly_demand) AS avg_demand,

        AVG(current_stock) AS avg_stock,

        AVG(safety_stock) AS avg_safety_stock

    FROM inventory_bases

    GROUP BY product_id
),

sales_metrics AS
(
    SELECT

        product_id,

        SUM(payment_value) AS revenue,

        COUNT(DISTINCT order_id) AS orders

    FROM fact_sales_fe

    GROUP BY product_id
)

SELECT

    p.product_id,

    ROUND(p.avg_demand,2) AS avg_monthly_demand,

    ROUND(p.avg_stock,2) AS average_stock,

    ROUND(p.avg_safety_stock,2) AS safety_stock,

    ROUND(s.revenue,2) AS revenue,

    s.orders,

    CASE

        WHEN p.avg_stock < p.avg_safety_stock
         AND p.avg_demand > 0

            THEN 'URGENT REPLENISHMENT'

        WHEN p.avg_stock > p.avg_demand * 3
         AND s.orders < (
                SELECT AVG(order_count)
                FROM
                (
                    SELECT
                        product_id,
                        COUNT(DISTINCT order_id) AS order_count
                    FROM fact_sales_fe
                    GROUP BY product_id
                ) x
            )

            THEN 'REDUCE INVENTORY'

        WHEN p.avg_demand > 0
         AND p.avg_stock < p.avg_demand

            THEN 'MONITOR STOCK'

        ELSE 'NORMAL'

    END AS management_action

FROM product_metrics p

LEFT JOIN sales_metrics s

    ON p.product_id = s.product_id

ORDER BY

    CASE management_action

        WHEN 'URGENT REPLENISHMENT' THEN 1
        WHEN 'REDUCE INVENTORY' THEN 2
        WHEN 'MONITOR STOCK' THEN 3
        ELSE 4

    END;


-- ===========================================================
-- QUERY 2 : SELLER STRATEGIC PRIORITIZATION
-- Business Question:
-- Which sellers deserve strategic attention based on
-- revenue contribution and customer dependency?
-- ===========================================================

WITH seller_revenue AS
(
    SELECT

        seller_id,

        SUM(payment_value) AS revenue,

        COUNT(DISTINCT order_id) AS orders,

        COUNT(DISTINCT customer_unique_id)
            AS customers

    FROM fact_sales_fe

    GROUP BY seller_id
),

seller_customer AS
(
    SELECT

        seller_id,

        customer_unique_id,

        SUM(payment_value) AS customer_revenue

    FROM fact_sales_fe

    GROUP BY

        seller_id,
        customer_unique_id
),

ranked_customers AS
(
    SELECT

        seller_id,

        customer_revenue,

        ROW_NUMBER() OVER
        (
            PARTITION BY seller_id
            ORDER BY customer_revenue DESC
        ) AS customer_rank

    FROM seller_customer
),

dependency AS
(
    SELECT

        seller_id,

        SUM(
            CASE
                WHEN customer_rank <= 3
                THEN customer_revenue
                ELSE 0
            END
        ) AS top_customer_revenue

    FROM ranked_customers

    GROUP BY seller_id
)

SELECT

    s.seller_id,

    ROUND(s.revenue,2) AS revenue,

    s.orders,

    s.customers,

    ROUND(

        d.top_customer_revenue
        /
        NULLIF(s.revenue,0)
        * 100,

        2

    ) AS top_3_customer_dependency,

    CASE

        WHEN s.revenue >=
             (
                SELECT AVG(revenue)
                FROM seller_revenue
             )
         AND
         d.top_customer_revenue
         /
         NULLIF(s.revenue,0) >= 0.60

            THEN 'HIGH VALUE / HIGH RISK'

        WHEN s.revenue >=
             (
                SELECT AVG(revenue)
                FROM seller_revenue
             )

            THEN 'STRATEGIC SELLER'

        WHEN
            d.top_customer_revenue
            /
            NULLIF(s.revenue,0) >= 0.60

            THEN 'DEPENDENCY RISK'

        ELSE 'STANDARD'

    END AS seller_action

FROM seller_revenue s

JOIN dependency d

    ON s.seller_id = d.seller_id

ORDER BY

    CASE seller_action

        WHEN 'HIGH VALUE / HIGH RISK' THEN 1
        WHEN 'STRATEGIC SELLER' THEN 2
        WHEN 'DEPENDENCY RISK' THEN 3
        ELSE 4

    END,

    s.revenue DESC;



-- ===========================================================
-- QUERY 3 : CATEGORY INVESTMENT PRIORITY
-- Business Question:
-- Which product categories combine strong commercial
-- performance with operational efficiency?
-- ===========================================================

WITH category_metrics AS
(
    SELECT

        product_category_name_english AS category,

        SUM(payment_value) AS revenue,

        COUNT(DISTINCT order_id) AS orders,

        AVG(review_score) AS avg_review,

        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ) AS avg_delivery_days,

        SUM(freight_value)
        /
        NULLIF(SUM(price),0) AS freight_ratio

    FROM fact_sales_fe

    WHERE order_delivered_customer_date IS NOT NULL

    GROUP BY product_category_name_english
)

SELECT

    category,

    ROUND(revenue,2) AS revenue,

    orders,

    ROUND(avg_review,2) AS average_review,

    ROUND(avg_delivery_days,2)
        AS average_delivery_days,

    ROUND(freight_ratio * 100,2)
        AS freight_ratio_percentage,

    CASE

        WHEN avg_review >= 4
         AND avg_delivery_days <=
             (
                SELECT AVG(avg_delivery_days)
                FROM category_metrics
             )
         AND freight_ratio <
             (
                SELECT AVG(freight_ratio)
                FROM category_metrics
             )

            THEN 'INVEST / SCALE'

        WHEN avg_review < 3.5
         OR avg_delivery_days >
            (
                SELECT AVG(avg_delivery_days)
                FROM category_metrics
            )

            THEN 'IMPROVE OPERATIONS'

        WHEN freight_ratio >
             (
                SELECT AVG(freight_ratio)
                FROM category_metrics
             )

            THEN 'OPTIMIZE LOGISTICS'

        ELSE 'MONITOR'

    END AS category_action

FROM category_metrics

ORDER BY

    CASE category_action

        WHEN 'INVEST / SCALE' THEN 1
        WHEN 'IMPROVE OPERATIONS' THEN 2
        WHEN 'OPTIMIZE LOGISTICS' THEN 3
        ELSE 4

    END,

    revenue DESC;

