use Santosh;
select * from customers;
select * from orders; 
select * from products;

/*List customer names with their orders and products*/
select c.customer_id,c.customer_name, o.order_id,o.quantity,p.product_id,p.product_name 
from customers c 
left join orders o on c.customer_id = o.customer_id
Left join Products p on o.product_id = p.product_id;

/*Show customers who haven’t placed any order*/
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

/*Filter orders placed in 2023 only*/
Select order_id,customer_id,cast(order_date as DATE) as order_date
from orders
where order_date between 2023-01-01 and 2023-12-31;

/*Total and average sales per region*/
Select C.region, SUM(CAST(o.total_price AS FLOAT)) as total_sale,AVG(CAST(o.quantity AS Decimal))as avg_quantity
from customers c
inner join orders o on c.customer_id = o.customer_id
group by c.region
order by total_sale desc;

/*Products that have been ordered more than 5 times*/
Select count(o.product_id) as order_count, p.product_name,SUM(CAST(o.quantity AS Decimal))as total_quantity
from products p
inner join orders o on p.product_id = o.product_id
group by p.product_name
having COUNT(o.product_id ) > 5;

/*Total quantity and revenue by product category*/
Select p.category, SUM(CAST(o.total_price AS Decimal))as total_revenue,SUM(CAST(o.quantity AS Decimal))as total_quantity
from products p
join orders o on p.product_id = o.product_id
group by p.category
order by total_revenue desc;