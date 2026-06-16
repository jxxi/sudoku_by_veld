import '../models/cell_position.dart';
import 'candidate_grid.dart';
import 'strategy_technique.dart';

typedef Board = List<List<int>>;
typedef Candidates = List<List<Set<int>>>;

List<CellPosition> rowCells(int row) =>
    [for (var col = 0; col < 9; col++) CellPosition(row, col)];

List<CellPosition> colCells(int col) =>
    [for (var row = 0; row < 9; row++) CellPosition(row, col)];

List<CellPosition> boxCells(int box) {
  final boxRow = (box ~/ 3) * 3;
  final boxCol = (box % 3) * 3;
  return [
    for (var row = boxRow; row < boxRow + 3; row++)
      for (var col = boxCol; col < boxCol + 3; col++)
        CellPosition(row, col),
  ];
}

List<CellPosition> houseCells(int row, int col) {
  final cells = <CellPosition>{};
  cells.addAll(rowCells(row));
  cells.addAll(colCells(col));
  final boxRow = (row ~/ 3) * 3;
  final boxCol = (col ~/ 3) * 3;
  cells.addAll([
    for (var r = boxRow; r < boxRow + 3; r++)
      for (var c = boxCol; c < boxCol + 3; c++)
        CellPosition(r, c),
  ]);
  return cells.toList();
}

bool sharesHouse(CellPosition a, CellPosition b) {
  return a.row == b.row ||
      a.col == b.col ||
      (a.boxRow == b.boxRow && a.boxCol == b.boxCol);
}

bool sees(CellPosition a, CellPosition b) {
  if (a == b) return false;
  return sharesHouse(a, b);
}

List<CellPosition> emptyInUnit(
  Board board,
  List<CellPosition> unit,
) {
  return [
    for (final pos in unit)
      if (board[pos.row][pos.col] == 0) pos,
  ];
}

List<StrategyHint> findNakedSingles(Candidates candidates) {
  final hints = <StrategyHint>[];
  for (var row = 0; row < 9; row++) {
    for (var col = 0; col < 9; col++) {
      final options = candidates[row][col];
      if (options.length != 1) continue;
      final value = options.first;
      hints.add(
        StrategyHint(
          kind: StrategyTechnique.nakedSingle,
          explanation:
              'This cell can only be $value — every other number is ruled out by its row, column, and box.',
          primaryCells: [CellPosition(row, col)],
          secondaryCells: houseCells(row, col),
          placement: (cell: CellPosition(row, col), value: value),
        ),
      );
    }
  }
  return hints;
}

List<StrategyHint> findHiddenSingles(Board board, Candidates candidates) {
  final hints = <StrategyHint>[];

  for (var row = 0; row < 9; row++) {
    for (var digit = 1; digit <= 9; digit++) {
      final target = _soleCandidateInUnit(board, candidates, rowCells(row), digit);
      if (target != null) {
        hints.add(
          StrategyHint(
            kind: StrategyTechnique.hiddenSingle,
            explanation:
                'In this row, $digit can only go in one cell — it is hidden among other candidates.',
            primaryCells: [target],
            secondaryCells: rowCells(target.row),
            placement: (cell: target, value: digit),
          ),
        );
      }
    }
  }

  for (var col = 0; col < 9; col++) {
    for (var digit = 1; digit <= 9; digit++) {
      final target = _soleCandidateInUnit(board, candidates, colCells(col), digit);
      if (target != null) {
        hints.add(
          StrategyHint(
            kind: StrategyTechnique.hiddenSingle,
            explanation:
                'In this column, $digit can only go in one cell — look where the column meets its box.',
            primaryCells: [target],
            secondaryCells: colCells(target.col),
            placement: (cell: target, value: digit),
          ),
        );
      }
    }
  }

  for (var box = 0; box < 9; box++) {
    for (var digit = 1; digit <= 9; digit++) {
      final unit = boxCells(box);
      final target = _soleCandidateInUnit(board, candidates, unit, digit);
      if (target != null) {
        hints.add(
          StrategyHint(
            kind: StrategyTechnique.hiddenSingle,
            explanation:
                'In this box, $digit can only fit in one spot even though the cell may show other pencil marks.',
            primaryCells: [target],
            secondaryCells: unit,
            placement: (cell: target, value: digit),
          ),
        );
      }
    }
  }

  return hints;
}

