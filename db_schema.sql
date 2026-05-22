-- WebhookNinja SQLite Schema v3.0
-- Synchronisé avec app.py init_db() et la base réelle
-- Généré le 17 mai 2026 après audit de conformité

-- TABLE: task_queue
-- Cœur du pattern Noosphere : file d'attente asynchrone
CREATE TABLE IF NOT EXISTS task_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    payload TEXT,
    status TEXT DEFAULT 'pending'
);

-- TABLE: audit_logs
-- Logs de sécurité et rate-limiting
CREATE TABLE IF NOT EXISTS audit_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TEXT,
    ip TEXT,
    endpoint TEXT,
    status INTEGER
);

-- TABLE: accounts
-- Authentification, plans tarifaires, Stripe
CREATE TABLE IF NOT EXISTS accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    api_key_hash TEXT UNIQUE NOT NULL,
    api_key_prefix TEXT NOT NULL,
    plan TEXT DEFAULT 'free',
    webhook_count INTEGER DEFAULT 0,
    webhook_month TEXT,
    stripe_customer_id TEXT,
    stripe_subscription_id TEXT,
    created_at TEXT NOT NULL,
    last_used TEXT
);

-- TABLE: deliveries
-- Audit des tentatives de delivery
CREATE TABLE IF NOT EXISTS deliveries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    webhook_id TEXT,
    payload TEXT,
    destination_url TEXT,
    status TEXT,
    response_code INTEGER,
    error_message TEXT,
    timestamp TEXT
);

-- TABLE: dead_letter_queue
-- Webhooks échoués, en attente de retry manuel
CREATE TABLE IF NOT EXISTS dead_letter_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    webhook_id TEXT,
    payload TEXT,
    destination_url TEXT,
    attempt_number INTEGER,
    last_error TEXT,
    last_timestamp TEXT,
    status TEXT DEFAULT 'pending'
);

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_deliveries_webhook_id ON deliveries(webhook_id);
CREATE INDEX IF NOT EXISTS idx_deliveries_timestamp ON deliveries(timestamp);
CREATE INDEX IF NOT EXISTS idx_dlq_status ON dead_letter_queue(status);
