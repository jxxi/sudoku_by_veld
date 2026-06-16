import '../../models/game_state.dart';

/// Digits where all nine cells are correctly placed per the puzzle solution.
abstract final class CompletedDigits {
  static Set<int> onBoard(GameState state) {
    final counts = List.filled(10, 0);
    final solution = state.puzzle.solution;

    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        final cell = state.cells[row][col];
        if (cell.isEmpty || cell.isWrong) continue;

        final index = row * 9 + col;
        final expected = int.parse(solution[index]);
        if (cell.value == expected) {
          counts[cell.value]++;
        }
      }
    }

    return {
      for (var digit = 1; digit <= 9; digit++)
        if (counts[digit] == 9) digit,
    };
  }
}
