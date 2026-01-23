// Put inside here all constants used through the project

/// Maximum number of translatable strings to include in a single translation
/// API request. When the total number of strings exceeds this threshold, the
/// strings are split into multiple batches that are sent in parallel via
/// [Future.wait]. This balances API rate limits against latency: smaller
/// batches complete faster individually, and parallelism reduces total wall
/// time, but too many concurrent requests may trigger rate limiting.
const int kTranslationBatchSize = 100;
