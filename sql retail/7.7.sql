-- ===========================================================
-- PHASE 7.8 – FINANCIAL & REVENUE INTELLIGENCE
-- TOP 5 QUERIES
-- ===========================================================



-- ===========================================================
-- QUERY 1 : REVENUE REALIZATION GAP
-- Business Question:
-- How much of the merchandise value is actually realized
-- after considering freight and payment amounts?
-- ===========================================================

WITH order_financials AS
(
    SELECT

        order_id,

        SUM(price) AS merchandise_value,

        SUM(freight_value) AS freight_value,

        MAX(payment_value) AS payment_value

    FROM fact_sales_fe

    GROUP BY order_id
)

SELECT

    order_id,

    ROUND(merchandise_value,2)
        AS merchandise_value,

    ROUND(freight_value,2)
        AS freight_value,

    ROUND(payment_value,2)
        AS payment_value,

    ROUND(

        payment_value
        -
        merchandise_value
        -
        freight_value,

        2

    ) AS payment_gap,

    CASE

        WHEN ABS(
            payment_value
            -
            merchandise_value
            -
            freight_value
        ) < 0.01

            THEN 'Reconciled'

        WHEN payment_value
             >
             merchandise_value + freight_value

            THEN 'Payment Above Order Value'

        ELSE 'Payment Below Order Value'

    END AS reconciliation_status

FROM order_financials

ORDER BY ABS(payment_gap) DESC;


-- ===========================================================
-- QUERY 2 : FREIGHT COST EFFICIENCY
-- Business Question:
-- Which orders consume an unusually large proportion
-- of their merchandise value in freight?
-- ===========================================================

SELECT

    order_id,

    ROUND(SUM(price),2)
        AS merchandise_value,

    ROUND(SUM(freight_value),2)
        AS freight_cost,

    ROUND(

        SUM(freight_value)
        /
        NULLIF(SUM(price),0)
        * 100,

        2

    ) AS freight_cost_percentage,

    CASE

        WHEN SUM(freight_value)
             /
             NULLIF(SUM(price),0) >= 0.50

            THEN 'Severe Freight Burden'

        WHEN SUM(freight_value)
             /
             NULLIF(SUM(price),0) >= 0.25

            THEN 'High Freight Burden'

        WHEN SUM(freight_value)
             /
             NULLIF(SUM(price),0) >= 0.10

            THEN 'Moderate Freight Burden'

        ELSE 'Efficient'

    END AS freight_efficiency

FROM fact_sales_fe

GROUP BY order_id

HAVING SUM(price) > 0

ORDER BY freight_cost_percentage DESC;


-- ===========================================================
-- QUERY 3 : PAYMENT METHOD ECONOMICS
-- Business Question:
-- How do different payment methods compare in terms of
-- order value, installments and customer spending?
-- ===========================================================

SELECT

    payment_type,

    COUNT(DISTINCT order_id)
        AS total_orders,

    COUNT(DISTINCT customer_unique_id)
        AS unique_customers,

    ROUND(
        SUM(payment_value),
        2
    ) AS total_payment_value,

    ROUND(
        AVG(payment_value),
        2
    ) AS average_payment_value,

    ROUND(
        AVG(payment_installments),
        2
    ) AS average_installments,

    ROUND(

        SUM(payment_value)
        /
        NULLIF(COUNT(DISTINCT order_id),0),

        2

    ) AS revenue_per_order

FROM fact_sales_fe

GROUP BY payment_type

ORDER BY total_payment_value DESC;


-- ===========================================================
-- QUERY 4 : REVENUE CONCENTRATION RISK
-- Business Question:
-- How dependent is total revenue on a small group of
-- sellers?
-- ===========================================================

WITH seller_revenue AS
(
    SELECT

        seller_id,

        SUM(payment_value) AS revenue

    FROM fact_sales_fe

    GROUP BY seller_id
),

ranked AS
(
    SELECT

        seller_id,

        revenue,

        SUM(revenue)
        OVER(
            ORDER BY revenue DESC
        ) AS cumulative_revenue,

        SUM(revenue)
        OVER() AS total_revenue,

        ROW_NUMBER()
        OVER(
            ORDER BY revenue DESC
        ) AS seller_rank,

        COUNT(*)
        OVER() AS seller_count

    FROM seller_revenue
)

SELECT

    seller_id,

    ROUND(revenue,2)
        AS revenue,

    seller_rank,

    ROUND(

        cumulative_revenue
        /
        NULLIF(total_revenue,0)
        * 100,

        2

    ) AS cumulative_revenue_percentage,

    ROUND(

        revenue
        /
        NULLIF(total_revenue,0)
        * 100,

        2

    ) AS individual_revenue_share

FROM ranked

WHERE seller_rank <= CEIL(seller_count * 0.20)

ORDER BY seller_rank;


