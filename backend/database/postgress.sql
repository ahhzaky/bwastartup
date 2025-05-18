-- Tabel: users
-- DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  occupation VARCHAR(255),
  email VARCHAR(255),
  password_hash VARCHAR(255),
  avatar_file_name VARCHAR(255),
  role VARCHAR(255),
  token VARCHAR(255),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Tabel: campaigns
-- DROP TABLE IF EXISTS campaigns;

CREATE TABLE campaigns (
  id SERIAL PRIMARY KEY,
  user_id INTEGER,
  name VARCHAR(255),
  short_description VARCHAR(255),
  description TEXT,
  perks TEXT,
  backer_count INTEGER,
  goal_amount INTEGER,
  current_amount INTEGER,
  slug VARCHAR(255),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Tabel: campaign_images
-- DROP TABLE IF EXISTS campaign_images;

CREATE TABLE campaign_images (
  id SERIAL PRIMARY KEY,
  campaign_id INTEGER,
  file_name VARCHAR(255),
  is_primary SMALLINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Tabel: transactions
-- DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  campaign_id INTEGER,
  user_id INTEGER,
  amount INTEGER,
  status VARCHAR(255),
  code VARCHAR(255),
  payment_url VARCHAR(255),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
