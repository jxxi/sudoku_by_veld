import 'package:flutter/material.dart';

import '../../theme/veld_colors.dart';

enum DiagramCellRole { normal, primary, house, eliminated }

class DiagramCellData {
  const DiagramCellData({
    this.value,
    this.notes = const {},
    this.role = DiagramCellRole.normal,
    this.showFocusDigit = false,
    this.circledNotes = const {},
    this.struckNotes = const {},
  });

  final int? value;
  final Set<int> notes;
  final DiagramCellRole role;
  final bool showFocusDigit;
  final Set<int> circledNotes;
  final Set<int> struckNotes;
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
                          child: DecoratedBox(
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
                            child: DecoratedBox(
                              decoration: cell.role == DiagramCellRole.primary
                                  ? BoxDecoration(
                                      border: Border.all(
                                        color: VeldColors.sage,
                                        width: 2,
                                      ),
                                    )
                                  : const BoxDecoration(),
                              child: _DiagramCellContent(
                                cell: cell,
                                focusDigit: note.focusDigit,
                                gridSize: size,
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
      DiagramCellRole.primary => const Color(0x4D6B7F5E),
      DiagramCellRole.house => const Color(0x40B8956B),
      DiagramCellRole.eliminated => const Color(0x33C62828),
      DiagramCellRole.normal => VeldColors.surface,
    };
  }
}

class _DiagramCellContent extends StatelessWidget {
  const _DiagramCellContent({
    required this.cell,
    required this.focusDigit,
    required this.gridSize,
  });

  final DiagramCellData cell;
  final int? focusDigit;
  final int gridSize;

  @override
  Widget build(BuildContext context) {
    if (cell.value != null) {
      return Center(
        child: Text(
          '${cell.value}',
          style: TextStyle(
            fontSize: gridSize <= 4 ? 18 : 11,
            fontWeight: FontWeight.w700,
            color: VeldColors.ink,
          ),
        ),
      );
    }

    if (cell.notes.isNotEmpty) {
      final gridCount = gridSize == 9 ? 3 : (cell.notes.length <= 4 ? 2 : 3);
      final noteFontSize = gridSize <= 4 ? (gridCount == 2 ? 9.0 : 7.0) : 5.5;
      return Padding(
        padding: EdgeInsets.all(gridSize == 9 ? 1 : 2),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gridCount * gridCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCount,
          ),
          itemBuilder: (context, index) {
            final digit = index + 1;
            if (!cell.notes.contains(digit)) {
              return const SizedBox.shrink();
            }

            final isCircled = cell.circledNotes.contains(digit) ||
                (cell.showFocusDigit && focusDigit == digit);
            final eliminated = cell.struckNotes.contains(digit) ||
                (cell.role == DiagramCellRole.eliminated && isCircled);

            return Center(
              child: _NoteMark(
                digit: digit,
                fontSize: noteFontSize,
                circled: isCircled,
                eliminated: eliminated,
              ),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _NoteMark extends StatelessWidget {
  const _NoteMark({
    required this.digit,
    required this.fontSize,
    required this.circled,
    required this.eliminated,
  });

  final int digit;
  final double fontSize;
  final bool circled;
  final bool eliminated;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      '$digit',
      style: TextStyle(
        fontSize: fontSize,
        height: 1,
        color: eliminated ? VeldColors.mistake : VeldColors.inkMuted,
        decoration: eliminated ? TextDecoration.lineThrough : null,
        fontWeight: FontWeight.w600,
      ),
    );

    if (!circled) return text;

    return Container(
      width: fontSize + 8,
      height: fontSize + 8,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: eliminated ? VeldColors.mistake : VeldColors.mistake,
          width: 1.5,
        ),
      ),
      child: text,
    );
  }
}
