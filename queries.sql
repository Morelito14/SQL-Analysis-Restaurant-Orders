/*ITEMS TABLE EXPLORATION*/

/*View entire menu_items table*/
SELECT*
FROM menu_items

/*To find the number of items in the menu items*/
SELECT COUNT(*) as Number_of_items
FROM menu_items

/*Least and most expensive items in the menu*/
SELECT item_name, price
FROM menu_items 
WHERE price = (SELECT MAX(price) FROM menu_items)
UNION
SELECT item_name, price
FROM menu_items 
WHERE price = (SELECT MIN(price) FROM menu_items)

/*The number of italian dishes*/
SELECT COUNT(*) as Number_of_italian_dishes
FROM menu_items
WHERE category = 'Italian'

/*The least and most expensive italian dishes*/
WITH italian_dishes as (
	SELECT item_name, price
	FROM menu_items
	WHERE category = 'Italian'
)
SELECT item_name, price
FROM italian_dishes
WHERE price = (SELECT MIN(price) FROM italian_dishes)
OR price = (SELECT MAX(price) FROM italian_dishes)

/*The number of dishes per category, average price */
SELECT category, COUNT(*) as Number_of_dishes, ROUND(AVG(price), 1) as Average_price 
FROM menu_items
GROUP BY category
ORDER BY AVG(price) DESC


/*ORDERS TABLE EXPLORATION*/

/*View entire order details table*/
SELECT *
FROM order_details

/*Date range of the order detail*/
SELECT MIN(order_date), MAX(order_date)
FROM order_details

/*Number of orders made*/
SELECT COUNT(DISTINCT(order_id)) 
FROM order_details


/*Number of items ordered*/
SELECT COUNT(*)
FROM order_details


/*Identifying which order had the most number of items*/
SELECT order_id, COUNT(item_id) as Number_of_items
FROM order_details
GROUP BY order_id
ORDER BY COUNT(item_id) DESC

/*Orders with more than 12 items*/
SELECT COUNT(*) 
FROM
(SELECT order_id, COUNT(item_id) as Number_of_items
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id) > 12)


/*CUSTOMER BEHAVIOR ANALYSIS*/

/*Combine menu items and order details*/
SELECT *
FROM order_details as od
JOIN menu_items as mt
ON od.item_id = mt.menu_item_id

/*Least and Most ordered items and in which category are they in*/
SELECT mt.item_name, COUNT(od.item_id) as Number_of_times_ordered, mt.category
FROM menu_items as mt
JOIN order_details as od
ON mt.menu_item_id = od.item_id
GROUP BY mt.item_name, mt.category
ORDER BY COUNT(od.item_id) DESC

/*Top 5 orders based on expenses*/
SELECT od.order_id, SUM(mt.price) as Total_expenses_per_order
FROM menu_items as mt
JOIN order_details as od
ON mt.menu_item_id = od.item_id
GROUP BY od.order_date, od.order_id
ORDER BY SUM(mt.price) DESC 
LIMIT 5



/*View details of the top 5 order with the highest expenses */
SELECT od.order_details_id, od.order_id, od.order_date, od.order_time, mt.item_name, mt.category, mt.price
FROM menu_items as mt
JOIN order_details as od
ON mt.menu_item_id = od.item_id
WHERE od.order_id IN (
					SELECT od.order_id
					FROM menu_items as mt
					JOIN order_details as od
					ON mt.menu_item_id = od.item_id
					GROUP BY od.order_date, od.order_id
					ORDER BY SUM(mt.price) DESC 
					LIMIT 5
)
ORDER BY od.order_id