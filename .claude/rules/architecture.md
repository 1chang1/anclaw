# Anclaw System Architecture

> MVVM + Clean Architecture (Google 공식 권장) 기반. Now in Android 참조.

## 전체 구조

```
[anclaw-web]  [앱 UI]
     │            │
     └────┬───────┘
          ↕ WebSocket
   [anclaw-relay (Railway)]
          ↕ WebSocket
[Android App: Anclaw — AgentForegroundService]
    │
    ├─ UI Layer (app/ 모듈, Jetpack Compose + Material 3)
    │   ├─ Welcome → AiConnect → RelaySetup → SetupComplete (셋업 플로우)
    │   ├─ Main: Dashboard + Conversations (탭)
    │   ├─ Chat (대화 화면, 마크다운/코드블록/ToolCall 렌더링)
    │   └─ Settings (Engine, Skills, System, Debug 탭)
    │
    ├─ Engine Layer (:core:engine + app/engine)
    │   ├─ ApiEngine — Claude / GPT / Gemini / Kimi (4 제공자, Ktor SSE)
    │   ├─ LocalEngine — Llamatik (llama.cpp) 로컬 추론
    │   ├─ AgentLoop — Tool-calling 루프 (15개 도구)
    │   ├─ ToolExecutor — 도구 실행 (web_search, execute_command 등)
    │   └─ EngineManager — 엔진 전환 관리
    │
    ├─ Data Layer (:core:data)
    │   ├─ Room DB (9 테이블: messages, conversations, memory, tool_calls,
    │   │   skills, local_models, usage, schedule_jobs, app_recipes)
    │   ├─ ConversationRepository, SkillRepository
    │   └─ SQLCipher 암호화 (선택)
    │
    ├─ Network Layer (:core:network)
    │   ├─ ClaudeApiClient, OpenAiApiClient, GeminiApiClient, KimiApiClient
    │   ├─ RemoteConfigService — R2 시스템 프롬프트 동적 로드
    │   └─ DuckDuckGoSearchClient — 웹 검색
    │
    ├─ Relay Layer (:core:relay)
    │   ├─ RelayClient — WebSocket 연결 (자동 재연결, JWT 인증)
    │   ├─ RelayMessageHandler — 메시지 라우팅
    │   └─ RelayStreamingSender — 스트리밍 응답 전송
    │
    ├─ proot Layer (:core:proot)
    │   ├─ ShellExecutorImpl — ProcessBuilder 기반 명령 실행
    │   ├─ ProotEnvironment — proot 환경 관리
    │   ├─ CommandSanitizer — 명령어 검증
    │   └─ RuntimeInstaller — proot 자동 설치
    │
    ├─ WebView Layer (:core:webview)
    │   ├─ WebViewAutomation — evaluateJavascript() JS injection
    │   ├─ WebPageFetcher — 페이지 fetching
    │   └─ WebViewPool — 성능 최적화 (풀링)
    │
    ├─ Device Layer (:core:device + :core:accessibility + :core:overlay)
    │   ├─ DeviceController — 디바이스 제어
    │   ├─ AnclawAccessibilityService — 접근성 기반 UI 자동화
    │   └─ DeviceControlOverlayManager — 화면 오버레이
    │
    ├─ 시스템 프롬프트 (anclaw-config R2에서 로드)
    │   ├─ SystemPromptBuilder — 3-Tier 프롬프트 조합
    │   ├─ SelfKnowledge — 오프라인 fallback
    │   └─ 3단계 캐시: 메모리(24h) → SharedPrefs → Hardcoded
    │
    └─ Android Native
        ├─ AgentForegroundService — 상시 구동 (30+ 의존성 주입)
        ├─ BootReceiver — 부팅 후 자동 시작
        ├─ WorkManager + ScheduleEngine + HeartbeatManager — 스케줄링
        └─ EncryptedSharedPreferences — API 키/토큰 암호화
```

## 데이터 흐름 (UDF)

