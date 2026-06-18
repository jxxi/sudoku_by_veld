import 'package:flutter/material.dart';

import '../../theme/veld_colors.dart';

enum RuleGridHighlight { all, row, columnAndBox }

class HowToPlayRuleVisual extends StatelessWidget {
  const HowToPlayRuleVisual({super.key, required this.highlight});

  final RuleGridHighlight highlight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: AspectRatio(
          aspectRatio: 1,
          child: _MiniGrid(highlight: highlight),
        ),
      ),
    );
  }
}

class _MiniGrid extends StatelessWidget {
  const _MiniGrid({required this.highlight});

  final RuleGridHighlight highlight;

  @override
  Widget build(BuildContext context) {
    const sample = [
      [5, 3, 0, 0, 7, 0, 0, 0, 0],
      [6, 0, 0, 1, 9, 5, 0, 0, 0],
      [0, 9, 8, 0, 0, 0, 0, 6, 0],
      [8, 0, 0, 0, 6, 0, 0, 0, 3],
      [4, 0, 0, 8, 0, 3, 0, 0, 1],
      [7, 0, 0, 0, 2, 0, 0, 0, 6],
      [0, 6, 0, 0, 0, 0, 2, 8, 0],
      [0, 0, 0, 4, 1, 9, 0, 0, 5],
      [0, 0, 0, 0, 8, 0, 0, 7, 9],
    ];

    return Container(
      decoration: BoxDecoration(
        color: VeldColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: VeldColors.blockLine),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Column(
          children: List.generate(9, (row) {
            return Expanded(
              child: Row(
                children: List.generate(9, (col) {
                  final value = sample[row][col];
                  final bg = _cellColor(row, col);
                  return Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: bg,
                        border: Border(
                          top: BorderSide(
                            color: row == 0
                                ? Colors.transparent
                                : (row % 3 == 0
                                    ? VeldColors.blockLine
                                    : VeldColors.gridLine),
                            width: row % 3 == 0 ? 1.25 : 0.75,
                          ),
                          left: BorderSide(
                            color: col == 0
                                ? Colors.transparent
                                : (col % 3 == 0
                                    ? VeldColors.blockLine
                                    : VeldColors.gridLine),
                            width: col % 3 == 0 ? 1.25 : 0.75,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          value == 0 ? '' : '$value',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: VeldColors.ink,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  Color _cellColor(int row, int col) {
    return switch (highlight) {
      RuleGridHighlight.all => VeldColors.surface,
      RuleGridHighlight.row when row == 0 => VeldColors.houseHighlight,
      RuleGridHighlight.columnAndBox when col == 4 || (row < 3 && col < 3) =>
        VeldColors.houseHighlight,
      _ => VeldColors.surface,
    };
  }
}
