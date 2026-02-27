# Relay Web Client Context (anclaw-web)

> anclaw-web 작업 시 참조. 자동 로드되지 않음 — 필요할 때 읽을 것.

## Overview

PC/iOS에서 Android Anclaw 서버에 원격 접속하는 Relay 웹 클라이언트. 구현 ~85%.

## Tech Stack

```
Framework:       React 19.2 + Vite 7.3
State:           Zustand 5.0
UI:              Radix UI (headless) + Tailwind CSS 4.2 + Framer Motion 12
Markdown:        React Markdown + Shiki (syntax highlighting) + KaTeX (math)
Router:          React Router 7.13
Storage:         idb (IndexedDB wrapper) — 오프라인 캐시
Testing:         Vitest 4.0 + @testing-library/react + JSDOM
Linting:         ESLint 9.39 + Prettier 3.8
Language:        TypeScript 5.9 (strict)
```

## Build Commands

```bash
npm run dev              # Dev server (Vite)
npm run build            # TypeScript check + Vite build
npm run typecheck        # tsc --noEmit
npm run test             # vitest run
npm run test:watch       # Watch mode
npm run test:coverage    # Coverage report
npm run lint:fix         # ESLint auto-fix
```

## Architecture (Feature-Sliced Design 변형)

```
src/
├── app/          # Entry point, store setup
├── pages/        # Page routes
├── features/     # Feature modules (conversations, messages, etc.)
├── widgets/      # Reusable UI components
├── shared/       # Utilities, hooks, constants
├── entities/     # Domain models
└── assets/       # Static files
```

의존성 방향: `pages → features → widgets → shared → entities`

## Key Features

- WebSocket으로 Relay 서버와 실시간 통신
- Zustand로 대화/메시지 상태 관리
- IndexedDB 오프라인 캐시
- 마크다운 렌더링 (코드 하이라이팅 + LaTeX 수식)
- Radix UI 기반 접근성 우선 컴포넌트

## Repository

- **GitHub:** `1chang1/anclaw-web`
- **독립 repo** — workspace에서 `.gitignore`로 제외
