DROP DATABASE IF EXISTS IceCreamDB;
CREATE DATABASE IF NOT EXISTS IceCreamDB;
USE IceCreamDB;

-- creating the tables 
CREATE TABLE Employee
(
    EmployeeID INT AUTO_INCREMENT, 
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    CONSTRAINT employee_PK PRIMARY KEY (EmployeeID)
) ENGINE = INNODB;

-- recipe table
CREATE TABLE Recipe
(
    RecipeID INT AUTO_INCREMENT,
    Name VARCHAR(50),
    Description TEXT,
    CONSTRAINT recipe_PK PRIMARY KEY (RecipeID)
) ENGINE = INNODB; 

-- VENDOR TABLE
CREATE TABLE Vendor
(
    VendorID INT AUTO_INCREMENT,
    Name VARCHAR(50),
    ContactInfo TEXT,
    CONSTRAINT vendor_PK PRIMARY KEY (VendorID)
) ENGINE = INNODB;

-- create product
CREATE TABLE Product
(
    ProductID INT AUTO_INCREMENT,
    Name VARCHAR(50),
    Price DECIMAL(10,2),
    RecipeID INT,
    VendorID INT,
    CONSTRAINT product_PK PRIMARY KEY (ProductID),
    CONSTRAINT product_FK1 FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID),
    CONSTRAINT product_FK2 FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
) ENGINE = INNODB;

-- inserting the sample data 
-- employee table 
INSERT INTO Employee (FirstName, LastName, Email) VALUES
('Meredith', 'Grey', 'meredith.grey@email.com'),
('Derek', 'Shepherd', 'derek.shepherd@email.com'),
('Cristina', 'Yang', 'cristina.yang@email.com');

-- recipe 
INSERT INTO Recipe (Name, Description) VALUES 
('Vanilla Base', 'Classic vanilla ice cream base: milk, cream, sugar, vanilla.'),
('Chocolate Base', 'Rich chocolate ice cream base: milk, cream, sugar, cocoa.'),
('Strawberry Base', 'Fresh strawberry base: milk, cream, sugar, strawberries.');

-- vendor
INSERT INTO Vendor (Name, ContactInfo) VALUES
('Dairy Supply Co.', '123 philadelphia St, (555) 123-4567'),
('SprinkleFactory.', '456 sunrise Rd, (555) 987-6543'),
('FruitFarm .', '789 Bustleton Blvd, (555) 222-3333');

-- products 
INSERT INTO Product (Name, Price, RecipeID, VendorID) VALUES
('Vanilla Scoop', 2.50, 1, 1),     
('Chocolate Scoop', 2.75, 2, 1),    
('Strawberry Scoop', 3.00, 3, 3),   
('Vanilla Pint', 5.00, 1, 1),       
('Chocolate Pint', 5.50, 2, 1),     
('Strawberry Pint', 6.00, 3, 3);



-- PART TWO REQUIRMENTS
 
-- 1. union query that combines related data 
-- from two different tables in my ice cream database.
SELECT ProductID AS ID, Name, Price AS Value, 'Product' AS Source
FROM Product
UNION
SELECT RecipeID AS ID, Name, LENGTH(Description) AS Value, 'Recipe' AS Source
FROM Recipe;

-- 2. this shows results for recipe names that have "base" in them.
SELECT p.ProductID, p.Name
FROM Product p
WHERE p.ProductID IN (
    SELECT r.RecipeID
    FROM Recipe r
    WHERE r.Name LIKE '%Base'
);

-- 3 this shows the the RecipeID and RecipeName for recipes 
-- that are used in products where the product name starts with the recipe name
SELECT DISTINCT r.RecipeID, r.Name AS RecipeName
FROM Recipe r
WHERE (r.RecipeID, r.Name) IN
(
    SELECT p.RecipeID, SUBSTRING_INDEX(p.Name, ' ', 1) AS ProductBaseName
    FROM Product p
    WHERE p.RecipeID IS NOT NULL
);
SELECT * FROM Recipe; 

-- 4. this selects colomns from the rpoduct and recipe tables 
-- and inner join stament to combine the rows that have a macthing recipe id.

SELECT p.ProductID, p.Name AS ProductName, p.Price, 
       r.RecipeID, r.Name AS RecipeName, r.Description
FROM Product p
INNER JOIN Recipe r ON p.RecipeID = r.RecipeID
ORDER BY p.ProductID;

-- 5 altring the tables 
-- changing the contact number for an employee and the name for a company
UPDATE Vendor SET Name = 'Dairy Cream.' WHERE VendorID = 1;
SELECT * FROM Vendor;

