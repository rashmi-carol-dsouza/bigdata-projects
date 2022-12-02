WITH dataset AS (
	SELECT 
		soh.CustomerID,
		soh.SalesOrderID,
		soh.OrderDate,
		soh.TotalDue,
		c.Title, 
		c.FirstName,
		c.LastName,
		c.EmailAddress,
		c.Phone,
		a.City,
		a.CountryRegion
	FROM [SalesLT].[SalesOrderHeader] AS soh
		LEFT JOIN [SalesLT].[SalesOrderDetail] AS sod
		ON soh.SalesOrderID = sod.SalesOrderID
		LEFT JOIN [SalesLT].[Customer] AS c
		ON soh.CustomerID = c.CustomerID
		LEFT JOIN [SalesLT].[Address] AS a
		ON soh.ShipToAddressID = a.AddressID
)

SELECT 
	CustomerID as "Customer ID", 
	FirstName +' '+ Lastname as "Name",
	EmailAddress as "Email Address", 
	Phone, 
	City, 
	CountryRegion as "Country/Region",
	FORMAT(max(OrderDate),'d','de-de') as "Last Order Date",
	--FORMAT((SELECT MAX(OrderDate) FROM dataset), 'd', 'de-de') as max_order_date,
	DATEDIFF(day,max(OrderDate),(SELECT MAX(OrderDate) FROM dataset)) AS Recency,
	COUNT(SalesOrderID) AS Frequency,
	FORMAT(SUM(TotalDue),'C') As Monetary
FROM dataset
	GROUP BY CustomerID, OrderDate, FirstName, LastName, EmailAddress, Phone, City, CountryRegion
	ORDER BY Monetary DESC
