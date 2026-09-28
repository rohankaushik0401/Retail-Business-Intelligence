-- ===========================================================
-- PHASE 7.6 – SUPPLY CHAIN INTELLIGENCE
-- ===========================================================



-- ===========================================================
-- QUERY 1 : DELIVERY SLA BREACH ANALYSIS
-- Business Question:
-- Which orders exceeded the expected delivery date?
-- ===========================================================

SELECT

    order_id,

    customer_unique_id,

    order_purchase_timestamp,

    order_delivered_customer_date,

    order_estimated_delivery_date,

    DATEDIFF(
        order_delivered_customer_date,
        order_estimated_delivery_date
    ) AS delivery_variance_days,

    CASE

        WHEN order_delivered_customer_date
             > order_estimated_delivery_date
            THEN 'SLA Breach'

        WHEN order_delivered_customer_date
             = order_estimated_delivery_date
            THEN 'On SLA'

        ELSE 'Early Delivery'

    END AS delivery_status

FROM fact_sales_fe

WHERE order_delivered_customer_date IS NOT NULL

  AND order_estimated_delivery_date IS NOT NULL

ORDER BY delivery_variance_days DESC;


-- ===========================================================
-- QUERY 2 : REGIONAL DELIVERY RISK
-- Business Question:
-- Which customer states experience the highest
-- proportion of late deliveries?
-- ===========================================================

WITH order_delivery AS
(
    SELECT

        customer_state,

        order_id,

        CASE

            WHEN MAX(order_delivered_customer_date)
                 > MAX(order_estimated_delivery_date)

                THEN 1

            ELSE 0

        END AS late_order

    FROM fact_sales_fe

    WHERE order_delivered_customer_date IS NOT NULL

      AND order_estimated_delivery_date IS NOT NULL

    GROUP BY
        customer_state,
        order_id
)

SELECT

    customer_state,

    COUNT(*) AS total_orders,

    SUM(late_order) AS late_orders,

    ROUND(

        SUM(late_order)
        / COUNT(*) * 100,

        2

    ) AS late_delivery_rate

FROM order_delivery

GROUP BY customer_state

HAVING COUNT(*) >= 20

ORDER BY late_delivery_rate DESC;


-- ===========================================================
-- QUERY 3 : FREIGHT BURDEN BY REGION
-- Business Question:
-- Which customer regions bear the highest freight burden
-- relative to merchandise value?
-- ===========================================================

SELECT

    customer_state,

    ROUND(SUM(price),2) AS merchandise_value,

    ROUND(SUM(freight_value),2) AS freight_cost,

    ROUND(

        SUM(freight_value)
        /
        NULLIF(SUM(price),0)
        * 100,

        2

    ) AS freight_burden_percentage

FROM fact_sales_fe

GROUP BY customer_state

HAVING SUM(price) > 0

ORDER BY freight_burden_percentage DESC;


-- ===========================================================
-- QUERY 4 : SELLER-TO-CUSTOMER LOGISTICS GAP
-- Business Question:
-- Which seller regions consistently take longer
-- to reach customers?
-- ===========================================================

SELECT

    seller_state,

    customer_state,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(

        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),

        2

    ) AS average_delivery_days

FROM fact_sales_fe

WHERE order_delivered_customer_date IS NOT NULL

GROUP BY

    seller_state,
    customer_state

HAVING COUNT(DISTINCT order_id) >= 20

ORDER BY average_delivery_days DESC;


-- ===========================================================
-- QUERY 5 : LOGISTICS ROUTE PERFORMANCE
-- Business Question:
-- Which seller → customer routes are operationally
-- inefficient?
-- ===========================================================

WITH routes AS
(
    SELECT

        seller_state,

        customer_state,

        order_id,

        DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        ) AS delivery_days

    FROM fact_sales_fe

    WHERE order_delivered_customer_date IS NOT NULL
)

SELECT

    seller_state,

    customer_state,

    COUNT(DISTINCT order_id) AS order_volume,

    ROUND(AVG(delivery_days),2) AS avg_delivery_days,

    MAX(delivery_days) AS worst_delivery_days,

    ROUND(STDDEV(delivery_days),2)
        AS delivery_variability

FROM routes

GROUP BY

    seller_state,
    customer_state

HAVING COUNT(DISTINCT order_id) >= 20

ORDER BY

    avg_delivery_days DESC;


-- ===========================================================
-- QUERY 6 : FREIGHT EFFICIENCY BY PRODUCT CATEGORY
-- Business Question:
-- Which product categories are expensive to ship
-- relative to their selling value?
-- ===========================================================

