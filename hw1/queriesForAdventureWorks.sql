USE AdventureWorks2019
GO

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice <> 0.0

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color is NULL

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color is not NULL

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color is not NULL and ListPrice > 0.0

SELECT Name + ' ' + Color as NameColor
FROM Production.Product
WHERE Color is not NULL

SELECT TOP 6 Name, Color
FROM Production.Product
WHERE Color = 'Black' or Color = 'Silver'

SELECT ProductID, Name
FROM Production.Product
WHERE ProductID >= 400 and ProductID <= 500

SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color IN ('Black', 'Blue')

SELECT ProductID, Name
FROM Production.Product
WHERE Name LIKE 'S%'

SELECT TOP 6 Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'S%'
ORDER BY Name

SELECT TOP 5 Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'S%' OR Name LIKE 'A%'
ORDER BY Name 

SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'SPO%' AND Name not LIKE 'SPOK%'
ORDER BY Name 

SELECT Color
FROM Production.Product
WHERE Color is not NULL
GROUP BY Color
ORDER BY Color desc

SELECT DISTINCT Color
FROM Production.Product
WHERE Color IS NOT NULL
ORDER BY Color DESC;

SELECT DISTINCT Color
FROM Production.Product
WHERE Color IS NOT NULL
ORDER BY Color DESC;