/* CATALOG OF ALL THE BOOKS */
CREATE TABLE CATALOG (
    ISBN VARCHAR(50) PRIMARY KEY,
    Title VARCHAR(40) NOT NULL,
    Publisher VARCHAR(40) NOT NULL,
    Year INT(4) NOT NULL,
    Price VARCHAR(10) NOT NULL,
    CATEGORY VARCHAR(15) NOT NULL
);

/* AUTHORS OF ALL BOOKS */
CREATE TABLE AUTHORS (
    ISBN VARCHAR(50) NOT NULL,
    Authors_Names CHAR(100) NOT NULL
);

/* INVENTORY WITH QUANTITY */
CREATE TABLE INVENTORY (
    ISBN VARCHAR(50) PRIMARY KEY,
    Inv_Quantity INT NOT NULL
);

/* CREATE ACCOUNTS TO IDENTIFY CERTAIN PERSONAL, AS WELL AS CREATE TABLE TO STORE ALL ACCOUNTS IN ONE PLACE */
/* Basics of an account */
CREATE TABLE ACCOUNTS (
    Email VARCHAR(35) PRIMARY KEY,
    Name CHAR(30) NOT NULL,
    Birthday DATE NOT NULL,
    PhoneNumber INT(10) NOT NULL,
    Address VARCHAR(40) NOT NULL
);
/* Each buyer has a seperate account and then tagged with their own ID */
CREATE TABLE BUYER_ACCOUNT (
    Email VARCHAR(35) PRIMARY KEY ,
    Name CHAR(30) NOT NULL,
    Birthday DATE NOT NULL,
    PhoneNumber INT(10) NOT NULL,
    Address VARCHAR(40) NOT NULL,
    StorePoints INT NOT NULL
);
/* Each employee has a seperate account and then tagged with their own ID */
CREATE TABLE EMPLOYEE_ACCOUNT (
    Email VARCHAR(35) PRIMARY KEY,
    Name CHAR(30) NOT NULL,
    Birthday DATE NOT NULL,
    PhoneNumber INT(10) NOT NULL,
    Address VARCHAR(40) NOT NULL
);
/* Each seller has a seperate account and then tagged with their own ID */
CREATE TABLE SELLER_ACCOUNT (
    Email VARCHAR(35) PRIMARY KEY,
    Name CHAR(30) NOT NULL,
    Birthday DATE NOT NULL,
    PhoneNumber INT(10) NOT NULL,
    Address VARCHAR(40) NOT NULL
);

/* CREATE TABLE OF WHICH EMPLOYEE ACCOUNTS CAN MANAGE OTHER ACCOUNTS */
CREATE TABLE EMPLOYEE_MANAGES_SELLER(
    Employee_Email VARCHAR(35) NOT NULL,
    Seller_Email VARCHAR(35) NOT NULL,

    FOREIGN KEY(Employee_Email) REFERENCES EMPLOYEE_ACCOUNT(Email)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Seller_Email) REFERENCES SELLER_ACCOUNT(Email)
        ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE EMPLOYEE_MANAGES_BUYER(
    Employee_Email VARCHAR(35) NOT NULL,
    Buyer_Email VARCHAR(35) NOT NULL,

    FOREIGN KEY(Employee_Email) REFERENCES EMPLOYEE_ACCOUNT(Email)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Buyer_Email) REFERENCES BUYER_ACCOUNT(Email)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/* If problem occurs with account, problem should be recorded */
CREATE TABLE CUSTOMER_SERVICE (
    Account_Email VARCHAR(35) NOT NULL,
    Case_Number PRIMARY KEY,
    Date DATE NOT NULL,
    Problem_Description VARCHAR(35) NOT NULL,
    Employee_In_Charge VARCHAR(50) NOT NULL,

    FOREIGN KEY(Account_Email) REFERENCES BUYER_ACCOUNT(Email)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Employee_In_Charge) REFERENCES EMPLOYEE_ACCOUNT(Email)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/* Buyer has ability to create and add books to their wishlist */
CREATE TABLE WISHLIST (
    Email VARCHAR(35) NOT NULL,
    ISBN VARCHAR(50) NOT NULL,
    Title VARCHAR(50) NOT NULL,
    Price VARCHAR(10) NOT NULL,
    DateAdded DATE NOT NULL
);
/* Obtain buyers email, ISBN, and price of book */
 CREATE TABLE BUYER_MANAGES_WISHLIST (
     Buyer_Email VARCHAR(35) NOT NULL,
     Book_ISBN VARCHAR(50) NOT NULL,
     Book_Price VARCHAR(10) NOT NULL,

     FOREIGN KEY(Buyer_Email) REFERENCES BUYER_ACCOUNT(Email)
        ON DELETE CASCADE ON UPDATE CASCADE,
     FOREIGN KEY(Book_ISBN) REFERENCES CATALOG(ISBN)
        ON DELETE CASCADE ON UPDATE CASCADE
 );

