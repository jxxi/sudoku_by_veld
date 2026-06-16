import 'package:flutter/material.dart';

import '../../logic/hint_engine.dart';
import '../../models/cell_position.dart';
import '../../models/game_state.dart';
import '../../theme/veld_colors.dart';
import 'sudoku_cell_widget.dart';

class SudokuGrid extends StatelessWidget {
  const SudokuGrid({
    super.key,
    required this.state,
    required this.onCellTap,
    this.strategyHint,
  });

  final GameState state;
  final ValueChanged<CellPosition> onCellTap;
  final StrategyHint? strategyHint;

  @override
  Widget build(BuildContext context) {
    final selected = state.selected;
    final selectedValue = state.selectedValue;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: VeldColors.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VeldColors.blockLine, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: List.generate(9, (row) {
              return Expanded(
                child: Row(
                  children: List.generate(9, (col) {
                    final pos = CellPosition(row, col);
                    final cell = state.cells[row][col];

                    final isSelected = selected == pos;
                    final isHouse = selected != null &&
                        !isSelected &&
                        isSameHouse(selected, pos);
                    final isSameNumber = selectedValue != null &&
                        !cell.isEmpty &&
                        cell.value == selectedValue &&
                        !isSelected;

                    final isHintPrimary = strategyHint?.primaryCells
                            .contains(pos) ??
                        false;
                    final isHintSecondary = strategyHint?.secondaryCells
                            .contains(pos) ??
                        false;

                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: col == 8
                                  ? Colors.transparent
                                  : (col % 3 == 2
                                      ? VeldColors.blockLine
                                      : VeldColors.gridLine),
                              width: col % 3 == 2 ? 1.5 : 1,
                            ),
                            bottom: BorderSide(
                              color: row == 8
                                  ? Colors.transparent
                                  : (row % 3 == 2
                                      ? VeldColors.blockLine
                                      : VeldColors.gridLine),
                              width: row % 3 == 2 ? 1.5 : 1,
                            ),
                          ),
                        ),
                        child: SudokuCellWidget(
                          cell: cell,
                          isSelected: isSelected,
                          isHouseHighlighted: isHouse,
                          isSameNumberHighlighted: isSameNumber,
                          isHintPrimary: isHintPrimary,
                          isHintSecondary: isHintSecondary,
                          onTap: () => onCellTap(pos),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
