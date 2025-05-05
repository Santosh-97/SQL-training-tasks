# SQL-training-tasks

----> Raw Datasets
![image](https://github.com/user-attachments/assets/249ef7ed-8d23-445d-956d-e0ae1b3b1690)




**/*List customer names with their orders and products*/**
select c.customer_id,c.customer_name, o.order_id,o.quantity,p.product_id,p.product_name 
from customers c 
left join orders o on c.customer_id = o.customer_id
Left join Products p on o.product_id = p.product_id;

**/*Show customers who haven’t placed any order*/**
select c.customer_id,c.customer_name, o.order_id 
from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_id is NULL;


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

ALTER TABLE Orders ADD order_date_clean DATE;

UPDATE Orders
SET order_date_clean = CAST(CONVERT(VARCHAR, order_date) AS DATE);

**/*Filter orders placed in 2023 only*/**
Select order_id,customer_id,cast(order_date as DATE) as order_date
from orders
where order_date between 2023-01-01 and 2023-12-31;

**/*Total and average sales per region*/**
Select C.region, SUM(CAST(o.total_price AS FLOAT)) as total_sale,AVG(CAST(o.quantity AS Decimal))as avg_quantity
from customers c
inner join orders o on c.customer_id = o.customer_id
group by c.region
order by total_sale desc;

**/*Products that have been ordered more than 5 times*/**
Select count(o.product_id) as order_count, p.product_name,SUM(CAST(o.quantity AS Decimal))as total_quantity
from products p
inner join orders o on p.product_id = o.product_id
group by p.product_name
having COUNT(o.product_id ) > 5;

**/*Total quantity and revenue by product category*/**
Select p.category, SUM(CAST(o.total_price AS Decimal))as total_revenue,SUM(CAST(o.quantity AS Decimal))as total_quantity
from products p
join orders o on p.product_id = o.product_id
group by p.category
order by total_revenue desc;

**/*Top 3 selling products in each region (by revenue)*/**
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


**/*Rank customers based on total spend*/**
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


**/* Rank customers based on total spend */**
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


**/*Find first and most recent order for each customer*/**
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
