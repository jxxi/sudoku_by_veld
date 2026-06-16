import 'package:flutter/material.dart';

import '../../models/difficulty.dart';
import '../../theme/veld_colors.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose difficulty')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Pick your pace',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'All difficulties are open. Take the path that feels right today.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          for (final difficulty in Difficulty.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  title: Text(difficulty.label),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pop(difficulty),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'Expert and Diabolical expect deeper techniques — see Learn for field notes.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: VeldColors.inkMuted,
                ),
          ),
        ],
      ),
    );
  }
}
