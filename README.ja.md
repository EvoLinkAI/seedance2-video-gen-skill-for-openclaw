# OpenClaw 向け Seedance 2 動画生成スキル

<p align="center">
  <strong>AI ビデオ生成など — ワンコマンドでインストール、秒速で作成開始。</strong>
</p>

<p align="center">
  <a href="#seedance-ビデオ生成">Seedance 2.0</a> •
  <a href="#インストール">インストール</a> •
  <a href="#api-key-の取得">API Key</a> •
  <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw">EvoLink</a>
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

## これは何ですか？

[EvoLink](https://evolink.ai?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) 提供の [OpenClaw](https://github.com/openclaw/openclaw) スキル集です。スキルをインストールすると、AI エージェントに新しい能力が追加されます — ビデオ生成、メディア処理など。

現在利用可能：

| スキル | 説明 | モデル |
|--------|------|--------|
| **Seedance Video Gen** | テキストからビデオ、画像からビデオ、リファレンスからビデオ、自動音声付き | Seedance 2.0（ByteDance） |

📚 **完全ガイド**: [awesome-seedance-2-guide](https://github.com/EvoLinkAI/awesome-seedance-2-guide) — プロンプト、ユースケース、機能紹介

その他のスキルも近日公開予定。

---

## インストール

### クイックインストール（推奨）

```bash
openclaw skills add https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw
```

完了です。スキルがエージェントで利用可能になりました。

### npm でインストール

```bash
npx evolink-seedance
```

または非対話モード（AI エージェント / CI 向け）：

```bash
npx evolink-seedance -y
```

### 手動インストール

```bash
git clone https://github.com/EvoLinkAI/seedance2-video-gen-skill-for-openclaw.git
cd seedance2-video-gen-skill-for-openclaw
openclaw skills add .
```

---

## API Key の取得

1. [evolink.ai](https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw) で登録
2. Dashboard → API Keys に移動
3. 新しい key を作成
4. 環境変数に設定：

```bash
export EVOLINK_API_KEY=your_key_here
```

または OpenClaw エージェントに *「EvoLink API key を ... に設定して」* と伝えるだけ — 残りは自動で処理します。

---

## Seedance ビデオ生成

OpenClaw エージェントとの自然な会話で AI ビデオを生成します。

### できること

- **テキストからビデオ** — シーンを説明すると、ビデオが生成されます（オプションのウェブ検索付き）
- **画像からビデオ** — 1枚の画像：最初のフレームからアニメーション；2枚の画像：最初と最後のフレーム補間
- **リファレンスからビデオ** — 画像、ビデオクリップ、音声を組み合わせてビデオを作成、編集、延長
- **自動音声** — 同期された音声、効果音、BGM
- **複数解像度** — 480p、720p
- **柔軟な長さ** — 4–15 秒
- **アスペクト比** — 16:9、9:16、1:1、4:3、3:4、21:9、adaptive

### 使用例

エージェントに話しかけるだけ：

> "5秒間の猫がピアノを弾くビデオを生成して"

> "海の上の映画のような夕日を作成して、720p、16:9"

> "この画像を参考にして、8秒のアニメーションビデオにして"

> "このビデオクリップを編集して — アイテムを自分の製品画像に置き換えて"

エージェントが不足情報を確認し、生成を処理します。

### 必要なもの

- システムに `curl` と `jq` がインストールされていること
- 環境変数 `EVOLINK_API_KEY` が設定されていること

### スクリプトリファレンス

スキルにはコマンドラインで直接使用できる `scripts/seedance-gen.sh` が含まれています：

```bash
# テキストからビデオ
./scripts/seedance-gen.sh "夜明けの穏やかな山の風景" --duration 5 --quality 720p

# 画像からビデオ（最初のフレームからアニメーション）
./scripts/seedance-gen.sh "穏やかな海の波" --image "https://example.com/beach.jpg" --duration 8 --quality 720p

# リファレンスからビデオ（画像でビデオクリップを編集）
./scripts/seedance-gen.sh "アイテムを画像1の製品に置き換え" --image "https://example.com/product.jpg" --video "https://example.com/clip.mp4" --duration 5 --quality 720p

# ソーシャルメディア用縦型
./scripts/seedance-gen.sh "踊る粒子" --aspect-ratio 9:16 --duration 4 --quality 720p

# 音声なし
./scripts/seedance-gen.sh "抽象芸術アニメーション" --duration 6 --quality 720p --no-audio
```

### API パラメータ

完全な API ドキュメントは [references/api-params.md](references/api-params.md) を参照してください。

---

## ファイル構造

```
.
├── README.md                    # このファイル
├── SKILL.md                     # OpenClaw スキル定義
├── _meta.json                   # スキルメタデータ
├── references/
│   └── api-params.md            # 完全な API パラメータリファレンス
└── scripts/
    └── seedance-gen.sh          # ビデオ生成スクリプト
```

---

## トラブルシューティング

| 問題 | 解決策 |
|------|--------|
| `jq: command not found` | jq をインストール: `apt install jq` / `brew install jq` |
| `401 Unauthorized` | [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) で `EVOLINK_API_KEY` を確認 |
| `402 Payment Required` | [evolink.ai/dashboard](https://evolink.ai/dashboard?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen) でクレジットを追加 |
| `Content blocked` | リアルな人間の顔は制限されています — プロンプトを修正してください |
| ビデオファイルが大きすぎる | リファレンスビデオは各≤50MB、合計時間≤15秒 |
| 生成タイムアウト | 設定により 30–180 秒かかることがあります。最初に低品質で試してください。 |

---

## その他のスキル

EvoLink 提供のスキルを追加予定です。続報をお待ちください、または [スキルをリクエスト](https://github.com/EvoLinkAI/evolink-skills/issues) してください。

---

## ClawHub からダウンロード

このスキルは ClawHub から直接インストールすることもできます：

👉 **[ClawHub でダウンロード →](https://clawhub.ai/kn74p4xy6sja0199cea53anecs81kqjs/seedance-2-video-gen)**

---

## ライセンス

MIT

---

<p align="center">
  Powered by <a href="https://evolink.ai/signup?utm_source=github&utm_medium=readme&utm_campaign=seedance2-video-gen-skill-for-openclaw"><strong>EvoLink</strong></a> — Unified AI API Gateway
</p>
