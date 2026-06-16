# Sudoku by Veld

Earthy Sudoku for Android and iOS — built with Flutter.

## First-time setup

Flutter was not available in the automated dev environment. On your machine:

```powershell
cd C:\Users\Jasmine\Projects\sudoku_by_veld

# Generate android/, ios/, etc. (keeps existing lib/ and pubspec.yaml)
flutter create . --org com.veld --project-name sudoku_by_veld

flutter pub get
flutter run
```

If `flutter` is not recognized, install the SDK from https://docs.flutter.dev/get-started/install/windows and add `flutter\bin` to your PATH.

## Validate puzzles (run before commit / in CI)

```powershell
flutter test
```

`test/puzzle_pack_test.dart` loads every puzzle in `assets/puzzles/puzzles.json` and checks:

- exactly **81 digits** in givens and solution
- givens **match** solution at clue cells
- solution is a **legal completed Sudoku**

After regenerating packs:

```powershell
dart run tool/generate_puzzles.dart 25
flutter test
```

Standalone validator (same rules, no Flutter test runner):

```powershell
dart run tool/validate_puzzles.dart
```

## Generate puzzle packs

```powershell
# 200 puzzles per difficulty tier (~1000 total). Takes several minutes.
dart run tool/generate_puzzles.dart 200

# Smaller dev set:
dart run tool/generate_puzzles.dart 20
```

## Store prep

See `docs/STORE_LISTING.md` and `docs/PRIVACY_POLICY.md`.

## What's included

- **Veld theme** — sand, sage, ochre palette
- **Home** — Continue game, New game, Learn, per-difficulty stats
- **5 difficulties** — Easy, Medium, Hard, Expert, Diabolical (all unlocked)
- **Grid** — sage selected cell, row/column/box highlight, same-number highlight, red mistake digits
- **Hints** — Strategy (naked/hidden single) or Reveal cell; unlimited
- **Learn** — Interactive walkthrough + Field Notes with 4×4 strategy diagrams
- **Save/resume** — in-progress puzzles persist locally
- **Settings** — timer visibility toggle, replay tutorial, tip jar
- **Haptics** — light feedback on input; celebration on complete
- **Curated puzzles** — rotating packs (`dart run tool/generate_puzzles.dart`)

## Next up

- App icon + splash assets
- Host privacy policy URL
- TestFlight / internal testing → store submit

## Tip jar product ID

`veld_tip_jar` — non-consumable, suggested price $2.99–3.99
