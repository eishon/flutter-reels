import 'package:flutter/material.dart';
import 'package:flutter_reels/domain/entities/user_entity.dart';
import 'package:flutter_reels/domain/entities/video_entity.dart';
import 'package:flutter_reels/presentation/widgets/video_description.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

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
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestWidget(
            video: testVideo,
            muted: isMuted,
            onToggleMute: () {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('@testuser'), findsOneWidget);
      });
    });

    testWidgets('should display avatar', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestWidget(
            video: testVideo,
            muted: isMuted,
            onToggleMute: () {},
          ),
        );
        await tester.pumpAndSettle();

        // Check for CircleAvatar widget
        expect(find.byType(CircleAvatar), findsOneWidget);
      });
    });

    testWidgets('should not display follow button', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestWidget(
            video: testVideo,
            muted: isMuted,
            onToggleMute: () {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Follow'), findsNothing);
      });
    });

    testWidgets('should display video description', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestWidget(
            video: testVideo,
            muted: isMuted,
            onToggleMute: () {},
          ),
        );
        await tester.pumpAndSettle();

        // Description is in a RichText widget, we can find it by searching all RichText widgets
        final richTextFinder = find.byWidgetPredicate((widget) {
          if (widget is RichText) {
            final text = widget.text;
            if (text is TextSpan) {
              return text.toPlainText().contains('Test video description');
            }
          }
          return false;
        });
        
        expect(richTextFinder, findsOneWidget);
      });
    });

    testWidgets('should display audio info with music note when unmuted',
        (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestWidget(
            video: testVideo,
            muted: false,
            onToggleMute: () {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.music_note), findsOneWidget);
        expect(find.byIcon(Icons.volume_off), findsNothing);
        expect(find.text('Original Audio - testuser'), findsOneWidget);
      });
    });

    testWidgets('should display volume off icon when muted', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestWidget(
            video: testVideo,
            muted: true,
            onToggleMute: () {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.volume_off), findsOneWidget);
        expect(find.byIcon(Icons.music_note), findsNothing);
        expect(find.text('Audio muted'), findsOneWidget);
      });
    });

    testWidgets('should call onToggleMute when audio info is tapped',
        (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestWidget(
            video: testVideo,
            muted: isMuted,
            onToggleMute: () => toggleMuteCallCount++,
          ),
        );
        await tester.pumpAndSettle();

        // Find and tap the audio info container
        final audioInfo = find.byType(GestureDetector).last;
        await tester.tap(audioInfo);
        await tester.pumpAndSettle();

        expect(toggleMuteCallCount, 1);
      });
    });

    testWidgets('should show snackbar when audio info is tapped',
        (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestWidget(
            video: testVideo,
            muted: false,
            onToggleMute: () {},
          ),
        );
        await tester.pumpAndSettle();

        // Tap the audio info (last GestureDetector is the audio info)
        final audioInfo = find.byType(GestureDetector).last;
        await tester.tap(audioInfo);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Audio muted'), findsOneWidget);
      });
    });

    testWidgets('should expand description when tapped if long',
        (tester) async {
      const longDescriptionVideo = VideoEntity(
        id: '1',
        url: 'https://example.com/video.mp4',
        title: 'Test Video',
        description:
            'This is a very long description that should be expandable because it contains more than 100 characters and should trigger the expand functionality',
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

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestWidget(
            video: longDescriptionVideo,
            muted: isMuted,
            onToggleMute: () {},
          ),
        );
        await tester.pumpAndSettle();

        // The description is wrapped in a GestureDetector with onTap
        // Find GestureDetector with onTap callback (not the audio info one)
        final descriptionGesture = find.byWidgetPredicate((widget) {
          if (widget is GestureDetector && widget.onTap != null) {
            // Get the child RichText
            if (widget.child is RichText) {
              final richText = widget.child as RichText;
              final textSpan = richText.text as TextSpan;
              return textSpan.toPlainText().contains('very long description');
            }
          }
          return false;
        });
        
        expect(descriptionGesture, findsOneWidget);
        
        // Get the RichText widget from the GestureDetector before expansion
        var gestureDetector = tester.widget<GestureDetector>(descriptionGesture);
        var richText = gestureDetector.child as RichText;
        
        // Should be collapsed initially (maxLines = 2)
        expect(richText.maxLines, equals(2));
        expect(richText.overflow, equals(TextOverflow.ellipsis));

        // Tap to expand
        await tester.tap(descriptionGesture);
        await tester.pumpAndSettle();

        // Get the updated RichText after tapping
        gestureDetector = tester.widget<GestureDetector>(descriptionGesture);
        richText = gestureDetector.child as RichText;
        
        // Should be expanded now (maxLines = null)
        expect(richText.maxLines, isNull);
        expect(richText.overflow, equals(TextOverflow.visible));
      });
    });
  });
}