// Mocks
import 'package:dio/dio.dart';
import 'package:event_planning_app/core/utils/failure/dio_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioException extends Mock implements DioException {}

class MockResponse extends Mock implements Response {}

class MockRequestOptions extends Mock implements RequestOptions {}

void main() {
  late MockDioException mockDioException;
  late MockResponse mockResponse;
  late MockRequestOptions mockRequestOptions;

  setUp(() {
    mockDioException = MockDioException();
    mockResponse = MockResponse();
    mockRequestOptions = MockRequestOptions();

    // Default setup for DioException
    when(() => mockDioException.requestOptions).thenReturn(mockRequestOptions);
    when(() => mockDioException.response).thenReturn(mockResponse);
  });

  group('CustomDioException', () {
    test('should store error message correctly', () {
      // Arrange
      const errorMessage = 'Test error message';

      // Act
      final exception = CustomDioException(errMessage: errorMessage);

      // Assert
      expect(exception.errMessage, equals(errorMessage));
    });

    test('should be an Exception', () {
      // Arrange & Act
      final exception = CustomDioException(errMessage: 'Error');

      // Assert
      expect(exception, isA<Exception>());
    });
  });

  group('Failures', () {
    test('should store error message in base class', () {
      // Arrange
      const errorMessage = 'Base error message';

      // Act
      final failure = ServerFailure(errorMessage);

      // Assert
      expect(failure.errorMessage, equals(errorMessage));
      expect(failure, isA<Failures>());
    });
  });

  group('ServerFailure.fromDioError', () {
    group('Connection Errors', () {
      test('should return connection timeout message for connectionTimeout',
          () {
        // Arrange
        when(() => mockDioException.type)
            .thenReturn(DioExceptionType.connectionTimeout);

        // Act
        final failure = ServerFailure.fromDioError(mockDioException);

        // Assert
        expect(
            failure.errorMessage, equals('Connection timeout with ApiServer'));
      });

      test('should return send timeout message for sendTimeout', () {
        // Arrange
        when(() => mockDioException.type)
            .thenReturn(DioExceptionType.sendTimeout);

        // Act
        final failure = ServerFailure.fromDioError(mockDioException);

        // Assert
        expect(failure.errorMessage, equals('Send timeout with ApiServer'));
      });

      test('should return receive timeout message for receiveTimeout', () {
        // Arrange
        when(() => mockDioException.type)
            .thenReturn(DioExceptionType.receiveTimeout);

        // Act
        final failure = ServerFailure.fromDioError(mockDioException);

        // Assert
        expect(failure.errorMessage, equals('Receive timeout with ApiServer'));
      });

      test('should return connection error message for connectionError', () {
        // Arrange
        when(() => mockDioException.type)
            .thenReturn(DioExceptionType.connectionError);

        // Act
        final failure = ServerFailure.fromDioError(mockDioException);

        // Assert
        expect(failure.errorMessage, equals('No Internet Connection'));
      });
    });

    group('Certificate and Cancel Errors', () {
      test('should return bad certificate message for badCertificate', () {
        // Arrange
        when(() => mockDioException.type)
            .thenReturn(DioExceptionType.badCertificate);

        // Act
        final failure = ServerFailure.fromDioError(mockDioException);

        // Assert
        expect(failure.errorMessage, equals('Bad certificate with ApiServer'));
      });

      test('should return cancel message for cancel', () {
        // Arrange
        when(() => mockDioException.type).thenReturn(DioExceptionType.cancel);

        // Act
        final failure = ServerFailure.fromDioError(mockDioException);

        // Assert
        expect(failure.errorMessage, equals('Cancel request'));
      });
    });

    group('Unknown Errors', () {
      test('should return no internet for SocketException in unknown', () {
        // Arrange
        when(() => mockDioException.type).thenReturn(DioExceptionType.unknown);
        when(() => mockDioException.message)
            .thenReturn('SocketException: Failed to connect');

        // Act
        final failure = ServerFailure.fromDioError(mockDioException);

        // Assert
        expect(failure.errorMessage, equals('No Internet Connection'));
      });

      test('should return unexpected error for other unknown errors', () {
        // Arrange
        when(() => mockDioException.type).thenReturn(DioExceptionType.unknown);
        when(() => mockDioException.message).thenReturn('Some other error');

        // Act
        final failure = ServerFailure.fromDioError(mockDioException);

        // Assert
        expect(failure.errorMessage,
            equals('Unexpected Error , please try again'));
      });

      test('should handle null message in unknown error', () {
        // Arrange
        when(() => mockDioException.type).thenReturn(DioExceptionType.unknown);
        when(() => mockDioException.message).thenReturn(null);

        // Act
        final failure = ServerFailure.fromDioError(mockDioException);

        // Assert
        expect(failure.errorMessage,
            equals('Unexpected Error , please try again'));
      });
    });

    group('Bad Response Errors', () {
      test('should delegate to fromResponse for badResponse', () {
        // Arrange
        when(() => mockDioException.type)
            .thenReturn(DioExceptionType.badResponse);
        when(() => mockResponse.statusCode).thenReturn(400);
        when(() => mockResponse.data).thenReturn({'message': 'Bad request'});

        // Act
        final failure = ServerFailure.fromDioError(mockDioException);

        // Assert
        expect(failure.errorMessage, equals('Bad request'));
      });
    });
  });

  group('ServerFailure.fromResponse', () {
    group('4xx Status Codes', () {
      test('should handle 400 Bad Request', () {
        // Arrange
        const statusCode = 400;
        final response = {'message': 'Invalid parameters'};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage, equals('Invalid parameters'));
      });

      test('should handle 401 Unauthorized', () {
        // Arrange
        const statusCode = 401;
        final response = {'message': 'Unauthorized access'};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage, equals('Unauthorized access'));
      });

      test('should handle 403 Forbidden', () {
        // Arrange
        const statusCode = 403;
        final response = {'message': 'Access forbidden'};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage, equals('Access forbidden'));
      });

      test('should handle 401 with expired token message', () {
        // Note: You'll need to mock handleExpairedAcessToken
        // For now, we'll just test that the message is returned
        const statusCode = 401;
        final response = {'message': 'Token has expired.'};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage, equals('Token has expired.'));
        // Verify handleExpairedAcessToken was called (needs mocking)
      });

      test('should handle 404 Not Found with message', () {
        // Arrange
        const statusCode = 404;
        final response = {'message': 'Resource not found'};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage, equals('Resource not found'));
      });

      test('should handle 404 Not Found without message', () {
        // Arrange
        const statusCode = 404;
        final response = <String, dynamic>{};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage,
            equals('Your request not found , please try later'));
      });

      test('should handle 422 Unprocessable Entity with message', () {
        // Arrange
        const statusCode = 422;
        final response = {'message': 'Validation failed'};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage, equals('Validation failed'));
      });

      test('should handle 422 Unprocessable Entity without message', () {
        // Arrange
        const statusCode = 422;
        final response = <String, dynamic>{};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage, equals('Unprocessable entity'));
      });

      test('should handle 413 Payload Too Large', () {
        // Arrange
        const statusCode = 413;
        final response = <String, dynamic>{};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage, equals('The image is too big '));
      });
    });

    group('5xx Status Codes', () {
      test('should handle 500 Internal Server Error', () {
        // Arrange
        const statusCode = 500;
        final response = {'message': 'Server crashed'};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage,
            equals('Internet server error , please try later'));
      });
    });

    group('Other Status Codes', () {
      test('should handle unexpected status codes', () {
        // Arrange
        const statusCode = 418; // I'm a teapot
        final response = {'message': 'Teapot'};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage,
            equals('Oops there was an error , please try again'));
      });

      test('should handle 3xx status codes', () {
        // Arrange
        const statusCode = 301;
        final response = {'message': 'Moved'};

        // Act
        final failure = ServerFailure.fromResponse(statusCode, response);

        // Assert
        expect(failure.errorMessage,
            equals('Oops there was an error , please try again'));
      });
    });

    group('Edge Cases', () {
      test('should handle null response data', () {
        // Arrange
        const statusCode = 400;
        final dynamic response = null;

        // Act & Assert
        expect(
          () => ServerFailure.fromResponse(statusCode, response),
          throwsA(isA<NoSuchMethodError>()),
        );
      });

      test('should handle string response instead of map', () {
        // Arrange
        const statusCode = 400;
        const response = 'Error string';

        // Act & Assert
        expect(
          () => ServerFailure.fromResponse(statusCode, response),
          throwsA(anything),
        );
      });
    });
  });

  group('Integration Tests', () {
    test('should correctly chain fromDioError to fromResponse', () {
      // Arrange
      when(() => mockDioException.type)
          .thenReturn(DioExceptionType.badResponse);
      when(() => mockResponse.statusCode).thenReturn(500);
      when(() => mockResponse.data).thenReturn({'message': 'Server error'});

      // Act
      final failure = ServerFailure.fromDioError(mockDioException);

      // Assert
      expect(failure.errorMessage,
          equals('Internet server error , please try later'));
    });

    test('should handle complete error flow', () {
      // Test various error types
      final testCases = [
        (
          DioExceptionType.connectionTimeout,
          'Connection timeout with ApiServer'
        ),
        (DioExceptionType.sendTimeout, 'Send timeout with ApiServer'),
        (DioExceptionType.receiveTimeout, 'Receive timeout with ApiServer'),
        (DioExceptionType.badCertificate, 'Bad certificate with ApiServer'),
        (DioExceptionType.cancel, 'Cancel request'),
        (DioExceptionType.connectionError, 'No Internet Connection'),
      ];

      for (final testCase in testCases) {
        when(() => mockDioException.type).thenReturn(testCase.$1);

        final failure = ServerFailure.fromDioError(mockDioException);

        expect(failure.errorMessage, equals(testCase.$2),
            reason: 'Failed for ${testCase.$1}');
      }
    });
  });
}
