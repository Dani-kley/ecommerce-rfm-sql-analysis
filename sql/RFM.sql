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
			
        SUBSTR(InvoiceDate, INSTR(InvoiceDate, ' ') - 4, 4) || '-' || 
        CASE 
            WHEN INSTR(InvoiceDate, '/') = 2 THEN '0' || SUBSTR(InvoiceDate, 1, 1)
            ELSE SUBSTR(InvoiceDate, 1, 2)
        END AS order_month,
        MAX(InvoiceDate) AS order_date,
        SUM(Quantity * UnitPrice) AS order_revenue
    FROM clean_sales
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
      AND Quantity > 0
      AND UnitPrice > 0
    GROUP BY CustomerID, InvoiceNo
),
customer_rfm AS (
    SELECT
        CustomerID,
        
        (
            SELECT MAX(SUBSTR(InvoiceDate, INSTR(InvoiceDate, ' ') - 4, 4) || '-' || 
                   CASE WHEN INSTR(InvoiceDate, '/') = 2 THEN '0' || SUBSTR(InvoiceDate, 1, 1) ELSE SUBSTR(InvoiceDate, 1, 2) END) 
            FROM clean_sales
        ) AS max_month,
        MAX(order_month) AS last_order_month,
        COUNT(*) AS frequency,
        SUM(order_revenue) AS monetary
    FROM customer_orders
    GROUP BY CustomerID
),
customer_rfm_calc AS (
    SELECT
        CustomerID,
       
        (CAST(SUBSTR(max_month, 1, 4) AS INTEGER) * 12 + CAST(SUBSTR(max_month, 6, 2) AS INTEGER)) - 
        (CAST(SUBSTR(last_order_month, 1, 4) AS INTEGER) * 12 + CAST(SUBSTR(last_order_month, 6, 2) AS INTEGER)) AS recency_months,
        frequency,
        monetary
    FROM customer_rfm
),
rfm_scores AS (
    SELECT
        CustomerID,
        recency_months,
        frequency,
        monetary,
        
        6 - NTILE(5) OVER (ORDER BY recency_months) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM customer_rfm_calc
),
segmented AS (
    SELECT
        *,
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'High-value loyal'
            WHEN r_score >= 4 AND f_score >= 3 THEN 'Active customers'
            WHEN r_score <= 2 AND f_score >= 3 THEN 'At risk'
            WHEN r_score >= 4 AND f_score <= 2 THEN 'Recent customers'
            WHEN r_score <= 2 AND f_score <= 2 THEN 'Inactive / low activity'
            ELSE 'Other customers'
        END AS customer_segment
    FROM rfm_scores
)
SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(SUM(monetary), 2) AS total_revenue,
    ROUND(AVG(monetary), 2) AS avg_customer_revenue,
    ROUND(AVG(frequency), 2) AS avg_orders,
    ROUND(AVG(recency_months), 1) AS avg_recency_months 
FROM segmented
GROUP BY customer_segment
ORDER BY total_revenue DESC;