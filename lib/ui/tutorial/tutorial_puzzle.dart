import '../../models/difficulty.dart';
import '../../models/puzzle.dart';

/// Fixed puzzle for the guided walkthrough — independent of the curated pack.
abstract final class TutorialPuzzle {
  static const solution =
      '534678912672195348198342567859761423426853791713924856961537284287419635345286179';

  static const emptyIndices = [2, 10, 18]; // (0,2), (1,1), (2,0)

  static String get givens {
    final chars = solution.split('');
    for (final index in emptyIndices) {
      chars[index] = '0';
    }
    return chars.join();
  }

  static Puzzle build() {
    return Puzzle(
      id: 'tutorial',
      difficulty: Difficulty.easy,
      givens: givens,
      solution: solution,
    );
  }
}