CellPosition? _soleCandidateInUnit(
  Board board,
  Candidates candidates,
  List<CellPosition> unit,
  int digit,
) {
  CellPosition? target;
  for (final pos in unit) {
    if (board[pos.row][pos.col] != 0) continue;
    if (!candidates[pos.row][pos.col].contains(digit)) continue;
    if (target != null) return null;
    target = pos;
  }
  return target;
}

List<StrategyHint> findNakedPairs(Board board, Candidates candidates) {
  final hints = <StrategyHint>[];
  final units = <List<CellPosition>>[
    for (var i = 0; i < 9; i++) ...[rowCells(i), colCells(i), boxCells(i)],
  ];

  for (final unit in units) {
    final empties = emptyInUnit(board, unit);
    for (var i = 0; i < empties.length; i++) {
      for (var j = i + 1; j < empties.length; j++) {
        final a = empties[i];
        final b = empties[j];
        final ca = candidates[a.row][a.col];
        final cb = candidates[b.row][b.col];
        if (ca.length != 2 || ca.length != cb.length || ca != cb) continue;

        final digits = ca.toList()..sort();
        hints.add(
          StrategyHint(
            kind: StrategyTechnique.nakedPair,
            explanation:
                'These two cells share exactly {${digits[0]}, ${digits[1]}} — remove those digits from every other cell in the unit.',
            primaryCells: [a, b],
            secondaryCells: [
              for (final pos in unit)
                if (pos != a && pos != b) pos,
            ],
          ),
        );
      }
    }
  }
  return hints;
}

List<StrategyHint> findHiddenPairs(Board board, Candidates candidates) {
  final hints = <StrategyHint>[];
  final units = <List<CellPosition>>[
    for (var i = 0; i < 9; i++) ...[rowCells(i), colCells(i), boxCells(i)],
  ];

  for (final unit in units) {
    final empties = emptyInUnit(board, unit);
    for (var d1 = 1; d1 <= 8; d1++) {
      for (var d2 = d1 + 1; d2 <= 9; d2++) {
        final cellsForD1 = <CellPosition>[];
        final cellsForD2 = <CellPosition>[];
        for (final pos in empties) {
          final c = candidates[pos.row][pos.col];
          if (c.contains(d1)) cellsForD1.add(pos);
          if (c.contains(d2)) cellsForD2.add(pos);
        }
        final union = {...cellsForD1, ...cellsForD2};
        if (union.length != 2) continue;

        final pair = union.toList();
        final notes = candidates[pair[0].row][pair[0].col];
        if (!notes.contains(d1) || !notes.contains(d2)) continue;

        hints.add(
          StrategyHint(
            kind: StrategyTechnique.hiddenPair,
            explanation:
                'Digits $d1 and $d2 can only appear in these two cells — remove any other pencil marks from them.',
            primaryCells: pair,
            secondaryCells: [
              for (final pos in unit)
                if (!union.contains(pos)) pos,
            ],
          ),
        );
      }
    }
  }
  return hints;
}

