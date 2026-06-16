import 'strategy_diagram.dart';

const fieldNotes = <FieldNote>[
  FieldNote(
    title: 'Naked Single',
    body:
        'When only one digit can fit in a cell, place it. The other candidates were ruled out by givens in its row, column, and box.',
    caption:
        'Sage border: the cell with a single candidate left. Brown tint: its row, column, and box.',
    gridSize: 4,
    focusDigit: 1,
    cells: [
      [
        const DiagramCellData(
          role: DiagramCellRole.primary,
          notes: {1},
        ),
        const DiagramCellData(value: 2, role: DiagramCellRole.house),
        const DiagramCellData(value: 3, role: DiagramCellRole.house),
        const DiagramCellData(value: 4, role: DiagramCellRole.house),
      ],
      [
        const DiagramCellData(value: 4, role: DiagramCellRole.house),
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 2),
      ],
      [
        const DiagramCellData(value: 2, role: DiagramCellRole.house),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 3),
      ],
      [
        const DiagramCellData(value: 3, role: DiagramCellRole.house),
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 1),
      ],
    ],
  ),
  FieldNote(
    title: 'Hidden Single',
    body:
        'A digit may be the only one that can go in a cell — even when that cell still shows other pencil marks. Scan each row, column, and box for a digit that appears in only one cell.',
    caption:
        'Red circle: the hidden single 2. Sage border: the only cell in the row where it can go.',
    gridSize: 4,
    focusDigit: 2,
    cells: [
      [
        const DiagramCellData(value: 1, role: DiagramCellRole.house),
        const DiagramCellData(
          notes: {2, 3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        const DiagramCellData(value: 4, role: DiagramCellRole.house),
        const DiagramCellData(notes: {3, 4}, role: DiagramCellRole.house),
      ],
      [
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 2),
      ],
      [
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 1),
      ],
      [
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 4),
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
        const DiagramCellData(
          notes: {2, 3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        const DiagramCellData(
          notes: {2, 3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        const DiagramCellData(
          notes: {1, 3},
          role: DiagramCellRole.eliminated,
          showFocusDigit: true,
        ),
        const DiagramCellData(value: 4),
      ],
      [
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 2),
      ],
      [
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 1),
      ],
      [
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 3),
      ],
    ],
  ),
  FieldNote(
    title: 'Box-Line Reduction',
    body:
        'The flip side: if every candidate for a digit in a row or column lies inside one box, remove that digit from the other empty cells in the box.',
    caption:
        'Red circles: every possible position for 3 in column 0 sits in the top-left box. 3 cannot be in the other cell in that box. Crossed red circle: 3 removed from the other cell in that box.',
    gridSize: 4,
    focusDigit: 3,
    cells: [
      [
        const DiagramCellData(
          notes: {3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        const DiagramCellData(
          notes: {2, 3},
          role: DiagramCellRole.eliminated,
          showFocusDigit: true,
        ),
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 1),
      ],
      [
        const DiagramCellData(
          notes: {3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        const DiagramCellData(value: 4),
        const DiagramCellData(),
        const DiagramCellData(),
      ],
      [
        const DiagramCellData(value: 4, role: DiagramCellRole.house),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 3),
      ],
      [
        const DiagramCellData(value: 1, role: DiagramCellRole.house),
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 2),
      ],
    ],
  ),
];
