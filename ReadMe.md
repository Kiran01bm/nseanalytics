## General Notes
This is a simple linear regression is a linear regression model with a single explanatory variable.

## Intention
Compute the Slope and Intercepts for the Price movement of NSE listed stocks for a configurable duration. ex: Week, Month, Year or an arbitrary date range.

## Structure - Key Components
1. ROOT/data         - NSE Bhav Data downloaded for a given Time Duration.
2. ROOT/database     - PostgreSQL RDBMS where the data from NSE is loaded.
3. ROOT/app          - Java App that does the Linear Regression Modelling.
4. ROOT/dataarchive  - Sample data from Test runs.

## NSE Series Defintions
```
EQ: It stands for Equity. In this series intraday trading is possible in addition to delivery.

BE: It stands for Book Entry. Shares falling in the Trade-to-Trade or T-segment are traded in this series and no intraday is allowed. This means trades can only be settled by accepting or giving the delivery of shares.

BL: This series is for facilitating block deals. Block deal is a trade, with a minimum quantity of 5 lakh shares or minimum value of Rs. 5 crore, executed through a single transaction, on the special “Block Deal window”. The window is opened for only 35 minutes in the morning from 9:15 to 9:50AM.

BT: This series provides an exit route to small investors having shares in the physical form with a cap of maximum 500 shares.

BZ : companies who fail to be complaint
```


