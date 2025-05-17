-- Assessment_Q4.sql
-- Estimate CLV per customer based on tenure, transaction count, and average profit per transaction

WITH customer_tenure AS (
    -- Calculate account tenure in months
    SELECT
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        date_joined,
        GREATEST(
            TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE),
            1
        ) AS tenure_months
    FROM users_customuser
),
transactions AS (
    -- Aggregate total transactions and sum of deposits per customer
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) / 100.0 AS total_deposit_amount -- kobo to naira
    FROM savings_savingsaccount
    GROUP BY owner_id
),
clv_calc AS (
    -- Calculate average profit per transaction and estimated CLV
    SELECT
        ct.customer_id,
        ct.name,
        ct.tenure_months,
        COALESCE(t.total_transactions, 0) AS total_transactions,
        CASE 
            WHEN t.total_transactions > 0 THEN (t.total_deposit_amount * 0.001) / t.total_transactions
            ELSE 0
        END AS avg_profit_per_transaction
    FROM customer_tenure ct
    LEFT JOIN transactions t ON ct.customer_id = t.owner_id
)

SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(
        CASE 
            WHEN tenure_months > 0 THEN (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
            ELSE 0
        END
    , 2) AS estimated_clv
FROM clv_calc
ORDER BY estimated_clv DESC;
