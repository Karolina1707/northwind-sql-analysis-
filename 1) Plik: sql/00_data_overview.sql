### liczba wierszy w "customers"
### Customers row count
SELECT COUNT(1) AS n_rows
FROM customers;

### liczba wierszy w "orders"
### orders row count
SELECT COUNT(1) AS n_rows
FROM orders;

### Zakres dat zamówień
### Date range of orders
SELECT
MAX(orderDate) AS max_date,
MIN(orderDate) AS min_date
FROM orders;
