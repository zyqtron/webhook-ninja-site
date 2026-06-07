# 🥷 WebhookNinja
*Part of the Zyqtron Ecosystem*

Plateforme d'automatisation webhook simplifiée, déployée sur GitHub Pages.

## ✨ Fonctionnalités Clés
- **Landing Page Interactive** : Terminal de démo, Calculateur ROI, Animations Ninja
- **Backend Sécurisé** : X-API-KEY, Rate-Limit 60 req/min, Worker Noosphere
- **Déploiement Rapide** : Propagation en <2 minutes sur GitHub Pages
- **SEO & Accessibilité** : Optimisé WCAG AA, balises Open Graph/Twitter Cards

## 🚀 Déploiement
- **Frontend** : [https://zyqtron.github.io/webhook-ninja/](https://zyqtron.github.io/webhook-ninja/)
- **Backend** : À déployer séparément (Render ou équivalent)

## 🛠️ Installation Locale
1. Cloner le dépôt :
   ```bash
   git clone https://github.com/zyqtron/webhook-ninja.git
   ```
2. Installer les dépendances :
   ```bash
   pip install -r requirements.txt
   ```
3. Configurer l'environnement :
   ```bash
   cp .env.example .env
   # Éditer .env avec votre clé API
   ```
4. Lancer le backend :
   ```bash
   python3 app.py
   ```

## 📂 Structure du Projet
- `index.html` : Landing Page v2.0 (single file, Tailwind CDN)
- `app.py` : Backend FastAPI v2.9.1
- `requirements.txt` : Dépendances Python
- `.env.example` : Modèle de configuration

## 📄 Licence
Projet sous licence MIT.