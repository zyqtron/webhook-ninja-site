# 🥷 WebhookNinja

**Infrastructure Webhook Robuste** — Propulsé par Zyqtron

> Gérez vos webhooks avec retry automatique, Dead Letter Queue persistante, monitoring temps réel et gestion de comptes multi-plans.

👉 **Site en ligne :** https://zyqtron.github.io/webhook-ninja-site/  
👉 **Repo privé (code source complet) :** [zyqtron/webhook-ninja](https://github.com/zyqtron/webhook-ninja)

---

## 📋 Table des matières

- [Architecture](#architecture)
- [Démarrage rapide](#démarrage-rapide)
- [API Endpoints](#api-endpoints)
- [Base de données](#base-de-données)
- [Dashboard](#dashboard)
- [Plans](#plans)
- [Déploiement](#déploiement)
- [Stack technique](#stack-technique)

---

## 🏗️ Architecture

```
                     ┌─────────────┐
                     │   Client    │
                     └──────┬──────┘
                            │ POST /webhooks/{id}/send
                            ▼
                     ┌─────────────┐
                     │  FastAPI    │  ← app.py
                     │  (uvicorn)  │
                     └──────┬──────┘
                            │
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
       ┌──────────┐  ┌──────────┐  ┌──────────┐
       │ task_    │  │  audit_  │  │accounts │
       │ queue    │  │  logs    │  │         │
       └────┬─────┘  └──────────┘  └──────────┘
            │
            ▼
     ┌──────────────┐     ┌──────────────────┐
     │  Worker      │────▶│  Dead Letter     │
     │  Noosphere   │     │  Queue (DLQ)     │
     └──────┬───────┘     └──────────────────┘
            │
            ▼
     ┌──────────────┐
     │  deliveries  │
     │  (logs)      │
     └──────────────┘
```

### Flux de données

1. **HTTP 202 Accepted** — Réception immédiate sans bloquer le client
2. **File d'attente** — La tâche est mise dans `task_queue` (statut `pending`)
3. **Worker Noosphere** — Boucle asynchrone qui traite les tâches en arrière-plan
4. **Retry intelligent** — Exponential backoff (1s → 2s → 4s → 8s → 16s → max 5min)
5. **DLQ** — Après épuisement des retries, le webhook est stocké dans la Dead Letter Queue
6. **Retry manuel** — L'utilisateur peut rejouer depuis le Dashboard ou l'API

---

## 🚀 Démarrage rapide

```bash
# 1. Cloner
git clone https://github.com/zyqtron/webhook-ninja-site.git
cd webhook-ninja-site

# 2. Installer les dépendances
pip install -r requirements.txt

# 3. Copier et configurer l'environnement
cp .env.example .env
# Éditer .env avec votre clé API

# 4. Lancer
chmod +x start.sh
./start.sh
```

Le serveur écoute sur **http://localhost:8000**.

---

## 📡 API Endpoints

### Webhooks

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `POST` | `/webhooks` | Créer un webhook |
| `GET` | `/webhooks` | Lister les webhooks |
| `GET` | `/webhooks/{id}` | Détail d'un webhook |
| `PUT` | `/webhooks/{id}` | Modifier un webhook |
| `DELETE` | `/webhooks/{id}` | Supprimer un webhook |
| `POST` | `/webhooks/{id}/send` | Envoyer avec retry automatique |

### Dead Letter Queue

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `GET` | `/dlq` | Voir la DLQ |
| `POST` | `/dlq/{id}/retry` | Rejouer un webhook échoué |
| `DELETE` | `/dlq/{id}` | Supprimer de la DLQ |

### Statistiques

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `GET` | `/stats/delivery` | Statistiques globales |
| `GET` | `/stats/delivery/{id}` | Stats par webhook |
| `GET` | `/health` | Health check |

### Exemples

```bash
# Créer un webhook
curl -X POST http://localhost:8000/webhooks \
  -H "Content-Type: application/json" \
  -d '{"name": "Mon Webhook", "destination_url": "https://example.com/hook", "enabled": true}'

# Envoyer un payload
curl -X POST http://localhost:8000/webhooks/abc123/send \
  -H "Content-Type: application/json" \
  -d '{"event": "payment", "amount": 1999}'

# Voir la DLQ
curl http://localhost:8000/dlq?limit=50

# Rejouer depuis la DLQ
curl -X POST http://localhost:8000/dlq/abc123/retry
```

---

## 💾 Base de données

5 tables SQLite — schema complet dans [`db_schema.sql`](db_schema.sql).

| Table | Rôle |
|-------|------|
| `task_queue` | File d'attente asynchrone (pattern Noosphere) |
| `audit_logs` | Logs de sécurité et rate-limiting |
| `accounts` | Comptes utilisateurs, plans, Stripe |
| `deliveries` | Historique des tentatives d'envoi |
| `dead_letter_queue` | Webhooks échoués en attente de retry |

### Index

```sql
CREATE INDEX idx_deliveries_webhook_id ON deliveries(webhook_id);
CREATE INDEX idx_deliveries_timestamp ON deliveries(timestamp);
CREATE INDEX idx_dlq_status ON dead_letter_queue(status);
```

---

## 📊 Dashboard

Interface de contrôle temps réel accessible sur `http://localhost:8000/dashboard` ([`dashboard.html`](dashboard.html)) :

- 📊 Statistiques globales (taux de succès, volume)
- ☠️ Dead Letter Queue interactive avec bouton retry
- 📋 File d'attente en temps réel
- ❌ Derniers échecs avec barres de progression
- 🔄 Auto-refresh toutes les 30 secondes

---

## 💰 Plans

| Plan | Webhooks/mois | Prix |
|------|:-------------:|:----:|
| **Free** | 1 000 | Gratuit |
| **Pro** | 50 000 | 29€/mois |
| **Enterprise** | Illimité | Sur devis |

---

## 🐳 Déploiement

### Docker

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Docker Compose

```yaml
version: '3'
services:
  webhook-ninja:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - ./webhook_ninja.db:/app/webhook_ninja.db
```

---

## 🛠️ Stack technique

| Composant | Technologie | Version |
|-----------|-------------|---------|
| Framework API | FastAPI | >= 0.115 |
| Serveur ASGI | uvicorn | >= 0.34 |
| Base de données | SQLite | 3.x |
| Client HTTP | httpx | Async |
| Frontend | HTML5 + Tailwind CSS | CDN |
| Dashboard | Vanilla JS | Auto-refresh |

---

## 📦 Dépendances

```
fastapi>=0.100.0
uvicorn>=0.24.0
pydantic>=2.0.0
httpx>=0.28.0
python-dotenv>=1.0.0
```

---

## 📄 Licence

MIT — voir [LICENSE](LICENSE).

---

🥷 **Propulsé par Zyqtron — Architecture Swarm Active**  
[Site officiel](https://zyqtron.github.io/webhook-ninja-site/) • [GitHub privé](https://github.com/zyqtron/webhook-ninja)
