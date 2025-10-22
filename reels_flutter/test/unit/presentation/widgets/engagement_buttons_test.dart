import 'package:flutter/material.dart';
import 'package:reels_flutter/domain/entities/user_entity.dart';
import 'package:reels_flutter/domain/entities/video_entity.dart';
import 'package:reels_flutter/presentation/widgets/engagement_buttons.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late VideoEntity testVideo;
  late int likeCallCount;
  late int shareCallCount;

  setUp(() {
    likeCallCount = 0;
    shareCallCount = 0;

    testVideo = const VideoEntity(
      id: '1',
      url: 'https://example.com/video.mp4',
      title: 'Test Video',
      description: 'Test video',
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
    required VoidCallback onLike,
    required VoidCallback onShare,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: EngagementButtons(video: video, onLike: onLike, onShare: onShare),
      ),
    );
  }

  group('EngagementButtons Widget', () {
    testWidgets('should display like button with count', (tester) async {
      await tester.pumpWidget(
        createTestWidget(video: testVideo, onLike: () {}, onShare: () {}),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('should display filled heart when liked', (tester) async {
      final likedVideo = testVideo.copyWith(isLiked: true);

      await tester.pumpWidget(
        createTestWidget(video: likedVideo, onLike: () {}, onShare: () {}),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('should display share button with count', (tester) async {
      await tester.pumpWidget(
        createTestWidget(video: testVideo, onLike: () {}, onShare: () {}),
      );

      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('should display horizontal more options icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(video: testVideo, onLike: () {}, onShare: () {}),
      );

      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsNothing);
    });

    testWidgets('should call onLike when like button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          video: testVideo,
          onLike: () => likeCallCount++,
          onShare: () {},
        ),
      );

      // Find the like button by icon
      final likeButton = find.byIcon(Icons.favorite_border);
      await tester.tap(likeButton);
      await tester.pump();

      expect(likeCallCount, 1);
    });

    testWidgets('should call onShare when share button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          video: testVideo,
          onLike: () {},
          onShare: () => shareCallCount++,
        ),
      );

      // Find the share button by icon
      final shareButton = find.byIcon(Icons.share_outlined);
      await tester.tap(shareButton);
      await tester.pump();

      expect(shareCallCount, 1);
    });

    testWidgets('should animate like button when tapped', (tester) async {
      await tester.pumpWidget(
        createTestWidget(video: testVideo, onLike: () {}, onShare: () {}),
      );

      // Tap the like button
      final likeButton = find.byIcon(Icons.favorite_border);
      await tester.tap(likeButton);

      // Pump animation frames
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Animation should complete without errors
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should format like count correctly', (tester) async {
      final videoWithManyLikes = testVideo.copyWith(likes: 1500);

      await tester.pumpWidget(
        createTestWidget(
          video: videoWithManyLikes,
          onLike: () {},
          onShare: () {},
        ),
      );

      expect(find.text('1.5K'), findsOneWidget);
    });

    testWidgets('should format share count correctly', (tester) async {
      final videoWithManyShares = testVideo.copyWith(shares: 2300);

      await tester.pumpWidget(
        createTestWidget(
          video: videoWithManyShares,
          onLike: () {},
          onShare: () {},
        ),
      );

      expect(find.text('2.3K'), findsOneWidget);
    });
  });
}
