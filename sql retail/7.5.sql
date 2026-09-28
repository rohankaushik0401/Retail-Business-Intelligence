-- ===========================================================
-- PHASE 7.5 – SELLER INTELLIGENCE
-- Focus: Seller Performance, Reliability & Risk
-- ===========================================================


-- ===========================================================
-- QUERY 1 : SELLER REVENUE PRODUCTIVITY
-- Business Question:
-- Which sellers generate the most revenue relative to
-- the number of products they sell?
-- ===========================================================

WITH seller_metrics AS
(
    SELECT
        seller_id,
        COUNT(DISTINCT product_id) AS products_handled,
        SUM(payment_value) AS revenue
    FROM fact_sales_fe
    GROUP BY seller_id
)

SELECT
    seller_id,
    products_handled,
    ROUND(revenue,2) AS revenue,

    ROUND(
        revenue / NULLIF(products_handled,0),
        2
    ) AS revenue_per_product,

    RANK() OVER
    (
        ORDER BY
        revenue / NULLIF(products_handled,0) DESC
    ) AS productivity_rank

FROM seller_metrics

ORDER BY productivity_rank;


-- ===========================================================
-- QUERY 2 : SELLER ORDER VALUE CONSISTENCY
-- Business Question:
-- Which sellers maintain consistent order values and
-- which sellers have highly unpredictable order values?
-- ===========================================================

WITH seller_orders AS
(
    SELECT
        seller_id,
        order_id,
        SUM(payment_value) AS order_value
    FROM fact_sales_fe
    GROUP BY seller_id, order_id
)

SELECT
    seller_id,

    COUNT(*) AS total_orders,

    ROUND(AVG(order_value),2) AS average_order_value,

    ROUND(STDDEV(order_value),2) AS order_value_stddev,

    ROUND(
        STDDEV(order_value)
        /
        NULLIF(AVG(order_value),0),
        2
    ) AS order_value_variability,

    CASE
        WHEN STDDEV(order_value)
             / NULLIF(AVG(order_value),0) <= 0.30
            THEN 'Highly Consistent'

        WHEN STDDEV(order_value)
             / NULLIF(AVG(order_value),0) <= 0.60
            THEN 'Moderately Consistent'

        ELSE 'Highly Variable'
    END AS consistency_class

FROM seller_orders

GROUP BY seller_id

HAVING COUNT(*) >= 5

ORDER BY order_value_variability DESC;


-- ===========================================================
-- QUERY 3 : SELLER CUSTOMER REACH
-- Business Question:
-- Which sellers have the widest customer base?
-- ===========================================================

SELECT

    seller_id,

    COUNT(DISTINCT customer_unique_id)
        AS unique_customers,

    COUNT(DISTINCT order_id)
        AS total_orders,

    ROUND(
        COUNT(DISTINCT order_id)
        /
        NULLIF(
            COUNT(DISTINCT customer_unique_id),
            0
        ),
        2
    ) AS orders_per_customer

FROM fact_sales_fe

GROUP BY seller_id

ORDER BY unique_customers DESC;


-- ===========================================================
-- QUERY 4 : SELLER DEPENDENCY RISK
-- Business Question:
-- Which sellers depend heavily on a small number of
-- customers for their revenue?
-- ===========================================================

WITH seller_customer_revenue AS
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

seller_totals AS
(
    SELECT

        seller_id,

        SUM(customer_revenue) AS total_revenue

    FROM seller_customer_revenue

    GROUP BY seller_id
),

customer_rank AS
(
    SELECT

        scr.seller_id,

        scr.customer_unique_id,

        scr.customer_revenue,

        st.total_revenue,

        ROW_NUMBER() OVER
        (
            PARTITION BY scr.seller_id
            ORDER BY scr.customer_revenue DESC
        ) AS customer_rank

    FROM seller_customer_revenue scr

    JOIN seller_totals st

        ON scr.seller_id = st.seller_id
)

SELECT

    seller_id,

    ROUND(
        SUM(
            CASE
                WHEN customer_rank <= 5
                THEN customer_revenue
                ELSE 0
            END
        )
        /
        NULLIF(MAX(total_revenue),0)
        * 100,
        2
    ) AS top_5_customer_revenue_share_pct
