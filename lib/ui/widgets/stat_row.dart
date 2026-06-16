import 'package:flutter/material.dart';

import '../../models/difficulty.dart';
import '../../storage/stats_store.dart';
import '../../theme/veld_colors.dart';

class StatRow extends StatelessWidget {
  const StatRow({
    super.key,
    required this.difficulty,
    required this.stats,
  });

  final Difficulty difficulty;
  final DifficultyStats stats;

  String _formatTime(int? seconds) {
    if (seconds == null) return '—';
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(
              difficulty.label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: Text(
              'Best ${_formatTime(stats.bestSeconds)}  ·  ${stats.completed} completed',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class VeldSectionCard extends StatelessWidget {
  const VeldSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

String formatElapsed(int seconds) {
  final minutes = seconds ~/ 60;
  final secs = seconds % 60;
  return '$minutes:${secs.toString().padLeft(2, '0')}';
}
