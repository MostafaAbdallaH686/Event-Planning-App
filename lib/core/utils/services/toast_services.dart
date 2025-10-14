import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Abstract interface for showing toast messages
abstract class ToastService {
  void show({
    required String message,
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = const Color(0xFFB26C26),
    Color textColor = Colors.white,
    int timeInSecForIosWeb = 2,
    double fontSize = 16.0,
  });

  void cancel();
}

/// Production implementation using Fluttertoast
class FlutterToastService implements ToastService {
  static final FlutterToastService _instance = FlutterToastService._internal();
  factory FlutterToastService() => _instance;
  FlutterToastService._internal();

  @override
  void show({
    required String message,
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = const Color(0xFFB26C26),
    Color textColor = Colors.white,
    int timeInSecForIosWeb = 2,
    double fontSize = 16.0,
  }) {
    cancel();

    Fluttertoast.showToast(
      msg: message,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: timeInSecForIosWeb,
      fontSize: fontSize,
    );
  }

  @override
  void cancel() {
    Fluttertoast.cancel();
  }
}

/// Mock implementation for testing
class MockToastService implements ToastService {
  final List<ToastCall> calls = [];
  int cancelCallCount = 0;
  ToastCall? lastCall;

  @override
  void show({
    required String message,
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = const Color(0xFFB26C26),
    Color textColor = Colors.white,
    int timeInSecForIosWeb = 2,
    double fontSize = 16.0,
  }) {
    final call = ToastCall(
      message: message,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      timeInSecForIosWeb: timeInSecForIosWeb,
      fontSize: fontSize,
    );

    calls.add(call);
    lastCall = call;
  }

  @override
  void cancel() {
    cancelCallCount++;
  }

  void reset() {
    calls.clear();
    cancelCallCount = 0;
    lastCall = null;
  }

  bool wasShownWith({
    String? message,
    ToastGravity? gravity,
    Color? backgroundColor,
  }) {
    return calls.any((call) {
      bool matches = true;
      if (message != null) matches = matches && call.message == message;
      if (gravity != null) matches = matches && call.gravity == gravity;
      if (backgroundColor != null) {
        matches = matches && call.backgroundColor == backgroundColor;
      }
      return matches;
    });
  }
}

/// Represents a single toast call for testing
class ToastCall {
  final String message;
  final ToastGravity gravity;
  final Color backgroundColor;
  final Color textColor;
  final int timeInSecForIosWeb;
  final double fontSize;

  ToastCall({
    required this.message,
    required this.gravity,
    required this.backgroundColor,
    required this.textColor,
    required this.timeInSecForIosWeb,
    required this.fontSize,
  });

  @override
  String toString() => 'ToastCall(message: $message, gravity: $gravity)';
}
