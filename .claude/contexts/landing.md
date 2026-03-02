# Landing Page Context (anclaw-landing)

> anclaw-landing 작업 시 참조. 자동 로드되지 않음 — 필요할 때 읽을 것.

## Overview

PMF fake test용 범용 랜딩 페이지 (anclaw.ai). Cloudflare Pages에 배포.
핵심 메시지: "앱을 직접 사용하는 AI Agent"

## Tech Stack

```
Framework:       Astro 5.17 (static SSG) + React islands
Styling:         Tailwind CSS 4.1
Animation:       Framer Motion 12.34
Font:            Pretendard (Korean/Latin)
i18n:            Custom Astro routing (/ko/, /en/)
Deploy:          Cloudflare Pages + Wrangler CLI
OG Images:       Satori + Resvg (빌드 타임 생성)
DB:              Cloudflare D1 (waitlist)
Bot Protection:  Cloudflare Turnstile
```

## Build Commands

```bash
npm run dev           # Astro dev server
npm run build         # Generate OG + astro check + build
npm run deploy        # Build + wrangler pages deploy
npm run preview       # Preview built site
npm run generate:og   # Generate OG images
```

## Page Structure

```
Header (sticky CTA 버튼 — 스크롤 시 표시)
├─ 1. Hero          — "앱을 직접 사용하는 AI Agent" + PhoneVisual 3단계 애니메이션
├─ 2. Use Cases     — 4가지 사용 사례 (자동화 / QA / 모니터링 / 조건부 매매)
├─ 3. How It Works  — 3단계 (설치 → 지시 → 결과)
├─ 4. Comparison    — 6열 비교 (수작업/Gemini/Zapier/OpenClaw/Appium/Anclaw)
├─ 5. FAQ           — 5개 질문
└─ 6. CTA           — 이메일 + 용도 설문 + UTM 캡처 + waitlist 카운터
Footer
```

## Key Paths

```
src/pages/ko/index.astro      # 한국어 랜딩
src/pages/en/index.astro      # 영어 랜딩
src/i18n/                     # 번역 파일 (types.ts, ko.ts, en.ts)
src/components/
  hero/                       # HeroSection, HeroContent, PhoneVisual
  usecases/                   # UseCasesSection, UseCaseCards
  howitworks/                 # HowItWorksSection, Steps
  comparison/                 # ComparisonSection, ComparisonTable (7열)
  faq/                        # FAQSection, FAQAccordion
  cta/                        # CTASection, CTAContent (설문 + UTM + 카운터)
  common/                     # Header (sticky CTA), Footer, NavLinks
src/layouts/BaseLayout.astro  # HTML shell + JSON-LD
src/styles/global.css         # Tailwind + 브랜딩
functions/api/
  waitlist.ts                 # POST — 이메일 + 설문 + UTM 저장
  waitlist-count.ts           # GET — waitlist 카운트 반환
scripts/generate-og.ts        # OG 이미지 생성
```

## UTM Tracking

1. 랜딩 로드 시 URL에서 UTM 파싱 → sessionStorage 저장
2. CTA 폼 제출 시 sessionStorage UTM 값 함께 전송
3. D1 waitlist 테이블에 저장 (use_case, utm_source, utm_medium, utm_campaign, utm_content)
4. 광고 URL: `anclaw.ai/ko/?utm_source=google&utm_medium=cpc&utm_campaign=automation`

## D1 Schema

```sql
-- 기존 + 신규 컬럼
CREATE TABLE waitlist (
  email TEXT PRIMARY KEY,
  locale TEXT,
  use_case TEXT,
  utm_source TEXT,
  utm_medium TEXT,
  utm_campaign TEXT,
  utm_content TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## Repository

- **GitHub:** `1chang1/anclaw-landing`
- **독립 repo** — workspace에서 `.gitignore`로 제외
