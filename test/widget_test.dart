// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:BlackFlipper/main.dart';
import 'package:BlackFlipper/Pages/SplashScreen.dart';
import 'package:BlackFlipper/Pages/HomePage.dart';

void main() {
  testWidgets('Splash screen navigates to home page after delay', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that Splash Screen is shown first.
    expect(find.byType(SplashScreenWidget), findsOneWidget);
    expect(find.text('Black'), findsOneWidget);
    expect(find.byType(HomePageWidget), findsNothing);

    // Wait for the splash screen duration to pass and for the navigation to complete.
    // The splash screen has a 5000ms delay. We wait a bit longer to be safe.
    await tester.pumpAndSettle(const Duration(milliseconds: 5100));

    // Verify that we have navigated to the HomePage.
    expect(find.byType(HomePageWidget), findsOneWidget);
    expect(find.byType(SplashScreenWidget), findsNothing);
  });
}