ALTER TABLE Employee ADD COLUMN PhoneNumber VARCHAR(20);
UPDATE Employee SET PhoneNumber = '555-123-4567' WHERE EmployeeID = 1;
SELECT * FROM Employee;

-- 6. updating employee email and a vendor name
UPDATE Employee
SET Email = 'updated.email@email.com'
WHERE EmployeeID = 2;

UPDATE Vendor
SET Name = 'Updated Dairy COW.'
WHERE VendorID = 1;



-- 7. DELET statment that delteds a product between the price of 3 and 5 dollats
--  and also deltes any product with vanilla in the name
DELETE FROM Product
WHERE Price BETWEEN 3.00 AND 5.00;
SELECT * FROM Product;

DELETE FROM Product
WHERE Name = 'Vanilla Scoop' OR Name = 'Vanilla Pint';
SELECT * FROM Product;

-- 8.
-- this calculates the sum and the average price 
-- of all the rpducts inside the products table
SELECT 
    SUM(Price) AS TotalPrice,
    AVG(Price) AS AveragePrice
FROM Product;

-- this shows the minumine and maximum recipeid inside the recipe table
SELECT 
    MIN(RecipeID) AS SmallestRecipeID,
    MAX(RecipeID) AS LargestRecipeID
FROM Recipe;

-- 9. this groups the products by the recipe
SELECT r.Name AS RecipeName, COUNT(p.ProductID) AS NumberOfProducts
FROM Recipe r
JOIN Product p ON r.RecipeID = p.RecipeID
GROUP BY r.Name;
-- this groups vendors by their contact information'
--  and shows vendors that share the same contact info 
SELECT v.ContactInfo, COUNT(v.VendorID) AS NumberOfVendors
FROM Vendor v
GROUP BY v.ContactInfo;

-- 10.group by and having clause 
-- counts the number of products for each recipe and shows the recipeds with more than one product in them
SELECT r.Name AS RecipeName, COUNT(p.ProductID) AS NumberOfProducts
FROM Recipe r
JOIN Product p ON r.RecipeID = p.RecipeID
GROUP BY r.Name
HAVING COUNT(p.ProductID) > 1;
-- this groups the vendor and product table 
-- and calculates the average price of products for each vendor and shows the avergae that is over 5 dollars
SELECT v.Name AS VendorName, AVG(p.Price) AS AveragePrice
FROM Vendor v
JOIN Product p ON v.VendorID = p.VendorID
GROUP BY v.Name
HAVING AVG(p.Price) > 5.00;


-- 11.two queries that are using the group by statment
-- this will count the products by recipe
SELECT r.Name AS RecipeName, COUNT(p.ProductID) AS NumberOfProducts
FROM Recipe r
JOIN Product p ON r.RecipeID = p.RecipeID
GROUP BY r.Name;

-- this will group the vendors by their contact information
SELECT v.ContactInfo, COUNT(v.VendorID) AS NumberOfVendors
FROM Vendor v
GROUP BY v.ContactInfo;


-- querys that sort the results in ascending and descending order
SELECT * FROM Product
ORDER BY Price ASC;

SELECT * FROM Vendor
ORDER BY Name DESC;

-- 12. sql view statments
CREATE VIEW ProductsByRecipe AS
SELECT p.Name AS ProductName, r.Name AS RecipeName
FROM Product p
JOIN Recipe r ON p.RecipeID = r.RecipeID;

SELECT * FROM ProductsByRecipe;

-- shows the price for products from each vendor using inner join statment
CREATE VIEW AveragePriceByVendor AS
SELECT v.Name AS VendorName, AVG(p.Price) AS AveragePrice
FROM Vendor v
JOIN Product p ON v.VendorID = p.VendorID
GROUP BY v.Name;

SELECT * FROM AveragePriceByVendor;


-- 13. creating user and revoking privlidges and granting privlidges
CREATE USER 'John Cena'@'localhost' IDENTIFIED BY 'password123';
CREATE USER 'ASMAAROHI'@'localhost' IDENTIFIED BY 'MyPassword456';


GRANT ALL PRIVILEGES ON IceCreamDB.* TO 'John Cena'@'localhost';
GRANT SELECT, INSERT ON IceCreamDB.* TO 'Asmaa Rohi'@'localhost';

-- 14.revokes privliges 
REVOKE ALL PRIVILEGES ON *.* FROM 'John cena'@'localhost';
SELECT 'After Revoking Privileges - John Cena' AS User;
SHOW GRANTS FOR 'john cena'@'localhost';



