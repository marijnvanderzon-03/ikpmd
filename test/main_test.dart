import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eindopdracht/main.dart';

void main() {
  testWidgets('expect to find circular progress indicator',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: const MyApp()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('test if screen widgets are build', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: const MyApp()));
    expect(
        find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
  });
}