List<StrategyHint> findPointing(Board board, Candidates candidates) {
  final hints = <StrategyHint>[];

  for (var box = 0; box < 9; box++) {
    final unit = boxCells(box);
    for (var digit = 1; digit <= 9; digit++) {
      final cells = <CellPosition>[];
      for (final pos in unit) {
        if (board[pos.row][pos.col] != 0) continue;
        if (candidates[pos.row][pos.col].contains(digit)) {
          cells.add(pos);
        }
      }
      if (cells.length < 2 || cells.length > 3) continue;

      final sameRow = cells.every((pos) => pos.row == cells.first.row);
      final sameCol = cells.every((pos) => pos.col == cells.first.col);
      if (!sameRow && !sameCol) continue;

      final kind = cells.length == 2
          ? StrategyTechnique.pointingPair
          : StrategyTechnique.pointingTriple;
      final lineCells = sameRow
          ? rowCells(cells.first.row)
          : colCells(cells.first.col);
      final eliminations = [
        for (final pos in lineCells)
          if (!unit.contains(pos) &&
              board[pos.row][pos.col] == 0 &&
              candidates[pos.row][pos.col].contains(digit))
            pos,
      ];
      if (eliminations.isEmpty) continue;

      hints.add(
        StrategyHint(
          kind: kind,
          explanation:
              'Every $digit in this box sits on one ${sameRow ? 'row' : 'column'} — remove $digit from the rest of that line outside the box.',
          primaryCells: cells,
          secondaryCells: eliminations,
        ),
      );
    }
  }
  return hints;
}

List<StrategyHint> findBoxLineReductions(Board board, Candidates candidates) {
  final hints = <StrategyHint>[];

  for (var row = 0; row < 9; row++) {
  for (var digit = 1; digit <= 9; digit++) {
      final hint = _boxLineInLine(
        board,
        candidates,
        rowCells(row),
        digit,
        isRow: true,
      );
      if (hint != null) hints.add(hint);
    }
  }

  for (var col = 0; col < 9; col++) {
    for (var digit = 1; digit <= 9; digit++) {
      final hint = _boxLineInLine(
        board,
        candidates,
        colCells(col),
        digit,
        isRow: false,
      );
      if (hint != null) hints.add(hint);
    }
  }

  return hints;
}

StrategyHint? _boxLineInLine(
  Board board,
  Candidates candidates,
  List<CellPosition> line,
  int digit, {
  required bool isRow,
}) {
  final cells = <CellPosition>[];
  for (final pos in line) {
    if (board[pos.row][pos.col] != 0) continue;
    if (candidates[pos.row][pos.col].contains(digit)) cells.add(pos);
  }
  if (cells.isEmpty) return null;

  final boxRow = cells.first.row ~/ 3;
  final boxCol = cells.first.col ~/ 3;
  final sameBox = cells.every(
    (pos) => pos.row ~/ 3 == boxRow && pos.col ~/ 3 == boxCol,
  );
  if (!sameBox) return null;

  final box = boxCells(boxRow * 3 + boxCol);
  final eliminations = <CellPosition>[];
  for (final pos in box) {
    if (line.contains(pos)) continue;
    if (board[pos.row][pos.col] != 0) continue;
    if (candidates[pos.row][pos.col].contains(digit)) {
      eliminations.add(pos);
    }
  }
  if (eliminations.isEmpty) return null;

  return StrategyHint(
    kind: StrategyTechnique.boxLineReduction,
    explanation:
        'Every $digit in this ${isRow ? 'row' : 'column'} lies in one box — remove $digit from the other cells in that box.',
    primaryCells: cells,
    secondaryCells: eliminations,
  );
}

