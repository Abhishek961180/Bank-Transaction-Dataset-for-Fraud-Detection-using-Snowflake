# Bank Transaction Dataset for Fraud Detection

## Project Overview
This project analyzes a bank transaction dataset to identify fraud, optimize operations, and gain customer behavior insights. By leveraging modern data engineering and analytical tools, the project aims to enhance decision-making and improve business performance.

## Objectives
- Detect fraudulent transactions and list the users involved.
- Identify the top 3 high-volume merchants.
- Analyze common transaction channels and calculate their percentages.
- Determine the percentage of transactions by location.
- List the top 5 customers with the highest total transaction amounts.
- Detect suspicious activity through multiple login attempts.

## Technology Stack
- **AWS Cloud**: For secure data storage and processing.
- **Python**: For data cleaning and automation.
- **Snowflake**: For data warehousing and analytical queries.

## Workflow
1. **Data Upload**: 
   - Local CSV file (`fraud_data.csv`) uploaded to an AWS S3 bucket using Python and `boto3`.
   - Duplicate and null values removed during preprocessing.

2. **AWS S3 and IAM**:
   - Created and configured an IAM role for secure access to S3.
   - Data stored in S3 for easy integration with Snowflake.

3. **Snowflake Setup**:
   - Organized a database (`TRANSACTION_DB`) with schemas for fraud analysis.
   - Created dimension tables (Date, Location, Merchant, Account).
   - Integrated external S3 storage for seamless data ingestion.

4. **Data Transformation**:
   - Ingested raw data into Snowflake's `BRONZE_BANK_TRANSACTIONS` table.
   - Designed a staging schema for processing.

5. **Key Performance Indicators (KPIs)**:
   - Fraudulent transactions and user identification.
   - Most popular merchants.
   - Channel usage percentages.
   - Geographic transaction percentages.
   - High-value customer analysis.
   - Suspicious login activity detection.

## Queries
- **Query 1**: Identify fraudulent transactions based on transaction amount and login attempts.
- **Query 2**: Find the top 3 most popular merchants.
- **Query 3**: Calculate the percentage of transactions by channel.
- **Query 4**: Analyze transaction percentages by location.
- **Query 5**: Identify the top 5 customers by transaction amount.
- **Query 6**: Detect suspicious activity from multiple login attempts.

## Data Flow
1. **Source**: Local dataset (`fraud_data.csv`) uploaded to AWS S3.
2. **Snowflake Integration**:
   - Data staged and transformed for analysis.
   - Dimensional tables created for reporting.
3. **Insights**:
   - Reports generated for fraud detection, customer behavior, and business performance.

## Visualization
Data insights are visualized through charts and reports, providing actionable recommendations for fraud monitoring, resource allocation, and customer engagement.

## How to Use
1. Clone this repository.
2. Set up AWS credentials and Snowflake account.
3. Follow the Python scripts for uploading data and querying insights.
4. Explore the queries and generate visualizations.

## Contact
For questions or collaborations, feel free to reach out via [LinkedIn](https://linkedin.com/in/abhishek-harikantra-0aab56266).

---

This README provides a clear and concise overview of the project, making it easy for others to understand and use your work. Let me know if you'd like any adjustments! 
