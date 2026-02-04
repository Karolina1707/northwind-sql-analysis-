--- Ranking klientów według całkowitej sprzedaży --- 
--- Customer ranking based on total sales --- 

-- wartość zamówienia na klienta i zamówienie --
-- order value per customer and order --
WITH wartosc_pozycji AS 
( 
SELECT orders.orderID, companyName AS firma,
SUM ((unitPrice * quantity) * (1 - discount)) AS wartosc_pozycji
FROM order_details
JOIN orders
ON order_details.orderID = orders.orderID
JOIN customers
ON orders.customerID = customers.customerID
GROUP BY customers.companyName, orders.orderID
)
-- Agregacja i ranking na poziomie klienta--
-- customer-level aggregation and ranking -- 
SELECT firma,
COUNT(*) AS orders_n,
ROUND(SUM(wartosc_pozycji), 2) AS total_sales,
ROUND(AVG(wartosc_pozycji), 2) AS avg_order_value
FROM wartosc_pozycji
GROUP BY firma
ORDER BY total_sales DESC
LIMIT 10;
