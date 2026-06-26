import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/main.dart';

void main() {
  testWidgets('Calculator shows 0 on start', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    // '0' appears in the display and as the '0' button
    expect(find.text('0'), findsNWidgets(2));
  });

  testWidgets('Tap digit updates display', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('5'));
    await tester.pump();
    // '5' appears in the display and as the '5' button
    expect(find.text('5'), findsNWidgets(2));
  });

  testWidgets('Addition works', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('3'));
    await tester.pump();
    await tester.tap(find.text('+'));
    await tester.pump();
    await tester.tap(find.text('4'));
    await tester.pump();
    await tester.tap(find.text('='));
    await tester.pump();
    // '7' appears in the display and as the '7' button
    expect(find.text('7'), findsNWidgets(2));
  });

  testWidgets('Division by zero shows Error', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('5'));
    await tester.pump();
    await tester.tap(find.text('÷'));
    await tester.pump();
    await tester.tap(find.text('0'));
    await tester.pump();
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('Error'), findsOneWidget);
  });
}
