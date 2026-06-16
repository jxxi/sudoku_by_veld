class SudokuCell {
  SudokuCell({
    required this.value,
    required this.isGiven,
    Set<int>? notes,
    this.isWrong = false,
  }) : notes = notes ?? <int>{};

  final int value;
  final bool isGiven;
  final Set<int> notes;
  final bool isWrong;

  bool get isEmpty => value == 0;

  SudokuCell copyWith({
    int? value,
    bool? isGiven,
    Set<int>? notes,
    bool? isWrong,
    bool clearNotes = false,
  }) {
    return SudokuCell(
      value: value ?? this.value,
      isGiven: isGiven ?? this.isGiven,
      notes: clearNotes ? <int>{} : (notes ?? this.notes),
      isWrong: isWrong ?? this.isWrong,
    );
  }
}
