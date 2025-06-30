create database ecomm;
use ecomm;
show tables;

---Analyze the Data ---
desc customers;
desc products;
desc Orders;
desc OrderDetails;

---Market Segmentation Analysis---
select location, count(customer_id) as number_of_customers
from customers
group by location
order by number_of_customers desc
limit 3;

---Engagement Depth Analysis---
SELECT NumberOfOrders, COUNT(*) AS CustomerCount
FROM (
    SELECT customer_id, COUNT(order_id) AS NumberOfOrders
    FROM Orders
    GROUP BY customer_id
) AS CustomerOrders
GROUP BY NumberOfOrders
ORDER BY NumberOfOrders ASC;

---Purchase High-Value Products---
select Product_Id, avg(quantity) as AvgQuantity, 
sum(quantity * price_per_unit) as TotalRevenue
from OrderDetails
group by Product_Id
having avg(quantity)=2
order by TotalRevenue desc;

---Category-wise Customer Reach---
select p.category, count( distinct(o.customer_id)) as unique_customers
from orders o 
join orderdetails od on o.order_id= od.order_id
join products p on od.product_id= p.product_id
group by p.category
order by  count(distinct(o.customer_id)) desc;

---Sales Trend Analysis---
with CTE as (
select Date_Format(order_date, '%Y-%m') as Month1, 
sum(total_amount) as TotalSales
from Orders
group by Month1
)
select month1 as Month, TotalSales,
round((((TotalSales- lag(TotalSales) over(order by Month1))/
lag(TotalSales) over(order by Month1))* 100),2) as PercentChange
from CTE;

---Average Order Value Fluctuation---
with CTE as (
    select date_format(Order_date, '%Y-%m') as Month, 
    avg(total_amount) as AvgOrderValue
    from Orders
    group by Month
)

Select Month, AvgOrderValue, round(AvgOrderValue- lag(AvgOrderValue) over
(order by month),2) as ChangeInValue
from CTE
order by ChangeInValue desc;

---Low Engagement Products---
select p.product_id as Product_id, p.name as Name, 
count(distinct(o.customer_id)) as UniqueCustomerCount
from products p 
join orderdetails od on p.product_id= od.product_id
join orders o on od.order_id= o.order_id
group by p.product_id, p.name
having UniqueCustomerCount<40;

---Customer Acquistion Trends---
   with cte as (
    select date_format(min(order_date), '%Y-%m') as FirstPurchaseMonth,
    count(distinct(customer_id)) as NewCustomers 
    from Orders
    group by customer_id    
   )

   select FirstPurchaseMonth, sum(NewCustomers) as TotalNewCustomers
   from cte
   group by FirstPurchaseMonth
   order by FirstPurchaseMonth;

---Peak Sales Period Identification---
select date_format(Order_date,'%Y-%m') as Month,
sum(total_amount) as TotalSales
from Orders
group by Month
order by TotalSales desc
limit 3;

