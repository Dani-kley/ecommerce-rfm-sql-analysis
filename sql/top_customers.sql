/* ============================================================================
 * Project:     E-Commerce Sales Performance & RFM Customer Segmentation
 * Author:      Danil Fedoseenko
 * GitHub:      https://github.com/Dani-kley/ecommerce-rfm-sql-analysis
 * LinkedIn:    https://www.linkedin.com/in/danil-fedoseenko/
 * Created:     November 2026
 * ============================================================================ */

WITH customer_orders AS (
    SELECT
        CustomerID,
        InvoiceNo,
        SUM(Quantity * UnitPrice) AS order_revenue
    FROM Online_Retail_3
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
      AND Quantity > 0
      AND UnitPrice > 0
    GROUP BY CustomerID, InvoiceNo
)
SELECT
    CustomerID,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_revenue), 2) AS total_revenue
FROM customer_orders
GROUP BY CustomerID
ORDER BY total_revenue DESC
LIMIT 10;