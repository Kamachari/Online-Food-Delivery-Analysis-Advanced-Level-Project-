create database online_food_delivery_analysis;

-- SQL-PRO CHALLENGE 
-- DAY-1
-- QUERY 1.1 Get the top 5 customers based on total orders placed
SELECT	c.customer_name,
		COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC
LIMIT 5;


-- QUERY 1.2  







-- QUERY 1.1 Find top 3 most frequently ordered items
SELECT  mi.item_name,
		COUNT(od.item_id) AS total_ordered
FROM menu_items mi
JOIN order_details od 
ON mi.item_id = od.item_id
GROUP BY mi.item_name
ORDER BY total_ordered DESC
LIMIT 5;

-- QUERY 1.2 Get list of customers who have placed more than 3 orders 
SELECT  c.customer_id,
		c.customer_name,
		COUNT(o.order_id) AS total_ordered
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.customer_id
HAVING total_ordered > 3
ORDER BY total_ordered DESC;

-- QUERY 1.3 Find average quantity per order per restaurant
SELECT  r.restaurant_id,
        r.rest_name,
        AVG(od.quantity) AS average_orders
FROM orders o
JOIN restaurants r ON r.restaurant_id = o.restaurant_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY r.restaurant_id, r.rest_name
ORDER BY average_orders DESC;

-- QUERY 1.4 Customers and Restaurants They've ordered from more than once
SELECT  c.customer_id,
		c.customer_name,
        r.restaurant_id,
		r.rest_name,
        COUNT(*) as order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY c.customer_id, c.customer_name, r.restaurant_id, r.rest_name
HAVING order_count > 1;

-- QUERY 1.5 Find top 3 rervenue -generating restaurants 
SELECT  r.restaurant_id,
		r.rest_name,
        SUM(mi.price*od.quantity) AS total_revenue
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
JOIN order_details od ON o.order_id = od.item_id
JOIN menu_items mi ON od.item_id = mi.item_id
GROUP BY r.restaurant_id, r.rest_name
ORDER BY total_revenue DESC
LIMIT 3;

-- DAY-2
-- QUERY 2.1 Conditional Count - How many high value orders (ABOVE 500/-) & low value orders (BELOW 500/-)
SELECT CASE
		WHEN ((mi.price*od.quantity) > 500) THEN 'High value'
        ElSE 'Low value'
	   END AS order_type,
		COUNT(*) AS total_orders
FROM orders o
JOIN order_details od  ON o.order_id = od.order_id
JOIN menu_items mi  ON mi.item_id = od.item_id
GROUP BY
CASE
	WHEN ((mi.price*od.quantity) > 500) THEN 'High value'
	ElSE 'Low value'
END; 

-- QUERY 2.2 Categorize restaurants based on year of registration as an old or new partner 
-- (BEFORE 2025 AS OLD PARTNER)
SELECT restaurant_id,
	   rest_name,
       reg_date,
CASE 
	WHEN reg_date < '2025-01-01' THEN 'Old Partner'
    ELSE 'New Partner'
END AS restaurant_type
FROM restaurants;

-- QUERY 2.3 Tag each item as 'premium','standard', or 'economy' based on price 
-- (price >500/--> 'primium', 201/- to 500/--> 'standard', <=200/--> 'economy')
SELECT 	item_id,
		item_name,
        price,
CASE 	
	WHEN price > 500 THEN 'Primium'
    WHEN price BETWEEN 201 AND 500 THEN 'Standard'
	ELSE 'Economy'
END AS item_type
FROM menu_items;

-- QUERY 2.4 Reward tier to customer based on number of orders placed((>=10) GOLD, (BETWEEN 5 AND 9) SILVER, (<5) BRONZE)
SELECT  c.customer_id,
		c.customer_name,
        COUNT(*) AS total_orders,
CASE 
	WHEN COUNT(o.order_id) >=10 THEN 'Gold'
    WHEN COUNT(o.order_id) BETWEEN 5 AND 9 THEN 'Silver'
    ELSE 'Bronze'
END AS customer_type 
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- QUERY 2.5 classify customers as 'active', 'moderate', or 'inactive' based on signup year 
-- (If signed up in 2025 --> 'active', IN 2024 --> ' Moderate' , Else --> 'Inactive')
SELECT customer_id,
		customer_name,
        signup_date,
