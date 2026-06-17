import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_by_veld/logic/hint_engine.dart';
import 'package:sudoku_by_veld/models/sudoku_cell.dart';

List<List<SudokuCell>> _nakedSingleBoard() {
  final cells = List.generate(
    9,
    (_) => List.generate(9, (_) => SudokuCell(value: 0, isGiven: false)),
  );

  for (var col = 0; col < 8; col++) {
    cells[0][col] = SudokuCell(value: col + 1, isGiven: true);
  }
  for (var row = 1; row < 9; row++) {
    cells[row][8] = SudokuCell(value: row, isGiven: true);
  }

  return cells;
}

void main() {
  test('returns applicable hints with most basic first', () {
    final cells = _nakedSingleBoard();

    final hints = HintEngine.findApplicableHints(cells);
    expect(hints, isNotEmpty);
    expect(hints.first.kind, StrategyTechnique.nakedSingle);
    expect(hints.first.placement?.value, 9);
    expect(hints.first.placement?.cell.row, 0);
    expect(hints.first.placement?.cell.col, 8);
  });

  test('findStrategyHint returns only the most basic applicable hint', () {
    final cells = _nakedSingleBoard();

    final hint = HintEngine.findStrategyHint(cells);
    final all = HintEngine.findApplicableHints(cells);

    expect(hint, isNotNull);
    expect(hint!.kind, StrategyTechnique.nakedSingle);
    expect(all.first.kind, hint.kind);
    expect(all.length, greaterThanOrEqualTo(1));
  });
}
