// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_reels/main.dart';

void main() {
  testWidgets('Hello World screen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlutterReelsApp());

    // Verify that Hello World text is displayed.
    expect(find.text('Hello World!'), findsOneWidget);
    
    // Verify that Flutter Reels Module text is displayed.
    expect(find.text('Flutter Reels Module'), findsAtLeast(1));
    
    // Verify that the video library icon is displayed.
    expect(find.byIcon(Icons.video_library), findsOneWidget);
  });

  testWidgets('App has correct title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlutterReelsApp());

    // Verify that the app bar title is correct.
    expect(find.widgetWithText(AppBar, 'Flutter Reels Module'), findsOneWidget);
  });
}
