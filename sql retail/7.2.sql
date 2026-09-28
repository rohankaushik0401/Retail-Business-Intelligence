-- ===========================================================
-- PHASE 7.2 – CUSTOMER INTELLIGENCE
-- ===========================================================

-- ===========================================================
-- QUERY 1 : AVERAGE DAYS BETWEEN PURCHASES
-- Business Question:
-- How often do customers return?
-- ===========================================================

WITH customer_orders AS
(
    SELECT DISTINCT
        customer_unique_id,
        DATE(order_purchase_timestamp) AS purchase_date
    FROM fact_sales_fe
),

purchase_gap AS
(
    SELECT
        customer_unique_id, 
        purchase_date,
        DATEDIFF(
            purchase_date,
            LAG(purchase_date)
            OVER(
                PARTITION BY customer_unique_id
                ORDER BY purchase_date
            )
        ) AS gap_days
    FROM customer_orders
    
),
average_gap as
(SELECT
    customer_unique_id, 
    ROUND(AVG(gap_days),2) AS avg_days_between_orders
FROM purchase_gap
GROUP BY customer_unique_id
ORDER BY avg_days_between_orders)

select  customer_unique_id,avg_days_between_orders from average_gap where avg_days_between_orders is not null;


-- ===========================================================
-- QUERY 2 : RFM ANALYSIS
-- Business Question:
-- Classify customers using Recency, Frequency and Monetary value.
-- ===========================================================

WITH customer_rfm AS
(
SELECT

customer_unique_id,

DATEDIFF(
CURRENT_DATE(),
MAX(order_purchase_timestamp)
) AS recency,

COUNT(order_id) AS frequency,

SUM(payment_value) AS monetary

FROM fact_sales_fe

GROUP BY customer_unique_id
)

SELECT

customer_unique_id,

recency,
frequency,
monetary,

NTILE(5) OVER(ORDER BY recency DESC) AS R,

NTILE(5) OVER(ORDER BY frequency) AS F,

NTILE(5) OVER(ORDER BY monetary) AS M

FROM customer_rfm
order by (R+F+M)desc;


-- ===========================================================
-- QUERY 3 : CUSTOMER SEGMENTATION
-- Business Question:
-- Segment customers according to total spending.
-- ===========================================================

WITH customer_spend AS
(
SELECT

customer_unique_id,

SUM(payment_value) AS spend

FROM fact_sales_fe

GROUP BY customer_unique_id
)

SELECT

customer_unique_id,

spend,

CASE

WHEN spend >= 1000 THEN 'Premium'

WHEN spend >= 600 THEN 'Gold'

WHEN spend >= 300 THEN 'Silver'

ELSE 'Bronze'

END AS customer_segment

FROM customer_spend

ORDER BY spend DESC;




-- ===========================================================
-- QUERY 4 : CHURN CANDIDATES
-- Business Question:
-- Which valuable customers have not purchased recently?
-- ===========================================================

SELECT

customer_unique_id,

SUM(payment_value) AS lifetime_spend,

MAX(order_purchase_timestamp) AS last_purchase,

DATEDIFF(
CURRENT_DATE(),
MAX(order_purchase_timestamp)
) AS inactive_days

FROM fact_sales_fe

GROUP BY customer_unique_id

HAVING inactive_days > 180

ORDER BY lifetime_spend DESC;


-- ===========================================================
-- QUERY 5 : CUSTOMER PROFITABILITY SCORE
-- Business Question:
-- Rank customers considering spending, frequency and review ratings.
-- ===========================================================

WITH customer_metrics AS
(
SELECT

customer_unique_id,

COUNT(DISTINCT order_id) AS total_orders,

SUM(payment_value) AS total_spend,

AVG(review_score) AS average_review

FROM fact_sales_fe

GROUP BY customer_unique_id
)

SELECT

customer_unique_id,

total_orders,

total_spend,

average_review,

ROUND(
(total_spend * average_review)
/total_orders,
2
) AS profitability_score

FROM customer_metrics;



-- ===========================================================
-- QUERY 6 : CUSTOMER PURCHASE JOURNEY
-- Business Question:
-- How many days does it take customers to make
-- their 2nd, 3rd, 4th... purchase?
-- ===========================================================

