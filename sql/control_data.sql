/* ============================================================================
 * Project:     E-Commerce Sales Performance & RFM Customer Segmentation
 * Author:      Danil Fedoseenko
 * GitHub:      https://github.com/Dani-kley/ecommerce-rfm-sql-analysis
 * LinkedIn:    https://www.linkedin.com/in/danil-fedoseenko/
 * Created:     November 2026
 * ============================================================================ */	

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE
        WHEN CustomerID IS NULL THEN 1
        ELSE 0
    END) AS missing_customer_id,
    SUM(CASE
        WHEN InvoiceNo LIKE 'C%' THEN 1
        ELSE 0
    END) AS cancellation_rows,
    SUM(CASE
        WHEN Quantity < 0 THEN 1
        ELSE 0
    END) AS negative_quantity_rows,
    SUM(CASE
        WHEN UnitPrice <= 0 THEN 1
        ELSE 0
    END) AS invalid_price_rows
FROM Online_Retail_3;