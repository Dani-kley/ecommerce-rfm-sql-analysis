/* ============================================================================
 * Project:     E-Commerce Sales Performance & RFM Customer Segmentation
 * Author:      Danil Fedoseenko
 * GitHub:      https://github.com/Dani-kley/ecommerce-rfm-sql-analysis
 * LinkedIn:    https://www.linkedin.com/in/danil-fedoseenko/
 * Created:     November 2026
 * ============================================================================ */
SELECT
    SUBSTR(InvoiceDate, INSTR(InvoiceDate, ' ') - 4, 4) || '-' || 
    CASE 
        WHEN INSTR(InvoiceDate, '/') = 2 THEN '0' || SUBSTR(InvoiceDate, 1, 1)
        ELSE SUBSTR(InvoiceDate, 1, 2)
    END AS month,

    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue,
    COUNT(DISTINCT InvoiceNo) AS orders,
    ROUND(
        SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo), 
        2
    ) AS average_order_value
FROM clean_sales
GROUP BY month
ORDER BY month; 