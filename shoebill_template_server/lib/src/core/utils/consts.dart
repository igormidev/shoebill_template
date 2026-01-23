// Put inside here all constants used through the project

// ============================================================================
// TRANSLATION CONSTANTS
// ============================================================================

/// Maximum number of translatable strings to include in a single translation
/// API request. When the total number of strings exceeds this threshold, the
/// strings are split into multiple batches that are sent in parallel via
/// [Future.wait]. This balances API rate limits against latency: smaller
/// batches complete faster individually, and parallelism reduces total wall
/// time, but too many concurrent requests may trigger rate limiting.
const int kTranslationBatchSize = 100;

// ============================================================================
// SESSION MANAGEMENT CONSTANTS
// ============================================================================

/// Maximum number of times a chat session can be refreshed before it is
/// automatically cleaned up. This prevents unbounded memory growth from
/// sessions that keep refreshing indefinitely.
const int kMaxSessionRefreshes = 30;

/// Duration of inactivity before a chat session is automatically cleaned up.
/// If no activity (refresh, send message, etc.) occurs within this duration,
/// the session and all its in-memory data are removed.
const Duration kSessionInactivityTimeout = Duration(minutes: 30);

// ============================================================================
// AI REVIEW AND RETRY CONSTANTS
// ============================================================================

/// Maximum number of Daytona retry attempts when the template reviewer
/// rejects the generated output. After this many attempts, the system
/// reports failure to the user.
const int kMaxDaytonaRetryAttempts = 6;

/// Maximum number of retry attempts for the template review loop.
/// This bounds how many times the reviewer AI can ask for corrections.
const int kMaxReviewRetryAttempts = 6;

/// The AI model used for template review.
/// Gemini 3 Flash Preview with thinking mode for thorough analysis.
const String kReviewerModel = 'google/gemini-3-flash-preview';

// ============================================================================
// LEGACY DAYTONA STREAMING CONSTANTS
// ============================================================================

/// Default execution timeout for the legacy Daytona streaming service.
/// This is the maximum time allowed for Claude Code to run in the sandbox.
const Duration kLegacyDaytonaExecutionTimeout = Duration(minutes: 30);

/// Number of PTY (pseudo-terminal) columns for the legacy sandbox terminal.
const int kPtyColumns = 120;

/// Number of PTY (pseudo-terminal) rows for the legacy sandbox terminal.
const int kPtyRows = 40;

/// Delay before sending the command to the PTY WebSocket to allow the
/// connection to stabilize.
const Duration kWebSocketConnectionDelay = Duration(milliseconds: 500);

/// Maximum number of poll attempts when waiting for the legacy sandbox
/// to become ready.
const int kLegacySandboxMaxPollAttempts = 60;

/// Interval between poll requests when waiting for the legacy sandbox
/// to become ready.
const Duration kLegacySandboxPollInterval = Duration(seconds: 2);

/// Auto-stop interval in minutes for the legacy sandbox.
const int kLegacySandboxAutoStopMinutes = 30;

/// Auto-archive interval in minutes for the legacy sandbox.
const int kLegacySandboxAutoArchiveMinutes = 60;

/// Auto-delete interval in minutes for the legacy sandbox.
const int kLegacySandboxAutoDeleteMinutes = 120;

/// Default command execution timeout in seconds for the legacy sandbox.
const int kLegacyCommandTimeoutSeconds = 600;

/// HTTP timeout for the legacy sandbox delete operation.
const Duration kLegacySandboxDeleteTimeout = Duration(seconds: 10);

/// HTTP timeout for sandbox creation requests.
const Duration kSandboxCreationTimeout = Duration(seconds: 60);

/// HTTP timeout for file download operations.
const Duration kFileDownloadTimeout = Duration(seconds: 30);
