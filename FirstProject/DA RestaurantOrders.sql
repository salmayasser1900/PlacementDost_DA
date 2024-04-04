Create database Restaurant
use Restaurant

 
/* 2. Basic SELECT Queries */

SELECT * FROM menu_items

SELECT TOP (5) [order_details_id]
      ,[order_id]
      ,[order_date]
      ,[order_time]
      ,[item_id]
  FROM [Restaurant].[dbo].[order_details]

/* 3. Filtering and Sorting */

SELECT item_name, price FROM menu_items

SELECT * FROM menu_items
ORDER BY price DESC;

/* 4. Aggregate Functions */

SELECT AVG(price) AS average_price FROM menu_items;

SELECT COUNT(DISTINCT order_id) AS total_orders FROM order_details;

/* 5. Joins:*/

SELECT menu_items.item_name, order_details.order_date, order_details.order_time
FROM order_details
JOIN menu_items ON order_details.item_id = menu_items.menu_item_id;

/* 6. Subqueries:*/
SELECT item_name, price
FROM menu_items
WHERE price > (SELECT AVG(price) FROM menu_items)
ORDER BY price DESC;

/* 7. Date and Time Functions:*/

SELECT MONTH(order_date) AS month,
       COUNT(*) AS total_orders
FROM order_details
GROUP BY MONTH(order_date)
ORDER BY month;

/*8. Group By and Having:*/
SELECT category, AVG(price) AS average_price
FROM menu_items
GROUP BY category
HAVING AVG(price) > 15;

SELECT category, 
       COUNT(*) AS item_count,
       AVG(price) AS average_price
FROM menu_items
GROUP BY category
HAVING AVG(price) > 15;

/*9. Conditional Statements:*/

SELECT item_name, price,
       CASE WHEN price > 20 THEN 'Yes' ELSE 'No' END AS Expensive
FROM menu_items;

/*10. Data Modification - Update*/

UPDATE menu_items
SET price = 25
WHERE menu_item_id = 101;

/*11. Data Modification - Insert: */
INSERT INTO menu_items (item_name,menu_item_id, price, category)
VALUES ('Molton Cake', 111 , 10.99, 'Dessert');

/*12. Data Modification - Delete:*/
DELETE FROM order_details
WHERE order_id < 100;

/*13. Window Functions - Rank:*/
SELECT item_name, price,
       RANK() OVER (ORDER BY price) AS item_rank
FROM menu_items;

/*14. Window Functions - Lag and Lead:*/

SELECT 
    item_name,
    price,
    price - LAG(price) OVER (ORDER BY price) AS price_difference_previous,
    LEAD(price) OVER (ORDER BY price) - price AS price_difference_next
FROM 
    menu_items;

/*15. Common Table Expressions (CTE):*/
WITH expensive_menu_items AS (
    SELECT item_name, price
    FROM menu_items
    WHERE price > 15
)
SELECT * FROM expensive_menu_items;


/*17. Unpivot Data:*/
SELECT Item, Value
FROM menu_items
UNPIVOT
(
    Value FOR Item IN (menu_item_id, item_name, category, price)
) AS unpivoted_menu_items;

/*18. Dynamic SQL:*/
DECLARE @category VARCHAR(100) = 'Dessert'; 
DECLARE @min_price DECIMAL(10, 2) = 10.00; 
DECLARE @max_price DECIMAL(10, 2) = 20.00; 

DECLARE @sql NVARCHAR(MAX);

SET @sql = 'SELECT menu_item_id, item_name, category, price FROM menu_items WHERE 1 = 1';

IF @category IS NOT NULL
    SET @sql = @sql + ' AND category = @category';

IF @min_price IS NOT NULL
    SET @sql = @sql + ' AND price >= @min_price';

IF @max_price IS NOT NULL
    SET @sql = @sql + ' AND price <= @max_price';

EXEC sp_executesql @sql, N'@category VARCHAR(100), @min_price DECIMAL(10, 2), @max_price DECIMAL(10, 2)', @category, @min_price, @max_price;

/*19. Stored Procedure:*/
CREATE PROCEDURE GetAveragePriceForCategory
    @category VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @avg_price DECIMAL(10, 2);

    SELECT @avg_price = AVG(price)
    FROM menu_items
    WHERE category = @category;

    SELECT @avg_price AS average_price;
END;

/*20. Triggers:*/
CREATE TABLE order_log (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    order_date DATE,
    order_time TIME,
);

CREATE TRIGGER trgAfterInsertOrder
ON order_details
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO order_log (order_id, order_date, order_time)
    SELECT order_id, CAST(GETDATE() AS DATE), CAST(GETDATE() AS TIME)
    FROM inserted;
END;

















