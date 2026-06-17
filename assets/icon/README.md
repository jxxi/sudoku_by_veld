# App icon

Master icon: `app_icon.png` (1024×1024) — partial sudoku grid matching the home screen preview.

Regenerate platform icons after editing the master:

```bash
dart run flutter_launcher_icons
```

Regenerate the master PNG from code (same givens as home screen):

```bash
dart run tool/generate_app_icon.dart
dart run flutter_launcher_icons
```
