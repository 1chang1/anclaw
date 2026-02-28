#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "==> buf lint"
buf lint

echo "==> buf generate"
buf generate

echo "==> 각 프로젝트로 복사"

# Go (anclaw-relay)
mkdir -p ../anclaw-relay/gen/relayv1
cp -r gen/go/anclaw/relay/v1/* ../anclaw-relay/gen/relayv1/

# Kotlin (anclaw-app)
mkdir -p ../anclaw-app/proto-gen/src/main/java/
cp -r gen/kotlin/* ../anclaw-app/proto-gen/src/main/java/

# TypeScript (anclaw-web)
mkdir -p ../anclaw-web/src/shared/proto/
cp -r gen/ts/anclaw/relay/v1/* ../anclaw-web/src/shared/proto/

echo "Done. 각 서브 프로젝트에서 커밋해주세요."
