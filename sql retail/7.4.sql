-- ===========================================================
-- PHASE 7.4 – INVENTORY INTELLIGENCE
-- ===========================================================



-- ===========================================================
-- QUERY 1 : DEAD STOCK DETECTION
-- Business Question:
-- Which products have inventory but almost no demand?
-- ===========================================================

SELECT

    product_id,

    SUM(current_stock) AS current_stock,

    SUM(avg_monthly_demand) AS total_demand,

    ROUND(
        SUM(current_stock)
        /
        NULLIF(SUM(avg_monthly_demand),0),
        2
    ) AS stock_to_demand_ratio

FROM inventory_bases

GROUP BY product_id

HAVING
    SUM(current_stock) > 0
    AND SUM(avg_monthly_demand) <= 1

ORDER BY stock_to_demand_ratio DESC;


-- ===========================================================
-- QUERY 2 : OVERSTOCK DETECTION
-- Business Question:
-- Which products are holding substantially more inventory
-- than their expected demand?
-- ===========================================================

SELECT

    product_id,

    ROUND(AVG(current_stock),2) AS avg_stock,

    ROUND(AVG(avg_monthly_demand),2) AS avg_monthly_demand,

    ROUND(
        AVG(current_stock)
        /
        NULLIF(AVG(avg_monthly_demand),0),
        2
    ) AS stock_cover_ratio

FROM inventory_bases

GROUP BY product_id

HAVING stock_cover_ratio > 3

ORDER BY stock_cover_ratio DESC;




-- ===========================================================
-- QUERY 3 : ABC INVENTORY CLASSIFICATION
-- Business Question:
-- Which products account for the majority of inventory value?
-- ===========================================================

WITH product_value AS
(
    SELECT

        product_id,

        SUM(Annual_Demand_Value) AS inventory_value

    FROM inventory_kpi

    GROUP BY product_id
),

ranked AS
(
    SELECT

        product_id,

        inventory_value,

        SUM(inventory_value)
        OVER(
            ORDER BY inventory_value DESC
        ) AS cumulative_value,

        SUM(inventory_value)
        OVER() AS total_value

    FROM product_value
)

SELECT

    product_id,

    inventory_value,

    ROUND(
        cumulative_value * 100
        / NULLIF(total_value,0),
        2
    ) AS cumulative_percentage,

    CASE

        WHEN cumulative_value / total_value <= 0.80
            THEN 'A'

        WHEN cumulative_value / total_value <= 0.95
            THEN 'B'

        ELSE 'C'

    END AS abc_class

FROM ranked

ORDER BY inventory_value DESC;


-- ===========================================================
-- QUERY 4 : XYZ DEMAND CLASSIFICATION
-- Business Question:
-- Which products have stable vs unpredictable demand?
-- ===========================================================

WITH demand_metrics AS
(
    SELECT

        product_id,

        AVG(avg_monthly_demand) AS avg_demand,

        STDDEV(avg_monthly_demand) AS demand_std

    FROM inventory_bases

    GROUP BY product_id
)

SELECT

    product_id,

    ROUND(avg_demand,2) AS avg_demand,

    ROUND(demand_std,2) AS demand_std,

    ROUND(
        demand_std
        /
        NULLIF(avg_demand,0),
        2
    ) AS coefficient_of_variation,

    CASE

        WHEN demand_std / NULLIF(avg_demand,0) <= 0.50
            THEN 'X - Stable'

        WHEN demand_std / NULLIF(avg_demand,0) <= 1.00
            THEN 'Y - Variable'

        ELSE 'Z - Highly Variable'

    END AS xyz_class

FROM demand_metrics

ORDER BY coefficient_of_variation DESC;


-- ===========================================================
-- QUERY 5 : ABC-XYZ MATRIX
-- Business Question:
-- Which products are both financially important
-- and demand-risky?
-- ===========================================================

WITH product_value AS
(
    SELECT

        product_id,

        SUM(annual_demand_value) AS inventory_value

    FROM inventory_kpi

    GROUP BY product_id
),

abc AS
(
    SELECT

        product_id,

        inventory_value,

        SUM(inventory_value)
        OVER(
            ORDER BY inventory_value DESC
        )
        /
        SUM(inventory_value)
        OVER() AS cumulative_share

    FROM product_value
),

demand AS
(
    SELECT

        product_id,

        AVG(avg_monthly_demand) AS avg_demand,

        STDDEV(avg_monthly_demand) AS demand_std

    FROM inventory_bases

    GROUP BY product_id
)

SELECT

    a.product_id,

    a.inventory_value,

    CASE

        WHEN a.cumulative_share <= 0.80
            THEN 'A'

        WHEN a.cumulative_share <= 0.95
            THEN 'B'

        ELSE 'C'

    END AS abc_class,

    CASE

        WHEN d.demand_std / NULLIF(d.avg_demand,0) <= 0.50
            THEN 'X'

        WHEN d.demand_std / NULLIF(d.avg_demand,0) <= 1.00
            THEN 'Y'

        ELSE 'Z'

    END AS xyz_class,

    CONCAT(

        CASE
            WHEN a.cumulative_share <= 0.80 THEN 'A'
            WHEN a.cumulative_share <= 0.95 THEN 'B'
            ELSE 'C'
        END,

        CASE
            WHEN d.demand_std / NULLIF(d.avg_demand,0) <= 0.50 THEN 'X'
            WHEN d.demand_std / NULLIF(d.avg_demand,0) <= 1.00 THEN 'Y'
            ELSE 'Z'
        END

    ) AS abc_xyz_class

FROM abc a

JOIN demand d

ON a.product_id = d.product_id

ORDER BY abc_xyz_class;



-- ===========================================================
-- QUERY 6 : REORDER PRIORITY SCORE
-- Business Question:
-- Which products should be replenished first?
-- ===========================================================

WITH metrics AS
(
    SELECT

        product_id,

        AVG(current_stock) AS stock,

        AVG(avg_monthly_demand) AS demand,

        AVG(safety_stock) AS safety_stock

    FROM inventory_bases

    GROUP BY product_id
)

SELECT

    product_id,

    ROUND(stock,2) AS current_stock,

    ROUND(demand,2) AS monthly_demand,

    ROUND(safety_stock,2) AS safety_stock,

    ROUND(

        (
            (demand / NULLIF(stock,1))
            +
            (safety_stock / NULLIF(stock,1))
        ),

        2

    ) AS reorder_priority_score

FROM metrics

WHERE stock < safety_stock

   OR stock < demand

ORDER BY reorder_priority_score DESC;