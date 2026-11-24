/* ============================================================================
 * Project:     E-Commerce Sales Performance & RFM Customer Segmentation
 * Author:      Danil Fedoseenko
 * GitHub:      https://github.com/Dani-kley/ecommerce-rfm-sql-analysis
 * LinkedIn:    https://www.linkedin.com/in/danil-fedoseenko/
 * Created:     November 2026
 * ============================================================================ */
SELECT
    StockCode,
    Description,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM Online_Retail_3
WHERE CustomerID IS NOT NULL
  AND InvoiceNo NOT LIKE 'C%'
  AND Quantity > 0
  AND UnitPrice > 0
GROUP BY StockCode, Description
ORDER BY revenue DESC
LIMIT 10;