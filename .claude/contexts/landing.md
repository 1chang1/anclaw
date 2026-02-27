# Landing Page Context (anclaw-landing)

> anclaw-landing 작업 시 참조. 자동 로드되지 않음 — 필요할 때 읽을 것.

## Overview

제품 소개 랜딩 페이지 (anclaw.ai). Cloudflare Pages에 배포 완료.

## Tech Stack

```
Framework:       Astro 5.17 (static SSG) + React islands
Styling:         Tailwind CSS 4.1
Animation:       Framer Motion 12.34
Font:            Pretendard (Korean/Latin)
i18n:            Custom Astro routing (/ko/, /en/)
Deploy:          Cloudflare Pages + Wrangler CLI
OG Images:       Satori + Resvg (빌드 타임 생성)
```

## Build Commands

```bash
npm run dev           # Astro dev server
npm run build         # Generate OG + astro check + build
npm run deploy        # Build + wrangler pages deploy
npm run preview       # Preview built site
npm run generate:og   # Generate OG images
```

## Architecture

- `.astro` 파일 = 정적 HTML (빌드 시 0 JS)
- `.tsx` 파일 = React islands (`client:load` / `client:visible`)
- i18n: 타입 세이프 번역 시스템 (`src/i18n/`)
- 다크 모드: 인라인 스크립트 (FOUC 방지)

## Key Paths

```
src/pages/ko/index.astro      # 한국어 랜딩
src/pages/en/index.astro      # 영어 랜딩
src/i18n/                     # 번역 파일
src/components/               # 컴포넌트 (hero, features 등)
src/layouts/BaseLayout.astro  # HTML shell
src/styles/global.css         # Tailwind + 브랜딩
```

## Repository

- **GitHub:** `1chang1/anclaw-landing`
- **독립 repo** — workspace에서 `.gitignore`로 제외
