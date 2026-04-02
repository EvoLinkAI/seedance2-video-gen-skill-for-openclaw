# Seedance 2 Video Gen Skill für OpenClaw

<p align="center">
  <strong>KI-Videoerzeugung und mehr — installieren mit einem Befehl, in Sekunden starten.</strong>
</p>

<p align="center">
  <a href="#seedance-videoerzeugung">Seedance 2.0</a> •
  <a href="#installation">Installieren</a> •
  <a href="#api-key-erhalten">API Key</a> •
  <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw">EvoLink</a>
</p>

<p align="center">
  <strong>🌐 Sprachen：</strong>
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

## Was ist das?

Eine Sammlung von [OpenClaw](https://github.com/openclaw/openclaw)-Skills, angetrieben von [EvoLink](https://evolink.ai?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen). Installieren Sie einen Skill und Ihr KI-Agent gewinnt neue Fähigkeiten — Videos erzeugen, Medien verarbeiten und mehr.

Derzeit verfügbar:

| Skill | Beschreibung | Modell |
|-------|--------------|--------|
| **Seedance Video Gen** | Text-zu-Video, Bild-zu-Video, Referenz-zu-Video mit automatischem Audio | Seedance 2.0 (ByteDance) |

📚 **Vollständiger Leitfaden**: [awesome-seedance-2-guide](https://github.com/EvoLinkAI/awesome-seedance-2-guide) — Prompts, Anwendungsfälle und Funktionsübersicht

Weitere Skills in Kürze.

---

## Installation

### Schnellinstallation (Empfohlen)

```bash
openclaw skills add https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw
```

Das war's. Der Skill ist jetzt für Ihren Agenten verfügbar.

### Über npm installieren

```bash
npx evolink-seedance
```

Oder nicht-interaktiv (für KI-Agenten / CI):

```bash
npx evolink-seedance -y
```

### Manuelle Installation

```bash
git clone https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw.git
cd seedance2-video-gen-skill-for-openclaw
openclaw skills add .
```

---

## API Key Erhalten

1. Registrieren Sie sich bei [evolink.ai](https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw)
2. Gehen Sie zu Dashboard → API Keys
3. Erstellen Sie einen neuen Key
4. Setzen Sie ihn in Ihrer Umgebung:

```bash
export EVOLINK_API_KEY=ihr_key_hier
```

Oder sagen Sie Ihrem OpenClaw-Agenten: *"Setze meinen EvoLink API Key auf ..."* — er erledigt den Rest.

---

## Seedance Videoerzeugung

Erzeugen Sie KI-Videos durch natürliche Konversation mit Ihrem OpenClaw-Agenten.

### Was Es Kann

- **Text-zu-Video** — Beschreiben Sie eine Szene, erhalten Sie ein Video (mit optionaler Websuche)
- **Bild-zu-Video** — 1 Bild: Animation vom ersten Frame; 2 Bilder: Interpolation zwischen erstem und letztem Frame
- **Referenz-zu-Video** — Kombinieren Sie Bilder, Videoclips und Audio zum Erstellen, Bearbeiten oder Verlängern von Videos
- **Automatisches Audio** — Synchronisierte Stimme, Soundeffekte und Hintergrundmusik
- **Mehrere Auflösungen** — 480p, 720p
- **Flexible Dauer** — 4–15 Sekunden
- **Seitenverhältnisse** — 16:9, 9:16, 1:1, 4:3, 3:4, 21:9, adaptive

### Nutzungsbeispiele

Sprechen Sie einfach mit Ihrem Agenten:

> "Erzeuge ein 5-Sekunden-Video von einer Katze, die Klavier spielt"

> "Erstelle einen filmischen Sonnenuntergang über dem Ozean, 720p, 16:9"

> "Verwende dieses Bild als Referenz und animiere es zu einem 8-Sekunden-Video"

> "Bearbeite diesen Videoclip — ersetze den Gegenstand durch mein Produktbild"

Der Agent führt Sie durch fehlende Details und verwaltet die Erzeugung.

### Anforderungen

- `curl` und `jq` auf Ihrem System installiert
- Umgebungsvariable `EVOLINK_API_KEY` gesetzt

### Script-Referenz

Der Skill enthält `scripts/seedance-gen.sh` für direkte Kommandozeilennutzung:

```bash
# Text-zu-Video
./scripts/seedance-gen.sh "Eine ruhige Berglandschaft im Morgengrauen" --duration 5 --quality 720p

# Bild-zu-Video (Animation vom ersten Frame)
./scripts/seedance-gen.sh "Sanfte Meereswellen" --image "https://example.com/beach.jpg" --duration 8 --quality 720p

# Referenz-zu-Video (Videoclip mit Bild bearbeiten)
./scripts/seedance-gen.sh "Ersetze den Gegenstand durch das Produkt aus Bild 1" --image "https://example.com/product.jpg" --video "https://example.com/clip.mp4" --duration 5 --quality 720p

# Vertikales Format für Social Media
./scripts/seedance-gen.sh "Tanzende Partikel" --aspect-ratio 9:16 --duration 4 --quality 720p

# Ohne Audio
./scripts/seedance-gen.sh "Abstrakte Kunstanimation" --duration 6 --quality 720p --no-audio
```

### API-Parameter

Siehe [references/api-params.md](references/api-params.md) für vollständige API-Dokumentation.

---

## Dateistruktur

```
.
├── README.md                    # Diese Datei
├── SKILL.md                     # OpenClaw Skill-Definition
├── _meta.json                   # Skill-Metadaten
├── references/
│   └── api-params.md            # Vollständige API-Parameterreferenz
└── scripts/
    └── seedance-gen.sh          # Videoerzeugungsscript
```

---

## Fehlerbehebung

| Problem | Lösung |
|---------|--------|
| `jq: command not found` | jq installieren: `apt install jq` / `brew install jq` |
| `401 Unauthorized` | Überprüfen Sie Ihren `EVOLINK_API_KEY` unter [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) |
| `402 Payment Required` | Guthaben unter [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) aufladen |
| `Content blocked` | Realistische menschliche Gesichter sind eingeschränkt — passen Sie Ihren Prompt an |
| Erzeugungs-Timeout | Videos können je nach Einstellung 30–180s dauern. Versuchen Sie zuerst niedrigere Qualität. |
| Videodatei zu groß | Referenzvideos müssen ≤50MB sein, Gesamtdauer ≤15s |

---

## Weitere Skills

Wir fügen weitere EvoLink-betriebene Skills hinzu. Bleiben Sie dran oder [fordern Sie einen Skill an](https://github.com/EvoLinkAI/evolink-skills/issues).

---

## Von ClawHub Herunterladen

Sie können diesen Skill auch direkt von ClawHub installieren:

👉 **[Auf ClawHub herunterladen →](https://clawhub.ai/kn74p4xy6sja0199cea53anecs81kqjs/seedance-2-video-gen)**

---

## Lizenz

MIT

---

<p align="center">
  Angetrieben von <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw"><strong>EvoLink</strong></a> — Einheitliches KI-API-Gateway
</p>
