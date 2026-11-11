-- ============================================================================
-- CSE 111 Fall 2026: Project Checkpoint 2 Script
-- Project Title: [Insert Project Title Here]
-- Team Members: [Adrian Ortizj Jr], [Jon Taylor]
-- File: Checkpoint2-script.sql
-- ============================================================================

-- ============================================================================
-- SCHEMA MODIFICATIONS SINCE CHECKPOINT 1
-- ============================================================================
-- Explain any modifications to your relational schema made since Checkpoint 1.
-- (e.g., added indexes, modified check constraints, renamed columns, or 
--  clarified weak entity vs. junction relationships). If no changes were made, 
--  explicitly state: "No modifications made to the Checkpoint 1 schema."
--
-- Modifications:
-- 1. [Description of schema modification 1, or None]
-- 2. [Description of schema modification 2]
-- ============================================================================

-- ============================================================================
-- MEMBER CONTRIBUTIONS SUMMARY (GROUPED AT THE TOP)
-- ============================================================================
-- Identify the member contributions to each query or modification statement
-- below. Each statement must sum to 100% across the 2 team members.
--
-- SECTION 1: SIMPLE STATEMENTS
-- Statement 01: [Adrian Ortiz Jr]: 100%, [Jon Taylor]: 0%
-- Statement 02: [Member 1]: XX%, [Member 2]: XX%
-- Statement 03: [Member 1]: XX%, [Member 2]: XX%
-- Statement 04: [Member 1]: XX%, [Member 2]: XX%
-- Statement 05: [Member 1]: XX%, [Member 2]: XX%
-- Statement 06: [Member 1]: XX%, [Member 2]: XX%
-- Statement 07: [Member 1]: XX%, [Member 2]: XX%
-- Statement 08: [Member 1]: XX%, [Member 2]: XX%
-- Statement 09: [Member 1]: XX%, [Member 2]: XX%
-- Statement 10: [Member 1]: XX%, [Member 2]: XX%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: [Member 1]: XX%, [Member 2]: XX%
-- Statement 12: [Member 1]: XX%, [Member 2]: XX%
-- Statement 13: [Member 1]: XX%, [Member 2]: XX%
-- Statement 14: [Member 1]: XX%, [Member 2]: XX%
-- Statement 15: [Member 1]: XX%, [Member 2]: XX%
-- Statement 16: [Member 1]: XX%, [Member 2]: XX%
-- Statement 17: [Member 1]: XX%, [Member 2]: XX%
-- Statement 18: [Member 1]: XX%, [Member 2]: XX%
-- Statement 19: [Member 1]: XX%, [Member 2]: XX%
-- Statement 20: [Member 1]: XX%, [Member 2]: XX%
-- Statement 21: [Member 1]: XX%, [Member 2]: XX%
--
-- SECTION 3: COMPLEX STATEMENTS
-- Statement 22: [Member 1]: XX%, [Member 2]: XX%
-- Statement 23: [Member 1]: XX%, [Member 2]: XX%
-- Statement 24: [Member 1]: XX%, [Member 2]: XX%
-- Statement 25: [Member 1]: XX%, [Member 2]: XX%
-- Statement 26: [Member 1]: XX%, [Member 2]: XX%
-- Statement 27: [Member 1]: XX%, [Member 2]: XX%
-- Statement 28: [Member 1]: XX%, [Member 2]: XX%
-- Statement 29: [Member 1]: XX%, [Member 2]: XX%
-- Statement 30: [Member 1]: XX%, [Member 2]: XX%
-- Statement 31: [Member 1]: XX%, [Member 2]: XX%
-- Statement 32: [Member 1]: XX%, [Member 2]: XX%
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
-- Explanation: Insert a new order in orders
-- ----------------------------------------------------------------------------
INSERT INTO orders (order_id, order_type, quantity, price, status, user_id, ticker) 
VALUES (7, 'BUY', 10, 750.00, 'EXECUTED', 1, 'GOOGL');

-- ----------------------------------------------------------------------------
-- Statement 04: Insert New Transaction
-- Explanation: Insert a new transaction record that was made 
-- ----------------------------------------------------------------------------
INSERT INTO transactions (transaction_id, quantity, price, cost_basis, order_id, ticker) 
VALUES (5, 10, 750.00, 7500.00, 7, 'GOOGL');

-- ----------------------------------------------------------------------------
-- Statement 05: Insert New Holding
-- Explanation: Insert a new holding in holdings requires an order and
--              transaction to occure. Previous insert statements make
--              this insert valid. We also specific which portfolio that
--              it belongs too.
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
SELECT watchlists.watchlist_id, watchlists.list_name
FROM watchlists

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
-- Statement 11: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the join logic, filtering, 
--              or conditional modification].
-- ----------------------------------------------------------------------------
SELECT users.name, orders.order_type, orders.ticker
FROM users
JOIN orders ON users.user_id = orders.user_id
ORDER BY users.name;

-- Statement 12: List Users and Their portfolios
--               Explanation: This query retrieves a list of all users 
--               alognside the names of the investment portfolios they own. 
--               It does this by joinin the users and portfolios tables 
--               using their shared user_id to link each person to their 
--               specific accounts.
-- ----------------------------------------------------------------------------
SELECT users.name, portfolios.portfolio_name
FROM users
JOIN portfolios ON users.user_id = portfolios.user_id;


-- ============================================================================
-- SECTION 3: COMPLEX STATEMENTS (Roughly 10 Statements)
-- Focus: Correlated subqueries (EXISTS/NOT EXISTS), set operations 
--        (UNION, INTERSECT, EXCEPT), Common Table Expressions (WITH / CTEs), 
--        window functions (ROW_NUMBER, DENSE_RANK), VIEW creation/querying, 
--        multi-condition triggers, and complex analytics.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 22: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the complex query/trigger logic].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 22 Here];

-- [Continue Statements 23 through 32...]
