import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_by_veld/logic/candidate_grid.dart';
import 'package:sudoku_by_veld/logic/game_controller.dart';
import 'package:sudoku_by_veld/models/cell_position.dart';
import 'package:sudoku_by_veld/models/game_state.dart';
import 'package:sudoku_by_veld/ui/tutorial/tutorial_puzzle.dart';

void main() {
  late GameController controller;

  setUp(() {
    controller = GameController(GameState.fromPuzzle(TutorialPuzzle.build()));
    controller.selectCell(const CellPosition(0, 2));
  });

  test('applyReveal selects the revealed cell', () {
    controller.applyReveal(const CellPosition(1, 1), 7);

    expect(controller.state.selected, const CellPosition(1, 1));
    expect(controller.state.cells[1][1].value, 7);
    expect(controller.state.cells[1][1].isWrong, isFalse);
  });

  test('wrong committed digit is marked incorrect', () {
    controller.inputDigit(9);

    expect(controller.state.cells[0][2].value, 9);
    expect(controller.state.cells[0][2].isWrong, isTrue);
  });

  test('pencil mode toggles notes without committing a value', () {
    controller.togglePencilMode();
    controller.inputDigit(4);
    controller.inputDigit(7);

    final cell = controller.state.cells[0][2];
    expect(cell.value, 0);
    expect(cell.notes, {4, 7});
  });

  test('clearSelected removes a committed wrong digit', () {
    controller.inputDigit(9);
    controller.clearSelected();

    expect(controller.state.cells[0][2].value, 0);
    expect(controller.state.cells[0][2].isWrong, isFalse);
  });

  group('CandidateGrid', () {
    test('empty cell candidates exclude values in row, column, and box', () {
      final board = List.generate(
        9,
        (row) => List.generate(9, (col) {
          if (row == 0 && col < 8) return col + 1;
          if (col == 8 && row > 0) return row;
          return 0;
        }),
      );

      final candidates = CandidateGrid.fromBoard(board);
      expect(candidates[0][8], {9});
    });
  });
}
