--- Klienci, którzy najczęściej pojawiają się w Top 3 sprzedaży w każdym miesiącu --- 
--- Customers who most often appear in the Top 3 sales every month --- 

--- wartość pozycji per zamówienie, klienta i miesiąc --- 
--- order values per order, customer and moth ---

WITH wartosc_pozycji AS ( 
SELECT strftime('%Y-%m', orders.orderDate) AS miesiac, 
customers.companyName AS firma,
orders.orderID,
SUM ((unitPrice * quantity) * (1 - discount)) AS wartosc_pozycji
FROM order_details
JOIN orders
ON order_details.orderID = orders.orderID
JOIN customers
ON orders.customerID = customers.customerID
GROUP BY customers.companyName, orders.orderID, strftime('%Y-%m', orders.orderDate)
),
  --- połączenie poziomu zamówień klienta z miesiącem ---
  --- Aggregate to customer-month level --- 
firma_miesiac AS (
SELECT firma, miesiac,
COUNT(orderID) AS orders_n,
ROUND(SUM(wartosc_pozycji), 2) AS total_sales,
ROUND(AVG(wartosc_pozycji), 2) AS avg_order_value
FROM wartosc_pozycji
GROUP BY firma, miesiac
),
  --- ranking klientów według miesięcznej sprzedaży --- 
  --- rank customers by monthly sales --- 
RANKED AS (
SELECT firma, miesiac, orders_n, total_sales, avg_order_value,
   RANK() OVER (
      PARTITION BY miesiac
      ORDER BY total_sales DESC
    ) AS rnk
  FROM firma_miesiac
),
  --- wyznaczenie top3 klientów w miesiącu ---
  --- keep only top 3 customers per month ---
top3 AS (
SELECT *
    FROM RANKED
    WHERE rnk <= 3
)
SELECT firma,
COUNT(*) AS top3,
AVG (rnk) AS avg_rnk
FROM top3
GROUP BY firma
ORDER BY top3 DESC, avg_rnk ASC;
