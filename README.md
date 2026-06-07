# 🥷 WebhookNinja

**Infrastructure Webhook Robuste** — Propulse par Zyqtron THKL

> Gerer vos webhooks avec retry automatique, Dead Letter Queue persistante, monitoring temps reel et gestion de comptes multi-plans.
> 
> **22 savoir-faire techniques valides, 529 preuves blockchain, algorithmes de securite certifies.**

👉 **Site en ligne :** [webhookninja.zyqtron.fr](https://webhookninja.zyqtron.fr) | [zyqtron.github.io/webhook-ninja-site](https://zyqtron.github.io/webhook-ninja-site/)

---

## 🛡️ Securite THKL

WebhookNinja s'appuie sur le portefeuille technique de Zyqtron :

| THKL | Domaine | Application |
|------|---------|-------------|
| THKL-52BC74 | Authentification renforcee | PBKDF2-SHA256, 52 bits entropie, blocage apres 20 tentatives |
| THKL-6A80B8 | Detection d'intrusion | Stide SCADA adapte aux patterns de webhooks |
| THKL-97585D | Detection de malware | Introspection VM pour isolation des payloads |
| THKL-C57C05 | IA neuromorphique | Detection d'anomalies en temps reel |

[Voir le catalogue THKL complet](https://zyqtron.fr/catalogue.html)

---

## 💰 Packs

| Pack | Webhooks/mois | Prix |
|------|:---:|:---:|
| **Starter** | 5 000 | 9EUR/mois |
| **Pro** | 50 000 | 29EUR/mois |
| **Enterprise** | Illimite | Sur devis |

---

## 🏗️ Architecture

```
Client → POST /webhooks → FastAPI → Task Queue → Worker Noosphere → Retry/DLQ
```

- **FastAPI + uvicorn** : API REST async
- **SQLite** : Persistance locale
- **Worker Noosphere** : Traitement async avec retry exponentiel (1s→16s) + jitter
- **DLQ** : Dead Letter Queue pour echecs persistants
- **HMAC signing** : Signature SHA256 des payloads

---

## 📡 API

| Methode | Endpoint | Description |
|---------|----------|-------------|
| `POST` | `/webhooks` | Recevoir un webhook (auth requise) |
| `GET` | `/stats/queue` | Stats file d'attente |
| `GET` | `/stats/delivery` | Stats livraison |
| `GET` | `/dlq` | Dead Letter Queue |
| `POST` | `/dlq/{id}/retry` | Rejouer un webhook echoue |
| `GET` | `/api/account` | Mon compte |
| `POST` | `/api/keys` | Generer une cle API |

---

## 🚀 Deploiement

- **Frontend** : [webhookninja.zyqtron.fr](https://webhookninja.zyqtron.fr) (GitHub Pages)
- **Backend** : A deployer separement (Railway, Koyeb, ou VPS)

### Local
```bash
git clone https://github.com/zyqtron/webhook-ninja-site.git
cd webhook-ninja-site
pip install -r requirements.txt
cp .env.example .env
python3 app.py
```

### Tests
```bash
python3 -m pytest tests/ -v
```

---

## 🛠️ Stack

| Composant | Technologie |
|-----------|-------------|
| API | FastAPI 0.115+ |
| Async | uvicorn + httpx |
| DB | SQLite |
| Auth | API Key SHA256 |
| Frontend | HTML5 + Tailwind CSS |
| Signing | HMAC-SHA256 |

---

🥷 **Zyqtron — Cabinet valorisation capital technique**  
[zyqtron.fr](https://zyqtron.fr) • [Catalogue THKL](https://zyqtron.fr/catalogue.html)
