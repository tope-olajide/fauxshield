import 'package:fauxshield_flutter/screens/product_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    const MaterialApp(home: ProductEditorScreen()),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('page shows the full reference field set on desktop', (
    tester,
  ) async {
    await _pumpScreen(tester);
    expect(tester.takeException(), isNull);

    for (final label in <String>[
      'New product',
      'Product name *',
      'Category',
      'SKU',
      'Description',
      'Packaging',
      'Shelf life',
      'Country restrictions',
      'Safety instructions',
      'Product imagery',
    ]) {
      expect(find.text(label), findsOneWidget, reason: 'missing $label');
    }
    expect(find.text('Add image'), findsOneWidget);
    expect(find.text('Create product'), findsOneWidget);
    // The form uses the full page width instead of a cramped modal.
    expect(
      tester.getSize(find.byType(Scaffold)).width,
      greaterThanOrEqualTo(1000),
    );
  });

  testWidgets('empty name is rejected before any network call', (
    tester,
  ) async {
    await _pumpScreen(tester);
    // The client is never initialized in tests, so any network attempt
    // would throw; a clean validation error proves submit was blocked.
    // Tap the always-visible app bar action (the bottom one may be folded).
    await tester.tap(find.widgetWithText(FilledButton, 'Create'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Enter at least 2 characters.'), findsOneWidget);
  });
}
