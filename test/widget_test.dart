// This is a basic Flutter widget test for N-Docs app.

import 'package:flutter_test/flutter_test.dart';

import 'package:ndocs/main.dart';

void main() {
  testWidgets('N-Docs app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NDocsApp());

    // Verify that the welcome page loads
    expect(find.text('Welcome to\nN-Docs'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
