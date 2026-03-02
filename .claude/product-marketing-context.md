# Product Marketing Context

*Last updated: 2026-03-03*

## Product Overview
**One-liner:** 앱을 직접 사용하는 AI Agent — 사람처럼 화면을 보고, 사람처럼 앱을 씁니다.
**What it does:** Anclaw는 Android 폰에 설치하면 AI가 화면을 보고 앱을 직접 조작합니다. Accessibility Service + proot + WebView를 활용해 API 없는 앱도 자동화합니다. 카카오톡 자동 응대, 쿠팡 가격 추적, 인스타 예약 포스팅, QA 테스트 자동화 등 사람이 할 수 있는 모든 앱 조작을 AI가 대신합니다.
**Product category:** AI Agent / App Automation
**Product type:** 모바일 앱 (Android)
**Business model:**
- 앱 자체: 무료
- 수익 1순위: API 프록시 마진 (원클릭 LLM 연결, 토큰당 10~20% 마진)
- 수익 2순위: Pro 구독 $5~10/월 (클라우드 백업, 멀티 디바이스 동기화, 고급 스케줄링)
- 수익 3순위: 프리미엄 스킬 마켓 (커뮤니티 무료 + 고급 스킬 유료)
- 수익 4순위: B2B (회사 폰 팜 + 관리 대시보드)

## Target Audience
**Target companies:** B2C 개인 사용자 + B2B (QA 팀, 마케팅 팀, 트레이딩)
**Decision-makers:** 앱 자동화가 필요한 모든 사용자 — 개인 자동화, QA 엔지니어, 마케터, 트레이더
**Primary use case:** API 없는 앱을 자연어로 자동화하고 싶은 사람
**Jobs to be done:**
- API 없는 앱(카톡, 인스타, 증권앱 등)을 자동화하고 싶다
- 코딩 없이 앱 테스트를 자동화하고 싶다
- 경쟁사 앱의 변화를 24시간 추적하고 싶다
- 조건부 매매/구매를 자동으로 실행하고 싶다
**Use cases:**
- 앱 자동화: 카톡 자동 응대, 쿠팡 가격 추적, 인스타 예약 포스팅
- 모바일 QA: 자연어 테스트 시나리오 → 실기기 실행
- 경쟁사 모니터링: 가격 변동, 신규 기능, 프로모션 추적
- 조건부 매매: 주식 조건 매수/매도, 한정판 자동 구매

## Personas
| Persona | Cares about | Challenge | Value we promise |
|---------|-------------|-----------|------------------|
| 자동화 얼리어답터 | 반복 작업 제거, 효율 | Zapier/Make는 API 필요, 앱은 못 건드림 | API 없어도 모든 앱 자동화 |
| QA 엔지니어 | 테스트 커버리지, 실기기 테스트 | Appium은 코딩 필수, 세팅 복잡 | 자연어로 테스트, 5분 셋업 |
| 마케터/PM | 경쟁사 동향, 빠른 대응 | 수작업 모니터링은 비효율적 | 24시간 경쟁사 앱 모니터링 |
| 트레이더 | 타이밍, 자동 실행 | 증권앱 API 없음, 수동 매매 | 조건 설정 → AI가 직접 앱에서 실행 |

## Problems & Pain Points
**Core problem:** 대부분의 앱에는 API가 없어서 자동화가 불가능하다. 있어도 복잡하고, 코딩이 필요하다.
**Why alternatives fall short:**
- Gemini: 구글 자체 앱 3개만 제어 가능, 범용 앱 자동화 불가
- Zapier/Make: API 있는 서비스만 연동 가능, 앱 UI 조작 불가
- OpenClaw: PC 기반, Docker 필수, 비개발자 진입장벽
- Appium: 코딩 필수, 세팅 복잡, QA 전용
**What it costs them:** 수작업으로 반복 작업, 코딩 의뢰 비용, 모니터링 인력
**Emotional tension:** "이 앱 자동화하고 싶은데 API가 없다." "Zapier로는 안 되는 앱이 너무 많다." "Appium 세팅만 하루 걸렸다."

## Competitive Landscape
**Direct:** Gemini (앱 제어 제한적), OpenClaw (PC 기반)
**Secondary:** Zapier/Make (API 의존), Appium (코드 필수)
**Indirect:** 수작업, 매크로 앱 (터치 좌표 기반, 깨지기 쉬움)

