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
  SavedGameSummary? _savedSummary;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybePromptTutorial());
    _refreshSavedSummary();
  }

  void _refreshSavedSummary() {
    setState(() {
      _savedSummary = widget.gameStore.hasSavedGame
          ? widget.gameStore.peekSummary()
          : null;
    });
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
    _refreshSavedSummary();
  }

  Future<void> _discardSavedGame() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard saved game?'),
        content: const Text(
          'Your in-progress puzzle will be removed. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await widget.gameStore.clear();
    _refreshSavedSummary();
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.statsStore.loadStats();

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
              _refreshSavedSummary();
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
            if (_savedSummary != null) ...[
              SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    FilledButton(
                      onPressed: () => _openGame(resumed: true),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Continue game'),
                          const SizedBox(height: 2),
                          Text(
                            '${_savedSummary!.difficulty.label} · ${formatElapsed(_savedSummary!.elapsedSeconds)}',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        tooltip: 'Discard saved game',
                        onPressed: _discardSavedGame,
                        visualDensity: VisualDensity.compact,
                        color: Theme.of(context).colorScheme.onPrimary,
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                  ],
                ),
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
