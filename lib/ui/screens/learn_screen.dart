import 'package:flutter/material.dart';

import '../../storage/stats_store.dart';
import '../learn/field_notes_data.dart';
import '../learn/strategy_diagram.dart';
import 'tutorial_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key, required this.statsStore});

  final StatsStore statsStore;

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
            const _FieldNotesTab(),
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TutorialScreen(statsStore: statsStore),
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
  const _FieldNotesTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: fieldNotes.length,
      itemBuilder: (context, index) {
        final note = fieldNotes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(note.body, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                StrategyDiagram(note: note),
              ],
            ),
          ),
        );
      },
    );
  }
}
