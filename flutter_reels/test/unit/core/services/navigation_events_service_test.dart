import 'package:flutter_reels/core/platform/messages.g.dart';
import 'package:flutter_reels/core/services/navigation_events_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'navigation_events_service_test.mocks.dart';

@GenerateMocks([FlutterReelsNavigationApi])
void main() {
  late NavigationEventsService service;
  late MockFlutterReelsNavigationApi mockApi;

  setUp(() {
    mockApi = MockFlutterReelsNavigationApi();
    service = NavigationEventsService(api: mockApi);
  });

  group('NavigationEventsService - Swipe Events', () {
    test('notifySwipeLeft calls API', () {
      // Act
      service.notifySwipeLeft();

      // Assert
      verify(mockApi.onSwipeLeft()).called(1);
    });

    test('notifySwipeLeft with video IDs calls API', () {
      // Arrange
      const fromVideoId = 'video123';
      const toVideoId = 'video124';
      const position = 5;

      // Act
      service.notifySwipeLeft(
        fromVideoId: fromVideoId,
        toVideoId: toVideoId,
        position: position,
      );

      // Assert
      verify(mockApi.onSwipeLeft()).called(1);
    });

    test('notifySwipeLeft with metadata calls API', () {
      // Arrange
      const fromVideoId = 'video123';
      final metadata = {'action': 'profile_view', 'timestamp': '2024-01-01'};

      // Act
      service.notifySwipeLeft(
        fromVideoId: fromVideoId,
        metadata: metadata,
      );

      // Assert
      verify(mockApi.onSwipeLeft()).called(1);
    });

    test('notifySwipeRight calls API', () {
      // Act
      service.notifySwipeRight();

      // Assert
      verify(mockApi.onSwipeRight()).called(1);
    });

    test('notifySwipeRight with video IDs calls API', () {
      // Arrange
      const fromVideoId = 'video124';
      const toVideoId = 'video123';
      const position = 4;

      // Act
      service.notifySwipeRight(
        fromVideoId: fromVideoId,
        toVideoId: toVideoId,
        position: position,
      );

      // Assert
      verify(mockApi.onSwipeRight()).called(1);
    });

    test('notifySwipeRight with metadata calls API', () {
      // Arrange
      const fromVideoId = 'video124';
      final metadata = {'action': 'back_to_feed', 'timestamp': '2024-01-01'};

      // Act
      service.notifySwipeRight(
        fromVideoId: fromVideoId,
        metadata: metadata,
      );

      // Assert
      verify(mockApi.onSwipeRight()).called(1);
    });

    test('notifySwipeLeft can be called multiple times', () {
      // Act
      service.notifySwipeLeft(fromVideoId: 'video1');
      service.notifySwipeLeft(fromVideoId: 'video2');
      service.notifySwipeLeft(fromVideoId: 'video3');

      // Assert
      verify(mockApi.onSwipeLeft()).called(3);
    });

    test('notifySwipeRight can be called multiple times', () {
      // Act
      service.notifySwipeRight(fromVideoId: 'video1');
      service.notifySwipeRight(fromVideoId: 'video2');
      service.notifySwipeRight(fromVideoId: 'video3');

      // Assert
      verify(mockApi.onSwipeRight()).called(3);
    });

    test('can alternate between left and right swipes', () {
      // Act
      service.notifySwipeLeft(fromVideoId: 'video1');
      service.notifySwipeRight(fromVideoId: 'video1');
      service.notifySwipeLeft(fromVideoId: 'video1');
      service.notifySwipeRight(fromVideoId: 'video1');

      // Assert
      verify(mockApi.onSwipeLeft()).called(2);
      verify(mockApi.onSwipeRight()).called(2);
    });
  });

  group('NavigationEventsService - Vertical Swipe Events', () {
    test('notifySwipeUp does not throw', () {
      // Act & Assert
      expect(
        () => service.notifySwipeUp(
          fromVideoId: 'video123',
          toVideoId: 'video124',
          position: 6,
        ),
        returnsNormally,
      );

      // Verify no API calls for vertical swipes (tracked via state changes)
      verifyNever(mockApi.onSwipeLeft());
      verifyNever(mockApi.onSwipeRight());
    });

    test('notifySwipeDown does not throw', () {
      // Act & Assert
      expect(
        () => service.notifySwipeDown(
          fromVideoId: 'video124',
          toVideoId: 'video123',
          position: 5,
        ),
        returnsNormally,
      );

      // Verify no API calls for vertical swipes (tracked via state changes)
      verifyNever(mockApi.onSwipeLeft());
      verifyNever(mockApi.onSwipeRight());
    });

    test('notifySwipeUp without parameters does not throw', () {
      // Act & Assert
      expect(() => service.notifySwipeUp(), returnsNormally);
    });

    test('notifySwipeDown without parameters does not throw', () {
      // Act & Assert
      expect(() => service.notifySwipeDown(), returnsNormally);
    });
  });

  group('NavigationEventsService - Edge Cases', () {
    test('handles null video IDs', () {
      // Act
      service.notifySwipeLeft(fromVideoId: null, toVideoId: null);
      service.notifySwipeRight(fromVideoId: null, toVideoId: null);

      // Assert
      verify(mockApi.onSwipeLeft()).called(1);
      verify(mockApi.onSwipeRight()).called(1);
    });

    test('handles null position', () {
      // Act
      service.notifySwipeLeft(
        fromVideoId: 'video123',
        position: null,
      );

      // Assert
      verify(mockApi.onSwipeLeft()).called(1);
    });

    test('handles empty metadata', () {
      // Act
      service.notifySwipeLeft(
        fromVideoId: 'video123',
        metadata: {},
      );

      // Assert
      verify(mockApi.onSwipeLeft()).called(1);
    });

    test('handles null metadata', () {
      // Act
      service.notifySwipeRight(
        fromVideoId: 'video123',
        metadata: null,
      );

      // Assert
      verify(mockApi.onSwipeRight()).called(1);
    });

    test('handles complex metadata', () {
      // Arrange
      final metadata = {
        'action': 'swipe_left',
        'timestamp': DateTime.now().toIso8601String(),
        'source': 'video_reel',
        'screen': 'reels_screen',
        'nested': {'key': 'value'},
      };

      // Act
      service.notifySwipeLeft(
        fromVideoId: 'video123',
        metadata: metadata,
      );

      // Assert
      verify(mockApi.onSwipeLeft()).called(1);
    });
  });

  group('NavigationEventsService - Integration Scenarios', () {
    test('handles rapid swipe gestures', () {
      // Act - Simulate rapid swipes
      for (int i = 0; i < 10; i++) {
        service.notifySwipeLeft(fromVideoId: 'video$i');
      }

      // Assert
      verify(mockApi.onSwipeLeft()).called(10);
    });

    test('handles swipe with full context', () {
      // Arrange
      const fromVideoId = 'video123';
      const toVideoId = 'video124';
      const position = 5;
      final metadata = {
        'screen': 'reels_screen',
        'action': 'profile_view',
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Act
      service.notifySwipeLeft(
        fromVideoId: fromVideoId,
        toVideoId: toVideoId,
        position: position,
        metadata: metadata,
      );

      // Assert
      verify(mockApi.onSwipeLeft()).called(1);
    });

    test('handles back-and-forth navigation', () {
      // Act - Simulate user navigating back and forth
      service.notifySwipeLeft(
        fromVideoId: 'main_feed',
        toVideoId: 'profile_screen',
      );
      service.notifySwipeRight(
        fromVideoId: 'profile_screen',
        toVideoId: 'main_feed',
      );
      service.notifySwipeLeft(
        fromVideoId: 'main_feed',
        toVideoId: 'profile_screen',
      );

      // Assert
      verify(mockApi.onSwipeLeft()).called(2);
      verify(mockApi.onSwipeRight()).called(1);
    });
  });
}
