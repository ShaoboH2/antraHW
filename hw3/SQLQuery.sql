USE Northwind
GO
-- 1.
SELECT DISTINCT City
FROM Customers
INTERSECT
SELECT DISTINCT City
FROM Employees

--2.
SELECT DISTINCT City
FROM Customers
WHERE City NOT IN (
    SELECT City
    FROM Employees
)

SELECT DISTINCT c.City
FROM Customers c LEFT JOIN Employees e ON c.City = e.City
WHERE e.City is NULL

--3.

SELECT p.ProductName, SUM(quantity) as QuantitySum
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY p.ProductName

-- 4

SELECT City as CustomerCity, SUM(Quantity) as TotalProducts
FROM Customers c 
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City

-- 5

SELECT City, COUNT(CustomerID) as CustomerCount
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2

-- 6

SELECT c.City, COUNT(DISTINCT od.ProductID) AS ProductCount
FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
HAVING COUNT(DISTINCT od.ProductID) >= 2;

-- 7
SELECT DISTINCT ContactName
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City <> o.ShipCity

-- 8 

WITH QuantityPerCity as (
    SELECT ProductID, City, SUM(Quantity) as TotalQuantity
    FROM Customers c
        JOIN Orders o ON c.CustomerID = o.CustomerID
        JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY ProductID, City
), MaxCity as (
    SELECT q.ProductID, City as bestCity
    FROM QuantityPerCity q JOIN (
        SELECT ProductID, MAX(TotalQuantity) as Most
        FROM QuantityPerCity
        GROUP BY ProductID
    ) k ON q.ProductID = k.ProductID AND TotalQuantity = k.Most
)
SELECT p.ProductName, AVGPrice, m.bestCity
FROM Products p
    JOIN (
        SELECT TOP 5 ProductID, SUM(Quantity) as SumOfQuantity, AVG(UnitPrice * (1 - Discount)) as AVGPrice
        FROM Customers c
            JOIN Orders o ON c.CustomerID = o.CustomerID
            JOIN [Order Details] od ON o.OrderID = od.OrderID
        GROUP BY ProductID
        ORDER BY SUM(Quantity) desc
    ) k ON p.ProductID = k.ProductID
    JOIN MaxCity m ON m.ProductID = p.ProductID


-- 9
SELECT e.City, e.FirstName + ' ' + e.LastName
FROM Employees e
    LEFT JOIN Customers c ON e.City = c.City
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE OrderID is NULL

SELECT e.City, e.FirstName + ' ' + e.LastName
FROM Employees e
WHERE e.City not IN (
    SELECT City
    FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
)

-- 10

SELECT City from (SELECT TOP 1 City
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.City 
ORDER BY COUNT(OrderID) desc) as employeeCity
INTERSECT
SELECT City from 
(SELECT TOP 1 City
FROM customers c JOIN Orders o ON c.CustomerID  = o.CustomerID JOIN [Order Details] od on o.OrderID = od.OrderID
GROUP BY c.City
ORDER BY SUM(Quantity) desc) as customerCity

-- 11
/* 
We can first search for duplicates using ROW_NUMBER or subquery
we can also use DISTINCT or GROUP BY to store the current the table into a new table and drop the original table
*/
