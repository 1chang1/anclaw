# /version-bump — Anclaw 버전 업데이트

인자: `$ARGUMENTS` (예: "patch", "minor", "major", 또는 구체적 설명)

## 실행 절차

1. **현재 버전 확인**: `app/build.gradle.kts`에서 `versionName`과 `versionCode` 읽기

2. **버전 결정**:
   - `$ARGUMENTS`가 "patch", "minor", "major" 중 하나면 해당 컴포넌트를 1 올림
   - 그 외 텍스트면 변경 내용을 분석하여 적절한 bump 수준 판단:
     - **major**: 호환성 깨지는 변경 (breaking change)
     - **minor**: 새 기능 추가 (feat)
     - **patch**: 버그 수정, 리팩토링 등 (fix, refactor, chore)
   - 판단이 애매하면 사용자에게 질문

3. **파일 수정** (`app/build.gradle.kts`):
   - `versionName` → 새 버전 문자열 (예: "0.2.0")
   - `versionCode` → 기존 값 + 1

4. **Git 태그 생성**:
   - 변경사항을 커밋: `chore: bump version to {새 버전}`
   - 태그 생성: `git tag v{새 버전}`

5. **결과 출력**: 이전 버전 → 새 버전, versionCode, 태그 이름

## 버전 규칙

- 형식: `major.minor.patch` (Semantic Versioning)
- `versionCode`는 항상 1씩 증가 (Play Store 요구사항)
- 태그 형식: `v{major}.{minor}.{patch}`
- major 올릴 때 minor와 patch는 0으로 리셋
- minor 올릴 때 patch는 0으로 리셋
