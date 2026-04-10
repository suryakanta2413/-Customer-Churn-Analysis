create database customer_churn;
use customer_churn;

-- 1. Overall churn rate
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer;

-- 2. Churn by Contract Type
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer
GROUP BY Contract
ORDER BY churn_rate DESC;

-- 3. Churn by Internet Service Type
SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer
GROUP BY InternetService
ORDER BY churn_rate DESC;

-- 4. Average Tenure — Churned vs. Retained Customers
SELECT 
    Churn,
    ROUND(AVG(tenure), 1) AS avg_tenure_months,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(AVG(TotalCharges), 2) AS avg_total_charges
FROM customer
GROUP BY Churn;

-- 5. Calculate monthly revenue lost & total revenue lost
SELECT 
    round(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END),2) AS monthly_revenue_lost,
    round(SUM(CASE WHEN Churn = 'Yes' THEN TotalCharges ELSE 0 END),2) AS total_revenue_lost
FROM customer;

-- 6. Churn by SeniorCitizen
SELECT 
    SeniorCitizen,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer
GROUP BY SeniorCitizen;

-- 7. churn by OnlineSecurity and TechSupport
SELECT 
    OnlineSecurity,
    TechSupport,
    COUNT(*) AS total,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer
WHERE InternetService != 'No'
GROUP BY OnlineSecurity, TechSupport
ORDER BY churn_rate DESC;

-- 8. High-Risk Customer Segments
SELECT 
    Contract,
    InternetService,
    PaymentMethod,
    COUNT(*) AS total,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer
GROUP BY Contract, InternetService, PaymentMethod
HAVING COUNT(*) > 20
ORDER BY churn_rate DESC
LIMIT 10;
