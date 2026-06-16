import 'package:flutter/material.dart';

import '../../models/difficulty.dart';
import '../../storage/stats_store.dart';
import '../../theme/veld_colors.dart';
import '../widgets/stat_row.dart';
import 'difficulty_screen.dart';
import 'game_screen.dart';
import 'learn_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.statsStore,
    required this.onStatsChanged,
  });

  final StatsStore statsStore;
  final VoidCallback onStatsChanged;

  @override
  Widget build(BuildContext context) {
    final stats = statsStore.loadStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku by Veld'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(statsStore: statsStore),
                ),
              );
              onStatsChanged();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to the veld',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unhurried puzzles, field notes, and room to think.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                final difficulty = await Navigator.of(context).push<Difficulty>(
                  MaterialPageRoute(builder: (_) => const DifficultyScreen()),
                );
                if (difficulty == null || !context.mounted) return;

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GameScreen(
                      difficulty: difficulty,
                      statsStore: statsStore,
                      onCompleted: onStatsChanged,
                    ),
                  ),
                );
              },
              child: const Text('New game'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LearnScreen(statsStore: statsStore),
                  ),
                );
              },
              child: const Text('Learn'),
            ),
            const SizedBox(height: 24),
            VeldSectionCard(
              title: 'Your stats',
              child: Column(
                children: [
                  for (final difficulty in Difficulty.values)
                    StatRow(
                      difficulty: difficulty,
                      stats: stats[difficulty] ?? const DifficultyStats(),
                    ),
                ],
              ),
            ),
            if (!statsStore.tipJarPurchased) ...[
              const SizedBox(height: 16),
              Card(
                color: VeldColors.surface,
                child: ListTile(
                  title: const Text('Support the Veld'),
                  subtitle: const Text('Optional tip jar — thanks for playing.'),
                  trailing: const Icon(Icons.favorite_outline),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SettingsScreen(
                          statsStore: statsStore,
                          openTipJar: true,
                        ),
                      ),
                    );
                    onStatsChanged();
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