CASE 
	WHEN signup_date BETWEEN '2025-01-01' AND '2025-12-31' THEN 'Active'
	WHEN signup_date BETWEEN '2024-01-01' AND '2024-12-31' THEN 'Moderate'
    ELSE 'Inactive'
END as customer_status
FROM customers;

-- DAY-3
-- Query 1: Find customers who placed more orders than the average number of orders per customer.
SELECT customer_id, customer_name
FROM customers
WHERE customer_id IN (
	SELECT customer_id FROM orders
	GROUP BY customer_id
	HAVING COUNT(order_id) > (
		SELECT AVG(order_count) FROM (
			SELECT customer_id, COUNT(order_id) AS order_count FROM orders
			GROUP BY customer_id
        ) AS cust_orders
));

-- Query 2: Show me the customers who never ordered from a restaurant located in their own city.
-- Query 3: For each city, list the restaurant with the highest total revenue.

-- Query 3.1: Top 5 Most Expensive Menu Items
SELECT  item_id, item_name, price
FROM menu_items
WHERE price IN (
	SELECT price FROM (
		SELECT price FROM menu_items
		ORDER BY price DESC
		LIMIT 5
	) AS T
);

-- QUERY 3.2:Find the restaurant with the highest average item price 
SELECT restaurant_id, rest_name
FROM restaurants
WHERE restaurant_id = (
	SELECT restaurant_id FROM menu_items
		GROUP BY restaurant_id
        ORDER BY AVG(price) DESC
        LIMIT 1
);

-- Query 3.3 : Find all restaurants that have received more orders than the average number of orders per restaurant. 
SELECT restaurant_id, rest_name
FROM restaurants
WHERE restaurant_id IN (
	SELECT restaurant_id FROM orders
    GROUP BY restaurant_id
    HAVING count(order_id) > (
		SELECT AVG(order_count) FROM (
			SELECT restaurant_id, COUNT(order_id) AS order_count FROM orders
            GROUP BY restaurant_id) AS orders_per_restaurant
));
            
-- Query 3.4: List the most frequently ordered menu item (overall), and how many times it was ordered.
SELECT item_id, 
	item_name,(
		SELECT COUNT(*) FROM order_details od
        WHERE od.item_id = mi.item_id ) AS times_ordered 
FROM menu_items mi
WHERE item_id IN (
	SELECT item_id FROM (
		SELECT item_id FROM order_details
        GROUP BY item_id
        ORDER BY COUNT(*) DESC
        LIMIT 1
        ) AS f 
);

-- Query 3.5: Customers with more than 2 total orders
SELECT customer_id, customer_name
FROM customers
WHERE customer_id IN (
	 SELECT customer_id FROM orders o
     GROUP BY customer_id
     HAVING COUNT(order_id) > 2);
-- OR 
SELECT customer_id, customer_name
FROM customers
WHERE (
	SELECT COUNT(*) FROM orders o
	WHERE o.customer_id = customers.customer_id) > 2;
     

-- DAY-4
-- Query 1: First Order of Each Customer
SELECT * 
FROM (
	SELECT customer_id, order_id, restaurant_id, order_date, 
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS r_n
	FROM orders
    ) AS result
WHERE r_n = 1;

-- Query 2: Top 2 Most Expensive Items in Each Restaurant
SELECT * 
FROM (
	SELECT restaurant_id, item_id, item_name, price,
	RANK() OVER (PARTITION BY restaurant_id ORDER BY price) AS mk
    FROM menu_items
    ) AS result
WHERE mk <= 2;

-- Query 3: Find Frequent Diners using NTILE
SELECT customer_id, COUNT(order_id) AS total_orders,
NTILE(4) OVER (ORDER BY COUNT(order_id) DESC) AS m
FROM orders
GROUP BY customer_id;

-- Query 4.1: Assign a Serial Number to All Orders
-- (Gives a unique number to every order in order of date.)
SELECT  customer_id,
		order_id, 
		order_date, 
		ROW_NUMBER() OVER ( ORDER BY order_date ) AS serial_num
FROM orders;

-- Query 4.2: Get First Item in the Menu per restaurant
-- (Find the alphabetically first item per restaurant.)
SELECT * 
FROM (
SELECT  restaurant_id, 
		item_id,
        item_name,
		RANK() OVER (PARTITION BY restaurant_id ORDER BY item_name DESC) AS first_item
FROM menu_items) AS RESULT
WHERE first_item = 1;

