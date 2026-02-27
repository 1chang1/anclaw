# Android App Context (anclaw-app)

> anclaw-app 작업 시 참조. 자동 로드되지 않음 — 필요할 때 읽을 것.

## Tech Stack

```
Language:        Kotlin 2.2 (K2 compiler)
Build:           Gradle 8.x + AGP 9.x + Version Catalogs + Convention Plugins
UI:              Jetpack Compose (BOM 2026.01.01)
Design System:   Material 3 (1.4.x)
Navigation:      Navigation 3 (1.0.x) — Compose-first, 개발자가 back stack 소유
Architecture:    MVVM + Clean Architecture (UI → Domain → Data)
DI:              Hilt 2.59 (compile-time safety)
State:           ViewModel + StateFlow + collectAsStateWithLifecycle()
Networking:      Ktor Client 3.1 (coroutine-native, SSE/WebSocket)
Local Storage:   Room 2.8 (KSP) + DataStore
Security:        EncryptedSharedPreferences (API 키 암호화)
Background:      Foreground Service + WorkManager
Async:           Kotlin Coroutines + Flow
Annotation:      KSP2 (KAPT 아님)
Testing:         JUnit 5 + Compose Test + Robolectric + Turbine
Icons:           Lucide (Material Icons 사용 금지)
```

## Build Commands

```bash
./gradlew assembleDebug          # Debug APK 빌드
./gradlew assembleRelease        # Release APK 빌드
./gradlew test                   # JVM 유닛 테스트
./gradlew test --tests "ai.anclaw.agent.SomeTest"  # 단일 테스트
./gradlew connectedAndroidTest   # 인스트루먼트 테스트 (디바이스 필요)
./gradlew clean                  # 클린 빌드
```

## Project Config

- **Package**: `ai.anclaw.agent`
- **Build**: Gradle + Kotlin DSL, AGP 9.0.0
- **Version catalog**: `gradle/libs.versions.toml`
- **SDK**: minSdk 30, compileSdk 36, targetSdk 36
- **Version**: 0.2.0 (versionCode 2)

## Module Structure

```
app/                          # Entry point, UI 화면, Navigation, ViewModel
core/
├── model/                    # 도메인 모델 (Message, Conversation, ToolCall 등)
├── data/                     # Room DB (9 테이블), Repository, DAO
├── network/                  # API 클라이언트 (Claude, GPT, Gemini, Kimi)
├── engine/                   # LLM 엔진 (LocalEngine, AgentLoop, ToolRunner)
├── relay/                    # Relay WebSocket 클라이언트
├── proot/                    # proot Linux 쉘 실행
├── webview/                  # WebView 자동화
├── device/                   # 디바이스 제어
├── accessibility/            # 접근성 서비스
├── overlay/                  # 오버레이 UI
├── adb/                      # ADB 연결
├── designsystem/             # Material 3 테마, Lucide 아이콘
├── common/                   # 유틸리티
└── telegram/                 # Telegram 통합 (미구현)
build-logic/                  # Convention Plugins
```

## Key Paths

- `app/src/main/java/ai/anclaw/agent/` — UI, ViewModel, Navigation, 엔진 관리
- `core/*/src/main/java/ai/anclaw/agent/core/` — 핵심 비즈니스 로직
- `app/src/main/AndroidManifest.xml` — 앱 매니페스트
- `gradle/libs.versions.toml` — 의존성 버전 관리
- `app/src/test/` — JVM 유닛 테스트
- `app/src/androidTest/` — 인스트루먼트 테스트

## Architecture Layers (3-Layer + Clean Architecture)

```
┌─────────────────────────────────────┐
│           UI Layer                  │
│  Compose Screen → ViewModel        │
│  State: StateFlow, Events: 위로↑   │
├─────────────────────────────────────┤
│         Domain Layer                │
│  UseCase (operator fun invoke())   │
│  비즈니스 로직, 재사용 가능         │
├─────────────────────────────────────┤
│          Data Layer                 │
│  Repository → DataSource           │
│  Local(Room) + Remote(Ktor)        │
│  Single Source of Truth (SSOT)     │
└─────────────────────────────────────┘
```

