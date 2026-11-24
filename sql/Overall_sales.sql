/* ============================================================================
 * Project:     E-Commerce Sales Performance & RFM Customer Segmentation
 * Author:      Danil Fedoseenko
 * GitHub:      https://github.com/Dani-kley/ecommerce-rfm-sql-analysis
 * LinkedIn:    https://www.linkedin.com/in/danil-fedoseenko/
 * Created:     November 2026
 * ============================================================================ */

SELECT
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    ROUND(
        SUM(Quantity * UnitPrice) /
        COUNT(DISTINCT InvoiceNo),
        2
    ) AS average_order_value,
    SUM(Quantity) AS units_sold
FROM Online_Retail_3
WHERE CustomerID IS NOT NULL
  AND InvoiceNo NOT LIKE 'C%'
  AND Quantity > 0
  AND UnitPrice > 0;
