/* ============================================================================
 * Project:     E-Commerce Sales Performance & RFM Customer Segmentation
 * Author:      Danil Fedoseenko
 * GitHub:      https://github.com/Dani-kley/ecommerce-rfm-sql-analysis
 * LinkedIn:    https://www.linkedin.com/in/danil-fedoseenko/
 * Created:     November 2026
 * ============================================================================ */

WITH CleanedSales AS (
    SELECT 
        InvoiceNo, 
        Quantity, 
        UnitPrice,
        
        SUBSTR(InvoiceDate, INSTR(InvoiceDate, ' ') - 4, 4) || '-' ||
        printf('%02d', SUBSTR(InvoiceDate, 1, INSTR(InvoiceDate, '/') - 1)) || '-' ||
        printf('%02d', SUBSTR(SUBSTR(InvoiceDate, INSTR(InvoiceDate, '/') + 1), 1, INSTR(SUBSTR(InvoiceDate, INSTR(InvoiceDate, '/') + 1), '/') - 1)) AS ValidDate
    FROM Online_Retail_3
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
      AND Quantity > 0
      AND UnitPrice > 0
)
SELECT
    CASE strftime('%w', ValidDate)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS weekday,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM CleanedSales
GROUP BY strftime('%w', ValidDate)
ORDER BY strftime('%w', ValidDate);