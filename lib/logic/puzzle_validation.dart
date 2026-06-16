/// Shared checks for curated puzzle data and generator output.
abstract final class PuzzleValidation {
  static String digitsOnly(String raw) => raw.replaceAll(RegExp(r'\D'), '');

  static String? validate({
    required String id,
    required String givens,
    required String solution,
  }) {
    final g = digitsOnly(givens);
    final s = digitsOnly(solution);

    if (g.length != 81) {
      return '$id: givens must be 81 digits (got ${g.length})';
    }
    if (s.length != 81) {
      return '$id: solution must be 81 digits (got ${s.length})';
    }
    if (!isDigitGrid(g) || !isDigitGrid(s)) {
      return '$id: givens and solution must contain only 0-9';
    }
    if (!givensMatchSolution(g, s)) {
      return '$id: givens conflict with solution at clue cells';
    }
    if (!isSolvedGrid(s)) {
      return '$id: solution is not a valid completed Sudoku';
    }
    return null;
  }

  static bool isDigitGrid(String flat) {
    if (flat.length != 81) return false;
    for (var i = 0; i < 81; i++) {
      final code = flat.codeUnitAt(i);
      if (code < 48 || code > 57) return false;
    }
    return true;
  }

  static bool givensMatchSolution(String givens, String solution) {
    for (var i = 0; i < 81; i++) {
      final given = givens.codeUnitAt(i) - 48;
      final solved = solution.codeUnitAt(i) - 48;
      if (given != 0 && given != solved) return false;
    }
    return true;
  }

  static bool isSolvedGrid(String solution) {
    if (!isDigitGrid(solution)) return false;
    for (var i = 0; i < 81; i++) {
      if (solution.codeUnitAt(i) == 48) return false;
    }
    return _hasValidSudokuPlacement(solution);
  }

  static bool _hasValidSudokuPlacement(String flat) {
    for (var unit = 0; unit < 9; unit++) {
      final seen = List.filled(10, false);
      for (var i = 0; i < 9; i++) {
        final index = _unitIndex(unit, i);
        final digit = flat.codeUnitAt(index) - 48;
        if (digit < 1 || digit > 9 || seen[digit]) return false;
        seen[digit] = true;
      }
    }
    return true;
  }

  /// unit 0-8 = rows, 9-17 = cols, 18-26 = boxes
  static int _unitIndex(int unit, int offset) {
    if (unit < 9) {
      return unit * 9 + offset;
    }
    if (unit < 18) {
      final col = unit - 9;
      return offset * 9 + col;
    }
    final box = unit - 18;
    final boxRow = box ~/ 3;
    final boxCol = box % 3;
    final row = boxRow * 3 + offset ~/ 3;
    final col = boxCol * 3 + offset % 3;
    return row * 9 + col;
  }
}