List<StrategyHint> findFish(
  Board board,
  Candidates candidates,
  int lineCount,
  StrategyTechnique kind,
) {
  final hints = <StrategyHint>[];

  for (var digit = 1; digit <= 9; digit++) {
    final rowMap = <int, Set<int>>{};
    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        if (board[row][col] != 0) continue;
        if (!candidates[row][col].contains(digit)) continue;
        rowMap.putIfAbsent(row, () => {}).add(col);
      }
    }

    final rows = rowMap.entries
        .where((entry) => entry.value.length >= 2 && entry.value.length <= lineCount)
        .toList();
    if (rows.length < lineCount) continue;

    for (final combo in _combinations(rows.length, lineCount)) {
      final cols = <int>{};
      var valid = true;
      for (final index in combo) {
        cols.addAll(rows[index].value);
        if (cols.length > lineCount) {
          valid = false;
          break;
        }
      }
      if (!valid || cols.length != lineCount) continue;

      final primary = <CellPosition>[];
      for (final index in combo) {
        final row = rows[index].key;
        for (final col in cols) {
          if (candidates[row][col].contains(digit)) {
            primary.add(CellPosition(row, col));
          }
        }
      }

      final eliminations = <CellPosition>[];
      for (final col in cols) {
        for (var row = 0; row < 9; row++) {
          if (combo.any((i) => rows[i].key == row)) continue;
          if (board[row][col] != 0) continue;
          if (candidates[row][col].contains(digit)) {
            eliminations.add(CellPosition(row, col));
          }
        }
      }
      if (eliminations.isEmpty) continue;

      hints.add(
        StrategyHint(
          kind: kind,
          explanation: lineCount == 2
              ? 'Digit $digit lines up on two rows and two columns — an X-Wing. Remove $digit from the rest of those columns.'
              : 'Digit $digit lines up on three rows and three columns — a Swordfish. Remove $digit from the rest of those columns.',
          primaryCells: primary,
          secondaryCells: eliminations,
        ),
      );
    }
  }

  return hints;
}

List<List<int>> _combinations(int n, int k) {
  final result = <List<int>>[];
  void choose(List<int> current, int start) {
    if (current.length == k) {
      result.add(List<int>.from(current));
      return;
    }
    for (var i = start; i < n; i++) {
      current.add(i);
      choose(current, i + 1);
      current.removeLast();
    }
  }

  choose([], 0);
  return result;
}

List<StrategyHint> findYWings(Candidates candidates, Board board) {
  final hints = <StrategyHint>[];
  final bivalue = <CellPosition>[];
  for (var row = 0; row < 9; row++) {
    for (var col = 0; col < 9; col++) {
      if (board[row][col] != 0) continue;
      if (candidates[row][col].length == 2) {
        bivalue.add(CellPosition(row, col));
      }
    }
  }

  for (final pivot in bivalue) {
    final pivotVals = candidates[pivot.row][pivot.col].toList()..sort();
    final a = pivotVals[0];
    final b = pivotVals[1];

    for (final wing1 in bivalue) {
      if (wing1 == pivot || !sees(pivot, wing1)) continue;
      final w1 = candidates[wing1.row][wing1.col].toList()..sort();
      if (w1.length != 2) continue;

      int? z;
      int? otherPivot;
      if (w1.contains(a) && !w1.contains(b)) {
        z = w1.firstWhere((d) => d != a);
        otherPivot = b;
      } else if (w1.contains(b) && !w1.contains(a)) {
        z = w1.firstWhere((d) => d != b);
        otherPivot = a;
      } else {
        continue;
      }

      for (final wing2 in bivalue) {
        if (wing2 == pivot || wing2 == wing1 || !sees(pivot, wing2)) continue;
        final w2 = candidates[wing2.row][wing2.col].toList()..sort();
        if (w2.length != 2) continue;
        if (!w2.contains(otherPivot!) || !w2.contains(z)) continue;

        final eliminations = <CellPosition>[];
        for (var row = 0; row < 9; row++) {
          for (var col = 0; col < 9; col++) {
            final pos = CellPosition(row, col);
            if (board[row][col] != 0) continue;
            if (!candidates[row][col].contains(z)) continue;
            if (pos == pivot || pos == wing1 || pos == wing2) continue;
            if (sees(pos, wing1) && sees(pos, wing2)) {
              eliminations.add(pos);
            }
          }
        }
        if (eliminations.isEmpty) continue;

        hints.add(
          StrategyHint(
            kind: StrategyTechnique.yWing,
            explanation:
                'Y-Wing: pivot {$a,$b} with wings sharing $z — remove $z from cells that see both wings.',
            primaryCells: [pivot, wing1, wing2],
            secondaryCells: eliminations,
          ),
        );
      }
    }
  }
  return hints;
}

