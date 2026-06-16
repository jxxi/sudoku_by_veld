import 'package:flutter/material.dart';

import '../../models/cell_position.dart';
import '../../models/sudoku_cell.dart';
import '../../theme/veld_colors.dart';

class SudokuCellWidget extends StatelessWidget {
  const SudokuCellWidget({
    super.key,
    required this.cell,
    required this.isSelected,
    required this.isHouseHighlighted,
    required this.isSameNumberHighlighted,
    required this.onTap,
    this.isHintPrimary = false,
    this.isHintSecondary = false,
    this.isTutorialTarget = false,
    this.showMistakeFeedback = true,
  });

  final SudokuCell cell;
  final bool isSelected;
  final bool isHouseHighlighted;
  final bool isSameNumberHighlighted;
  final bool isHintPrimary;
  final bool isHintSecondary;
  final bool isTutorialTarget;
  final bool showMistakeFeedback;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color background = VeldColors.surface;
    if (isHintSecondary) {
      background = VeldColors.sameNumberHighlight;
    }
    if (isHouseHighlighted) {
      background = VeldColors.houseHighlight;
    }
    if (isSameNumberHighlighted) {
      background = VeldColors.sameNumberHighlight;
    }
    if (isHintPrimary) {
      background = VeldColors.selectedGlow;
    }
    if (isSelected) {
      background = VeldColors.selectedGlow;
    }

    final border = isSelected
        ? Border.all(color: VeldColors.sage, width: 2)
        : isTutorialTarget
            ? Border.all(color: VeldColors.ochre, width: 2)
            : isHintPrimary
                ? Border.all(color: VeldColors.ochre, width: 2)
                : null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: background,
          border: border,
        ),
        child: cell.isEmpty
            ? _NotesGrid(notes: cell.notes)
            : Center(
                child: Text(
                  '${cell.value}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: cell.isGiven ? FontWeight.w700 : FontWeight.w500,
                    color: cell.isWrong && showMistakeFeedback
                        ? VeldColors.mistake
                        : VeldColors.ink,
                  ),
                ),
              ),
      ),
    );
  }
}

class _NotesGrid extends StatelessWidget {
  const _NotesGrid({required this.notes});

  final Set<int> notes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          final digit = index + 1;
          final show = notes.contains(digit);
          return Center(
            child: Text(
              show ? '$digit' : '',
              style: const TextStyle(
                fontSize: 9,
                color: VeldColors.inkMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }
}

bool isSameHouse(CellPosition a, CellPosition b) {
  return a.row == b.row ||
      a.col == b.col ||
      (a.boxRow == b.boxRow && a.boxCol == b.boxCol);
}
