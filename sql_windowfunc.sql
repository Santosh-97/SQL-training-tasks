use Santosh;
select * from customers;
select * from orders; 
select * from products;

/*Top 3 selling products in each region (by revenue)*/
with productsales As(
Select  
 C.region,
 p.product_name, 
 sum(CAST(o.total_price As float))as total_revenue,
 RANK()over(
  partition by c.region
  Order by SUM(CAST(o.total_price AS FLOAT)) desc
  ) as sales_ranking
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id
group by c.region,p.product_name
)
Select *
from productsales
where sales_ranking <=3
order by region, sales_ranking;


/*Rank customers based on total spend*/
Select  
 C.customer_name,
 p.product_name, 
 SUM(CAST(o.quantity as int)) as total_quantity,
 SUM(CAST(o.total_price As float))as total_spend,
 RANK()over(
  partition by c.customer_name
  Order by SUM(CAST(o.total_price AS FLOAT)) desc
  ) as customer_ranking
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id
group by c.customer_name,p.product_name
ORDER BY c.customer_name, customer_ranking;


/* Rank customers based on total spend */
SELECT  
    c.customer_name,
    SUM(CAST(o.quantity AS INT)) AS total_quantity,
    SUM(CAST(o.total_price AS FLOAT)) AS total_spend,
    RANK() OVER (
        ORDER BY SUM(CAST(o.total_price AS FLOAT)) DESC
    ) AS customer_ranking
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spend DESC;


/*Find first and most recent order for each customer*/
WITH RankedOrders AS (
    SELECT
        o.customer_id,
        c.customer_name,
        CAST(o.order_date AS DATE) AS order_date,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id 
            ORDER BY o.order_date ASC
        ) AS first_order_rank,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id 
            ORDER BY o.order_date DESC
        ) AS recent_order_rank
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
)
-- Get both first and recent orders--
SELECT *
FROM RankedOrders
WHERE first_order_rank = 1 OR recent_order_rank = 1
ORDER BY customer_id, order_date;