-- Query 4.3 : Total Number of Orders Each Customer Placed 
-- ( Show total orders per customer without collapsing rows.)
SELECT  customer_id,
		order_id,
        COUNT(*) OVER (PARTITION BY customer_id ) AS total_orders
FROM orders;

-- Query 4.4:Restaurant with Highest Price Menu Item ,1 per restaurant 
-- (Find the most expensive item in each restaurant.)
SELECT * 
FROM (
	SELECT  restaurant_id,
		item_id,
        item_name,
        price,
        RANK() OVER (PARTITION BY restaurant_id ORDER BY price DESC) AS item_price
FROM menu_items) AS result 
WHERE item_price = 1;

-- Query 4.5: Average Price of Items for Each Restaurant 
-- (Compare item price to restaurant's average price.)
SELECT restaurant_id,
		item_id,
        item_name,
        price,
        AVG(price) OVER (PARTITION BY restaurant_id ORDER BY price DESC) AS avg_price_per_restaurant,
        CASE 
			WHEN price > AVG(price) OVER (PARTITION BY restaurant_id) THEN "Above avg"
            WHEN price < AVG(price) OVER (PARTITION BY restaurant_id) THEN "Below avg"
            ELSE "Equal to avg"
		END AS price_vs_avg
FROM menu_items;

-- DAY - 5
-- Query 1: Customer’s Last Order Date
SELECT  customer_id,
		order_id,	
		order_date,
        MAX(order_date) OVER (PARTITION BY customer_id) AS last_order_date
FROM orders;
        
-- Query 2: Identify Repeat Customers (Customers who have more than 1 order.)
SELECT *
FROM (
SELECT  customer_id, order_id, 
		COUNT(order_id) OVER (PARTITION BY customer_id) AS total_ordered
FROM orders) AS result
WHERE total_ordered > 1;

-- Query 3: Get Previous and Next Item Ordered by Each Customer
SELECT  customer_id,
		order_id,
        LAG(order_id) OVER (PARTITION BY customer_id) AS previous_order,
        LEAD(order_id) OVER (PARTITION BY customer_id) AS next_order
FROM orders;

-- Query 5.1:Previous Order Date for Each Customer ( Compare each order’s date to the previous one for that customer.)
SELECT customer_id,
		order_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
FROM orders;

-- Query 5.2: Next Order Date for Each Customer (Look ahead to see when the customer placed their next order.)
SELECT customer_id,
		order_id,
        order_date,
        LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
FROM orders;

-- Query 5.3 : Find the Cheapest Item per Restaurant
SELECT *
FROM
(SELECT  restaurant_id,
		item_id,
        item_name,
        price,
        RANK() OVER (PARTITION BY restaurant_id ORDER BY price) AS cheapest_item
FROM menu_items) AS result
WHERE cheapest_item = 1;

-- Query 5.4:Percentile Bucket for Customers (Top/Bottom Tiers) - (Divide customers into 5 groups (like top 20%, bottom 20%, etc.).)
SELECT  customer_id,
		customer_name,
        city,
        NTILE(5) OVER (ORDER BY COUNT(customer_id)) AS customer_bucket
FROM customers
GROUP BY customer_id;

-- Query 5.5: Rank Restaurants by Total Revenue Without Gaps (restaurants with the same revenue should have the same rank, without skipping numbers.)
SELECT  r.restaurant_id,
		r.rest_name,
        SUM(mi.price*od.quantity) AS total_revenue,
        DENSE_RANK() OVER (PARTITION BY r.restaurant_id ORDER BY SUM(mi.price*od.quantity) DESC) AS restaurant_rank
FROM restaurants r
JOIN menu_items mi ON r.restaurant_id = mi.restaurant_id
JOIN order_details od ON mi.item_id = od.item_id
GROUP BY r.restaurant_id, r.rest_name;

-- DAY - 6
-- Query 1: customer_total_spend
-- Query 2: customer_order_count
-- Query 3: most_ordered_items

-- Query 6.1: Create a SQL view named avg_spend_per_order that displays each order’s ID, the customer ID, and the total spend for that order.
CREATE VIEW  avg_spend_per_order AS 
SELECT 	o.order_id,
		o.customer_id,
        SUM(mi.price*od.quantity) AS total_spent_per_order
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_items mi ON mi.item_id = od.item_id
GROUP BY o.order_id, o.customer_id;

-- Find the average spend per orders across all customers 
SELECT VG(total_spent_per_order) AS avg_spend
FROM avg_spend_per_order;

-- Query 6.2: Create a SQL view named restaurant_performance that displays each restaurant’s ID, name, total number of orders, and total revenue.
CREATE VIEW restaurant_performance AS 
SELECT  r.restaurant_id,
		r.rest_name,
        COUNT(o.order_id) AS total_orders,
		SUM(mi.price*od.quantity) AS total_revenue
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_items mi ON od.item_id = mi.item_id
GROUP BY r.restaurant_id, r.rest_name
ORDER BY total_revenue DESC;

-- Find the top 3 restaurants by total revenue
SELECT	* FROM restaurant_performance
LIMIT 3;

-- Query 6.3 : Create a SQL view named city_customer_spending that displays each city and the total amount spent by customers from that city.
CREATE VIEW city_customer_spending AS 
SELECT  c.city,
		SUM(mi.price*od.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_items mi ON od.item_id = mi.item_id
GROUP BY c.city
ORDER BY total_spent DESC;

-- Find the city with the maximum customers spending
SELECT MAX(total_spent) FROM city_customer_spending;

-- Query 6.4:Create a SQL view named top_high_value_orders that displays the top 5 highest-value orders. 
-- (The view should include the order ID, customer name, order date, and the total order value.)
CREATE VIEW top_high_value_orders AS
SELECT  o.order_id,
		c.customer_name,
        o.order_date,
        SUM(mi.price*od.quantity) AS total_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_items mi ON od.item_id = mi.item_id
GROUP BY o.order_id, c.customer_name, o.order_date
ORDER BY total_order_value DESC
LIMIT 5;

-- Check which customer placed the single highest value order
SELECT  customer_name, order_id, total_order_value
FROM top_high_value_orders
ORDER BY total_order_value DESC
LIMIT 1;

-- Query 6.5: Create a SQL view named customers_without_orders that lists all customers who have never placed an order. 
-- The view should include the customer ID, name, email, city, and signup date.
CREATE VIEW customers_without_orders AS
SELECT c.* 
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
        
-- Count how many customers never placed an order
SELECT COUNT(*) AS inactive_customers 
FROM customers_without_orders;

-- DAY -7
/* Task 7.1 — Customer Order Count
Goal: Make a temporary table with each customer’s total number of orders.
Then, show customers who have more than 2 orders. */

CREATE TEMPORARY TABLE temp_customers_orders AS
SELECT o.customer_id, COUNT(o.order_id) AS total_orders
FROM orders o
GROUP BY o.customer_id;

SELECT t.customer_id, c.customer_name, t.total_orders FROM 
temp_customers_orders AS t 
JOIN customers c ON t.customer_id = c.customer_id
WHERE total_orders > 2;

/* Task 7.2 — Restaurant Revenue
GOAL: Create a temporary table with total revenue per restaurant.
Then, display restaurants where revenue is above ₹20,000. */

CREATE TEMPORARY TABLE  temp_restaurant_revenue AS
SELECT mi.restaurant_id, SUM(mi.price*od.quantity) AS total_revenue
FROM menu_items mi
JOIN order_details od ON mi.item_id = od.item_id
GROUP BY mi.restaurant_id;

SELECT * FROM temp_restaurant_revenue
WHERE total_revenue > 20000
ORDER BY restaurant_id;

/*Task 7.3 — High Value Orders
Goal: Make a temporary table with each order’s total value.
Then, show only orders above ₹1,000. */

CREATE TEMPORARY TABLE temp_high_value_orders AS
SELECT od.order_id, SUM(mi.price*od.quantity) AS order_value
FROM menu_items mi
JOIN order_details od ON mi.item_id = od.item_id
GROUP BY od.order_id;

SELECT * FROM temp_high_value_orders
WHERE order_value > 1000 
ORDER BY order_id;

/*Task 7.4 — Popular Items
Goal: Create a temporary table with total quantity sold per menu item.
Then, show the top 5 items by quantity.*/

CREATE TEMPORARY TABLE temp_total_quantity_per_item AS
SELECT mi.item_id, mi.item_name, SUM(od.quantity) AS total_quantity
FROM menu_items mi 
JOIN order_details od ON mi.item_id = od.item_id
GROUP BY mi.item_id, mi.item_name;

SELECT * FROM temp_total_quantity_per_item
ORDER BY total_quantity DESC
LIMIT 5;

/*Task 7.5 — 
GOAL: “Big cart” orders: orders with 5+ items (quantity-wise),
Find orders with 5+ items using a temp table of order item counts.*/
CREATE TEMPORARY TABLE temp_big_cart AS 
SELECT o.order_id, SUM(od.quantity) AS total_items
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id;

SELECT * FROM temp_big_cart
WHERE total_items >= 5
ORDER BY order_id ;

-- DAY - 8
-- solve them using CTE
/* 8.1.Top 5 most‑sold items (by quantity) [ CTE Name: item_qty 🔹 Columns in CTE: item_id, item_name, total_qty.....
🔹 What it contains: Each menu item’s total quantity sold across all orders..] */
 WITH item_qty AS
 (
 SELECT mi.item_id, mi.item_name, SUM(od.quantity) AS total_qty
 FROM order_details od 
 JOIN menu_items mi ON mi.item_id = od.item_id
 GROUP BY mi.item_id, mi.item_name
 )
 SELECT * FROM item_qty
 ORDER BY total_qty DESC
 LIMIT 5;

/* 8.2. Customers who never ordered [ CTE Name: active_customers 🔹 Columns in CTE: customer_id... 
🔹 What it contains: IDs of customers who have placed orders — later used with LEFT JOIN to find those who haven’t.*/
WITH Active_customers AS
(
SELECT DISTINCT o.customer_id
FROM orders o
)
SELECT c.customer_id, c.customer_name, c.email, c.city
FROM customers c
LEFT JOIN Active_customers ac ON c.customer_id = ac.customer_id 
WHERE ac.customer_id IS NULL;

/* 8.3. Active customer list (placed at least one order) CTE Name: active_customers 🔹 Columns in CTE: customer_id 
🔹 What it contains: IDs of customers who have placed at least one order.*/
WITH Active_customers AS
(
SELECT DISTINCT o.customer_id
FROM orders o
)
SELECT ac.customer_id, c.customer_name, c.city
FROM customers c 
JOIN Active_customers ac ON c.customer_id = ac.customer_id ;

/* 8.4. Items sold per day (quantity) CTE Name: day_items 🔹 Columns in CTE: d (date), items_sold 
🔹 What it contains: Total number of items sold on each date.*/
WITH day_items AS
(
SELECT o.order_date AS d, SUM(od.quantity) AS total_items_sold
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_date
)
SELECT * FROM day_items
ORDER BY d;

/* 8.5.Average item price per restaurant CTE Name: avg_price🔹 Columns in CTE: restaurant_id, avg_item_price 
🔹 What it contains: Average price of menu items in each restaurant.*/
WITH avg_price AS
(
SELECT mi.restaurant_id, AVG(mi.price) AS avg_item_price
FROM menu_items mi
GROUP BY mi.restaurant_id
)
SELECT ap.restaurant_id, r.rest_name, ap.avg_item_price
FROM avg_price ap
JOIN restaurants r ON r.restaurant_id = ap.restaurant_id;

-- DAY - 9
-- solve them using CTE
/* 9.1.Menu Items That Were Never Ordered - There may be menu items listed but never sold. 
Your task: Find all items from menu_item that do not appear in order_details. (Hint use -Left Join) */
WITH unordered_item AS
(
SELECT mi.item_id, mi.item_name, mi.restaurant_id
FROM menu_items mi 
LEFT JOIN order_details od ON mi.item_id = od.item_id
WHERE od.item_id IS  NULL
)
SELECT  * FROM unordered_item;

/* 9.2. Orders With More Than 3 Items - Identify big orders by quantity. 
Your task: List order IDs where the total quantity of items ordered was more than 3. (Hint: Use SUM(quantity) grouped by order_id.) */
WITH big_orders AS
(
SELECT od.order_id, SUM(od.quantity) AS total_items
FROM order_details od 
GROUP BY od.order_id
HAVING SUM(od.quantity) > 3
)
SELECT * FROM big_orders;

/* 9.3. One-Time Customers - Some customers placed only one order ever. 
Your task: List all such customers along with their total number of orders (which should be 1). */
WITH customer_orders AS
(
SELECT o.customer_id, COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY o.customer_id
)
SELECT co.customer_id, c.customer_name, co.total_orders
FROM customer_orders co
JOIN customers c ON co.customer_id = c.customer_id
WHERE co.total_orders = 1;

/* 9.4. Restaurant Revenue Leaderboard - We want to rank restaurants based on how much money they made.
 Your task: Calculate total revenue for each restaurant and assign a rank (1 = highest revenue). Show: restaurant_name, revenue, revenue_rank. [Hint: use rank() ] */
WITH restaurant_revenue AS
(
SELECT mi.restaurant_id, r.rest_name, SUM(mi.price*od.quantity) AS revenue
FROM order_details od 
JOIN menu_items mi ON  mi.item_id = od.item_id
JOIN restaurants r ON r.restaurant_id = mi.restaurant_id
GROUP BY mi.restaurant_id, r.rest_name
)
SELECT rest_name, revenue,
		RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM restaurant_revenue;

/* 9.5. Customers Who Ordered From More Than 3 Restaurants [Hint: as we did in demo query] */
WITH customer_restaurant_count AS
(
SELECT o.customer_id, COUNT(DISTINCT mi.restaurant_id) AS restaurant_count
FROM orders o 
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_items mi ON mi.item_id = od.item_id
GROUP BY o.customer_id
)
SELECT crc.customer_id, c.customer_name, crc.restaurant_count
FROM customer_restaurant_count crc
JOIN customers c ON crc.customer_id = c.customer_id
WHERE crc.restaurant_count > 3;

-- DAY - 10
/* 10.1. Restaurants in a Specific City - Task: Make a stored procedure that shows all restaurants from a city you pass as input.
Input parameter: city_name.
Output: restaurant_id, rest_name, city. */
DELIMITER //
CREATE PROCEDURE RestaurantsInCity(IN city_name VARCHAR(50))
BEGIN
    SELECT restaurant_id, rest_name, city
    FROM restaurants
    WHERE city = city_name;
END //
DELIMITER ;
-- Run:
CALL RestaurantsInCity('Hyderabad');

/* 10.2. Revenue Between Two Dates -Task: Create a stored procedure to calculate the total revenue from all orders between two dates you provide.
Inputs: start_date, end_date.
Output: One row with total_revenue.
Join the tables orders, order_details, and menu_item to calculate revenue = price × quantity.
use : WHERE o.order_date BETWEEN ................. &............. */
DELIMITER //
CREATE PROCEDURE RevenueBetweenDates(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT SUM(mi.price * od.quantity) AS total_revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN menu_items mi ON od.item_id = mi.item_id
    WHERE o.order_date BETWEEN start_date AND end_date;
END //
DELIMITER ;
-- Run:
CALL RevenueBetweenDates('2025-01-01', '2025-01-31');

/* 10.3. Top N Customers by Orders - Task: Make a stored procedure that shows the top N customers based on how many orders they have placed.
Input: limit_num (the number of customers to return).
Output: customer_name, total_orders.
Sort from highest to lowest orders. */
DELIMITER //
CREATE PROCEDURE TopNCustomers(IN limit_num INT)
BEGIN
    SELECT c.customer_name, COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
    ORDER BY total_orders DESC
    LIMIT limit_num;
END //
DELIMITER ;

-- Run:
CALL TopNCustomers(5);

/* 10.4. Orders for a Specific Restaurant - Task: Create a stored procedure to display all orders placed with a specific restaurant.
Input: rest_id.
Output: order_id, customer_id, restaurant_id, order_date. */

DELIMITER //
CREATE PROCEDURE OrdersByRestaurant(IN rest_id INT)
BEGIN
    SELECT  o.order_id,
			o.customer_id,
			mi.restaurant_id,
			o.order_date
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN menu_items mi ON od.item_id = mi.item_id
    WHERE mi.restaurant_id = mi.restaurant_id;
END //
DELIMITER ;
-- Run:
CALL OrdersByRestaurant(101);

/* 10.5. First Order Date for Each Customer - Task: Make a stored procedure that shows when each customer placed their very first order.
No input needed.
Output: customer_id, first_order (earliest order_date). */
DELIMITER //
CREATE PROCEDURE FirstOrderDate()
BEGIN
    SELECT 
        customer_id,
        MIN(order_date) AS first_order
    FROM orders
    GROUP BY customer_id;
END //
DELIMITER ;

-- Run:
CALL FirstOrderDate();


-- DAY - 11
-- 11.1 Customer Signups Category - Task: Classify customers as “Early Bird” (signup before 2024), “Regular” (2024), or “New” (2025).
SELECT customer_id, customer_name, signup_date,
    CASE 
        WHEN YEAR(signup_date) < 2024 THEN 'Early Bird'
        WHEN YEAR(signup_date) = 2024 THEN 'Regular'
        WHEN YEAR(signup_date) = 2025 THEN 'New'
        ELSE 'Future'
    END AS signup_category
FROM customers;

-- 11.2 Customers with Max Orders- Task: Find customers who placed the maximum number of orders.
WITH customer_orders AS 
(
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
), max_orders AS 
(
    SELECT MAX(total_orders) AS max_order_count 
    FROM customer_orders
)
SELECT  c.customer_id, cu.customer_name, c.total_orders
FROM customer_orders c
JOIN max_orders m ON c.total_orders = m.max_order_count
JOIN customers cu ON c.customer_id = cu.customer_id;

-- 11.3 Menu Items Priced Above Global Average- Task: Show items that are priced higher than the average price of all menu items.
SELECT 
    item_id,
    item_name,
    price
FROM menu_items
WHERE price > (SELECT AVG(price) FROM menu_items);

-- 11.4 Restaurants With More Items Than Avg - Task: Show restaurants that offer more menu items than the overall average.
WITH rest_item_count AS 
(
SELECT restaurant_id, COUNT(item_id) AS total_items
FROM menu_items
GROUP BY restaurant_id
)
SELECT r.restaurant_id, r.rest_name, ric.total_items
FROM rest_item_count ric
JOIN restaurants r ON ric.restaurant_id = r.restaurant_id
WHERE ric.total_items > (SELECT AVG(total_items) FROM rest_item_count);

-- 11.5 Monthly Order Summary - Task: Build a CTE for monthly orders and then filter only months with >50 orders.
WITH monthly_orders AS 
(
SELECT  DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        COUNT(order_id) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT * FROM monthly_orders
WHERE total_orders > 50
ORDER BY order_month;

-- DAY - 12
-- 12.1 Restaurant Size Category -- Task: Based on menu items, mark restaurants as Small (<5 items), Medium (5–10), or Large (>10).
SELECT r.restaurant_id, r.rest_name, COUNT(m.item_id) AS total_items,
    CASE 
        WHEN COUNT(m.item_id) < 5 THEN 'Small'
        WHEN COUNT(m.item_id) BETWEEN 5 AND 10 THEN 'Medium'
        ELSE 'Large'
    END AS size_category
FROM restaurants r
LEFT JOIN menu_items m ON r.restaurant_id = m.restaurant_id
GROUP BY r.restaurant_id, r.rest_name;

-- 12.2 Orders per Customer with Rank -- Task: Use a CTE to calculate orders per customer and rank them.
WITH customer_orders AS 
(
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders 
GROUP BY customer_id
)
SELECT  co.customer_id, c.customer_name, co.total_orders,
		RANK() OVER (ORDER BY co.total_orders DESC) AS order_rank
FROM customer_orders co
JOIN customers c ON c.customer_id = co.customer_id;


-- 12.3 Store Top 3 Restaurants -- Task: Create a temporary table of top 3 restaurants by revenue.
CREATE TEMPORARY TABLE top3_restaurants AS
SELECT 	r.restaurant_id, r.rest_name,
		SUM(mi.price * od.quantity) AS total_revenue
FROM restaurants r
JOIN menu_items mi ON r.restaurant_id = mi.restaurant_id
JOIN order_details od ON mi.item_id = od.item_id
GROUP BY r.restaurant_id, r.rest_name
ORDER BY total_revenue DESC
LIMIT 3;
-- Check result
SELECT * FROM top3_restaurants;


-- 12.4 Store Orders Last 7 Days -- Task: Create a temp table of orders from the last 7 days.
CREATE TEMPORARY TABLE last7_orders AS
SELECT *
FROM orders
WHERE order_date >= (SELECT DATE_SUB(max(order_date), INTERVAL 7 DAY)
FROM orders);
-- Check result
SELECT * FROM last7_orders;

-- 12.5 Create View for Customer Spend -- Task: Create a view showing total spend per customer.
CREATE VIEW customer_spend AS
SELECT o.customer_id, c.customer_name,
    SUM(mi.price * od.quantity) AS total_spend
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_items mi ON od.item_id = mi.item_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name;
-- Check result
SELECT * FROM customer_spend;




