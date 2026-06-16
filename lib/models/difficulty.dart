enum Difficulty {
  easy('Easy'),
  medium('Medium'),
  hard('Hard'),
  expert('Expert'),
  diabolical('Diabolical');

  const Difficulty(this.label);

  final String label;

  static Difficulty fromKey(String key) {
    return Difficulty.values.firstWhere(
      (d) => d.name == key,
      orElse: () => Difficulty.easy,
    );
  }
}
