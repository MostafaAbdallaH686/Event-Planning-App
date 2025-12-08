import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsService {
  static final FirebaseCrashlytics _instance = FirebaseCrashlytics.instance;

  /// Initialize Crashlytics with custom settings
  static Future<void> initialize() async {
    // Set user ID for tracking
    // You can set this after user logs in

    // Enable collection in non-debug builds
    await _instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  /// Record a custom error
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {
    await _instance.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  /// Record a custom log message
  static void log(String message) {
    _instance.log(message);
  }

  /// Set user identifier for crash tracking
  static Future<void> setUserIdentifier(String userId) async {
    await _instance.setUserIdentifier(userId);
  }

  /// Set custom key-value data
  static Future<void> setCustomKey(String key, dynamic value) async {
    await _instance.setCustomKey(key, value);
  }

  /// Record an authentication event
  static Future<void> recordAuthEvent(String event, {String? userId}) async {
    await _instance.log('Auth Event: $event');
    if (userId != null) {
      await setUserIdentifier(userId);
    }
  }

  /// Record a transaction event
  static Future<void> recordTransactionEvent(
    String eventName, {
    required String? eventId,
    required String? userId,
    required double amount,
  }) async {
    await _instance.log(
      'Transaction Event: $eventName - Amount: $amount',
    );
    if (userId != null) {
      await setCustomKey('user_id', userId);
    }
    if (eventId != null) {
      await setCustomKey('event_id', eventId);
    }
  }

  /// Record a navigation event
  static Future<void> recordNavigationEvent(String routeName) async {
    await _instance.log('Navigation: $routeName');
  }

  /// Check if collection is enabled
  static bool isCollectionEnabled() {
    return !kDebugMode;
  }
}
