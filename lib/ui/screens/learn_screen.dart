import 'package:flutter/material.dart';

import '../../storage/stats_store.dart';
import '../../theme/veld_colors.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key, required this.statsStore});

  final StatsStore statsStore;

  static const _strategies = [
    (
      title: 'Naked Single',
      body:
          'When a cell has only one possible candidate left, place that digit. Scan empty cells and their row, column, and box.',
    ),
    (
      title: 'Hidden Single',
      body:
          'A digit can only fit in one cell within a row, column, or box — even if that cell still shows multiple pencil marks.',
    ),
    (
      title: 'Pointing Pairs',
      body:
          'When a digit is confined to one row or column inside a box, you can eliminate that digit from the same line outside the box.',
    ),
    (
      title: 'Box-Line Reduction',
      body:
          'The mirror of pointing pairs: when a digit in a row or column only appears inside one box, eliminate it from the rest of that box.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Learn'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Walkthrough'),
              Tab(text: 'Field Notes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _WalkthroughTab(statsStore: statsStore),
            _FieldNotesTab(),
          ],
        ),
      ),
    );
  }
}

class _WalkthroughTab extends StatelessWidget {
  const _WalkthroughTab({required this.statsStore});

  final StatsStore statsStore;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Guided walkthrough',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'A short coached first game: tap cells, place numbers, try pencil mode, and see mistakes turn red. Skip anytime.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Interactive tutorial overlay — coming next.'),
              ),
            );
          },
          child: const Text('Start walkthrough'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () async {
            await statsStore.setTutorialCompleted(true);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tutorial skipped for now.')),
            );
          },
          child: const Text('Skip'),
        ),
        if (statsStore.tutorialCompleted) ...[
          const SizedBox(height: 8),
          Text(
            'You can replay the walkthrough anytime from Settings.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

class _FieldNotesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: LearnScreen._strategies.length,
      itemBuilder: (context, index) {
        final item = LearnScreen._strategies[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(item.body, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 12),
                Text(
                  'Diagram puzzles coming soon.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: VeldColors.inkMuted,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
