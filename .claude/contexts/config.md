# Config Context (anclaw-config)

> anclaw-config 작업 시 참조. 자동 로드되지 않음 — 필요할 때 읽을 것.

## Overview

시스템 프롬프트 + LLM 모델 목록을 Cloudflare R2에서 원격 관리. 프로덕션 운영 중.

## Structure

```
anclaw-config/
├── models.json           # LLM 모델 목록 (앱이 동적 로드)
├── prompts/
│   ├── index.json        # 버전 매니페스트 + latest 포인터
│   └── 0.1.0.json        # 시스템 프롬프트 데이터 (Tier 1)
├── upload.sh             # R2 업로드 스크립트 (validate 자동 실행)
├── validate.sh           # JSON 스키마 검증
└── wrangler.toml         # Cloudflare Workers 설정
```

**빌드 시스템 없음** — JSON + Shell 스크립트만.

## Key Operations

```bash
bash upload.sh            # validate + R2 업로드
bash validate.sh          # JSON 스키마 검증
```

**중요:** 프롬프트 수정 후 반드시 `upload.sh` 실행. 안 하면 디바이스에 이전 버전 캐시 유지.

## R2 Public URLs

```
https://pub-942ef69572124bd1aba1513dd3590981.r2.dev/models.json
https://pub-942ef69572124bd1aba1513dd3590981.r2.dev/prompts/index.json
https://pub-942ef69572124bd1aba1513dd3590981.r2.dev/prompts/0.1.0.json
```

## 3-Tier Prompt System

| Tier | 내용 | 위치 |
|------|------|------|
| **System** | identity, behaviorRules, knowledge | R2 (이 repo) |
| **Application** | tool list (SSOT) | 앱 코드 `ToolDefinitions.kt` |
| **User** | SOUL, profiles, memories | 디바이스 로컬 (Room DB) |

앱 측 캐시: 메모리(24h TTL) → SharedPreferences → Hardcoded fallback

## Repository

- **GitHub:** `1chang1/anclaw-config`
- **독립 repo** — workspace에서 `.gitignore`로 제외
