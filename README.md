# Transaction Ledger
A transaction ledger, storing transactions against an account allowing users to request their balance at any
point in time — past, present, or future.

## Setup
### Project build
To build the project run `./gradlew build` (Mac/Linux) and `gradle build` (Windows).

### Database 
Run the database instance from docker compose, such as `docker-compose up -d`

#### Schema 
The application database is called `ledger` and has the following tables
`Users`
`Accounts`
`Transactions`

The relationship between them is one-to-many, so a User can have one or more Accounts and an Account can have one or more Transactions.

#### Populated data
Some test DB data should be populated automatically upon spinning up the Database Container on the `ledger` database.

You can use account `9223a802-d334-40f8-8fd0-ea8f5293d7bf` to get current, present and/or future balances. 

Any new accounts have to be added in DB manually at this point (API under Development).

We have three types of transactions:
* Debit - `from_account_id` populated, `to_account_id` NULL
* Credit - `from_account_id` NULL, `to_account_id` populated
* Transfer - both `from_account_id` and `to_account_id`


## Application Run
Run the application from the `TransactionLedgerApplication.java` class either using an IDE 
or via the following command `./gradlew bootRun`

## API Calls
We have the following API calls
`/` - index page

`/balance/{accountId}/current` - returns the current balance for this `accountId`

`/balance/{accountId}?fromDate={date}&toDate={date}` - returns the balance for this `accountId` between `fromDate` and `toDate`. 
Any future date will return a prediction based on a Simple Linear Regresion model.

To test these you can use the following examples:
- `http://localhost:8080/`

- `/balance/9223a802-d334-40f8-8fd0-ea8f5293d7bf/current` - returns the current balance for account with id `9223a802-d334-40f8-8fd0-ea8f5293d7bf`

- `/balance/9223a802-d334-40f8-8fd0-ea8f5293d7bf?fromDate=30/03/2023&toDate=29/12/2024` - returns the balance for account with id `9223a802-d334-40f8-8fd0-ea8f5293d7bf` 
between 2nd of March 2024 til 1st of January 2025. 

### Get balances
The application exposes one API that gets you the current balance of an individual account.

There is also another API that returns all balances within a time period set, which could be past and future.  It has 2 request parameters that define the time range of your search, allowing you to search for current or past balances and even find 
a future balance by making a prediction using a Linear Regression model.

**Example**:

Consider current date is 22nd October 2024.

1. If you pass a time range in the past between 2nd October 2023 - 2nd October 2024, then you will get back the balance for all these months
2. If you pass a time range that is in the future, i.e. 2nd November 2024 - 12 December 2024, then a linear regression model will make predictions and return back the closing balance for the remaing months (see below)
3. If the time range overlaps with current date, i.e. 2nd October 2024 - 12 December 2024 then we will see past balances up to the current date and predicted balances for the remaining time range.

## How predictions work
A linear regression is run against your existing data and can estimate how much the balance will change in the future using basic linear regression. 

It was decided that the results will be more accurate if two models are run, one against total debits and one agains total credits for an account, thus
2 linear regressions can run against future data.

In this case the dependent variable (Y) is the total debit/credit of the month and the independent variable X is the month. After the predicted debits and credits
are computed for each month the closing balance is calculated by subtracting these two.

The linear regression model will first use the last **12 months** of transaction data to populate some data to train the model. 
Then it will run a prediction against these data on how it expects the balance for the next months to go. 

In the end it will return the combined results of all balances falling in the past plus all predicted balances for the future.
