-- Assessment_Q1
-- Identify customers with at least one funded savings and investment plan
-- Display counts of each plan type and total deposits, ordered by total deposits

WITH savings_plans_funded AS (
    -- Get distinct savings plans with deposits per customer
    SELECT DISTINCT p.owner_id, p.id AS plan_id
    FROM plans_plan AS p
    JOIN savings_savingsaccount AS s 
      ON p.id = s.plan_id 
     AND p.owner_id = s.owner_id
    WHERE p.is_regular_savings = 1
      AND s.confirmed_amount > 0
),
investment_plans_funded AS (
    -- Get distinct investment plans with deposits per customer
    SELECT DISTINCT p.owner_id, p.id AS plan_id
    FROM plans_plan AS p
    JOIN savings_savingsaccount AS s 
      ON p.id = s.plan_id 
     AND p.owner_id = s.owner_id
    WHERE p.is_a_fund = 1
      AND s.confirmed_amount > 0
),
savings_count AS (
    -- Count savings plans per customer
    SELECT owner_id, COUNT(DISTINCT plan_id) AS savings_count
    FROM savings_plans_funded
    GROUP BY owner_id
),
investment_count AS (
    -- Count investment plans per customer
    SELECT owner_id, COUNT(DISTINCT plan_id) AS investment_count
    FROM investment_plans_funded
    GROUP BY owner_id
),
total_deposits AS (
    -- Sum all confirmed deposits per customer, convert kobo to naira
    SELECT owner_id, SUM(confirmed_amount) / 100.0 AS total_deposits
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
)

SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COALESCE(sc.savings_count, 0) AS savings_count,
    COALESCE(ic.investment_count, 0) AS investment_count,
    ROUND(COALESCE(td.total_deposits, 0), 2) AS total_deposits
FROM users_customuser AS u
JOIN savings_count AS sc ON u.id = sc.owner_id
JOIN investment_count AS ic ON u.id = ic.owner_id
LEFT JOIN total_deposits AS td ON u.id = td.owner_id
WHERE sc.savings_count > 0
  AND ic.investment_count > 0
ORDER BY total_deposits DESC;
