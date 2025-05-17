-- Question 1
-- Customers with at least one funded savings and investment plan, ordered by total deposit

SELECT
    cu.id AS owner_id,
-- name column is empty therefore first name and last name column is retrieved and concatenated into a name column
   CONCAT(TRIM(cu.first_name), ' ', TRIM(cu.last_name)) AS name,
   
-- Count the number of plans for each user with ATLEAST ONE SAVINGS PLAN as savings_count
   COUNT(DISTINCT 
	CASE 
		WHEN pp.is_regular_savings >= 1 
        THEN pp.id 
	END) AS savings_count,

-- Count the number of plans for each user with ATLEAST ONE INVESTMENT PLAN as investment_count
   COUNT(DISTINCT 
	CASE
		WHEN pp.is_a_fund >= 1 
        THEN pp.id 
	END) AS investment_count,
    
-- convert kobo to naira
   ROUND(SUM(sa.confirmed_amount) / 100.0, 2) AS total_deposits
   
FROM users_customuser cu
JOIN plans_plan pp ON cu.id = pp.owner_id
JOIN savings_savingsaccount sa ON pp.id = sa.plan_id
WHERE sa.confirmed_amount IS NOT NULL
GROUP BY cu.id, cu.name
HAVING 
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 THEN pp.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 THEN pp.id END) >= 1
ORDER BY total_deposits DESC;