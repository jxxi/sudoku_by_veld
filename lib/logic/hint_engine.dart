import '../models/sudoku_cell.dart';
import 'candidate_grid.dart';
import 'hint_finders.dart';
import 'strategy_technique.dart';

export 'hint_finders.dart' show StrategyHint;
export 'strategy_technique.dart' show StrategyTechnique;

enum HintType { strategy, reveal }

abstract final class HintEngine {
  /// All technique types that apply right now, one example each, basic first.
  static List<StrategyHint> findApplicableHints(List<List<SudokuCell>> cells) {
    final board = boardFromCells(cells);
    final candidates = CandidateGrid.fromBoard(board);

    final all = <StrategyHint>[
      ...findNakedSingles(candidates),
      ...findHiddenSingles(board, candidates),
      ...findNakedPairs(board, candidates),
      ...findHiddenPairs(board, candidates),
      ...findPointing(board, candidates),
      ...findBoxLineReductions(board, candidates),
      ...findFish(board, candidates, 2, StrategyTechnique.xWing),
      ...findFish(board, candidates, 3, StrategyTechnique.swordfish),
      ...findYWings(candidates, board),
      ...findXyzWings(candidates, board),
      ...findSimpleColoring(board, candidates),
      ...findUniqueRectangles(board, candidates),
    ];

    all.sort((a, b) => a.kind.priority.compareTo(b.kind.priority));

    final seen = <StrategyTechnique>{};
    final result = <StrategyHint>[];
    for (final hint in all) {
      if (seen.add(hint.kind)) result.add(hint);
    }
    return result;
  }

  static StrategyHint? findStrategyHint(List<List<SudokuCell>> cells) {
    final hints = findApplicableHints(cells);
    return hints.isEmpty ? null : hints.first;
  }
}
