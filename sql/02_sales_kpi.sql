--- oblicznie podstawowego KPI sprzedażowego dla bazy Northwind ---
--- calculation of the basic sales KPI for the Northwind database ---

--- Całkowita sprzedaż ---
--- Total sales ---
SELECT
SUM (((unitPrice * quantity)) * (1 - discount)) AS wartosc_pozycji
FROM order_details;

--- Walidacja: suma sprzedaży miesięcznej równa się całkowitej sprzedaży ---
--- Validation: sum of monthly sales equals total sales --- 
SELECT
ROUND(SUM(wartosc_pozycji), 2) AS suma_calosci
FROM (
  SELECT
    strftime('%Y-%m', orderDate) AS data,
    ROUND (SUM((unitPrice * quantity) * (1 - discount)), 2) AS wartosc_pozycji
  FROM order_details
  JOIN (orders)
    ON order_details.orderID = orders.orderID
  GROUP BY strftime('%Y-%m', orderDate)
);
