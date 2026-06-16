import 'package:flutter/material.dart';

import '../../storage/game_store.dart';
import '../../storage/stats_store.dart';
import '../../theme/veld_colors.dart';
import '../widgets/home_puzzle_preview.dart';
import '../widgets/stat_row.dart';
import 'difficulty_screen.dart';
import 'game_screen.dart';
import 'learn_screen.dart';
import 'settings_screen.dart';
import 'tutorial_screen.dart';
import '../../models/difficulty.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.statsStore,
    required this.gameStore,
    required this.onStatsChanged,
  });

  final StatsStore statsStore;
  final GameStore gameStore;
  final VoidCallback onStatsChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybePromptTutorial());
  }

  Future<void> _maybePromptTutorial() async {
    if (widget.statsStore.tutorialCompleted || !mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const SizedBox(
          width: double.infinity,
          child: Text(
            'First time here?',
            textAlign: TextAlign.center,
          ),
        ),
        content: const SizedBox(
          width: double.infinity,
          child: Text(
            'Take a 60-second walkthrough',
            textAlign: TextAlign.center,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () async {
              await widget.statsStore.setTutorialCompleted(true);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Skip'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _openTutorial();
            },
            child: const Text('Walkthrough'),
          ),
        ],
      ),
    );
  }

  Future<void> _openTutorial() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TutorialScreen(statsStore: widget.statsStore),
      ),
    );
    widget.onStatsChanged();
  }

  Future<void> _openGame({Difficulty? difficulty, bool resumed = false}) async {
    if (resumed) {
      final state = await widget.gameStore.load();
      if (state == null || !mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GameScreen(
            statsStore: widget.statsStore,
            gameStore: widget.gameStore,
            resumedState: state,
            onCompleted: widget.onStatsChanged,
          ),
        ),
      );
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GameScreen(
            difficulty: difficulty,
            statsStore: widget.statsStore,
            gameStore: widget.gameStore,
            onCompleted: widget.onStatsChanged,
          ),
        ),
      );
    }
    widget.onStatsChanged();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.statsStore.loadStats();
    final hasSave = widget.gameStore.hasSavedGame;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku by Veld'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    statsStore: widget.statsStore,
                    onOpenTutorial: _openTutorial,
                  ),
                ),
              );
              widget.onStatsChanged();
              setState(() {});
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
                  const SizedBox(height: 20),
                  const HomePuzzlePreview(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (hasSave) ...[
              FilledButton(
                onPressed: () => _openGame(resumed: true),
                child: const Text('Continue game'),
              ),
              const SizedBox(height: 12),
            ],
            FilledButton(
              onPressed: () async {
                final difficulty = await Navigator.of(context).push<Difficulty>(
                  MaterialPageRoute(builder: (_) => const DifficultyScreen()),
                );
                if (difficulty == null || !context.mounted) return;
                await _openGame(difficulty: difficulty);
              },
              child: const Text('New game'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LearnScreen(statsStore: widget.statsStore),
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
            if (!widget.statsStore.tipJarPurchased) ...[
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
                          statsStore: widget.statsStore,
                          openTipJar: true,
                          onOpenTutorial: _openTutorial,
                        ),
                      ),
                    );
                    widget.onStatsChanged();
                    setState(() {});
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
