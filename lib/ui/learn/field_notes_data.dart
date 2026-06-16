import 'strategy_diagram.dart';

const fieldNotes = <FieldNote>[
  FieldNote(
    title: 'Naked Single',
    body:
        'When a cell has only one possible candidate left, place that digit. Scan empty cells and their row, column, and box.',
    caption: 'Sage cell: only one digit fits. Lighter sage: its house.',
    gridSize: 4,
    focusDigit: 1,
    cells: [
      [
        DiagramCellData(role: DiagramCellRole.primary, notes: {1}),
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 4),
      ],
      [
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 2),
      ],
      [
        const DiagramCellData(value: 2, role: DiagramCellRole.secondary),
        const DiagramCellData(value: 1, role: DiagramCellRole.secondary),
        const DiagramCellData(value: 4, role: DiagramCellRole.secondary),
        const DiagramCellData(value: 3, role: DiagramCellRole.secondary),
      ],
      [
        const DiagramCellData(value: 3, role: DiagramCellRole.secondary),
        const DiagramCellData(value: 4, role: DiagramCellRole.secondary),
        DiagramCellData(notes: {2}, role: DiagramCellRole.secondary),
        const DiagramCellData(value: 1, role: DiagramCellRole.secondary),
      ],
    ],
  ),
  FieldNote(
    title: 'Hidden Single',
    body:
        'A digit can only fit in one cell within a row, column, or box — even if that cell still shows multiple pencil marks.',
    caption: 'Bold 2 in notes: the hidden digit. Sage cell: where it must go.',
    gridSize: 4,
    focusDigit: 2,
    cells: [
      [
        const DiagramCellData(value: 1),
        DiagramCellData(
          notes: {2, 3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 4),
      ],
      [
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 2, role: DiagramCellRole.secondary),
        const DiagramCellData(value: 3, role: DiagramCellRole.secondary),
      ],
      [
        const DiagramCellData(value: 3, role: DiagramCellRole.secondary),
        const DiagramCellData(value: 2, role: DiagramCellRole.secondary),
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 1),
      ],
      [
        const DiagramCellData(value: 2, role: DiagramCellRole.secondary),
        const DiagramCellData(value: 4, role: DiagramCellRole.secondary),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 3),
      ],
    ],
  ),
  FieldNote(
    title: 'Pointing Pairs',
    body:
        'When a digit is confined to one row or column inside a box, you can eliminate that digit from the same line outside the box.',
    caption: 'Ochre box: digit 3 locked to the top row. Red notes: eliminated.',
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
          notes: {3},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 2),
      ],
      [
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 1),
      ],
      [
        DiagramCellData(
          notes: {3, 4},
          role: DiagramCellRole.eliminated,
          showFocusDigit: true,
        ),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 4),
      ],
      [
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 3),
      ],
    ],
  ),
  FieldNote(
    title: 'Box-Line Reduction',
    body:
        'The mirror of pointing pairs: when a digit in a row or column only appears inside one box, eliminate it from the rest of that box.',
    caption: 'Column locks 4 to one box. Red notes: removed from the rest of the box.',
    gridSize: 4,
    focusDigit: 4,
    cells: [
      [
        const DiagramCellData(value: 1),
        DiagramCellData(
          notes: {4},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 3),
      ],
      [
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 2),
        DiagramCellData(
          notes: {4, 1},
          role: DiagramCellRole.eliminated,
          showFocusDigit: true,
        ),
        const DiagramCellData(value: 1),
      ],
      [
        const DiagramCellData(value: 2),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 3),
        DiagramCellData(
          notes: {4},
          role: DiagramCellRole.primary,
          showFocusDigit: true,
        ),
      ],
      [
        const DiagramCellData(value: 4),
        const DiagramCellData(value: 3),
        const DiagramCellData(value: 1),
        const DiagramCellData(value: 2),
      ],
    ],
  ),
];
