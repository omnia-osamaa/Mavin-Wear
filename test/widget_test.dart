import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mavin_wear/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MavinWearApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