SELECT

    product_category_name_english AS category,

    ROUND(SUM(price),2) AS product_value,

    ROUND(SUM(freight_value),2) AS freight_cost,

    ROUND(

        SUM(freight_value)
        /
        NULLIF(SUM(price),0)
        * 100,

        2

    ) AS freight_to_value_ratio,

    COUNT(DISTINCT order_id) AS orders

FROM fact_sales_fe

GROUP BY product_category_name_english

HAVING SUM(price) > 0

ORDER BY freight_to_value_ratio DESC;


-- ===========================================================
-- QUERY 7 : DELIVERY DELAY IMPACT ON CUSTOMER EXPERIENCE
-- Business Question:
-- Does late delivery correspond with lower review scores?
-- ===========================================================

WITH order_status AS
(
    SELECT

        order_id,

        AVG(review_score) AS review_score,

        CASE

            WHEN MAX(order_delivered_customer_date)
                 > MAX(order_estimated_delivery_date)

                THEN 'Late'

            ELSE 'On Time'

        END AS delivery_status

    FROM fact_sales_fe

    WHERE order_delivered_customer_date IS NOT NULL

      AND order_estimated_delivery_date IS NOT NULL

    GROUP BY order_id
)

SELECT

    delivery_status,

    COUNT(*) AS orders,

    ROUND(AVG(review_score),2)
        AS average_review_score,

    ROUND(
        MIN(review_score),2
    ) AS minimum_review_score,

    ROUND(
        MAX(review_score),2
    ) AS maximum_review_score

FROM order_status

GROUP BY delivery_status

ORDER BY delivery_status;


-- ===========================================================
-- QUERY 8 : SUPPLY CHAIN BOTTLENECK DETECTION
-- Business Question:
-- Which stage of the order journey contributes most
-- to total fulfillment time?
-- ===========================================================

WITH order_stages AS
(
    SELECT

        order_id,

        DATEDIFF(
            MAX(order_approved_at),
            MAX(order_purchase_timestamp)
        ) AS purchase_to_approval,

        DATEDIFF(
            MAX(order_delivered_carrier_date),
            MAX(order_approved_at)
        ) AS approval_to_carrier,

        DATEDIFF(
            MAX(order_delivered_customer_date),
            MAX(order_delivered_carrier_date)
        ) AS carrier_to_customer

    FROM fact_sales_fe

    GROUP BY order_id
)

SELECT

    ROUND(
        AVG(purchase_to_approval),
        2
    ) AS avg_purchase_to_approval,

    ROUND(
        AVG(approval_to_carrier),
        2
    ) AS avg_approval_to_carrier,

    ROUND(
        AVG(carrier_to_customer),
        2
    ) AS avg_carrier_to_customer

FROM order_stages;


-- ===========================================================
-- QUERY 9 : HIGH-RISK SUPPLY CHAIN SEGMENTS
-- Business Question:
-- Which state/category combinations combine high
-- freight burden with poor delivery performance?
-- ===========================================================

WITH segment_metrics AS
(
    SELECT

        customer_state,

        product_category_name_english,

        COUNT(DISTINCT order_id) AS orders,

        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ) AS avg_delivery_days,

        SUM(freight_value)
        /
        NULLIF(SUM(price),0) AS freight_ratio,

        SUM(

            CASE

                WHEN order_delivered_customer_date
                     > order_estimated_delivery_date

                    THEN 1

                ELSE 0

            END

        )
        /
        COUNT(DISTINCT order_id) AS late_rate

    FROM fact_sales_fe

    WHERE order_delivered_customer_date IS NOT NULL

      AND order_estimated_delivery_date IS NOT NULL

    GROUP BY

        customer_state,
        product_category_name_english
)

SELECT

    customer_state,

    product_category_name_english,

    orders,

    ROUND(avg_delivery_days,2)
        AS avg_delivery_days,

    ROUND(freight_ratio * 100,2)
        AS freight_ratio_percentage,

    ROUND(late_rate * 100,2)
        AS late_delivery_percentage,

    ROUND(

        (
            late_rate * 0.50
        )
        +
        (
            freight_ratio * 0.30
        )
        +
        (
            avg_delivery_days
            /
            NULLIF(
                MAX(avg_delivery_days) OVER(),
                0
            )
            * 0.20
        ),

        4

    ) AS supply_chain_risk_score

FROM segment_metrics

WHERE orders >= 20

ORDER BY supply_chain_risk_score DESC;


