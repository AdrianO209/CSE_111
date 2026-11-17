-- ============================================================================
-- CSE 111 Fall 2026: Project Checkpoint 2 Script
-- Project Title: StoqX
-- Team Members: [Adrian Ortiz Jr], [Jon Taylor]
-- File: Checkpoint2-script.sql
-- ============================================================================

-- ============================================================================
-- SCHEMA MODIFICATIONS SINCE CHECKPOINT 1
-- ============================================================================
-- 1. No modifications made to the Checkpoint 1 schema
-- ============================================================================

-- ============================================================================
-- MEMBER CONTRIBUTIONS SUMMARY (GROUPED AT THE TOP)
-- ============================================================================
-- Identify the member contributions to each query or modification statement
-- below. Each statement must sum to 100% across the 2 team members.
--
-- SECTION 1: SIMPLE STATEMENTS
-- Statement 01: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 02: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 03: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 04: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 05: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 06: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 07: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 08: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 09: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 10: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 12: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 13: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 14: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 15: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 16: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 17: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 18: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 19: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 20: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 21: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
--
-- SECTION 3: COMPLEX STATEMENTS
-- Statement 22: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 23: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 24: [Adrian Ortiz Jr]: 100%, [Jon Taylor ]: 0%
-- Statement 25: [Adrian Ortiz Jr]: 100%, [Jon Taylor`]: 0%
-- Statement 26: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 27: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 28: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 29: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 1000%
-- Statement 30: [Adrian Ortiz Jr]: 0%, [Jon Taylor]: 100%
-- Statement 31: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 32: [Adrian Ortiz Jr]: 75%, [Jon Taylor]: 25%
-- ============================================================================

-- Ensure SQLite foreign key constraints are enforced
PRAGMA foreign_keys = ON;

-- Set output format for readability during evaluation
.headers on
.mode column

-- ============================================================================
-- SECTION 1: SIMPLE STATEMENTS (Roughly 10 Statements)
-- Focus: Single-table projections/filters, simple inserts/updates/deletes, 
--        basic sorting, simple aggregate functions, and pattern matching.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 01: List All Users
-- Explanation: This query projects a single column from the users table
--              to list all register account names. We uses an alias of
--              'Users' for cleaner output.
-- ----------------------------------------------------------------------------
SELECT users.name AS Users
FROM users;

-- ----------------------------------------------------------------------------
-- Statement 02: All transactions with a cost basis bigger than $2,000
-- Explanation: Retrives the ticker and with the transaction amount
--              bigger than 2000.
-- ----------------------------------------------------------------------------
SELECT transactions.ticker AS ticker,
  transactions.cost_basis AS cost_basis
FROM transactions
WHERE transactions.cost_basis > 2000;

-- ----------------------------------------------------------------------------
-- Statement 03: Insert New Order
-- Explanation: Insert a new order in orders.
-- ----------------------------------------------------------------------------
INSERT INTO orders (order_id, order_type, quantity, price, status, user_id, ticker) 
VALUES (7, 'BUY', 10, 750.00, 'EXECUTED', 1, 'GOOGL');

-- ----------------------------------------------------------------------------
-- Statement 04: Insert New Transaction
-- Explanation: Insert a new transaction record that was made.
-- ----------------------------------------------------------------------------
INSERT INTO transactions (transaction_id, quantity, price, cost_basis, order_id, ticker) 
VALUES (5, 10, 750.00, 7500.00, 7, 'GOOGL');

-- ----------------------------------------------------------------------------
-- Statement 05: Insert New Holding
-- Explanation: Insert a new holding in holdings requires an order and
--              transaction to occure. Previous insert statements make
--              this insert valid. We also specific which portfolio that
--              it belongs too. Also note that user 1 never had a GOOGL holding,
--              therefore it did not had a previous average purchase price.
-- ----------------------------------------------------------------------------
INSERT INTO holdings (portfolio_id, ticker, shares_owned, average_purchase_price) 
VALUES (1, 'GOOGL', 10.0000, 750.00);

-- ----------------------------------------------------------------------------
-- Statement 06: Total Shares Of Each Portfolio
-- Explanation: Finds the total amount of shares each portfolio
--               currently owns.
-- ----------------------------------------------------------------------------
SELECT holdings.portfolio_id,
  SUM(holdings.shares_owned) AS shares_owned
FROM holdings
GROUP BY holdings.portfolio_id;

-- ----------------------------------------------------------------------------
-- Statement 07: Highest Transaction Cost
-- Explanation: Finds the high cost-basis (the total amount of money spend 
--              in dollars for that transaction)
-- ----------------------------------------------------------------------------
SELECT transactions.ticker,
  transactions.executed_at,
  transactions.cost_basis AS highest_transaction_cost
FROM transactions
ORDER BY cost_basis DESC
LIMIT 1;

-- ----------------------------------------------------------------------------
-- Statement 08: Adding New User
-- Explanation: Inserting a new user name Jacob Davis with a cash_balance of
--              $11000.
-- ----------------------------------------------------------------------------
INSERT INTO users (user_id, name, cash_balance)
VALUES (5, 'Jacob Davis', 11000);

-- ----------------------------------------------------------------------------
-- Statement 09: Current Watchlists
-- Explanation: This prints out all the watchlists currently created.
-- ----------------------------------------------------------------------------
SELECT watchlists.watchlist_id,
  watchlists.list_name
FROM watchlists;

-- ----------------------------------------------------------------------------
-- Statement 10: Stocks That Are In A Watchlist
-- Explanation: List all the stocks that are being watched by a watchlist 
--              and is ordered by the data added from most recent to oldest.
-- ----------------------------------------------------------------------------
SELECT *
FROM watchlist_items
ORDER BY watchlist_items.date_added DESC;


-- ============================================================================
-- SECTION 2: INTERMEDIATE STATEMENTS (Roughly 10 Statements)
-- Focus: Multi-table inner joins, left outer joins, aggregation with GROUP BY 
--        and HAVING, scalar subqueries, table aliasing, and conditional updates.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 11: Users Trading Activity
-- Explanation: This query retries all the trading activity all users have done,
--              which includes the order type and what ticker did they buy/sell.
-- ----------------------------------------------------------------------------
SELECT users.name,
  orders.order_type,
  orders.ticker
FROM users
JOIN orders ON users.user_id = orders.user_id
ORDER BY users.name;

-- Statement 12: List Users and Their portfolios
-- Explanation: This query retrieves a list of all users 
--              alognside the names of the investment portfolios they own. 
--              It does this by joinin the users and portfolios tables 
--              using their shared user_id to link each person to their 
--              specific accounts.
-- ----------------------------------------------------------------------------
SELECT users.name, 
  portfolios.portfolio_name
FROM users
JOIN portfolios ON users.user_id = portfolios.user_id;

-- ----------------------------------------------------------------------------
-- Statement 13: All Transactions Cost
-- Explanation: This query retrieves all the transactions that happened and
--              attaches the name to who each transaction belongs to.
-- ----------------------------------------------------------------------------
SELECT users.name, 
  transactions.cost_basis AS cost_basis_inDollars, 
  transactions.ticker
FROM users 
JOIN orders ON orders.user_id = users.user_id
JOIN transactions ON transactions.order_id = orders.order_id;

-- ----------------------------------------------------------------------------
-- Statement 14: Total Amount of Transaction Cost
-- Explanation: This query retrieves the total amount of money each user spend
--              by summing up all the transaction cost basis for all the
--              transactions that did.
-- ----------------------------------------------------------------------------
SELECT users.name,
  SUM(transactions.cost_basis) AS total_transaction_cost
FROM users
JOIN orders ON orders.user_id = users.user_id
JOIN transactions ON transactions.order_id = orders.order_id
GROUP BY users.name;

-- ----------------------------------------------------------------------------
-- Statement 15: Who Has A Watchlist
-- Explanation: This query retrieves all the watchlist name current created and
--              who does it belong to.
-- ----------------------------------------------------------------------------
SELECT users.name,
  watchlists.list_name AS watchlist_name
FROM users
JOIN watchlists ON watchlists.user_id = users.user_id
ORDER BY users.name ASC;

-- ----------------------------------------------------------------------------
-- Statement 16: Watchlist Tickers
-- Explanation: This query does the same thing as statement 15, but adds
--              watchlist items. Last statement query matched all watchlist
--              name with there appropriate names of who they belong to.
--              This query goes further by printing out all the tickers, which
--              is in a watchlist and prints the name of the user, the watchlist
--              name, and the ticker that is in that watchlist.
-- ----------------------------------------------------------------------------
SELECT users.name,
  watchlists.list_name AS watchlist_name,
  watchlist_items.ticker
FROM users
JOIN watchlists ON watchlists.user_id = users.user_id
JOIN watchlist_items ON watchlist_items.watchlist_id = watchlists.watchlist_id
ORDER BY users.name ASC;

-- ----------------------------------------------------------------------------
-- Statement 17: Users Who Have Not Placed Any Orders
-- Explanation: This query uses the NOT IN statement to find all the users who 
--              does not have any orders.
-- ------------------------------------------------------------------------ ----
SELECT users.name
FROM users
WHERE user_id NOT IN (
  SELECT user_id 
  FROM orders
);

-- ----------------------------------------------------------------------------
-- Statement 18: Cancelled Or Pending Orders
-- Explanation: This query retrieves all the orders who have a PENDING or
--              CANCELLED status, and returns the names who those orders
--              belong to.
-- ----------------------------------------------------------------------------
SELECT users.name,
  orders.status,
  orders.ticker
FROM orders
JOIN users ON users.user_id = orders.user_id 
WHERE orders.status = 'PENDING' OR orders.status = 'CANCELLED';

-- ----------------------------------------------------------------------------
-- Statement 19: All Executed Orders
-- Explanation: This is similar to statement 18 but this query retrieves all 
--              the orders, which have a status of EXECUTED and the name who
--              those orders belong to.
-- ----------------------------------------------------------------------------
SELECT users.name, 
  orders.status, 
  orders.ticker
FROM orders
JOIN users ON users.user_id = orders.user_id
WHERE orders.status = 'EXECUTED';

-- ----------------------------------------------------------------------------
-- Statement 20: Finding All tickers of a Watchlist
-- Explanation: This query prints out the watchlist name and all the tickers
--              that the watchlist is looking at.
-- ----------------------------------------------------------------------------
SELECT watchlists.list_name,
  watchlist_items.ticker
FROM watchlists
JOIN watchlist_items ON watchlist_items.watchlist_id = watchlists.watchlist_id
WHERE watchlists.watchlist_id= 2;


-- ============================================================================
-- SECTION 3: COMPLEX STATEMENTS (Roughly 10 Statements)
-- Focus: Correlated subqueries (EXISTS/NOT EXISTS), set operations 
--        (UNION, INTERSECT, EXCEPT), Common Table Expressions (WITH / CTEs), 
--        window functions (ROW_NUMBER, DENSE_RANK), VIEW creation/querying, 
--        multi-condition triggers, and complex analytics.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 21: View Creation For Users Orders
-- Explanation: Creates a view that connections each order to a user.
-- ----------------------------------------------------------------------------
CREATE VIEW view_usersOrders AS
SELECT users.name,
  users.user_id,
  orders.order_type,
  orders.quantity,
  orders.price,
  orders.status,
  orders.created_at,
  orders.ticker
FROM users
JOIN orders ON orders.user_id = users.user_id;

-- ----------------------------------------------------------------------------
-- Statement 22: User Full Trading Activity
-- Explanation: Statement 11 is similar but this query gets the user_id and
--              prints out the order status and the usage of a view.
-- ----------------------------------------------------------------------------
SELECT name,
  order_type, 
  status,
  ticker
FROM view_usersOrders
WHERE user_id = 1;

-- ----------------------------------------------------------------------------
-- Statement 23:  Users Who Have Bough & Sold
-- Explanation: We find the user id and the user name who placed both buy and
--              sell orders.
-- ----------------------------------------------------------------------------
SELECT user_id, name
FROM view_usersOrders
WHERE LOWER(order_type) = 'buy'

INTERSECT

SELECT user_id, name
FROM view_usersOrders
WHERE LOWER(order_type) = 'sell';

-- ----------------------------------------------------------------------------
-- Statement 24: User Holding View Creation
-- Explanation: Creates a view that connects all the users to there holdings
--              and portfolios.
-- ----------------------------------------------------------------------------
CREATE VIEW view_user_holdings AS
SELECT 
  users.user_id,
  users.name AS user_name,
  portfolios.portfolio_id,
  portfolios.portfolio_name,
  holdings.ticker,
  stocks.company_name,
  holdings.shares_owned,
  holdings.average_purchase_price
FROM users
JOIN portfolios ON users.user_id = portfolios.user_id
JOIN holdings ON portfolios.portfolio_id = holdings.portfolio_id
JOIN stocks ON holdings.ticker = stocks.ticker;

-- ----------------------------------------------------------------------------
-- Statement 25: Alice (user_id = 1) Stocks and Watchlist Stocks
-- Explanation: This query retrieves what stocks does Alice owns and which
--              stocks that she has on any of her watchlist.
-- ----------------------------------------------------------------------------
SELECT ticker, 'Currently Owned' AS relationship
FROM view_user_holdings
WHERE user_id = 1

UNION

SELECT watchlist_items.ticker, 'On Watchlist' AS relationship
FROM watchlist_items
JOIN watchlists ON watchlist_items.watchlist_id = watchlists.watchlist_id
WHERE watchlists.user_id = 1;

-- ----------------------------------------------------------------------------
-- Statement 26: Bob Smith Shopping List
-- Explanation: This query is the similar to query from statement 25, but rather than
--              using union, we use EXCEPT to find stocks that Bob have on
--              his watchlist but currently does not own. We also take the ticker
--              from the watchlist first and then take the difference to Bob
--              ticker holdings.
-- ----------------------------------------------------------------------------
SELECT watchlist_items.ticker
FROM watchlist_items
JOIN watchlists ON watchlist_items.watchlist_id = watchlists.watchlist_id
WHERE watchlists.user_id = 2

EXCEPT

SELECT ticker
FROM view_user_holdings
WHERE user_id = 2;



-- ----------------------------------------------------------------------------
-- Statement 27: Sectors Exposure 
-- Explanation: This query retrieves the user name and the number of distinct
--              sectors that there stocks are considered. This also indicates
--              which users have an active portfolios.
-- ----------------------------------------------------------------------------
SELECT users.name,
  COUNT(DISTINCT stocks.sector) AS distinct_sectors_owned
FROM users
JOIN portfolios ON portfolios.user_id = users.user_id
JOIN holdings ON holdings.portfolio_id = portfolios.portfolio_id
JOIN stocks ON stocks.ticker = holdings.ticker
GROUP BY users.user_id, users.name;

-- ----------------------------------------------------------------------------
-- Statement 28: Most Recent Orders
-- Explanation: This query reterives the most recent orders for each user who
--              had a order in the first place. It does this by combining the 
--              users relation to orders relation by the user_id attribute.
--              Then we only select the rows that are equal to the sub query
--              result, which in this case would be the most recent orders.
-- ----------------------------------------------------------------------------
SELECT users.name,
  orders.ticker,
  orders.order_type,
  orders.status,
  orders.created_at
FROM users
JOIN orders ON orders.user_id = users.user_id
WHERE orders.created_at = (
  SELECT MAX(created_at)
  FROM orders AS sub_orders
  WHERE sub_orders.user_id = orders.user_id
);

-- ----------------------------------------------------------------------------
-- Statement 29: Total Investment Capital
-- Explanation: This query takes the sum of user shares owned times average 
--              purchase price to find the total amount invested in dollars.
--              We order it by total investment captial for each user in
--              descending order.
-- ----------------------------------------------------------------------------
SELECT users.name,
  portfolios.portfolio_name,
  SUM(holdings.shares_owned * holdings.average_purchase_price) AS total_investment_capital
FROM users
JOIN portfolios ON portfolios.user_id = users.user_id
JOIN holdings ON holdings.portfolio_id = portfolios.portfolio_id
GROUP BY users.name, portfolios.portfolio_name
ORDER BY total_investment_capital DESC;

-- ----------------------------------------------------------------------------
-- Statement 30: Unwanted Stocks
-- Explanation: This query retrieves all the stocks which currently no users
--              hold. In other words, it prints out the ticker, company name,
--              and sectors of each stock which currently is not in any users 
--              portfolios.
-- ----------------------------------------------------------------------------
SELECT ticker,
  company_name,
  sector
FROM stocks
WHERE NOT EXISTS (
  SELECT 1
  FROM holdings 
  WHERE holdings.ticker = stocks.ticker
);
