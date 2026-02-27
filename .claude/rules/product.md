# Anclaw Product Context

## Core Concept

**"서랍 속 안 쓰는 안드로이드 폰 → 24/7 개인 AI 에이전트 서버"**

- 하드웨어 비용 0원 (기존 폰 활용)
- 비개발자도 앱 설치 한 번으로 AI 비서 구축
- Relay 서버(WebSocket) 통해 어디서든 접속
- 로컬 LLM으로 완전 무료 사용 가능

## Branding

- **이름**: Anclaw = An(droid) + Claw(집게발). 발음: 앤클로
- **도메인**: anclaw.ai (최우선)
- Claude/Clawd 연상 없음 (상표 안전). OpenClaw 사례 분석 후 결정.

## Competitive Positioning

**vs OpenClaw (PC 기반):** Docker만 불가, 나머지 동등. 하드웨어 비용 0원, 설치 난이도 "앱 한 번", 타겟 "누구나".

**vs ChatGPT/Claude 앱:** 실제 파일 생성/전달, 웹 크롤링, 로컬 코드 실행, 스킬 자동 생성, 스케줄링, 24/7 백그라운드, 무료(로컬 LLM) — 모두 Anclaw만 가능.

## Revenue Model

절대 건드리면 안 되는 것: 앱 유료화, 로컬 LLM 기능 제한, 광고.

| 우선순위 | 모델 | 설명 |
|---------|------|------|
| 1 | API 프록시 마진 | "원클릭 LLM 연결". API 키 발급이 귀찮은 사용자 대상. 토큰당 10~20% 마진 |
| 2 | Pro 구독 ($5~10/월) | 클라우드 백업, 멀티 디바이스 동기화, 고급 스케줄링 |
| 3 | 프리미엄 스킬 마켓 | 커뮤니티 무료 + 고급 스킬 유료 |
| 4 | B2B | 회사 폰 팜 + 관리 대시보드 |

## Development Roadmap

### Phase 1: Engine 2 (API) + Relay 연결 ✅ 완료
- ✅ Gradle 프로젝트 모듈화 (app + core/* 구조)
- ✅ Hilt DI 세팅
- ✅ Jetpack Compose UI + Navigation 3
- ✅ Relay WebSocket 연결 (Ktor Client, 자동 재연결, JWT 인증)
- ✅ API 키 입력 UI + EncryptedSharedPreferences
- ✅ Claude/GPT/Gemini/**Kimi** API 호출 (Ktor + SSE 스트리밍)
- ✅ Room으로 대화 히스토리 저장 (9개 테이블)
- ✅ Foreground Service (상시 구동, 부팅 자동 시작)
- ✅ Tool-calling 루프 (AgentLoop, 15개 도구)
- ✅ 시스템 프롬프트 R2 동적 로드 + 3단계 캐시

### Phase 2: Engine 1 (로컬 LLM) ✅ 완료
- ✅ Llamatik (llama.cpp) 기반 로컬 추론
- ✅ 모델 다운로드 매니저 (ModelDownloader)
- ✅ 로컬 추론 파이프라인 (LocalInferenceStrategy)
- ✅ 엔진 전환 UI (EngineManager)
- ✅ RAM 체크 (InsufficientMemoryException)

### Phase 3: proot 환경 통합 ✅ 완료
- ✅ proot 네이티브 바이너리 (armeabi-v7a, arm64-v8a)
- ✅ ShellExecutor 구현 (ProcessBuilder 기반)
- ✅ 명령어 검증 (CommandSanitizer)
- ✅ npm/pip 패키지 설치
- ✅ DevPreviewManager

### Phase 4: 웹 자동화 + 스킬 시스템 🟡 진행 중
- ✅ WebView + JS injection (WebViewAutomation, WebViewPool)
- ✅ 스킬 시스템 (SkillRegistry, SkillAutoGenerator, SKILL.md 파싱)
- ✅ WorkManager 기반 스케줄러 (ScheduleEngine + HeartbeatManager)
- ✅ 디바이스 제어 (DeviceController, 접근성 서비스, 오버레이)
- ✅ AI 메모리 시스템 (장기 기억 저장/검색)
- ❌ 스킬 마켓플레이스 UI (API만 구현)
- ❌ API 프록시 결제 시스템
- ❌ Telegram 통합

### Phase 5: 출시 준비 (다음)
- Play Store 출시 준비 (스크린샷, 설명, 심사)
- anclaw-web 배포 (Relay 웹 클라이언트)
- E2E 테스트 자동화
- 성능 최적화 + UI 폴리시
- CustomEngine 구현

## Platform Strategy

| 플랫폼 | 서버 | 클라이언트 |
|--------|------|-----------|
| Android | 핵심 (proot + Foreground Service) | 앱 UI + Relay |
| iOS | 불가 (샌드박스 제한) | anclaw-web (Relay 웹 클라이언트)으로 Android 서버 접속 |
| PC/Mac | - | anclaw-web으로 접속 |

## Ecosystem

| 프로젝트 | 역할 | 스택 | 상태 |
|---------|------|------|------|
| **anclaw** | Android 앱 (핵심) | Kotlin + Compose + Hilt | v0.2.0 |
| **anclaw-web** | Relay 웹 클라이언트 | React 19 + Vite + Zustand | 배포 준비 중 |
| **anclaw-config** | 시스템 프롬프트 + 모델 목록 관리 | JSON + Cloudflare R2 | 프로덕션 |
| **anclaw-landing** | 제품 소개 (anclaw.ai) | Astro 5 + Cloudflare Pages + D1 | 배포 완료 |
| **anclaw-design** | 브랜드 에셋 | Affinity Designer + SVG | 에셋 관리 |
| **anclaw-relay** | Relay 중계 서버 | Railway 호스팅 | 프로덕션 |