## Differentiation
**Key differentiators:**
- API 불필요 — 화면만 있으면 모든 앱 자동화
- 코딩 불필요 — 자연어로 지시
- 24/7 무인 실행 — Foreground Service + Accessibility Service
- 5분 셋업 — 앱 설치 한 번
- 실기기에서 실행 — 에뮬레이터가 아닌 진짜 앱
**How we do it differently:** Accessibility Service로 화면을 읽고 앱을 조작, proot으로 Linux 명령 실행, WebView로 웹 자동화. LLM이 아니라 실행 환경이 핵심.
**Why that's better:** API 제약에서 자유로움, 비개발자도 사용 가능, 실기기 테스트 가능.
**Why customers choose us:** "API 없는 앱도 되니까." "코딩 안 해도 되니까." "설치하고 5분이면 끝나니까."

## Objections
| Objection | Response |
|-----------|----------|
| "어떤 앱이든 되나?" | 사람이 쓸 수 있는 모든 앱이 됩니다. 화면에 보이면 자동화됩니다. |
| "보안은?" | TBD — 출시 전 상세 보안 정책 공개 예정. |
| "비용은?" | LLM API 비용만 (보통 월 $1~5). 앱 자동화 자체는 무료. |

**Anti-persona:**
- Docker/Linux 세팅을 즐기는 하드코어 개발자 (→ OpenClaw)
- 엔터프라이즈급 SLA가 필요한 기업 (→ 전용 솔루션)
- iOS만 사용하는 사람 (Android 필요)

## Switching Dynamics
**Push:** 앱 API 없음, Zapier/Make 한계, Appium 세팅 복잡, 수작업 비효율
**Pull:** 모든 앱 자동화, 자연어 조작, 5분 셋업, 24/7 무인
**Habit:** 수작업에 익숙, "API가 없으면 안 되지" 고정관념
**Anxiety:** "진짜 모든 앱이 되나?", "복잡한 거 아니야?", "보안은?"

## Customer Language
**How they describe the problem:**
- "이 앱 자동화하고 싶은데 API가 없다"
- "Zapier로 안 되는 앱이 너무 많다"
- "매일 같은 작업을 수동으로 하고 있다"
- "Appium 세팅만 하루 걸렸다"
**How they describe us:**
- "AI가 앱을 직접 써주는 거"
- "코딩 없이 앱 자동화하는 앱"
- "자연어로 앱 테스트하는 도구"
**Words to use:** 앱 자동화, 화면을 보고, 직접 조작, 자연어, API 불필요, 코딩 불필요, 모든 앱, 5분 셋업
**Words to avoid:** 매크로, RPA, 봇, 서버, Docker, 로컬 LLM, 온디바이스, proot (기술 용어)
**Glossary:**
| Term | Meaning |
|------|---------|
| AI Agent | 사용자 대신 앱을 직접 조작하는 AI |
| 앱 자동화 | API 없이 앱의 화면을 보고 조작하는 것 |
| 자연어 조작 | "OO 해줘"라고 말하면 AI가 실행하는 것 |
| 스킬 | 반복 작업을 자동화하는 재사용 가능한 AI 능력 단위 |

## Brand Voice
**Tone:** 직접적이고 명확함. 기술적이지 않은. 결과 중심.
**Style:** 짧은 문장, 구체적 예시 (카톡, 쿠팡, 인스타), 대비 강조 (불가 vs 가능)
**Personality:** 실용적, 자신감 있는, 문제 해결 중심

## Proof Points
**Metrics:**
- 5분 셋업 (vs Appium 수시간)
- API 불필요 (vs Zapier API 필수)
- 모든 앱 자동화 (vs Gemini 3개 앱)
- 자연어 조작 (vs Appium 코드 필수)
**Customers:** 프리런치 — 웨이트리스트 수집 중
**Testimonials:** 아직 없음 (출시 전)
**Value themes:**
| Theme | Proof |
|-------|-------|
| 범용성 | API 없는 앱도 자동화, 화면만 있으면 됨 |
| 접근성 | 코딩 불필요, 자연어 지시, 5분 셋업 |
| 상시 실행 | 24/7 Foreground Service, 무인 운영 |
| 다목적 | 자동화, QA, 모니터링, 매매 — 하나의 앱으로 |

## Goals
**Business goal:** Play Store 출시 → 웨이트리스트 전환 → PMF 검증
**Conversion action:** 웨이트리스트 이메일 등록 + 용도 설문 (anclaw.ai)
**Current metrics:** 프리런치 단계 (PMF fake test 진행 중)
