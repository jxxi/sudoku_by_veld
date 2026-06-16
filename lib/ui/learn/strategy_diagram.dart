import 'package:flutter/material.dart';

import '../../theme/veld_colors.dart';

enum DiagramCellRole { normal, primary, secondary, eliminated }

class DiagramCellData {
  const DiagramCellData({
    this.value,
    this.notes = const {},
    this.role = DiagramCellRole.normal,
    this.showFocusDigit = false,
  });

  final int? value;
  final Set<int> notes;
  final DiagramCellRole role;
  final bool showFocusDigit;
}

class FieldNote {
  const FieldNote({
    required this.title,
    required this.body,
    required this.caption,
    required this.gridSize,
    required this.cells,
    this.focusDigit,
  });

  final String title;
  final String body;
  final String caption;
  final int gridSize;
  final List<List<DiagramCellData>> cells;
  final int? focusDigit;
}

class StrategyDiagram extends StatelessWidget {
  const StrategyDiagram({
    super.key,
    required this.note,
  });

  final FieldNote note;

  @override
  Widget build(BuildContext context) {
    final size = note.gridSize;
    final box = size == 4 ? 2 : 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: VeldColors.surfaceMuted,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: VeldColors.blockLine, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Column(
                children: List.generate(size, (row) {
                  return Expanded(
                    child: Row(
                      children: List.generate(size, (col) {
                        final cell = note.cells[row][col];
                        return Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _backgroundFor(cell.role),
                              border: Border(
                                right: BorderSide(
                                  color: col == size - 1
                                      ? Colors.transparent
                                      : (col % box == box - 1
                                          ? VeldColors.blockLine
                                          : VeldColors.gridLine),
                                  width: col % box == box - 1 ? 1.25 : 0.75,
                                ),
                                bottom: BorderSide(
                                  color: row == size - 1
                                      ? Colors.transparent
                                      : (row % box == box - 1
                                          ? VeldColors.blockLine
                                          : VeldColors.gridLine),
                                  width: row % box == box - 1 ? 1.25 : 0.75,
                                ),
                              ),
                            ),
                            child: _DiagramCellContent(
                              cell: cell,
                              focusDigit: note.focusDigit,
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
        ),
        const SizedBox(height: 8),
        Text(
          note.caption,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: VeldColors.inkMuted,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }

  Color _backgroundFor(DiagramCellRole role) {
    return switch (role) {
      DiagramCellRole.primary => VeldColors.selectedGlow,
      DiagramCellRole.secondary => VeldColors.houseHighlight,
      DiagramCellRole.eliminated => const Color(0x33C62828),
      DiagramCellRole.normal => VeldColors.surface,
    };
  }
}

class _DiagramCellContent extends StatelessWidget {
  const _DiagramCellContent({
    required this.cell,
    required this.focusDigit,
  });

  final DiagramCellData cell;
  final int? focusDigit;

  @override
  Widget build(BuildContext context) {
    if (cell.value != null) {
      final isFocus = focusDigit != null && cell.value == focusDigit;
      return Center(
        child: Text(
          '${cell.value}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isFocus ? VeldColors.sage : VeldColors.ink,
          ),
        ),
      );
    }

    if (cell.notes.isNotEmpty) {
      final gridCount = cell.notes.length <= 4 ? 2 : 3;
      return Padding(
        padding: const EdgeInsets.all(2),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gridCount * gridCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCount,
          ),
          itemBuilder: (context, index) {
            final digit = index + 1;
            final show = cell.notes.contains(digit);
            final isFocus = focusDigit == digit;
            final eliminated = cell.role == DiagramCellRole.eliminated &&
                cell.showFocusDigit &&
                focusDigit == digit;

            return Center(
              child: Text(
                show ? '$digit' : '',
                style: TextStyle(
                  fontSize: gridCount == 2 ? 9 : 7,
                  color: eliminated
                      ? VeldColors.mistake
                      : isFocus
                          ? VeldColors.sage
                          : VeldColors.inkMuted,
                  decoration:
                      eliminated ? TextDecoration.lineThrough : null,
                  fontWeight: isFocus ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
