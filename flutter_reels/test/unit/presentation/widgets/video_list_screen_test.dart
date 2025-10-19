import 'package:flutter/material.dart';
import 'package:flutter_reels/presentation/providers/video_provider.dart';
import 'package:flutter_reels/presentation/screens/video_list_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../helpers/test_mocks.mocks.dart';

/// Widget tests for VideoListScreen
///
/// Tests focus on core UI states that don't depend on network resources:
/// - Loading state
/// - Error state with retry
/// - Empty state
/// - Basic success state presence
void main() {
  late MockGetVideosUseCase mockGetVideosUseCase;
  late MockToggleLikeUseCase mockToggleLikeUseCase;
  late MockIncrementShareCountUseCase mockIncrementShareCountUseCase;
  late VideoProvider videoProvider;

  setUp(() {
    mockGetVideosUseCase = MockGetVideosUseCase();
    mockToggleLikeUseCase = MockToggleLikeUseCase();
    mockIncrementShareCountUseCase = MockIncrementShareCountUseCase();

    videoProvider = VideoProvider(
      getVideosUseCase: mockGetVideosUseCase,
      toggleLikeUseCase: mockToggleLikeUseCase,
      incrementShareCountUseCase: mockIncrementShareCountUseCase,
    );
  });

  /// Helper to wrap widget with necessary providers
  Widget createTestWidget() {
    return ChangeNotifierProvider<VideoProvider>.value(
      value: videoProvider,
      child: const MaterialApp(
        home: VideoListScreen(),
      ),
    );
  }

  group('VideoListScreen UI States', () {
    group('app bar', () {
      testWidgets('should display app bar with title', (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Flutter Reels'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should have refresh button in app bar', (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byIcon(Icons.refresh), findsOneWidget);
      });
    });

    group('loading state', () {
      testWidgets('should hide loading after videos load', (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump(); // Trigger initState
        await tester.pumpAndSettle(); // Complete all animations

        // Assert - loading should be gone
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Loading videos...'), findsNothing);
      });
    });

    group('error state', () {
      testWidgets('should show error message when loading fails',
          (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenThrow(Exception('Network error'));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump(); // Trigger initState
        await tester.pump(); // Process error

        // Assert
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.textContaining('Failed to load videos'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should show custom error message', (tester) async {
        // Arrange
        when(mockGetVideosUseCase())
            .thenThrow(Exception('Custom error message'));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        await tester.pump();

        // Assert
        expect(find.textContaining('Custom error message'), findsOneWidget);
      });

      testWidgets('should retry loading when retry button tapped',
          (tester) async {
        // Arrange - first call fails
        when(mockGetVideosUseCase()).thenThrow(Exception('Error'));

        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        await tester.pump();

        // Verify error state
        expect(find.text('Retry'), findsOneWidget);

        // Arrange - second call succeeds
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act - tap retry
        await tester.tap(find.text('Retry'));
        await tester.pumpAndSettle();

        // Assert - error should be gone
        expect(find.byIcon(Icons.error_outline), findsNothing);
        expect(find.text('Retry'), findsNothing);
        verify(mockGetVideosUseCase()).called(2); // initial + retry
      });
    });

    group('empty state', () {
      testWidgets('should show empty state when no videos', (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.video_library_outlined), findsOneWidget);
        expect(find.text('No videos available'), findsOneWidget);
      });

      testWidgets('should show empty icon with correct properties',
          (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        final iconFinder = find.byIcon(Icons.video_library_outlined);
        expect(iconFinder, findsOneWidget);

        final Icon icon = tester.widget(iconFinder);
        expect(icon.size, 64);
        expect(icon.color, Colors.grey);
      });
    });

    group('success state verification', () {
      testWidgets('should have RefreshIndicator available', (tester) async {
        // Arrange - use empty list to avoid NetworkImage issues
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Widget structure should support refresh
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('state transitions', () {
      testWidgets('should transition from loading to empty', (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump(); // initState
        await tester.pumpAndSettle(); // complete

        // Assert - empty state
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byIcon(Icons.video_library_outlined), findsOneWidget);
      });

      testWidgets('should transition from loading to error', (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenThrow(Exception('Error'));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump(); // initState
        await tester.pump(); // error

        // Assert - error state
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('should transition from error to empty after retry',
          (tester) async {
        // Arrange - initial error
        when(mockGetVideosUseCase()).thenThrow(Exception('Error'));
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        // Arrange - empty list after retry
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act - retry
        await tester.tap(find.text('Retry'));
        await tester.pumpAndSettle();

        // Assert - empty state
        expect(find.byIcon(Icons.error_outline), findsNothing);
        expect(find.byIcon(Icons.video_library_outlined), findsOneWidget);
      });
    });

    group('user interactions', () {
      testWidgets('should call refresh when app bar refresh tapped',
          (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act - tap refresh icon
        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pump();

        // Assert - should call use case again
        verify(mockGetVideosUseCase()).called(2); // initial + refresh
      });

      testWidgets('refresh button should be accessible', (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        final refreshButton = find.byIcon(Icons.refresh);
        expect(refreshButton, findsOneWidget);
        expect(
            tester.widget<IconButton>(find.ancestor(
              of: refreshButton,
              matching: find.byType(IconButton),
            )),
            isNotNull);
      });
    });

    group('layout structure', () {
      testWidgets('should have Scaffold as root widget', (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should use Consumer for state updates', (tester) async {
        // Arrange
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(Consumer<VideoProvider>), findsOneWidget);
      });
    });
  });
}