FROM customer_rank

GROUP BY seller_id

ORDER BY top_5_customer_revenue_share_pct;


-- ===========================================================
-- QUERY 5 : SELLER CATEGORY SPECIALIZATION
-- Business Question:
-- Which sellers are highly specialized in one category
-- versus sellers operating across many categories?
-- ===========================================================

WITH seller_categories AS
(
    SELECT

        seller_id,

        product_category_name_english,

        SUM(payment_value) AS category_revenue

    FROM fact_sales_fe

    GROUP BY
        seller_id,
        product_category_name_english
),

seller_totals AS
(
    SELECT

        seller_id,

        SUM(category_revenue) AS total_revenue,

        COUNT(DISTINCT product_category_name_english)
            AS category_count

    FROM seller_categories

    GROUP BY seller_id
),

category_rank AS
(
    SELECT

        sc.seller_id,

        sc.category_revenue,

        st.total_revenue,

        st.category_count,

        RANK() OVER
        (
            PARTITION BY sc.seller_id
            ORDER BY sc.category_revenue DESC
        ) AS category_rank

    FROM seller_categories sc

    JOIN seller_totals st

        ON sc.seller_id = st.seller_id
)

SELECT

    seller_id,

    category_count,

    ROUND(
        MAX(
            CASE
                WHEN category_rank = 1
                THEN category_revenue
            END
        )
        /
        NULLIF(MAX(total_revenue),0)
        * 100,
        2
    ) AS dominant_category_share,

    CASE

        WHEN category_count = 1
            THEN 'Pure Specialist'

        WHEN
            MAX(
                CASE
                    WHEN category_rank = 1
                    THEN category_revenue
                END
            )
            /
            NULLIF(MAX(total_revenue),0) >= 0.75
            THEN 'Highly Specialized'

        WHEN category_count >= 5
            THEN 'Diversified'

        ELSE 'Balanced'

    END AS seller_profile

FROM category_rank

GROUP BY
    seller_id,
    category_count

ORDER BY dominant_category_share ;



-- ===========================================================
-- QUERY 6 : SELLER PORTFOLIO RISK SCORE
-- Business Question:
-- Which sellers represent the greatest business risk
-- based on concentration, specialization and customer dependency?
-- ==========================================================



WITH seller_customer AS
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

seller_summary AS
(
    SELECT

        seller_id,

        SUM(customer_revenue) AS total_revenue,

        COUNT(DISTINCT customer_unique_id)
            AS customer_count

    FROM seller_customer

    GROUP BY seller_id
),

customer_rank AS
(
    SELECT

        ss.seller_id,

        customer_revenue,

        total_revenue,

        ROW_NUMBER() OVER
        (
            PARTITION BY seller_id
            ORDER BY customer_revenue DESC
        ) AS rn

    FROM seller_customer sc

    JOIN seller_summary ss

        ON sc.seller_id = ss.seller_id
)

SELECT

    seller_id,

    ROUND(MAX(total_revenue),2) AS total_revenue,

    count(customer_revenue)AS customer_count,

    ROUND(

        SUM(
            CASE
                WHEN rn <= 3
                THEN customer_revenue
                ELSE 0
            END
        )
        /
        NULLIF(MAX(total_revenue),0)
        * 100,

        2

    ) AS top_3_customer_dependency,

    CASE

        WHEN
            SUM(
                CASE
                    WHEN rn <= 3
                    THEN customer_revenue
                    ELSE 0
                END
            )
            /
            NULLIF(MAX(total_revenue),0) >= 0.70
            THEN 'High Risk'

        WHEN
            SUM(
                CASE
                    WHEN rn <= 3
                    THEN customer_revenue
                    ELSE 0
                END
            )
            /
            NULLIF(MAX(total_revenue),0) >= 0.40
            THEN 'Medium Risk'

        ELSE 'Low Risk'

    END AS seller_risk

FROM customer_rank

GROUP BY seller_id

ORDER BY

    CASE seller_risk
        WHEN 'High Risk' THEN 1
        WHEN 'Medium Risk' THEN 2
        ELSE 3
    END,

    top_3_customer_dependency DESC;