-- Database creation
Create database financial_variance_analysis;
use financial_variance_analysis;

SELECT * 
FROM financial_variance_analysis
LIMIT 10;

-- Queries 
-- Total KPI
SELECT 
    SUM(budget_amount) AS total_budget,
    SUM(actual_amount) AS total_actual,
    SUM(Variance) AS total_variance,
    (SUM(Variance)/SUM(budget_amount))*100 AS variance_pct
FROM financial_variance_analysis;

-- Category-wise Spending
SELECT 
    Category,
    SUM(actual_amount) AS total_spent
FROM financial_variance_analysis
GROUP BY Category
ORDER BY total_spent DESC;

-- Monthly Budget vs Actual
SELECT 
    Year,
    Month,
    SUM(budget_amount) AS total_budget,
    SUM(actual_amount) AS total_actual
FROM financial_variance_analysis
GROUP BY Year, Month
ORDER BY Year, Month;

-- Overspend vs Savings Count
SELECT 
    CASE 
        WHEN Variance > 0 THEN 'Overspend'
        ELSE 'Savings'
    END AS status,
    COUNT(*) AS transaction_count
FROM financial_variance_analysis
GROUP BY status;

-- Top 5 Risky Departments
SELECT 
    Department,
    SUM(Variance) AS total_overspend
FROM financial_variance_analysis
WHERE Variance > 0
GROUP BY Department
ORDER BY total_overspend DESC
LIMIT 5;

-- Department Share of Total Spend
SELECT 
    Department,
    SUM(actual_amount) AS dept_spend,
    SUM(actual_amount) * 100 / 
        SUM(SUM(actual_amount)) OVER() AS spend_share_pct
FROM financial_variance_analysis
GROUP BY Department;

-- Rank Departments by Variance
SELECT 
    Department,
    SUM(Variance) AS total_variance,
    RANK() OVER (ORDER BY SUM(Variance) DESC) AS variance_rank
FROM financial_variance_analysis
GROUP BY Department;

-- Running Total 
SELECT 
    Year,
    Month,
    SUM(actual_amount) AS monthly_spend,
    SUM(SUM(actual_amount)) OVER (ORDER BY Year, Month) 
        AS running_total
FROM financial_variance_analysis
GROUP BY Year, Month;

-- Variance % by Department
SELECT 
    Department,
    SUM(Variance) AS total_variance,
    SUM(Variance) * 100 / SUM(budget_amount) AS variance_pct
FROM financial_variance_analysis
GROUP BY Department
ORDER BY variance_pct DESC;

-- Above-Average Spend Transactions
SELECT *
FROM financial_variance_analysis
WHERE actual_amount >
    (SELECT AVG(actual_amount) 
     FROM financial_variance_analysis);






