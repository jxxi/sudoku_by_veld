import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_by_veld/models/difficulty.dart';
import 'package:sudoku_by_veld/storage/stats_store.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('settings default to timer and mistake feedback on', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = StatsStore(prefs);

    expect(store.showTimerDuringGame, isTrue);
    expect(store.showMistakeFeedback, isTrue);
    expect(store.tutorialCompleted, isFalse);
  });

  test('recordWin tracks best time and completion count', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = StatsStore(prefs);

    await store.recordWin(Difficulty.easy, 300);
    await store.recordWin(Difficulty.easy, 240);
    await store.recordWin(Difficulty.easy, 360);

    final stats = store.loadStats()[Difficulty.easy]!;
    expect(stats.completed, 3);
    expect(stats.bestSeconds, 240);
  });

  test('settings persist when toggled', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = StatsStore(prefs);

    await store.setShowTimerDuringGame(false);
    await store.setShowMistakeFeedback(false);
    await store.setTutorialCompleted(true);

    expect(store.showTimerDuringGame, isFalse);
    expect(store.showMistakeFeedback, isFalse);
    expect(store.tutorialCompleted, isTrue);
  });

  test('puzzle index advances per difficulty', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = StatsStore(prefs);

    expect(store.puzzleIndex(Difficulty.hard), 0);
    await store.setPuzzleIndex(Difficulty.hard, 4);
    expect(store.puzzleIndex(Difficulty.hard), 4);
  });
}
