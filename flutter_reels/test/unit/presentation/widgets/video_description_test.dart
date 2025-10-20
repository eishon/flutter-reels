import 'package:flutter/material.dart';
import 'package:flutter_reels/domain/entities/user_entity.dart';
import 'package:flutter_reels/domain/entities/video_entity.dart';
import 'package:flutter_reels/presentation/widgets/video_description.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late VideoEntity testVideo;
  late bool isMuted;
  late int toggleMuteCallCount;

  setUp(() {
    isMuted = false;
    toggleMuteCallCount = 0;

    testVideo = const VideoEntity(
      id: '1',
      url: 'https://example.com/video.mp4',
      title: 'Test Video',
      description: 'Test video description #flutter #testing',
      user: UserEntity(
        name: 'testuser',
        avatarUrl: 'https://example.com/avatar.jpg',
      ),
      likes: 100,
      comments: 10,
      shares: 50,
      isLiked: false,
      category: 'Technology',
      duration: '00:30',
      quality: '1080p',
      format: 'mp4',
      products: [],
    );
  });

  Widget createTestWidget({
    required VideoEntity video,
    required bool muted,
    required VoidCallback onToggleMute,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: VideoDescription(
          video: video,
          isMuted: muted,
          onToggleMute: onToggleMute,
        ),
      ),
    );
  }

  group('VideoDescription Widget', () {
    testWidgets('should display username', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          video: testVideo,
          muted: isMuted,
          onToggleMute: () {},
        ),
      );

      expect(find.text('@testuser'), findsOneWidget);
    });

    testWidgets('should display avatar', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          video: testVideo,
          muted: isMuted,
          onToggleMute: () {},
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should not display follow button', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          video: testVideo,
          muted: isMuted,
          onToggleMute: () {},
        ),
      );

      expect(find.text('Follow'), findsNothing);
    });

    testWidgets('should display video description', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          video: testVideo,
          muted: isMuted,
          onToggleMute: () {},
        ),
      );

      expect(
        find.text('Test video description #flutter #testing'),
        findsOneWidget,
      );
    });

    testWidgets('should display audio info with music note when unmuted',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          video: testVideo,
          muted: false,
          onToggleMute: () {},
        ),
      );

      expect(find.byIcon(Icons.music_note), findsOneWidget);
      expect(find.byIcon(Icons.volume_off), findsNothing);
      expect(find.text('Original Audio - testuser'), findsOneWidget);
    });

    testWidgets('should display volume off icon when muted', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          video: testVideo,
          muted: true,
          onToggleMute: () {},
        ),
      );

      expect(find.byIcon(Icons.volume_off), findsOneWidget);
      expect(find.byIcon(Icons.music_note), findsNothing);
      expect(find.text('Audio muted'), findsOneWidget);
    });

    testWidgets('should call onToggleMute when audio info is tapped',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          video: testVideo,
          muted: isMuted,
          onToggleMute: () => toggleMuteCallCount++,
        ),
      );

      // Find and tap the audio info container
      final audioInfo = find.byType(GestureDetector).first;
      await tester.tap(audioInfo);
      await tester.pump();

      expect(toggleMuteCallCount, 1);
    });

    testWidgets('should show snackbar when audio info is tapped',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          video: testVideo,
          muted: false,
          onToggleMute: () {},
        ),
      );

      // Tap the audio info
      final audioInfo = find.byType(GestureDetector).first;
      await tester.tap(audioInfo);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Audio muted'), findsOneWidget);
    });

    testWidgets('should expand description when tapped if long', (tester) async {
      const longDescriptionVideo = VideoEntity(
        id: '1',
        url: 'https://example.com/video.mp4',
        title: 'Test Video',
        description: 'This is a very long description that should be expandable because it contains more than 100 characters and should trigger the expand functionality',
        user: UserEntity(
          name: 'testuser',
          avatarUrl: 'https://example.com/avatar.jpg',
        ),
        likes: 100,
        comments: 10,
        shares: 50,
        isLiked: false,
        category: 'Technology',
        duration: '00:30',
        quality: '1080p',
        format: 'mp4',
        products: [],
      );

      await tester.pumpWidget(
        createTestWidget(
          video: longDescriptionVideo,
          muted: isMuted,
          onToggleMute: () {},
        ),
      );

      // Should show "more" text initially
      expect(find.text(' more', findRichText: true), findsOneWidget);

      // Tap to expand
      await tester.tap(find.byType(RichText));
      await tester.pumpAndSettle();

      // Should not show "more" text after expansion
      expect(find.text(' more', findRichText: true), findsNothing);
    });
  });
}
