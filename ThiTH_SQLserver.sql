CREATE DATABASE AZBank
GO 

USE AZBank
GO

-- Table Customer
CREATE TABLE Customer
(
    CustomerID INT PRIMARY KEY NOT NULL,
	Name NVARCHAR(50) NULL,
	City NVARCHAR(50) NULL,
	Country NVARCHAR(50) NULL,
	Phone NVARCHAR(15) NULL,
	Email NVARCHAR(50) NULL
)
GO

-- Table CustomerAccount
CREATE TABLE CustomerAccount
(
    AccountNumber CHAR(9) PRIMARY KEY NOT NULL,
	CustomerID INT FOREIGN KEY REFERENCES dbo.Customer(CustomerID),
	Balance MONEY NOT NULL,
	MinAccount MONEY NULL
)
GO

-- Table CustomerTransaction
CREATE TABLE CustomerTransaction
(
    TransactionID INT PRIMARY KEY NOT NULL,
	AccountNumber CHAR(9) FOREIGN KEY REFERENCES dbo.CustomerAccount(AccountNumber),
	TransactionDate SMALLDATETIME NULL ,
	Amount MONEY NULL,
	DepositorWithdraw BIT CHECK(DepositorWithdraw = '0' OR DepositorWithdraw = '1') NULL -- 0 withdraw money, 1 depositmoney
)
GO

SELECT * FROM dbo.Customer
SELECT * FROM dbo.CustomerAccount
SELECT * FROM dbo.CustomerTransaction


--3 Insert into each table at least 3 records
INSERT INTO dbo.Customer VALUES (1, N'David', N'New York', N'USA', N'0922226699',  N'david999@gmail.com'),
                                (2, N'Jessica', N'New York', N'USA', N'0922225555',  N'jessica123@gmail.com'),
								(3, N'Emma', N'New York', N'USA', N'0922226222',  N'emma555@gmail.com'),
								(4, N'William', N'New York', N'USA', N'0366622255',  N'william2001@gmail.com')

INSERT INTO dbo.CustomerAccount VALUES ('002036999', 1, 100000, 10),
                                       ('002036555', 2, 9000000, 10),
									   ('002036222', 3, 10000000, 10),
									   ('002036666', 4, 2500000, 10)

INSERT INTO dbo.CustomerTransaction VALUES (1, '002036999', '2021-10-17', 10000, '0'), 
                                           (2, '002036555', '2021-11-01', 90000, '0'), 
										   (3, '002036999', '2021-11-17', 20000, '1'), 
										   (4, '002036222', '2022-01-10', 5000, '0'), 
										   (5, '002036555', '2022-01-12', 100, '1')


--4 Write a query to get all customers from Customer table who live in ‘New York’ 
SELECT * FROM dbo.Customer
WHERE City LIKE N'New York'


--5 Write a query to get account information of the customers (Name, Phone, Email, AccountNumber, Balance
SELECT Name, Phone, Email, AccountNumber, Balance
FROM dbo.Customer 
INNER JOIN dbo.CustomerAccount ON CustomerAccount.CustomerID = Customer.CustomerID 


--6 A-Z bank has a business rule that each transaction (withdrawal or deposit) won’t be over $1000000 (One million USDs). Create a CHECK constraint on Amount column
-- of CustomerTransaction table to check that each transaction amount is greater than 0 and less than or equal $1000000.
ALTER TABLE dbo.CustomerTransaction
     ADD CONSTRAINT ck_Amount CHECK(Amount > 0 AND Amount < 1000000) 


--7 Create a view named vCustomerTransactions that display Name, AccountNumber, TransactionDate, Amount,
--and DepositorWithdraw from Customer, CustomerAccount and CustomerTransaction tables.
CREATE VIEW vCustomerTransactions
AS 
SELECT Name, CustomerAccount.AccountNumber, TransactionDate, Amount, DepositorWithdraw
FROM dbo.Customer 
INNER JOIN dbo.CustomerAccount ON CustomerAccount.CustomerID = Customer.CustomerID
INNER JOIN dbo.CustomerTransaction ON CustomerTransaction.AccountNumber = CustomerAccount.AccountNumber