/* Transactions when buying books
   - Payment Type
   - Receipt
   - Which books are being bought
   - Quantity of books being bought
   - Total Price
   - Each transaction is tagged to their respective buyer
   - Payment accepted (boolean)
 */
 /* Payment Type: cash or card, total amount, receipt number */
CREATE TABLE PAYMENT_TYPE (
    Payment_ID INT PRIMARY KEY,
    Name VARCHAR(40) NOT NULL,
    Method VARCHAR(20) NOT NULL
);
/* If payment is approved */
CREATE TABLE PAYMENT_STATUS (
    Payment_ID INT PRIMARY KEY,
    Order_ID INT NOT NULL,
    Approval_Status BOOLEAN NOT NULL, /* 1 = Approved, 0 = denied */
    Approval_Date DATE NOT NULL,

    FOREIGN KEY(Payment_ID) REFERENCES PAYMENT_TYPE(Payment_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(Order_ID) REFERENCES ORDER_DETAILS(Order_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
/* Individual book prices, total price, buyer email, book details (ISBN) */
CREATE TABLE ORDER_DETAILS (
    Order_ID INT NOT NULL,
    Order_Date DATE NOT NULL,
    Book_ISBN VARCHAR(50) NOT NULL,
    Book_Title VARCHAR(100) NOT NULL,
    Book_Price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (Book_ISBN) REFERENCES CATALOG(ISBN)
        ON DELETE CASCADE ON UPDATE CASCADE
);
/* Record Transaction of buyer and the books being bought */
CREATE TABLE TRANSACTION_DETAILS (
    Transaction_ID INT PRIMARY KEY,
    Transaction_Date DATE NOT NULL,
    Order_ID INT NOT NULL,
    Transaction_Total DECIMAL(10,2) NOT NULL,
    Buyer_Details VARCHAR(30) NOT NULL,
    Payment_Approved BOOLEAN NOT NULL,

    FOREIGN KEY (Order_ID) REFERENCES ORDER_DETAILS(Order_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Buyer_Details) REFERENCES BUYER_ACCOUNT(Email)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/* Buyer should get receipt of transaction details */
CREATE TABLE BUYER_RECEIPT (
    Buyer_Email VARCHAR(50) NOT NULL,
    Transaction_ID INT NOT NULL,
    Order_ID INT NOT NULL,
    Receipt_Date DATE NOT NULL,
    Transaction_Total DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (Buyer_Email) REFERENCES BUYER_ACCOUNT(Email)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Transaction_ID) REFERENCES TRANSACTION_DETAILS(Transaction_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Order_ID) REFERENCES ORDER_DETAILS(Order_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/* Seller wants to add, drop, update books to catalogs */
CREATE TABLE SELLER_UPDATES_CATALOG (
    Seller_Email VARCHAR(30) NOT NULL,
    ISBN VARCHAR(50) NOT NULL,
    Title VARCHAR(40) NOT NULL,
    Publisher VARCHAR(40) NOT NULL,
    Year INT(4) NOT NULL,
    Price VARCHAR(10) NOT NULL,
    CATEGORY VARCHAR(15) NOT NULL,

    FOREIGN KEY (Seller_Email) REFERENCES SELLER_ACCOUNT(Email)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ISBN) REFERENCES CATALOG(ISBN)
        ON DELETE CASCADE ON UPDATE CASCADE
);


/* Index */
/* Genre - this allows customers to just search for books in genres they are interested in */
CREATE INDEX Genre
ON CATALOG(CATEGORY);

/* Price Range - this gives customers a filter to find books within price ranges */
CREATE INDEX Price_Range
ON CATALOG(Price);


/*
INSERT / DELETE STATEMENTS

Inserting data into the AUTHORS and INVENTORY tables,need to make sure that the
ISBN value already exists in the CATALOG table.
If it does not exist, need to insert it into the CATALOG table first.
 */
INSERT INTO CATALOG (ISBN, Title, Publisher, Year, Price, CATEGORY) VALUES
('9783161484100', 'The Catcher in the Rye', 'Little, Brown and Company', 1951, '10.99', 'Fiction');
INSERT INTO AUTHORS (ISBN, Authors_Names) VALUES
('9783161484100', 'J. D. Salinger');
INSERT INTO INVENTORY (ISBN, Inv_Quantity) VALUES
('9783161484100', 50);

/*
 Likewise when deleting data, need to delete records from CATALOG, AUTHORS, and INVENTORY
 */
DELETE FROM CATALOG WHERE ISBN = '9783161484100';
DELETE FROM AUTHORS WHERE ISBN = '9783161484100';
DELETE FROM INVENTORY WHERE ISBN = '9783161484100';


/* VIEWS */

/* Display a Full Catalog
   the ISBN, Title, Authors, Publisher, and Price of all books */
CREATE VIEW FULL_CATALOG AS
SELECT CATALOG.ISBN, CATALOG.Title, AUTHORS.Authors_Names, CATALOG.Publisher, CATALOG.Price
FROM CATALOG
INNER JOIN AUTHORS ON CATALOG.ISBN = AUTHORS.ISBN;

/* Display ONE_WISH
   Customer Email, Name, Items in their Wishlist
 */
CREATE VIEW ONE_WISH AS
SELECT BUYER_ACCOUNT.Name, BUYER_ACCOUNT.Email, WISHLIST.Title, INVENTORY.Inv_Quantity
FROM WISHLIST
INNER JOIN INVENTORY ON WISHLIST.ISBN = INVENTORY.ISBN
INNER JOIN BUYER_ACCOUNT ON WISHLIST.Email = BUYER_ACCOUNT.Email;


/* QUERIES */

/* EXTRA QUERIES */

/* Find the person with the most amount of books in their wishlist */
SELECT BUYER_ACCOUNT.name, COUNT(Book_ISBN) AS Total_Books
FROM BUYER_ACCOUNT
INNER JOIN BUYER_MANAGES_WISHLIST ON BUYER_ACCOUNT.Email = BUYER_MANAGES_WISHLIST.Buyer_Email
GROUP BY Name
ORDER BY Total_Books DESC
LIMIT 1;

/* Find the reason for a specific customer service problem.
        Customers name is Maggie Brown */
SELECT ACCOUNTS.Name, CUSTOMER_SERVICE.Problem_Description
FROM CUSTOMER_SERVICE
INNER JOIN ACCOUNTS ON CUSTOMER_SERVICE.Account_Email = ACCOUNTS.Email
WHERE ACCOUNTS.Name = 'Maggie Brown';

/* In ascending order, get the price of each customers wishlist */
UPDATE WISHLIST
SET Price = REPLACE(Price, '$', '')
WHERE WISHLIST.Price LIKE '%$%';
SELECT BUYER_ACCOUNT.name, CAST(WISHLIST.Price AS DECIMAL(10,2)) AS Total_Price
FROM BUYER_ACCOUNT
INNER JOIN WISHLIST ON BUYER_ACCOUNT.Email = WISHLIST.Email
GROUP BY Name
ORDER BY Total_Price ASC;

/* Find the top 5 customers who have accumulated the most store points and their current store point balances. */
SELECT Name, StorePoints FROM Buyer_Account
ORDER BY StorePoints DESC
LIMIT 5;

/* Find the average price of a book in each category - keep price at two decimals */
/* Update CATALOG TO GET RID OF '$', then cast AVG command since all the values are number */
UPDATE CATALOG
SET Price = REPLACE(Price, '$', '')
WHERE CATALOG.Price LIKE '%$%';
SELECT CATEGORY, ROUND(AVG(Price), 2) AS avg_price FROM CATALOG
GROUP BY category;

/* Find most used method payment type, and display the counts of each payment method in desc order */
SELECT Method, COUNT(*) as Num_Transactions FROM PAYMENT_TYPE
WHERE Method = 'Card' OR Method = 'Cash'
GROUP BY Method
ORDER BY Num_Transactions DESC;

/* SIMPLE QUERIES */
/* Find all of the books by Pratchett that cost less than $10 */
SELECT Title FROM CATALOG
INNER JOIN AUTHORS on CATALOG.ISBN = AUTHORS.ISBN
WHERE AUTHORS.Authors_Names LIKE '%Pratchett%'
AND CAST(Price AS DECIMAL(10,2)) < 10.00;

/* Give all of the titles and dates for purchases made by a particular customer. */
/* Let's find all the purchases made by John Smith */
SELECT ORDER_DETAILS.Book_Title, BUYER_RECEIPT.Receipt_Date
FROM ORDER_DETAILS
INNER JOIN BUYER_RECEIPT ON ORDER_DETAILS.Order_ID = BUYER_RECEIPT.Order_ID
INNER JOIN BUYER_ACCOUNT ON BUYER_RECEIPT.Buyer_Email = BUYER_ACCOUNT.Email
WHERE BUYER_ACCOUNT.Name = 'John Smith';

/* List all of the books with less than 5 quantity in stock. */
SELECT Title FROM CATALOG
INNER JOIN INVENTORY ON CATALOG.ISBN = INVENTORY.ISBN
WHERE INVENTORY.Inv_Quantity < 5;

/* Give all the customers who purchased a book by Pratchett
   and the titles of Pratchett books they purchased */
SELECT BUYER_ACCOUNT.Name AS Customer_Name, ORDER_DETAILS.Book_Title AS Title, AUTHORS.Authors_Names AS Authors
FROM BUYER_ACCOUNT
INNER JOIN BUYER_RECEIPT ON BUYER_ACCOUNT.Email = BUYER_RECEIPT.Buyer_Email
INNER JOIN ORDER_DETAILS ON BUYER_RECEIPT.Order_ID = ORDER_DETAILS.Order_ID
INNER JOIN CATALOG ON ORDER_DETAILS.Book_Title = CATALOG.Title
INNER JOIN AUTHORS ON CATALOG.ISBN = AUTHORS.ISBN
WHERE AUTHORS.Authors_Names LIKE '%Pratchett%';

/* Find the total number of books purchased by a single customer */
/* Let's assume the customers name is 'Jaash Atluri' */
SELECT BUYER_ACCOUNT.Name, COUNT(ORDER_DETAILS.Book_ISBN) AS Total_Books_Purchased
FROM ORDER_DETAILS
INNER JOIN BUYER_RECEIPT ON ORDER_DETAILS.Order_ID = BUYER_RECEIPT.Order_ID
INNER JOIN BUYER_ACCOUNT ON BUYER_RECEIPT.Buyer_Email = BUYER_ACCOUNT.Email
WHERE BUYER_ACCOUNT.Name = 'Jaash Atluri';

/* Find the customer who has purchased the most books
   and the total number of books they have purchased */
SELECT BUYER_ACCOUNT.Name, COUNT(ORDER_DETAILS.Book_ISBN) AS Total_Books_Purchased
FROM ORDER_DETAILS
INNER JOIN BUYER_RECEIPT ON ORDER_DETAILS.Order_ID = BUYER_RECEIPT.Order_ID
INNER JOIN BUYER_ACCOUNT ON BUYER_RECEIPT.Buyer_Email = BUYER_ACCOUNT.Email
GROUP BY BUYER_ACCOUNT.Name
ORDER BY Total_Books_Purchased DESC
LIMIT 1;

/* Browse Catalog for a certain book */
/* Customer is trying to find the book 'Small Gods' by Pratchett */
SELECT CATALOG.Title, AUTHORS.Authors_Names, INVENTORY.Inv_Quantity AS Inventory
FROM CATALOG
INNER JOIN INVENTORY ON CATALOG.ISBN = INVENTORY.ISBN
INNER JOIN AUTHORS ON CATALOG.ISBN = AUTHORS.ISBN
WHERE CATALOG.Title = 'Small Gods' AND AUTHORS.Authors_Names LIKE '%Pratchett%';

/* Customer can review their accounts */
/* Requires Customer to input their email in order to review their own account */
SELECT * FROM BUYER_ACCOUNT
WHERE BUYER_ACCOUNT.Email = '123test@test.net';

/* Employee Reviews Sales */
SELECT ORDER_DETAILS.Book_ISBN, ORDER_DETAILS.Book_Title, INVENTORY.Inv_Quantity
FROM ORDER_DETAILS
INNER JOIN INVENTORY ON ORDER_DETAILS.Book_ISBN = INVENTORY.ISBN;

/* Employee reviews sales and needs to see what books need to be re-ordered */
/* If the quantity is 0 and the book has been ordered before, need to restock */
SELECT ORDER_DETAILS.Book_ISBN, ORDER_DETAILS.Book_Title, INVENTORY.Inv_Quantity
FROM ORDER_DETAILS
INNER JOIN INVENTORY ON ORDER_DETAILS.Book_ISBN = INVENTORY.ISBN
WHERE INVENTORY.Inv_Quantity = 0;