WITH customer_orders AS
(
    SELECT
        customer_unique_id,
        DATE(order_purchase_timestamp) AS purchase_date,

        ROW_NUMBER() OVER
        (
            PARTITION BY customer_unique_id
            ORDER BY order_purchase_timestamp
        ) AS purchase_number

    FROM
    (
        SELECT DISTINCT
            customer_unique_id,
            order_purchase_timestamp
        FROM fact_sales_fe
    ) t
),

purchase_gap AS
(
    SELECT

        customer_unique_id,

        purchase_number,

        DATEDIFF
        (
            purchase_date,

            LAG(purchase_date)
            OVER
            (
                PARTITION BY customer_unique_id
                ORDER BY purchase_number
            )
        ) AS gap_days

    FROM customer_orders
)

SELECT

    purchase_number,

    ROUND(AVG(gap_days),2) AS average_gap_days

FROM purchase_gap

WHERE purchase_number > 1

GROUP BY purchase_number

ORDER BY purchase_number;



-- ===========================================================
-- QUERY 7 : CUSTOMER CATEGORY AFFINITY
-- Business Question:
-- Which product category does every customer prefer?
-- ===========================================================

WITH category_frequency AS
(
    SELECT

        customer_unique_id,

        product_category_name_english,

        COUNT(*) AS purchases

    FROM fact_sales_fe

    GROUP BY

        customer_unique_id,

        product_category_name_english
),

ranked_categories AS
(
    SELECT

        *,

        ROW_NUMBER() OVER
        (
            PARTITION BY customer_unique_id
            ORDER BY purchases DESC
        ) AS rn

    FROM category_frequency
)

SELECT

    customer_unique_id,

    product_category_name_english AS preferred_category,

    purchases

FROM ranked_categories

WHERE rn = 1;



-- ===========================================================
-- QUERY 8 : CUSTOMER BASKET DIVERSITY SCORE
-- Business Question:
-- Which customers purchase across the highest number
-- of different product categories?
-- ===========================================================

SELECT

    customer_unique_id,

    COUNT(DISTINCT product_category_name_english)
        AS categories_purchased,

    COUNT(DISTINCT order_id)
        AS total_orders,

    ROUND
    (
        COUNT(DISTINCT product_category_name_english)
        /
        COUNT(DISTINCT order_id),

        2
    ) AS basket_diversity_score

FROM fact_sales_fe

GROUP BY customer_unique_id

ORDER BY basket_diversity_score DESC;



-- ===========================================================
-- QUERY 9 : CATEGORY SWITCHING ANALYSIS
-- Business Question:
-- Which customers frequently change the categories
-- they purchase from?
-- ===========================================================

WITH customer_history AS
(
    SELECT

        customer_unique_id,

        order_purchase_timestamp,

        product_category_name_english,

        LAG(product_category_name_english)
        OVER
        (
            PARTITION BY customer_unique_id
            ORDER BY order_purchase_timestamp
        ) AS previous_category

    FROM
    (
        SELECT DISTINCT

            customer_unique_id,

            order_purchase_timestamp,

            product_category_name_english

        FROM fact_sales_fe
    ) t
)

SELECT

    customer_unique_id,

    COUNT(*) AS category_switches

FROM customer_history

WHERE

    previous_category IS NOT NULL

    AND previous_category <> product_category_name_english

GROUP BY customer_unique_id

ORDER BY category_switches DESC;



-- ===========================================================
-- QUERY 10 : CUSTOMER LOYALTY SCORE
-- Business Question:
-- Generate a weighted loyalty score using
-- Orders + Spend + Review Rating.
-- ===========================================================

WITH customer_metrics AS
(
    SELECT

        customer_unique_id,

        COUNT(DISTINCT order_id) AS total_orders,

        SUM(payment_value) AS total_spend,

        AVG(review_score) AS average_review

    FROM fact_sales_fe

    GROUP BY customer_unique_id
)

SELECT

    customer_unique_id,

    total_orders,

    total_spend,

    average_review,

    ROUND
    (
        (total_orders * 0.35)
        +
        ((total_spend / 1000) * 0.45)
        +
        (average_review * 0.20),

        2
    ) AS loyalty_score

FROM customer_metrics

ORDER BY loyalty_score DESC;