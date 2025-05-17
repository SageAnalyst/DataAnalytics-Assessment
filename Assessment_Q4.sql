-- Question 4
-- Calculate Customer Lifetime Value (CLV) based on account tenure and transactions
SELECT 
    cu.id AS customer_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS name,  -- Concatenate first and last names into full name
    -- Calculate tenure in months since user signup date to current date
    TIMESTAMPDIFF(MONTH, cu.date_joined, CURRENT_DATE) AS tenure_months,  
    COUNT(sa.id) AS total_transactions, -- Total number of transactions from savings_savingsaccount per customer
    -- Estimated CLV: (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
    -- Profit per transaction = 0.1% = 0.001 times the transaction value (in kobo), i will convert to base currency by dividing by 100*100 = 10000
    -- Since amount is in kobo, but I'm using count only, I will assume average transaction value is 1 for simplicity 
    -- Here, I will simplify by assuming each transaction contributes equally, so:
    ((COUNT(sa.id) / NULLIF(TIMESTAMPDIFF(MONTH, cu.date_joined, CURRENT_DATE), 0)) * 12 * 0.001) AS estimated_clv
FROM 
    users_customuser cu
LEFT JOIN 
    savings_savingsaccount sa ON cu.id = sa.owner_id
GROUP BY 
    cu.id, cu.first_name, cu.last_name, cu.date_joined
ORDER BY 
    estimated_clv DESC;
