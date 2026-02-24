# Seedance 2 Video Gen Skill for OpenClaw

<p align="center">
  <strong>AI video oluşturma ve daha fazlası — bir komutla kurun, saniyeler içinde oluşturmaya başlayın.</strong>
</p>

<p align="center">
  <a href="#seedance-video-oluşturma">Seedance 2.0</a> •
  <a href="#kurulum">Kurulum</a> •
  <a href="#api-key-alma">API Key</a> •
  <a href="https://evolink.ai">EvoLink</a>
</p>

<p align="center">
  <strong>🌐 Languages：</strong>
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

## Bu Nedir?

[EvoLink](https://evolink.ai) tarafından desteklenen [OpenClaw](https://github.com/openclaw/openclaw) yetenekleri koleksiyonu. Bir yetenek yükleyin ve AI ajanınız yeni yetenekler kazansın — video oluşturma, medya işleme ve daha fazlası.

Şu anda mevcut:

| Yetenek | Açıklama | Model |
|---------|----------|-------|
| **Seedance Video Gen** | Metin-videoya ve görsel-videoya, otomatik sesli | Seedance 1.5 Pro → 2.0 (ByteDance) |

📚 **Tam Rehber**: [awesome-seedance-2-guide](https://github.com/EvoLinkAI/awesome-seedance-2-guide) — Promptlar, kullanım örnekleri ve yetenekler vitrini

🚀 **[Seedance 2.0 API Erken Erişim Al →](https://seedance2api.app/)**

**Not**: Şu anda Seedance 1.5 Pro kullanılıyor. Seedance 2.0 piyasaya sürüldüğünde, göç gerekmez — otomatik olarak çalışır.

Daha fazla yetenek yakında.

---

## Kurulum

### Hızlı Kurulum (Önerilen)

```bash
openclaw skills add https://github.com/EvoLinkAI/evolink-skills
```

Hepsi bu. Yetenek artık ajanınızda kullanılabilir.

### Manuel Kurulum

```bash
git clone https://github.com/EvoLinkAI/evolink-skills.git
cd evolink-skills
openclaw skills add .
```

---

## API Key Alma

1. [evolink.ai](https://evolink.ai)'de kaydolun
2. Dashboard → API Keys'e gidin
3. Yeni bir key oluşturun
4. Ortam değişkenine ayarlayın:

```bash
export EVOLINK_API_KEY=your_key_here
```

Veya OpenClaw ajanınıza şunu söyleyin: *"EvoLink API key'imi ... olarak ayarla"* — gerisini o halleder.

---

## Seedance Video Oluşturma

OpenClaw ajanınızla doğal konuşma yoluyla AI videoları oluşturun.

### Neler Yapabilir

- **Metin-videoya** — Bir sahneyi tanımlayın, video alın
- **Görsel-videoya** — Çıktıyı yönlendirmek için referans görselleri sağlayın
- **Otomatik ses** — Senkronize ses, ses efektleri ve arka plan müziği
- **Birden fazla çözünürlük** — 480p, 720p, 1080p
- **Esnek süre** — 4–12 saniye
- **En boy oranları** — 16:9, 9:16, 1:1, 4:3, 3:4, 21:9

### Kullanım Örnekleri

Sadece ajanınızla konuşun:

> "Piyano çalan bir kedinin 5 saniyelik videosunu oluştur"

> "Okyanus üzerinde sinematik bir gün batımı oluştur, 1080p, 16:9"

> "Bu görseli referans olarak kullan ve 8 saniyelik bir videoya canlandır"

Ajan, eksik detaylar konusunda size rehberlik edecek ve oluşturmayı yönetecektir.

### Gereksinimler

- Sisteminizde `curl` ve `jq` yüklü olmalı
- `EVOLINK_API_KEY` ortam değişkeni ayarlanmış olmalı

### Script Referansı

Yetenek, doğrudan komut satırı kullanımı için `scripts/seedance-gen.sh` içerir:

```bash
# Metin-videoya
./scripts/seedance-gen.sh "Şafaktaki huzurlu bir dağ manzarası" --duration 5 --quality 720p

# Referans görsel ile
./scripts/seedance-gen.sh "Hafif okyanus dalgaları" --image "https://example.com/beach.jpg" --duration 8 --quality 1080p

# Sosyal medya için dikey format
./scripts/seedance-gen.sh "Dans eden parçacıklar" --aspect-ratio 9:16 --duration 4 --quality 720p

# Ses olmadan
./scripts/seedance-gen.sh "Soyut sanat animasyonu" --duration 6 --quality 720p --no-audio
```

### API Parametreleri

Tam API belgeleri için [references/api-params.md](references/api-params.md)'ye bakın.

---

## Dosya Yapısı

```
.
├── README.md                    # Bu dosya
├── SKILL.md                     # OpenClaw yetenek tanımı
├── _meta.json                   # Yetenek meta verileri
├── references/
│   └── api-params.md            # Tam API parametre referansı
└── scripts/
    └── seedance-gen.sh          # Video oluşturma scripti
```

---

## Sorun Giderme

| Sorun | Çözüm |
|-------|-------|
| `jq: command not found` | jq yükleyin: `apt install jq` / `brew install jq` |
| `401 Unauthorized` | [evolink.ai/dashboard](https://evolink.ai/dashboard)'da `EVOLINK_API_KEY`'nizi kontrol edin |
| `402 Payment Required` | [evolink.ai/dashboard](https://evolink.ai/dashboard)'da kredi ekleyin |
| `Content blocked` | Gerçekçi insan yüzleri kısıtlıdır — prompt'unuzu değiştirin |
| Oluşturma zaman aşımı | Videolar ayarlara bağlı olarak 30–180 saniye sürebilir. Önce daha düşük kalite deneyin. |

---

## Daha Fazla Yetenek

EvoLink destekli daha fazla yetenek ekliyoruz. Güncellemeleri takip edin veya [bir yetenek isteyin](https://github.com/EvoLinkAI/evolink-skills/issues).

---

## ClawHub'dan İndir

Bu yeteneği doğrudan ClawHub'dan da yükleyebilirsiniz:

👉 **[ClawHub'da İndir →](https://clawhub.ai/kn74p4xy6sja0199cea53anecs81kqjs/seedance-2-video-gen)**

---

## Lisans

MIT

---

<p align="center">
  Powered by <a href="https://evolink.ai"><strong>EvoLink</strong></a> — Unified AI API Gateway
</p>
