# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Workspace Overview

**Anclaw** — 서랍 속 안 쓰는 안드로이드 폰을 24/7 개인 AI 에이전트 서버로 변환하는 제품 생태계.

이 workspace는 Anclaw 제품을 구성하는 6개 서브 프로젝트를 하나로 묶는 container repo.

## Sub-Projects

| 폴더 | 설명 | 스택 | 상태 | GitHub |
|------|------|------|------|--------|
| `anclaw-app/` | Android 앱 — 핵심. AI 에이전트 + Relay 서버 | Kotlin + Compose + Hilt | v0.2.0, ~75% | `1chang1/anclaw-app` |
| `anclaw-web/` | Relay 웹 클라이언트 — PC/iOS 원격 접속 | React 19 + Vite + Zustand + Tailwind | ~85% | `1chang1/anclaw-web` |
| `anclaw-landing/` | 제품 랜딩 (anclaw.ai) | Astro 5 + Tailwind + Cloudflare Pages | 배포 완료 | `1chang1/anclaw-landing` |
| `anclaw-config/` | 시스템 프롬프트 + 모델 관리 | JSON + Cloudflare R2 | 프로덕션 | `1chang1/anclaw-config` |
| `anclaw-relay/` | WebSocket 중계 서버 | Go 1.24 + gorilla/websocket | 프로덕션 | `1chang1/anclaw-relay` |
| `anclaw-design/` | 브랜드 에셋 | Affinity Designer + SVG | 에셋 관리 | 없음 |

각 서브 프로젝트는 독립 git repo (workspace `.gitignore`로 제외).

## Project Relations

```
anclaw-app (Android) ← 핵심. Relay 서버 + AI 에이전트 구동
    ↕ WebSocket
anclaw-relay (Railway) ← WebSocket 중계
    ↕ WebSocket
anclaw-web (React) ← PC/iOS에서 원격 접속 UI

anclaw-config (R2) → anclaw-app이 시스템 프롬프트 + 모델 목록을 동적 로드
anclaw-landing (anclaw.ai) ← 제품 소개 + 출시 알림 수집
anclaw-design ← 브랜드 에셋 원본 (로고, 심볼)
```

## Context Files

**`.claude/rules/`** — Claude Code가 자동 로드. 제품 전체에 적용되는 규칙:
- `product.md` — 제품 컨셉, 경쟁 분석, 수익 모델, 로드맵
- `architecture.md` — 시스템 아키텍처, 엔진, 데이터 흐름, 생태계 연동

**`.claude/contexts/`** — 자동 로드되지 않음. 특정 서브 프로젝트 작업 시 필요에 따라 읽을 것:
- `app.md` — Android 앱 (스택, 빌드, 모듈, 인터페이스, 아이콘, 프롬프트 동기화)
- `web.md` — Relay 웹 클라이언트 (React, Vite, Zustand, FSD)
- `landing.md` — 랜딩 페이지 (Astro, Tailwind, Cloudflare Pages, i18n)
- `config.md` — R2 프롬프트/모델 관리 (구조, 배포, 캐시)
- `relay.md` — Relay 서버 (Go, WebSocket, JWT, Railway)
- `design.md` — 브랜드 에셋 (Affinity Designer, SVG)

## Common Rules

- **의사소통 언어:** 한국어. 기술 용어와 고유명사는 영어 그대로 사용.
- 코드 식별자(변수명, 함수명 등)는 영어.
- 각 서브 프로젝트의 세부 규칙은 해당 폴더의 `CLAUDE.md`가 우선.
