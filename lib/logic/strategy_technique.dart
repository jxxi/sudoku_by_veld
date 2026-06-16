/// Teaching order for strategy hints — lower priority = more basic.
enum StrategyTechnique {
  nakedSingle(0, 'Naked Single'),
  hiddenSingle(1, 'Hidden Single'),
  nakedPair(2, 'Naked Pair'),
  hiddenPair(3, 'Hidden Pair'),
  pointingPair(4, 'Pointing Pairs'),
  pointingTriple(5, 'Pointing Triples'),
  boxLineReduction(6, 'Box-Line Reduction'),
  xWing(7, 'X-Wing'),
  swordfish(8, 'Swordfish'),
  yWing(9, 'Y-Wing'),
  xyzWing(10, 'XYZ-Wing'),
  simpleColoring(11, 'Simple Coloring'),
  uniqueRectangle(12, 'Unique Rectangle');

  const StrategyTechnique(this.priority, this.label);

  final int priority;
  final String label;
}
