import 'package:flutter/material.dart';

import '../../theme/veld_colors.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.pencilMode,
    required this.onDigit,
    required this.onErase,
    required this.onTogglePencil,
    required this.onHint,
    this.showHint = true,
    this.completedDigits = const {},
  });

  final bool pencilMode;
  final ValueChanged<int> onDigit;
  final VoidCallback onErase;
  final VoidCallback onTogglePencil;
  final VoidCallback onHint;
  final bool showHint;
  final Set<int> completedDigits;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onTogglePencil,
                icon: Icon(
                  Icons.edit_outlined,
                  color: pencilMode ? VeldColors.sage : VeldColors.inkMuted,
                ),
                label: Text(pencilMode ? 'Pencil on' : 'Pencil'),
              ),
            ),
            const SizedBox(width: 12),
            if (showHint)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onHint,
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('Hint'),
                ),
              )
            else
              const Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 6.0;
            final cellWidth = (constraints.maxWidth - spacing * 8) / 9;
            final cellHeight = cellWidth.clamp(36.0, 48.0);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 9,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                childAspectRatio: cellWidth / cellHeight,
              ),
              itemBuilder: (context, index) {
                final digit = index + 1;
                if (completedDigits.contains(digit)) {
                  return const SizedBox.shrink();
                }
                return FilledButton(
                  onPressed: () => onDigit(digit),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('$digit'),
                );
              },
            );
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onErase,
          icon: const Icon(Icons.backspace_outlined),
          label: const Text('Erase'),
        ),
      ],
    );
  }
}
