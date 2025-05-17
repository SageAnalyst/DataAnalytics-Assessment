# DataAnalytics-Assessment
This document outlines my approach to solving the SQL assessment questions based on the Adashi database. It details the required tasks per question, the steps I took, errors I encountered along the way, and how I resolved them through reading documentation, testing, and troubleshooting.

Question 1
Required Task:
Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

Objective:
-Retrieve a list of users who:
-Have at least one savings plan (is_regular_savings = 1)
-Have at least one investment plan (is_a_fund = 1)
-Have confirmed deposits
-Are sorted by the total amount deposited (in Naira)

Steps:
Step 1: Select User ID
Step 2: Handle Empty Name Column
Step 3: Count Savings Plans
Step 4: Count Investment Plans
Step 5: Calculate Total Deposits
Step 6: Specify Tables and Relationships
Step 7: Filter Out Null Deposits
Step 8: Group by User
Step 9: Ensure Users Have Both Types of Plans
Step 10: Order by Total Deposits

Issue	
1. Empty name column: after I called my query I found out that the name column was empty but I have a first and last name in separate columns
   Fix: Decided to call the first name and last name column into one single column to get the full name

2. Misuse of arithmetic + for strings: the new 'name' column came out as '0'.
   Fix: I researched and found that in MySQL, '+' is used for numerical addition, not string concatenation. I rewrote the query using CONCAT()

3. Ensuring only users with both plan types
   Fix: I Used HAVING with conditional statements

4. Naira/kobo conversion: the values were in kobo not naira
   Fix: Divided by 100.0 and rounded to 2 decimal places

Question 2
Required Task:
1. Write a query to categorize customers by their average number of successful transactions per month into three groups:
-High Frequency (≥ 10/month)
-Medium Frequency (3–9/month)
-Low Frequency (< 3/month)
2. Return the number of users in each group and their average monthly transaction frequency.

Objective:
Identify customers based on how often they make successful transactions.
Categorize each user into:
- High Frequency: ≥ 10 transactions/month
- Medium Frequency: 3–9 transactions/month
- Low Frequency: < 3 transactions/month
Return:
- The number of users in each frequency category
- The average number of monthly transactions per category

Steps:
Step 1: Calculate Monthly Transaction Counts
Step 2: Calculate Average Monthly Transactions per User
Step 3: Join with User Table and Categorize
Step 4: Aggregate and Display Results

Issues:
1. Needed to calculate monthly frequency
   Fix: Created monthly_txn CTE to group by month and user.
2. Findng Average per customer
   Fix: Used AVG() in the second CTE to compute mean monthly frequency.
3. Assigning frequency labels
   Fix: Used CASE WHEN to assign users to frequency categories based on thresholds.
4. Default alphabetical order of categories
   Fix: Overrode using ORDER BY FIELD(...) to match desired logic-based order.

Question 3
Required Task:
Write a query to find all active savings or investment plans that have had no transactions in the last 365 days, or have never had a transaction.

Objective:
- Retrieve a list of non-archived and non-deleted plans that:
- Have no recorded transactions, or
- Haven’t had a transaction in the last 365 days
  
Return:
- Plan ID and owner ID
- Type of plan (Savings or Investment)
- Last transaction date (if any)
- Number of days since the last transaction

Steps:
-- STEP 1: I will pick all active (not archived or deleted) plans.
-- STEP 2: Join transaction data so we can find the last transaction per plan.
-- STEP 3: Group by plan to aggregate transactions.
-- STEP 4: Use HAVING to filter plans with no recent transactions or no transactions at all.
-- STEP 5: Calculate inactivity as days since last transaction using DATEDIFF.
-- STEP 6: Label plans as Savings or Investment using CASE on plan flags.

Issues:
1. Needed to handle plans with no transactions at all
   Fix: I Used LEFT JOIN and checked for MAX(transaction_date) IS NULL in HAVING.
2. Needed to detect long-term inactivity
   Fix: Used DATEDIFF(CURRENT_DATE, MAX(...)) > 365.
3. Plan types weren’t clearly distinguishable
   Fix: Used CASE to assign Savings, Investment, or Other labels.
4. Grouping errors due to expression aliasing
   Fix: Explicitly included type in the GROUP BY clause to avoid issues with SQL standards.

Question 4
Required Task:
Write a query to calculate the Customer Lifetime Value (CLV) based on account tenure and transaction history for each customer.

Objective:
Retrieve customer details including:
- Full name (concatenated first and last names)
- Account tenure in months (time since signup)
- Total number of transactions
- An estimated CLV calculated from transactions and tenure
- Sort customers by estimated CLV in descending order

Steps:
 Step 1: Select Customer Details and Concatenate Name
 Step 2: Calculate Customer Tenure in Months
 Step 3: Count Total Transactions
 Step 4: Calculate Estimated CLVStep 5: Join Customer and Transaction Tables 
 Step 5: Join Customer and Transaction Tables
 Step 6: Group and Order Results

Issues:
1. Empty name column when concatenating first and last names
   Fix: Used CONCAT() with a space to combine names correctly.
2. Division by zero if tenure is zero months
   Fix: Used NULLIF() to prevent divide-by-zero errors.
3. Transaction values were in kobo but not used directly
   Fix: Simplified by assuming each transaction contributes equally to CLV.
4. Customers with no transactions excluded by inner join
   Fix: Used LEFT JOIN to include customers without transactions.

Conclusion
Through this assessment, I improved my SQL debugging skills and deepened my understanding of:
String concatenation
Conditional aggregation
Date/time functions in MySQL
Handling edge cases like division by zero
I encountered multiple errors, but resolved them through documentation, experimentation, and troubleshooting. This hands-on process significantly enhanced my practical SQL skills
