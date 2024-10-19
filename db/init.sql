CREATE EXTENSION "uuid-ossp";

CREATE TABLE Users (
       user_id UUID NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
       username VARCHAR(50) NOT NULL UNIQUE,
       email VARCHAR(100) NOT NULL UNIQUE,
       full_name VARCHAR(100),
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Accounts (
      account_id UUID NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
      user_id UUID NOT NULL,
      account_type VARCHAR(50),  -- e.g., CURRENT, SAVINGS, etc.
      balance DECIMAL(15, 2) DEFAULT 0.00,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


CREATE TABLE Transactions (
              transaction_id UUID NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
              from_account_id UUID,
              to_account_id UUID,
              type_name VARCHAR(50) NOT NULL,
              amount DECIMAL(15, 2) NOT NULL,
              transaction_date DATE DEFAULT CURRENT_DATE,
              description VARCHAR(255),
              FOREIGN KEY (from_account_id) REFERENCES Accounts(account_id),
              FOREIGN KEY (to_account_id) REFERENCES Accounts(account_id)
);


INSERT INTO Users (user_id, username, email, full_name)
VALUES
    (uuid_generate_v4(), 'johncena', 'john.cena@example.com', 'John Cena'),
    (uuid_generate_v4(), 'alicew', 'alice.wonder@example.com', 'Alice Wonderland');


INSERT INTO Accounts (account_id, user_id, account_type, balance)
VALUES
    ('9223a802-d334-40f8-8fd0-ea8f5293d7bf', (SELECT user_id FROM Users WHERE username = 'johncena'), 'CURRENT', 1200.50),
    (uuid_generate_v4(), (SELECT user_id FROM Users WHERE username = 'johncena'), 'SAVINGS', 3400.00),
    ('aaf8851d-c852-44ed-b29e-90275a9b8fab', (SELECT user_id FROM Users WHERE username = 'alicew'), 'CURRENT', 1500.00),
    (uuid_generate_v4(), (SELECT user_id FROM Users WHERE username = 'alicew'), 'SAVINGS', 5600.75);



INSERT INTO Transactions (transaction_id, from_account_id, to_account_id, type_name, amount, transaction_date, description)
VALUES
    -- January
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 1203.00, '2023-01-03', 'ATM withdrawal'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit',  154.00, '2023-01-07', 'Grocery shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit', 508.00, '2023-01-15', 'Salary deposit'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 708.00, '2023-01-16', 'Gift deposit'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 400.00, '2023-01-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 200.00, '2023-01-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-01-29', 'Online shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-01-30', 'Freelance payment'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 106.00, '2023-01-05', 'Groceries Payment'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 250.00, '2023-01-10', 'Salary Deposit'),


    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1203.00, '2023-01-03', 'ATM withdrawal'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit',  154.00, '2023-01-07', 'Grocery shopping'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit', 508.00, '2023-01-15', 'Salary deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 708.00, '2023-01-16', 'Gift deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 400.00, '2023-01-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 200.00, '2023-01-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-01-29', 'Online shopping'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-01-30', 'Freelance payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 106.00, '2023-01-05', 'Groceries Payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 250.00, '2023-01-10', 'Salary Deposit'),

    -- February
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 1230.00, '2023-02-03', 'ATM withdrawal'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit',  150.00, '2023-02-07', 'Grocery shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit', 300.00, '2023-02-15', 'Salary deposit'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 300.00, '2023-02-16', 'Gift deposit'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 500.00, '2023-02-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 100.00, '2023-02-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 80.00, '2023-02-23', 'Online shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 910.00, '2023-02-26', 'Freelance payment'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 830.00, '2023-02-03', 'Rent Payment'),
    (uuid_generate_v4(),NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Credit', 930.00, '2023-02-15', 'Freelance Payment'),

    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1203.00, '2023-02-03', 'ATM withdrawal'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit',  154.00, '2023-02-07', 'Grocery shopping'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit', 508.00, '2023-02-15', 'Salary deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 708.00, '2023-02-16', 'Gift deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-02-26', 'Online shopping'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-02-22', 'Freelance payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 106.00, '2023-02-05', 'Groceries Payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 250.00, '2023-02-10', 'Salary Deposit'),
    -- March
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 810.00, '2023-03-03', 'ATM withdrawal'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit',  930.00, '2023-03-07', 'Grocery shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit', 230.00, '2023-03-15', 'Salary deposit'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 230.00, '2023-03-16', 'Gift deposit'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 340.00, '2023-03-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 150.00, '2023-03-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 90.00, '2023-03-29', 'Online shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 430.00, '2023-03-30', 'Freelance payment'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 345.00, '2023-03-08', 'Utilities Payment'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 1300.00, '2023-03-20', 'Gift Received'),

    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1203.00, '2023-03-03', 'ATM withdrawal'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit',  154.00, '2023-03-07', 'Grocery shopping'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit', 508.00, '2023-03-15', 'Salary deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 708.00, '2023-03-16', 'Gift deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-03-29', 'Online shopping'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-03-30', 'Freelance payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 106.00, '2023-03-05', 'Groceries Payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 250.00, '2023-03-10', 'Salary Deposit'),
    -- April
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 3500.00, '2023-04-03', 'ATM withdrawal'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit',  340.00, '2023-04-07', 'Grocery shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit', 1300.00, '2023-04-15', 'Salary deposit'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 300.00, '2023-04-16', 'Gift deposit'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 340.00, '2023-04-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 130.00, '2023-04-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 310.00, '2023-04-29', 'Online shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 350.00, '2023-04-30', 'Freelance payment'),

    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1203.00, '2023-04-03', 'ATM withdrawal'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit',  154.00, '2023-04-07', 'Grocery shopping'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit', 508.00, '2023-04-15', 'Salary deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 708.00, '2023-04-16', 'Gift deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-04-29', 'Online shopping'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-04-30', 'Freelance payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 106.00, '2023-04-05', 'Groceries Payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 250.00, '2023-04-10', 'Salary Deposit'),
    -- May
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 220.00, '2023-05-03', 'ATM withdrawal'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit',  1110.00, '2023-05-07', 'Grocery shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit', 230.00, '2023-05-15', 'Salary deposit'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 340.00, '2023-05-16', 'Gift deposit'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 120.00, '2023-05-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 120.00, '2023-05-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 55.00, '2023-05-29', 'Online shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 830.00, '2023-05-30', 'Freelance payment'),

    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1203.00, '2023-05-03', 'ATM withdrawal'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit',  154.00, '2023-05-07', 'Grocery shopping'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit', 508.00, '2023-05-15', 'Salary deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 708.00, '2023-05-16', 'Gift deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-05-29', 'Online shopping'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-05-30', 'Freelance payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 106.00, '2023-05-05', 'Groceries Payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 250.00, '2023-05-10', 'Salary Deposit'),
    -- June
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 207.00, '2023-06-03', 'ATM withdrawal'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit',  1157.00, '2023-06-07', 'Grocery shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit', 506.00, '2023-06-15', 'Salary deposit'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 750.00, '2023-06-16', 'Gift deposit'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 200.00, '2023-06-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 200.00, '2023-06-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 54.00, '2023-06-29', 'Online shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 803.00, '2023-06-30', 'Freelance payment'),

    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1203.00, '2023-06-03', 'ATM withdrawal'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit',  154.00, '2023-06-07', 'Grocery shopping'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit', 508.00, '2023-06-15', 'Salary deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 708.00, '2023-06-16', 'Gift deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-06-29', 'Online shopping'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-06-30', 'Freelance payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 106.00, '2023-06-05', 'Groceries Payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 250.00, '2023-06-10', 'Salary Deposit'),
    -- July
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 1200.00, '2023-07-03', 'ATM withdrawal'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit',  150.00, '2023-07-07', 'Grocery shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit', 300.00, '2023-07-15', 'Salary deposit'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1700.00, '2023-07-16', 'Gift deposit'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 400.00, '2023-07-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 200.00, '2023-07-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 150.00, '2023-07-29', 'Online shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1800.00, '2023-07-30', 'Freelance payment'),

    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1203.00, '2023-07-03', 'ATM withdrawal'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit',  154.00, '2023-07-07', 'Grocery shopping'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit', 508.00, '2023-07-15', 'Salary deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 708.00, '2023-07-16', 'Gift deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-07-29', 'Online shopping'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-07-30', 'Freelance payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 106.00, '2023-07-05', 'Groceries Payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 250.00, '2023-07-10', 'Salary Deposit'),
    -- August
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 1204.00, '2023-08-03', 'ATM withdrawal'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit',  50.00, '2023-08-07', 'Grocery shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit', 100.00, '2023-08-15', 'Salary deposit'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 900.00, '2023-08-16', 'Gift deposit'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 500.00, '2023-08-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 50.00, '2023-08-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 150.00, '2023-08-29', 'Online shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 400.00, '2023-08-30', 'Freelance payment'),

    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1203.00, '2023-08-03', 'ATM withdrawal'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit',  154.00, '2023-08-07', 'Grocery shopping'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit', 508.00, '2023-08-15', 'Salary deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 708.00, '2023-08-16', 'Gift deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-08-29', 'Online shopping'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-08-30', 'Freelance payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 106.00, '2023-08-05', 'Groceries Payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 250.00, '2023-08-10', 'Salary Deposit'),
    -- September
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 1100.00, '2023-09-03', 'ATM withdrawal'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit',  160.00, '2023-09-07', 'Grocery shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit', 400.00, '2023-09-15', 'Salary deposit'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 600.00, '2023-09-16', 'Gift deposit'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 60.00, '2023-09-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 50.00, '2023-09-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 30.00, '2023-09-29', 'Online shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 200.00, '2023-09-30', 'Freelance payment'),

    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1203.00, '2023-09-03', 'ATM withdrawal'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit',  154.00, '2023-09-07', 'Grocery shopping'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit', 508.00, '2023-09-15', 'Salary deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 708.00, '2023-09-16', 'Gift deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-09-29', 'Online shopping'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-09-30', 'Freelance payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 106.00, '2023-09-05', 'Groceries Payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 250.00, '2023-09-10', 'Salary Deposit'),
    -- October
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 1200.00, '2023-10-03', 'ATM withdrawal'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit',  150.00, '2023-10-07', 'Grocery shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit', 100.00, '2023-10-15', 'Salary deposit'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 400.00, '2023-10-16', 'Gift deposit'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 90.00, '2023-10-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 10.00, '2023-10-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 50.00, '2023-10-29', 'Online shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 800.00, '2023-10-30', 'Freelance payment'),

    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1203.00, '2023-10-03', 'ATM withdrawal'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit',  154.00, '2023-10-07', 'Grocery shopping'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit', 508.00, '2023-10-15', 'Salary deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 708.00, '2023-10-16', 'Gift deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-10-29', 'Online shopping'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-10-30', 'Freelance payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 106.00, '2023-10-05', 'Groceries Payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 250.00, '2023-10-10', 'Salary Deposit'),
    -- November
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 950.00, '2023-11-03', 'ATM withdrawal'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit',  250.00, '2023-11-07', 'Grocery shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit', 200.00, '2023-11-15', 'Salary deposit'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 320.00, '2023-11-16', 'Gift deposit'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 30.00, '2023-11-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),'Transfer', 10.00, '2023-11-20', 'Transfer to SAVINGS'),
    (uuid_generate_v4(),(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 150.00, '2023-11-29', 'Online shopping'),
    (uuid_generate_v4(), NULL, (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 900.00, '2023-11-30', 'Freelance payment'),

    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 1203.00, '2023-11-03', 'ATM withdrawal'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), 'Credit',  154.00, '2023-11-07', 'Grocery shopping'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'alicew')), NULL, 'Debit', 508.00, '2023-11-15', 'Salary deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), NULL, 'Debit', 708.00, '2023-11-16', 'Gift deposit'),
    (uuid_generate_v4(), (SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')),NULL, 'Debit', 59.00, '2023-11-29', 'Online shopping'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 809.00, '2023-11-30', 'Freelance payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'CURRENT' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 106.00, '2023-11-05', 'Groceries Payment'),
    (uuid_generate_v4(), NULL,(SELECT account_id FROM Accounts WHERE account_type = 'SAVINGS' AND user_id = (SELECT user_id FROM Users WHERE username = 'johncena')), 'Credit', 250.00, '2023-11-10', 'Salary Deposit');

