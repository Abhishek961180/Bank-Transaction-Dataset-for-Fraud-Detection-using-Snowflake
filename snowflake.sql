-- Step 1: Create a Database
    CREATE DATABASE TRANSACTION_DB;

-- Step 2: Set the Current Database Context
    USE DATABASE TRANSACTION_DB;

-- Step 3: Set the Warehouse Context 
    USE WAREHOUSE COMPUTE_WH;

-- Step 4: Create a Schema in the Database
    CREATE SCHEMA FRAUD_ANALYSIS;
    
-- Step 5: Set the Current Schema Context
    USE SCHEMA FRAUD_ANALYSIS;

-- Step 6: Create a Table for Raw Data
    CREATE OR REPLACE TABLE BRONZE_BANK_TRANSACTIONS (
    TransactionID STRING,
    AccountID STRING,
    TransactionAmount FLOAT,
    TransactionDate TIMESTAMP,
    TransactionType STRING,
    Location STRING,
    DeviceID STRING,
    IPAddress STRING,
    MerchantID STRING,
    Channel STRING,
    CustomerAge INT,
    CustomerOccupation STRING,
    TransactionDuration INT,
    LoginAttempts INT,
    AccountBalance FLOAT,
    PreviousTransactionDate TIMESTAMP
);

-- Step 7 Create Storage Integration for S3
    CREATE OR REPLACE STORAGE INTEGRATION my_s3_integration
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::022499005870:role/banking'
STORAGE_ALLOWED_LOCATIONS = ('s3://fraud-detection2/');

--Step 8 Create Stages for Files
   CREATE OR REPLACE STAGE s3_stage
URL = 's3://fraud-detection2/'
CREDENTIALS = (AWS_KEY_ID = ' ' AWS_SECRET_KEY = ' ')
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);



--Step 9 Copy Data from S3 Stage to the Raw Table
    COPY INTO BRONZE_BANK_TRANSACTIONS
FROM @s3_stage
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

--Step 10 Create Date Dimension Table
    CREATE OR REPLACE TABLE DATE_DIMENSION (
    DateID INT PRIMARY KEY,        -- Surrogate key
    FullDate DATE,                 -- Actual date
    Year INT,                      -- Year 
    Quarter INT,                   -- Quarter 
    Month INT,                     -- Month 
    Day INT,                       -- Day of the month
    Weekday STRING,                -- Day of the week 
    IsWeekend BOOLEAN              -- True if Saturday or Sunday
);

--Step 11 Inserting values to Date_Dimension
    INSERT INTO DATE_DIMENSION
SELECT DISTINCT
    TO_NUMBER(TO_CHAR(CAST(TransactionDate AS DATE), 'YYYYMMDD')) AS DateID,
    CAST(TransactionDate AS DATE) AS FullDate,
    YEAR(TransactionDate) AS Year,
    CEIL(MONTH(TransactionDate) / 3) AS Quarter,
    MONTH(TransactionDate) AS Month,
    DAY(TransactionDate) AS Day,
    DAYNAME(TransactionDate) AS Weekday,
    CASE WHEN DAYOFWEEK(TransactionDate) IN (1, 7) THEN TRUE ELSE FALSE END AS IsWeekend
FROM BRONZE_BANK_TRANSACTIONS;

--Step 12 Identify Fraudulent Transactions and List Users
    SELECT DISTINCT AccountID AS FraudulentUser
FROM BRONZE_BANK_TRANSACTIONS
WHERE TransactionAmount > AccountBalance 
   OR LoginAttempts > 3;

--Step 13 Top 3 Most Popular Merchants
    SELECT MerchantID, COUNT(*) AS TransactionCount
FROM BRONZE_BANK_TRANSACTIONS
GROUP BY MerchantID
ORDER BY TransactionCount DESC
LIMIT 3;

--Step 14 Common Channels with Percentages
    SELECT Channel, 
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM BRONZE_BANK_TRANSACTIONS
GROUP BY Channel;

--Step 15 Percentage of Transactions by Location
    SELECT Location, 
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM BRONZE_BANK_TRANSACTIONS
GROUP BY Location;

--Step 16 Top 5 customers with the highest total transaction amounts
    SELECT AccountID, 
       SUM(TransactionAmount) AS TotalSpent
FROM BRONZE_BANK_TRANSACTIONS
GROUP BY AccountID
ORDER BY TotalSpent DESC
LIMIT 5;

--Step 17 Suspicious Activity by Login Attempts
SELECT AccountID, 
       TransactionID, 
       LoginAttempts, 
       TransactionAmount, 
       TransactionDate
FROM BRONZE_BANK_TRANSACTIONS
WHERE LoginAttempts > 3
ORDER BY LoginAttempts DESC;