```
사용자 (앱 UI / Relay)
    │ 메시지/이벤트 (↑ Events)
    ▼
ViewModel (UI State 관리)
    │ UseCase 호출
    ▼
UseCase (비즈니스 로직)
    │ Repository 호출
    ▼
Repository (데이터 조율)
    ├─ Room (로컬 SSOT) ←→ LLM API (원격)
    │
    ▼ StateFlow (↓ State)
UI (Compose) — collectAsStateWithLifecycle()
```

## LLM 엔진 상세

### Engine 1: 로컬 LLM (무료) ✅
- **라이브러리:** Llamatik 0.15 (llama.cpp 기반)
- **모델:** Gemma 2B, Phi-3 Mini, Llama 3.2 1B 등 (동적 다운로드)
- **요구:** RAM 4GB+ (InsufficientMemoryException으로 사전 체크)
- **전략:** LocalInferenceStrategy — Tool-calling 지원
- **장점:** 오프라인, 프라이버시, 비용 0원

### Engine 2: API 키 (메인) ✅
- **지원:** Anthropic Claude, OpenAI GPT, Google Gemini, **Moonshot Kimi** (4개 제공자)
- **호출:** Ktor Client로 직접 HTTP 호출 (스트리밍: SSE)
- **저장:** EncryptedSharedPreferences로 API 키 암호화
- **도구:** AgentLoop + ToolExecutor (15개 도구)
- **모델 목록:** anclaw-config R2에서 동적 로드 (models.json)

### Engine 3: 커스텀 (고급) ❌ 미구현
- 설정 깊숙이 숨김. 앱이 유도하지 않음
- 사용자 책임 하에 사용

모든 엔진은 동일한 `LLMEngine` 인터페이스 구현. 엔진 전환 UI 제공.

## proot Linux 환경

Termux proot-distro 방식. 앱 내부에 Linux 환경 임베딩.

| 가능 | 불가 |
|------|------|
| npm/pip install | Docker/Snap/Flatpak |
| Git push/pull/clone | GPU 가속 |
| Node.js/Python 실행 | 하드웨어 직접 접근 |
| React 빌드 + Firebase 배포 | systemd (→ Foreground Service) |
| HTTP 요청, 파일 CRUD | Puppeteer (→ WebView) |
| llama.cpp, 웹 서버 | |

- proot 오버헤드: PC 대비 2~5배 느림 (대부분 I/O 바운드라 실용적)
- proot 파일시스템과 Android 파일시스템은 분리. 파일 공유 시 복사 필요
- JNI를 통한 네이티브 브릿지로 Kotlin ↔ proot 통신

## 웹 자동화

- Android WebView + `evaluateJavascript()` → JS injection
- DOM 조작, 데이터 추출, 브라우저 자동화
- Puppeteer/Playwright 불가 (proot Chromium 바이너리 제한)

## 스킬 시스템 ✅

- SKILL.md 형식 (마크다운 + JSON 메타데이터)
- **SkillRegistry** — 스킬 카탈로그 관리
- **SkillAutoGenerator** — 대화에서 자동 생성
- **SkillMarkdownParser** — SKILL.md 파싱
- Room `skills` 테이블에 저장
- 마켓플레이스 API 구현 (UI는 미완)

## 스케줄링 시스템 ✅

- **ScheduleEngine** — 작업 스케줄 관리
- **HeartbeatManager** — 주기적 실행 (heartbeat)
- **WorkManager** 기반 백그라운드 실행
- Room `schedule_jobs` 테이블에 저장

## 메모리 시스템 ✅

- AI 장기 기억 저장/검색
- Room `memory` 테이블
- 시스템 프롬프트에 자동 포함

## 생태계 연동

```
anclaw-config (Cloudflare R2)
├─ prompts/0.1.0.json    → SystemPromptBuilder가 동적 로드
├─ prompts/index.json    → 버전 관리
└─ models.json           → 모델 목록 + 가격 정보

anclaw-relay (Railway)
└─ WebSocket 중계       → RelayClient가 연결

anclaw-web (React 19)
└─ Relay 웹 클라이언트   → PC/iOS에서 접속
```
