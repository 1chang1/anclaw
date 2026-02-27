# /anclaw-debug — Anclaw ADB Debug Bridge

ADB를 통해 Anclaw 앱의 내부 상태를 조회하고 액션을 실행합니다.
디바이스가 USB 또는 WiFi ADB로 연결되어 있어야 합니다.

## 사용법

`/anclaw-debug <command> [args...]`

## Commands

### 읽기 (query)

| Command | 설명 |
|---------|------|
| `status` | 앱 전체 상태 (서비스, 엔진, relay) |
| `engine` | 엔진 상세 (타입, 모델, provider, 가용성) |
| `conversations` | 최근 대화 목록 + 메타데이터 |
| `tools` | 도구 정의 목록 |
| `metrics` | 성능 메트릭 집계 |
| `logs [tag] [level]` | 구조화 로그 (선택: tag, level 필터) |
| `device` | 디바이스 정보 (배터리, 메모리, 스토리지) |
| `config` | 현재 설정값 |

### 액션 (call)

| Command | 설명 |
|---------|------|
| `restart-engine` | 엔진 재시작 |
| `switch-engine <api\|local>` | 엔진 타입 전환 |
| `test-message <message>` | 테스트 메시지 dry run |
| `exec-tool <tool-name> <json-input>` | 도구 직접 실행 |
| `clear-cache` | 로그/메트릭 캐시 클리어 |

## 실행

$ARGUMENTS 파싱:

```bash
# 인자가 없거나 "status"면 기본 상태 조회
ARGS="$ARGUMENTS"
CMD=$(echo "$ARGS" | awk '{print $1}')
REST=$(echo "$ARGS" | cut -d' ' -f2-)

case "$CMD" in
  ""| "status")
    adb shell content query --uri content://ai.anclaw.agent.debug/status 2>&1
    ;;
  "engine")
    adb shell content query --uri content://ai.anclaw.agent.debug/engine 2>&1
    ;;
  "conversations")
    adb shell content query --uri content://ai.anclaw.agent.debug/conversations 2>&1
    ;;
  "tools")
    adb shell content query --uri content://ai.anclaw.agent.debug/tools 2>&1
    ;;
  "metrics")
    adb shell content query --uri content://ai.anclaw.agent.debug/metrics 2>&1
    ;;
  "logs")
    TAG_PARAM=$(echo "$REST" | awk '{print $1}')
    LEVEL_PARAM=$(echo "$REST" | awk '{print $2}')
    URI="content://ai.anclaw.agent.debug/logs"
    QUERY_PARAMS=""
    if [ -n "$TAG_PARAM" ]; then QUERY_PARAMS="?tag=$TAG_PARAM"; fi
    if [ -n "$LEVEL_PARAM" ]; then
      if [ -n "$QUERY_PARAMS" ]; then QUERY_PARAMS="$QUERY_PARAMS&level=$LEVEL_PARAM"
      else QUERY_PARAMS="?level=$LEVEL_PARAM"; fi
    fi
    adb shell content query --uri "${URI}${QUERY_PARAMS}" 2>&1
    ;;
  "device")
    adb shell content query --uri content://ai.anclaw.agent.debug/device 2>&1
    ;;
  "config")
    adb shell content query --uri content://ai.anclaw.agent.debug/config 2>&1
    ;;
  "restart-engine")
    adb shell content call --uri content://ai.anclaw.agent.debug/ --method restart_engine 2>&1
    ;;
  "switch-engine")
    ENGINE_TYPE=$(echo "$REST" | awk '{print $1}')
    adb shell content call --uri content://ai.anclaw.agent.debug/ --method switch_engine --arg "$ENGINE_TYPE" 2>&1
    ;;
  "test-message")
    adb shell content call --uri content://ai.anclaw.agent.debug/ --method send_test_message --arg "$REST" 2>&1
    ;;
  "exec-tool")
    TOOL_NAME=$(echo "$REST" | awk '{print $1}')
    JSON_INPUT=$(echo "$REST" | cut -d' ' -f2-)
    # Format: tool_name|{json} — pipe delimiter avoids ADB colon conflict
    adb shell content call --uri content://ai.anclaw.agent.debug/ --method execute_tool --arg "${TOOL_NAME}|${JSON_INPUT}" 2>&1
    ;;
  "clear-cache")
    adb shell content call --uri content://ai.anclaw.agent.debug/ --method clear_cache 2>&1
    ;;
  *)
    echo "Unknown command: $CMD"
    echo "Available: status, engine, conversations, tools, metrics, logs, device, config"
    echo "Actions: restart-engine, switch-engine, test-message, exec-tool, clear-cache"
    ;;
esac
```

위 bash 블록을 실행하여 결과를 사용자에게 보여주세요. JSON 결과는 포맷팅하여 읽기 쉽게 표시합니다.
