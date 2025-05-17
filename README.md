
---

## Overview

This assessment involved writing precise and efficient SQL queries to address four real-world business scenarios involving customer account data, transaction patterns, and product plans. The focus was on delivering accurate results, optimal performance, and clear, readable queries.

---

## Question 1: High-Value Customers with Multiple Products

**Objective:**  
Identify customers who hold both funded savings and investment plans. Provide counts of each plan type and total deposits, sorted by deposit amount.

**Approach:**  
- Joined `plans_plan` and `savings_savingsaccount` tables to identify plans with deposits (`confirmed_amount > 0`).  
- Used flags `is_regular_savings` and `is_a_fund` to classify plan types.  
- Aggregated counts of savings and investment plans per customer.  
- Summed total deposits (converted from kobo to naira).  
- Filtered customers with at least one plan of each type and ordered by deposits.

**Challenges:**  
- Understanding how different IDs link customers, plans, and transactions since IDs were UUID strings that didn't directly match across tables initially.  
- Distinguishing funded plans required careful joining with transactions, not just relying on plan flags.  
- Ensuring the sum of deposits was correctly aggregated across all relevant plans without double counting.  
- Balancing query complexity and readability while ensuring performance on large datasets.

---

## Question 2: Transaction Frequency Analysis

**Objective:**  
Segment customers based on how frequently they transact by calculating average transactions per month, and categorize them into High, Medium, or Low frequency groups.

**Approach:**  
- Computed total transaction counts and the span of active months per customer using their first and last transaction dates.  
- Calculated average monthly transactions, ensuring a minimum of one month to avoid division errors.  
- Defined frequency categories based on specified thresholds.  
- Aggregated the number of customers and average transaction rates per category.

**Challenges:**  
- Handling customers with only one transaction date or very short activity spans required careful use of date functions to avoid division by zero.  
- Choosing inclusive and mutually exclusive frequency boundaries to avoid misclassification.  
- Making sure the grouping and rounding of average transaction rates were accurate and meaningful.  
- Optimizing the query for clarity while dealing with date calculations and aggregations.

---

## Question 3: Account Inactivity Alert

**Objective:**  
Identify active accounts (savings or investment) with no transactions in the last 365 days.

**Approach:**  
- For each plan, determined the most recent transaction date via a left join with the transaction table.  
- Classified plans as Savings or Investment based on plan flags.  
- Filtered to accounts inactive for more than a year, calculating inactivity duration in days.

**Challenges:**  
- Handling plans that had no transactions at all and ensuring they were flagged as inactive appropriately.  
- Interpreting inactivity correctly with respect to the current date, especially for plans with very old last transaction dates.  
- Ensuring the query logic accurately captured the one-year threshold and accounted for different date formats.  
- Balancing performance when dealing with large numbers of plans and transactions.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

**Objective:**  
Estimate CLV per customer using account tenure, transaction volume, and profit per transaction.

**Approach:**  
- Calculated tenure in months from signup date to current date.  
- Aggregated total transactions and total deposit amounts per customer.  
- Derived average profit per transaction assuming 0.1% profit on deposits.  
- Computed estimated CLV using the provided formula and rounded for clarity.

**Challenges:**  
- Managing customers with zero transactions to avoid division by zero errors.  
- Aligning the profit calculation with transaction counts and deposits in different units (kobo vs naira).  
- Ensuring the tenure calculation handled edge cases where signup dates were recent or missing.  
- Maintaining clarity in the formula implementation while ensuring SQL efficiency.

---

# General Notes

- Amounts stored in kobo were consistently converted to naira by dividing by 100 for all monetary calculations.  
- Consistent aliasing and modular use of Common Table Expressions (CTEs) improved query readability and maintainability.  
- Comments were added throughout the SQL scripts to clarify logic, business rules, and calculation steps.  
- Queries were designed to be performant on large datasets, leveraging indexed columns for joins and filters.  
- Edge cases such as missing transactions or recent signups were carefully handled to prevent errors or misleading results.

---

If you have any questions or would like further clarifications, feel free to reach out!

---

*Prepared by Ayomide Aderibigbe*

*Date: 17/05/2025*
