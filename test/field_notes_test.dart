import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_by_veld/ui/learn/field_notes_data.dart';

void main() {
  test('field notes are in teaching order with valid grids', () {
    expect(fieldNotes.length, 13);

    final titles = fieldNotes.map((note) => note.title).toList();
    expect(titles, [
      'Naked Single',
      'Hidden Single',
      'Naked Pair',
      'Hidden Pair',
      'Pointing Pairs',
      'Pointing Triples',
      'Box-Line Reduction',
      'X-Wing',
      'Swordfish',
      'Y-Wing',
      'XYZ-Wing',
      'Simple Coloring',
      'Unique Rectangle',
    ]);

    for (final note in fieldNotes) {
      expect(note.cells.length, note.gridSize);
      for (final row in note.cells) {
        expect(row.length, note.gridSize);
      }
    }
  });
}
