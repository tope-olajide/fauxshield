import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:fauxshield_flutter/widgets/batch_stats_grid.dart';
import 'package:fauxshield_flutter/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

BatchStats _stats({
  int totalIdentities = 2400,
  int generated = 2300,
  int active = 1830,
  int verified = 1500,
  int locked = 12,
  int recalled = 3,
  int flagged = 27,
}) => BatchStats(
  batchId: UuidValue.withValidation('00000000-0000-4000-8000-000000000000'),
  totalIdentities: totalIdentities,
  generated: generated,
  active: active,
  verified: verified,
  locked: locked,
  recalled: recalled,
  deleted: 4,
  flagged: flagged,
  generatedAt: DateTime.utc(2026, 10, 9),
);

Future<void> _pumpGrid(
  WidgetTester tester,
  Size surface,
  BatchStats stats,
) async {
  tester.view.physicalSize = surface;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BatchStatsGrid(stats: stats),
        ),
      ),
    ),
  );
}

/// Asserts no layout exceptions fired and that every value and label sits
/// fully inside its own tile.
void _expectTilesFit(WidgetTester tester) {
  expect(tester.takeException(), isNull, reason: 'layout overflowed');
  final tiles = tester.widgetList<StatTile>(find.byType(StatTile)).toList();
  expect(tiles, hasLength(6));
  for (final tile in tiles) {
    final tileFinder = find.byWidget(tile);
    final tileRect = tester.getRect(tileFinder);
    for (final text in <String>[tile.value, tile.label]) {
      final textRect = tester.getRect(
        find.descendant(of: tileFinder, matching: find.text(text)),
      );
      expect(
        textRect.left,
        greaterThanOrEqualTo(tileRect.left - 0.5),
        reason: '"$text" spills left out of its tile',
      );
      expect(
        textRect.right,
        lessThanOrEqualTo(tileRect.right + 0.5),
        reason: '"$text" spills right out of its tile',
      );
      expect(
        textRect.top,
        greaterThanOrEqualTo(tileRect.top - 0.5),
        reason: '"$text" spills above its tile',
      );
      expect(
        textRect.bottom,
        lessThanOrEqualTo(tileRect.bottom + 0.5),
        reason: '"$text" spills below its tile',
      );
    }
  }
}

void main() {
  testWidgets('phone width: values stay inside compact tiles', (
    tester,
  ) async {
    await _pumpGrid(tester, const Size(360, 800), _stats());
    _expectTilesFit(tester);

    final sizes = tester
        .widgetList<StatTile>(find.byType(StatTile))
        .map((tile) => tester.getSize(find.byWidget(tile)))
        .toList();
    for (final size in sizes) {
      // ~160px wide: readable, and never the squeezed 93px sliver that
      // pushed values out of the tile before.
      expect(size.width, greaterThan(120));
      expect(size.width, lessThan(200));
    }
    // Two columns on a 360px screen means the six tiles form at least two
    // distinct rows.
    final tiles = tester.widgetList<StatTile>(find.byType(StatTile)).toList();
    final rowTops = tiles
        .map((tile) => tester.getRect(find.byWidget(tile)).top.round())
        .toSet();
    expect(rowTops.length, greaterThanOrEqualTo(2));
  });

  testWidgets('desktop width: tiles stay compact instead of stretching', (
    tester,
  ) async {
    await _pumpGrid(tester, const Size(1400, 900), _stats());
    _expectTilesFit(tester);

    final tiles = tester.widgetList<StatTile>(find.byType(StatTile)).toList();
    final rects = tiles
        .map((tile) => tester.getRect(find.byWidget(tile)))
        .toList();
    for (final rect in rects) {
      // The old GridView stretched 3 columns across the whole window;
      // now no tile is wider than 200px.
      expect(rect.width, lessThan(200));
    }
    // All six fit on a single row.
    final rows = rects.map((rect) => rect.top.round()).toSet();
    expect(rows, hasLength(1));
  });

  testWidgets('large values scale down rather than overflow', (tester) async {
    await _pumpGrid(
      tester,
      const Size(360, 800),
      _stats(
        totalIdentities: 987654321,
        active: 123456789,
        verified: 1000000,
      ),
    );
    _expectTilesFit(tester);
    expect(find.text('987654321'), findsOneWidget);
  });
}
