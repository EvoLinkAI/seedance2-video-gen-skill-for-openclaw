# OpenClaw용 Seedance 2 Video Gen Skill

<p align="center">
  <strong>AI 비디오 생성 등 — 한 번의 명령으로 설치, 수 초 만에 생성 시작.</strong>
</p>

<p align="center">
  <a href="#seedance-비디오-생성">Seedance 2.0</a> •
  <a href="#설치">설치</a> •
  <a href="#api-key-받기">API Key</a> •
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

## 이것은 무엇인가요?

[EvoLink](https://evolink.ai) 제공 [OpenClaw](https://github.com/openclaw/openclaw) 스킬 모음입니다. 스킬을 설치하면 AI 에이전트에 새로운 기능이 추가됩니다 — 비디오 생성, 미디어 처리 등.

현재 사용 가능:

| 스킬 | 설명 | 모델 |
|------|------|------|
| **Seedance Video Gen** | 텍스트-투-비디오, 이미지-투-비디오, 자동 오디오 포함 | Seedance 1.5 Pro → 2.0 (ByteDance) |

📚 **완전한 가이드**: [awesome-seedance-2-guide](https://github.com/EvoLinkAI/awesome-seedance-2-guide) — 프롬프트, 사용 사례, 기능 소개

🚀 **[Seedance 2.0 API 얼리 액세스 신청 →](https://seedance2api.app/)**

**참고**: 현재 Seedance 1.5 Pro를 사용하고 있습니다. Seedance 2.0이 출시되어도 마이그레이션 작업이 필요 없습니다 — 자동으로 작동합니다.

더 많은 스킬이 곧 출시됩니다.

---

## 설치

### 빠른 설치 (권장)

```bash
openclaw skills add https://github.com/EvoLinkAI/evolink-skills
```

끝입니다. 스킬이 에이전트에서 사용 가능합니다.

### 수동 설치

```bash
git clone https://github.com/EvoLinkAI/evolink-skills.git
cd evolink-skills
openclaw skills add .
```

---

## API Key 받기

1. [evolink.ai](https://evolink.ai)에서 가입
2. Dashboard → API Keys로 이동
3. 새 key 생성
4. 환경 변수에 설정:

```bash
export EVOLINK_API_KEY=your_key_here
```

또는 OpenClaw 에이전트에게 *"EvoLink API key를 ...로 설정해줘"* 라고 말하면 됩니다 — 나머지는 자동으로 처리합니다.

---

## Seedance 비디오 생성

OpenClaw 에이전트와 자연스러운 대화를 통해 AI 비디오를 생성합니다.

### 할 수 있는 것

- **텍스트-투-비디오** — 장면을 설명하면 비디오가 생성됩니다
- **이미지-투-비디오** — 참조 이미지를 제공하여 출력 제어
- **자동 오디오** — 동기화된 음성, 효과음, 배경음악
- **다중 해상도** — 480p, 720p, 1080p
- **유연한 길이** — 4–12초
- **화면 비율** — 16:9, 9:16, 1:1, 4:3, 3:4, 21:9

### 사용 예시

에이전트에게 말하기만 하면 됩니다:

> "5초짜리 고양이가 피아노 치는 비디오 생성해줘"

> "바다 위 영화 같은 일몰 만들어줘, 1080p, 16:9"

> "이 이미지를 참조로 해서 8초 애니메이션 비디오로 만들어줘"

에이전트가 부족한 정보를 확인하고 생성을 처리합니다.

### 필요한 것

- 시스템에 `curl`과 `jq`가 설치되어 있어야 함
- 환경 변수 `EVOLINK_API_KEY`가 설정되어 있어야 함

### 스크립트 참조

스킬에는 명령줄에서 직접 사용할 수 있는 `scripts/seedance-gen.sh`이 포함되어 있습니다:

```bash
# 텍스트-투-비디오
./scripts/seedance-gen.sh "새벽의 평화로운 산 풍경" --duration 5 --quality 720p

# 참조 이미지 포함
./scripts/seedance-gen.sh "부드러운 파도" --image "https://example.com/beach.jpg" --duration 8 --quality 1080p

# 소셜 미디어용 세로형
./scripts/seedance-gen.sh "춤추는 입자" --aspect-ratio 9:16 --duration 4 --quality 720p

# 오디오 없음
./scripts/seedance-gen.sh "추상 예술 애니메이션" --duration 6 --quality 720p --no-audio
```

### API 파라미터

전체 API 문서는 [references/api-params.md](references/api-params.md)를 참조하세요.

---

## 파일 구조

```
.
├── README.md                    # 이 파일
├── SKILL.md                     # OpenClaw 스킬 정의
├── _meta.json                   # 스킬 메타데이터
├── references/
│   └── api-params.md            # 완전한 API 파라미터 참조
└── scripts/
    └── seedance-gen.sh          # 비디오 생성 스크립트
```

---

## 문제 해결

| 문제 | 해결책 |
|------|--------|
| `jq: command not found` | jq 설치: `apt install jq` / `brew install jq` |
| `401 Unauthorized` | [evolink.ai/dashboard](https://evolink.ai/dashboard)에서 `EVOLINK_API_KEY` 확인 |
| `402 Payment Required` | [evolink.ai/dashboard](https://evolink.ai/dashboard)에서 크레딧 추가 |
| `Content blocked` | 사실적인 인간 얼굴은 제한됨 — 프롬프트 수정 |
| 생성 타임아웃 | 설정에 따라 30–180초 소요될 수 있습니다. 먼저 낮은 품질로 시도하세요. |

---

## 더 많은 스킬

EvoLink 제공 스킬을 추가할 예정입니다. 업데이트를 기다리거나 [스킬 요청하기](https://github.com/EvoLinkAI/evolink-skills/issues).

---

## ClawHub에서 다운로드

이 스킬은 ClawHub에서 직접 설치할 수도 있습니다:

👉 **[ClawHub에서 다운로드 →](https://clawhub.ai/kn74p4xy6sja0199cea53anecs81kqjs/seedance-2-video-gen)**

---

## 라이선스

MIT

---

<p align="center">
  Powered by <a href="https://evolink.ai"><strong>EvoLink</strong></a> — Unified AI API Gateway
</p>
