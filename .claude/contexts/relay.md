# Relay Server Context (anclaw-relay)

> anclaw-relay 작업 시 참조. 자동 로드되지 않음 — 필요할 때 읽을 것.

## Overview

Android 앱과 웹 클라이언트 간 WebSocket 중계 서버. Railway에 호스팅. 프로덕션 운영 중.

## Tech Stack

```
Language:        Go 1.24
WebSocket:       gorilla/websocket v1.5.3
Auth:            golang-jwt/jwt v5.3.1
Database:        SQLite (mattn/go-sqlite3)
Utils:           google/uuid, golang.org/x/time (rate limiting)
Deploy:          Docker → Railway
```

## Build Commands

```bash
go build -o server ./cmd/server    # 바이너리 빌드
go run ./cmd/server                # 직접 실행
docker build -t anclaw-relay .     # Docker 이미지
```

## Architecture

```
cmd/
└── server/              # Entry point

internal/
├── auth/                # JWT 인증 + 토큰 처리
├── config/              # 설정 관리
├── hub/                 # WebSocket hub (연결 관리)
├── middleware/           # HTTP 미들웨어 (인증, 로깅)
├── model/               # 데이터 모델
├── store/               # SQLite 영속성
└── ws/                  # WebSocket 프로토콜 핸들러
```

## Key Features

- Android 앱 ↔ 웹 클라이언트 실시간 WebSocket 중계
- JWT 기반 인증
- SQLite 세션/사용자 데이터 영속성
- Rate limiting

## Repository

- **GitHub:** `1chang1/anclaw-relay`
- **호스팅:** Railway
- **독립 repo** — workspace에서 `.gitignore`로 제외