List<StrategyHint> findXyzWings(Candidates candidates, Board board) {
  final hints = <StrategyHint>[];

  for (var row = 0; row < 9; row++) {
    for (var col = 0; col < 9; col++) {
      if (board[row][col] != 0) continue;
      final pivotNotes = candidates[row][col];
      if (pivotNotes.length != 3) continue;
      final pivot = CellPosition(row, col);
      final vals = pivotNotes.toList()..sort();

      for (var zi = 0; zi < vals.length; zi++) {
        final z = vals[zi];
        final others = [for (var i = 0; i < vals.length; i++) if (i != zi) vals[i]];
        final x = others[0];
        final y = others[1];

        for (var r = 0; r < 9; r++) {
          for (var c = 0; c < 9; c++) {
            if (board[r][c] != 0) continue;
            final wing1 = CellPosition(r, c);
            if (wing1 == pivot || !sees(pivot, wing1)) continue;
            final w1 = candidates[r][c];
            if (w1.length != 2 || !w1.contains(y) || !w1.contains(z)) continue;

            for (var r2 = 0; r2 < 9; r2++) {
              for (var c2 = 0; c2 < 9; c2++) {
                if (board[r2][c2] != 0) continue;
                final wing2 = CellPosition(r2, c2);
                if (wing2 == pivot || wing2 == wing1 || !sees(pivot, wing2)) {
                  continue;
                }
                final w2 = candidates[r2][c2];
                if (w2.length != 2 || !w2.contains(x) || !w2.contains(z)) {
                  continue;
                }

                final eliminations = <CellPosition>[];
                for (var er = 0; er < 9; er++) {
                  for (var ec = 0; ec < 9; ec++) {
                    final pos = CellPosition(er, ec);
                    if (board[er][ec] != 0) continue;
                    if (!candidates[er][ec].contains(z)) continue;
                    if (pos == pivot || pos == wing1 || pos == wing2) continue;
                    if (sees(pos, pivot) && sees(pos, wing1) && sees(pos, wing2)) {
                      eliminations.add(pos);
                    }
                  }
                }
                if (eliminations.isEmpty) continue;

                hints.add(
                  StrategyHint(
                    kind: StrategyTechnique.xyzWing,
                    explanation:
                        'XYZ-Wing: pivot {$x,$y,$z} with wings {$y,$z} and {$x,$z} — remove $z where all three meet.',
                    primaryCells: [pivot, wing1, wing2],
                    secondaryCells: eliminations,
                  ),
                );
              }
            }
          }
        }
      }
    }
  }
  return hints;
}

List<StrategyHint> findSimpleColoring(Board board, Candidates candidates) {
  final hints = <StrategyHint>[];

  for (var digit = 1; digit <= 9; digit++) {
    final graph = <CellPosition, List<CellPosition>>{};
    void link(CellPosition a, CellPosition b) {
      graph.putIfAbsent(a, () => []).add(b);
      graph.putIfAbsent(b, () => []).add(a);
    }

    for (var row = 0; row < 9; row++) {
      final cells = <CellPosition>[];
      for (var col = 0; col < 9; col++) {
        if (board[row][col] == 0 && candidates[row][col].contains(digit)) {
          cells.add(CellPosition(row, col));
        }
      }
      if (cells.length == 2) link(cells[0], cells[1]);
    }

    for (var col = 0; col < 9; col++) {
      final cells = <CellPosition>[];
      for (var row = 0; row < 9; row++) {
        if (board[row][col] == 0 && candidates[row][col].contains(digit)) {
          cells.add(CellPosition(row, col));
        }
      }
      if (cells.length == 2) link(cells[0], cells[1]);
    }

    for (var box = 0; box < 9; box++) {
      final cells = <CellPosition>[];
      for (final pos in boxCells(box)) {
        if (board[pos.row][pos.col] == 0 &&
            candidates[pos.row][pos.col].contains(digit)) {
          cells.add(pos);
        }
      }
      if (cells.length == 2) link(cells[0], cells[1]);
    }

    if (graph.isEmpty) continue;

    final colors = <CellPosition, int>{};
    for (final start in graph.keys) {
      if (colors.containsKey(start)) continue;
      colors[start] = 0;
      final queue = [start];
      while (queue.isNotEmpty) {
        final node = queue.removeAt(0);
        for (final neighbor in graph[node]!) {
          final nextColor = colors[node]! == 0 ? 1 : 0;
          final existing = colors[neighbor];
          if (existing == null) {
            colors[neighbor] = nextColor;
            queue.add(neighbor);
          } else if (existing == colors[node]) {
            hints.add(
              StrategyHint(
                kind: StrategyTechnique.simpleColoring,
                explanation:
                    'Simple coloring on $digit: two linked cells share the same color — remove $digit from any cell seeing both.',
                primaryCells: [node, neighbor],
                secondaryCells: [
                  for (var row = 0; row < 9; row++)
                    for (var col = 0; col < 9; col++)
                      if (board[row][col] == 0 &&
                          candidates[row][col].contains(digit))
                        CellPosition(row, col),
                ],
              ),
            );
            return hints;
          }
        }
      }
    }
  }
  return hints;
}

