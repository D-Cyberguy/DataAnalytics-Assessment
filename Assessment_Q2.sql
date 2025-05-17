-- Assessment_Q2
-- Categorize customers by their average monthly transactions into High, Medium, Low frequency groups

WITH transactions_per_customer AS (
    -- Count total transactions and get first/last transaction dates per customer
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        MIN(transaction_date) AS first_transaction,
        MAX(transaction_date) AS last_transaction
    FROM savings_savingsaccount
    GROUP BY owner_id
),
customer_activity AS (
    -- Calculate active months and average transactions per month
    SELECT
        owner_id,
        total_transactions,
        first_transaction,
        last_transaction,
        GREATEST(
            TIMESTAMPDIFF(MONTH, first_transaction, last_transaction),
            1
        ) AS active_months,
        total_transactions / GREATEST(
            TIMESTAMPDIFF(MONTH, first_transaction, last_transaction),
            1
        ) AS avg_transactions_per_month
    FROM transactions_per_customer
),
categorized AS (
    -- Categorize customers based on average transactions per month
    SELECT
        owner_id,
        total_transactions,
        active_months,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_activity
)

SELECT
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;


