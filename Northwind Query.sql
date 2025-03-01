Select *
From orders

----Write a query to get Product name and quantity/unit.
Select product_name, quantity_per_unit
From products;

----Write a query to get current Product list (Product ID and name).
Select product_id, product_name
From products
WHERE Discontinued = 0;

----Write a query to get the Products by Category
Select p.product_name, c.category_name
From products p
Join categories c ON p.category_id = c.category_id
Order by p.product_name, c.category_name;

----Write a query to get discontinued Product list (Product ID and name).
Select product_name, product_id
From products
Where discontinued = 1;

----Write a query to get most expense and least expensive Product list (name and unit price).
(Select product_name, unit_price
From products
Order By unit_price DESC
Limit 1)
UNION ALL
(SELECT product_name, unit_price 
 FROM products 
 ORDER BY unit_price ASC 
 LIMIT 1);

----Alternatively
SELECT product_name, unit_price 
FROM products 
WHERE unit_price = (SELECT MAX(unit_price) FROM products)
   OR unit_price = (SELECT MIN(unit_price) FROM products);

----Write a query to get Product list (id, name, unit price) where current products cost less than $20.
Select product_id, product_name, unit_price
From products
Where unit_price < 20 and discontinued = 0;

----Write a query to get Product list (id, name, unit price) where products cost between $15 and $25.
Select product_id, product_name, unit_price
From products
Where unit_price Between 15 and 25;

----Write a query to get Product list (name, unit price) of above average price.
Select product_name, unit_price
From products
Where unit_price > (Select AVG(unit_price)
From products);

----Write a query to get Product list (name, unit price) of ten most expensive products.
Select product_name, unit_price
From products
Order By unit_price DESC
Limit 10;

----Write a query to count current and discontinued products.
SELECT 
    CASE 
        WHEN Discontinued = 0 THEN 'current products' 
        WHEN Discontinued = 1 THEN 'discontinued products' 
    END AS product_status, 
    COUNT(*) AS product_count
FROM products
GROUP BY discontinued;

----Alternatively
SELECT 
    SUM(CASE WHEN discontinued = 0 THEN 1 ELSE 0 END) AS current_products,
    SUM(CASE WHEN discontinued = 1 THEN 1 ELSE 0 END) AS discontinued_products
FROM products;

----Write a query to get Product list (name, units on order , units in stock) of stock is less than the quantity on order.
Select product_name, units_on_order, units_in_stock,
	Case
		When units_in_stock < units_on_order Then 'consider_to_restock'
		When units_in_stock = 0 Then 'out_of_stock' Else 'in_stock'
	End As stock_status
From products
Where discontinued = 0;

----Write a query to get Product list (name, units on order , units in stock) of stock is less than the quantity on order.(2)
SELECT product_name, units_on_order, Units_in_stock
FROM products
WHERE units_in_stock < units_on_order;

----For each employee, get their sales amount.
Select CONCAT(e.first_name,' ',e.last_name) employee_name, SUM(od.unit_price*od.quantity*(1-discount)) total_sales
From employees e
Join orders o ON e.employee_id = o.employee_id
Join order_details od ON o.order_id = od.order_id
Group By employee_name
Order By total_sales;

----Write a query that returns the order and calculates sales price for each order after discount is applied.
Select o.order_id, SUM(od.unit_price*od.quantity*(1-od.discount)) sales_price
From orders o
Join order_details od ON o.order_id = od.order_id
Group By o.order_id
Order By sales_price DESC;

----For each category, get the list of products sold and the total sales amount per product
SELECT 
    c.category_name,
    p.product_name,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales_amount
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name, p.product_name
ORDER BY c.category_name, total_sales_amount DESC;

----Write a query that shows sales figures by categories for the year 1997 alone.
SELECT 
    c.Category_Name, o.Order_Date,
    SUM(od.Unit_Price * od.Quantity * (1 - od.Discount)) AS TotalSalesAmount
FROM Orders o
JOIN Order_Details od ON o.Order_ID = od.Order_ID
JOIN Products p ON od.Product_ID = p.Product_ID
JOIN Categories c ON p.Category_ID = c.Category_ID
WHERE o.Order_Date BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY c.Category_Name, o.Order_Date
ORDER BY TotalSalesAmount DESC;