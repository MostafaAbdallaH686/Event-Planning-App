import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_planning_app/core/utils/cache/cache_helper.dart';

// Mock SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late CacheHelper cacheHelper;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(0);
    registerFallbackValue(0.0);
    registerFallbackValue(false);
  });

  setUp(() {
    // Reset singleton before each test
    CacheHelper.reset();
    mockPrefs = MockSharedPreferences();
    // Create CacheHelper instance with mock for testing
    cacheHelper = CacheHelper.createForTest(mockPrefs);
  });

  tearDown(() {
    CacheHelper.reset();
  });
  test('saveData should return false when SharedPreferences throws', () async {
    const key = 'error_key';
    const value = 'test';

    when(() => mockPrefs.setString(key, value))
        .thenThrow(Exception('Storage error'));

    final result = await cacheHelper.saveData(key: key, value: value);

    expect(result, isFalse);
  });
  test('getData should handle all types correctly', () {
    when(() => mockPrefs.get('string_key')).thenReturn('value');
    when(() => mockPrefs.get('int_key')).thenReturn(42);
    when(() => mockPrefs.get('double_key')).thenReturn(3.14);

    expect(cacheHelper.getData(key: 'string_key'), 'value');
    expect(cacheHelper.getData(key: 'int_key'), 42);
    expect(cacheHelper.getData(key: 'double_key'), 3.14);
  });
  test('should handle rapid successive operations', () async {
    // Stub setString for ANY key/value
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

    final futures = List.generate(
      100,
      (i) => cacheHelper.saveData(key: 'key_$i', value: 'value_$i'),
    );

    final results = await Future.wait(futures);

    expect(results.every((r) => r == true), isTrue);

    // verify at least some were called
    verify(() => mockPrefs.setString(any(), any())).called(100);
  });

  test('saveData should return false when SharedPreferences throws', () async {
    const key = 'error_key';
    const value = 'test';

    when(() => mockPrefs.setString(key, value))
        .thenThrow(Exception('Storage error'));

    final result = await cacheHelper.saveData(key: key, value: value);

    expect(result, isFalse);
  });

  group('CacheHelper Unit Tests', () {
    group('Initialization', () {
      test('should throw StateError when accessed before initialization', () {
        CacheHelper.reset();
        expect(() => CacheHelper.instance, throwsA(isA<StateError>()));
      });

      test('should initialize successfully with createForTest', () {
        cacheHelper = CacheHelper.createForTest(mockPrefs);
        expect(CacheHelper.isInitialized, isTrue);
      });
      test('should return same instance on multiple calls', () {
        final firstInstance = CacheHelper.instance;
        final secondInstance = CacheHelper.instance;
        expect(firstInstance, same(secondInstance));
      });
    });

    group('String Operations', () {
      test('getDataString should return stored string', () {
        const key = 'user_name';
        const value = 'John Doe';

        when(() => mockPrefs.getString(key)).thenReturn(value);

        final result = cacheHelper.getDataString(key: key);

        expect(result, value);
        verify(() => mockPrefs.getString(key)).called(1);
      });

      test('getDataString should return null for non-existent key', () {
        const key = 'non_existent';

        when(() => mockPrefs.getString(key)).thenReturn(null);

        final result = cacheHelper.getDataString(key: key);

        expect(result, isNull);
        verify(() => mockPrefs.getString(key)).called(1);
      });

      test('saveData should save string successfully', () async {
        const key = 'token';
        const value = 'abc123';

        when(() => mockPrefs.setString(key, value))
            .thenAnswer((_) async => true);

        final result = await cacheHelper.saveData(key: key, value: value);

        expect(result, isTrue);
        verify(() => mockPrefs.setString(key, value)).called(1);
      });
    });

    group('Boolean Operations', () {
      test('saveData should save boolean successfully', () async {
        const key = 'is_logged_in';
        const value = true;

        when(() => mockPrefs.setBool(key, value)).thenAnswer((_) async => true);

        final result = await cacheHelper.saveData(key: key, value: value);

        expect(result, isTrue);
        verify(() => mockPrefs.setBool(key, value)).called(1);
      });

      test('getData should return boolean value', () {
        const key = 'dark_mode';
        const value = false;

        when(() => mockPrefs.get(key)).thenReturn(value);

        final result = cacheHelper.getData(key: key);

        expect(result, value);
        verify(() => mockPrefs.get(key)).called(1);
      });
    });

    group('Integer Operations', () {
      test('saveData should save integer successfully', () async {
        const key = 'user_age';
        const value = 25;

        when(() => mockPrefs.setInt(key, value)).thenAnswer((_) async => true);

        final result = await cacheHelper.saveData(key: key, value: value);

        expect(result, isTrue);
        verify(() => mockPrefs.setInt(key, value)).called(1);
      });
    });

    group('Double Operations', () {
      test('saveData should save double successfully', () async {
        const key = 'user_rating';
        const value = 4.5;

        when(() => mockPrefs.setDouble(key, value))
            .thenAnswer((_) async => true);

        final result = await cacheHelper.saveData(key: key, value: value);

        expect(result, isTrue);
        verify(() => mockPrefs.setDouble(key, value)).called(1);
      });
    });

    group('removeData', () {
      test('should remove existing key successfully', () async {
        const key = 'temp_data';

        when(() => mockPrefs.remove(key)).thenAnswer((_) async => true);

        final result = await cacheHelper.removeData(key: key);

        expect(result, isTrue);
        verify(() => mockPrefs.remove(key)).called(1);
      });

      test('should return false when removal fails', () async {
        const key = 'key_to_remove';

        when(() => mockPrefs.remove(key)).thenAnswer((_) async => false);

        final result = await cacheHelper.removeData(key: key);

        expect(result, isFalse);
        verify(() => mockPrefs.remove(key)).called(1);
      });
    });

    group('containsKey', () {
      test('should return true for existing key', () {
        const key = 'existing_key';

        when(() => mockPrefs.containsKey(key)).thenReturn(true);

        final result = cacheHelper.containsKey(key: key);

        expect(result, isTrue);
        verify(() => mockPrefs.containsKey(key)).called(1);
      });

      test('should return false for non-existent key', () {
        const key = 'non_existent_key';

        when(() => mockPrefs.containsKey(key)).thenReturn(false);

        final result = cacheHelper.containsKey(key: key);

        expect(result, isFalse);
        verify(() => mockPrefs.containsKey(key)).called(1);
      });
    });

    group('clearData', () {
      test('should clear all data successfully', () async {
        when(() => mockPrefs.clear()).thenAnswer((_) async => true);

        final result = await cacheHelper.clearData();

        expect(result, isTrue);
        verify(() => mockPrefs.clear()).called(1);
      });
    });

    group('Edge Cases', () {
      test('should handle empty keys', () async {
        const emptyKey = '';
        const value = 'test_value';

        when(() => mockPrefs.setString(emptyKey, value))
            .thenAnswer((_) async => true);

        final result = await cacheHelper.saveData(key: emptyKey, value: value);

        expect(result, isTrue);
        verify(() => mockPrefs.setString(emptyKey, value)).called(1);
      });

      test('should handle null values in saveData', () async {
        const key = 'null_test';
        //  SharedPreferences doesn't support null values directly
        final result = await cacheHelper.saveData(key: key, value: null);

        expect(result, isFalse);
        verifyNever(() => mockPrefs.setString(any(), any()));
        verifyNever(() => mockPrefs.setBool(any(), any()));
        verifyNever(() => mockPrefs.setInt(any(), any()));
        verifyNever(() => mockPrefs.setDouble(any(), any()));
      });

      test('should handle very long keys and values', () async {
        final longKey = List.filled(1000, 'a').join(); // "aaaaa...." 1000 times
        final longValue =
            List.filled(10000, 'b').join(); // "bbbbb...." 10000 times

        when(() => mockPrefs.setString(longKey, longValue))
            .thenAnswer((_) async => true);

        final result =
            await cacheHelper.saveData(key: longKey, value: longValue);

        expect(result, isTrue);
        verify(() => mockPrefs.setString(longKey, longValue)).called(1);
      });
    });

    group('Integration Tests', () {
      test('should maintain data consistency across operations', () async {
        const key = 'consistent_key';
        const value = 'consistent_value';

        // Setup mocks for the sequence
        when(() => mockPrefs.setString(key, value))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.containsKey(key)).thenReturn(true);
        when(() => mockPrefs.getString(key)).thenReturn(value);
        when(() => mockPrefs.remove(key)).thenAnswer((_) async => true);

        // Save data
        final saveResult = await cacheHelper.saveData(key: key, value: value);
        final containsResult = cacheHelper.containsKey(key: key);
        final getStringResult = cacheHelper.getDataString(key: key);
        final removeResult = await cacheHelper.removeData(key: key);

        expect(saveResult, isTrue);
        expect(containsResult, isTrue);
        expect(getStringResult, value);
        expect(removeResult, isTrue);

        verifyInOrder([
          () => mockPrefs.setString(key, value),
          () => mockPrefs.containsKey(key),
          () => mockPrefs.getString(key),
          () => mockPrefs.remove(key),
        ]);
      });

      test('should handle sequence of operations correctly', () async {
        const key = 'sequence_key';
        String? storedValue;

        // Mock saving
        when(() => mockPrefs.setString(key, any()))
            .thenAnswer((invocation) async {
          storedValue = invocation.positionalArguments[1] as String;
          return true;
        });

        // Mock reading
        when(() => mockPrefs.getString(key)).thenAnswer((_) => storedValue);

        // Mock removing
        when(() => mockPrefs.remove(key)).thenAnswer((_) async {
          storedValue = null;
          return true;
        });

        // Mock containsKey
        when(() => mockPrefs.containsKey(key))
            .thenAnswer((_) => storedValue != null);

        // Save first value
        await cacheHelper.saveData(key: key, value: 'first_value');
        expect(cacheHelper.getDataString(key: key), 'first_value');

        // Save second value
        await cacheHelper.saveData(key: key, value: 'second_value');
        expect(cacheHelper.getDataString(key: key), 'second_value');

        // Remove
        await cacheHelper.removeData(key: key);
        expect(cacheHelper.containsKey(key: key), isFalse);

        // Verify calls
        verify(() => mockPrefs.setString(key, 'first_value')).called(1);
        verify(() => mockPrefs.setString(key, 'second_value')).called(1);
        verify(() => mockPrefs.remove(key)).called(1);
      });
    });
  });
}
