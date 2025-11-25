-- CatchiMail D1 Database Schema
-- This schema defines the tables for zones, mailboxes, and email messages,
-- enabling persistent storage on Cloudflare D1.
-- Zones table to manage different domains/identities
CREATE TABLE IF NOT EXISTS zones (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  domain TEXT NOT NULL UNIQUE
);
-- Mailboxes table with routing rules, linked to zones
CREATE TABLE IF NOT EXISTS mailboxes (
  id TEXT PRIMARY KEY,
  zone_id TEXT NOT NULL,
  rules JSON NOT NULL DEFAULT '[]',
  FOREIGN KEY (zone_id) REFERENCES zones(id) ON DELETE CASCADE
);
-- Email messages table, the core data of the application
CREATE TABLE IF NOT EXISTS email_messages (
  id TEXT PRIMARY KEY,
  from_address TEXT NOT NULL, -- Renamed from 'from' to avoid SQL keyword conflict
  subject TEXT NOT NULL,
  body_html TEXT,
  ai_summary TEXT,
  category TEXT CHECK(category IN ('OTP', 'FORM_DATA', 'DEFAULT', 'GENERAL')) DEFAULT 'DEFAULT',
  otp_code TEXT,
  form_data JSON,
  ts INTEGER NOT NULL,
  zone_id TEXT NOT NULL,
  FOREIGN KEY (zone_id) REFERENCES zones(id) ON DELETE CASCADE
);
-- Indexes for query performance optimization
CREATE INDEX IF NOT EXISTS idx_messages_zone ON email_messages(zone_id);
CREATE INDEX IF NOT EXISTS idx_messages_ts ON email_messages(ts DESC);
-- Seed data for initial zones to ensure the application is usable on first deploy
INSERT OR IGNORE INTO zones (id, name, domain) VALUES
('zone-demo-1', 'CatchiMail Primary', 'catchi.co.za'),
('zone-demo-2', 'Example Zone', 'example-zone.com');