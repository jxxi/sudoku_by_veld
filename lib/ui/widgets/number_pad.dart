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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
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
                minimumSize: const Size(36, 44),
              ),
              child: Text('$digit'),
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
