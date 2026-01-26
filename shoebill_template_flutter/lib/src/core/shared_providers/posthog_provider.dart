import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shoebill_template_flutter/src/core/utils/device_utils.dart';
import 'package:shoebill_template_flutter/src/core/utils/talker.dart';

/// Provider that initializes and provides access to PostHog analytics
final posthogProvider = Provider<Posthog>((ref) {
  return Posthog();
});

/// Analytics service provider that wraps PostHog with best practices
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final posthog = ref.watch(posthogProvider);
  return AnalyticsService(posthog);
});

/// Service class that encapsulates analytics tracking with PostHog best practices
///
/// Event naming convention: category:object_action
/// - category: context where event occurred (e.g., auth, dashboard)
/// - object: component/location (e.g., login_button, signup_form)
/// - action: verb describing what happened (e.g., click, submit, view)
///
/// Uses lowercase, snake_case, and present-tense verbs
///
/// All tracking methods are error-safe and will not throw exceptions to the app.
/// Errors are logged using Talker for debugging purposes.
class AnalyticsService {
  final Posthog _posthog;

  AnalyticsService(this._posthog);

  /// Whether analytics logging should be performed.
  ///
  /// Returns true only when running on web platform.
  /// This prevents development logs from Mac (the developer's machine) from
  /// mixing with real user analytics data, since the app is currently web-only.
  bool get _shouldLog => DeviceUtils.isWeb;

  /// Centralized, error-safe method to capture analytics events
  ///
  /// Wraps PostHog capture with try-catch to ensure analytics errors
  /// never disrupt app flow. Errors are logged via Talker.
  /// Only logs when running on web platform (see [_shouldLog]).
  Future<void> _safeCapture({
    required String eventName,
    required Map<String, Object> properties,
  }) async {
    if (!_shouldLog) return;
    try {
      await _posthog.capture(
        eventName: eventName,
        properties: properties,
      );
    } catch (e, stackTrace) {
      // Log analytics error but don't throw - analytics should never break the app
      logError(
        e,
        stackTrace,
        'Analytics tracking failed for event: $eventName',
      );
    }
  }

  /// Centralized, error-safe method to identify users
  ///
  /// Wraps PostHog identify with try-catch to ensure analytics errors
  /// never disrupt app flow. Errors are logged via Talker.
  /// Only logs when running on web platform (see [_shouldLog]).
  Future<void> _safeIdentify({
    required String userId,
    Map<String, Object>? userProperties,
  }) async {
    if (!_shouldLog) return;
    try {
      await _posthog.identify(
        userId: userId,
        userProperties: userProperties,
      );
    } catch (e, stackTrace) {
      // Log analytics error but don't throw - analytics should never break the app
      logError(
        e,
        stackTrace,
        'Analytics user identification failed for userId: $userId',
      );
    }
  }

  /// Centralized, error-safe method to reset user identification
  ///
  /// Wraps PostHog reset with try-catch to ensure analytics errors
  /// never disrupt app flow. Errors are logged via Talker.
  /// Only logs when running on web platform (see [_shouldLog]).
  Future<void> _safeReset() async {
    if (!_shouldLog) return;
    try {
      await _posthog.reset();
    } catch (e, stackTrace) {
      // Log analytics error but don't throw - analytics should never break the app
      logError(
        e,
        stackTrace,
        'Analytics reset failed',
      );
    }
  }

  /// Centralized, error-safe method to flush pending events
  ///
  /// Wraps PostHog flush with try-catch to ensure analytics errors
  /// never disrupt app flow. Errors are logged via Talker.
  /// Only logs when running on web platform (see [_shouldLog]).
  Future<void> _safeFlush() async {
    if (!_shouldLog) return;
    try {
      await _posthog.flush();
    } catch (e, stackTrace) {
      // Log analytics error but don't throw - analytics should never break the app
      logError(
        e,
        stackTrace,
        'Analytics flush failed',
      );
    }
  }

  // ========================================
  // General Utility Methods
  // ========================================

  /// Track any custom event with properties
  Future<void> trackEvent({
    required String eventName,
    Map<String, Object>? properties,
  }) async {
    final Map<String, Object> eventProps = {
      if (properties != null) ...properties,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _safeCapture(
      eventName: eventName,
      properties: eventProps,
    );
  }

  /// Identify a user in PostHog
  Future<void> identifyUser({
    required String userId,
    Map<String, Object>? userProperties,
  }) async {
    await _safeIdentify(
      userId: userId,
      userProperties: userProperties,
    );
  }

  /// Reset user identification (call on logout)
  Future<void> reset() async {
    await _safeReset();
  }

  /// Flush any pending events
  Future<void> flush() async {
    await _safeFlush();
  }
}
