# Transaction Ledger
A transaction ledger, storing transactions against an account allowing users to request their balance at any
point in time—past, present, or future.

## Setup
### Project build
To build the project run `./gradlew build` (Mac/Linux) and `gradle build` (Windows).

### Database 
Run the database instance from docker compose, such as `docker-compose up -d`

### Populate data
Some test DB data should be populated automatically upon spinning up the Database Container.



## Application Run
Run the application from the `TransactionLedgerApplication.java` class either using an IDE or via the following command.

## API Calls
### Get balances
The application exposes a single API that gets you the balance of an individual account using the following `curl`:
`curl -x /balance`...

It has optionally 2 extra parameters that define the time range of your search, allowing you to search for current or past balances and even find 
a future balance by making a prediction using a Linear Regression model.


## How predictions work
A linear regression is run against your existing data and can estimate how much the balance will change in the future using basic linear regression. 

The dependent variable (Y) in this case is the closing balance of the month and the independent variable X is the month