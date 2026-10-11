import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import 'common.dart';

/// The six batch counters — planned, active, verified, flagged, locked and
/// recalled — laid out as a responsive tile grid.
///
/// Column count adapts to the available width (2 on a phone, up to 6 on a
/// desktop window) and each tile gets a fixed, human-sized width instead of
/// stretching across the screen. Tile height follows the content, so the
/// values and labels always stay inside the tile.
class BatchStatsGrid extends StatelessWidget {
  const BatchStatsGrid({super.key, required this.stats});

  final BatchStats stats;

  static const double _spacing = 8;

  /// Target width per tile; drives the column count.
  static const double _targetTileWidth = 150;

  /// The grid never grows wider than this on large windows.
  static const double _maxGridWidth = 960;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      StatTile(label: 'Planned', value: '${stats.totalIdentities}'),
      StatTile(label: 'Active', value: '${stats.active}'),
      StatTile(label: 'Verified', value: '${stats.verified}'),
      StatTile(
        label: 'Flagged',
        value: '${stats.flagged}',
        color: const Color(0xFFB45309),
      ),
      StatTile(
        label: 'Locked',
        value: '${stats.locked}',
        color: const Color(0xFFC2410C),
      ),
      StatTile(
        label: 'Recalled',
        value: '${stats.recalled}',
        color: Theme.of(context).colorScheme.error,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final available = maxWidth.isFinite
            ? maxWidth.clamp(0.0, _maxGridWidth).toDouble()
            : _maxGridWidth;
        final columns = (available / _targetTileWidth)
            .floor()
            .clamp(2, 6)
            .toInt();
        // Floor so float rounding can never push the last tile of a row
        // over the limit and wrap it onto an extra row.
        final tileWidth = ((available - _spacing * (columns - 1)) / columns)
            .floorToDouble();
        return SizedBox(
          width: available,
          child: Wrap(
            spacing: _spacing,
            runSpacing: _spacing,
            children: <Widget>[
              for (final tile in tiles) SizedBox(width: tileWidth, child: tile),
            ],
          ),
        );
      },
    );
  }
}
