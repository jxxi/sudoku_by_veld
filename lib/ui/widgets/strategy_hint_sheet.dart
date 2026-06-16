import 'package:flutter/material.dart';

import '../../logic/hint_engine.dart';
import '../../theme/veld_colors.dart';

class StrategyHintSheet extends StatelessWidget {
  const StrategyHintSheet({
    super.key,
    required this.hint,
    required this.onApply,
  });

  final StrategyHint hint;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              hint.technique,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Card(
              color: VeldColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(hint.explanation),
              ),
            ),
            const SizedBox(height: 16),
            if (hint.placement != null)
              FilledButton(
                onPressed: onApply,
                child: const Text('Apply placement'),
              ),
            if (hint.placement != null) const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        ),
      ),
    );
  }
}
