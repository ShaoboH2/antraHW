USE AdventureWorks2019
GO

SELECT COUNT(ProductID) as ProductCount
FROM Production.Product

SELECT COUNT(ProductID) as ProductCountWithSub
FROM Production.Product
WHERE ProductSubcategoryID is NOT NULL

SELECT  ProductSubcategoryID, COUNT(ProductSubcategoryID) as CounterProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID

SELECT COUNT(ProductID) as ProductCountWithOutSub
FROM Production.Product
WHERE ProductSubcategoryID IS NULL

SELECT SUM(Quantity) as EachProductQuantity
FROM Production.ProductInventory
GROUP BY ProductID


SELECT s1.ProductID, s2.TheSum
FROM Production.ProductInventory s1 
JOIN (
    SELECT ProductID, SUM(Quantity) as TheSum
    FROM Production.ProductInventory
    GROUP BY ProductID
) AS s2 ON s1.ProductID = s2.ProductID
WHERE s1.LocationID = 40 and s2.TheSum < 100

SELECT s1.Shelf, s1.ProductID, s2.TheSum
FROM Production.ProductInventory s1 
JOIN (
    SELECT ProductID, SUM(Quantity) as TheSum
    FROM Production.ProductInventory
    WHERE Shelf NOT LIKE 'N/A'
    GROUP BY ProductID
) s2 ON s1.ProductID = s2.ProductID
WHERE s1.LocationID = 40 and s2.TheSum < 100

SELECT avg(quantity)
FROM Production.ProductInventory
WHERE LocationID = 10

SELECT ProductID, Shelf, AVG(Quantity) as TheAvg
FROM Production.ProductInventory
GROUP BY Shelf, ProductID

SELECT ProductID, Shelf, AVG(Quantity) as TheAvg
FROM Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY Shelf, ProductID




SELECT Color, NULL as Class, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL
GROUP BY Color

UNION ALL

SELECT NULL as Color, Class, COUNT(*) AS TheCount, AVG(ListPrice)  AS AvgPrice
FROM Production.Product
WHERE Class IS NOT NULL
GROUP BY Class


SELECT c.Name as Country, s.Name as Province
FROM Person.CountryRegion c JOIN Person.StateProvince s on c.CountryRegionCode = s.CountryRegionCode



SELECT c.Name as Country, s.Name as Province
FROM Person.CountryRegion c JOIN Person.StateProvince s on c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name = 'Germany' or c.Name = 'Canada'

USE Northwind
GO

SELECT ProductName, os.OrderDate
FROM Products p 
     JOIN [Order Details] o on p.ProductID = o.ProductID 
     JOIN Orders os on o.OrderID = os.OrderID
WHERE os.OrderDate >= DATEADD(year, -27, GETDATE());

SELECT TOP 5 o.ShipPostalCode
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE ShipPostalCode IS NOT NULL 
GROUP BY o.ShipPostalCode 
ORDER BY SUM(od.Quantity) desc
    
SELECT TOP 5 o.ShipPostalCode
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE ShipPostalCode IS NOT NULL and o.OrderDate >= DATEADD(year, -27, GETDATE())
GROUP BY o.ShipPostalCode 
ORDER BY SUM(od.Quantity) desc
    
SELECT City, COUNT(CustomerID)
FROM Customers
GROUP BY City

SELECT City, COUNT(CustomerID) as NumberCustomers
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2


SELECT DISTINCT ContactName
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1998-01-01'

SELECT ContactName, MAX(OrderDate)
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY ContactName

/* for fun
Find out who made the latest order

SELECT DISTINCT ContactName
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od on od.OrderID = o.OrderID
JOIN (
    SELECT od1.ProductID, MAX(OrderDate) as latest
    FROM Customers c1 JOIN Orders o1 ON c1.CustomerID = o1.CustomerID JOIN [Order Details] od1 on od1.OrderID = o1.OrderID
    GROUP BY od1.productID
) m on m.ProductID = od.ProductID
WHERE o.OrderDate = m.latest
GROUP BY ContactName

*/

SELECT ContactName, SUM(Quantity) as ProductCount
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY ContactName

SELECT ContactName, SUM(Quantity) as ProductCount
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY ContactName
HAVING SUM(Quantity) > 100

SELECT DISTINCT sp.ContactName as SupplierCompanyName, s.CompanyName as ShippingCompanyName
FROM Suppliers sp 
    JOIN Products p ON sp.SupplierID = p.SupplierID
    JOIN [Order Details] od ON p.ProductID = od.ProductID 
    JOIN Orders o ON od.OrderID = o.OrderID   
    JOIN Shippers s ON o.ShipVia = s.ShipperID
ORDER BY sp.ContactName


SELECT OrderDate, ProductName
FROM Products p
    JOIN [Order Details] od ON p.ProductID = od.ProductID 
    JOIN Orders o ON od.OrderID = o.OrderID
ORDER BY OrderDate

SELECT e1.FirstName + ' ' + e1.LastName as employee1, e2.FirstName + ' ' + e2.LastName as employee2
FROM Employees e1 JOIN Employees e2 on e1.Title = e2.Title and e1.EmployeeID < e2.EmployeeID

SELECT e1.FirstName + ' ' + e1.LastName as employee,  e2.FirstName + ' ' + e2.LastName as manager
FROM Employees e1 LEFT JOIN Employees e2 on e1.ReportsTo = e2.employeeID

SELECT e0.FirstName + ' ' + e0.LastName as employee2
FROM Employees e0
JOIN (
    SELECT e2.EmployeeID 
    FROM Employees e1 LEFT JOIN Employees e2 on e1.ReportsTo = e2.employeeID
    GROUP BY e2.EmployeeID
    HAVING COUNT(e1.FirstName) > 2
) m on e0.EmployeeID = m.EmployeeID


SELECT City, ContactName, 'Customer' as TYPE
FROM Customers

UNION 

SELECT City, ContactName, 'Supplier' as TYPE
FROM Suppliers
