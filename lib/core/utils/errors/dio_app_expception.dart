import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

/// A lightweight wrapper that normalises [DioException]s into
/// domain-friendly error messages and metadata that the UI layer can consume.
class DioAppException implements Exception {
  DioAppException({
    required this.message,
    this.statusCode,
    this.data,
    this.dioException,
  });

  /// Human-readable message describing the problem.
  final String message;

  /// HTTP status code (if present on the response).
  final int? statusCode;

  /// Raw payload returned by the backend (if any).
  final Object? data;

  /// The originating Dio exception for debugging purposes.
  final DioException? dioException;

  /// Builds a [DioAppException] from a Dio-layer exception, mapping it to a
  /// consistent error message regardless of the original transport error.
  factory DioAppException.fromDioException(DioException dioException) {
    if (dioException.type == DioExceptionType.badResponse) {
      return DioAppException(
        message: _messageFromBadResponse(dioException.response),
        statusCode: dioException.response?.statusCode,
        data: dioException.response?.data,
        dioException: dioException,
      );
    }

    if (dioException.type == DioExceptionType.unknown &&
        dioException.error is SocketException) {
      return DioAppException(
        message:
            'No internet connection detected. Please check your network and try again.',
        statusCode: dioException.response?.statusCode,
        data: dioException.response?.data,
        dioException: dioException,
      );
    }

    final fallbackMessage = switch (dioException.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'Connection to the server timed out. Please retry.',
      DioExceptionType.badCertificate =>
        'Secure connection could not be established because the certificate is invalid.',
      DioExceptionType.connectionError =>
        'Network connection error. Please verify your internet connection.',
      DioExceptionType.cancel =>
        'Request to the server was cancelled before completion.',
      _ => 'Unexpected network error. Please try again.',
    };

    return DioAppException(
      message: fallbackMessage,
      statusCode: dioException.response?.statusCode,
      data: dioException.response?.data,
      dioException: dioException,
    );
  }

  /// Derives a [DioAppException] from a concrete HTTP [Response],
  /// preserving the payload along with a human-readable message.
  factory DioAppException.fromResponse(
    Response<Object?> response, {
    String? fallbackMessage,
  }) {
    final message = fallbackMessage ?? _messageFromBadResponse(response);
    return DioAppException(
      message: message,
      statusCode: response.statusCode,
      data: response.data,
      dioException: null,
    );
  }

  /// Executes [callback] and converts any [DioException] into a
  /// [DioAppException], returning either the result or the mapped
  /// application exception.
  static Future<Either<DioAppException, T>> guard<T>(
    Future<T> Function() callback,
  ) async {
    try {
      final value = await callback();
      return Right(value);
    } on DioException catch (dioError) {
      return Left(DioAppException.fromDioException(dioError));
    } catch (error) {
      return Left(DioAppException(message: error.toString()));
    }
  }

  /// Attempts to surface the most helpful error message from a backend
  /// response, falling back to sensible defaults when a specific message is
  /// unavailable.
  static String _messageFromBadResponse(Response<Object?>? response) {
    if (response == null) {
      return 'Received an invalid response from the server.';
    }

    final statusCode = response.statusCode;
    final payloadMessage = _extractServerMessage(response.data);

    return switch (statusCode) {
      400 => payloadMessage ?? 'The request was rejected by the server.',
      401 => payloadMessage ?? 'You are not authorised to perform this action.',
      403 =>
        payloadMessage ?? 'You do not have permission to access this resource.',
      404 => payloadMessage ?? 'The requested resource could not be found.',
      409 =>
        payloadMessage ?? 'A conflict occurred while processing your request.',
      422 => payloadMessage ?? 'The submitted data is invalid.',
      500 || 502 || 503 || 504 => payloadMessage ??
          'The server is currently unavailable. Please try again later.',
      _ => payloadMessage ??
          (statusCode != null
              ? 'Received an unexpected status code: $statusCode.'
              : 'Unexpected server response.'),
    };
  }

  /// Recursively walks the server payload to discover a meaningful error
  /// message. Works with common API response structures.
  static String? extractServerMessage(Object? data) =>
      _extractServerMessage(data);

  static String? _extractServerMessage(Object? data) {
    if (data == null) {
      return null;
    }

    if (data is String) {
      final trimmed = data.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    if (data is Map) {
      for (final key in [
        'message',
        'error',
        'detail',
        'title',
        'description'
      ]) {
        final value = data[key];
        if (value is String) {
          final trimmed = value.trim();
          if (trimmed.isNotEmpty) {
            return trimmed;
          }
        }
      }

      final errors = data['errors'];
      if (errors != null) {
        final nested = _extractServerMessage(errors);
        if (nested != null) {
          return nested;
        }
      }

      for (final value in data.values) {
        final nested = _extractServerMessage(value);
        if (nested != null) {
          return nested;
        }
      }
    }

    if (data is Iterable) {
      for (final value in data) {
        final nested = _extractServerMessage(value);
        if (nested != null) {
          return nested;
        }
      }
    }

    return null;
  }

  @override
  String toString() => message;
}

/// Convenience extension to convert a [DioException] into the unified
/// [DioAppException] used across the app.
extension DioExceptionMapper on DioException {
  DioAppException get asAppException => DioAppException.fromDioException(this);
}