class CellPosition {
  const CellPosition(this.row, this.col);

  final int row;
  final int col;

  int get boxRow => row ~/ 3;
  int get boxCol => col ~/ 3;

  @override
  bool operator ==(Object other) {
    return other is CellPosition && other.row == row && other.col == col;
  }

  @override
  int get hashCode => Object.hash(row, col);
}
