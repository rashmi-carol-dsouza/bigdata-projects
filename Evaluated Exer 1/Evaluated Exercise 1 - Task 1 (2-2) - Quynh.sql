WITH dataset AS(
SELECT 
	o.CustomerID, 
	o.OrderDate, 
	od.OrderID,
	SUM((od.UnitPrice * od.Quantity) - od.Discount) AS order_value,
	COUNT(od.Quantity) AS order_qty_articles,
	c.ContactName AS "Name",
    c.City,
    c.Country
FROM [dbo].[Orders] AS o
    LEFT JOIN [dbo].[Order Details] AS od
    ON o.OrderID = od.OrderID
    LEFT JOIN [dbo].[Customers] AS c
    ON o.CustomerID = c.CustomerID
	GROUP BY o.CustomerID, o.OrderDate, od.OrderID, c.ContactName, c.City, c.Country
)

SELECT
	CustomerID, "Name", City, Country,
	FORMAT(max(OrderDate),'d','de-de') as LastOrderDate,
	FORMAT((SELECT MAX(OrderDate) FROM dataset), 'd', 'de-de') as max_order_date,
	DATEDIFF(day,max(OrderDate),(SELECT MAX(OrderDate) FROM dataset)) AS Recency,
	COUNT(OrderID) AS Frequency,
	SUM(order_value) As Monetary
FROM dataset
	GROUP BY CustomerID, "Name", City, Country
	ORDER BY Monetary DESC