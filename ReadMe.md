## General Notes
This is a simple linear regression is a linear regression model with a single explanatory variable.

## Intention
Compute the Slope and Intercepts for the Price movement of NSE listed stocks for a configurable duration. ex: Week, Month, Year or an arbitrary date range.

## Structure - Key Components
1. ROOT/data         - NSE Bhav Data downloaded for a given Time Duration.
2. ROOT/database     - PostgreSQL RDBMS where the data from NSE is loaded.
3. ROOT/app          - Java App that does the Linear Regression Modelling.
4. ROOT/dataarchive  - Sample data from Test runs.