List<StrategyHint> findUniqueRectangles(Board board, Candidates candidates) {
  final hints = <StrategyHint>[];

  for (var d1 = 1; d1 <= 8; d1++) {
    for (var d2 = d1 + 1; d2 <= 9; d2++) {
      for (var rowA = 0; rowA < 8; rowA++) {
        for (var rowB = rowA + 1; rowB < 9; rowB++) {
          for (var colA = 0; colA < 8; colA++) {
            for (var colB = colA + 1; colB < 9; colB++) {
              final corners = [
                CellPosition(rowA, colA),
                CellPosition(rowA, colB),
                CellPosition(rowB, colA),
                CellPosition(rowB, colB),
              ];
              if (!_uniqueRectangleShape(corners)) continue;

              final notes = [
                for (final pos in corners)
                  candidates[pos.row][pos.col],
              ];
              if (notes.any((set) => set.isEmpty)) continue;

              var pairOnly = 0;
              CellPosition? extraCorner;
              int? extraDigit;
              for (var i = 0; i < 4; i++) {
                final n = notes[i];
                if (n.length == 2 && n.contains(d1) && n.contains(d2)) {
                  pairOnly++;
                } else if (n.length == 3 && n.contains(d1) && n.contains(d2)) {
                  extraCorner = corners[i];
                  extraDigit = n.firstWhere((d) => d != d1 && d != d2);
                }
              }
              if (pairOnly != 3 || extraCorner == null || extraDigit == null) {
                continue;
              }

              hints.add(
                StrategyHint(
                  kind: StrategyTechnique.uniqueRectangle,
                  explanation:
                      'Unique rectangle on {$d1,$d2}: the fourth corner cannot keep $extraDigit without a deadly pattern — remove it.',
                  primaryCells: corners,
                  secondaryCells: [extraCorner],
                ),
              );
            }
          }
        }
      }
    }
  }
  return hints;
}

bool _uniqueRectangleShape(List<CellPosition> corners) {
  final boxes = corners.map((p) => (p.boxRow, p.boxCol)).toSet();
  final rows = corners.map((p) => p.row).toSet();
  final cols = corners.map((p) => p.col).toSet();
  return boxes.length == 2 && rows.length == 2 && cols.length == 2;
}

class StrategyHint {
  const StrategyHint({
    required this.kind,
    required this.explanation,
    required this.primaryCells,
    required this.secondaryCells,
    this.placement,
  });

  final StrategyTechnique kind;
  final String explanation;
  final List<CellPosition> primaryCells;
  final List<CellPosition> secondaryCells;
  final ({CellPosition cell, int value})? placement;

  String get technique => kind.label;
}
