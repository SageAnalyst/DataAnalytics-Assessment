-- Question 2
-- customers by transaction frequency per month
-- Step 1: Get monthly transaction counts for each customer
-- Step 2: Calculate the average monthly transactions for each customer
-- Step 3: Join with user table and assign transaction frequency categories
-- Step 4: Aggregate how many customers fall into each frequency group
-- i will be using common table expressions (CTE) as my temporary table

-- CTE 1: this CTE will hold the number of transactions each customer made per month that will be used to calculate the average 
WITH monthly_txn AS (
    SELECT 
        sa.owner_id,
        DATE_FORMAT(sa.transaction_date, '%Y-%m') AS txn_month, -- Extracting year and month in 'YYYY-MM' format
        COUNT(*) AS txn_count 
    FROM savings_savingsaccount sa
    WHERE sa.transaction_status = 'success' -- Only include successful transactions
    GROUP BY sa.owner_id, txn_month
),

-- CTE 2: this CTE will hold the average number of monthly transactions per customer that will be used in categorizing customers
avg_txn_per_customer AS (
    SELECT 
        owner_id,
        AVG(txn_count) AS avg_txn_per_month
    FROM monthly_txn
    GROUP BY owner_id
),

-- CTE 3: this CTE will be used to categorize customers based on transaction frequency and retrieve their names
categorized AS (
    SELECT 
        atc.owner_id,
        cu.first_name,
        cu.last_name,
        CONCAT(TRIM(cu.first_name), ' ', TRIM(cu.last_name)) AS name,  -- Combine first and last name into one full name
        atc.avg_txn_per_month,
        CASE 
            WHEN atc.avg_txn_per_month >= 10 THEN 'High Frequency' -- More than 10 transactions/month
            WHEN atc.avg_txn_per_month >= 3 THEN 'Medium Frequency' -- Between 3 and 9
            ELSE 'Low Frequency' -- less than 3
        END AS frequency_category -- Assign a label based on average frequency
    FROM avg_txn_per_customer atc
    JOIN users_customuser cu ON atc.owner_id = cu.id
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');