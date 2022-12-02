SELECT 
	o.CustomerID,
    o.OrderDate,
    od.OrderID,
    SUM((od.UnitPrice * od.Quantity) - od.Discount) AS order_value,
	COUNT(od.Quantity) AS order_qty_articles,
    c.ContactName,
    c.City,
    c.Country
FROM [dbo].[Orders] AS o
    LEFT JOIN [dbo].[Order Details] AS od
    ON o.OrderID = od.OrderID
    LEFT JOIN [dbo].[Customers] AS c
    ON o.CustomerID = c.CustomerID
	GROUP BY o.CustomerID, o.OrderDate, od.OrderID, c.ContactName, c.City, c.Country