**핵심 원칙:**
- **단방향 데이터 흐름 (UDF):** Events↑ State↓
- **SSOT:** 각 데이터 타입마다 하나의 진실의 원천
- **UI는 데이터 모델에서 구동**
- **오프라인 우선:** Data Layer가 로컬 DB를 먼저 읽고 원격 동기화

## State Management 패턴

```kotlin
class SomeViewModel @Inject constructor(
    private val someUseCase: SomeUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(SomeUiState())
    val uiState: StateFlow<SomeUiState> = _uiState.asStateFlow()

    fun onAction(action: SomeAction) {
        _uiState.update { current ->
            current.copy(isLoading = true)
        }
    }
}

@Composable
fun SomeScreen(viewModel: SomeViewModel = hiltViewModel()) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
}
```

**금지 사항:**
- `MutableStateFlow`를 public으로 노출하지 않음
- `viewModelScope`에서 5초 이상 작업 금지 (WorkManager 사용)
- 네비게이션/일회성 이벤트를 StateFlow로 모델링하지 않음 (SharedFlow 사용)

## Navigation 3

```kotlin
val backStack = rememberMutableStateListOf<Route>(Route.Dashboard)

NavDisplay(backStack = backStack) {
    entry<Route.Dashboard> { DashboardScreen(onNavigate = { backStack.add(it) }) }
    entry<Route.Chat> { ChatScreen() }
    entry<Route.Settings> { SettingsScreen() }
}
```

- XML graph 없음, Fragment 없음, SafeArgs 없음
- Type-safe, Compose-state-first

## Hilt DI

```kotlin
@Module
@InstallIn(SingletonComponent::class)
object EngineModule {
    @Provides @Singleton
    fun provideEngineManager(
        apiEngine: ApiEngine,
        localEngine: LocalEngine
    ): EngineManager = EngineManager(apiEngine, localEngine)
}

@HiltViewModel
class DashboardViewModel @Inject constructor(
    private val engineManager: EngineManager
) : ViewModel()
```

## Background Work

| 작업 유형 | 솔루션 |
|----------|--------|
| 에이전트 상시 구동 | **Foreground Service** (알림 필수) |
| 주기적 작업 | **WorkManager PeriodicWorkRequest** |
| 즉시 실행 (< 5초) | **viewModelScope 코루틴** |

## Icon System — Lucide Icons

```kotlin
import com.composables.icons.lucide.Lucide
import com.composables.icons.lucide.IconName

Icon(
    imageVector = Lucide.IconName,
    contentDescription = "설명",
)
```

- **패키지:** `com.composables:icons-lucide-cmp`
- **버전:** `gradle/libs.versions.toml` → `lucide`
- **아이콘 탐색:** https://lucide.dev/icons
- `androidx.compose.material.icons` 사용 금지
- `Icons.Default.*`, `Icons.Filled.*`, `Icons.AutoMirrored.*` 사용 금지

## Core Interfaces

### LLMEngine

```kotlin
interface LLMEngine {
    val name: String
    val type: EngineType

    suspend fun initialize()
    suspend fun chat(messages: List<Message>, options: ChatOptions = ChatOptions()): ChatResponse
    fun stream(messages: List<Message>, options: ChatOptions = ChatOptions()): Flow<String>
    fun isAvailable(): Boolean
    fun getStatus(): EngineStatus
}

enum class EngineType { LOCAL, API, CUSTOM }

data class ChatOptions(
    val maxTokens: Int? = null,
    val temperature: Float? = null,
    val systemPrompt: String? = null,
    val tools: List<Tool> = emptyList()
)

data class ChatResponse(
    val content: String,
    val toolCalls: List<ToolCall> = emptyList(),
    val usage: TokenUsage? = null
)
```

### ShellExecutor

```kotlin
interface ShellExecutor {
    suspend fun execute(command: String, options: ExecOptions = ExecOptions()): ExecResult
    fun stream(command: String): Flow<String>
    fun isEnvironmentReady(): Boolean
    suspend fun installPackage(manager: PackageManager, packageName: String)
}

enum class PackageManager { NPM, PIP }

data class ExecResult(val stdout: String, val stderr: String, val exitCode: Int)
data class ExecOptions(val cwd: String? = null, val timeoutMillis: Long = 30_000, val env: Map<String, String> = emptyMap())
```

