import 'package:flutter/material.dart';

import '../../models/cell_position.dart';
import '../../theme/veld_colors.dart';

enum TutorialStep {
  welcome,
  fillGrid,
  onePerRow,
  onePerColumnBox,
  tapCell,
  enterDigit,
  seeHighlights,
  pencilMode,
  mistake,
  done,
}

class TutorialStepData {
  const TutorialStepData({
    required this.step,
    required this.title,
    required this.message,
    this.targetCell,
    this.expectedDigit,
    this.requirePencil = false,
  });

  final TutorialStep step;
  final String title;
  final String message;
  final CellPosition? targetCell;
  final int? expectedDigit;
  final bool requirePencil;
}

const tutorialSteps = [
  TutorialStepData(
    step: TutorialStep.welcome,
    title: 'Welcome to the veld',
    message:
        'A quick coached round — tap cells, place numbers, and learn the feel. Skip anytime.',
  ),
  TutorialStepData(
    step: TutorialStep.fillGrid,
    title: 'Fill the grid',
    message:
        'Every row, column, and 3×3 box must contain the digits 1 through 9.',
  ),
  TutorialStepData(
    step: TutorialStep.onePerRow,
    title: 'One per row',
    message:
        'Each horizontal row has exactly one of each digit — no repeats.',
  ),
  TutorialStepData(
    step: TutorialStep.onePerColumnBox,
    title: 'One per column & box',
    message:
        'Same rule for every column and every thicker-outlined 3×3 box.',
  ),
  TutorialStepData(
    step: TutorialStep.tapCell,
    title: 'Choose a cell',
    message: 'Tap the highlighted empty cell to select it.',
    targetCell: CellPosition(0, 2),
  ),
  TutorialStepData(
    step: TutorialStep.enterDigit,
    title: 'Place a number',
    message: 'The number pad is below. Tap 4 to fill the cell.',
    targetCell: CellPosition(0, 2),
    expectedDigit: 4,
  ),
  TutorialStepData(
    step: TutorialStep.seeHighlights,
    title: 'Read the grid',
    message:
        'Tap the 7 in the top row. Its row, column, and box light up — and every other 7 joins in.',
    targetCell: CellPosition(0, 4),
  ),
  TutorialStepData(
    step: TutorialStep.pencilMode,
    title: 'Pencil marks',
    message:
        'Turn on Pencil, select the empty cell below the 6, then tap 2 and 4 for small notes.',
    targetCell: CellPosition(1, 1),
    requirePencil: true,
  ),
  TutorialStepData(
    step: TutorialStep.mistake,
    title: 'Mistakes turn red',
    message:
        'Turn Pencil off, select the empty cell at the start of row three, and try 2 — wrong digits go red.',
    targetCell: CellPosition(2, 0),
    expectedDigit: 2,
  ),
  TutorialStepData(
    step: TutorialStep.done,
    title: 'You are ready',
    message: 'That is the rhythm. Pick any difficulty on the home screen when you are ready.',
  ),
];

TutorialStepData dataForStep(TutorialStep step) {
  return tutorialSteps.firstWhere((item) => item.step == step);
}

class TutorialCoach extends StatelessWidget {
  const TutorialCoach({
    super.key,
    required this.data,
    required this.onSkip,
    required this.onNext,
    this.showNext = false,
  });

  final TutorialStepData data;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final bool showNext;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: VeldColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(data.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(data.message, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(onPressed: onSkip, child: const Text('Skip')),
                const Spacer(),
                if (showNext)
                  FilledButton(onPressed: onNext, child: const Text('Next')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
