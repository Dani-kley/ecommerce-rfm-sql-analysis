/* ============================================================================
 * Project:     E-Commerce Sales Performance & RFM Customer Segmentation
 * Author:      Danil Fedoseenko
 * GitHub:      https://github.com/Dani-kley/ecommerce-rfm-sql-analysis
 * LinkedIn:    https://www.linkedin.com/in/danil-fedoseenko/
 * Created:     November 2026
 * ============================================================================ */

SELECT
    Country,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue,
    ROUND(
        SUM(Quantity * UnitPrice) /
        COUNT(DISTINCT InvoiceNo),
        2
    ) AS average_order_value
FROM online_retail_3
WHERE CustomerID IS NOT NULL
  AND InvoiceNo NOT LIKE 'C%'
  AND Quantity > 0
  AND UnitPrice > 0
GROUP BY Country
ORDER BY revenue DESC;
