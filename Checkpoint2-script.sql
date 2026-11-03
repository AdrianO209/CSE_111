DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS portfolios;
DROP TABLE IF EXISTS stocks;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS watchlists;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS holdings;
DROP TABLE IF EXISTS watchlistItems;

-- Creating tables

CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  cash_balance DECIMAL(12,2) NOT NULL DEFAULT 0.0 CHECK (cash_balance >= 0.0)
);


CREATE TABLE portfolios (
  portfolio_id INTEGER PRIMARY KEY,
  portfolio_name VARCHAR(100) NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE stocks (
  ticker VARCHAR(10) PRIMARY KEY,
  company_name VARCHAR(150) NOT NULL,
  sector VARCHAR(50)
);

CREATE TABLE orders (
  order_id INTEGER PRIMARY KEY,
  order_type VARCHAR(4) NOT NULL CHECK (order_type('BUY', 'SELL')),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  price DECIMAL(10, 2) NOT NULL CHECK (PRICE >= 0),
  status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  user_id INTEGER NOT NULL,
  ticker VARCHAR(10) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (ticker) REFERENCES stocks(ticker) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE watchlists(
  watchlist_id INTEGER PRIMARY KEY,
  list_name VARCHAR(100) NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES user(user_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE transactions (
  transaction_id INTEGER PRIMARY KEY,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0.0),
  executed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  cost_basis DECIMAL(12, 2) NOT NULL CHECK (cost_basis >= 0.0),
  order_id INTEGER NOT NULL,
  ticker VARCHAR(10) NOT NULL,
  FOREIGN KEY(order_id) REFERENCES order(order_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (ticker) REFERENCES stocks(ticker) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE holdings(
  portfolio_id INTEGER NOT NULL,
  ticker VARCHAR(10) NOT NULL,
  shares_owned DECIMAL(12, 4) NOT NULL DEFAULT 0 CHECK (shares_owned >= 0),
  average_purchase_price DECIMAL(10, 2) NOT NULL CHECK (average_purchase_price >= 0.0),
  PRIMARY KEY (portfolio_id, ticker),
  FOREIGN KEY (portfolio_id) REFERENCES portfolios(portfolio_id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (ticker) REFERENCES stocks(ticker) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE watchlist_items(
  watchlist_id INTEGER NOT NULL,
  ticker VARCHAR(10) NOT NULL,
  date_added DATE,
  PRIMARY KEY (watchlist_id, ticker),
  FOREIGN KEY (watchlist_id) REFERENCES watchlists(watchlist_id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (ticker) REFERENCES stocks(ticker) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- INSERT DATA

INSERT INTO users (user_id, name, cash_balance) VALUES
(1, 'Alice Johnson', 10000.00),
(2, 'Bob Smith',       7500.50),
(3, 'Carol White',    12500.00),
(4, 'David Lee',       5000.00);

INSERT INTO portfolios (portfolio_id, portfolio_name, user_id) VALUES
(1, 'Alice Main Portfolio',      1),
(2, 'Alice Tech Growth',         1),
(3, 'Bob Retirement Fund',         2),
(4, 'Carol Growth Portfolio',    3),
(5, 'David Starter Portfolio',   4);

INSERT INTO stocks (ticker, company_name, sector) VALUES
('AAPL', 'Apple Inc.', 'Technology'),
('MSFT', 'Microsoft Corporation', 'Technology'),
('GOOGL', 'Alphabet Inc.', 'Communication Services'),
('AMZN', 'Amazon.com Inc.', 'Consumer Discretionary'),
('TSLA', 'Tesla Inc.', 'Consumer Discretionary'),
('JPM', 'JPMorgan Chase & Co.', 'Financials'),
('NVDA', 'NVIDIA Corporation', 'Technology'),
('JNJ', 'Johnson & Johnson', 'Healthcare'),
('XOM', 'Exxon Mobil Corporation', 'Energy'),
('WMT', 'Walmart Inc.', 'Consumer Staples');

INSERT INTO orders (order_id, order_type, quantity, price, status, created_at, user_id, ticker) VALUES
(1, 'BUY', 10, 225.50, 'EXECUTED', '2026-10-15 09:30:00', 1, 'AAPL'),
(2, 'BUY', 5, 420.00, 'EXECUTED', '2026-10-16 10:15:00', 1, 'MSFT'),
(3, 'SELL', 3, 780.25, 'EXECUTED', '2026-10-20 14:45:00', 2, 'GOOGL'),
(4, 'BUY', 8, 195.75, 'PENDING',  '2026-10-28 11:00:00', 3, 'NVDA'),
(5, 'BUY', 15, 85.40, 'EXECUTED', '2026-10-18 13:20:00', 2, 'JPM'),
(6, 'SELL', 4, 310.00, 'CANCELLED','2026-10-25 16:00:00', 1, 'TSLA');

INSERT INTO watchlists (watchlist_id, list_name, user_id) VALUES
(1, 'Tech Favorites', 1),
(2, 'Dividend Picks', 2),
(3, 'Growth Watch',   3);

INSERT INTO watchlistItems (watchlist_id, ticker, date_added) VALUES
(1, 'AAPL', '2026-10-01'),
(1, 'MSFT', '2026-10-05'),
(1, 'NVDA', '2026-10-12'),
(2, 'JPM', '2026-10-03'),
(2, 'JNJ', '2026-10-08'),
(3, 'TSLA', '2026-10-15'),
(3, 'AMZN', '2026-10-20');

INSERT INTO orders (order_id, order_type, quantity, price, status, created_at, user_id, ticker) VALUES
(1, 'BUY',  10, 225.50, 'EXECUTED',  '2026-10-15 09:30:00', 1, 'AAPL'),
(2, 'BUY',   5, 420.00, 'EXECUTED',  '2026-10-16 10:15:00', 1, 'MSFT'),
(3, 'SELL',  3, 780.25, 'EXECUTED',  '2026-10-20 14:45:00', 2, 'GOOGL'),
(4, 'BUY',   8, 195.75, 'PENDING',   '2026-10-28 11:00:00', 3, 'NVDA'),
(5, 'BUY',  15,  85.40, 'EXECUTED',  '2026-10-18 13:20:00', 2, 'JPM'),
(6, 'SELL',  4, 310.00, 'CANCELLED', '2026-10-25 16:00:00', 1, 'TSLA');

INSERT INTO holdings (portfolio_id, ticker, shares_owned, average_purchase_price) VALUES
(1, 'AAPL',  10.0000, 225.50),
(1, 'MSFT',   5.0000, 420.00),
(3, 'GOOGL',  7.0000, 775.00),
(3, 'JPM',   15.0000,  85.40),
(2, 'NVDA',   8.0000, 190.00);

INSERT INTO transactions (transaction_id, quantity, price, executed_at, cost_basis, order_id, ticker) VALUES
(1, 10, 225.50, '2026-10-15 09:31:00', 2255.00, 1, 'AAPL'),
(2, 5, 420.00, '2026-10-16 10:16:00', 2100.00, 2, 'MSFT'),
(3, 3, 780.25, '2026-10-20 14:46:00', 2340.75, 3, 'GOOGL'),
(4, 15, 85.40, '2026-10-18 13:21:00', 1281.00, 5, 'JPM');