### EngineManager

```kotlin
interface EngineManager {
    val activeEngine: StateFlow<LLMEngine?>
    val availableEngines: StateFlow<List<LLMEngine>>
    suspend fun switchEngine(type: EngineType)
    suspend fun initializeAll()
}
```

### ConversationRepository

```kotlin
interface ConversationRepository {
    fun getConversations(): Flow<List<Conversation>>
    fun getMessages(conversationId: String): Flow<List<Message>>
    suspend fun saveMessage(conversationId: String, message: Message)
    suspend fun createConversation(): Conversation
    suspend fun deleteConversation(conversationId: String)
}
```

## Prompt Sync — 시스템 프롬프트 동기화

### 3-Tier 구조

| Tier | 내용 | 위치 | 업데이트 |
|------|------|------|---------|
| **System** | identity, behaviorRules, knowledge | `anclaw-config/prompts/{version}.json` (R2) | JSON 수정 + upload.sh |
| **Application** | tool list (name + description) | `ToolDefinitions.kt` → `generateToolListPrompt()` | 앱 릴리스 |
| **User** | SOUL, UserProfile, Memories, Skills | 디바이스 로컬 | 사용자 직접 변경 |

### 의존 관계 맵

```
ToolDefinitions.kt (tool name + schema)
    ├─→ ToolExecutor.kt (when 분기로 실행)
    ├─→ SystemPromptBuilder.kt (generateToolListPrompt() 자동 포함)
    ├─→ R2 behaviorRules.api (tool name을 행동 규칙에서 참조)
    ├─→ R2 knowledge.tools (사용자 대상 tool 설명)
    └─→ SelfKnowledge.kt FALLBACK (오프라인 fallback)
```

### Tool 추가/제거 시 체크리스트

1. **`ToolDefinitions.kt`** — tool schema 추가/제거 (`BASE` 리스트)
2. **`ToolExecutor.kt`** — `when(toolUse.name)` 분기 추가/제거
3. **`anclaw-config/prompts/{version}.json`** → `behaviorRules.api` — 새 tool의 행동 규칙 추가 (필요 시)
4. **`anclaw-config/prompts/{version}.json`** → `knowledge.tools` — tool 설명 추가/제거
5. **`SystemPromptBuilder.kt`** → `FALLBACK_RULES_API` — fallback에 tool 행동 규칙 동기화
6. **`SelfKnowledge.kt`** → `FALLBACK_CATEGORIES["tools"]` — fallback 동기화
7. **`app/src/test/.../SelfKnowledgeTest.kt`** — tool name 검증 테스트가 자동으로 잡아줌

### 캐시 동작

R2 프롬프트는 3단계 캐시:
1. **메모리** (24시간 TTL) → 앱 재시작 시 만료
2. **SharedPreferences** → 영구 저장, 네트워크 실패 시 사용
3. **Hardcoded fallback** → 앱 코드 내 `FALLBACK_*` 상수

## Testing

| 계층 | 도구 | 위치 | 속도 |
|------|------|------|------|
| Unit (ViewModel, UseCase) | JUnit 5 + Turbine | `test/` (JVM) | 빠름 |
| Compose UI | Compose Test + Robolectric | `test/` (JVM) | 빠름 |
| Integration | Compose Test (디바이스) | `androidTest/` | 보통 |
| Screenshot | Roborazzi | `test/` (JVM) | 빠름 |
| E2E (proot, Relay) | 실제 디바이스 필수 | `androidTest/` | 느림 |

## Verification Strategy

- **기본: 로컬 빌드/테스트** — `./gradlew assembleDebug`, `./gradlew test` 등 로컬에서 직접 실행
- 로컬 검증 통과 후 **로컬에서 main에 직접 머지** (PR/GitHub Actions 불필요)
- **GitHub Actions CI는 사용자가 명시적으로 요청할 때만** 사용
