-- Question 3: Account Inactivity Alert
-- Find active plans with no transactions in the last 365 days
-- STEP 1: I will pick all active (not archived or deleted) plans.
-- STEP 2: Join transaction data so we can find the last transaction per plan.
-- STEP 3: Group by plan to aggregate transactions.
-- STEP 4: Use HAVING to filter plans with no recent transactions or no transactions at all.
-- STEP 5: Calculate inactivity as days since last transaction using DATEDIFF.
-- STEP 6: Label plans as Savings or Investment using CASE on plan flags.

SELECT 
    pp.id AS plan_id,
    pp.owner_id,
    CASE 
        WHEN pp.is_regular_savings = 1 THEN 'Savings' -- If the plan is marked 1, label it 'Savings'
        WHEN pp.is_a_fund = 1 THEN 'Investment' -- If the plan is marked 1, label it 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(sa.transaction_date) AS last_transaction_date,  -- Get the most recent transaction date from savings_savingsaccount for this plan
    DATEDIFF(CURRENT_DATE, MAX(sa.transaction_date)) AS inactivity_days  -- Calculate days since last transaction by subtracting max transaction date from current date

FROM 
    plans_plan pp
LEFT JOIN 
    savings_savingsaccount sa ON pp.id = sa.plan_id
WHERE 
    pp.is_archived = 0 -- Filter out plans that are archived (inactive)
    AND pp.is_deleted = 0 -- Filter out plans that are deleted
GROUP BY 
    pp.id, pp.owner_id, type
HAVING 
    (MAX(sa.transaction_date) IS NULL -- Include plans with no transactions at all (NULL last transaction date)
    OR DATEDIFF(CURRENT_DATE, MAX(sa.transaction_date)) > 365); -- Or plans with last transaction older than 365 days (inactive);