import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'storage/stats_store.dart';
import 'theme/veld_theme.dart';
import 'ui/screens/home_screen.dart';

class SudokuByVeldApp extends StatefulWidget {
  const SudokuByVeldApp({super.key, required this.statsStore});

  final StatsStore statsStore;

  @override
  State<SudokuByVeldApp> createState() => _SudokuByVeldAppState();
}

class _SudokuByVeldAppState extends State<SudokuByVeldApp> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku by Veld',
      debugShowCheckedModeBanner: false,
      theme: VeldTheme.light(),
      home: HomeScreen(
        statsStore: widget.statsStore,
        onStatsChanged: _refresh,
      ),
    );
  }
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final statsStore = StatsStore(prefs);
  runApp(SudokuByVeldApp(statsStore: statsStore));
}
