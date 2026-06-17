import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_by_veld/logic/sudoku_validator.dart';
import 'package:sudoku_by_veld/models/cell_position.dart';
import 'package:sudoku_by_veld/models/sudoku_cell.dart';
import 'package:sudoku_by_veld/ui/tutorial/tutorial_puzzle.dart';

void main() {
  final puzzle = TutorialPuzzle.build();
  final solution = puzzle.solution;

  List<List<SudokuCell>> solvedCells() {
    return List.generate(9, (row) {
      return List.generate(9, (col) {
        final index = row * 9 + col;
        return SudokuCell(
          value: int.parse(solution[index]),
          isGiven: true,
        );
      });
    });
  }

  test('isSolved is true only for a full correct grid', () {
    expect(SudokuValidator.isSolved(solvedCells(), solution), isTrue);

    final wrong = solvedCells();
    wrong[0][0] = SudokuCell(value: 9, isGiven: false);
    expect(SudokuValidator.isSolved(wrong, solution), isFalse);
  });

  test('applyMistakes flags only wrong user entries', () {
    final cells = solvedCells();
    cells[0][2] = SudokuCell(value: 9, isGiven: false);

    final validated = SudokuValidator.applyMistakes(cells, solution);

    expect(validated[0][2].isWrong, isTrue);
    expect(validated[0][0].isWrong, isFalse);
  });

  test('hasConflict detects duplicate in row', () {
    final cells = solvedCells();
    expect(
      SudokuValidator.hasConflict(
        cells,
        const CellPosition(0, 2),
        int.parse(solution[0]),
      ),
      isTrue,
    );
  });
}
