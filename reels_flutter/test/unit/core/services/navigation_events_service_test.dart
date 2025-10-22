import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reels_flutter/core/services/navigation_events_service.dart';

import '../../../helpers/test_mocks.dart';

void main() {
  group('NavigationEventsService', () {
    late NavigationEventsService service;
    late MockReelsFlutterNavigationApi mockApi;

    setUp(() {
      mockApi = MockReelsFlutterNavigationApi();
      service = NavigationEventsService(api: mockApi);
    });

    group('onSwipeLeft', () {
      test('should call api.onSwipeLeft', () {
        // Act
        service.onSwipeLeft();

        // Assert
        verify(mockApi.onSwipeLeft()).called(1);
      });

      test('should not throw when api fails', () {
        // Arrange
        when(mockApi.onSwipeLeft()).thenThrow(Exception('Navigation error'));

        // Act & Assert
        expect(() => service.onSwipeLeft(), returnsNormally);
      });
    });

    group('onSwipeRight', () {
      test('should call api.onSwipeRight', () {
        // Act
        service.onSwipeRight();

        // Assert
        verify(mockApi.onSwipeRight()).called(1);
      });

      test('should not throw when api fails', () {
        // Arrange
        when(mockApi.onSwipeRight()).thenThrow(Exception('Navigation error'));

        // Act & Assert
        expect(() => service.onSwipeRight(), returnsNormally);
      });
    });

    group('legacy compatibility methods', () {
      test('notifySwipeLeft should call onSwipeLeft', () {
        // Act
        service.notifySwipeLeft();

        // Assert
        verify(mockApi.onSwipeLeft()).called(1);
      });

      test('notifySwipeLeft with currentIndex should call onSwipeLeft', () {
        // Act
        service.notifySwipeLeft(currentIndex: 5);

        // Assert
        verify(mockApi.onSwipeLeft()).called(1);
      });

      test('notifySwipeRight should call onSwipeRight', () {
        // Act
        service.notifySwipeRight();

        // Assert
        verify(mockApi.onSwipeRight()).called(1);
      });

      test('notifySwipeRight with currentIndex should call onSwipeRight', () {
        // Act
        service.notifySwipeRight(currentIndex: 3);

        // Assert
        verify(mockApi.onSwipeRight()).called(1);
      });
    });

    group('multiple consecutive calls', () {
      test('should handle multiple swipe left calls', () {
        // Act
        service.onSwipeLeft();
        service.onSwipeLeft();
        service.onSwipeLeft();

        // Assert
        verify(mockApi.onSwipeLeft()).called(3);
      });

      test('should handle alternating swipe calls', () {
        // Act
        service.onSwipeLeft();
        service.onSwipeRight();
        service.onSwipeLeft();
        service.onSwipeRight();

        // Assert
        verify(mockApi.onSwipeLeft()).called(2);
        verify(mockApi.onSwipeRight()).called(2);
      });
    });
  });
}
