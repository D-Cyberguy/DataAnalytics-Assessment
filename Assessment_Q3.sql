-- Assessment_Q3
-- Find active plans with no transactions in the last 1 year (365 days)

WITH last_transactions AS (
    -- Get the last transaction date per plan
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM plans_plan AS p
    LEFT JOIN savings_savingsaccount AS s
      ON p.id = s.plan_id 
     AND p.owner_id = s.owner_id
    WHERE p.is_deleted = 0
    GROUP BY p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
)

SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURRENT_DATE, last_transaction_date) AS inactivity_days
FROM last_transactions
WHERE last_transaction_date <= CURRENT_DATE - INTERVAL 365 DAY
ORDER BY inactivity_days DESC;
