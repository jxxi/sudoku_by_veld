import 'strategy_diagram.dart';

List<List<DiagramCellData>> _emptyGrid(int size) {
  return List.generate(
    size,
    (_) => List.filled(size, const DiagramCellData(), growable: false),
  );
}

void _set(
  List<List<DiagramCellData>> grid,
  int row,
  int col,
  DiagramCellData cell,
) {
  grid[row][col] = cell;
}

const _basicFieldNotes = <FieldNote>[
  FieldNote(
    title: 'Naked Single',
    body:
        'When only one digit can still fit in a cell, place it. The other candidates were ruled out by givens in its row, column, and box.',
    caption:
        'Sage border: the cell with a single candidate left. Brown tint: its row, column, and box.',
    gridSize: 4,
    focusDigit: 1,
    cells: [
      [
        DiagramCellData(role: DiagramCellRole.primary, notes: {1}),
        DiagramCellData(value: 2, role: DiagramCellRole.house),
        DiagramCellData(value: 3, role: DiagramCellRole.house),
        DiagramCellData(value: 4, role: DiagramCellRole.house),
      ],
      [
        DiagramCellData(value: 4, role: DiagramCellRole.house),
        DiagramCellData(value: 3),
        DiagramCellData(value: 1),
        DiagramCellData(value: 2),
      ],
      [
        DiagramCellData(value: 2, role: DiagramCellRole.house),
        DiagramCellData(value: 1),
        DiagramCellData(value: 4),
        DiagramCellData(value: 3),
      ],
      [
        DiagramCellData(value: 3, role: DiagramCellRole.house),
        DiagramCellData(value: 4),
        DiagramCellData(value: 2),
        DiagramCellData(value: 1),
      ],
    ],
  ),
  FieldNote(
    title: 'Hidden Single',
    body:
        'A digit may be the only one that can go in a cell — even when that cell still shows other pencil marks. Scan each row, column, and box for a digit that appears in only one cell.',
    caption:
        'Red circle: the hidden digit in pencil marks. Sage border: the only cell in the row where it can go.',
    gridSize: 4,
    focusDigit: 2,
    cells: [
      [
        DiagramCellData(value: 1, role: DiagramCellRole.house),
        DiagramCellData(
          notes: {2, 3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        DiagramCellData(value: 4, role: DiagramCellRole.house),
        DiagramCellData(notes: {3, 4}, role: DiagramCellRole.house),
      ],
      [
        DiagramCellData(value: 4),
        DiagramCellData(value: 3),
        DiagramCellData(value: 1),
        DiagramCellData(value: 2),
      ],
      [
        DiagramCellData(value: 3),
        DiagramCellData(value: 2),
        DiagramCellData(value: 4),
        DiagramCellData(value: 1),
      ],
      [
        DiagramCellData(value: 2),
        DiagramCellData(value: 1),
        DiagramCellData(value: 3),
        DiagramCellData(value: 4),
      ],
    ],
  ),
  FieldNote(
    title: 'Naked Pair',
    body:
        'Two cells in the same row, column, or box share exactly the same two candidates. Those digits cannot appear anywhere else in that unit.',
    caption:
        'Sage borders: the pair sharing {2, 3}. Crossed red circles: 2 and 3 removed from the rest of the row.',
    gridSize: 4,
    cells: [
      [
        DiagramCellData(
          notes: {2, 3},
          role: DiagramCellRole.primary,
          circledNotes: {2, 3},
        ),
        DiagramCellData(
          notes: {2, 3},
          role: DiagramCellRole.primary,
          circledNotes: {2, 3},
        ),
        DiagramCellData(
          notes: {1, 2, 3},
          role: DiagramCellRole.eliminated,
          struckNotes: {2, 3},
        ),
        DiagramCellData(value: 4),
      ],
      [
        DiagramCellData(value: 4),
        DiagramCellData(value: 3),
        DiagramCellData(value: 1),
        DiagramCellData(value: 2),
      ],
      [
        DiagramCellData(value: 2),
        DiagramCellData(value: 1),
        DiagramCellData(value: 4),
        DiagramCellData(value: 3),
      ],
      [
        DiagramCellData(value: 3),
        DiagramCellData(value: 4),
        DiagramCellData(value: 2),
        DiagramCellData(value: 1),
      ],
    ],
  ),
  FieldNote(
    title: 'Hidden Pair',
    body:
        'Two digits can only appear in two cells within a row, column, or box. Strip every other pencil mark from those two cells.',
    caption:
        'Red circles: digits 2 and 3 are confined to two cells. Crossed marks: other candidates removed from those cells.',
    gridSize: 4,
    cells: [
      [
        DiagramCellData(
          notes: {1, 2, 3},
          role: DiagramCellRole.primary,
          circledNotes: {2, 3},
          struckNotes: {1},
        ),
        DiagramCellData(
          notes: {2, 3, 4},
          role: DiagramCellRole.primary,
          circledNotes: {2, 3},
          struckNotes: {4},
        ),
        DiagramCellData(value: 4, role: DiagramCellRole.house),
        DiagramCellData(value: 1, role: DiagramCellRole.house),
      ],
      [
        DiagramCellData(value: 2, role: DiagramCellRole.house),
        DiagramCellData(value: 4),
        DiagramCellData(value: 1),
        DiagramCellData(value: 3),
      ],
      [
        DiagramCellData(value: 1),
        DiagramCellData(value: 3),
        DiagramCellData(value: 2),
        DiagramCellData(value: 4),
      ],
      [
        DiagramCellData(value: 4),
        DiagramCellData(value: 2),
        DiagramCellData(value: 3),
        DiagramCellData(value: 1),
      ],
    ],
  ),
  FieldNote(
    title: 'Pointing Pairs',
    body:
        'Inside a box, if every candidate for a digit sits on the same row (or column), that digit cannot appear on the rest of that row outside the box.',
    caption:
        'Red circles: 3 is locked to the top row of the box. Crossed red circle: 3 removed from the rest of the row.',
    gridSize: 4,
    focusDigit: 3,
    cells: [
      [
        DiagramCellData(
          notes: {2, 3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        DiagramCellData(
          notes: {2, 3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        DiagramCellData(
          notes: {1, 3},
          role: DiagramCellRole.eliminated,
          showFocusDigit: true,
        ),
        DiagramCellData(value: 4),
      ],
      [
        DiagramCellData(value: 4),
        DiagramCellData(value: 1),
        DiagramCellData(value: 3),
        DiagramCellData(value: 2),
      ],
      [
        DiagramCellData(value: 3),
        DiagramCellData(value: 4),
        DiagramCellData(value: 2),
        DiagramCellData(value: 1),
      ],
      [
        DiagramCellData(value: 1),
        DiagramCellData(value: 2),
        DiagramCellData(value: 4),
        DiagramCellData(value: 3),
      ],
    ],
  ),
  FieldNote(
    title: 'Box-Line Reduction',
    body:
        'The flip side: if every candidate for a digit in a row or column lies inside one box, remove that digit from the other empty cells in the box.',
    caption:
        'Red circles: every possible position for 3 in column 0 sits in the top-left box. Crossed red circle: 3 removed from the other cell in that box.',
    gridSize: 4,
    focusDigit: 3,
    cells: [
      [
        DiagramCellData(
          notes: {3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        DiagramCellData(
          notes: {2, 3},
          role: DiagramCellRole.eliminated,
          showFocusDigit: true,
        ),
        DiagramCellData(value: 2),
        DiagramCellData(value: 1),
      ],
      [
        DiagramCellData(
          notes: {3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        DiagramCellData(value: 4),
        DiagramCellData(),
        DiagramCellData(),
      ],
      [
        DiagramCellData(value: 4, role: DiagramCellRole.house),
        DiagramCellData(value: 1),
        DiagramCellData(value: 2),
        DiagramCellData(value: 3),
      ],
      [
        DiagramCellData(value: 1, role: DiagramCellRole.house),
        DiagramCellData(value: 3),
        DiagramCellData(value: 4),
        DiagramCellData(value: 2),
      ],
    ],
  ),
];

FieldNote _pointingTriplesNote() {
  final grid = _emptyGrid(9);
  for (var col = 0; col < 3; col++) {
    _set(
      grid,
      0,
      col,
      DiagramCellData(
        notes: {5},
        role: DiagramCellRole.primary,
        circledNotes: {5},
      ),
    );
  }
  _set(
    grid,
    0,
    4,
    const DiagramCellData(
      notes: {5, 8},
      role: DiagramCellRole.eliminated,
      struckNotes: {5},
    ),
  );
  _set(grid, 1, 0, const DiagramCellData(value: 7));
  _set(grid, 1, 1, const DiagramCellData(value: 2));
  _set(grid, 1, 2, const DiagramCellData(value: 9));
  _set(grid, 2, 0, const DiagramCellData(value: 4));
  _set(grid, 2, 1, const DiagramCellData(value: 1));
  _set(grid, 2, 2, const DiagramCellData(value: 6));
  return FieldNote(
    title: 'Pointing Triples',
    body:
        'Same idea as a pointing pair, but three cells in a box share a row or column — all candidates for that digit are confined to that line.',
    caption:
        'Red circles: every 5 in the box sits on the top row. Crossed red circle: 5 removed from the rest of the row.',
    gridSize: 9,
    focusDigit: 5,
    cells: grid,
  );
}

FieldNote _xWingNote() {
  final grid = _emptyGrid(9);
  const wing = DiagramCellData(
    notes: {7},
    role: DiagramCellRole.primary,
    circledNotes: {7},
  );
  _set(grid, 1, 2, wing);
  _set(grid, 1, 5, wing);
  _set(grid, 4, 2, wing);
  _set(grid, 4, 5, wing);

  for (final row in [0, 3, 6]) {
    _set(
      grid,
      row,
      2,
      const DiagramCellData(
        notes: {7, 9},
        role: DiagramCellRole.eliminated,
        struckNotes: {7},
      ),
    );
    _set(
      grid,
      row,
      5,
      const DiagramCellData(
        notes: {7, 1},
        role: DiagramCellRole.eliminated,
        struckNotes: {7},
      ),
    );
  }

  for (var col = 0; col < 9; col++) {
    if (col == 2 || col == 5) continue;
    grid[1][col] = const DiagramCellData(role: DiagramCellRole.house);
    grid[4][col] = const DiagramCellData(role: DiagramCellRole.house);
  }

  return FieldNote(
    title: 'X-Wing',
    body:
        'A digit appears as a candidate in exactly two cells in two different rows, and those cells line up in the same two columns (or the row/column mirror). Eliminate that digit from the rest of those columns.',
    caption:
        'Red circles: 7 forms a rectangle across two rows and two columns. Crossed red circles: 7 removed from the rest of those columns.',
    gridSize: 9,
    focusDigit: 7,
    cells: grid,
  );
}

FieldNote _swordfishNote() {
  final grid = _emptyGrid(9);
  const mark = DiagramCellData(
    notes: {4},
    role: DiagramCellRole.primary,
    circledNotes: {4},
  );

  for (final row in [1, 4, 7]) {
    _set(grid, row, 2, mark);
    _set(grid, row, 5, mark);
    _set(grid, row, 8, mark);
  }

  for (final row in [0, 3, 6, 2, 5, 8]) {
    for (final col in [2, 5, 8]) {
      if (grid[row][col].notes.isEmpty && grid[row][col].value == null) {
        _set(
          grid,
          row,
          col,
          const DiagramCellData(
            notes: {4, 9},
            role: DiagramCellRole.eliminated,
            struckNotes: {4},
          ),
        );
      }
    }
  }

  return FieldNote(
    title: 'Swordfish',
    body:
        'An X-Wing scaled up: a digit occupies exactly three cells in three rows, all in the same three columns. Eliminate that digit from every other cell in those columns.',
    caption:
        'Red circles: 4 lines up on three rows and three columns. Crossed red circles: 4 removed elsewhere in those columns.',
    gridSize: 9,
    focusDigit: 4,
    cells: grid,
  );
}

FieldNote _yWingNote() {
  final grid = _emptyGrid(9);
  _set(
    grid,
    1,
    1,
    const DiagramCellData(
      notes: {2, 3},
      role: DiagramCellRole.primary,
      circledNotes: {2, 3},
    ),
  );
  _set(
    grid,
    1,
    4,
    const DiagramCellData(
      notes: {3, 5},
      role: DiagramCellRole.primary,
      circledNotes: {3, 5},
    ),
  );
  _set(
    grid,
    4,
    1,
    const DiagramCellData(
      notes: {2, 5},
      role: DiagramCellRole.primary,
      circledNotes: {2, 5},
    ),
  );
  _set(
    grid,
    4,
    4,
    const DiagramCellData(
      notes: {5, 8},
      role: DiagramCellRole.eliminated,
      struckNotes: {5},
    ),
  );

  return FieldNote(
    title: 'Y-Wing',
    body:
        'Three bivalue cells form a Y: a pivot shares one digit with each wing, and the wings share the third digit. Any cell that sees both wings cannot contain that shared digit.',
    caption:
        'Sage cells: pivot {2,3} and wings {3,5} and {2,5}. Crossed red circle: 5 eliminated where both wings meet.',
    gridSize: 9,
    focusDigit: 5,
    cells: grid,
  );
}

FieldNote _xyzWingNote() {
  final grid = _emptyGrid(9);
  _set(
    grid,
    1,
    1,
    const DiagramCellData(
      notes: {2, 3, 5},
      role: DiagramCellRole.primary,
      circledNotes: {2, 3, 5},
    ),
  );
  _set(
    grid,
    1,
    4,
    const DiagramCellData(
      notes: {3, 5},
      role: DiagramCellRole.primary,
      circledNotes: {3, 5},
    ),
  );
  _set(
    grid,
    4,
    1,
    const DiagramCellData(
      notes: {2, 5},
      role: DiagramCellRole.primary,
      circledNotes: {2, 5},
    ),
  );
  _set(
    grid,
    4,
    4,
    const DiagramCellData(
      notes: {5, 8},
      role: DiagramCellRole.eliminated,
      struckNotes: {5},
    ),
  );

  return FieldNote(
    title: 'XYZ-Wing',
    body:
        'Like a Y-Wing, but the pivot holds all three digits {X,Y,Z}. The Z digit can be eliminated from any cell that sees the pivot and both wings.',
    caption:
        'Sage pivot {2,3,5} with wings {3,5} and {2,5}. Crossed red circle: 5 removed where all three meet.',
    gridSize: 9,
    focusDigit: 5,
    cells: grid,
  );
}

FieldNote _simpleColoringNote() {
  final grid = _emptyGrid(9);
  _set(grid, 0, 0, const DiagramCellData(value: 4));
  _set(
    grid,
    0,
    8,
    const DiagramCellData(
      notes: {4},
      role: DiagramCellRole.primary,
      circledNotes: {4},
    ),
  );
  _set(
    grid,
    8,
    0,
    const DiagramCellData(
      notes: {4},
      role: DiagramCellRole.primary,
      circledNotes: {4},
    ),
  );
  _set(
    grid,
    8,
    8,
    const DiagramCellData(
      notes: {4, 9},
      role: DiagramCellRole.eliminated,
      struckNotes: {4},
    ),
  );

  for (final row in [0, 8]) {
    for (var col = 1; col < 8; col++) {
      grid[row][col] = const DiagramCellData(role: DiagramCellRole.house);
    }
  }
  for (final col in [0, 8]) {
    for (var row = 1; row < 8; row++) {
      grid[row][col] = const DiagramCellData(role: DiagramCellRole.house);
    }
  }

  return FieldNote(
    title: 'Simple Coloring',
    body:
        'Follow one digit through conjugate pairs (only two candidates left in a unit). Color the chain; if two cells of the same color see each other, that color is impossible — eliminate that digit everywhere it appears in the chain.',
    caption:
        'Brown tint: conjugate chain for 4 along the edges. Crossed red circle: 4 removed where same-color cells meet.',
    gridSize: 9,
    focusDigit: 4,
    cells: grid,
  );
}

FieldNote _uniqueRectangleNote() {
  final grid = _emptyGrid(9);
  const pair = DiagramCellData(
    notes: {1, 2},
    role: DiagramCellRole.primary,
    circledNotes: {1, 2},
  );
  _set(grid, 1, 1, pair);
  _set(grid, 1, 5, pair);
  _set(grid, 4, 1, pair);
  _set(
    grid,
    4,
    5,
    const DiagramCellData(
      notes: {1, 2, 5},
      role: DiagramCellRole.eliminated,
      circledNotes: {1, 2, 5},
      struckNotes: {5},
    ),
  );

  for (final row in [1, 4]) {
    for (var col = 0; col < 9; col++) {
      if (col == 1 || col == 5) continue;
      grid[row][col] = const DiagramCellData(role: DiagramCellRole.house);
    }
  }

  return FieldNote(
    title: 'Unique Rectangle',
    body:
        'Four cells at the corners of a rectangle share two digits. If three corners are {1,2} and the fourth adds an extra candidate, that extra digit would force a deadly pattern — so eliminate it.',
    caption:
        'Red circles: three corners locked to {1,2}. Crossed red circle: 5 removed from the fourth corner.',
    gridSize: 9,
    focusDigit: 5,
    cells: grid,
  );
}

/// All Field Notes in teaching order.
final List<FieldNote> fieldNotes = [
  _basicFieldNotes[0], // Naked Single
  _basicFieldNotes[1], // Hidden Single
  _basicFieldNotes[2], // Naked Pair
  _basicFieldNotes[3], // Hidden Pair
  _basicFieldNotes[4], // Pointing Pairs
  _pointingTriplesNote(),
  _basicFieldNotes[5], // Box-Line Reduction
  _xWingNote(),
  _swordfishNote(),
  _yWingNote(),
  _xyzWingNote(),
  _simpleColoringNote(),
  _uniqueRectangleNote(),
];
