🌐 [English](README.md) | [Español](README.es.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [Deutsch](README.de.md) | **Français** | [Türkçe](README.tr.md) | [Русский](README.ru.md) | [Português](README.pt.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md)


# Seedance 2 Video Gen Skill pour OpenClaw

<p align="center">
  <strong>Génération de vidéo IA et plus — installez en une commande, commencez à créer en secondes.</strong>
</p>

<p align="center">
  <a href="#génération-de-vidéo-seedance">Seedance 2.0</a> •
  <a href="#installation">Installer</a> •
  <a href="#obtenir-une-api-key">API Key</a> •
  <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw">EvoLink</a>
</p>

<p align="center">
  <strong>🌐 Langues：</strong>
  <a href="README.md">English</a> |
  <a href="README.zh-CN.md">简体中文</a> |
  <a href="README.zh-TW.md">繁體中文</a> |
  <a href="README.es.md">Español</a> |
  <a href="README.ja.md">日本語</a> |
  <a href="README.ko.md">한국어</a> |
  <a href="README.tr.md">Türkçe</a> |
  <a href="README.fr.md">Français</a> |
  <a href="README.de.md">Deutsch</a>
</p>

---

## Qu'est-ce que c'est ?

Une collection de compétences pour [OpenClaw](https://github.com/openclaw/openclaw) propulsées par [EvoLink](https://evolink.ai?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen). Installez une compétence et votre agent IA gagne de nouvelles capacités — générez des vidéos, traitez des médias et plus.

Actuellement disponible :

| Compétence | Description | Modèle |
|------------|-------------|--------|
| **Seedance Video Gen** | Texte vers vidéo, image vers vidéo, référence vers vidéo avec audio automatique | Seedance 2.0 (ByteDance) |

📚 **Guide Complet** : [awesome-seedance-2-guide](https://github.com/EvoLinkAI/awesome-seedance-2-guide) — Prompts, cas d'utilisation et démonstration des capacités

Plus de compétences à venir.

---

## Installation

### Installation Rapide (Recommandé)

```bash
openclaw skills add https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw
```

C'est tout. La compétence est maintenant disponible pour votre agent.

### Installer via npm

```bash
npx evolink-seedance
```

Ou mode non interactif (pour agents IA / CI) :

```bash
npx evolink-seedance -y
```

### Installation Manuelle

```bash
git clone https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw.git
cd seedance2-video-gen-skill-for-openclaw
openclaw skills add .
```

---

## Obtenir une API Key

1. Inscrivez-vous sur [evolink.ai](https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw)
2. Allez dans Dashboard → API Keys
3. Créez une nouvelle key
4. Configurez-la dans votre environnement :

```bash
export EVOLINK_API_KEY=votre_key_ici
```

Ou dites à votre agent OpenClaw : *"Configure ma clé API EvoLink à ..."* — il s'occupera du reste.

---

## Génération de Vidéo Seedance

Générez des vidéos IA via une conversation naturelle avec votre agent OpenClaw.

### Ce Que Ça Peut Faire

- **Texte vers vidéo** — Décrivez une scène, obtenez une vidéo (avec recherche web optionnelle)
- **Image vers vidéo** — 1 image : animation depuis la première image ; 2 images : interpolation première et dernière image
- **Référence vers vidéo** — Combinez images, clips vidéo et audio pour créer, éditer ou prolonger une vidéo
- **Audio automatique** — Voix, effets sonores et musique de fond synchronisés
- **Résolutions multiples** — 480p, 720p
- **Durée flexible** — 4–15 secondes
- **Ratios d'aspect** — 16:9, 9:16, 1:1, 4:3, 3:4, 21:9, adaptive

### Exemples d'Utilisation

Parlez simplement à votre agent :

> "Génère une vidéo de 5 secondes d'un chat jouant du piano"

> "Crée un coucher de soleil cinématographique sur l'océan, 720p, 16:9"

> "Utilise cette image comme référence et anime-la en une vidéo de 8 secondes"

> "Édite ce clip vidéo — remplace l'objet par l'image de mon produit"

L'agent vous guidera à travers les détails manquants et gérera la génération.

### Prérequis

- `curl` et `jq` installés sur votre système
- Variable d'environnement `EVOLINK_API_KEY` configurée

### Référence du Script

La compétence inclut `scripts/seedance-gen.sh` pour une utilisation directe en ligne de commande :

```bash
# Texte vers vidéo
./scripts/seedance-gen.sh "Un paysage montagneux serein à l'aube" --duration 5 --quality 720p

# Image vers vidéo (animation depuis la première image)
./scripts/seedance-gen.sh "Douces vagues océaniques" --image "https://example.com/beach.jpg" --duration 8 --quality 720p

# Référence vers vidéo (éditer un clip avec une image)
./scripts/seedance-gen.sh "Remplace l'objet par le produit de l'image 1" --image "https://example.com/product.jpg" --video "https://example.com/clip.mp4" --duration 5 --quality 720p

# Format vertical pour les réseaux sociaux
./scripts/seedance-gen.sh "Particules dansantes" --aspect-ratio 9:16 --duration 4 --quality 720p

# Sans audio
./scripts/seedance-gen.sh "Animation d'art abstrait" --duration 6 --quality 720p --no-audio
```

### Paramètres API

Consultez [references/api-params.md](references/api-params.md) pour la documentation complète de l'API.

---

## Structure des Fichiers

```
.
├── README.md                    # Ce fichier
├── SKILL.md                     # Définition de compétence OpenClaw
├── _meta.json                   # Métadonnées de compétence
├── references/
│   └── api-params.md            # Référence complète des paramètres API
└── scripts/
    └── seedance-gen.sh          # Script de génération de vidéo
```

---

## Dépannage

| Problème | Solution |
|----------|----------|
| `jq: command not found` | Installez jq : `apt install jq` / `brew install jq` |
| `401 Unauthorized` | Vérifiez votre `EVOLINK_API_KEY` sur [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) |
| `402 Payment Required` | Ajoutez des crédits sur [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) |
| `Content blocked` | Les visages humains réalistes sont restreints — modifiez votre prompt |
| Timeout de génération | Les vidéos peuvent prendre 30–180s selon les réglages. Essayez une qualité inférieure d'abord. |
| Fichier vidéo trop volumineux | Les vidéos de référence doivent être ≤50 Mo chacune, durée totale ≤15s |

---

## Plus de Compétences

Nous ajoutons plus de compétences propulsées par EvoLink. Restez à l'écoute ou [demandez une compétence](https://github.com/EvoLinkAI/evolink-skills/issues).

---

## Télécharger depuis ClawHub

Vous pouvez aussi installer cette compétence directement depuis ClawHub :

👉 **[Télécharger sur ClawHub →](https://clawhub.ai/kn74p4xy6sja0199cea53anecs81kqjs/seedance-2-video-gen)**

---

## Licence

MIT

---

<p align="center">
  Propulsé par <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw"><strong>EvoLink</strong></a> — Passerelle API IA Unifiée
</p>
