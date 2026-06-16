import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_by_veld/logic/hint_engine.dart';
import 'package:sudoku_by_veld/logic/strategy_technique.dart';
import 'package:sudoku_by_veld/models/sudoku_cell.dart';

void main() {
  test('returns applicable hints with most basic first', () {
    final cells = List.generate(
      9,
      (_) => List.generate(9, (_) => const SudokuCell(value: 0)),
    );

    for (var col = 0; col < 8; col++) {
      cells[0][col] = SudokuCell(value: col + 1, isGiven: true);
    }
    for (var row = 1; row < 9; row++) {
      cells[row][8] = SudokuCell(value: row, isGiven: true);
    }

    final hints = HintEngine.findApplicableHints(cells);
    expect(hints, isNotEmpty);
    expect(hints.first.kind, StrategyTechnique.nakedSingle);
    expect(hints.first.placement?.value, 9);
    expect(hints.first.placement?.cell.row, 0);
    expect(hints.first.placement?.cell.col, 8);
  });
}
